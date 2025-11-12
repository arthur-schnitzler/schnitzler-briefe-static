<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

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
        <!-- Netzwerk-Seiten für alle Korrespondenzen -->
        <xsl:for-each
            select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null')]">
            <xsl:variable name="corr-id"
                select="tei:persName[@role = 'main']/replace(@ref, '#', '')"/>
            <xsl:variable name="filename" select="concat('netzwerke_', $corr-id, '.html')"/>
            <xsl:variable name="corr-name"
                select="mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text())"/>
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
                <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de"
                    xml:lang="de">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$corr-name"/>
                    </xsl:call-template>
                    <script src="https://code.highcharts.com/highcharts.js"/>
                    <script src="https://code.highcharts.com/modules/networkgraph.js"/>
                    <script src="https://code.highcharts.com/modules/exporting.js"/>
                    <script src="js/correspondence-networks.js"/>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <div class="container">
                                <div class="card">
                                    <div class="card-header">
                                        <h1>
                                            <xsl:text>Netzwerkvisualisierungen zur Korrespondenz Arthur Schnitzler – </xsl:text>
                                            <xsl:value-of select="$corr-name"/>
                                        </h1>
                                    </div>
                                    <div class="body">
                                        <xsl:if
                                            test="unparsed-text-available(resolve-uri(concat('../../network-data/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv'), document-uri(/)))">
                                            <h3 style="text-align: center;">Erwähnte Personen</h3>
                                            <div id="person-container" style="width:100%; margin: auto"/>
                                            <div id="person-chart-buttons"
                                                class="chart-buttons text-center mt-3"
                                                style="margin: auto; padding-bottom: 40px">
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corr_weights_directed/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv')}"
                                                  >Top 30</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corr_weights_directed/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv')}"
                                                  >Top 100</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/))) or unparsed-text-available(resolve-uri(concat('../../network-data/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corr_weights_directed/person_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv')}"
                                                  >Alle</button>
                                                </xsl:if>
                                            </div>
                                        </xsl:if>
                                        <xsl:if
                                            test="unparsed-text-available(resolve-uri(concat('../../network-data/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv'), document-uri(/)))">
                                            <h3 style="text-align: center;">Erwähnte Orte</h3>
                                            <div id="place-container" style="width:100%; margin: auto"/>
                                            <div id="place-chart-buttons"
                                                class="chart-buttons text-center mt-3"
                                                style="margin: auto; padding-bottom: 40px">
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/place_freq_corr_weights_directed/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv')}"
                                                  >Top 30</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/place_freq_corr_weights_directed/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv')}"
                                                  >Top 100</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/))) or unparsed-text-available(resolve-uri(concat('../../network-data/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/place_freq_corr_weights_directed/place_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv')}"
                                                  >Alle</button>
                                                </xsl:if>
                                            </div>
                                        </xsl:if>
                                        <xsl:if
                                            test="unparsed-text-available(resolve-uri(concat('../../network-data/institution_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv'), document-uri(/)))">
                                            <h3 style="text-align: center;">Erwähnte Institutionen</h3>
                                            <div id="institution-container"
                                                style="width:100%; margin: auto"/>
                                            <div id="institution-chart-buttons"
                                                class="chart-buttons text-center mt-3"
                                                style="margin: auto; padding-bottom: 40px">
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/institution_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institutionen_freq_corr_weights_directed/institutionen_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv')}"
                                                  >Top 30</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/institution_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institutionen_freq_corr_weights_directed/institutionen_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv')}"
                                                  >Top 100</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/institution_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/))) or unparsed-text-available(resolve-uri(concat('../../network-data/institution_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institutionen_freq_corr_weights_directed/institutionen_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv')}"
                                                  >Alle</button>
                                                </xsl:if>
                                            </div>
                                        </xsl:if>
                                        <xsl:if
                                            test="unparsed-text-available(resolve-uri(concat('../../network-data/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv'), document-uri(/)))">
                                            <h3 style="text-align: center;">Erwähnte Werke</h3>
                                            <div id="work-container" style="width:100%; margin: auto"/>
                                            <div id="work-chart-buttons"
                                                class="chart-buttons text-center mt-3"
                                                style="margin: auto; padding-bottom: 40px">
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corr_weights_directed/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv')}"
                                                  >Top 30</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corr_weights_directed/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv')}"
                                                  >Top 100</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/))) or unparsed-text-available(resolve-uri(concat('../../network-data/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corr_weights_directed/work_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv')}"
                                                  >Alle</button>
                                                </xsl:if>
                                            </div>
                                        </xsl:if>
                                        <xsl:if
                                            test="unparsed-text-available(resolve-uri(concat('../../network-data/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv'), document-uri(/)))">
                                            <h3 style="text-align: center;">Erwähnte Ereignisse</h3>
                                            <div id="event-container" style="width:100%; margin: auto"/>
                                            <div id="event-chart-buttons"
                                                class="chart-buttons text-center mt-3"
                                                style="margin: auto; padding-bottom: 40px">
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/event_freq_corr_weights_directed/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv')}"
                                                  >Top 30</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/event_freq_corr_weights_directed/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv')}"
                                                  >Top 100</button>
                                                </xsl:if>
                                                <xsl:if
                                                  test="unparsed-text-available(resolve-uri(concat('../../network-data/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top30.csv'), document-uri(/))) or unparsed-text-available(resolve-uri(concat('../../network-data/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_top100.csv'), document-uri(/)))">
                                                  <button class="btn mx-1 chart-btn"
                                                  style="background-color: #A63437; color: white; border: none; padding: 2px 10px; font-size: 0.875rem;"
                                                  data-csv="{concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/event_freq_corr_weights_directed/event_freq_corr_weights_directed_correspondence_', substring-after($corr-id, 'pmb'), '_alle.csv')}"
                                                  >Alle</button>
                                                </xsl:if>
                                            </div>
                                        </xsl:if>
                                    </div>
                                    <p style="text-align:center;">
                                        <i>Die zu Grunde liegenden Daten können hier geladen werden: <a
                                                href="https://github.com/arthur-schnitzler/schnitzler-briefe-charts/tree/main/netzwerke"
                                                >GitHub</a></i>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
