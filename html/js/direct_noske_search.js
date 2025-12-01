// Direct Noske API implementation without external dependencies
class DirectNoskeSearch {
    constructor() {
        this.baseUrl = 'https://corpus-search.acdh.oeaw.ac.at/run.cgi/';
        this.corpname = 'schnitzlerbriefe';
        this.initialized = false;
    }

    init() {
        if (this.initialized) return;

        console.log('Initializing direct Noske search...');

        // Set up search input event listener
        const searchInput = document.getElementById('noske-input');
        if (searchInput) {
            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    this.performSearch(e.target.value);
                }
            });

            // Also add a search button
            const searchButton = document.createElement('button');
            searchButton.textContent = 'Suchen';
            searchButton.className = 'btn btn-primary btn-sm mt-2';
            searchButton.addEventListener('click', () => {
                this.performSearch(searchInput.value);
            });

            searchInput.parentElement.appendChild(searchButton);
        }

        this.initialized = true;
        console.log('Direct Noske search initialized');
    }

    performSearch(query) {
        if (!query.trim()) return;

        console.log('Performing Noske search for:', query);

        const statsContainer = document.getElementById('noske-stats');
        const hitsContainer = document.getElementById('noske-hits');

        // Show loading state
        if (statsContainer) {
            statsContainer.innerHTML = 'Suche läuft...';
        }
        if (hitsContainer) {
            hitsContainer.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        }

        // Try JSONP approach first, fallback to iframe
        this.performJSONPSearch(query);
    }

    performJSONPSearch(query) {
        console.log('Trying JSONP search for:', query);

        // Create a JSONP callback function
        const callbackName = 'noskeCallback_' + Date.now();

        window[callbackName] = (data) => {
            console.log('JSONP response received:', data);
            this.displayResults(data, query);
            // Clean up
            document.head.removeChild(script);
            delete window[callbackName];
        };

        // Create script tag for JSONP
        const script = document.createElement('script');
        const searchUrl = new URL('https://corpus-search.acdh.oeaw.ac.at/run.cgi/first');
        searchUrl.searchParams.append('corpname', this.corpname);
        searchUrl.searchParams.append('iquery', query);
        searchUrl.searchParams.append('queryselector', 'iqueryrow');
        searchUrl.searchParams.append('format', 'json');
        searchUrl.searchParams.append('callback', callbackName);

        script.src = searchUrl.toString();
        script.onerror = () => {
            console.log('JSONP failed, falling back to iframe approach');
            document.head.removeChild(script);
            delete window[callbackName];
            this.performIframeSearch(query);
        };

        document.head.appendChild(script);

        // Timeout fallback
        setTimeout(() => {
            if (window[callbackName]) {
                console.log('JSONP timeout, falling back to iframe approach');
                script.onerror();
            }
        }, 5000);
    }

    performIframeSearch(query) {
        const hitsContainer = document.getElementById('noske-hits');
        const statsContainer = document.getElementById('noske-stats');

        // Build the Crystal search URL (the web interface)
        const searchUrl = new URL('https://corpus-search.acdh.oeaw.ac.at/crystal/');
        searchUrl.hash = `concordance?corpname=${this.corpname}&tab=basic&keyword=${encodeURIComponent(query)}&attrs=word&viewmode=sen&attr_allpos=all&refs_up=0&shorten_refs=1&glue=1&gdexcnt=300&show_gdex_scores=0&itemsPerPage=20&structs=s%2Cg&refs=doc&showresults=1&showTBL=0&tbl_template=&gdexconf=&f_tab=basic&f_showrelfrq=1&f_showperc=0&f_showreldens=0&f_showreltt=0&c_customrange=0&t_attr=&t_absfrq=0&t_trimempty=1&t_threshold=5`;

        console.log('Crystal search URL:', searchUrl.toString());

        if (statsContainer) {
            statsContainer.innerHTML = `<small class="text-muted">Ergebnisse für "${query}"</small>`;
        }

        if (hitsContainer) {
            hitsContainer.innerHTML = `
                <div class="alert alert-info">
                    <h6><i class="fas fa-external-link-alt"></i> Noske/Crystal Suche</h6>
                    <p class="mb-3">Die Suche wird in der Crystal-Oberfläche geöffnet:</p>
                    <p><strong>Suchbegriff:</strong> <code>${query}</code></p>
                    <div class="d-grid gap-2">
                        <a href="${searchUrl.toString()}" target="_blank" class="btn btn-primary">
                            <i class="fas fa-search"></i> In Crystal öffnen
                        </a>
                    </div>
                </div>
                <div class="mt-3">
                    <h6>Eingebettete Suche:</h6>
                    <iframe
                        src="${searchUrl.toString()}"
                        style="width: 100%; height: 600px; border: 1px solid #dee2e6; border-radius: 0.375rem;"
                        title="Noske Crystal Search Results">
                    </iframe>
                </div>
            `;
        }
    }

    displayResults(data, query) {
        const statsContainer = document.getElementById('noske-stats');
        const hitsContainer = document.getElementById('noske-hits');

        console.log('Displaying results for query:', query, 'Data:', data);

        // Display statistics
        if (statsContainer) {
            const numHits = data.concsize || data.total || 0;
            statsContainer.innerHTML = `<small class="text-muted">${numHits} Treffer für "${query}"</small>`;
        }

        // Display results
        if (hitsContainer) {
            // Check different possible data structures
            const lines = data.Lines || data.lines || data.results || [];

            if (lines.length > 0) {
                let html = '<table class="table table-hover"><tbody>';

                lines.slice(0, 20).forEach((line, index) => {
                    let leftContext = '';
                    let keyword = '';
                    let rightContext = '';
                    let docRef = '';

                    // Handle different possible line structures
                    if (line.Left || line.Kwic || line.Right) {
                        // Standard Noske format
                        leftContext = this.extractText(line.Left || []);
                        keyword = this.extractText(line.Kwic || []);
                        rightContext = this.extractText(line.Right || []);
                    } else if (line.left || line.kwic || line.right) {
                        // Alternative naming
                        leftContext = this.extractText(line.left || []);
                        keyword = this.extractText(line.kwic || []);
                        rightContext = this.extractText(line.right || []);
                    } else if (typeof line === 'string') {
                        // Simple string format
                        keyword = line;
                    } else {
                        // Fallback - display entire line as keyword
                        keyword = JSON.stringify(line);
                    }

                    // Extract document reference (Editionseinheit)
                    // Noske typically provides this in line.Refs or line.refs
                    if (line.Refs && Array.isArray(line.Refs)) {
                        const docRefObj = line.Refs.find(ref => ref.name === 'doc' || ref.name === 'text');
                        docRef = docRefObj?.val || docRefObj?.value || '';
                    } else if (line.refs && Array.isArray(line.refs)) {
                        const docRefObj = line.refs.find(ref => ref.name === 'doc' || ref.name === 'text');
                        docRef = docRefObj?.val || docRefObj?.value || '';
                    } else if (line.Ref) {
                        docRef = line.Ref;
                    } else if (line.ref) {
                        docRef = line.ref;
                    } else if (line.doc) {
                        docRef = line.doc;
                    }

                    console.log('Document reference for line', index, ':', docRef);

                    // Create link URL to the letter/edition unit
                    let letterUrl = '';
                    if (docRef) {
                        // Clean up the docRef and create proper link
                        const letterId = docRef.replace(/\.xml$/, '').replace(/^.*\//, '');
                        letterUrl = `${letterId}.html`;
                    }

                    // Make the entire row clickable
                    const rowClass = letterUrl ? 'cursor-pointer' : '';
                    const rowClick = letterUrl ? `onclick="window.location.href='${letterUrl}'"` : '';

                    html += `
                        <tr class="p-2 ${rowClass}" ${rowClick} style="${letterUrl ? 'cursor: pointer;' : ''}">
                            <td class="text-sm text-gray-500 p-2 text-right">${leftContext}</td>
                            <td class="text-lg text-red-500">
                                ${letterUrl ? `<a href="${letterUrl}">${keyword}</a>` : keyword}
                            </td>
                            <td class="text-sm text-gray-500 p-2 text-left">${rightContext}</td>
                        </tr>
                    `;
                });

                html += '</tbody></table>';
                hitsContainer.innerHTML = html;
            } else {
                hitsContainer.innerHTML = '<div class="alert alert-info">Keine Treffer gefunden.</div>';
            }
        }
    }

    extractText(lineData) {
        if (!Array.isArray(lineData)) return '';

        return lineData.map(item => {
            if (typeof item === 'string') return item;
            if (item && item.str) return item.str;
            if (item && item.word) return item.word;
            return '';
        }).join(' ');
    }

    show() {
        console.log('Showing direct Noske search...');
        document.getElementById('noske-search-container').style.display = 'block';
        document.getElementById('typesense-search-container').style.display = 'none';
        if (!this.initialized) {
            this.init();
        }
    }

    hide() {
        document.getElementById('noske-search-container').style.display = 'none';
    }
}

// Initialize global instance
window.directNoskeSearch = new DirectNoskeSearch();