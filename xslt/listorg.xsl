<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs"
    xmlns:mam="whatever">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title"
            select="'Verzeichnis erwähnter Institutionen und Organisationen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/networkgraph.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
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
                                <div class="alert alert-light alert-dismissible fade show" role="alert" style="border: 1px solid #dee2e6;">
                                    <div id="container"
                                        style="padding-bottom: 20px; width:100%; margin: auto"/>
                                    <div id="chart-buttons" class="text-center mt-3"
                                        style="margin: auto; padding-bottom: 20px">
                                        <button class="btn mx-1 chart-btn"
                                            style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                            data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top30.csv"
                                            >Top 30</button>
                                        <button class="btn mx-1 chart-btn"
                                            style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                            data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top100.csv"
                                            >Top 100</button>
                                        <button class="btn mx-1 chart-btn"
                                            style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                            data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top500.csv"
                                            >Top 500</button>
                                    </div>
                                    <script src="js/institution_freq_corp_weights_directed.js"/>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Schließen"></button>
                                </div>
                                
                                    <table class="table table-sm display" id="tabulator-table-org">
                                        <thead>
                                            <tr>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Name</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Namensvarianten</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Zugehörigkeiten</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Typ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:for-each select=".//tei:org">
                                                <xsl:variable name="id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                </xsl:variable>
                                                <tr>
                                                  <td>
                                                      <span hidden="true">
                                                          <xsl:value-of select="mam:sonderzeichen-entfernen(child::tei:orgName[1]/text())"/>
                                                      </span>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat($id, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="child::tei:orgName[1]/text()"/>
                                                  </a>
                                                  </td>
                                                  <td>
                                                      <xsl:choose>
                                                          <xsl:when test="child::tei:orgName[@type = 'alternative-name']">
                                                  <xsl:for-each
                                                  select="child::tei:orgName[@type = 'alternative-name']">
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position() = last())">
                                                  <br/>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                          </xsl:when>
                                                      </xsl:choose>
                                                  </td>
                                                  <td>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="not(tei:location[@type = 'located_in_place'])">
                                                  <span hidden="true">ZZZ</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span hidden="true"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:for-each
                                                  select="distinct-values(tei:location[@type = 'located_in_place']/tei:placeName[1])">
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </td>
                                                  <td>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="contains(tei:desc[@type = 'entity_type'], '&gt;&gt;')">
                                                  <xsl:value-of
                                                  select="tokenize(tei:desc[@type = 'entity_type'], '&gt;&gt;')[last()]"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="tei:desc[@type = 'entity_type']"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
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
                    <xsl:call-template name="tabulator_org_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:org">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(child::tei:orgName[1]/text())"/>
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
                <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h1 align="center">
                                            <xsl:value-of select="$name"/>
                                            <xsl:text> </xsl:text>
                                            <small>
                                                <xsl:text> (Institution)</xsl:text>
                                            </small>
                                        </h1>
                                    </div>
                                    <div class="card-body">
                                        <xsl:call-template name="org_detail"/>
                                    </div>
                                </div>
                            </div>
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:function name="mam:sonderzeichen-entfernen" as="xs:string">
        <xsl:param name="input-string" as="xs:string"/>
        <!-- Ersetzen der Umlaute und Sonderzeichen Schritt für Schritt -->
        <xsl:variable name="string0"
            select="replace(replace(replace(replace(replace(replace(replace($input-string, '»', ''), '«', ''), '’', ''), '\?\?\s\[', ''), '\[', ''), '\(', ''), '\*', '')"/>
        <xsl:variable name="string1" select="replace($string0, 'ä', 'ae')"/>
        <xsl:variable name="string2" select="replace($string1, 'ö', 'oe')"/>
        <xsl:variable name="string3" select="replace($string2, 'ü', 'ue')"/>
        <xsl:variable name="string4" select="replace($string3, 'ß', 'ss')"/>
        <xsl:variable name="string5" select="replace($string4, 'Ä', 'Ae')"/>
        <xsl:variable name="string6" select="replace($string5, 'Ü', 'Ue')"/>
        <xsl:variable name="string7" select="replace($string6, 'Ö', 'Oe')"/>
        <xsl:variable name="string8" select="replace($string7, 'é', 'e')"/>
        <xsl:variable name="string9" select="replace($string8, 'è', 'e')"/>
        <xsl:variable name="string10" select="replace($string9, 'É', 'E')"/>
        <xsl:variable name="string11" select="replace($string10, 'È', 'E')"/>
        <xsl:variable name="string12" select="replace($string11, 'ò', 'o')"/>
        <xsl:variable name="string13" select="replace($string12, 'Č', 'C')"/>
        <xsl:variable name="string14" select="replace($string13, 'D’', 'D')"/>
        <xsl:variable name="string15" select="replace($string14, 'd’', 'd')"/>
        <xsl:variable name="string16" select="replace($string15, 'Ś', 'S')"/>
        <xsl:variable name="string17" select="replace($string16, '’', ' ')"/>
        <xsl:variable name="string18" select="replace($string17, '&amp;', 'und')"/>
        <xsl:variable name="string19" select="replace($string18, 'ë', 'e')"/>
        <xsl:variable name="string20" select="replace($string19, '!', '')"/>
        <xsl:variable name="string21" select="replace($string20, 'č', 'c')"/>
        <xsl:variable name="string22" select="replace($string21, 'Ł', 'L')"/>
        <xsl:variable name="string23">
            <xsl:choose>
                <xsl:when test="starts-with($string22, 'Der ')">
                    <xsl:value-of select="substring-after($string22, 'Der ')"/>
                </xsl:when>
                <xsl:when test="starts-with($string22, 'Die ')">
                    <xsl:value-of select="substring-after($string22, 'Die ')"/>
                </xsl:when>
                <xsl:when test="starts-with($string22, 'Das ')">
                    <xsl:value-of select="substring-after($string22, 'Das ')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string22"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$string23"/>
    </xsl:function>
</xsl:stylesheet>
