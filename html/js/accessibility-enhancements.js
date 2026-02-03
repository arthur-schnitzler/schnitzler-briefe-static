/**
 * Accessibility enhancements for the Schnitzler Briefe website
 * Improves keyboard navigation, screen reader support, and general accessibility
 */

$(document).ready(function() {
    
    // Enhanced keyboard navigation for dropdowns
    $('.dropdown-toggle').on('keydown', function(e) {
        var $dropdown = $(this);
        var $menu = $dropdown.next('.dropdown-menu');
        
        if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
            e.preventDefault();
            if (!$menu.hasClass('show')) {
                $dropdown.dropdown('toggle');
            }
            // Focus first/last item
            var $items = $menu.find('a');
            if (e.key === 'ArrowDown') {
                $items.first().focus();
            } else {
                $items.last().focus();
            }
        } else if (e.key === 'Escape') {
            if ($menu.hasClass('show')) {
                $dropdown.dropdown('toggle');
                $dropdown.focus();
            }
        }
    });
    
    // Keyboard navigation within dropdown menus
    $('.dropdown-menu a').on('keydown', function(e) {
        var $current = $(this);
        var $items = $current.closest('.dropdown-menu').find('a');
        var currentIndex = $items.index($current);
        
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            var nextIndex = (currentIndex + 1) % $items.length;
            $items.eq(nextIndex).focus();
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            var prevIndex = currentIndex > 0 ? currentIndex - 1 : $items.length - 1;
            $items.eq(prevIndex).focus();
        } else if (e.key === 'Escape') {
            e.preventDefault();
            var $toggle = $current.closest('.dropdown').find('.dropdown-toggle');
            $toggle.dropdown('toggle');
            $toggle.focus();
        } else if (e.key === 'Tab') {
            // Let normal tab behavior work, but close dropdown
            $current.closest('.dropdown').find('.dropdown-toggle').dropdown('hide');
        }
    });
    
    // Improve modal accessibility
    $('.modal').on('shown.bs.modal', function() {
        var $modal = $(this);
        
        // Skip accessibility enhancements for the editor-widget modal to avoid interference
        if ($modal.attr('id') === 'editor-widget') {
            return;
        }
        
        // Wait a bit for custom elements (like annotation-slider) to be fully initialized
        setTimeout(function() {
            var $focusableElements = $modal.find('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
            
            // Don't auto-focus if the modal contains de-editor elements to avoid interfering
            if (!$modal.find('annotation-slider, image-switch, font-size').length && $focusableElements.length > 0) {
                $focusableElements.first().focus();
            }
            
            // Trap focus within modal, but allow clicks on annotation-slider elements
            $modal.on('keydown', function(e) {
                // Don't interfere with annotation-slider or other de-editor element interactions
                if ($(e.target).closest('annotation-slider, image-switch, font-size').length) {
                    return true; // Allow normal event handling
                }
                
                if (e.key === 'Tab') {
                    var firstElement = $focusableElements.first()[0];
                    var lastElement = $focusableElements.last()[0];
                    
                    if (e.shiftKey) { // Shift + Tab
                        if (document.activeElement === firstElement) {
                            e.preventDefault();
                            lastElement.focus();
                        }
                    } else { // Tab
                        if (document.activeElement === lastElement) {
                            e.preventDefault();
                            firstElement.focus();
                        }
                    }
                } else if (e.key === 'Escape') {
                    $modal.modal('hide');
                }
            });
        }, 100);
    });
    
    // Announce dynamic content changes to screen readers
    function announceToScreenReader(message, priority = 'polite') {
        var $announcer = $('#screen-reader-announcements');
        if ($announcer.length === 0) {
            $announcer = $('<div id="screen-reader-announcements" aria-live="polite" aria-atomic="true" class="visually-hidden"></div>');
            $('body').append($announcer);
        }
        
        $announcer.attr('aria-live', priority);
        $announcer.text(message);
        
        // Clear after announcement
        setTimeout(function() {
            $announcer.text('');
        }, 1000);
    }
    
    // Enhance table accessibility
    $('table').each(function() {
        var $table = $(this);
        
        // Add table caption if missing but has a preceding heading
        if (!$table.find('caption').length) {
            var $prevHeading = $table.prevAll('h1, h2, h3, h4, h5, h6').first();
            if ($prevHeading.length) {
                $table.prepend('<caption class="visually-hidden">' + $prevHeading.text() + '</caption>');
            }
        }
        
        // Ensure table headers have scope attributes
        $table.find('th').each(function() {
            var $th = $(this);
            if (!$th.attr('scope')) {
                if ($th.closest('thead').length || $th.parent().is(':first-child')) {
                    $th.attr('scope', 'col');
                } else {
                    $th.attr('scope', 'row');
                }
            }
        });
    });
    
    // Improve form accessibility
    $('form').each(function() {
        $(this).find('input, select, textarea').each(function() {
            var $field = $(this);
            var $label = $('label[for="' + $field.attr('id') + '"]');
            
            // If no explicit label, look for nearby text
            if ($label.length === 0) {
                var $prevText = $field.prev();
                if ($prevText.length && $prevText.text().trim()) {
                    var labelId = 'label-' + ($field.attr('id') || 'field-' + Math.random().toString(36).substr(2, 9));
                    $prevText.attr('id', labelId);
                    $field.attr('aria-labelledby', labelId);
                }
            }
            
            // Mark required fields
            if ($field.prop('required') && !$field.attr('aria-required')) {
                $field.attr('aria-required', 'true');
            }
        });
    });
    
    // Add skip links for long lists (excluding TOC)
    $('ul, ol').each(function() {
        var $list = $(this);

        // Skip TOC lists and lists inside TOC
        if ($list.hasClass('toc-list') || $list.closest('#page-toc').length > 0) {
            return;
        }

        if ($list.children('li').length > 20) {
            var listId = $list.attr('id') || 'list-' + Math.random().toString(36).substr(2, 9);
            $list.attr('id', listId);

            var $skipLink = $('<a href="#after-' + listId + '" class="skip-link">Zum Ende der Liste springen ↓</a>');
            var $skipTarget = $('<div id="after-' + listId + '" tabindex="-1"></div>');

            $list.before($skipLink);
            $list.after($skipTarget);
        }
    });
    
    // Enhance button accessibility
    $('button, [role="button"]').each(function() {
        var $btn = $(this);
        
        // Ensure buttons have accessible names
        if (!$btn.attr('aria-label') && !$btn.attr('aria-labelledby') && !$btn.text().trim()) {
            var title = $btn.attr('title');
            if (title) {
                $btn.attr('aria-label', title);
            }
        }
        
        // Add keyboard support for elements with role="button"
        if ($btn.attr('role') === 'button' && !$btn.is('button, input[type="button"], input[type="submit"]')) {
            $btn.attr('tabindex', '0');
            $btn.on('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    $(this).click();
                }
            });
        }
    });
    
    // Expose utility function globally
    window.announceToScreenReader = announceToScreenReader;
    
    // Add ARIA landmarks if missing
    if (!$('main').length && $('#main-content').length) {
        $('#main-content').attr('role', 'main');
    }
    
    if (!$('nav[role="navigation"], nav[aria-label]').length && $('nav').length) {
        $('nav').first().attr('role', 'navigation').attr('aria-label', 'Hauptnavigation');
    }
    
    console.log('Accessibility enhancements loaded');
});

// Add CSS for accessibility helpers
$(document).ready(function() {
    if (!$('#accessibility-css').length) {
        var css = `
            <style id="accessibility-css">
                .visually-hidden {
                    position: absolute !important;
                    width: 1px !important;
                    height: 1px !important;
                    padding: 0 !important;
                    margin: -1px !important;
                    overflow: hidden !important;
                    clip: rect(0, 0, 0, 0) !important;
                    white-space: nowrap !important;
                    border: 0 !important;
                }
                
                .visually-hidden-focusable:focus,
                .visually-hidden-focusable:active {
                    position: static !important;
                    width: auto !important;
                    height: auto !important;
                    padding: inherit !important;
                    margin: inherit !important;
                    overflow: visible !important;
                    clip: auto !important;
                    white-space: inherit !important;
                }
                
                /* Enhanced focus indicators */
                *:focus {
                    outline: 2px solid #005fcc !important;
                    outline-offset: 2px !important;
                }
                
                /* Skip link improvements */
                .skip-link {
                    display: block;
                    text-align: right;
                    padding: 0.25rem 0.5rem;
                    background: #fff;
                    color: #005fcc;
                    text-decoration: none;
                    font-size: 0.875rem;
                    z-index: 9999;
                }

                .skip-link:hover {
                    text-decoration: underline;
                }

                .skip-link:focus {
                    position: static;
                    transform: none;
                }
            </style>
        `;
        $('head').append(css);
    }
});