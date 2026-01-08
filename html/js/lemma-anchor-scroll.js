/**
 * Lemma Anchor Scroll and Highlight
 *
 * This script handles clicking on lemma links to scroll to the corresponding
 * anchor in the text and highlight it with an animation.
 */

document.addEventListener('DOMContentLoaded', function() {

    function highlightAnchor(targetElement) {
        if (!targetElement) return;

        // Wait for scroll to finish, then highlight
        setTimeout(() => {
            // Scroll to the target with smooth behavior
            targetElement.scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });

            // Wait a moment for scroll to complete before highlighting
            setTimeout(() => {
                // Get the position of the target or its next visible sibling
                let referenceElement = targetElement;
                if (targetElement.tagName === 'SPAN' && !targetElement.textContent.trim()) {
                    referenceElement = targetElement.nextElementSibling || targetElement;
                }

                // Create a visual highlight marker
                const highlight = document.createElement('div');
                highlight.className = 'highlight-anchor-marker';

                const rect = referenceElement.getBoundingClientRect();
                const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;

                // Position the highlight
                highlight.style.cssText = `
                    position: absolute;
                    top: ${rect.top + scrollTop - 4}px;
                    left: ${rect.left + scrollLeft - 4}px;
                    width: ${rect.width + 8}px;
                    height: ${rect.height + 8}px;
                    background-color: rgba(255, 255, 0, 0.7);
                    pointer-events: none;
                    z-index: 1000;
                    border-radius: 4px;
                    box-shadow: 0 0 15px rgba(255, 255, 0, 0.7);
                `;

                document.body.appendChild(highlight);

                // Fade out animation
                let opacity = 0.7;
                const fadeInterval = setInterval(() => {
                    opacity -= 0.05;
                    if (opacity <= 0) {
                        clearInterval(fadeInterval);
                        highlight.remove();
                    } else {
                        highlight.style.backgroundColor = `rgba(255, 255, 0, ${opacity})`;
                        highlight.style.boxShadow = `0 0 15px rgba(255, 255, 0, ${opacity})`;
                    }
                }, 100);
            }, 500); // Wait for scroll to finish
        }, 100);
    }

    // Get all lemma links
    const lemmaLinks = document.querySelectorAll('a.lemma');

    lemmaLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // Get the target anchor ID from the href
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);

            if (targetElement) {
                highlightAnchor(targetElement);
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
                highlightAnchor(targetElement);
            }, 300);
        }
    }
});
