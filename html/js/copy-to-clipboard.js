function copyToClipboard(element) {
                    const text = element.textContent || element.innerText;
                    
                    if (navigator.clipboard && navigator.clipboard.writeText) {
                        navigator.clipboard.writeText(text).then(function() {
                            showCopyFeedback(element);
                        }).catch(function(err) {
                            console.error('Fehler beim Kopieren: ', err);
                            fallbackCopyToClipboard(text, element);
                        });
                    } else {
                        fallbackCopyToClipboard(text, element);
                    }
                }
                
                function fallbackCopyToClipboard(text, element) {
                    const textArea = document.createElement('textarea');
                    textArea.value = text;
                    textArea.style.position = 'fixed';
                    textArea.style.left = '-999999px';
                    textArea.style.top = '-999999px';
                    document.body.appendChild(textArea);
                    textArea.focus();
                    textArea.select();
                    
                    try {
                        document.execCommand('copy');
                        showCopyFeedback(element);
                    } catch (err) {
                        console.error('Fallback-Kopieren fehlgeschlagen: ', err);
                        alert('Kopieren fehlgeschlagen. Bitte markieren Sie den Text manuell und drücken Sie Strg+C');
                    }
                    
                    document.body.removeChild(textArea);
                }
                
                function showCopyFeedback(element) {
                    const originalBg = element.style.backgroundColor;
                    const originalBorder = element.style.borderLeft;
                    
                    element.style.backgroundColor = '#d4edda';
                    element.style.borderLeft = '4px solid #28a745';
                    element.title = 'Kopiert!';
                    
                    setTimeout(function() {
                        element.style.backgroundColor = originalBg;
                        element.style.borderLeft = originalBorder;
                        element.title = 'Klicken zum Kopieren';
                    }, 1500);
                }