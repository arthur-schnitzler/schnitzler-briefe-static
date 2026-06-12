<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Bildpostkarten'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <!-- Breadcrumbs -->
                        <nav class="crumbs mt-1" aria-label="Brotkrumennavigation" style="--project-color: {$current-colour};">
                            <span class="type-pill">Verzeichnis</span> <span class="sep">/</span>
                            <xsl:text>bildpostkarten</xsl:text>
                        </nav>
                        <div class="card">
                            <div class="card-header">
                                <h1>Bildpostkarten</h1>
                            </div>
                            <div class="card-body">
                                <div class="mb-4">
                                    <p class="text-muted mb-0">Julia Ilgner hat eine weitreichende Auswertung von Arthur Schnitzlers Bildpolitik durch seine
                                        Ansichtskarten verfasst. Der Text wird im Heft 34 von Studia Austriaca erscheinen. Wer schon vorher die Bildpostkarten und ihre Motiven, die
                                        Schnitzler versandte oder bekommen hat, studieren will, findet hier eine separate Aufstellung.</p>
                                </div>
                                <table class="table table-sm display" id="tabulator-table-bildpostkarten">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Briefnummer</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Datum</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Motiv</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Sender</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="collection('../data/editions/?select=*.xml')/tei:TEI[descendant::tei:objectType[@ana = 'bildpostkarte']]">
                                            <xsl:sort
                                                select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"/>
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <xsl:variable name="briefnummer"
                                                select="replace(tokenize($full_path, '/')[last()], '.xml', '')"/>
                                            <xsl:variable name="sortdate"
                                                select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"/>
                                            <tr>
                                                <td>
                                                    <a class="theme-color"
                                                        href="{concat($briefnummer, '.html')}">
                                                        <xsl:value-of select="$briefnummer"/>
                                                    </a>
                                                </td>
                                                <td>
                                                    <span hidden="true">
                                                        <xsl:value-of select="$sortdate"/>
                                                    </span>
                                                    <xsl:value-of
                                                        select="normalize-space(descendant::tei:correspDesc[1]/tei:correspAction[1]/tei:date[1])"
                                                    />
                                                </td>
                                                <td>
                                                    <xsl:variable name="motiv">
                                                        <xsl:for-each
                                                            select="descendant::tei:div[@type = 'image']">
                                                            <xsl:if test="position() gt 1">
                                                                <xsl:text> | </xsl:text>
                                                            </xsl:if>
                                                            <xsl:apply-templates select="."
                                                                mode="motiv"/>
                                                        </xsl:for-each>
                                                    </xsl:variable>
                                                    <xsl:value-of select="normalize-space($motiv)"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of
                                                        select="string-join(for $p in descendant::tei:correspDesc[1]/tei:correspAction[1]/tei:persName return normalize-space($p), ', ')"
                                                    />
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
                    <script src="tabulator-js/config.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            var table = new Tabulator("#tabulator-table-bildpostkarten", {
                                pagination: "local",
                                paginationSize: 25,
                                paginationCounter: "rows",
                                layout: "fitColumns",
                                responsiveLayout: "hide",
                                autoResize: true,
                                tooltips: true,
                                movableColumns: true,
                                resizableRows: false,
                                placeholder: "Keine Daten verfügbar",
                                columns: [
                                    {title: "Briefnummer", field: "briefnummer", headerFilter: "input", formatter: "html", width: 140},
                                    {title: "Datum", field: "datum", headerFilter: "input", formatter: "html", width: 180},
                                    {title: "Motiv", field: "motiv", headerFilter: "input", formatter: "html"},
                                    {title: "Sender", field: "sender", headerFilter: "input", formatter: "html", width: 220}
                                ],
                                langs: {
                                    "de-de": {
                                        "pagination": {
                                            "first": "Erste",
                                            "first_title": "Erste Seite",
                                            "last": "Letzte",
                                            "last_title": "Letzte Seite",
                                            "prev": "Vorige",
                                            "prev_title": "Vorige Seite",
                                            "next": "Nächste",
                                            "next_title": "Nächste Seite",
                                            "all": "Alle",
                                            "counter": {
                                                "showing": "Zeige",
                                                "of": "von",
                                                "rows": "Reihen",
                                                "pages": "Seiten"
                                            }
                                        }
                                    }
                                },
                                locale: "de-de"
                            });

                            var dlCsv = document.getElementById("download-csv");
                            if (dlCsv) dlCsv.addEventListener("click", function() {
                                table.download("csv", "bildpostkarten.csv");
                            });
                            var dlJson = document.getElementById("download-json");
                            if (dlJson) dlJson.addEventListener("click", function() {
                                table.download("json", "bildpostkarten.json");
                            });
                            var dlHtml = document.getElementById("download-html");
                            if (dlHtml) dlHtml.addEventListener("click", function() {
                                table.download("html", "bildpostkarten.html", {style: true});
                            });
                        });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
    <!-- Motiv als Fließtext: Absätze und Zeilenumbrüche trennen mit Leerzeichen,
         Inline-Elemente (c, rs, hi) laufen ohne Trenner zusammen -->
    <xsl:template match="tei:p" mode="motiv">
        <xsl:if test="position() gt 1">
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates mode="motiv"/>
    </xsl:template>
    <xsl:template match="tei:lb | tei:space" mode="motiv">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="motiv">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
