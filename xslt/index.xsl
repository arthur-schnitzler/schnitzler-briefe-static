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
                </xsl:call-template>
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
                                    <img
                                        src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/hero-bg.jpg"
                                        class="d-block w-100" style="max-width=30%;"
                                        alt="Arthur Schnitzer, gezeichnet von Léandre"/>
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
                            <p class="mt-3">Diese Webseite enthält zur Zeit 49 vollständige
                                Korrespondenzen mit über 3.800 Briefen von und an Arthur Schnitzler
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
                                        <h4 class="card-title">
                                            <i class="fa-solid fa-chart-simple"></i> Anzahl der Korrespondenzstücke
                                        </h4>
                                        <div id="stats-content">
                                            <p>Lädt Statistiken...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="tocs.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/korrespondenzen.jpg"
                                                title="Quelle: ANNO, Die Bühne, datum=19310315"
                                                alt="Schnitzlers Arbeitstisch"/>
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/brief.jpg"
                                                alt="Briefumschlag mit Schnitzlers aufgedruckter Absenderadresse"
                                            />
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/calendar.jpg"
                                                title="Detail aus http://www.ifm-wolfen.de/index.php?id=110005000534 CC BY-NC-SA"
                                                alt="Kalenderdetail"/>
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/persons.jpg"
                                                title="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an Schnitzler, Cambridge University Library"
                                                alt="Zwei der Kinder von Felix Salten, aus einem Brief von diesem an Schnitzler, Cambridge University Library"
                                            />
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/werke.jpg"
                                                title="Nahaufnahme von Buchrücken CC BY 0"
                                                alt="Nahaufnahme von Buchrücken"/>
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/places.jpg"
                                                alt="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                title="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                            />
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/org.jpg"
                                                title="Briefkopf d’Ora" alt="Briefkopf d’Ora"/>
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-acdh.jpg"
                                                title="Schnitzler am ACDH"
                                                alt="Schnitzler am ACDH"/>
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
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-github.jpg"
                                                title="Schnitzler Repositories auf Github"
                                                alt="Schnitzler Repositories auf Github"/>
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
                <script src="js-data/letterStatistics.js"></script>
                <xsl:text disable-output-escaping="yes"><![CDATA[
                <script>
                    // Load and display statistics on index page
                    document.addEventListener('DOMContentLoaded', function() {
                        if (typeof letterStatistics !== 'undefined') {
                            displayIndexStats(letterStatistics);
                        }
                    });

                    function formatGermanDate(isoDate) {
                        if (!isoDate) return '';
                        const parts = isoDate.split('-');
                        if (parts.length !== 3) return isoDate;
                        const day = parseInt(parts[2], 10);
                        const month = parseInt(parts[1], 10);
                        const year = parts[0];
                        return day + '.' + month + '.' + year;
                    }

                    function displayIndexStats(stats) {
                        const container = document.getElementById('stats-content');
                        if (!container) return;

                        let html = '<div class="row">';
                        html += '<div class="col-md-3 text-center">';
                        html += '<h3 class="display-4">' + (stats.total_letters || 0) + '</h3>';
                        html += '<p class="text-muted">Briefe gesamt</p>';
                        html += '</div>';

                        html += '<div class="col-md-3 text-center">';
                        html += '<h3 class="display-4 theme-color">' + (stats.schnitzler_sent || 0) + '</h3>';
                        html += '<p class="text-muted">von Schnitzler</p>';
                        html += '</div>';

                        html += '<div class="col-md-3 text-center">';
                        html += '<h3 class="display-4 sender-color">' + (stats.schnitzler_received || 0) + '</h3>';
                        html += '<p class="text-muted">an Schnitzler</p>';
                        html += '</div>';

                        html += '<div class="col-md-3 text-center">';
                        if (stats.third_party && stats.third_party > 0) {
                            html += '<h3 class="display-4 umfeld-color">' + stats.third_party + '</h3>';
                            html += '<p class="text-muted">Umfeldbriefe</p>';
                        } else if (stats.date_range && stats.date_range.earliest && stats.date_range.latest) {
                            html += '<h5>' + formatGermanDate(stats.date_range.earliest) + '<br/>bis<br/>' + formatGermanDate(stats.date_range.latest) + '</h5>';
                            html += '<p class="text-muted">Zeitraum</p>';
                        }
                        html += '</div>';

                        html += '</div>';

                        container.innerHTML = html;
                    }
                </script>
                ]]></xsl:text>
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
