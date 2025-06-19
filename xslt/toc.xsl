<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Alle Briefe</h1>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm display" id="tabulator-table" style="width:100%"
                                    >
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Titel</th>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Briefwechsel</th>
                                            <th scope="col" tabulator-headerFilter="input">Datum (ISO)</th>
                                            <th scope="col" tabulator-headerFilter="input">Art</th>
                                            <th scope="col" tabulator-headerFilter="input">ID</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:variable name="collection" select="collection('../data/editions/?select=*.xml')"/>
                                        <xsl:for-each
                                            select="$collection/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                  <sortdate hidden="true">
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                  /><xsl:text>;</xsl:text>
                                                  </sortdate>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"
                                                  />
                                                  </a>
                                                </td>
                                                <td>
                                                  <xsl:for-each
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspContext[1]/tei:ref[@type = 'belongsToCorrespondence']">
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                      select="concat(replace(@target, 'correspondence_', 'toc_'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>; </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                </td>
                                                <td>
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                  />
                                                </td>
                                                <td>
                                                  <xsl:variable name="sortentyp"
                                                  select="child::tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listWit[1]/tei:witness[1]/tei:objectType[1]"
                                                  as="node()?"/>
                                                    <xsl:choose>
                                                        <xsl:when test="($sortentyp/text() != '') and not(normalize-space(.)='')"> <!-- für den Fall, dass Textinhalt, wird einfach dieser ausgegeben -->
                                                            <xsl:value-of select="normalize-space($sortentyp)"/>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@ana">
                                                            <xsl:choose>
                                                                <xsl:when test="$sortentyp/@ana='fotografie'">
                                                                    <xsl:text>Fotografie</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='entwurf' and $sortentyp/@corresp='brief'">
                                                                    <xsl:text>Briefentwurf</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='entwurf' and $sortentyp/@corresp='telegramm'">
                                                                    <xsl:text>Telegrammentwurf</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='bildpostkarte'">
                                                                    <xsl:text>Bildpostkarte</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='postkarte'">
                                                                    <xsl:text>Postkarte</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='briefkarte'">
                                                                    <xsl:text>Briefkarte</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@ana='visitenkarte'">
                                                                    <xsl:text>Visitenkarte</xsl:text>
                                                                </xsl:when>
                                                                <xsl:when test="$sortentyp/@corresp='widmung'">
                                                                    <xsl:choose>
                                                                        <xsl:when test="$sortentyp/@ana='widmung_vorsatzblatt'">
                                                                            <xsl:text>Widmung am Vorsatzblatt</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="$sortentyp/@ana='widmung_titelblatt'">
                                                                            <xsl:text>Widmung am Titelblatt</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="$sortentyp/@ana='widmung_schmutztitel'">
                                                                            <xsl:text>Widmung am Schmutztitel</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:when test="$sortentyp/@ana='widmung_umschlag'">
                                                                            <xsl:text>Widmung am Umschlag</xsl:text>
                                                                        </xsl:when>
                                                                    </xsl:choose>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:when>
                                                        <!-- ab hier ist nurmehr @corresp zu berücksichtigen, alle @ana-Fälle sind erledigt -->
                                                        <xsl:when test="$sortentyp/@corresp='anderes'">
                                                            <xsl:text>Sonderfall</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='bild'">
                                                            <xsl:text>Bild</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='brief'">
                                                            <xsl:text>Brief</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='karte'">
                                                            <xsl:text>Karte</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='kartenbrief'">
                                                            <xsl:text>Kartenbrief</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='telegramm'">
                                                            <xsl:text>Telegramm</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='umschlag'">
                                                            <xsl:text>Umschlag</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="$sortentyp/@corresp='widmung'">
                                                            <xsl:text>Widmung</xsl:text>
                                                        </xsl:when>
                                                        
                                                    </xsl:choose>
                                                  
                                                    
                                                </td>
                                                <td>
                                                    <xsl:value-of select="@xml:id"/>
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
