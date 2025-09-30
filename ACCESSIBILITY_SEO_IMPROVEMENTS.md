# Accessibility & SEO Verbesserungsvorschläge
## Für schnitzler-briefe.acdh.oeaw.ac.at

---

## ✅ Bereits gut umgesetzt

1. **Sitemap & robots.txt** vorhanden
2. **Responsive Design** (viewport meta tag)
3. **Semantic HTML** (nav, header, footer Elemente)
4. **ARIA Labels** in Navigation
5. **Accessibility-Script** bereits vorhanden (`accessibility-enhancements.js`)
6. **Strukturierte Daten** durch TEI-XML
7. **Favicons** für alle Plattformen
8. **HTTPS** wird verwendet
9. **Matomo Analytics** für Statistiken

---

## 🔴 Kritische Verbesserungen (High Priority)

### 1. **Meta Description fehlt**
**Problem**: Keine Description-Tags → Suchmaschinen generieren eigene Snippets

**Lösung**: Meta Descriptions für jede Seite hinzufügen
```xml
<!-- In xslt/partials/html_head.xsl -->
<meta name="description" content="Über 3.800 Briefe von und an Arthur Schnitzler (1862-1931) aus 49 vollständigen Korrespondenzen, viele erstmals veröffentlicht." />
```

**Umsetzung**: Parameter für jede Seite individuell setzen
- Startseite: 150-160 Zeichen über das Projekt
- Briefe: Kurze Zusammenfassung (Datum, Absender, Empfänger)
- Index-Seiten: "Verzeichnis von X erwähnte Personen/Werke/Orte..."

---

### 2. **Title-Tags optimieren**
**Problem**:
- Startseite: `<title>schnitzler-briefe</title>` (zu kurz, nicht beschreibend)
- Fehlt auf vielen Unterseiten ein aussagekräftiger Titel

**Lösung**:
```xml
<!-- Startseite -->
<title>Arthur Schnitzler Briefwechsel – Digitale Edition (1885-1931) | ACDH-CH</title>

<!-- Brief -->
<title>Elsa Plessner an Arthur Schnitzler, 2.1.1899 | Schnitzler Briefe</title>

<!-- Index -->
<title>Personenverzeichnis | Arthur Schnitzler Briefwechsel</title>
```

**Format**: [Spezifischer Inhalt] | [Projekt] | [Institution]
- Max. 60 Zeichen für Google Desktop
- Wichtigste Keywords vorne

---

### 3. **Strukturierte Daten (Schema.org)**
**Problem**: Keine strukturierten Daten → Suchmaschinen verstehen Inhaltstyp nicht

**Lösung**: JSON-LD Schema.org Markup hinzufügen

```xml
<!-- In xslt/editions.xsl für Briefe -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Letter",
  "author": {
    "@type": "Person",
    "name": "Elsa Plessner",
    "@id": "https://d-nb.info/gnd/1041571119"
  },
  "recipient": {
    "@type": "Person",
    "name": "Arthur Schnitzler",
    "@id": "https://d-nb.info/gnd/118609807"
  },
  "dateCreated": "1899-01-02",
  "inLanguage": "de",
  "isPartOf": {
    "@type": "Collection",
    "name": "Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Austrian Centre for Digital Humanities and Cultural Heritage",
    "@id": "https://www.oeaw.ac.at/acdh/"
  },
  "license": "https://creativecommons.org/licenses/by/4.0/"
}
</script>
```

**Für Startseite**: `WebSite` + `SearchAction`
```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Arthur Schnitzler Briefwechsel",
  "url": "https://schnitzler-briefe.acdh.oeaw.ac.at/",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "https://schnitzler-briefe.acdh.oeaw.ac.at/search.html?q={search_term_string}",
    "query-input": "required name=search_term_string"
  }
}
```

---

### 4. **Alt-Text für Bilder verbessern**
**Problem**: Manche Bilder haben generische Alt-Texte

**Aktuell**:
```html
<img alt="Schnitzlers Arbeitstisch" />
```

**Besser**:
```html
<img alt="Historische Schwarz-Weiß-Fotografie von Arthur Schnitzlers Schreibtisch mit Schreibmaschine, Büchern und Briefen" />
```

**Regel**: Alt-Text sollte beschreiben, was auf dem Bild zu sehen ist UND warum es relevant ist.

---

### 5. **Canonical URLs**
**Problem**: Keine Canonical Tags → Duplicate Content Risk

**Lösung**:
```xml
<!-- In html_head.xsl -->
<link rel="canonical" href="https://schnitzler-briefe.acdh.oeaw.ac.at/{$current_page}" />
```

---

## 🟡 Wichtige Verbesserungen (Medium Priority)

### 6. **Open Graph & Twitter Cards**
**Problem**: Kein Social Media Preview

**Lösung**:
```xml
<!-- Open Graph -->
<meta property="og:title" content="Arthur Schnitzler Briefwechsel" />
<meta property="og:description" content="Über 3.800 Briefe von und an Arthur Schnitzler..." />
<meta property="og:image" content="https://schnitzler-briefe.acdh.oeaw.ac.at/img/og-image.jpg" />
<meta property="og:url" content="https://schnitzler-briefe.acdh.oeaw.ac.at/" />
<meta property="og:type" content="website" />
<meta property="og:locale" content="de_AT" />

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Arthur Schnitzler Briefwechsel" />
<meta name="twitter:description" content="Über 3.800 Briefe von und an Arthur Schnitzler..." />
<meta name="twitter:image" content="https://schnitzler-briefe.acdh.oeaw.ac.at/img/og-image.jpg" />
```

**Hinweis**: OG-Image sollte 1200x630px sein

---

### 7. **Heading-Hierarchie**
**Problem**: Prüfen ob h1-h6 korrekt verschachtelt sind

**Regel**:
- Nur **eine h1** pro Seite (Hauptüberschrift)
- Keine Levels überspringen (h2 → h4)
- Hierarchie = Inhaltsstruktur

**Check durchführen**:
```bash
# Alle h1-Tags finden
grep -r "<h1" html/*.html
```

---

### 8. **Skip-to-Content Link**
**Problem**: Tastatur-User müssen durch gesamte Navigation

**Lösung**:
```html
<!-- Am Anfang von <body> -->
<a href="#main-content" class="skip-link">Direkt zum Inhalt springen</a>

<style>
.skip-link {
    position: absolute;
    top: -40px;
    left: 0;
    background: #A63437;
    color: white;
    padding: 8px;
    z-index: 100;
}
.skip-link:focus {
    top: 0;
}
</style>

<!-- Hauptinhalt markieren -->
<main id="main-content">
  <!-- Inhalt -->
</main>
```

---

### 9. **Breadcrumbs mit Schema.org**
**Problem**: Keine Breadcrumb-Navigation

**Lösung**:
```html
<nav aria-label="Breadcrumb">
  <ol vocab="https://schema.org/" typeof="BreadcrumbList">
    <li property="itemListElement" typeof="ListItem">
      <a property="item" typeof="WebPage" href="/">
        <span property="name">Startseite</span>
      </a>
      <meta property="position" content="1">
    </li>
    <li property="itemListElement" typeof="ListItem">
      <a property="item" typeof="WebPage" href="/tocs.html">
        <span property="name">Korrespondenzen</span>
      </a>
      <meta property="position" content="2">
    </li>
    <li property="itemListElement" typeof="ListItem">
      <span property="name">Elsa Plessner</span>
      <meta property="position" content="3">
    </li>
  </ol>
</nav>
```

---

### 10. **Sprachauszeichnung verbessern**
**Aktuell**: `lang="de"` ist gesetzt ✅

**Zusätzlich**: Fremdsprachige Zitate auszeichnen
```html
<p>Schnitzler schrieb: <span lang="en">This is important</span></p>
```

---

### 11. **Contrast Ratios prüfen**
**Tools**:
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Browser DevTools: Lighthouse Audit

**Ziel**: WCAG AA Standard
- Normal text: 4.5:1
- Large text: 3:1

**Besonders prüfen**:
- `.theme-color` (#A63437) auf weißem Hintergrund
- `.sender-color` (#1C6E8C) auf weißem Hintergrund
- Links im Text

---

### 12. **Focus Indicators**
**Problem**: Tastatur-Navigation nicht immer sichtbar

**Lösung**:
```css
/* Nie focus outline entfernen! */
*:focus {
    outline: 2px solid #A63437;
    outline-offset: 2px;
}

/* Bessere Focus-Styles */
a:focus, button:focus {
    outline: 3px solid #A63437;
    outline-offset: 2px;
    box-shadow: 0 0 0 3px rgba(166, 52, 55, 0.2);
}
```

---

## 🟢 Nice-to-Have (Low Priority)

### 13. **Performance Optimierung**
- **Bilder**: WebP Format zusätzlich zu JPG
- **Lazy Loading**: `<img loading="lazy" />` für Bilder unterhalb des Folds
- **Font Display**: `font-display: swap` für Font Awesome
- **CSS/JS Minification**: Bereits durch CDN

---

### 14. **Preconnect für externe Ressourcen**
```html
<link rel="preconnect" href="https://shared.acdh.oeaw.ac.at" />
<link rel="preconnect" href="https://cdnjs.cloudflare.com" />
<link rel="dns-prefetch" href="https://matomo.acdh.oeaw.ac.at" />
```

---

### 15. **hreflang für Mehrsprachigkeit**
Falls englische Version geplant:
```html
<link rel="alternate" hreflang="de" href="https://schnitzler-briefe.acdh.oeaw.ac.at/" />
<link rel="alternate" hreflang="en" href="https://schnitzler-briefe.acdh.oeaw.ac.at/en/" />
```

---

### 16. **WAI-ARIA Landmarks**
```html
<header role="banner">
<nav role="navigation" aria-label="Hauptnavigation">
<main role="main">
<aside role="complementary">
<footer role="contentinfo">
```

**Hinweis**: Moderne semantische HTML5-Elemente bereits vorhanden!

---

### 17. **Link-Texte verbessern**
**Problem**: "Hier klicken", "Mehr", "Details" sind nicht aussagekräftig

**Besser**:
- ❌ `<a href="#">Mehr</a>`
- ✅ `<a href="#">Mehr über die Korrespondenz mit Elsa Plessner</a>`

**Oder** aria-label verwenden:
```html
<a href="#" aria-label="Mehr über die Korrespondenz mit Elsa Plessner">Mehr</a>
```

---

### 18. **Tabellen Accessibility**
Falls Datentabellen vorhanden:
```html
<table>
  <caption>Briefe nach Jahren</caption>
  <thead>
    <tr>
      <th scope="col">Jahr</th>
      <th scope="col">Anzahl</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">1899</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
```

---

### 19. **Print Stylesheet**
```html
<link rel="stylesheet" href="css/print.css" media="print" />
```

```css
/* print.css */
@media print {
  nav, .no-print { display: none; }
  a[href]:after { content: " (" attr(href) ")"; }
  body { font-size: 12pt; }
}
```

---

### 20. **RSS Feed**
Für Neuigkeiten/neue Briefe:
```html
<link rel="alternate" type="application/rss+xml" title="Schnitzler Briefe Updates" href="/feed.xml" />
```

---

## 🔧 Konkrete Implementierung

### Priorität 1: Quick Wins (1-2 Stunden)

1. **Meta Descriptions hinzufügen**
   - Datei: `xslt/partials/html_head.xsl`
   - Parameter für Description hinzufügen
   - Für jedes Template individuell setzen

2. **Title-Tags verbessern**
   - Datei: `xslt/partials/html_head.xsl`
   - Format: [Spezifisch] | [Projekt] | [Institution]

3. **Canonical URLs**
   - In `html_head.xsl` Template erweitern

4. **Alt-Texte überarbeiten**
   - In `xslt/index.xsl` durchgehen

---

### Priorität 2: Strukturiert (4-6 Stunden)

5. **Schema.org JSON-LD**
   - Template für Briefe: `xslt/editions.xsl`
   - Template für Startseite: `xslt/index.xsl`
   - Template für Personen: `xslt/listperson.xsl`

6. **Open Graph Tags**
   - In `html_head.xsl`
   - OG-Image erstellen (1200x630px)

7. **Skip-Link & Focus Styles**
   - In `html/css/style.css`
   - In `xslt/partials/html_navbar.xsl`

---

### Priorität 3: Langfristig (Optional)

8. **Accessibility Audit durchführen**
   - WAVE Tool: https://wave.webaim.org/
   - axe DevTools: Browser Extension
   - Lighthouse in Chrome DevTools

9. **Performance Audit**
   - PageSpeed Insights: https://pagespeed.web.dev/
   - GTmetrix: https://gtmetrix.com/

---

## 📊 Testing Tools

### Accessibility
- **WAVE**: https://wave.webaim.org/
- **axe DevTools**: Browser Extension
- **NVDA/JAWS**: Screen Reader Testing
- **Keyboard Navigation**: Tab durch die gesamte Seite

### SEO
- **Google Search Console**: https://search.google.com/search-console
- **Bing Webmaster Tools**: https://www.bing.com/webmasters
- **Schema.org Validator**: https://validator.schema.org/
- **Rich Results Test**: https://search.google.com/test/rich-results

### Performance
- **Lighthouse**: Chrome DevTools
- **PageSpeed Insights**: https://pagespeed.web.dev/
- **WebPageTest**: https://www.webpagetest.org/

---

## 📝 GitHub Pages Spezifisch

### Custom Domain SEO
Falls Custom Domain verwendet:
```
# In Repository Settings → Pages
- Custom Domain: schnitzler-briefe.acdh.oeaw.ac.at
- Enforce HTTPS: ✅
```

### GitHub Pages Limits
- Max. 1 GB Repository Size
- Max. 100 GB Bandbreite/Monat
- Max. 10 Builds/Stunde

### robots.txt für GitHub Pages
```
User-agent: *
Allow: /

Sitemap: https://schnitzler-briefe.acdh.oeaw.ac.at/sitemap.xml
```

---

## 🎯 Empfohlene Reihenfolge

### Phase 1 (Sofort, < 1 Tag)
1. Meta Descriptions
2. Title-Tags
3. Canonical URLs
4. Alt-Texte

### Phase 2 (Diese Woche, 1-2 Tage)
5. Schema.org JSON-LD für Briefe
6. Open Graph Tags
7. Skip-Link
8. Focus Styles

### Phase 3 (Nächsten Monat)
9. Breadcrumbs
10. Contrast Prüfung + Fixes
11. Link-Texte Review
12. Accessibility Audit

### Phase 4 (Optional)
13. Performance Optimierung
14. Print Stylesheet
15. RSS Feed

---

## 💡 Zusätzliche Ressourcen

### Accessibility Guidelines
- **WCAG 2.1**: https://www.w3.org/WAI/WCAG21/quickref/
- **WebAIM**: https://webaim.org/
- **A11Y Project**: https://www.a11yproject.com/

### SEO Best Practices
- **Google Search Central**: https://developers.google.com/search
- **Schema.org Documentation**: https://schema.org/
- **MOZ SEO Guide**: https://moz.com/beginners-guide-to-seo

### DH-Spezifisch
- **TEI Publisher Docs**: Ähnliche Projekte als Referenz
- **DHd Best Practices**: https://dig-hum.de/

---

## ✅ Checkliste für die Umsetzung

- [ ] Meta Descriptions für alle Hauptseiten
- [ ] Title-Tags optimiert
- [ ] Canonical URLs implementiert
- [ ] Alt-Texte überprüft und verbessert
- [ ] Schema.org JSON-LD für Briefe
- [ ] Schema.org für Startseite
- [ ] Open Graph Tags
- [ ] OG-Image erstellt (1200x630px)
- [ ] Skip-to-Content Link
- [ ] Focus Styles verbessert
- [ ] Contrast Ratios geprüft
- [ ] Heading-Hierarchie validiert
- [ ] WAVE Test durchgeführt
- [ ] Lighthouse Audit durchgeführt
- [ ] Google Search Console eingerichtet

---

**Erstellt**: 30. September 2025
**Für**: schnitzler-briefe-static (GitHub Pages)
**Kontakt**: ACDH-CH, ÖAW