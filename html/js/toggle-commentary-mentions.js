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

        // Update year-details headers dynamically (details/summary structure)
        const yearDetails = document.querySelectorAll('.year-details');
        yearDetails.forEach(function(details) {
            const summary = details.querySelector('.year-summary');
            if (!summary) return;

            // Extract year from summary text
            const summaryText = summary.textContent.trim();
            const yearMatch = summaryText.match(/^(\d{4})/);
            if (!yearMatch) return;

            const year = yearMatch[1];
            const yearContent = details.querySelector('.year-content');
            if (!yearContent) return;

            // Count visible items in this year's content
            const visibleCount = countVisibleItems(yearContent);

            // Update summary text
            if (visibleCount === 1) {
                summary.textContent = year + ' (1 Eintrag)';
            } else {
                summary.textContent = year + ' (' + visibleCount + ' Einträge)';
            }

            // Hide year section if no visible entries
            if (visibleCount === 0) {
                details.style.display = 'none';
            } else {
                details.style.display = '';
            }
        });

        // Update month-details within year sections
        const monthDetails = document.querySelectorAll('.month-details');
        monthDetails.forEach(function(details) {
            const monthContent = details.querySelector('.month-content');
            if (!monthContent) return;

            const visibleCount = countVisibleItems(monthContent);

            // Hide month section if no visible entries
            if (visibleCount === 0) {
                details.style.display = 'none';
            } else {
                details.style.display = '';
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
