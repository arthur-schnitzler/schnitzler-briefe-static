<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:variable name="teiSource" select="'listevent.xml'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis der Ereignisse'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                            </div>
                            <div class="card-body">
                                <div style="max-width: 800px; margin: 0 auto;">
                                    <p>Hier werden »Ereignisse« im engeren Sinne verstanden: als eine kulturelle Veranstaltung. 
                                        Mit dem Auszeichnen von Ereignisse wurde erst nach sechs Jahren des Projekts begonnen, 
                                        so dass diese in den bis dahin publizierten
                                        Briefen noch nicht vorhanden sind. Wir werden uns bemühen, diese nachzutragen. Es empfiehlt sich trotzdem, nach bestimmten
                                        Veranstaltungen auch über die Werke zu suchen, die aufgeführt wurden.</p>
                                </div>
                                <table class="table table-sm display" id="tabulator-table-event">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Datum</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Ereignis</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Werk</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Ort</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Typ</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Mitwirkende</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Teilnehmende</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Organisation</th>
                                        </tr>
                                    </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:event[@xml:id]">
                                    <xsl:sort select="@when-iso" order="ascending"/>
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <xsl:variable name="idhtml" select="concat($id, '.html')"/>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="@when-iso"/>
                                        </td>
                                        <td>
                                            <span hidden="hidden">
                                                <xsl:value-of select="./tei:eventName[1]/text()"/>
                                            </span>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="$idhtml"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="./tei:eventName[1]/text()"/>
                                            </a>
                                        </td>
                                        
                                        <td>
                                            <xsl:for-each
                                                select="tei:listBibl/tei:bibl[not(tei:note[contains(., 'rezensi')]) and normalize-space(tei:title)]">
                                                <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(tei:title/@key, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="normalize-space(tei:title)"
                                                  />
                                                </xsl:element>
                                                <xsl:if test="not(position() = last())">
                                                  <br/>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <xsl:for-each select="tei:listPlace/tei:place">
                                                <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(tei:placeName/@key, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="tei:placeName"/>
                                                </xsl:element>
                                                <xsl:if test="not(position() = last())">
                                                  <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:eventName/@n"/>
                                        </td>
                                        <td>
                                            <xsl:if
                                                test="tei:listPerson/tei:person[@role = 'hat als Arbeitskraft' or contains(@role, 'mitwirkend')]/tei:persName/@key = 'pmb2121'">
                                                <xsl:text>AS</xsl:text>
                                                <xsl:if
                                                    test="tei:listPerson/tei:person[@role = 'hat als Arbeitskraft' or contains(@role, 'mitwirkend')][2]">
                                                    <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:if>
                                            <xsl:for-each
                                                select="tei:listPerson/tei:person[(@role = 'hat als Arbeitskraft' or contains(@role, 'mitwirkend')) and not(tei:persName/@key = 'pmb2121')]">
                                                <xsl:variable name="name" select="tei:persName"/>
                                                <xsl:choose>
                                                    <!-- Wenn genau ein Komma enthalten ist -->
                                                    <xsl:when
                                                        test="matches($name, '^[^,]+,\s*[^,]+$')">
                                                        <xsl:element name="a">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($name/@key, '.html')"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:analyze-string select="$name"
                                                                regex="^([^,]+),\s*(.+)$">
                                                                <xsl:matching-substring>
                                                                    <xsl:value-of select="regex-group(2)"/>
                                                                    <xsl:text> </xsl:text>
                                                                    <xsl:value-of select="regex-group(1)"/>
                                                                </xsl:matching-substring>
                                                                <xsl:non-matching-substring>
                                                                    <xsl:value-of select="."/>
                                                                </xsl:non-matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <!-- Wenn kein oder mehr als ein Komma enthalten ist -->
                                                    <xsl:otherwise>
                                                        <xsl:element name="a">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($name/@key, '.html')"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:value-of select="$name"/>
                                                        </xsl:element>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- Semikolon nur, wenn nicht letztes Element -->
                                                <xsl:if test="not(position() = last())">
                                                    <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <xsl:if
                                                test="tei:listPerson/tei:person[(@role = 'hat als Teilnehmer:in' or contains(@role, 'teilnehmend'))]/tei:persName/@key = 'pmb2121'">
                                                <xsl:text>AS</xsl:text>
                                                <xsl:if
                                                    test="tei:listPerson/tei:person[(@role = 'hat als Teilnehmer:in' or contains(@role, 'teilnehmend'))][2]">
                                                    <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:if>
                                            <xsl:for-each
                                                select="tei:listPerson/tei:person[(@role = 'hat als Teilnehmer:in' or contains(@role, 'teilnehmend')) and not(tei:persName/@key = 'pmb2121')]">
                                                <xsl:variable name="name" select="tei:persName"/>
                                                <xsl:choose>
                                                    <!-- Wenn genau ein Komma enthalten ist -->
                                                    <xsl:when
                                                        test="matches($name, '^[^,]+,\s*[^,]+$')">
                                                        <xsl:element name="a">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($name/@key, '.html')"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:analyze-string select="$name"
                                                                regex="^([^,]+),\s*(.+)$">
                                                                <xsl:matching-substring>
                                                                    <xsl:value-of select="regex-group(2)"/>
                                                                    <xsl:text> </xsl:text>
                                                                    <xsl:value-of select="regex-group(1)"/>
                                                                </xsl:matching-substring>
                                                                <xsl:non-matching-substring>
                                                                    <xsl:value-of select="."/>
                                                                </xsl:non-matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <!-- Wenn kein oder mehr als ein Komma enthalten ist -->
                                                    <xsl:otherwise>
                                                        <xsl:element name="a">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($name/@key, '.html')"
                                                                />
                                                            </xsl:attribute>
                                                            <xsl:value-of select="$name"/>
                                                        </xsl:element>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- Semikolon nur, wenn nicht letztes Element -->
                                                <xsl:if test="not(position() = last())">
                                                    <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <xsl:for-each
                                                select="tei:note[@type = 'listorg']/tei:listOrg/tei:org">
                                                <xsl:element name="a">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(tei:orgName/@key, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="tei:orgName"/>
                                                </xsl:element>
                                                <xsl:if test="not(position() = last())">
                                                  <xsl:text>; </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        
                                        
                                        <!--<td>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="$idhtml"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$id"/>
                                            </a>
                                        </td>-->
                                    </tr>
                                </xsl:for-each>
                                    </tbody>
                                </table>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_event_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:event[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name"
                select="normalize-space(string-join(./tei:eventName[1]//text()))"/>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="de">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"/>
                        </xsl:call-template>
                        <link rel="stylesheet"
                            href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
                            integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
                            crossorigin=""/>
                        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""/>
                        <link rel="stylesheet"
                            href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css"/>
                        <link rel="stylesheet"
                            href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"/>
                        <script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"/>
                    </head>
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1>
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="event_detail">
                                    
                                </xsl:call-template>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
                        integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
                        crossorigin=""/>
                    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""/>
                    <script>
                            var lat = <xsl:value-of select="replace(tokenize(descendant::tei:location[1]/tei:geo[1]/text(), ' ')[1], ',', '.')"/>;
                            var long = <xsl:value-of select="replace(tokenize(descendant::tei:location[1]/tei:geo[1]/text(), ' ')[2], ',', '.')"/>;
                            var map = L.map('map_detail').setView([Number(lat), Number(long)], 13);
                            L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
                            maxZoom: 19,
                            attribution: '&amp;copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &amp;copy; <a href="https://carto.com/attributions">CARTO</a>'
                            }).addTo(map);
                            var marker = L.marker([Number(lat), Number(long)]).addTo(map);
                        </script>
                    <link
                        href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css"
                        rel="stylesheet"/>
                    
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
