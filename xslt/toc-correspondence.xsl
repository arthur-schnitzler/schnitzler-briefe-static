<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis der Korrespondenzen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/highcharts-more.js"/>
            <script src="https://code.highcharts.com/modules/data.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
            <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <xsl:variable name="korrespondenznummer"
                        select="replace(substring-after(child::tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:idno[@type = 'URI'][1], 'https://id.acdh.oeaw.ac.at/schnitzler-briefe/tocs/toc_'), '.xml', '')"/>
                    <xsl:variable name="csvFilename"
                        select="concat('statistik_pmb', $korrespondenznummer, '.csv')"/>

                    <script src="./js/tocs-statistics.js"/>
                    <script>
    function getTitle() {
        var title = '<xsl:value-of select="$csvFilename"/>';
        return title;
    }
    document.addEventListener('DOMContentLoaded', function () {
        // Assuming your JavaScript function is defined in tocs-statistics-1.js
        var title = getTitle();
        createStatistik1(title);
    });
                    </script>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>
                                    <xsl:value-of
                                        select="descendant::tei:titleStmt/tei:title[@level = 'a']"/>
                                </h1>
                            </div>
                            <div class="card-body">
                                <div id="statistik1" style="width:100%; height:400px;"/>
                                <p style="text-align: center;"><a
                                        href="{concat('statistik_pmb', $korrespondenznummer, '.html')}"
                                        >Weitere Statistiken</a>&#160;&#160;<xsl:if test="
                                            concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/',
                                            'person_freq_corr_weights_directed/' or 'place_freq_corr_weights_directed/' or 'work_freq_corr_weights_directed/' or 'institution_freq_corr_weights_directed/',
                                            'person_freq_corr_weights_directed_correspondence_' or 'place_freq_corr_weights_directed_correspondence_' or 'work_freq_corr_weights_directed_correspondence_' or 'institution_freq_corr_weights_directed_correspondence_',
                                            $korrespondenznummer, '.csv')"
                                            ><a
                                            href="{concat('netzwerke_pmb', $korrespondenznummer, '.html')}"
                                            >Entitäten</a>&#160;&#160;</xsl:if>
                                    <a href="{concat('karte_pmb', $korrespondenznummer, '.html')}"
                                        >Karten</a>
                                </p>

                                <table class="table-light table-striped display"
                                    id="tabulator-table-limited" style="width:100%">
                                    <thead>
                                        <tr>

                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Titel</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Datum (ISO)</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Briefnummer</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="descendant::tei:text[1]/tei:body[1]/tei:list[1]/tei:item">
                                            <tr>

                                                <td>
                                                  <sortdate hidden="true">
                                                  <xsl:value-of select="tei:date/@when"/>
                                                  </sortdate>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat(@corresp, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="tei:title/text()"/>
                                                  </a>
                                                </td>
                                                <td>
                                                  <sortdate hidden="true">
                                                  <xsl:value-of select="tei:date/@when"/>
                                                  <xsl:value-of select="tei:date/@from"/>
                                                  <xsl:value-of select="tei:date/@notBefore"/>
                                                  </sortdate>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat(@corresp, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:choose>
                                                  <xsl:when test="tei:date/@when">
                                                  <xsl:value-of select="tei:date/@when"/>
                                                  </xsl:when>
                                                  <xsl:when test="tei:date/@notBefore">
                                                  <xsl:value-of
                                                  select="concat('nach ', tei:date/@notBefore, ', vor ', tei:date/@notAfter)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="tei:date/@from">
                                                  <xsl:value-of
                                                  select="concat(tei:date/@from, ' – ', tei:date/@to)"
                                                  />
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </a>
                                                </td>
                                                <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat(@corresp, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="@corresp"/>
                                                  </a>
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
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
                    <script src="tabulator-js/tabulator-limited.js"></script>
                </div>
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
