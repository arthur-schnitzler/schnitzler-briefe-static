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

            // Initialize the state on page load based on checkbox status
            // For unchecked toggles, trigger change event to hide entities
            if (!toggle.checked) {
                // Find all entities that have the current entity type class
                const allEntities = document.querySelectorAll('.entity');
                allEntities.forEach(function(entity) {
                    if (entity.classList.contains(entityType)) {
                        entity.classList.add('entity-hidden');
                    }
                });
                // Update slider color to grey
                const slider = toggle.nextElementSibling;
                slider.style.backgroundColor = '#ccc';
            }
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
                console.log('Image mode toggle changed, checked:', imageModeToggle.checked);
                const transcriptContainer = document.querySelector('.transcript');
                const slider = imageModeToggle.nextElementSibling;

                if (imageModeToggle.checked) {
                    console.log('Enabling inline image mode...');
                    enableInlineImageMode(transcriptContainer);
                    slider.style.backgroundColor = '#A63437';
                } else {
                    console.log('Disabling inline image mode...');
                    disableInlineImageMode(transcriptContainer);
                    slider.style.backgroundColor = '#ccc';
                }

                updateURLParameters();
            });

            // Initial state: Bildmodus nur verfügbar wenn Faksimile aktiv
            if (faksimileToggle.checked) {
                imageModeToggle.disabled = false;
                document.getElementById('imgmode-toggle-container').style.opacity = '1';
            } else {
                imageModeToggle.disabled = true;
                document.getElementById('imgmode-toggle-container').style.opacity = '0.5';
            }
        }

        async function enableInlineImageMode(container) {
            console.log('enableInlineImageMode called', container);
            if (!container) {
                console.warn('No container found for inline image mode');
                return;
            }

            container.classList.add('inline-mode');

            // Hide the original two-column layout
            const textCol = container.querySelector('.text');
            const facsimilesCol = container.querySelector('.facsimiles');

            if (textCol) textCol.style.display = 'none';
            if (facsimilesCol) facsimilesCol.style.display = 'none';

            // Get all pagebreaks from the text
            const pagebreaks = container.querySelectorAll('.pagebreak[data-facs]');
            console.log('Found pagebreaks with data-facs:', pagebreaks.length);

            // Create new container for paired rows
            let pairedContainer = container.querySelector('#paired-text-images-container');
            if (!pairedContainer) {
                pairedContainer = document.createElement('div');
                pairedContainer.id = 'paired-text-images-container';
                pairedContainer.className = 'container-fluid';
                // Insert at the beginning of the container, before all other content
                container.insertBefore(pairedContainer, container.firstChild);
            } else {
                // Clear existing content
                pairedContainer.innerHTML = '';
            }

            // Build paired rows: one row per pagebreak section
            for (let i = 0; i < pagebreaks.length; i++) {
                const pbElement = pagebreaks[i];
                const nextPbElement = pagebreaks[i + 1] || null;
                const facsId = pbElement.getAttribute('data-facs');

                if (!facsId) continue;

                // Extract text between this pb and the next pb
                const textContent = extractTextBetweenPagebreaks(pbElement, nextPbElement);

                // Get IIIF URL for this pagebreak
                const iiifUrl = extractIIIFUrlFromTileSources(facsId);

                if (!iiifUrl) {
                    console.warn(`No IIIF URL found for ${facsId}, skipping this section`);
                    // Still create a row with just text, no image
                    const row = createPairedRow(textContent, null, i + 1, facsId);
                    pairedContainer.appendChild(row);
                    continue;
                }

                // Create paired row with text and image
                const row = createPairedRow(textContent, iiifUrl, i + 1, facsId);
                pairedContainer.appendChild(row);
            }

            console.log('Paired rows created');
        }

        function extractTextBetweenPagebreaks(startPb, endPb) {
            // Find the parent text container
            const textColumn = startPb.closest('.text');
            if (!textColumn) {
                console.warn('Could not find .text parent for pagebreak');
                return document.createElement('div');
            }

            // Create a Range to extract content between the two pagebreaks
            const range = document.createRange();

            // Set the start after the startPb element
            range.setStartAfter(startPb);

            // Set the end: either before endPb, or at the end of textColumn
            if (endPb) {
                range.setEndBefore(endPb);
            } else {
                range.setEndAfter(textColumn.lastChild);
            }

            // Clone the range contents
            const clonedContents = range.cloneContents();

            // Create final container with editionText class
            const textContainer = document.createElement('div');
            textContainer.className = 'text-section editionText';

            // Add the startPb itself at the beginning
            textContainer.appendChild(startPb.cloneNode(true));

            // Add the extracted content
            textContainer.appendChild(clonedContents);

            return textContainer;
        }

        function createPairedRow(textContent, iiifUrl, pageNum, facsId) {
            // Create Bootstrap row
            const row = document.createElement('div');
            row.className = 'row paired-text-image-row mb-4';
            row.setAttribute('data-page', pageNum);
            row.setAttribute('data-facs', facsId);

            // Create text column (left, 50%)
            const textCol = document.createElement('div');
            textCol.className = 'col-md-6 paired-text-col';
            textCol.appendChild(textContent);

            // Create image column (right, 50%)
            const imageCol = document.createElement('div');
            imageCol.className = 'col-md-6 paired-image-col';

            if (iiifUrl) {
                // Create image element
                const img = document.createElement('img');
                img.className = 'paired-facsimile img-fluid';
                img.alt = `Seite ${pageNum}`;

                // Get IIIF image URL (1200px width)
                const imageUrl = iiifUrl.replace('/info.json', `/full/,1200/0/default.jpg`);
                img.src = imageUrl;
                img.style.width = '100%';
                img.style.height = 'auto';

                imageCol.appendChild(img);

                // Add error handling
                img.addEventListener('error', function() {
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-warning';
                    errorDiv.textContent = `Bild konnte nicht geladen werden (${facsId})`;
                    imageCol.innerHTML = '';
                    imageCol.appendChild(errorDiv);
                });
            } else {
                // No image available
                const noImageDiv = document.createElement('div');
                noImageDiv.className = 'alert alert-info';
                noImageDiv.textContent = 'Kein Bild verfügbar';
                imageCol.appendChild(noImageDiv);
            }

            // Append columns to row
            row.appendChild(textCol);
            row.appendChild(imageCol);

            return row;
        }

        function synchronizeImagePositions(pagebreaks, inlineContainer) {
            console.log('Synchronizing image positions...');

            const textColumn = document.querySelector('.text');
            const facsimilesColumn = document.querySelector('.facsimiles');

            if (!textColumn || !facsimilesColumn) {
                console.error('Text or facsimiles column not found');
                return;
            }

            // Get the top offset of both columns relative to the page
            const textColumnRect = textColumn.getBoundingClientRect();
            const facsimilesRect = facsimilesColumn.getBoundingClientRect();
            const inlineContainerRect = inlineContainer.getBoundingClientRect();

            console.log('Text column top:', textColumnRect.top);
            console.log('Facsimiles column top:', facsimilesRect.top);
            console.log('Inline container top:', inlineContainerRect.top);

            // Build a list of pb elements that actually have images
            const pbWithImages = [];
            for (let i = 0; i < pagebreaks.length; i++) {
                const pbElement = pagebreaks[i];
                const facsId = pbElement.getAttribute('data-facs');
                if (!facsId) continue;

                // Get ALL image containers with this facsId (there might be duplicates)
                const imageContainers = inlineContainer.querySelectorAll(`.inline-image-container[data-facs="${facsId}"]`);

                if (imageContainers.length > 0) {
                    // For now, use the first matching container
                    // TODO: In case of duplicates, we might need more sophisticated matching
                    pbWithImages.push({
                        pb: pbElement,
                        facs: facsId,
                        container: imageContainers[0],
                        originalIndex: i
                    });
                }
            }

            console.log(`Found ${pbWithImages.length} pagebreaks with images out of ${pagebreaks.length} total pagebreaks`);

            // Now synchronize only the pb elements that have images
            for (let i = 0; i < pbWithImages.length; i++) {
                const { pb: pbElement, facs: facsId, container: imageContainer, originalIndex } = pbWithImages[i];
                const nextPbWithImage = pbWithImages[i + 1];

                // Calculate the vertical position of this pb element relative to viewport
                const pbRect = pbElement.getBoundingClientRect();
                const pbOffsetFromTextTop = pbRect.top - textColumnRect.top;

                console.log(`PB ${originalIndex + 1} (${facsId}):`, pbOffsetFromTextTop);

                // Get current position of this image relative to inline container
                const imageContainerRect = imageContainer.getBoundingClientRect();
                const imageOffsetFromContainerTop = imageContainerRect.top - inlineContainerRect.top;

                console.log(`Image ${i + 1} offset from container:`, imageOffsetFromContainerTop);

                // Calculate how much space we need before this image
                // We want the image to start at the same offset from the top as the pb element
                const neededSpaceBefore = pbOffsetFromTextTop - imageOffsetFromContainerTop;

                console.log(`Needed space before image ${i + 1}:`, neededSpaceBefore);

                if (neededSpaceBefore > 5) { // Use a small threshold to avoid tiny spacers
                    // Add a spacer div before the image
                    const spacer = document.createElement('div');
                    spacer.className = 'image-position-spacer';
                    spacer.style.height = neededSpaceBefore + 'px';
                    spacer.style.backgroundColor = 'transparent';
                    imageContainer.parentNode.insertBefore(spacer, imageContainer);
                    console.log(`Added spacer of ${neededSpaceBefore}px before image ${i + 1}`);
                }

                // Calculate spacing after this image
                if (nextPbWithImage) {
                    // Use the next pb that has an image
                    const nextPbRect = nextPbWithImage.pb.getBoundingClientRect();
                    const textSectionHeight = nextPbRect.top - pbRect.top;

                    const img = imageContainer.querySelector('img');
                    if (img && img.complete) {
                        const imageHeight = img.naturalHeight || img.height;

                        console.log(`Text section from PB ${originalIndex + 1} to ${nextPbWithImage.originalIndex + 1}:`, textSectionHeight, 'Image height:', imageHeight);

                        // If image is shorter than text section, add whitespace after
                        if (imageHeight < textSectionHeight - 10) { // Use threshold
                            const spacerAfter = document.createElement('div');
                            spacerAfter.className = 'image-whitespace-spacer';
                            const whiteSpaceHeight = textSectionHeight - imageHeight;
                            spacerAfter.style.height = whiteSpaceHeight + 'px';
                            spacerAfter.style.backgroundColor = 'transparent';
                            imageContainer.appendChild(spacerAfter);
                            console.log(`Added whitespace of ${whiteSpaceHeight}px after image ${i + 1}`);
                        }
                    }
                }
            }

            console.log('Synchronization complete');
        }

        function disableInlineImageMode(container) {
            console.log('Disabling inline image mode');
            if (!container) {
                console.warn('No container in disableInlineImageMode');
                return;
            }

            container.classList.remove('inline-mode');

            // Show original two-column layout again
            const textCol = container.querySelector('.text');
            const facsimilesCol = container.querySelector('.facsimiles');

            if (textCol) textCol.style.display = '';
            if (facsimilesCol) facsimilesCol.style.display = '';

            // Show Openseadragon viewer again
            const osdViewer = document.getElementById('openseadragon-photo');
            if (osdViewer) {
                osdViewer.style.display = 'block';
            }

            // Remove paired container
            const pairedContainer = document.getElementById('paired-text-images-container');
            if (pairedContainer) {
                pairedContainer.remove();
            }

            // Also remove old inline container if it exists
            const inlineContainer = document.getElementById('inline-images-container');
            if (inlineContainer) {
                inlineContainer.remove();
            }
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
                            // Find the URL that matches this facs ID exactly
                            // The URL format is: .../HS.NZ85.1.3163_0040-0.jp2/info.json
                            for (let urlStr of urls) {
                                const url = urlStr.replace(/"/g, '');
                                // Extract just the image ID part (between last two slashes, before /info.json)
                                const parts = url.split('/');
                                // parts[-2] is the image file with extension, parts[-1] is "info.json"
                                if (parts.length >= 2) {
                                    const imageFileWithExt = parts[parts.length - 2];
                                    // Remove the file extension (.jp2, .jpg, etc.)
                                    const imageId = imageFileWithExt.replace(/\.(jp2|jpg|jpeg|png|tif|tiff)$/i, '');

                                    console.log(`Comparing facsId "${facsId}" with imageId "${imageId}"`);

                                    // Exact match
                                    if (imageId === facsId) {
                                        console.log(`✓ Exact match found: ${url}`);
                                        return url;
                                    }
                                }
                            }

                            // If no exact match, log warning
                            console.warn(`No exact match found for facsId: ${facsId}`);
                        }
                    }
                }
            }
            return null;
        }

        async function insertInlineImageInRightColumn(pbElement, pageNum, rightColumnContainer) {
            const facsId = pbElement.getAttribute('data-facs');

            // Check if this facsId was already used
            const existingContainers = rightColumnContainer.querySelectorAll(`[data-facs="${facsId}"]`);
            const isDuplicate = existingContainers.length > 0;

            console.log(`Processing pagebreak ${pageNum}, facs ID: ${facsId}${isDuplicate ? ' (DUPLICATE - will show again)' : ''}`);

            if (!facsId) {
                console.warn(`No facs ID for pagebreak ${pageNum}`);
                return;
            }

            // Extract IIIF URL from Openseadragon tileSources
            const iiifUrl = extractIIIFUrlFromTileSources(facsId);
            console.log(`IIIF URL for ${facsId}:`, iiifUrl);

            if (!iiifUrl) {
                console.warn(`Could not find IIIF URL for facs ID: ${facsId}`);
                return;
            }

            const container = document.createElement('div');
            container.className = 'inline-image-container';
            if (isDuplicate) {
                container.classList.add('duplicate-image');
            }
            container.setAttribute('data-facs', facsId);
            container.setAttribute('data-page-num', pageNum);

            const img = document.createElement('img');
            img.className = 'inline-facsimile';
            img.alt = `Seite ${pageNum}`;

            // Images up to 1200px wide
            const imageUrl = iiifUrl.replace('/info.json', `/full/,1200/0/default.jpg`);
            img.src = imageUrl;
            img.style.width = '100%';
            img.style.height = 'auto';
            img.style.display = 'block';
            img.style.marginBottom = '2rem';

            container.appendChild(img);

            // Add to right column container
            rightColumnContainer.appendChild(container);

            // Add scroll synchronization: when clicking image, scroll text to corresponding pagebreak
            container.addEventListener('click', function() {
                pbElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });

            img.addEventListener('error', function() {
                const errorDiv = document.createElement('div');
                errorDiv.className = 'inline-image-error';
                errorDiv.innerHTML = `<strong>⚠ Bild konnte nicht geladen werden</strong><br><small>Faksimile-ID: ${facsId}</small>`;
                container.replaceWith(errorDiv);
            });
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
            }
        }
        
        // Initialize from URL parameters
        initializeFromURL();
        
        // Update master toggle states after initialization
        updateMasterAnnotationToggleState();
    }, 500);
});

// LoadEditor removed - replaced with standard toggle switch

// Individual entity highlight toggles - event delegation for robustness
(function() {
    const typeToClassMap = {
        'person': 'persons',
        'work': 'works',
        'org': 'orgs',
        'event': 'events',
        'place': 'places'
    };

    const colorMap = {
        'person': '#e74c3c',
        'work': '#f39c12',
        'org': '#9b59b6',
        'event': '#27ae60',
        'place': '#3498db'
    };

    function findMatchingEntitySpans(entityId, entityClass) {
        const transcriptContainer = document.querySelector('.transcript');
        if (!transcriptContainer) return [];

        const allEntitySpans = transcriptContainer.querySelectorAll('.' + entityClass + '.entity');
        const matchingEntities = [];

        allEntitySpans.forEach(function(span) {
            const hrefLink = span.querySelector('a[href="' + entityId + '.html"]');
            if (hrefLink) {
                matchingEntities.push(span);
                return;
            }
            const modalLink = span.querySelector('a[data-bs-target]');
            if (modalLink) {
                const target = modalLink.getAttribute('data-bs-target');
                if (target && target.includes(entityId)) {
                    matchingEntities.push(span);
                }
            }
        });

        return matchingEntities;
    }

    // Event delegation: handles clicks regardless of when the modal content is rendered
    document.addEventListener('change', function(e) {
        const toggle = e.target;
        if (!toggle.matches('.entity-highlight-toggle input[type="checkbox"]')) return;

        const container = toggle.closest('.entity-highlight-toggle');
        const entityId = container.getAttribute('data-entity-id');
        const entityType = container.getAttribute('data-type');
        const entityClass = typeToClassMap[entityType];
        const entityColor = colorMap[entityType];
        const slider = toggle.nextElementSibling;

        const matchingEntities = findMatchingEntitySpans(entityId, entityClass);

        if (toggle.checked) {
            slider.style.backgroundColor = entityColor;
            matchingEntities.forEach(function(span) {
                // Use setProperty with 'important' to override any entity-hidden CSS rule
                span.style.setProperty('background-color', entityColor, 'important');
                span.style.padding = '2px 4px';
                span.style.borderRadius = '3px';
            });
        } else {
            slider.style.backgroundColor = '#ccc';
            matchingEntities.forEach(function(span) {
                span.style.removeProperty('background-color');
                span.style.padding = '';
                span.style.borderRadius = '';
            });
        }
    });
}());

