/**
 * Advanced Search Features for Schnitzler Briefe
 * Provides faceted search, auto-complete, and intelligent query suggestions
 */

class AdvancedSearch {
    constructor(options = {}) {
        this.searchConfig = {
            apiUrl: options.apiUrl || '/api/search',
            typesenseConfig: options.typesense || {},
            maxResults: options.maxResults || 50,
            debounceDelay: options.debounceDelay || 300
        };
        
        this.searchState = {
            query: '',
            filters: new Map(),
            facets: new Map(),
            results: [],
            totalResults: 0,
            currentPage: 0,
            suggestions: []
        };
        
        this.ui = {
            searchInput: null,
            resultsContainer: null,
            filtersContainer: null,
            suggestionsContainer: null,
            facetsContainer: null
        };
        
        this.init();
    }
    
    init() {
        this.setupUI();
        this.setupEventListeners();
        this.loadSearchHistory();
        this.initializeFacets();
        
        // Load initial state from URL parameters
        this.loadStateFromURL();
    }
    
    setupUI() {
        // Main search input
        this.ui.searchInput = document.querySelector('#search-input') || 
                             document.querySelector('input[type="search"]');
        
        if (!this.ui.searchInput) {
            console.warn('Search input not found');
            return;
        }
        
        // Create advanced search interface
        this.createAdvancedSearchUI();
        
        // Results container
        this.ui.resultsContainer = document.querySelector('#search-results') ||
                                  this.createResultsContainer();
        
        // Filters container
        this.ui.filtersContainer = document.querySelector('#search-filters') ||
                                  this.createFiltersContainer();
        
        // Auto-complete suggestions
        this.ui.suggestionsContainer = this.createSuggestionsContainer();
    }
    
    createAdvancedSearchUI() {
        const searchContainer = this.ui.searchInput.parentElement;
        
        // Add search type selector
        const searchTypeSelector = document.createElement('div');
        searchTypeSelector.className = 'search-type-selector';
        searchTypeSelector.innerHTML = `
            <label class="search-type-label">Suchbereich:</label>
            <select id="search-type" class="form-select form-select-sm">
                <option value="all">Volltext</option>
                <option value="title">Nur Titel</option>
                <option value="persons">Nur Personen</option>
                <option value="places">Nur Orte</option>
                <option value="content">Nur Briefinhalt</option>
            </select>
        `;
        
        // Add advanced search toggle
        const advancedToggle = document.createElement('button');
        advancedToggle.type = 'button';
        advancedToggle.className = 'btn btn-outline-secondary btn-sm';
        advancedToggle.innerHTML = '⚙️ Erweiterte Suche';
        advancedToggle.addEventListener('click', () => this.toggleAdvancedSearch());
        
        searchContainer.appendChild(searchTypeSelector);
        searchContainer.appendChild(advancedToggle);
    }
    
    createResultsContainer() {
        const container = document.createElement('div');
        container.id = 'search-results';
        container.className = 'search-results';
        
        // Insert after search input or in main content area
        const insertAfter = document.querySelector('.search-container') || 
                           document.querySelector('main') ||
                           document.body;
        insertAfter.appendChild(container);
        
        return container;
    }
    
    createFiltersContainer() {
        const container = document.createElement('div');
        container.id = 'search-filters';
        container.className = 'search-filters';
        container.innerHTML = `
            <h3>Filter</h3>
            <div class="filter-section" id="date-filter">
                <h4>Zeitraum</h4>
                <div class="date-range">
                    <input type="number" id="year-from" placeholder="Von Jahr" min="1889" max="1931">
                    <input type="number" id="year-to" placeholder="Bis Jahr" min="1889" max="1931">
                </div>
            </div>
            <div class="filter-section" id="correspondent-filter">
                <h4>Korrespondenten</h4>
                <div class="filter-checkboxes" id="correspondent-checkboxes"></div>
            </div>
            <div class="filter-section" id="place-filter">
                <h4>Orte</h4>
                <div class="filter-checkboxes" id="place-checkboxes"></div>
            </div>
            <div class="filter-section" id="type-filter">
                <h4>Brieftyp</h4>
                <div class="filter-checkboxes">
                    <label><input type="checkbox" value="as-sender"> Von Schnitzler</label>
                    <label><input type="checkbox" value="as-empf"> An Schnitzler</label>
                    <label><input type="checkbox" value="umfeld"> Umfeldbriefe</label>
                </div>
            </div>
        `;
        
        this.ui.resultsContainer.before(container);
        return container;
    }
    
    createSuggestionsContainer() {
        const container = document.createElement('div');
        container.id = 'search-suggestions';
        container.className = 'search-suggestions';
        container.style.display = 'none';
        
        this.ui.searchInput.parentElement.appendChild(container);
        return container;
    }
    
    setupEventListeners() {
        // Search input with debouncing
        let searchTimeout;
        this.ui.searchInput.addEventListener('input', (e) => {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                this.handleSearchInput(e.target.value);
            }, this.searchConfig.debounceDelay);
        });
        
        // Auto-complete selection
        this.ui.searchInput.addEventListener('keydown', (e) => {
            this.handleKeyboardNavigation(e);
        });
        
        // Filter changes
        if (this.ui.filtersContainer) {
            this.ui.filtersContainer.addEventListener('change', (e) => {
                this.handleFilterChange(e);
            });
        }
        
        // Search form submission
        const searchForm = this.ui.searchInput.closest('form');
        if (searchForm) {
            searchForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.performSearch();
            });
        }
        
        // URL state management
        window.addEventListener('popstate', () => {
            this.loadStateFromURL();
        });
    }
    
    async handleSearchInput(query) {
        this.searchState.query = query;
        
        if (query.length < 2) {
            this.hideSuggestions();
            return;
        }
        
        try {
            // Get auto-complete suggestions
            const suggestions = await this.getAutoCompleteSuggestions(query);
            this.displaySuggestions(suggestions);
            
            // Perform search if query is substantial
            if (query.length >= 3) {
                await this.performSearch();
            }
            
        } catch (error) {
            console.error('Search error:', error);
            this.displayError('Fehler bei der Suche. Bitte versuchen Sie es erneut.');
        }
    }
    
    async getAutoCompleteSuggestions(query) {
        // Implement auto-complete logic
        // This would typically call your search API
        
        const suggestions = [];
        
        // Simple keyword suggestions (would be enhanced with real data)
        const keywords = ['Arthur Schnitzler', 'Brief', 'Wien', 'Theater', 'Literatur'];
        keywords.forEach(keyword => {
            if (keyword.toLowerCase().includes(query.toLowerCase())) {
                suggestions.push({
                    type: 'keyword',
                    text: keyword,
                    highlight: this.highlightQuery(keyword, query)
                });
            }
        });
        
        // Add person suggestions
        suggestions.push({
            type: 'person',
            text: 'Hugo von Hofmannsthal',
            highlight: 'Hugo von Hofmannsthal'
        });
        
        return suggestions.slice(0, 8); // Limit suggestions
    }
    
    displaySuggestions(suggestions) {
        if (!suggestions.length) {
            this.hideSuggestions();
            return;
        }
        
        const html = suggestions.map(suggestion => `
            <div class="suggestion-item" data-type="${suggestion.type}" data-text="${suggestion.text}">
                <span class="suggestion-icon">${this.getSuggestionIcon(suggestion.type)}</span>
                <span class="suggestion-text">${suggestion.highlight}</span>
            </div>
        `).join('');
        
        this.ui.suggestionsContainer.innerHTML = html;
        this.ui.suggestionsContainer.style.display = 'block';
        
        // Add click handlers for suggestions
        this.ui.suggestionsContainer.querySelectorAll('.suggestion-item').forEach(item => {
            item.addEventListener('click', () => {
                this.selectSuggestion(item.dataset.text);
            });
        });
    }
    
    hideSuggestions() {
        this.ui.suggestionsContainer.style.display = 'none';
    }
    
    selectSuggestion(text) {
        this.ui.searchInput.value = text;
        this.searchState.query = text;
        this.hideSuggestions();
        this.performSearch();
    }
    
    getSuggestionIcon(type) {
        const icons = {
            keyword: '🔍',
            person: '👤',
            place: '📍',
            work: '📚',
            date: '📅'
        };
        return icons[type] || '💭';
    }
    
    highlightQuery(text, query) {
        const regex = new RegExp(`(${query})`, 'gi');
        return text.replace(regex, '<mark>$1</mark>');
    }
    
    async performSearch() {
        if (!this.searchState.query.trim()) {
            this.clearResults();
            return;
        }
        
        this.showSearchLoading();
        
        try {
            const searchParams = this.buildSearchParams();
            const results = await this.executeSearch(searchParams);
            
            this.searchState.results = results.hits || [];
            this.searchState.totalResults = results.found || 0;
            this.searchState.facets = new Map(Object.entries(results.facet_counts || {}));
            
            this.displayResults();
            this.displayFacets();
            this.updateURL();
            this.saveSearchHistory();
            
        } catch (error) {
            console.error('Search execution error:', error);
            this.displayError('Fehler bei der Suchausführung.');
        } finally {
            this.hideSearchLoading();
        }
    }
    
    buildSearchParams() {
        const params = {
            q: this.searchState.query,
            query_by: this.getQueryFields(),
            facet_by: 'sender.label,receiver.label,places.label,year',
            max_facet_values: 20,
            per_page: this.searchConfig.maxResults,
            page: this.searchState.currentPage + 1
        };
        
        // Add filters
        const filterBy = [];
        for (const [key, values] of this.searchState.filters) {
            if (values.length > 0) {
                filterBy.push(`${key}:=[${values.join(',')}]`);
            }
        }
        
        if (filterBy.length > 0) {
            params.filter_by = filterBy.join(' && ');
        }
        
        return params;
    }
    
    getQueryFields() {
        const searchType = document.querySelector('#search-type')?.value || 'all';
        
        const fieldMappings = {
            all: 'title,full_text,accessible_title',
            title: 'title,accessible_title',
            persons: 'sender.label,receiver.label,persons.label',
            places: 'places.label',
            content: 'full_text'
        };
        
        return fieldMappings[searchType] || fieldMappings.all;
    }
    
    async executeSearch(params) {
        // This would interface with your actual search backend (Typesense, etc.)
        // For now, return mock data
        
        await new Promise(resolve => setTimeout(resolve, 500)); // Simulate API delay
        
        return {
            hits: [
                {
                    document: {
                        id: 'L00001',
                        title: 'Fedor Mamroth an Arthur Schnitzler, 2. 8. 1889',
                        accessible_title: 'Brief von Fedor Mamroth an Arthur Schnitzler vom 2. August 1889',
                        year: 1889,
                        sender: { label: 'Fedor Mamroth' },
                        receiver: { label: 'Arthur Schnitzler' }
                    },
                    highlights: {
                        title: { snippet: 'Fedor <mark>Mamroth</mark> an Arthur Schnitzler' }
                    }
                }
            ],
            found: 1,
            facet_counts: {
                'sender.label': {
                    counts: [
                        { value: 'Fedor Mamroth', count: 1 },
                        { value: 'Hugo von Hofmannsthal', count: 15 }
                    ]
                },
                year: {
                    counts: [
                        { value: '1889', count: 1 },
                        { value: '1890', count: 5 }
                    ]
                }
            }
        };
    }
    
    displayResults() {
        if (!this.searchState.results.length) {
            this.ui.resultsContainer.innerHTML = `
                <div class="no-results">
                    <h3>Keine Ergebnisse gefunden</h3>
                    <p>Für "${this.searchState.query}" wurden keine Briefe gefunden.</p>
                    <div class="search-suggestions">
                        <h4>Versuchen Sie:</h4>
                        <ul>
                            <li>Andere Suchbegriffe</li>
                            <li>Weniger spezifische Begriffe</li>
                            <li>Überprüfung der Rechtschreibung</li>
                        </ul>
                    </div>
                </div>
            `;
            return;
        }
        
        const resultsHtml = `
            <div class="search-results-header">
                <h2>Suchergebnisse</h2>
                <p>${this.searchState.totalResults} Treffer für "${this.searchState.query}"</p>
            </div>
            <div class="results-list">
                ${this.searchState.results.map(result => this.renderResultItem(result)).join('')}
            </div>
            ${this.renderPagination()}
        `;
        
        this.ui.resultsContainer.innerHTML = resultsHtml;
        this.setupResultsEventListeners();
    }
    
    renderResultItem(result) {
        const doc = result.document;
        const highlights = result.highlights || {};
        
        return `
            <article class="result-item" data-id="${doc.id}">
                <header class="result-header">
                    <h3 class="result-title">
                        <a href="${doc.id}.html">${this.getHighlightedText(highlights.title) || doc.title}</a>
                    </h3>
                    <div class="result-meta">
                        <span class="result-date">${doc.year}</span>
                        <span class="result-correspondent">
                            ${doc.sender?.label} → ${doc.receiver?.label}
                        </span>
                    </div>
                </header>
                <div class="result-content">
                    ${this.getHighlightedText(highlights.full_text) || this.truncateText(doc.full_text, 200)}
                </div>
                <footer class="result-actions">
                    <a href="${doc.id}.html" class="btn btn-primary">Brief lesen</a>
                    <button class="btn btn-outline-secondary" onclick="this.addToCollection('${doc.id}')">
                        Zur Sammlung hinzufügen
                    </button>
                </footer>
            </article>
        `;
    }
    
    getHighlightedText(highlight) {
        return highlight?.snippet || '';
    }
    
    truncateText(text, maxLength) {
        if (!text || text.length <= maxLength) return text || '';
        return text.substring(0, maxLength) + '...';
    }
    
    displayFacets() {
        // Update filter checkboxes based on facet data
        this.updateFacetCheckboxes('correspondent-checkboxes', this.searchState.facets.get('sender.label'));
        this.updateFacetCheckboxes('place-checkboxes', this.searchState.facets.get('places.label'));
    }
    
    updateFacetCheckboxes(containerId, facetData) {
        const container = document.getElementById(containerId);
        if (!container || !facetData) return;
        
        const checkboxes = facetData.counts.map(item => `
            <label class="facet-item">
                <input type="checkbox" value="${item.value}" ${this.isFilterActive(containerId, item.value) ? 'checked' : ''}>
                <span class="facet-label">${item.value}</span>
                <span class="facet-count">(${item.count})</span>
            </label>
        `).join('');
        
        container.innerHTML = checkboxes;
    }
    
    isFilterActive(containerId, value) {
        // Check if this filter value is currently active
        return false; // Implement actual logic
    }
    
    showSearchLoading() {
        if (this.ui.resultsContainer) {
            this.ui.resultsContainer.innerHTML = `
                <div class="search-loading">
                    <div class="spinner"></div>
                    <p>Suche läuft...</p>
                </div>
            `;
        }
    }
    
    hideSearchLoading() {
        // Loading is hidden when results are displayed
    }
    
    displayError(message) {
        if (this.ui.resultsContainer) {
            this.ui.resultsContainer.innerHTML = `
                <div class="search-error alert alert-danger">
                    <h3>Fehler</h3>
                    <p>${message}</p>
                </div>
            `;
        }
    }
    
    clearResults() {
        if (this.ui.resultsContainer) {
            this.ui.resultsContainer.innerHTML = '';
        }
    }
    
    // URL state management
    updateURL() {
        const params = new URLSearchParams();
        
        if (this.searchState.query) {
            params.set('q', this.searchState.query);
        }
        
        // Add filter parameters
        for (const [key, values] of this.searchState.filters) {
            if (values.length > 0) {
                params.set(key, values.join(','));
            }
        }
        
        const newURL = `${window.location.pathname}?${params.toString()}`;
        window.history.replaceState(null, '', newURL);
    }
    
    loadStateFromURL() {
        const params = new URLSearchParams(window.location.search);
        
        this.searchState.query = params.get('q') || '';
        if (this.ui.searchInput) {
            this.ui.searchInput.value = this.searchState.query;
        }
        
        // Load filters from URL
        // Implementation depends on your filter structure
        
        if (this.searchState.query) {
            this.performSearch();
        }
    }
    
    // Additional utility methods
    saveSearchHistory() {
        // Save search to localStorage for history/suggestions
        const history = JSON.parse(localStorage.getItem('schnitzler-search-history') || '[]');
        
        if (this.searchState.query && !history.includes(this.searchState.query)) {
            history.unshift(this.searchState.query);
            history.splice(10); // Keep only last 10 searches
            localStorage.setItem('schnitzler-search-history', JSON.stringify(history));
        }
    }
    
    loadSearchHistory() {
        // Load and display search history
        return JSON.parse(localStorage.getItem('schnitzler-search-history') || '[]');
    }
    
    toggleAdvancedSearch() {
        const filtersContainer = this.ui.filtersContainer;
        if (filtersContainer) {
            const isVisible = filtersContainer.style.display !== 'none';
            filtersContainer.style.display = isVisible ? 'none' : 'block';
        }
    }
}

// Initialize advanced search when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    if (document.querySelector('#search-input') || document.querySelector('input[type="search"]')) {
        window.advancedSearch = new AdvancedSearch({
            maxResults: 25,
            debounceDelay: 250
        });
    }
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AdvancedSearch;
}