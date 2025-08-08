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
      query_by: "full_text"
    },
  });


const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
    indexName: 'schnitzler-briefe',
    searchClient,
});

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
      }
    })
]);



search.addWidgets([
    instantsearch.widgets.configure({
        attributesToSnippet: ['full_text'],
    })
]);



search.start();