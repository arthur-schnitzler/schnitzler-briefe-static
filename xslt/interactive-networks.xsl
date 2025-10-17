<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:function name="mam:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Interaktive Netzwerke'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/networkgraph.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
            <script src="js/interactive-networks.js"/>
            <link rel="stylesheet" href="css/interactive-networks.css"/>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>
                                    <xsl:text>Interaktive Netzwerkvisualisierungen</xsl:text>
                                </h1>
                                <p>Wählen Sie eine oder mehrere Korrespondenzen aus, um das kombinierte Netzwerk zu visualisieren.</p>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="filter-section">
                                            <h4>Korrespondenzen</h4>
                                            <div class="form-group">
                                                <input type="text" id="correspondence-search" class="form-control mb-2" placeholder="Suchen..."/>
                                            </div>
                                            <div id="correspondence-list" class="correspondence-list">
                                                <xsl:for-each select="//tei:personGrp[not(@xml:id = 'correspondence_null') and not(@ana = 'planned')]">
                                                    <xsl:sort select="tei:persName[@role = 'main'][1]/text()"/>
                                                    <xsl:variable name="corr-id" select="substring-after(@xml:id, 'correspondence_')"/>
                                                    <xsl:variable name="corr-name" select="string-join(mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text()), '')"/>
                                                    <div class="form-check correspondence-item" data-id="{$corr-id}" data-name="{$corr-name}">
                                                        <input class="form-check-input correspondence-checkbox" type="checkbox"
                                                               value="{$corr-id}" id="corr_{$corr-id}"/>
                                                        <label class="form-check-label" for="corr_{$corr-id}">
                                                            <xsl:value-of select="$corr-name"/>
                                                        </label>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                            <div class="mt-3">
                                                <button id="select-all" class="btn btn-sm btn-secondary">Alle auswählen</button>
                                                <button id="clear-all" class="btn btn-sm btn-secondary">Alle abwählen</button>
                                            </div>
                                        </div>

                                        <div class="filter-section mt-4">
                                            <h4>Entitätstypen</h4>
                                            <div class="form-check">
                                                <input class="form-check-input entity-type-checkbox" type="checkbox"
                                                       value="person" id="entity_person" checked="checked"/>
                                                <label class="form-check-label" for="entity_person">
                                                    Personen
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input entity-type-checkbox" type="checkbox"
                                                       value="place" id="entity_place"/>
                                                <label class="form-check-label" for="entity_place">
                                                    Orte
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input entity-type-checkbox" type="checkbox"
                                                       value="institution" id="entity_institution"/>
                                                <label class="form-check-label" for="entity_institution">
                                                    Institutionen
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input entity-type-checkbox" type="checkbox"
                                                       value="work" id="entity_work"/>
                                                <label class="form-check-label" for="entity_work">
                                                    Werke
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input entity-type-checkbox" type="checkbox"
                                                       value="event" id="entity_event"/>
                                                <label class="form-check-label" for="entity_event">
                                                    Ereignisse
                                                </label>
                                            </div>
                                        </div>

                                        <div class="filter-section mt-4">
                                            <h4>Optionen</h4>
                                            <div class="form-group">
                                                <label for="min-mentions">Mindestanzahl Erwähnungen: <span id="min-mentions-value">1</span></label>
                                                <input type="range" class="form-range" id="min-mentions" min="1" max="50" value="1"/>
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="max-nodes">Max. Knoten: <span id="max-nodes-value">100</span></label>
                                                <input type="range" class="form-range" id="max-nodes" min="10" max="200" value="100" step="10"/>
                                            </div>
                                        </div>

                                        <div class="mt-4">
                                            <button id="generate-network" class="btn btn-primary w-100">Netzwerk generieren</button>
                                        </div>
                                    </div>

                                    <div class="col-md-9">
                                        <div id="network-info" class="alert alert-info">
                                            <p>Wählen Sie mindestens eine Korrespondenz aus und klicken Sie auf "Netzwerk generieren".</p>
                                        </div>
                                        <div id="network-stats" class="network-stats" style="display: none;">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="stat-card">
                                                        <div class="stat-value" id="stat-correspondences">0</div>
                                                        <div class="stat-label">Korrespondenzen</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-card">
                                                        <div class="stat-value" id="stat-nodes">0</div>
                                                        <div class="stat-label">Knoten</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-card">
                                                        <div class="stat-value" id="stat-connections">0</div>
                                                        <div class="stat-label">Verbindungen</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-card">
                                                        <div class="stat-value" id="stat-overlaps">0</div>
                                                        <div class="stat-label">Überschneidungen</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="network-container" style="width:100%; height:600px; margin-top: 20px;"/>
                                        <div id="loading-indicator" style="display: none; text-align: center; padding: 50px;">
                                            <div class="spinner-border" role="status">
                                                <span class="visually-hidden">Lädt...</span>
                                            </div>
                                            <p>Netzwerk wird generiert...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
