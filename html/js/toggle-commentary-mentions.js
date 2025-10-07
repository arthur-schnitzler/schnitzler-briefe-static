/**
 * Toggle commentary mentions visibility
 * Shows/hides mentions that come from commentary notes
 * Affects the list, SVG chart, and dynamically updates counts
 */

document.addEventListener('DOMContentLoaded', function() {
    const toggleCheckbox = document.getElementById('toggle-commentary-mentions');

    if (!toggleCheckbox) {
        // No commentary mentions on this page
        return;
    }

    // Function to count visible items in a container
    function countVisibleItems(container) {
        const items = container.querySelectorAll('li');
        let count = 0;
        items.forEach(function(item) {
            if (item.style.display !== 'none') {
                count++;
            }
        });
        return count;
    }

    // Function to update visibility based on checkbox state
    function updateCommentaryVisibility() {
        const commentaryVisible = toggleCheckbox.checked;

        // Update slider color based on state
        const slider = toggleCheckbox.nextElementSibling;
        if (slider && slider.classList.contains('i-slider')) {
            if (commentaryVisible) {
                slider.style.backgroundColor = '#A63437'; // Red when checked
            } else {
                slider.style.backgroundColor = '#ccc'; // Grey when unchecked
            }
        }

        // Toggle list items
        const commentaryMentions = document.querySelectorAll('.mention-commentary');
        commentaryMentions.forEach(function(mention) {
            if (commentaryVisible) {
                mention.style.display = '';
            } else {
                mention.style.display = 'none';
            }
        });

        // Toggle SVG bars for commentary-only mentions
        const commentaryBars = document.querySelectorAll('rect[data-type="commentary"]');
        commentaryBars.forEach(function(bar) {
            if (commentaryVisible) {
                bar.style.display = '';
            } else {
                bar.style.display = 'none';
            }
        });

        // Update accordion headers dynamically
        const accordionButtons = document.querySelectorAll('#mentionsAccordion .accordion-button');
        accordionButtons.forEach(function(button) {
            // Extract year from button text
            const buttonText = button.textContent.trim();
            const yearMatch = buttonText.match(/^(\d{4})/);

            if (yearMatch) {
                const year = yearMatch[1];
                const accordionId = button.getAttribute('data-bs-target').replace('#', '');
                const accordionBody = document.getElementById(accordionId);

                if (accordionBody) {
                    // Count visible items in this year's accordion
                    const visibleCount = countVisibleItems(accordionBody);

                    // Update button text
                    if (visibleCount === 1) {
                        button.textContent = year + ' (1 Eintrag)';
                    } else if (visibleCount > 1) {
                        button.textContent = year + ' (' + visibleCount + ' Einträge)';
                    } else {
                        button.textContent = year + ' (0 Einträge)';
                    }

                    // Hide accordion item if no visible entries
                    const accordionItem = button.closest('.accordion-item');
                    if (visibleCount === 0) {
                        accordionItem.style.display = 'none';
                    } else {
                        accordionItem.style.display = '';
                    }
                }
            }
        });

        // Update month headers within accordions (for years with >10 entries)
        const monthHeaders = document.querySelectorAll('#mentionsAccordion h3');
        monthHeaders.forEach(function(header) {
            const list = header.nextElementSibling;
            if (list && list.tagName === 'UL') {
                const visibleCount = countVisibleItems(list);

                // Hide month section if no visible entries
                if (visibleCount === 0) {
                    header.style.display = 'none';
                    list.style.display = 'none';
                } else {
                    header.style.display = '';
                    list.style.display = '';
                }
            }
        });

        // Handle simple list (<=10 entries) - show message if all hidden
        const simpleList = document.getElementById('simple-mentions-list');
        if (simpleList) {
            const visibleCount = countVisibleItems(simpleList);

            // Check if message already exists
            let noEntriesMessage = simpleList.nextElementSibling;
            if (!noEntriesMessage || !noEntriesMessage.classList.contains('no-entries-message')) {
                noEntriesMessage = document.createElement('p');
                noEntriesMessage.className = 'no-entries-message text-muted';
                noEntriesMessage.textContent = 'Keine Erwähnungen im Editionstext.';
                simpleList.parentNode.insertBefore(noEntriesMessage, simpleList.nextSibling);
            }

            if (visibleCount === 0) {
                simpleList.style.display = 'none';
                noEntriesMessage.style.display = '';
            } else {
                simpleList.style.display = '';
                noEntriesMessage.style.display = 'none';
            }
        }
    }

    // Listen to checkbox change events
    toggleCheckbox.addEventListener('change', updateCommentaryVisibility);

    // Initialize visibility on page load
    updateCommentaryVisibility();
});
