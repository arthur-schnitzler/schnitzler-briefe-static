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
                                <div class="entity-theme mb-3" style="--project-color: {$current-colour};">
                                    <div class="entity-tabs" id="vennEntityTabs" role="tablist" aria-label="Entitätstyp">
                                        <button class="entity-tab-btn active" data-entity="person"
                                            type="button" role="tab" aria-selected="true">Personen</button>
                                        <button class="entity-tab-btn" data-entity="work"
                                            type="button" role="tab" aria-selected="false">Werke</button>
                                        <button class="entity-tab-btn" data-entity="place"
                                            type="button" role="tab" aria-selected="false">Orte</button>
                                        <button class="entity-tab-btn" data-entity="org"
                                            type="button" role="tab" aria-selected="false">Institutionen</button>
                                        <button class="entity-tab-btn" data-entity="event"
                                            type="button" role="tab" aria-selected="false">Ereignisse</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3 border-end pe-3">
                                        <div id="venn-gender-filter" class="mb-3" style="display:none;">
                                            <h6 class="fw-bold mb-1">Gender</h6>
                                            <p class="text-muted mb-2" style="font-size:0.78rem;">Auf einzelne soziale Geschlechter filtern:</p>
                                            <div class="venn-gender-options">
                                                <div class="form-check mb-1">
                                                    <input class="form-check-input" type="radio" name="venn-gender" id="vgender-all" value="all" checked="checked"/>
                                                    <label class="form-check-label" for="vgender-all">alle</label>
                                                </div>
                                                <div class="form-check mb-1">
                                                    <input class="form-check-input" type="radio" name="venn-gender" id="vgender-female" value="female"/>
                                                    <label class="form-check-label" for="vgender-female">weiblich</label>
                                                </div>
                                                <div class="form-check mb-1">
                                                    <input class="form-check-input" type="radio" name="venn-gender" id="vgender-male" value="male"/>
                                                    <label class="form-check-label" for="vgender-male">männlich</label>
                                                </div>
                                                <div class="form-check mb-1">
                                                    <input class="form-check-input" type="radio" name="venn-gender" id="vgender-unknown" value="unknown"/>
                                                    <label class="form-check-label" for="vgender-unknown">nicht ausgezeichnet, unbekannt oder anderes</label>
                                                </div>
                                            </div>
                                        </div>
                                        <h6 class="fw-bold mb-1">Projekte</h6>
                                        <p class="text-muted mb-2" style="font-size:0.78rem;">Max. 3 Projekte (= 3 Kreise).</p>
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
