<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                    <xsl:with-param name="html_url" select="'https://schnitzler-briefe.acdh.oeaw.ac.at/'"/>
                </xsl:call-template>
                <meta name="google-site-verification" content="dc888ZmCroA0_VKEB86Vss7wy4Jbkaro0j2QfM8GOak" />

                <!-- Highcharts for statistics visualization - deferred for performance -->
                <script src="https://code.highcharts.com/highcharts.js" defer="defer"></script>

                <!-- Schema.org JSON-LD for Homepage -->
                <script type="application/ld+json">
                {
                  "@context": "https://schema.org",
                  "@type": "WebSite",
                  "name": "Arthur Schnitzler Briefwechsel",
                  "alternateName": "Schnitzler Briefe",
                  "url": "https://schnitzler-briefe.acdh.oeaw.ac.at/",
                  "description": "Über <xsl:value-of select="$total_letters_formatted"/> Briefe von und an Arthur Schnitzler (1862–1931) aus <xsl:value-of select="$complete_correspondences_formatted"/> vollständigen Korrespondenzen, viele erstmals veröffentlicht. Digitale Edition von Martin Anton Müller mit Gerd-Hermann Susen, Laura Untner und Selma Jahnke.",
                  "inLanguage": "de",
                  "publisher": {
                    "@type": "Organization",
                    "name": "Austrian Centre for Digital Humanities",
                    "url": "https://www.oeaw.ac.at/acdh/",
                    "logo": {
                      "@type": "ImageObject",
                      "url": "https://shared.acdh.oeaw.ac.at/schnitzler-briefe/project-logo.svg"
                    }
                  },
                  "potentialAction": {
                    "@type": "SearchAction",
                    "target": {
                      "@type": "EntryPoint",
                      "urlTemplate": "https://schnitzler-briefe.acdh.oeaw.ac.at/search.html?q={search_term_string}"
                    },
                    "query-input": "required name=search_term_string"
                  },
                  "about": {
                    "@type": "Person",
                    "name": "Arthur Schnitzler",
                    "birthDate": "1862",
                    "deathDate": "1931",
                    "@id": "https://d-nb.info/gnd/118609807"
                  }
                }
                </script>
            </head>
            <body class="page" style="background-color:#f1f1f1;">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="row intro">
                            <div class="col-md-6 col-lg-6 col-sm-12 wp-intro_left">
                                <div class="intro_left">
                                    <h3 class="mt-3">Arthur Schnitzler</h3>
                                    <h1 class="mt-3" style="text-align: left;">Briefwechsel mit
                                        Autorinnen und Autoren </h1>
                                    <h3 class="mt-3">1885–1931</h3>
                                    <h4 style="font-style: italic">Herausgegeben von Martin Anton
                                        Müller mit Gerd-Hermann Susen, Laura Untner und Selma Jahnke, Wien
                                        2018–[2029]</h4>
                                    <div style="text-align: right">
                                        <a href="#body">
                                            <button class="btn btn-round"
                                                style="background-color: #A63437; color: white;"
                                                >Weiter</button>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <div class="intro_right wrapper">
                                    <picture>
                                        <source srcset="img/index/hero-bg.webp" type="image/webp"/>
                                        <img
                                            src="img/index/hero-bg.jpg"
                                            class="d-block w-100" style="max-width=30%;"
                                            alt="Arthur Schnitzer, gezeichnet von Léandre"
                                            width="412" height="258"/>
                                    </picture>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid" style="margin:2em auto;" id="body">
                        <div style="max-width: 650px; margin: auto;">
                            <span style="display: block;
                                position: relative;
                                top: -250px; visibility: hidden"
                                id="body"/>
                            <p class="mt-3">Diese Webseite enthält zur Zeit <span id="correspondence-count">…</span> vollständige
                                Korrespondenzen mit <span id="letter-count">…</span> Briefen von und an Arthur Schnitzler
                                (1862–1931). Viele davon werden erstmals veröffentlicht. Alle sind
                                nach den Originalen in Archiven in Europa und Amerika durchgesehen
                                und korrigiert.</p>
                            <p class="mt-3" style="padding-bottom: 50px;">In der seit 2025 laufenden 3. Projektlaufzeit wurden bereits die Korrespondenzen
                                mit Karl Emil Franzos, Sigmund Freud, Elsa Plessner, Romain Rolland, Wanda Sacher-Masoch und Stefan Zweig aufgenommen. Die Korrespondenz mit Theodor Herzl wird 
                                nach und nach ergänzt (<a
                                    href="status.html">Projektstand</a>).</p>
                            <a href="L00001.html">
                                <button class="btn btn-round">Lesen</button>
                            </a>
                            <span>&#160;&#160;&#160;&#160;</span>
                            <a href="about.html">
                                <button class="btn btn-round">Zum Projekt</button>
                            </a>
                        </div>
                    </div>
                    <div class="container-fluid" style="margin:2em auto;">
                        <div class="row wrapper img_bottom">
                            <div class="col-md-12 mb-4">
                                <div class="card" style="background-color: white;">
                                    <div class="card-body">
                                        <h4 class="card-title" id="stats-title">
                                            <i class="fa-solid fa-chart-simple" style="margin-right: 0.5em;"></i><span id="stats-title-text">Anzahl der Korrespondenzstücke</span>
                                        </h4>
                                        <div id="stats-content">
                                            <p>Lädt Statistiken...</p>
                                        </div>
                                        <div class="text-center mt-3">
                                            <button class="btn btn-sm btn-outline-secondary" id="stats-prev-btn" style="display:none;">
                                                <i class="fa-solid fa-chevron-left"></i> Zurück
                                            </button>
                                            <span id="stats-slide-indicator" class="mx-3"></span>
                                            <button class="btn btn-sm btn-outline-secondary" id="stats-next-btn" style="display:none;">
                                                Weiter <i class="fa-solid fa-chevron-right"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="tocs.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/korrespondenzen.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/korrespondenzen.jpg"
                                                    title="Quelle: ANNO, Die Bühne, datum=19310315"
                                                    alt="Schnitzlers Arbeitstisch"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Korrespondenzen </h4>
                                            <p>Auswahl anhand der Korrespondenzpartnerinnen und
                                                -partner.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="toc.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/brief.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/brief.jpg"
                                                    alt="Briefumschlag mit Schnitzlers aufgedruckter Absenderadresse"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Korrespondenzstücke</h4>
                                            <p>Verzeichnis aller edierten Briefe, Karten,
                                                Widmungsexemplare und Telegramme.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="calendar.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/calendar.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/calendar.jpg"
                                                    title="Detail aus http://www.ifm-wolfen.de/index.php?id=110005000534 CC BY-NC-SA"
                                                    alt="Kalenderdetail"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Kalender</h4>
                                            <p>Korrespondenzstücke anhand eines Datums finden.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listperson.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/persons.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/persons.jpg"
                                                    title="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an Schnitzler, Cambridge University Library"
                                                    alt="Zwei der Kinder von Felix Salten, aus einem Brief von diesem an Schnitzler, Cambridge University Library"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Personen</h4>
                                            <p>In den Korrespondenzstücken erwähnte Personen.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listbibl.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/werke.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/werke.jpg"
                                                    title="Nahaufnahme von Buchrücken CC BY 0"
                                                    alt="Nahaufnahme von Buchrücken"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Werkverzeichnis</h4>
                                            <p>In den Korrespondenzstücken erwähnte literarische wie
                                                nicht-literarische Werke.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listplace.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/places.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/places.jpg"
                                                    alt="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                    title="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Orte</h4>
                                            <p>In den Korrespondenzstücken erwähnte geografische
                                                Orte. Diese sind auch über ihre Koordinaten
                                                erschlossen.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listorg.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/org.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/org.jpg"
                                                    title="Briefkopf d'Ora" alt="Briefkopf d'Ora"
                                                    width="427" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <h4>Institutionen und Organisationen</h4>
                                            <p>In den Korrespondenzstücken erwähnte Verlage,
                                                Redaktionen, Vereine, Gesellschaften, Firmen, Preise
                                                …</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="https://schnitzler.acdh.oeaw.ac.at/" class="index-link"
                                    target="_blank">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/schnitzler-acdh.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/schnitzler-acdh.jpg"
                                                    title="Schnitzler am ACDH"
                                                    alt="Schnitzler am ACDH"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <p>Schnitzler am ACDH</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="https://github.com/arthur-schnitzler" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <picture>
                                                <source srcset="img/index/schnitzler-github.webp" type="image/webp"/>
                                                <img class="d-block w-100"
                                                    src="img/index/schnitzler-github.jpg"
                                                    title="Schnitzler Repositories auf Github"
                                                    alt="Schnitzler Repositories auf Github"
                                                    width="468" height="250"/>
                                            </picture>
                                        </div>
                                        <div class="card-header">
                                            <p>Quelldaten dieser Webseite auf GitHub</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <!--<div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="search.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <p> Datenbanksuche </p>
                                        </div>
                                    </div>
                                </a>
                            </div>-->
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
                <script src="js/index-statistics.js"></script>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
