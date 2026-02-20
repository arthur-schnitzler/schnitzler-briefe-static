# Brief-Statistiken

Diese Funktionalität generiert dynamische Statistiken aus den Brief-XMLs im `data/editions/` Ordner.

## Dateien

### Python-Script
- **`python/generate_letter_statistics.py`**: Analysiert alle Brief-XMLs und erstellt Statistiken

### XSLT-Stylesheet
- **`xslt/statistics.xsl`**: Transformiert die Statistik-XML in HTML mit interaktiven Charts

### Output-Dateien
- **`data/meta/statistiken-dynamisch.xml`**: TEI-XML mit den generierten Statistiken
- **`html/js-data/letterStatistics.json`**: JSON-Format für Weiterverarbeitung
- **`html/js-data/letterStatistics.js`**: JavaScript-Variable für Charts
- **`html/statistiken-dynamisch.html`**: Die finale HTML-Seite

## Verwendung

### Manuell
```bash
# Statistiken generieren
python3 python/generate_letter_statistics.py

# HTML erstellen
ant
```

### Automatisch (Teil des Build-Prozesses)
```bash
./transform.sh
```

Das Script wird automatisch zwischen `python/make_calendar_data.py` und `python/fetch_cmif_data.py` ausgeführt.

## Generierte Statistiken

- **Gesamtanzahl**: Briefe insgesamt
- **Nach Rolle**: Briefe von/an Schnitzler, Umfeldbriefe
- **Nach Jahr**: Zeitliche Verteilung
- **Nach Korrespondenz**: Häufigste Korrespondenzpartner
- **Nach Absender/Empfänger**: Detaillierte Personenstatistiken
- **Textlänge**: Umfang nach Jahren

## Visualisierungen

Die HTML-Seite enthält interaktive Charts (Chart.js):
1. Balkendiagramm: Briefe nach Jahren
2. Tortendiagramm: Verteilung nach Schnitzlers Rolle
3. Horizontales Balkendiagramm: Top 10 Korrespondenzen

## Hinweis

⚠️ **Wichtig**: Die lokalen Daten in `data/editions/` sind nicht die finalen Produktionsdaten. Die Statistiken basieren auf dem aktuellen Stand des lokalen Repositories.

## Integration in die Website

Die generierte Seite ist unter `html/statistiken-dynamisch.html` verfügbar und kann über die Navigation verlinkt werden. Sie ergänzt die bestehende statische Statistikseite (`statistiken.html`).