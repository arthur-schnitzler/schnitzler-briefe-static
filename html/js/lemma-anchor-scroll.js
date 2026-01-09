/**
 * Lemma Anchor Scroll and Highlight
 *
 * This script handles clicking on lemma links to scroll to the corresponding
 * anchor in the text and highlight it with an animation.
 */

document.addEventListener('DOMContentLoaded', function() {

    function highlightAnchor(targetElement) {
        if (!targetElement) return;

        // Scroll to the target with smooth behavior
        targetElement.scrollIntoView({
            behavior: 'smooth',
            block: 'center'
        });

        // Wait a moment for scroll to complete before highlighting
        setTimeout(() => {
            const anchorId = targetElement.id || targetElement.getAttribute('data-corresp');
            if (!anchorId) return;

            // Find the start and end markers
            const startMarker = document.querySelector(`.lemma-anchor-start[data-corresp="${anchorId}"]`);
            const endMarker = document.querySelector(`.lemma-anchor-end[data-corresp="${anchorId}"]`);

            if (!startMarker || !endMarker) {
                console.warn('Could not find anchor markers for', anchorId);
                return;
            }

            // Collect all elements between start and end marker
            let currentNode = startMarker.nextSibling;
            const nodesToHighlight = [];

            while (currentNode && currentNode !== endMarker) {
                if (currentNode.nodeType === Node.ELEMENT_NODE) {
                    nodesToHighlight.push(currentNode);
                } else if (currentNode.nodeType === Node.TEXT_NODE && currentNode.textContent.trim()) {
                    // For text nodes, we need to create a span wrapper
                    const wrapper = document.createElement('span');
                    wrapper.textContent = currentNode.textContent;
                    currentNode.parentNode.replaceChild(wrapper, currentNode);
                    nodesToHighlight.push(wrapper);
                    currentNode = wrapper;
                }
                currentNode = currentNode.nextSibling;
            }

            // Highlight all collected elements
            nodesToHighlight.forEach(node => {
                const originalBg = node.style.backgroundColor;
                const originalShadow = node.style.boxShadow;
                const originalPadding = node.style.padding;
                const originalBorderRadius = node.style.borderRadius;

                node.style.backgroundColor = 'rgba(166, 52, 55, 0.3)';
                node.style.boxShadow = '0 0 10px rgba(166, 52, 55, 0.4)';
                node.style.padding = '2px 4px';
                node.style.borderRadius = '3px';
                node.style.transition = 'all 0.3s ease-out';

                // Fade out animation
                let opacity = 0.3;
                const fadeInterval = setInterval(() => {
                    opacity -= 0.02;
                    if (opacity <= 0) {
                        clearInterval(fadeInterval);
                        // Restore original styles
                        node.style.backgroundColor = originalBg;
                        node.style.boxShadow = originalShadow;
                        node.style.padding = originalPadding;
                        node.style.borderRadius = originalBorderRadius;
                    } else {
                        node.style.backgroundColor = `rgba(166, 52, 55, ${opacity})`;
                        node.style.boxShadow = `0 0 10px rgba(166, 52, 55, ${opacity * 1.3})`;
                    }
                }, 100);
            });
        }, 600); // Wait for scroll to finish
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
