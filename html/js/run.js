var editor = new LoadEditor({
    aot: {
        title: "Entitäten",
        variants:[ {
            opt: "ef",
            opt_slider: "entities-features-slider",
            title: "Alle",
            color: "red",
            html_class: "undefined",
            css_class: "",
            chg_citation: "citation-url",
            hide: {
                hidden: false,
                class: "undefined",
            },
            features: {
                all: true,
                class: "features-1",
            },
        }, {
            opt: "ef2",
            opt_slider: "entities-features-slider",
            title: "Alle",
            color: "green",
            html_class: "undefined",
            css_class: "",
            chg_citation: "citation-url",
            hide: {
                hidden: false,
                class: "undefined",
            },
            features: {
                all: true,
                class: "features-2",
            },
        }, {
            opt: "ls",
            opt_slider: "langes-s-slider",
            title: "Langes-s (ſ)",
            color: "undefined",
            html_class: "langes-s",
            hide: {
                hidden: true,
                class: "langes-s-rplMe"
            },
            css_class: "langes-s-rplMe",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "gem-m",
            opt_slider: "gemination-m-slider",
            title: "Gemination m (m̅)",
            color: "undefined",
            html_class: "gemination-m",
            hide: {
                hidden: true,
                class: "gemination-m-rplMe"
            },
            css_class: "gemination-m-rplMe",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "gem-n",
            opt_slider: "gemination-n-slider",
            title: "Gemination n (n̅̅)",
            color: "undefined",
            html_class: "gemination-n",
            hide: {
                hidden: true,
                class: "gemination-n-rplMe"
            },
            css_class: "gemination-n-rplMe",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "del",
            opt_slider: "deleted-slider",
            title: "Streichung",
            color: "black",
            html_class: "del",
            hide: {
                hidden: true,
                class: "del"
            },
            css_class: "strikethrough",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "add",
            opt_slider: "addition-slider",
            title: "Hinzufügungen",
            color: "undefined",
            html_class: "add",
            hide: {
                hidden: true,
                class: "add-zeichen"
            },
            css_class: "add-zeichen",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "prs",
            title: "Personen",
            html_class: "persons",
            hide: {
                hidden: true,
                class: "persons .entity",
            },
            chg_citation: "citation-url",
            features: {
                all: false,
                class: "features-1",
            },
        }, {
            opt: "plc",
            title: "Orte",
            html_class: "places",
            hide: {
                hidden: true,
                class: "places .entity",
            },
            chg_citation: "citation-url",
            features: {
                all: false,
                class: "features-1",
            },
        }, {
            opt: "org",
            title: "Institutionen",
            html_class: "orgs",
            hide: {
                hidden: true,
                class: "orgs .entity",
            },
            chg_citation: "citation-url",
            features: {
                all: false,
                class: "features-1",
            },
        }, {
            opt: "wrk",
            title: "Werke",
            html_class: "works",
            hide: {
                hidden: true,
                class: "works .entity",
            },
            features: {
                all: false,
                class: "features-1",
            },
        }, {
            opt: "evt",
            title: "Ereignisse",
            html_class: "events",
            hide: {
                hidden: true,
                class: "events .entity",
            },
            features: {
                all: false,
                class: "features-1",
            },
        }],
        span_element: {
            css_class: "badge-item",
        },
        active_class: "activated",
        rendered_element: {
            label_class: "switch",
            slider_class: "i-slider round",
        },
    },
    is: {
        name: "Faksimile",
        variants:[ {
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
        },],
        active_class: "active",
        rendered_element: {
            a_class: "nav-link btn btn-round",
            svg: "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' class='bi bi-image' viewBox='0 0 16 16'><path d='M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z'/><path d='M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z'/></svg>",
        },
    },
    wr: false,
    up: true,
});