<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
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
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>

                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                            </div>
                            <div class="card-body">
                                <div id="container" style="padding-bottom: 20px"/>
                                <div id="chart-buttons" class="text-center mt-3" style="margin-bottom: 10px">
                                    <button class="btn mx-1 chart-btn" style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;" data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top1000.csv">Top 1.000</button>
                                    <button class="btn mx-1 chart-btn" style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;" data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top100.csv">Top 100</button>
                                    <button class="btn mx-1 chart-btn" style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;" data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top30.csv">Top 30</button>
                                </div>
                                <script src="js/institution_freq_corp_weights_directed.js"/>
                                <table class="table table-sm display" id="tabulator-table" style="width:100%"
                                    >
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Name</th>
                                            <th scope="col" tabulator-headerFilter="input">Typ</th>
                                            <th scope="col" tabulator-headerFilter="input">Ort</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select=".//tei:org">
                                            <xsl:variable name="id">
                                                <xsl:value-of select="data(@xml:id)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="concat($id, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="child::tei:orgName[1]/text()"/>
                                                  </a>
                                                  <xsl:if
                                                  test="child::tei:orgName[@type = 'alternative-name']">
                                                  <xsl:text> (</xsl:text>
                                                  <xsl:for-each
                                                  select="child::tei:orgName[@type = 'alternative-name']">
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  <xsl:text>)</xsl:text>
                                                  </xsl:if>
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
                                                <td>
                                                    <xsl:for-each
                                                        select="distinct-values(tei:location[@type = 'located_in_place']/tei:placeName[1])">
                                                        <xsl:value-of select="."/>
                                                        <xsl:if test="not(position() = last())">
                                                            <xsl:text>, </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table> <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:org">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(child::tei:orgName[1]/text())"/>
            <xsl:result-document href="{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
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

</xsl:stylesheet>
