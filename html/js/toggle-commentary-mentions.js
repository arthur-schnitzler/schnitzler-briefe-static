/**
 * Toggle commentary mentions visibility
 * Shows/hides mentions that come from commentary notes
 * Affects both the list and the SVG chart
 */

document.addEventListener('DOMContentLoaded', function() {
    const toggleButton = document.getElementById('toggle-commentary-mentions');

    if (!toggleButton) {
        // No commentary mentions on this page
        return;
    }

    let commentaryVisible = true; // Start with commentary visible

    toggleButton.addEventListener('click', function() {
        commentaryVisible = !commentaryVisible;

        // Toggle list items
        const commentaryMentions = document.querySelectorAll('.mention-commentary');
        const toggleText = document.getElementById('toggle-commentary-text');

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

        // Update button appearance and text
        if (commentaryVisible) {
            // Commentary is shown - button is "active/on" (red)
            toggleButton.style.backgroundColor = '#A63437';
            toggleButton.style.color = 'white';
            toggleText.textContent = 'Kommentar';
        } else {
            // Commentary is hidden - button is "inactive/off" (grey)
            toggleButton.style.backgroundColor = '#6c757d';
            toggleButton.style.color = 'white';
            toggleText.textContent = 'Kommentar';
        }
    });
});
