const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
    server: {
      apiKey: "q1jDFeqfOj47rJD14NxWFVyQZj7FL7Xj",
      nodes: [
        {
          host: "typesense.acdh-dev.oeaw.ac.at",
          port: "443",
          protocol: "https",
        },
      ],
      cacheSearchResultsForSeconds: 2 * 60,
    },
    additionalSearchParameters: {
      query_by: "full_text,editionstext,kommentar,objektbeschreibung"
    },
  });

// Wrap the search client to modify query_by based on filters
const originalSearch = typesenseInstantsearchAdapter.searchClient.search.bind(typesenseInstantsearchAdapter.searchClient);

typesenseInstantsearchAdapter.searchClient.search = function(requests) {
    // Modify requests to adjust query_by based on text_areas filter
    const modifiedRequests = requests.map(request => {
        const filters = request.params?.facetFilters || [];

        // Look for text_areas filter
        let selectedAreas = [];
        filters.forEach(filterGroup => {
            if (Array.isArray(filterGroup)) {
                filterGroup.forEach(filter => {
                    if (typeof filter === 'string' && filter.startsWith('text_areas:')) {
                        selectedAreas.push(filter.replace('text_areas:', ''));
                    }
                });
            } else if (typeof filterGroup === 'string' && filterGroup.startsWith('text_areas:')) {
                selectedAreas.push(filterGroup.replace('text_areas:', ''));
            }
        });

        // Determine query_by based on selected areas
        let queryBy = 'full_text';

        if (selectedAreas.length > 0) {
            const fieldMap = {
                'Editionstext': 'editionstext',
                'Kommentar': 'kommentar',
                'Objektbeschreibung': 'objektbeschreibung'
            };

            const fields = selectedAreas
                .map(area => fieldMap[area])
                .filter(field => field);

            if (fields.length > 0) {
                queryBy = fields.join(',');
            }
        }

        // Override query_by in additional search parameters
        return {
            ...request,
            params: {
                ...request.params,
                query_by: queryBy
            }
        };
    });

    return originalSearch(modifiedRequests);
};

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
    indexName: 'schnitzler-briefe',
    searchClient,
});

// Make search globally available for the toggle functionality
window.search = search;

search.addWidgets([
    instantsearch.widgets.searchBox({
        container: '#searchbox',
        autofocus: true,
        cssClasses: {
          form: 'form-inline',
          input: 'form-control col-md-11',
          submit: 'btn',
          reset: 'btn'
        },
    }),

    instantsearch.widgets.hits({
  container: "#hits",
  cssClasses: {
    item: "w-100"
  },
  templates: {
    empty: "Keine Resultate für <q>{{ query }}</q>",
    item(hit, { html, components }) {
      // Helper function to truncate label
      const truncateLabel = (label) => label.length > 115 ? label.substring(0, 112) + '…' : label;

      return html`
        <h3><a href="${hit.id}.html">${hit.title}</a></h3>
        <p>${hit._snippetResult.full_text.matchedWords.length > 0 ? components.Snippet({ hit, attribute: 'full_text' }) : ''}</p>
        <p>
        ${hit.persons.map((item) => html`<a href='${item.id}.html'><span class="badge rounded-pill m-1" style="background-color: #e74c3c; color: white;">${truncateLabel(item.label)}</span></a>`)}
        ${hit.places.map((item) => html`<a href='${item.id}.html'><span class="badge rounded-pill m-1" style="background-color: #3498db; color: white;">${truncateLabel(item.label)}</span></a>`)}
        ${hit.orgs.map((item) => html`<a href='${item.id}.html'><span class="badge rounded-pill m-1" style="background-color: #9b59b6; color: white;">${truncateLabel(item.label)}</span></a>`)}
        ${hit.works.map((item) => html`<a href='${item.id}.html'><span class="badge rounded-pill m-1" style="background-color: #f39c12; color: white;">${truncateLabel(item.label)}</span></a>`)}
        ${hit.events && hit.events.map((item) => html`<a href='${item.id}.html'><span class="badge rounded-pill m-1" style="background-color: #27ae60; color: white;">${truncateLabel(item.label)}</span></a>`)}
        </p>`;
    },
  },
}),

    instantsearch.widgets.stats({
      container: '#stats-container',
      templates: {
        text: `
          {{#areHitsSorted}}
            {{#hasNoSortedResults}}Keine Treffer{{/hasNoSortedResults}}
            {{#hasOneSortedResults}}1 Treffer{{/hasOneSortedResults}}
            {{#hasManySortedResults}}{{#helpers.formatNumber}}{{nbSortedHits}}{{/helpers.formatNumber}} Treffer {{/hasManySortedResults}}
            aus {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}}
          {{/areHitsSorted}}
          {{^areHitsSorted}}
            {{#hasNoResults}}Keine Treffer{{/hasNoResults}}
            {{#hasOneResult}}1 Treffer{{/hasOneResult}}
            {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} Treffer{{/hasManyResults}}
          {{/areHitsSorted}}
          gefunden in {{processingTimeMS}}ms
        `,
      }
  }),
  instantsearch.widgets.refinementList({
    container: "#refinement-list-text-areas",
    attribute: "text_areas",
    sortBy: ["name:asc"],
    cssClasses: {
      list: "list-unstyled",
      count: "badge ml-2 bg-secondary",
      label: "d-flex align-items-center",
      checkbox: "form-check",
    },
  }),

  instantsearch.widgets.rangeInput({
    container: "#range-input",
    attribute: "year",
    templates: {
      separatorText: 'bis',
      submitText: 'Suchen',
    },
    cssClasses: {
      form: 'form-inline',
      input: 'form-control',
      submit: 'btn'
    }
  }),
  instantsearch.widgets.refinementList({
    container: "#refinement-list-receiver",
    attribute: "receiver.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    searchablePlaceholder: "Suche",
    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2 border-light-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-secondary btn-sm align-content-center",
      list: "list-unstyled",
      count: "badge ml-2 bg-info",
      label: "d-flex align-items-center text-capitalize",
      checkbox: "form-check",
    },
  }),

  instantsearch.widgets.refinementList({
    container: "#refinement-list-sender",
    attribute: "sender.label",
    searchable: true,
    showMore: true,
    showMoreLimit: 50,
    searchablePlaceholder: "Suche",
    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2 border-light-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-secondary btn-sm align-content-center",
      list: "list-unstyled",
      count: "badge ml-2 bg-info",
      label: "d-flex align-items-center text-capitalize",
      checkbox: "form-check",
    },
  }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-places',
        attribute: 'places.label',
        searchable: true,
        showMore: true,
        showMoreLimit: 50,
        searchablePlaceholder: 'Suche',
        cssClasses: {
          searchableInput: 'form-control form-control-sm mb-2 border-light-2',
          searchableSubmit: 'd-none',
          searchableReset: 'd-none',
          showMore: 'btn btn-secondary btn-sm align-content-center',
          list: 'list-unstyled',
          count: 'badge ml-2',
          label: 'd-flex align-items-center text-capitalize',
          checkbox: 'form-check'
        }
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-persons',
        attribute: 'persons.label',
        searchable: true,
        showMore: true,
        showMoreLimit: 50,
        searchablePlaceholder: 'Suche',
        cssClasses: {
          searchableInput: 'form-control form-control-sm mb-2 border-light-2',
          searchableSubmit: 'd-none',
          searchableReset: 'd-none',
          showMore: 'btn btn-secondary btn-sm align-content-center',
          list: 'list-unstyled',
          count: 'badge ml-2',
          label: 'd-flex align-items-center text-capitalize',
          checkbox: 'form-check'
        }
    }),

    instantsearch.widgets.refinementList({
        container: '#refinement-list-works',
        attribute: 'works.label',
        searchable: true,
        showMore: true,
        showMoreLimit: 50,
        searchablePlaceholder: 'Suche',
        cssClasses: {
          searchableInput: 'form-control form-control-sm mb-2 border-light-2',
          searchableSubmit: 'd-none',
          searchableReset: 'd-none',
          showMore: 'btn btn-secondary btn-sm align-content-center',
          list: 'list-unstyled',
          count: 'badge ml-2',
          label: 'd-flex align-items-center text-capitalize',
          checkbox: 'form-check'
        }
    }),

    instantsearch.widgets.refinementList({
      container: '#refinement-list-orgs',
      attribute: 'orgs.label',
      searchable: true,
      showMore: true,
      showMoreLimit: 50,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge ml-2',
        label: 'd-flex align-items-center text-capitalize',
        checkbox: 'form-check'
      }
  }),

    instantsearch.widgets.refinementList({
      container: '#refinement-list-events',
      attribute: 'events.label',
      searchable: true,
      showMore: true,
      showMoreLimit: 50,
      searchablePlaceholder: 'Suche',
      cssClasses: {
        searchableInput: 'form-control form-control-sm mb-2 border-light-2',
        searchableSubmit: 'd-none',
        searchableReset: 'd-none',
        showMore: 'btn btn-secondary btn-sm align-content-center',
        list: 'list-unstyled',
        count: 'badge ml-2',
        label: 'd-flex align-items-center text-capitalize',
        checkbox: 'form-check'
      }
  }),
    instantsearch.widgets.pagination({
        container: '#pagination',
        padding: 2,
        cssClasses: {
          list: 'pagination',
          item: 'page-item',
          link: 'page-link'
        }
    }),
    instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
        templates: {
          resetLabel: 'Filter zurücksetzen',
        },
        cssClasses: {
          button: 'btn'
        }
    }),

    	

    instantsearch.widgets.currentRefinements({
      container: '#current-refinements',
      cssClasses: {
        delete: 'btn',
        label: 'badge'
      },
      transformItems(items) {
        return items.map(item => ({
          ...item,
          refinements: item.refinements.map(refinement => ({
            ...refinement,
            label: refinement.value
          }))
        }));
      }
    })
]);



search.addWidgets([
    instantsearch.widgets.configure({
        attributesToSnippet: ['full_text', 'editionstext', 'kommentar', 'objektbeschreibung'],
    })
]);



// Start search after DOM is loaded and toggle is initialized
document.addEventListener('DOMContentLoaded', function() {
    // Wait a moment for toggle to initialize
    setTimeout(() => {
        search.start();
    }, 200);
});