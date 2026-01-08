/**
 * Lemma Anchor Scroll and Highlight
 *
 * This script handles clicking on lemma links to scroll to the corresponding
 * anchor in the text and highlight it with an animation.
 */

document.addEventListener('DOMContentLoaded', function() {
    // Get all lemma links
    const lemmaLinks = document.querySelectorAll('a.lemma');

    lemmaLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // Get the target anchor ID from the href
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);

            if (targetElement) {
                // Scroll to the target with smooth behavior
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });

                // Add highlight class to create the pulsing effect
                targetElement.classList.add('highlight-anchor');

                // Remove the highlight class after animation completes
                setTimeout(() => {
                    targetElement.classList.remove('highlight-anchor');
                }, 2000); // Match the animation duration in CSS
            }
        });
    });

    // Also handle direct links with hash (e.g., page loads with #K_L00001-1)
    if (window.location.hash) {
        const targetId = window.location.hash.substring(1);
        const targetElement = document.getElementById(targetId);

        if (targetElement && targetId.startsWith('K_')) {
            // Wait a bit for the page to fully load
            setTimeout(() => {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });

                targetElement.classList.add('highlight-anchor');

                setTimeout(() => {
                    targetElement.classList.remove('highlight-anchor');
                }, 2000);
            }, 100);
        }
    }
});
