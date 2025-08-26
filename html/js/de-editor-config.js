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
                    // Restore project color
                    slider.style.backgroundColor = '#A63437';
                }
                
                // Update master toggle state based on individual toggles
                updateMasterToggleState();
            });
        });
        
        // Annotation toggles
        const annotationToggles = document.querySelectorAll('.annotation-toggle input[type="checkbox"]');
        annotationToggles.forEach(function(toggle) {
            const annotationType = toggle.closest('.annotation-toggle').getAttribute('data-type');
            
            toggle.addEventListener('change', function() {
                const slider = toggle.nextElementSibling;
                
                // Update slider color
                if (!toggle.checked) {
                    slider.style.backgroundColor = '#ccc';
                } else {
                    slider.style.backgroundColor = '#A63437';
                }
                
                // Handle different annotation types
                if (annotationType === 'ef2') {
                    // Handle features-2 class elements
                    const features2Elements = document.querySelectorAll('.features-2');
                    features2Elements.forEach(function(element) {
                        if (toggle.checked) {
                            element.classList.add('activated');
                        } else {
                            element.classList.remove('activated');
                        }
                    });
                } else if (annotationType === 'ls') {
                    // Handle langes-s
                    document.querySelectorAll('.langes-s').forEach(el => {
                        if (toggle.checked) {
                            el.classList.add('langes-s-active');
                        } else {
                            el.classList.remove('langes-s-active');
                        }
                        el.textContent = toggle.checked ? el.dataset.replacement : el.dataset.original;
                    });
                } else if (annotationType === 'gem-m') {
                    // Handle gemination-m
                    document.querySelectorAll('.gemination-m').forEach(el => {
                        if (toggle.checked) {
                            el.classList.add('gemination-m-active');
                        } else {
                            el.classList.remove('gemination-m-active');
                        }
                        el.textContent = toggle.checked ? el.dataset.replacement : el.dataset.original;
                    });
                } else if (annotationType === 'gem-n') {
                    // Handle gemination-n
                    document.querySelectorAll('.gemination-n').forEach(el => {
                        if (toggle.checked) {
                            el.classList.add('gemination-n-active');
                        } else {
                            el.classList.remove('gemination-n-active');
                        }
                        el.textContent = toggle.checked ? el.dataset.replacement : el.dataset.original;
                    });
                } else if (annotationType === 'del') {
                    // Handle deletions
                    document.querySelectorAll('.del').forEach(el => {
                        if (toggle.checked) {
                            el.classList.add('strikethrough');
                        } else {
                            el.classList.remove('strikethrough');
                        }
                    });
                } else if (annotationType === 'add') {
                    // Handle additions
                    document.querySelectorAll('.add').forEach(el => {
                        if (toggle.checked) {
                            el.classList.add('add-zeichen');
                        } else {
                            el.classList.remove('add-zeichen');
                        }
                    });
                }
                
                // Update URL parameters
                updateURLParameters();
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
        
        // Function to update URL parameters
        function updateURLParameters() {
            const url = new URL(window.location);
            
            // Check annotation toggles
            const ef2Toggle = document.getElementById('ef2-slider');
            const lsToggle = document.getElementById('langes-s-slider');
            const gmToggle = document.getElementById('gemination-m-slider');
            const gnToggle = document.getElementById('gemination-n-slider');
            const delToggle = document.getElementById('deleted-slider');
            const addToggle = document.getElementById('addition-slider');
            
            if (ef2Toggle && ef2Toggle.checked) {
                url.searchParams.set('textfeatures', '1');
            } else {
                url.searchParams.delete('textfeatures');
            }
            
            if (lsToggle && lsToggle.checked) {
                url.searchParams.set('ls', '1');
            } else {
                url.searchParams.delete('ls');
            }
            
            if (gmToggle && gmToggle.checked) {
                url.searchParams.set('gem-m', '1');
            } else {
                url.searchParams.delete('gem-m');
            }
            
            if (gnToggle && gnToggle.checked) {
                url.searchParams.set('gem-n', '1');
            } else {
                url.searchParams.delete('gem-n');
            }
            
            if (delToggle && delToggle.checked) {
                url.searchParams.set('del', '1');
            } else {
                url.searchParams.delete('del');
            }
            
            if (addToggle && addToggle.checked) {
                url.searchParams.set('add', '1');
            } else {
                url.searchParams.delete('add');
            }
            
            // Update URL without reloading page
            window.history.replaceState({}, '', url);
            
            // Trigger URL update for prev/next buttons
            if (window.nextPrevUrlUpdate) {
                window.nextPrevUrlUpdate();
            }
        }
        
        // Initialize toggles from URL parameters
        function initializeFromURL() {
            const urlParams = new URLSearchParams(window.location.search);
            
            // Set toggle states based on URL parameters
            const toggleMappings = {
                'textfeatures': 'ef2-slider',
                'ls': 'langes-s-slider',
                'gem-m': 'gemination-m-slider',
                'gem-n': 'gemination-n-slider',
                'del': 'deleted-slider',
                'add': 'addition-slider'
            };
            
            Object.entries(toggleMappings).forEach(([param, toggleId]) => {
                const toggle = document.getElementById(toggleId);
                if (toggle && urlParams.get(param) === '1') {
                    toggle.checked = true;
                    // Trigger change event to apply styles
                    toggle.dispatchEvent(new Event('change'));
                }
            });
        }
        
        // Initialize from URL parameters
        initializeFromURL();
    }, 500);
});

var editor = new LoadEditor({
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

