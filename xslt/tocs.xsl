<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0"
    exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis der Korrespondenzen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>


            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header">
                                <h1>Verzeichnis der Korrespondenzen</h1>
                            </div>
                            <div class="card-body">
                                <script src="js/correspondence_weights_directed.js"/>
                                <div id="tocs-container" style="padding-bottom: 20px; width:100%; margin: auto"/>
                                <table class="table-light table-striped display"
                                    id="tabulator-table-limited" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Korrespondenz</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">enthält</th>
                                            <th scope="col">Anzahl</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null')]">
                                            <xsl:sort select="tei:persName[@role = 'main']/text()"/>
                                            <xsl:variable name="nummer-des-korrespondenzpartners"
                                                select="tei:persName[@role = 'main']/replace(@ref, '#', '')"/>
                                            <tr>
                                                <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(replace(@xml:id, 'correspondence', 'toc'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="tei:persName[@role = 'main']/text()"/>
                                                  </a>
                                                </td>
                                                <td>
                                                  <xsl:for-each
                                                  select="tei:persName[not(@role = 'main')]">
                                                  <xsl:value-of
                                                  select="concat(substring-after(., ', '), ' ', substring-before(., ', '))"/>
                                                  <xsl:if test="not(position() = last())">
                                                  <br/>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                </td>
                                                <td>
                                                  <xsl:value-of
                                                  select="count(document(concat('../data/tocs/toc_', replace($nummer-des-korrespondenzpartners, 'pmb', ''), '.xml'))/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:list[1]/tei:item)"
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
                    <xsl:call-template name="tabulator-limited_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each
            select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null')]">
            <xsl:sort select="tei:persName[@role = 'main']/text()"/>
            <xsl:variable name="nummer-des-korrespondenzpartners"
                select="tei:persName[@role = 'main']/replace(@ref, '#', '')"/>
            <xsl:variable name="filename"
                select="concat('statistik_', $nummer-des-korrespondenzpartners, '.html')"/>
            <xsl:variable name="name"
                select="mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text())"/>
            <xsl:result-document href="{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <script src="https://code.highcharts.com/modules/accessibility.js"/>
                    <script src="https://code.highcharts.com/highcharts.js"/>
                    <script src="https://code.highcharts.com/highcharts-more.js"/>
                    <script src="https://code.highcharts.com/modules/data.js"/>
                    <script src="https://code.highcharts.com/modules/exporting.js"/>
                    <script src="./js/tocs-statistics.js"/>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <xsl:variable name="csvFilename"
                                select="concat('statistik_', $nummer-des-korrespondenzpartners, '.csv')"/>
                            <script>
                                function getTitle() {
                                var title = '<xsl:value-of select="$csvFilename"/>';
                                return title;
                                }
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createStatistik1(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createStatistik2(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createStatistik3(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createStatistik4a(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createStatistik4b(title);
                                });
                            </script>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1>
                                            <xsl:text>Statistik zur Korrespondenz Arthur Schnitzler – </xsl:text>
                                            <xsl:value-of select="$name"/>
                                        </h1>
                                    </div>
                                    <div class="body">
                                        <div id="statistik1"
                                            style="width:100%; height:400px; margin-bottom:1.5em;"/>
                                        <div id="statistik3"
                                            style="width:100%; height:400px; margin-bottom:1.5em;"/>
                                        <div id="statistik2"
                                            style="width:100%; height:400px; margin-bottom:1.5em;"/>
                                        <div
                                            style="display: flex; flex-wrap: wrap; justify-content: space-between;">
                                            <div id="statistik4a"
                                                style="flex: 1 1 45%; height: 400px; margin-bottom: 1.5em; min-width: 375px;"/>
                                            <div id="statistik4b"
                                                style="flex: 1 1 45%; height: 400px; margin-bottom: 1.5em; min-width: 375px;"
                                            />
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
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
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <script src="https://code.highcharts.com/maps/modules/accessibility.js"/>
                    <script src="https://code.highcharts.com/maps/highmaps.js"/>
                    <script src="https://code.highcharts.com/maps/modules/flowmap.js"/>
                    <script src="https://code.highcharts.com/maps/modules/exporting.js"/>
                    <script src="https://code.highcharts.com/maps/modules/offline-exporting.js"/>
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
                                createKarte1(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createKarte2(title);
                                });
                                document.addEventListener('DOMContentLoaded', function () {
                                var title = getTitle();
                                createKarte3(title);
                                });
                            </script>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1>
                                            <xsl:text>Karten zur Korrespondenz Arthur Schnitzler – </xsl:text>
                                            <xsl:value-of select="$name"/>
                                        </h1>
                                    </div>
                                    <div class="body">
                                        <div id="karte1" style="height: 500px;
                                            min-width: 310px;
                                            max-width: 100%
                                            margin: 0 auto; margin-bottom:2em;"/>
                                        <div id="karte2" style="height: 500px;
                                            min-width: 310px;
                                            max-width: 100%
                                            margin: 0 auto; margin-bottom:2em;"/>
                                        <div id="karte3" style="height: 500px;
                                            min-width: 310px;
                                            max-width: 100%
                                            margin: 0 auto; margin-bottom:2em;"
                                        />
                                    </div>
                                    <p style="text-align:center;"><i>Die zu Grunde liegenden Daten
                                            können hier geladen werden: <a
                                                href="https://github.com/arthur-schnitzler/schnitzler-briefe-statistik"
                                                >GitHub</a></i></p>
                                </div>
                            </div>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>

    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
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
</xsl:stylesheet>
