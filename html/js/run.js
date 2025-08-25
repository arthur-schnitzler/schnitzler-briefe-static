// Independent entity toggle system
document.addEventListener('DOMContentLoaded', function() {
    // Wait for DOM to be ready
    setTimeout(function() {
        const entityToggles = document.querySelectorAll('.entity-toggle input[type="checkbox"]');
        const masterToggle = document.getElementById('master-entity-toggle');
        
        // Individual entity toggles
        entityToggles.forEach(function(toggle) {
            const entityType = toggle.closest('.entity-toggle').getAttribute('data-type');
            
            // Skip master toggle for individual handling
            if (entityType === 'master') return;
            
            toggle.addEventListener('change', function() {
                // Find all entities that have the current entity type class
                // This includes both single entities (.persons.entity) and mixed entities (.persons.places.entity)
                const allEntities = document.querySelectorAll('.entity');
                const matchingEntities = [];
                
                allEntities.forEach(function(entity) {
                    // Check if this entity has the current entityType class
                    if (entity.classList.contains(entityType)) {
                        matchingEntities.push(entity);
                    }
                });
                
                matchingEntities.forEach(function(entity) {
                    if (toggle.checked) {
                        // Show borders - remove the hidden class
                        entity.classList.remove('entity-hidden');
                    } else {
                        // Hide borders - add the hidden class
                        entity.classList.add('entity-hidden');
                    }
                });
                
                // Update slider color (grey when unchecked)
                const slider = toggle.nextElementSibling;
                if (!toggle.checked) {
                    slider.style.backgroundColor = '#ccc';
                } else {
                    // Restore original color
                    const colorMap = {
                        'persons': '#e74c3c',
                        'works': '#f39c12', 
                        'places': '#3498db',
                        'orgs': '#9b59b6',
                        'events': '#27ae60'
                    };
                    slider.style.backgroundColor = colorMap[entityType];
                }
                
                // Update master toggle state based on individual toggles
                updateMasterToggleState();
            });
        });
        
        // Master toggle handler
        if (masterToggle) {
            masterToggle.addEventListener('change', function() {
                const individualToggles = document.querySelectorAll('.entity-toggle:not([data-type="master"]) input[type="checkbox"]');
                const masterSlider = masterToggle.nextElementSibling;
                
                // Set all individual toggles to match master
                individualToggles.forEach(function(toggle) {
                    if (toggle.checked !== masterToggle.checked) {
                        toggle.checked = masterToggle.checked;
                        // Trigger change event to update entities
                        toggle.dispatchEvent(new Event('change'));
                    }
                });
                
                // Update master slider color
                if (!masterToggle.checked) {
                    masterSlider.style.backgroundColor = '#ccc';
                } else {
                    masterSlider.style.backgroundColor = '#A63437';
                }
            });
        }
        
        // Function to update master toggle state based on individual toggles
        function updateMasterToggleState() {
            if (!masterToggle) return;
            
            const individualToggles = document.querySelectorAll('.entity-toggle:not([data-type="master"]) input[type="checkbox"]');
            const checkedCount = Array.from(individualToggles).filter(t => t.checked).length;
            const totalCount = individualToggles.length;
            
            const masterSlider = masterToggle.nextElementSibling;
            
            if (checkedCount === totalCount) {
                // All checked - master should be checked
                masterToggle.checked = true;
                masterSlider.style.backgroundColor = '#A63437';
            } else if (checkedCount === 0) {
                // None checked - master should be unchecked
                masterToggle.checked = false;
                masterSlider.style.backgroundColor = '#ccc';
            } else {
                // Some checked - master remains as is but we could make it indeterminate
                // For now, just update color based on current state
                if (masterToggle.checked) {
                    masterSlider.style.backgroundColor = '#A63437';
                } else {
                    masterSlider.style.backgroundColor = '#ccc';
                }
            }
        }
    }, 500);
});

var editor = new LoadEditor({
    aot: {
        title: "Einstellungen",
        variants:[ {
            opt: "ef2",
            opt_slider: "ef2-slider", 
            title: "Textkritische Zeichen",
            color: "green",
            html_class: "undefined",
            css_class: "",
            chg_citation: "citation-url",
            urlparam: "textfeatures",
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
                hidden: false,
                class: "undefined"
            },
            css_class: "langes-s-active",
            chg_citation: "citation-url",
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
                hidden: false,
                class: "undefined"
            },
            css_class: "gemination-m-active",
            chg_citation: "citation-url",
            features: {
                all: false,
                class: "features-2"
            }
        }, {
            opt: "gem-n",
            opt_slider: "gemination-n-slider",
            title: "Gemination n (n̅)",
            color: "undefined",
            html_class: "gemination-n",
            hide: {
                hidden: false,
                class: "undefined"
            },
            css_class: "gemination-n-active",
            chg_citation: "citation-url",
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
            svg: "<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='white' class='bi bi-image' viewBox='0 0 16 16'><path d='M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z'/><path d='M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a .5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z'/></svg>",
        },
    },
    wr: false,
    up: true,
});

// Monitor for CSS class changes and trigger text replacement
document.addEventListener('DOMContentLoaded', function() {
    
    // Use MutationObserver to watch for class changes
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                const element = mutation.target;
                
                // Check for langes-s changes
                if (element.classList.contains('langes-s')) {
                    const isActive = element.classList.contains('langes-s-active');
                    element.textContent = isActive ? element.dataset.replacement : element.dataset.original;
                }
                
                // Check for gemination-m changes  
                if (element.classList.contains('gemination-m')) {
                    const isActive = element.classList.contains('gemination-m-active');
                    element.textContent = isActive ? element.dataset.replacement : element.dataset.original;
                }
                
                // Check for gemination-n changes
                if (element.classList.contains('gemination-n')) {
                    const isActive = element.classList.contains('gemination-n-active');
                    element.textContent = isActive ? element.dataset.replacement : element.dataset.original;
                }
            }
        });
    });
    
    // Start observing class changes on relevant elements
    setTimeout(function() {
        const elements = document.querySelectorAll('.langes-s, .gemination-m, .gemination-n');
        elements.forEach(function(element) {
            observer.observe(element, { attributes: true, attributeFilter: ['class'] });
        });
    }, 500);
    
});