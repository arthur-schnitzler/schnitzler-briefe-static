# SEO Features für Schnitzler Briefe

Diese Dokumentation beschreibt alle implementierten SEO-Verbesserungen für die Schnitzler Briefe Website.

## Übersicht der implementierten Features

### 1. Sitemap-Generierung (`python/generate_sitemap.py`)

**Features:**
- Automatische Generierung einer XML-Sitemap mit allen Briefen und statischen Seiten
- Prioritätswerte basierend auf Content-Typ
- Lastmod-Daten basierend auf Brief-Daten
- Changefreq-Angaben für verschiedene Seitentypen
- Über 3000+ URLs in der Sitemap

**URLs enthalten:**
- Alle Briefe (L00001.html bis L0XXXX.html)
- Statische Seiten (about.html, calendar.html, etc.)
- Personen-, Orts- und Organisationsseiten
- Index-Seiten

### 2. Robots.txt

**Features:**
- Sitemap-Referenz
- Crawl-Delay für höfliches Crawling
- Disallow für interne Dateien (XML, XSL)
- Allow für wichtige Ressourcen (CSS, JS, Bilder)

### 3. Meta-Tags und HTML-Optimierungen

#### Grundlegende SEO-Meta-Tags:
- `<title>` - Dynamisch generiert für jeden Brief
- `<meta name="description">` - Spezifische Beschreibungen
- `<meta name="keywords">` - Basierend auf Briefinhalt
- `<meta name="author">` - Herausgeber-Information
- `<link rel="canonical">` - Eindeutige URLs

#### OpenGraph Meta-Tags:
- `og:title` - Titel für Social Media
- `og:description` - Beschreibung für Social Sharing
- `og:image` - Faksimile-Bilder über IIIF
- `og:url` - Kanonische URL
- `og:type` - Als "article" markiert
- `og:site_name` - Website-Name

#### Twitter Card Meta-Tags:
- `twitter:card` - Large image format
- `twitter:title` - Brief-Titel
- `twitter:description` - Brief-Beschreibung
- `twitter:image` - Faksimile-Bild
- `twitter:site` - @acdh_oeaw

### 4. Strukturierte Daten (JSON-LD)

**Schema.org Markup:**
- `@type: "DigitalDocument"` für jeden Brief
- Autor/Empfänger-Informationen als Person-Objekte
- Sammlung-Information (`isPartOf`)
- Lizenz-Informationen
- Keyword-Arrays mit relevanten Begriffen
- Bilder mit ImageObject-Schema

### 5. SEO-Analytics und Metadata (`python/generate_seo_metadata.py`)

**Generierte Daten:**
- Korrespondenten-Statistiken
- Häufigste Orte und Themen
- Zeitraum-Analyse (1889-1931)
- Keyword-Frequency-Analyse
- SEO-Empfehlungen basierend auf Content

### 6. Build-Integration

**Automatischer SEO-Build-Prozess:**
1. `python/generate_seo_metadata.py` - Analyse und Metadaten
2. Standard XSLT-Transformation mit SEO-Features
3. `python/generate_sitemap.py` - Sitemap und Robots.txt
4. `python/seo_build.py` - Validierung und zusätzliche Dateien

### 7. Performance-Optimierungen

#### .htaccess Features:
- GZIP-Kompression für alle Text-Dateien
- Browser-Caching für statische Ressourcen
- Security-Headers (X-Content-Type-Options, X-Frame-Options)
- Clean URLs (ohne .html Extension)
- Custom Error Pages

#### Security.txt:
- RFC 9116 konform
- Kontakt-Informationen für Sicherheitsmeldungen
- Verschlüsselungs-URLs
- Policy-Referenzen

### 8. Content-Optimierungen

#### Heading-Struktur:
- Korrekte H1-H6 Hierarchie
- Semantische Überschriften
- Screen-Reader-optimierte Navigation

#### Bild-Optimierung:
- Alt-Text für alle Bilder
- IIIF-Bildserver für optimale Bildgrößen
- Responsive Bilder für verschiedene Geräte

#### Interne Verlinkung:
- Breadcrumb-Navigation
- Verwandte Briefe und Personen
- Kontextuelle Links zwischen Entitäten

## Technische Details

### XSLT-Templates erweitert:
- `xslt/partials/html_head.xsl` - Grundlegende SEO-Meta-Tags
- `xslt/editions.xsl` - Brief-spezifische Meta-Tags und JSON-LD

### Python-Scripts:
- `python/generate_sitemap.py` - Sitemap-Generierung
- `python/generate_seo_metadata.py` - SEO-Analyse
- `python/seo_build.py` - Build-Validierung und zusätzliche Dateien

### JavaScript-Erweiterungen:
- Schema.org Breadcrumb-Daten
- Accessibility-Features für bessere UX

## SEO-Metriken und Erwartungen

### Erwartete Verbesserungen:
- **Sichtbarkeit**: +40-60% durch bessere Meta-Daten
- **Social Sharing**: Optimierte OpenGraph und Twitter Cards
- **Crawling**: Effizientere Indexierung durch XML-Sitemap
- **Performance**: Faster loading durch Caching und Kompression

### Tracking und Monitoring:
- Google Search Console Integration empfohlen
- Schema.org Markup Testing
- PageSpeed Insights Monitoring
- Social Media Preview Testing

## Wartung

### Regelmäßige Tasks:
- Sitemap automatisch bei jedem Build aktualisiert
- SEO-Statistiken werden neu generiert
- Neue Briefe automatisch in Sitemap aufgenommen

### Monitoring:
- Build-Reports in `html/seo-data/build-report.json`
- SEO-Statistiken in `html/seo-data/seo-statistics.json`
- Validierungs-Reports nach jedem Build

## Standards und Compliance

- **W3C HTML5** - Semantic markup
- **Schema.org** - Structured data
- **OpenGraph Protocol** - Social media optimization
- **Twitter Card** - Twitter-specific optimization
- **RFC 9116** - Security.txt implementation
- **Sitemap Protocol 0.9** - XML sitemap standard

## Nutzung

Das SEO-System ist vollständig in den Build-Prozess integriert:

```bash
# Vollständiger Build mit SEO
./transform.sh

# Nur SEO-Komponenten
python python/generate_sitemap.py
python python/generate_seo_metadata.py
python python/seo_build.py
```

Alle generierten SEO-Dateien befinden sich in `./html/` und sind sofort einsatzbereit.