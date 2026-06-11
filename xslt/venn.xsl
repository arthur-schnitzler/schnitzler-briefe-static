<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Projektüberschneidungen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/venn.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
            <body class="page">
                <style>
                    .nav-tabs { border-bottom: 2px solid #A63437; }
                    .nav-tabs .nav-link { color: #A63437; }
                    .nav-tabs .nav-link.active {
                        background-color: #A63437;
                        border-color: #A63437;
                        color: #fff;
                    }
                    .nav-tabs .nav-link:not(.active):hover {
                        border-color: transparent;
                        background-color: rgba(166,52,55,0.08);
                        color: #A63437;
                    }
                    .form-check-label { cursor: pointer; font-size: 0.875rem; }
                    #venn-info { font-size: 0.875rem; color: #666; min-height: 1.5em; }
                    #venn-project-list input[disabled] + label { cursor: default; }
                </style>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <!-- Breadcrumbs -->
                        <nav class="crumbs mt-1" aria-label="Brotkrumennavigation" style="--project-color: {$current-colour};">
                            <span class="type-pill">Statistiken</span> <span class="sep">/</span>
                            <xsl:text>Schnittmengen</xsl:text>
                        </nav>
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <p class="text-muted mb-0">Hier werden Schnittmengen zwischen <em>Schnitzler Briefwechsel mit Autorinnen und Autoren</em> und anderen Projekten angezeigt. In den
                                Überlappungen der Kreise wird die Anzahl der gemeinsamen Entitäten dargestellt.</p>
                            </div>
                            <div class="card-body">
                                <ul class="nav nav-tabs mb-3" id="vennEntityTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" data-entity="person"
                                            type="button" role="tab" aria-selected="true">Personen</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="work" type="button"
                                            role="tab" aria-selected="false">Werke</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="place" type="button"
                                            role="tab" aria-selected="false">Orte</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="org" type="button"
                                            role="tab" aria-selected="false">Institutionen</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="event" type="button"
                                            role="tab" aria-selected="false">Ereignisse</button>
                                    </li>
                                </ul>
                                <div class="row">
                                    <div class="col-md-3 border-end pe-3">
                                        <h6 class="fw-bold mb-1">Projekte</h6>
                                        <p class="text-muted mb-2" style="font-size:0.78rem;">Max. 3 Projekte (= 3 Kreise). Ausgeblendet = für diesen Entitätstyp keine Daten.</p>
                                        <div id="venn-project-list"/>
                                    </div>
                                    <div class="col-md-9">
                                        <div id="venn-container" style="height:500px; min-width:300px;"/>
                                        <div id="venn-info" class="text-center mt-2"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script src="js/venn.js"/>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () { initVennChart(); });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
