<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Inhaltsverzeichnis'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Inhaltsverzeichnis</h1>
                            </div>
                            <div class="card-body">
                                <table class="table table-striped display" id="tocTable"
                                    style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Titel</th>
                                            <th scope="col">Briefwechsel</th>
                                            <th scope="col">Datum (ISO)</th>
                                            <th scope="col">Briefsorte</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="collection('../data/editions/?select=*.xml')/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                  <sortdate hidden="true">
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                  />
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
                                                  select="concat(replace(@target, '#pmb', 'toc_'), '.html')"
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
                                                  select="child::tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listWit[1]/tei:witness[1]/tei:msDesc[1]/tei:physDesc[1]/tei:objectDesc[1]"
                                                  as="node()?"/>
                                                  <xsl:for-each
                                                  select="$sortentyp/tei:desc[not(starts-with(@type,'_'))]">
                                                  <xsl:choose>
                                                  <xsl:when test="@type = 'anderes'">
                                                  <xsl:text>Anderes</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="@type = 'bild' and @subtype = 'fotografie'">
                                                  <xsl:text>Bild (Fotografie)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'bild'">
                                                  <xsl:text>Bild</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'brief'">
                                                  <xsl:text>Brief</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'entwurf'">
                                                  <xsl:text>Entwurf</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'fragment'">
                                                  <xsl:text>Fragment</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'karte'">
                                                  <xsl:text>Karte</xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when test="@subtype = 'postkarte'">
                                                  <xsl:text> (Postkarte)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'bildpostkarte'">
                                                  <xsl:text> (Bildpostkarte)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'briefkarte'">
                                                  <xsl:text> (Briefkarte)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'visitenkarte'">
                                                  <xsl:text> (Vistenkarte)</xsl:text>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'kartenbrief'">
                                                  <xsl:text>Kartenbrief</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'reproduktion'">
                                                  <xsl:text>Reproduktion</xsl:text>
                                                  <xsl:choose>
                                                  <xsl:when test="@subtype = 'fotokopie'">
                                                  <xsl:text> (Fotokopie)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="@subtype = 'fotografische_vervielfaeltigung'">
                                                  <xsl:text> (Fotografische Vervielfältigung)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'ms_abschrift'">
                                                  <xsl:text> (maschinelle Abschrift)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'hs_abschrift'">
                                                  <xsl:text> (handschriftliche Abschrift)</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@subtype = 'durchschlag'">
                                                  <xsl:text> (Durchschlag)</xsl:text>
                                                  </xsl:when>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'telegramm'">
                                                  <xsl:text>Telegramm</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'umschlag'">
                                                  <xsl:text>Umschlag</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when test="@type = 'widmung'">
                                                  <xsl:text>Widmung</xsl:text>
                                                      <xsl:choose>
                                                          <xsl:when test="@subtype = 'widmung_vorsatzblatt'">
                                                              <xsl:text> (Vorsatzblatt)</xsl:text>
                                                          </xsl:when>
                                                          <xsl:when
                                                              test="@subtype = 'widmung_titelblatt'">
                                                              <xsl:text> (Titelblatt)</xsl:text>
                                                          </xsl:when>
                                                          <xsl:when test="@subtype = 'widmung_vortitel'">
                                                              <xsl:text> (Vortitel)</xsl:text>
                                                          </xsl:when>
                                                          <xsl:when test="@subtype = 'widmung_schmutztitel'">
                                                              <xsl:text> (Schmutztitel)</xsl:text>
                                                          </xsl:when>
                                                          <xsl:when test="@subtype = 'Umschlag'">
                                                              <xsl:text> (Umschlag)</xsl:text>
                                                          </xsl:when>
                                                      </xsl:choose>
                                                      
                                                  </xsl:when>
                                                  </xsl:choose>
                                                      <xsl:if test="not(position()=last())">
                                                          <xsl:text>, </xsl:text>
                                                      </xsl:if>
                                                  </xsl:for-each>
                                                    <xsl:if test="empty($sortentyp) and child::tei:teiHeader[1]/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listBibl[1]/tei:biblStruct[1]">
                                                        <xsl:text>Druck</xsl:text>
                                                    </xsl:if>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script>
                        $(document).ready(function () {
                        createDataTable('tocTable')
                        });
                    </script>
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
