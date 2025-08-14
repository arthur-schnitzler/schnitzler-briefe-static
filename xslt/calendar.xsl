<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>


    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:text>schnitzler-briefe</xsl:text>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <script src="js-data/calendarData.js"/>
                <script src="js/simple-calendar.js"/>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>

                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1 style="display:inline-block;margin-bottom:0;padding-right:5px;">
                                    Kalender</h1>
                                <a>
                                    <i class="fas fa-info"
                                        title="Korrespondenzstücke nach Tagen suchen"
                                        data-bs-toggle="modal" data-target="#exampleModal"/>
                                </a>
                                <a style="padding-left:5px;" href="js-data/calendarData.js">
                                    <i class="fas fa-download" title="Kalenderdaten herunterladen"/>
                                </a>
                            </div>
                            <div class="card-body containingloader">
                                <!-- Calendar Container -->
                                <div class="row" id="calendar-row">
                                    <div class="col-12" id="calendar-col">
                                        <div id="calendar"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal" tabindex="-1" role="dialog" id="exampleModal">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Die Briefe in Kalenderansicht</h5>
                                </div>
                                <div class="modal-body">
                                    <p>Dieser Kalender zeigt alle Korrespondenzstücke der vorliegenden Edition. Sie
                                    sind aufgeteilt in die Farben rot (Korrespondenzstücke von Arthur Schnitzler), blau (Korrespondenzstücke
                                    an Schnitzler) und grün (Umfeldbriefe: Korrespondenzstücke der jeweiligen Lebensgefährtin oder des jeweiligen
                                    Lebensgefährten an das jeweilige Gegenüber).</p>
                                    <p>Zusätzlich werden in brauner Farbe gedruckte Korrespondenzstücke Schnitzlers angezeigt, die sich nicht
                                    in der Edition finden. Ihr Inhalt ist nicht aufgenommen. Teilweise sind PDFs der Drucke hier zu finden:
                                        <ref type="URL" target="drucke.html">Druckdigitalisate</ref>.
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script type="text/javascript" src="js/calendar.js" charset="UTF-8"/>
                    <div id="loadModal"/>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
