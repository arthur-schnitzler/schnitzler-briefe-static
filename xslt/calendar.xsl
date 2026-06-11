<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

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

                    <main id="calendar-main"
                        style="max-width:1240px;margin:0 auto;padding:30px 32px 80px;">
                        <div
                            style="display:flex;align-items:flex-end;justify-content:space-between;flex-wrap:wrap;gap:16px;margin-bottom:24px;">
                            <div>
                                <h1
                                    style="font-weight:600;font-size:34px;line-height:1.05;margin:0 0 6px;color:#26241f;">
                                    <xsl:text>Kalender</xsl:text>
                                </h1>
                                <p style="margin:0;font-size:14px;color:#6f6b62;max-width:60ch;">
                                    <xsl:text>Alle Korrespondenzstücke der Edition in chronologischer Ansicht. Tage anklicken für die Einträge; Kategorien unten ein- und ausblenden.</xsl:text>
                                </p>
                            </div>
                            <div style="display:flex;gap:14px;align-items:center;">
                                <a href="#" data-bs-toggle="modal" data-bs-target="#calendarInfoModal"
                                    aria-label="Informationen zum Kalender">
                                    <i class="fas fa-info" title="Korrespondenzstücke nach Tagen suchen"/>
                                </a>
                                <a href="js-data/calendarData.js"
                                    aria-label="Kalenderdaten herunterladen">
                                    <i class="fas fa-download" title="Kalenderdaten herunterladen"/>
                                </a>
                            </div>
                        </div>

                        <!-- Calendar Container -->
                        <div id="calendar"/>
                    </main>

                    <div class="modal" tabindex="-1" role="dialog" id="calendarInfoModal">
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
                                    <p>Zusätzlich werden in brauner Farbe gedruckte Korrespondenzstücke Schnitzlers angezeigt. Solche, die sich
                                    auch in der vorliegenden Edition finden, werden nicht angezeigt. Auch der jeweilige Inhalt ist nicht aufgenommen. Teilweise sind PDFs der Drucke hier zu finden:
                                        <a href="drucke.html">Druckdigitalisate</a>.
                                    </p>
                                    <p>Die Ansicht »Leben« zeigt eine Übersicht über die gesamte Laufzeit: ein Feld
                                    je Monat, gefärbt nach Anzahl und häufigster Kategorie der Korrespondenzstücke.</p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <script type="text/javascript" src="js/calendar.js" charset="UTF-8"/>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
