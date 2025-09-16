// Import Noske search from CDN
import { NoskeSearch } from "https://cdn.jsdelivr.net/npm/acdh-noske-search/dist/index.js";

console.log('NoskeSearch import:', NoskeSearch);

class Noske {
    constructor() {
        this.search = null;
        this.initialized = false;
    }

    init() {
        if (this.initialized) return;

        console.log('Initializing Noske search...');

        try {
            // Initialize Noske search
            this.search = new NoskeSearch({
                container: "noske-search-container"
            });

            console.log('Noske search instance created:', this.search);

            this.search.search({
            client: {
                base: "https://corpus-search.acdh.oeaw.ac.at/run.cgi/",
                corpname: "schnitzlerbriefe", // Corrected corpus name from URL
                attrs: "word,lemma,pos",
                structs: "doc,chapter,p,s",
                refs: "doc.title,chapter.title,p.id,s.id"
            },
            hits: {
                id: "noske-hits",
                css: {
                    table: "table table-striped"
                }
            },
            pagination: {
                id: "noske-pagination"
            },
            searchInput: {
                id: "noske-input"
            },
            stats: {
                id: "noske-stats"
            }
        });

        this.initialized = true;
        console.log('Noske search initialized successfully');

        } catch (error) {
            console.error('Error initializing Noske search:', error);
        }
    }

    show() {
        console.log('Showing Noske search...');
        console.log('NoskeSearch available:', typeof NoskeSearch);

        document.getElementById('noske-search-container').style.display = 'block';
        document.getElementById('typesense-search-container').style.display = 'none';
        if (!this.initialized) {
            console.log('Initializing Noske for first time...');
            this.init();
        }
    }

    hide() {
        document.getElementById('noske-search-container').style.display = 'none';
    }
}

// Initialize global Noske instance
window.noskeSearch = new Noske();