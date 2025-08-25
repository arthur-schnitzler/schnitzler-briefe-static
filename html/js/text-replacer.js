// Text replacement functions for de-editor toggles
window.textReplacer = {
    
    // Toggle long s
    toggleLangesS: function(active) {
        const elements = document.querySelectorAll('.langes-s');
        elements.forEach(el => {
            if (active) {
                el.textContent = el.dataset.replacement;
            } else {
                el.textContent = el.dataset.original;
            }
        });
    },
    
    // Toggle gemination m
    toggleGeminationM: function(active) {
        const elements = document.querySelectorAll('.gemination-m');
        elements.forEach(el => {
            if (active) {
                el.textContent = el.dataset.replacement;
            } else {
                el.textContent = el.dataset.original;
            }
        });
    },
    
    // Toggle gemination n
    toggleGeminationN: function(active) {
        const elements = document.querySelectorAll('.gemination-n');
        elements.forEach(el => {
            if (active) {
                el.textContent = el.dataset.replacement;
            } else {
                el.textContent = el.dataset.original;
            }
        });
    }
};