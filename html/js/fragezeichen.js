(function() {
  const url = window.location.href;
  if (url.endsWith('?')) {
    const newUrl = url.slice(0, -1); // Entfernt das letzte Zeichen (das Fragezeichen)
    window.history.replaceState(null, '', newUrl);
  }
})();