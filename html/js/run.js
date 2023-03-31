var editor = new LoadEditor({
    aot: {
      title: "Entitäten",
      variants: [
        {
          opt: "ef",
          opt_slider: "entities-features-slider",
          title: "Alle",
          color: "red",
          html_class: "undefined",
          css_class: "undefined",
          chg_citation: "citation-url",
          hide: {
            hidden: false,
            class: "undefined",
          },
          features: {
            all: true,
            class: "features-1",
          },
        },
        {
          opt: "prs",
          color: "red",
          title: "Personen",
          html_class: "persons",
          css_class: "pers",
          hide: {
            hidden: false,
            class: "persons .entity",
          },
          chg_citation: "citation-url",
          features: {
            all: false,
            class: "features-1",
          },
        },
        {
          opt: "plc",
          color: "red",
          title: "Orte",
          html_class: "places",
          css_class: "plc",
          hide: {
            hidden: false,
            class: "places .entity",
          },
          chg_citation: "citation-url",
          features: {
            all: false,
            class: "features-1",
          },
        },
        {
          opt: "org",
          color: "red",
          title: "Institutionen",
          html_class: "orgs",
          css_class: "org",
          hide: {
            hidden: false,
            class: "orgs .entity",
          },
          chg_citation: "citation-url",
          features: {
            all: false,
            class: "features-1",
          },
        },
        {
          opt: "wrk",
          color: "red",
          title: "Werke",
          html_class: "works",
          css_class: "wrk",
          chg_citation: "citation-url",
          hide: {
            hidden: false,
            class: "wrk .entity",
          },
          features: {
            all: false,
            class: "features-1",
          },
        }
      ],
      span_element: {
        css_class: "badge-item",
      },
      active_class: "activated",
      rendered_element: {
        label_class: "switch",
        slider_class: "i-slider round",
      },
    },
    fos: {
      name: "Change font size",
      variants: [
        {
          opt: "fs",
          title: "Schriftgröße",
          urlparam: "fs",
          chg_citation: "citation-url",
          sizes: {
            default: "Standard",
            font_size_14: "Klein",
            font_size_18: "Groß",
            font_size_22: "Größer",
            font_size_26: "Riesig",
          },
          paragraph: ".yes-index",
          p_class: "",
          css_class: "font-size-",
        },
      ],
      active_class: "active",
      html_class: "form-select",
    },
    is: {
      name: "Faksimile",
      variants: [
        {
          opt: "es",
          title: "Faksimile",
          urlparam: "img",
          chg_citation: "citation-url",
          fade: "fade",
          column_small: {
            class: "col-md-6",
            percent: "50",
          },
          column_full: {
            class: "col-md-12",
            percent: "100",
          },
          hide: {
            hidden: false,
            class_to_hide: "facsimiles",
            class_to_show: "text",
            class_parent: "transcript",
            resize: "resize-hide",
          },
          image_size: "40px",
        },
      ],
      active_class: "active",
      rendered_element: {
        a_class: "nav-link btn btn-round",
        svg: "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-image' viewBox='0 0 16 16'><path d='M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z'/><path d='M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z'/></svg>",
      },
    },
    wr: false,
    up: true,
  });
  