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
        <!-- Karten-Seiten für alle Korrespondenzen -->
        <xsl:for-each
            select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null')]">
            <xsl:sort select="tei:persName[@role = 'main']/text()"/>
            <xsl:variable name="nummer-des-korrespondenzpartners"
                select="tei:persName[@role = 'main']/replace(@ref, '#', '')"/>
            <xsl:variable name="filename"
                select="concat('karte_', $nummer-des-korrespondenzpartners, '.html')"/>
            <xsl:variable name="name"
                select="mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text())"/>
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
                <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de"
                    xml:lang="de">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <style>
                        /* Range Input Styling */
                        input[type="range"] {
                            -webkit-appearance: none;
                            appearance: none;
                            height: 6px;
                            border-radius: 3px;
                            outline: none;
                        }

                        /* Thumb */
                        input[type="range"]::-webkit-slider-thumb {
                            -webkit-appearance: none;
                            appearance: none;
                            width: 18px;
                            height: 18px;
                            border-radius: 50%;
                            background: #A63437;
                            cursor: pointer;
                            border: 2px solid white;
                            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
                        }

                        input[type="range"]::-moz-range-thumb {
                            width: 18px;
                            height: 18px;
                            border-radius: 50%;
                            background: #A63437;
                            cursor: pointer;
                            border: 2px solid white;
                            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
                        }

                        /* Track for year-from (red on right) */
                        #year-from {
                            background: linear-gradient(to right, #e9ecef 0%, #e9ecef 50%, #A63437 50%, #A63437 100%);
                        }

                        /* Track for year-to (red on left) */
                        #year-to {
                            background: linear-gradient(to right, #A63437 0%, #A63437 50%, #e9ecef 50%, #e9ecef 100%);
                        }
                    </style>
                    <script src="https://code.highcharts.com/maps/highmaps.js"/>
                    <script src="https://code.highcharts.com/maps/modules/flowmap.js"/>
                    <script src="https://code.highcharts.com/modules/sankey.js"/>
                    <script src="https://code.highcharts.com/modules/arc-diagram.js"/>
                    <script src="https://code.highcharts.com/maps/modules/exporting.js"/>
                    <script src="https://code.highcharts.com/maps/modules/offline-exporting.js"/>
                    <script src="https://code.highcharts.com/maps/modules/accessibility.js"/>
                    <script src="./js/tocs-maps.js"/>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <xsl:variable name="csvFilename"
                                select="concat('karte_', $nummer-des-korrespondenzpartners)"/>
                            <script>
                                function getTitle() {
                                var title = '<xsl:value-of select="$csvFilename"/>';
                                return title;
                                }
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createKarte4(title);
                                });
                            </script>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1>
                                            <xsl:text>Karte zur Korrespondenz Arthur Schnitzler – </xsl:text>
                                            <xsl:value-of select="$name"/>
                                        </h1>
                                    </div>
                                    <div class="body">
                                        <div style="margin-bottom: 1.5em; padding: 1em;">
                                            <div style="margin-bottom: 1.5em;">
                                                <div class="btn-group" role="group"
                                                  aria-label="Ansicht auswählen">
                                                  <button type="button"
                                                  class="btn btn-outline-secondary active"
                                                  id="view-map-btn" onclick="showMapView()"
                                                  >Kartenansicht</button>
                                                  <button type="button"
                                                  class="btn btn-outline-secondary" id="view-arc-btn"
                                                  onclick="showArcView()">Arc-Diagram</button>
                                                </div>
                                            </div>
                                            <div id="map-filters"
                                                style="display: flex; flex-wrap: wrap; gap: 2em; margin-bottom: 1em;">
                                                <div style="flex: 1; min-width: 200px;">
                                                  <label for="direction-filter"
                                                  style="font-weight: bold; margin-right: 1em;"
                                                  >Briefrichtung:</label>
                                                  <select id="direction-filter"
                                                  style="padding: 5px 10px; border: 1px solid #ced4da; border-radius: 4px;">
                                                  <option value="both">Beide Richtungen</option>
                                                  <option value="from-schnitzler">Von Arthur Schnitzler</option>
                                                  <option value="to-schnitzler">
                                                  <xsl:text>Von </xsl:text>
                                                  <xsl:value-of select="$name"/>
                                                  </option>
                                                  </select>
                                                </div>
                                                <div style="flex: 0; min-width: 200px;">
                                                  <label for="show-umfeld"
                                                  style="font-weight: bold; margin-right: 0.5em; cursor: pointer;">
                                                  <input type="checkbox" id="show-umfeld"
                                                  checked="checked"
                                                  style="margin-right: 0.5em; cursor: pointer;"/>
                                                  Umfeldbriefe </label>
                                                </div>
                                            </div>
                                            <div id="time-filters" style="margin-bottom: 0;">
                                                <label
                                                  style="font-weight: bold; display: block; margin-bottom: 0.5em;"
                                                  >Zeitspanne:</label>
                                                <div style="display: flex; align-items: center; gap: 1em;">
                                                  <div style="flex: 1;">
                                                  <label for="year-from" style="margin-right: 0.5em;">Von:</label>
                                                  <input type="range" id="year-from"
                                                  style="width: 70%; vertical-align: middle;"/>
                                                  <span id="year-from-label"
                                                  style="margin-left: 0.5em; font-weight: bold;"/>
                                                  </div>
                                                  <div style="flex: 1;">
                                                  <label for="year-to" style="margin-right: 0.5em;">Bis:</label>
                                                  <input type="range" id="year-to"
                                                  style="width: 70%; vertical-align: middle;"/>
                                                  <span id="year-to-label"
                                                  style="margin-left: 0.5em; font-weight: bold;"/>
                                                  </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="map-view" style="display: block;">
                                            <div id="karte4" style="height: 600px;
                                                min-width: 310px;
                                                max-width: 100%;
                                                margin: 0 auto; margin-bottom:2em;"/>
                                        </div>
                                        <div id="arc-view" style="display: none;">
                                            <div id="arc-diagram" style="height: 600px;
                                                min-width: 310px;
                                                max-width: 100%;
                                                margin: 0 auto; margin-bottom:2em;"/>
                                        </div>
                                    </div>
                                    <p style="text-align:center;">
                                        <i>Die zu Grunde liegenden Daten können hier geladen werden: <a
                                                href="https://github.com/arthur-schnitzler/schnitzler-briefe-charts/tree/main/statistiken"
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
