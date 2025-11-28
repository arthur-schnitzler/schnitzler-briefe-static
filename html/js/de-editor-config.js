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
                    // Restore original entity colors
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
                    // Master toggle for all text-critical features
                    const features2Elements = document.querySelectorAll('.features-2');
                    features2Elements.forEach(function(element) {
                        if (toggle.checked) {
                            element.classList.add('activated');
                        } else {
                            element.classList.remove('activated');
                        }
                    });
                    
                    // Control all other annotation toggles - disable update during batch operation
                    const annotationToggles = document.querySelectorAll('#langes-s-slider, #gemination-m-slider, #gemination-n-slider, #deleted-slider, #addition-slider');
                    annotationToggles.forEach(function(annotationToggle) {
                        annotationToggle.checked = toggle.checked;
                        // Update slider color immediately
                        const childSlider = annotationToggle.nextElementSibling;
                        if (!annotationToggle.checked) {
                            childSlider.style.backgroundColor = '#ccc';
                        } else {
                            childSlider.style.backgroundColor = '#A63437';
                        }
                        // Apply the functionality without triggering the master update
                        applyAnnotationToggle(annotationToggle);
                    });
                } else {
                    // Handle individual annotation toggles
                    applyAnnotationToggle(toggle);
                }
                
                // Update master annotation toggle state for non-master toggles
                if (annotationType !== 'ef2') {
                    updateMasterAnnotationToggleState();
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
        
        // Function to apply annotation toggle functionality without triggering master update
        function applyAnnotationToggle(annotationToggle) {
            const annotationType = annotationToggle.closest('.annotation-toggle').getAttribute('data-type');
            
            if (annotationType === 'ls') {
                // Handle langes-s
                document.querySelectorAll('.langes-s').forEach(el => {
                    if (annotationToggle.checked) {
                        el.classList.add('langes-s-active');
                    } else {
                        el.classList.remove('langes-s-active');
                    }
                    el.textContent = annotationToggle.checked ? el.dataset.replacement : el.dataset.original;
                });
            } else if (annotationType === 'gem-m') {
                // Handle gemination-m
                document.querySelectorAll('.gemination-m').forEach(el => {
                    if (annotationToggle.checked) {
                        el.classList.add('gemination-m-active');
                    } else {
                        el.classList.remove('gemination-m-active');
                    }
                    el.textContent = annotationToggle.checked ? el.dataset.replacement : el.dataset.original;
                });
            } else if (annotationType === 'gem-n') {
                // Handle gemination-n
                document.querySelectorAll('.gemination-n').forEach(el => {
                    if (annotationToggle.checked) {
                        el.classList.add('gemination-n-active');
                    } else {
                        el.classList.remove('gemination-n-active');
                    }
                    el.textContent = annotationToggle.checked ? el.dataset.replacement : el.dataset.original;
                });
            } else if (annotationType === 'del') {
                // Handle deletions - show/hide via display style
                document.querySelectorAll('.del').forEach(el => {
                    if (annotationToggle.checked) {
                        el.style.display = 'inline';
                    } else {
                        el.style.display = 'none';
                    }
                });
            } else if (annotationType === 'add') {
                // Handle additions - show/hide only the arrows, keep content visible
                document.querySelectorAll('.add-zeichen').forEach(el => {
                    if (annotationToggle.checked) {
                        el.style.display = 'inline';
                    } else {
                        el.style.display = 'none';
                    }
                });
            } else if (annotationType === 'faksimile') {
                // Handle faksimile toggle - show/hide facsimile images
                document.querySelectorAll('.facsimiles').forEach(el => {
                    if (annotationToggle.checked) {
                        el.style.display = 'block';
                    } else {
                        el.style.display = 'none';
                    }
                });
                // Also toggle the column layout
                const textElements = document.querySelectorAll('.text');
                const transcriptContainer = document.querySelector('.transcript');
                if (annotationToggle.checked) {
                    // Show facsimile - use two-column layout
                    textElements.forEach(el => {
                        el.classList.remove('col-md-12');
                        el.classList.add('col-md-6');
                    });
                } else {
                    // Hide facsimile - use single-column layout
                    textElements.forEach(el => {
                        el.classList.remove('col-md-6');
                        el.classList.add('col-md-12');
                    });
                }
            }
        }

        // ============================================================
        // INLINE IMAGE MODE IMPLEMENTATION
        // ============================================================

        // Image Mode Toggle Handler
        const imageModeToggle = document.getElementById('image-mode-slider');
        const faksimileToggle = document.getElementById('faksimile-slider');

        if (imageModeToggle && faksimileToggle) {
            // Faksimile-Toggle kontrolliert die Verfügbarkeit des Bildmodus-Toggles
            faksimileToggle.addEventListener('change', function() {
                if (faksimileToggle.checked) {
                    imageModeToggle.disabled = false;
                    document.getElementById('imgmode-toggle-container').style.opacity = '1';
                } else {
                    imageModeToggle.disabled = true;
                    imageModeToggle.checked = false;
                    document.getElementById('imgmode-toggle-container').style.opacity = '0.5';
                    // Wenn Faksimile ausgeschaltet wird, deaktiviere auch Inline-Modus
                    const transcriptContainer = document.querySelector('.transcript');
                    if (transcriptContainer && transcriptContainer.classList.contains('inline-mode')) {
                        disableInlineImageMode(transcriptContainer);
                    }
                }
            });

            imageModeToggle.addEventListener('change', function() {
                const transcriptContainer = document.querySelector('.transcript');
                const slider = imageModeToggle.nextElementSibling;

                if (imageModeToggle.checked) {
                    enableInlineImageMode(transcriptContainer);
                    slider.style.backgroundColor = '#A63437';
                } else {
                    disableInlineImageMode(transcriptContainer);
                    slider.style.backgroundColor = '#ccc';
                }

                updateURLParameters();
            });

            // Initial state: Bildmodus nur verfügbar wenn Faksimile aktiv
            if (!faksimileToggle.checked) {
                imageModeToggle.disabled = true;
                document.getElementById('imgmode-toggle-container').style.opacity = '0.5';
            }
        }

        async function enableInlineImageMode(container) {
            if (!container) return;

            container.classList.add('inline-mode');

            const facsimilesCol = container.querySelector('.facsimiles');
            if (facsimilesCol) facsimilesCol.style.display = 'none';

            const textCol = container.querySelector('.text');
            if (textCol) {
                textCol.classList.remove('col-md-6');
                textCol.classList.add('col-md-12');
            }

            const pagebreaks = container.querySelectorAll('.pagebreak[data-facs]');
            for (let i = 0; i < pagebreaks.length; i++) {
                await insertInlineImage(pagebreaks[i], i + 1);
            }
        }

        function disableInlineImageMode(container) {
            if (!container) return;

            container.classList.remove('inline-mode');

            const facsimilesCol = container.querySelector('.facsimiles');
            if (facsimilesCol) facsimilesCol.style.display = 'block';

            const textCol = container.querySelector('.text');
            if (textCol) {
                textCol.classList.remove('col-md-12');
                textCol.classList.add('col-md-6');
            }

            container.querySelectorAll('.inline-image-container, .inline-image-spacer')
                .forEach(el => el.remove());
        }

        function extractIIIFUrlFromTileSources(facsId) {
            // Try to extract IIIF URL from Openseadragon's tileSources in the page
            const scripts = document.querySelectorAll('script');
            for (let script of scripts) {
                if (script.textContent && script.textContent.includes('tileSources')) {
                    const match = script.textContent.match(/tileSources:\[(.*?)\]/);
                    if (match) {
                        const urls = match[1].match(/"([^"]+)"/g);
                        if (urls) {
                            // Find the URL that matches this facs ID
                            for (let urlStr of urls) {
                                const url = urlStr.replace(/"/g, '');
                                if (url.includes(facsId)) {
                                    return url;
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        async function insertInlineImage(pbElement, pageNum) {
            const facsId = pbElement.getAttribute('data-facs');

            if (!facsId) return;

            if (pbElement.nextElementSibling?.classList.contains('inline-image-container')) {
                return;
            }

            // Extract IIIF URL from Openseadragon tileSources
            const iiifUrl = extractIIIFUrlFromTileSources(facsId);

            if (!iiifUrl) {
                console.warn(`Could not find IIIF URL for facs ID: ${facsId}`);
                return;
            }

            const container = document.createElement('div');
            container.className = 'inline-image-container';
            container.setAttribute('data-facs', facsId);

            const img = document.createElement('img');
            img.className = 'inline-facsimile';
            img.alt = `Seite ${pageNum}`;

            // Responsive Bildgröße: 800px Desktop, 600px Mobile
            const isMobile = window.innerWidth <= 768;
            const imageWidth = isMobile ? 600 : 800;
            const imageUrl = iiifUrl.replace('/info.json', `/full/${imageWidth},/0/default.jpg`);
            img.src = imageUrl;

            const caption = document.createElement('div');
            caption.className = 'image-caption';
            caption.textContent = `Seite ${pageNum}`;

            container.appendChild(img);
            container.appendChild(caption);

            pbElement.parentNode.insertBefore(container, pbElement.nextSibling);

            img.addEventListener('load', function() {
                const spacerHeight = calculateWhitespace(pbElement, container.offsetHeight);
                if (spacerHeight > 0) {
                    insertSpacer(container, spacerHeight);
                }
            });

            img.addEventListener('error', function() {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'inline-image-error';
                errorDiv.innerHTML = `<strong>⚠ Bild konnte nicht geladen werden</strong><br><small>Faksimile-ID: ${facsId}</small>`;
                container.replaceWith(errorDiv);
            });
        }

        function calculateWhitespace(pbElement, imageHeight) {
            let nextPb = findNextPagebreak(pbElement);
            let textHeight = nextPb ?
                (nextPb.offsetTop - pbElement.offsetTop) : 1000;
            // 50px Puffer für besseren visuellen Abstand
            return Math.max(0, imageHeight - textHeight + 50);
        }

        function insertSpacer(imageContainer, height) {
            const spacer = document.createElement('div');
            spacer.className = 'inline-image-spacer';
            spacer.style.height = height + 'px';
            imageContainer.parentNode.insertBefore(spacer, imageContainer.nextSibling);
        }

        function findNextPagebreak(currentPb) {
            let next = currentPb.nextElementSibling;
            while (next) {
                if (next.classList?.contains('pagebreak')) return next;
                next = next.nextElementSibling;
            }
            return null;
        }

        // Function to update master annotation toggle state based on individual annotation toggles
        function updateMasterAnnotationToggleState() {
            const masterAnnotationToggle = document.getElementById('ef2-slider');
            if (!masterAnnotationToggle) return;
            
            const individualAnnotationToggles = document.querySelectorAll('#langes-s-slider, #gemination-m-slider, #gemination-n-slider, #deleted-slider, #addition-slider');
            const checkedCount = Array.from(individualAnnotationToggles).filter(t => t.checked).length;
            const totalCount = individualAnnotationToggles.length;
            
            const masterSlider = masterAnnotationToggle.nextElementSibling;
            
            if (checkedCount === totalCount) {
                // All checked - master should be checked
                masterAnnotationToggle.checked = true;
                masterSlider.style.backgroundColor = '#A63437';
            } else if (checkedCount === 0) {
                // None checked - master should be unchecked
                masterAnnotationToggle.checked = false;
                masterSlider.style.backgroundColor = '#ccc';
            } else {
                // Some checked - master remains unchecked but keep current color
                masterAnnotationToggle.checked = false;
                masterSlider.style.backgroundColor = '#ccc';
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
            const faksimileToggle = document.getElementById('faksimile-slider');
            
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

            if (faksimileToggle && faksimileToggle.checked) {
                url.searchParams.set('img', '1');
            } else {
                url.searchParams.delete('img');
            }

            // Image mode toggle
            const imageModeToggle = document.getElementById('image-mode-slider');
            if (imageModeToggle && imageModeToggle.checked) {
                url.searchParams.set('imgmode', 'inline');
            } else {
                url.searchParams.delete('imgmode');
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
                'add': 'addition-slider',
                'img': 'faksimile-slider'
            };

            Object.entries(toggleMappings).forEach(([param, toggleId]) => {
                const toggle = document.getElementById(toggleId);
                if (toggle && urlParams.get(param) === '1') {
                    toggle.checked = true;
                    // Trigger change event to apply styles
                    toggle.dispatchEvent(new Event('change'));
                }
            });

            // Handle imgmode parameter separately (value is 'inline', not '1')
            const imageModeToggle = document.getElementById('image-mode-slider');
            if (imageModeToggle && urlParams.get('imgmode') === 'inline') {
                // Only activate if faksimile is enabled
                const faksimileToggle = document.getElementById('faksimile-slider');
                if (faksimileToggle && faksimileToggle.checked) {
                    imageModeToggle.checked = true;
                    imageModeToggle.dispatchEvent(new Event('change'));
                }
            });
        }
        
        // Initialize from URL parameters
        initializeFromURL();
        
        // Update master toggle states after initialization
        updateMasterAnnotationToggleState();
    }, 500);
});

// LoadEditor removed - replaced with standard toggle switch

// Individual entity highlight toggles
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(function() {
        const entityHighlightToggles = document.querySelectorAll('.entity-highlight-toggle input[type="checkbox"]');

        entityHighlightToggles.forEach(function(toggle) {
            const container = toggle.closest('.entity-highlight-toggle');
            const entityId = container.getAttribute('data-entity-id');
            const entityType = container.getAttribute('data-type');

            // Map entity types to their plural forms used in class names
            const typeToClassMap = {
                'person': 'persons',
                'work': 'works',
                'org': 'orgs',
                'event': 'events',
                'place': 'places'
            };

            const entityClass = typeToClassMap[entityType];

            // Color map for each entity type
            const colorMap = {
                'person': '#e74c3c',
                'work': '#f39c12',
                'org': '#9b59b6',
                'event': '#27ae60',
                'place': '#3498db'
            };

            const slider = toggle.nextElementSibling;

            // Initialize slider as grey (unchecked state)
            slider.style.backgroundColor = '#ccc';

            toggle.addEventListener('change', function() {
                // Get the entity color from the colorMap
                const entityColor = colorMap[entityType];
                console.log('Toggle changed for entity:', entityId, 'Type:', entityType, 'Color:', entityColor);

                // Find all entity mentions in the text (not in the modal)
                // Format: <span class="persons badge-item entity"><a href="pmb2121.html">...</a></span>
                const allEntitySpans = document.querySelectorAll('.' + entityClass + '.badge-item.entity');
                const matchingEntities = [];

                allEntitySpans.forEach(function(span) {
                    const link = span.querySelector('a[href="' + entityId + '.html"]');
                    if (link) {
                        matchingEntities.push(span);
                    }
                });

                if (toggle.checked) {
                    // Change slider to entity color
                    slider.style.backgroundColor = entityColor;

                    // Highlight all references to this entity in the text with the entity color
                    matchingEntities.forEach(function(span) {
                        span.style.backgroundColor = entityColor;
                        span.style.padding = '2px 4px';
                        span.style.borderRadius = '3px';
                    });
                } else {
                    // Change slider back to grey
                    slider.style.backgroundColor = '#ccc';

                    // Remove highlight
                    matchingEntities.forEach(function(span) {
                        span.style.backgroundColor = '';
                        span.style.padding = '';
                        span.style.borderRadius = '';
                    });
                }
            });
        });
    }, 500);
});

