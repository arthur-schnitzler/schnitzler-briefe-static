 // Code taken from ARCHE Website
 
 $(function() { 
     
    
    $(document ).delegate( "#copyLinkInputBtn", "click keydown", function(e) {
        if (e.type === 'keydown' && e.which !== 13 && e.which !== 32) {
            return;
        }
        e.preventDefault();
        var URLtoCopy = $(this).data("copyuri");
        var result = copyToClipboard(URLtoCopy);
        if (result) {
	        $('#copyLinkTextfield').val("Nachweis ist in die Zwischenablage kopiert!");
	        $(this).attr('aria-label', 'Nachweis wurde kopiert');
	        setTimeout(function() { 
	            $('#copyLinkTextfield').val(URLtoCopy); 
	            $('#copyLinkInputBtn').attr('aria-label', 'Nachweis in Zwischenablage kopieren');
	        }, 2000);
        }
    });
    
    
    $(document).on({
    mouseenter: function () {
        $(this).find('#copyLinkTextfield-wrapper').fadeIn();
    },
    mouseleave: function () {
        $(this).find('#copyLinkTextfield-wrapper').fadeOut();
    }
}, '#res-act-button-copy-url');
     
     
     $(document ).delegate( "#copy-cite-btn", "click keydown", function(e) {
        if (e.type === 'keydown' && e.which !== 13 && e.which !== 32) {
            return;
        }
        e.preventDefault();
        var URLtoCopy = $('.cite-content.active').html();
        var result = copyToClipboard(URLtoCopy);
        if (result) {
            $('#copy-cite-btn-confirmation').fadeIn(100);
            $(this).attr('aria-label', 'Zitat wurde kopiert');
            setTimeout(function() { 
                $('#copy-cite-btn-confirmation').fadeOut(200); 
                $('#copy-cite-btn').attr('aria-label', 'Zitat in Zwischenablage kopieren');
            }, 2000);
        }
     });
    
});

// Copies a string to the clipboard. Must be called from within an event handler such as click.
// May return false if it failed, but this is not always
// possible. Browser support for Chrome 43+, Firefox 42+, Edge and IE 10+, Safari 10+.
// IE: The clipboard feature may be disabled by an adminstrator. By default a prompt is
// shown the first time the clipboard is used (per session).
function copyToClipboard(text) {
    if (window.clipboardData && window.clipboardData.setData) {
        // IE specific code path to prevent textarea being shown while dialog is visible.
        return clipboardData.setData("Text", text); 

    } else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        var textarea = document.createElement("textarea");
        textarea.textContent = text;
        textarea.style.position = "fixed";  // Prevent scrolling to bottom of page in MS Edge.
        document.body.appendChild(textarea);
        textarea.select();
        try {
            return document.execCommand("copy");  // Security exception may be thrown by some browsers.
        } catch (ex) {
            console.warn("Copy to clipboard failed.", ex);
            return false;
        } finally {
            document.body.removeChild(textarea);
        }
    }
}