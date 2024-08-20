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
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:variable name="teiSource" select="'listperson.xml'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis erwähnter Personen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
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
                                <div id="container"
                                    style="padding-bottom: 20px; width:100%; margin: auto"/>
                                <div id="chart-buttons" class="text-center mt-3"
                                    style="margin: auto; padding-bottom: 20px">
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top30.csv"
                                        >Top 30</button>
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top100.csv"
                                        >Top 100</button>
                                    <button class="btn mx-1 chart-btn"
                                        style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                        data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top500.csv"
                                        >Top 500</button>
                                </div>
                                <script src="js/person_freq_corp_weights_directed.js"/>
                                <div style="display: flex; justify-content: center;">
                                    <table class="table table-sm display" id="tabulator-table-limited"
                                        style="width:100%; margin: auto;">
                                        <thead>
                                            <tr>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Name</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Namensvarianten</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Lebensdaten</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  >Berufe</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:for-each
                                                select="descendant::tei:listPerson[1]/tei:person">
                                                <xsl:variable name="entiyID"
                                                  select="replace(@xml:id, '#', '')"/>
                                                <xsl:variable name="entity" as="node()" select="."/>
                                                <tr>
                                                  <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat($entity/@xml:id, '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="starts-with($entity/tei:persName[1]/tei:surname[1]/text(), '??')">
                                                  <span hidden="true">ZZZ</span>
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:surname[1]/text()"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$entity/tei:persName[1]/tei:surname[1]/text() and $entity/tei:persName[1]/tei:forename[1]/text()">
                                                  <span hidden="true">
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:surname[1]/text()"/>
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:forename[1]/text()"
                                                  />
                                                  </span>
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:forename[1]/text()"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:surname[1]/text()"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$entity/tei:persName[1]/tei:surname[1]/text()">
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:surname[1]/text()"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$entity/tei:persName[1]/tei:forename[1]/text()">
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:forename[1]/text()"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="$entity/tei:persName[1]/tei:persName[1]"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </a>
                                                  </td>
                                                  <td>
                                                  <xsl:variable name="lemma-name"
                                                  select="$entity/tei:persName[(position() = 1)]"
                                                  as="node()"/>
                                                  <xsl:variable name="namensformen" as="node()">
                                                  <xsl:element name="listPerson">
                                                  <xsl:for-each
                                                  select="$entity/descendant::tei:persName[not(position() = 1)]">
                                                  <xsl:copy-of select="."/>
                                                  </xsl:for-each>
                                                  </xsl:element>
                                                  </xsl:variable>
                                                      
                                                  <xsl:for-each
                                                  select="$namensformen/descendant::tei:persName">
                                                  <xsl:choose>
                                                  <xsl:when test="descendant::*">
                                                  <!-- den Fall dürfte es eh nicht geben, aber löschen braucht man auch nicht -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="./tei:forename/text() and ./tei:surname/text()">
                                                  <xsl:value-of
                                                  select="concat(./tei:forename/text(), ' ', ./tei:surname/text())"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="./tei:forename/text()">
                                                  <xsl:value-of select="./tei:forename/text()"/>
                                                  </xsl:when>
                                                  <xsl:when test="./tei:surname/text()">
                                                  <xsl:value-of select="./tei:surname/text()"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:for-each select="@type = 'person_geburtsname_vorname' and $namensformen/descendant::tei:persName[@type = 'person_geburtsname_nachname']">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>geboren </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of
                                                              select="concat(., ' ', $namensformen/descendant::tei:persName[@type = 'person_geburtsname_nachname'][1])"
                                                          />
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                          
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_geburtsname_vorname' and not($namensformen/descendant::tei:persName[@type = 'person_geburtsname_nachname'])">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>geboren </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of
                                                              select="concat(., ' ', $lemma-name//tei:surname)"
                                                          />
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_geburtsname_nachname' and not($namensformen/descendant::tei:persName[@type = 'person_geburtsname_vorname'][1])">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>geboren </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_adoptierter-nachname'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>adoptierter Name </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_variante-nachname-vorname' or  @type = 'person_namensvariante'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>Namensvariante </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_rufname'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>Rufname </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_pseudonym'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>Pseudonym </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_ehename'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>verheiratet </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_geschieden'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>geschieden </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                      <xsl:for-each select="@type = 'person_verwitwet'">
                                                          <xsl:if test="position()=1">
                                                              <xsl:text>verwitwet </xsl:text>
                                                          </xsl:if>
                                                          <xsl:value-of select="."/>
                                                          <xsl:choose>
                                                              <xsl:when test="not(position()=last())">
                                                                  <xsl:text>, </xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:element name="br"/>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:for-each>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of select="mam:lebensdaten($entity)"/>
                                                  </td>
                                                  <td>
                                                  <xsl:if test="$entity/descendant::tei:occupation">
                                                  <xsl:for-each
                                                  select="$entity/descendant::tei:occupation">
                                                  <xsl:variable name="beruf" as="xs:string">
                                                  <xsl:choose>
                                                  <xsl:when test="contains(., '&gt;&gt;')">
                                                  <xsl:value-of
                                                  select="tokenize(., '&gt;&gt;')[last()]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <xsl:choose>
                                                  <xsl:when test="$entity/tei:sex/@value = 'male'">
                                                  <xsl:value-of select="tokenize($beruf, '/')[1]"/>
                                                  </xsl:when>
                                                  <xsl:when test="$entity/tei:sex/@value = 'female'">
                                                  <xsl:value-of select="tokenize($beruf, '/')[2]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="$beruf"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                  </td>
                                                </tr>
                                            </xsl:for-each>
                                        </tbody>
                                    </table>
                                </div>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_js"/>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name">
                <xsl:choose>
                    <xsl:when
                        test="./tei:persName[1]/tei:forename[1] and ./tei:persName[1]/tei:surname[1]">
                        <xsl:value-of
                            select="normalize-space(concat(./tei:persName[1]/tei:forename[1], ' ', ./tei:persName[1]/tei:surname[1]))"
                        />
                    </xsl:when>
                    <xsl:when test="./tei:persName[1]/tei:forename[1]">
                        <xsl:value-of select="normalize-space(./tei:persName[1]/tei:forename[1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(./tei:persName[1]/tei:surname[1])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="entity" select="." as="node()"/>
            <xsl:result-document href="{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="$name"/>
                    </xsl:call-template>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h2 align="center">
                                            <xsl:value-of select="$name"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:choose>
                                                <xsl:when
                                                  test="child::tei:birth and child::tei:death">
                                                  <span class="lebensdaten">
                                                  <xsl:text>(</xsl:text>
                                                  <xsl:value-of select="mam:lebensdaten($entity)"/>
                                                  <xsl:text>)</xsl:text>
                                                  </span>
                                                </xsl:when>
                                            </xsl:choose>
                                        </h2>
                                    </div>
                                    <xsl:call-template name="person_detail"/>
                                </div>
                            </div>
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:function name="mam:lebensdaten">
        <xsl:param name="entity" as="node()"/>
        <xsl:variable name="geburtsort" as="xs:string?"
            select="$entity/tei:birth[1]/tei:settlement[1]/tei:placeName[1]"/>
        <xsl:variable name="geburtsdatum" as="xs:string?"
            select="mam:normalize-date($entity/tei:birth[1]/tei:date[1]/text())"/>
        <xsl:variable name="todessort" as="xs:string?"
            select="$entity/tei:death[1]/tei:settlement[1]/tei:placeName[1]"/>
        <xsl:variable name="todesdatum" as="xs:string?"
            select="mam:normalize-date($entity/tei:death[1]/tei:date[1]/text())"/>
        <xsl:choose>
            <xsl:when test="$geburtsdatum != '' and $todesdatum != ''">
                <xsl:value-of select="$geburtsdatum"/>
                <xsl:if test="$geburtsort != ''">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$geburtsort"/>
                </xsl:if>
                <xsl:text> – </xsl:text>
                <xsl:value-of select="$todesdatum"/>
                <xsl:if test="$todessort != ''">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$todessort"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$geburtsdatum != ''">
                <xsl:text>* </xsl:text>
                <xsl:value-of select="$geburtsdatum"/>
                <xsl:if test="$geburtsort != ''">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$geburtsort"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$todesdatum != ''">
                <xsl:text>† </xsl:text>
                <xsl:value-of select="$todesdatum"/>
                <xsl:if test="$todessort != ''">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$todessort"/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
