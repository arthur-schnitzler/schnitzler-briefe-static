/**
 * Toggle commentary mentions visibility
 * Shows/hides mentions that come from commentary notes
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

        const commentaryMentions = document.querySelectorAll('.mention-commentary');
        const toggleText = document.getElementById('toggle-commentary-text');

        commentaryMentions.forEach(function(mention) {
            if (commentaryVisible) {
                mention.style.display = '';
                toggleText.textContent = '&#160;ohne Kommentar';
            } else {
                mention.style.display = 'none';
                toggleText.textContent = '&#160;mit Kommentar';
            }
        });

        // Update button appearance
        if (commentaryVisible) {
            toggleButton.classList.remove('btn-secondary');
            toggleButton.classList.add('btn-outline-secondary');
        } else {
            toggleButton.classList.remove('btn-outline-secondary');
            toggleButton.classList.add('btn-secondary');
        }
    });
});
