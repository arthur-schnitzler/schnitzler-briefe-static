<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:java="http://www.java.com/" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title"
            select="'Verzeichnis der Korrespondenzen mit Schriftstellerinnen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <link
                href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css"
                rel="stylesheet"/>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header sender-color">
                                <h1>Verzeichnis der Korrespondenzen mit Schriftstellerinnen</h1>
                            </div>
                            <div style="display: flex; justify-content: center; width: 100%;">
                                <div style="max-width: 800px; text-align: left;">
                                    <p>Die Korrespondenzen, die Schnitzler mit Schriftstellerinnen
                                        geführt hat, sind nicht besonders umfangreich. Auf seiner <ref type="URL" target="https://schnitzler-lektueren.acdh.oeaw.ac.at/listperson.html">Leseliste</ref>
                                        kommt im Schnitt eine Autorin auf neun männliche Autoren. In beiden
                                        Fällen kann nicht ein ausgeglichenes Verhältnis konstatiert werden. Es lässt sich
                                        aber festhalten, dass Schnitzler Schriftstellerinnen
                                        wahrnahm und sie rezipierte.</p>
                                    <p>Die vorliegende Edition strebt
                                        eine vollständige Edition aller dazugehörigen
                                        Korrespondenzen an, sofern ein tatsächlicher Austausch
                                        anzunehmen ist. Nicht berücksichtigt wurden bislang zwei
                                        umfangreichere Korrespondenzen an der Grenzlinie zwischen
                                        persönlicher und beruflicher Freundschaft, die beide
                                        eingebettet in autobiografische Zeugnisse des Gegenübers
                                        vorliegen: Clara Katharina Pollaczek, die Lebensgefährtin
                                        des letzten Lebensjahrzehnts, nahm die Korrespondenz in ihr
                                        nachgelassenes Memoirenwerk <a target="_blank"
                                            href="https://pollaczek.acdh.oeaw.ac.at/">Arthur
                                            Schnitzler und ich</a> auf. Die ebenfalls in die Zeit
                                        nach dem 1. Weltkrieg fallende Freundschaft zwischen Hedy
                                        Kempny und Schnitzler wiederum wurde gemeinsam mit
                                        Tagebucheintragungen von ihr in der Buchedition <i
                                            >»Das Mädchen mit den dreizehn Seelen«.
                                            Eine Korrespondenz ergänzt durch Blätter aus Hedy
                                            Kempnys Tagebuch sowie durch eine Auswahl ihrer
                                            Erzählungen</i> (Hg. Heinz P. Adamek, Reinbek 1984)
                                        publiziert.</p>
                                    <!--<p>Marie Ebner-Eschenbach bezeichnet sich selbst als »uralte
                                        Erzählerin«, Lou Andreas-Salomé formuliert für Schnitzler
                                        Überlegungen zum »überspannten Mann«, Auguste Hauschner
                                        bittet um Verzeihung für einen »Herzensschrei und das Senden
                                        meines Buches«, bevor sie eine Rezension über <i>Der Weg ins
                                            Freie</i> verfasst, mit Marie Herzfeld nutzt Schnitzler
                                        die Gelegenheit des Briefverkehrs, einander »gegenseitig
                                        schmeichelhafte Dinge zu sagen«. Die Asymmetrie der
                                        zeitgenössischen Geschlechterrollen, schlägt sich in den
                                        Korrespondenzen (unterschiedlich stark) nieder und lädt zur
                                        Untersuchung ein. Das literarische Werk Schnitzlers wird
                                        deutlich mehr thematisiert als das seiner
                                        Schreibpartnerinnen. Aber es sind schreibkundige Autorinnen,
                                        die hier Schnitzler Feedback zu seinen Texten geben.</p>-->
                                    <p>In nächster Zeit werden die Korrespondenzen mit Elsa Plessner
                                        und Berta Zuckerkandl ediert.</p>
                                </div>
                            </div>
                            <div class="card-body">
                                <div id="tocs-container"
                                    style="padding-bottom: 20px; width:100%; margin: auto"/>
                                <div style="display: flex; justify-content: center;">
                                    <table class="table-light table-striped display"
                                        id="tabulator-table-limited"
                                        style="width:100%; margin: auto;">
                                        <thead>
                                            <tr>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Korrespondenz</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Enthält</th>
                                                <th scope="col">Anzahl</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:for-each
                                                select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null') and @corresp = 'female-correspondence-partner']">
                                                <xsl:sort
                                                  select="tei:persName[@role = 'main']/text()"/>
                                                <xsl:variable
                                                  name="nummer-des-korrespondenzpartners"
                                                  select="tei:persName[@role = 'main']/replace(@ref, '#', '')"/>
                                                <tr>
                                                  <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(replace(@xml:id, 'correspondence', 'toc'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:attribute name="class">
                                                  <xsl:text>sender-color</xsl:text>
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
                                </div>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"/>
                    <script src="tabulator-js/tabulator-limited.js"/>
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
