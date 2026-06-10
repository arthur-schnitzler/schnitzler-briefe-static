// Noske Search Implementation using acdh-noske-search package
import { NoskeSearch } from "https://cdn.jsdelivr.net/npm/acdh-noske-search/dist/index.js";

// Maximum number of words shown left and right of the keyword
const CONTEXT_WORDS = 25;

class NoskeSearchImplementation {
    constructor() {
        this.search = null;
        this.initialized = false;
    }

    init() {
        if (this.initialized) return;

        console.log('Initializing Noske search with acdh-noske-search package...');

        try {
            this.search = new NoskeSearch({ container: "noske-search" });

            this.search.search({
                client: {
                    base: "https://corpus-search.acdh.oeaw.ac.at/",
                    corpname: "schnitzlerbriefe",
                    attrs: "word,landingPageURI",
                    structs: "chapter",
                    refs: "doc.id",
                    // Sentence-bounded context: never crosses letter boundaries.
                    // ("s:chapter" is invalid manatee syntax and yields empty contexts.)
                    kwicleftctx: "-1:s",
                    kwicrightctx: "1:s",
                },
                hits: {
                    id: "hitsbox",
                    css: {
                        table: "table-auto",
                        kwicContainer: "kwic-container",
                        leftContext: "context-left",
                        rightContext: "context-right",
                        keyword: "keyword"
                    }
                },
                pagination: {
                    id: "noske-pagination-test",
                    css: {
                        pagination: "pagination justify-content-center",
                        pageItem: "page-item",
                        pageLink: "page-link"
                    }
                },
                searchInput: {
                    id: "noske-search",
                    css: {
                        input: "form-control form-control-lg"
                    }
                },
                stats: {
                    id: "noske-stats",
                    label: "Treffer:",
                    css: {
                        container: "alert alert-info",
                        text: "mb-0"
                    }
                },
                config: {
                    results: "Keine Treffer gefunden. Bitte versuchen Sie eine andere Suchanfrage.",
                    customResponseHtml: (lines, containerId) => this.renderHits(lines, containerId)
                },
                autocompleteOptions: {
                    id: "noske-autocomplete",
                },
            });

            this.initialized = true;
            console.log('Noske search initialized successfully');

        } catch (error) {
            console.error('Error initializing Noske search:', error);
            this.showError('Fehler beim Initialisieren der Noske-Suche. Bitte versuchen Sie es später erneut.');
        }
    }

    // Extracts the letter URL (e.g. "L02453.html") from a result line.
    // The landingPageURI attribute is delivered per token in kwic_attr,
    // e.g. "/https://arthur-schnitzler.github.io/schnitzler-briefe-static/L02453.html"
    letterUrlFromLine(line) {
        const attr = line.kwic_attr || '';
        const match = attr.match(/([A-Za-z0-9_-]+\.html)/);
        return match ? match[1] : null;
    }

    escapeHtml(text) {
        return String(text)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    trimContext(text, side) {
        const words = String(text || '').trim().split(/\s+/).filter(Boolean);
        if (words.length <= CONTEXT_WORDS) {
            return words.join(' ');
        }
        if (side === 'left') {
            return '… ' + words.slice(-CONTEXT_WORDS).join(' ');
        }
        return words.slice(0, CONTEXT_WORDS).join(' ') + ' …';
    }

    renderHits(lines, containerId) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const rows = lines.map(line => {
            const left = this.escapeHtml(this.trimContext(line.left, 'left'));
            const right = this.escapeHtml(this.trimContext(line.right, 'right'));
            const kwic = this.escapeHtml(String(line.kwic || '').trim());
            const url = this.letterUrlFromLine(line);

            const wrap = (content) => url
                ? `<a class="kwic-link" href="${url}">${content}</a>`
                : content;

            return `
                <tr${url ? ` data-url="${url}"` : ''}>
                    <td class="context-left">${wrap(left)}</td>
                    <td class="keyword">${wrap(kwic)}</td>
                    <td class="context-right">${wrap(right)}</td>
                </tr>`;
        }).join('');

        container.innerHTML = `
            <div class="overflow-x-auto">
                <table class="table-auto">
                    <tbody>${rows}</tbody>
                </table>
            </div>`;

        // Make whole rows clickable (links inside still work normally)
        container.querySelectorAll('tr[data-url]').forEach(row => {
            row.addEventListener('click', (e) => {
                if (e.target.closest('a')) return;
                window.location.href = row.dataset.url;
            });
        });
    }

    showError(message) {
        const statsContainer = document.getElementById('noske-stats');
        const hitsContainer = document.getElementById('hitsbox');

        if (statsContainer) {
            statsContainer.innerHTML = `<div class="alert alert-warning mb-0"><i class="fas fa-exclamation-triangle"></i> ${message}</div>`;
        }

        if (hitsContainer) {
            hitsContainer.innerHTML = `
                <div class="alert alert-warning">
                    <h6><i class="fas fa-exclamation-triangle"></i> Hinweis</h6>
                    <p class="mb-3">${message}</p>
                    <div class="mt-3">
                        <h6>Erweiterte Suchoptionen:</h6>
                        <ul class="mb-0">
                            <li><strong>Einfache Suche:</strong> <code>liebe</code> oder <code>lieb*</code> für Platzhaltersuche</li>
                            <li><strong>CQL-Suche:</strong> <code>[lemma="lieben"]</code> für Lemma-Suche</li>
                            <li><strong>Regex:</strong> <code>[word=".*ing"]</code> für komplexe Muster</li>
                        </ul>
                    </div>
                </div>
            `;
        }
    }

    show() {
        console.log('Showing Noske search...');

        // Show Noske container, hide Typesense
        const noskeContainer = document.getElementById('noske-search-container');
        const typesenseContainer = document.getElementById('typesense-search-container');

        if (noskeContainer) noskeContainer.style.display = 'block';
        if (typesenseContainer) typesenseContainer.style.display = 'none';

        // Initialize if not already done
        if (!this.initialized) {
            this.init();
        }
    }

    hide() {
        const noskeContainer = document.getElementById('noske-search-container');
        if (noskeContainer) {
            noskeContainer.style.display = 'none';
        }
    }

    // Utility method to check if the package is available
    isPackageAvailable() {
        return typeof NoskeSearch !== 'undefined';
    }
}

// Initialize global Noske search instance
try {
    window.noskeSearch = new NoskeSearchImplementation();
    console.log('Noske search module loaded successfully');
} catch (error) {
    console.error('Failed to initialize Noske search module:', error);

    // Fallback error display
    window.noskeSearch = {
        show: function() {
            const container = document.getElementById('noske-search-container');
            if (container) {
                container.innerHTML = `
                    <div class="alert alert-danger">
                        <h6><i class="fas fa-exclamation-circle"></i> Noske-Suche nicht verfügbar</h6>
                        <p>Die Noske-Suchfunktion konnte nicht geladen werden. Bitte verwenden Sie die Typesense-Suche oder kontaktieren Sie den Administrator.</p>
                    </div>
                `;
                container.style.display = 'block';
            }
        },
        hide: function() {
            const container = document.getElementById('noske-search-container');
            if (container) container.style.display = 'none';
        }
    };
}
