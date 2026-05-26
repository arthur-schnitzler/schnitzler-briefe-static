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
        <xsl:variable name="doc_title" select="'Projektüberschneidungen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/venn.js"/>
            <script src="https://code.highcharts.com/modules/exporting.js"/>
            <body class="page">
                <style>
                    .nav-tabs { border-bottom: 2px solid #A63437; }
                    .nav-tabs .nav-link { color: #A63437; }
                    .nav-tabs .nav-link.active {
                        background-color: #A63437;
                        border-color: #A63437;
                        color: #fff;
                    }
                    .nav-tabs .nav-link:not(.active):hover {
                        border-color: transparent;
                        background-color: rgba(166,52,55,0.08);
                        color: #A63437;
                    }
                    .form-check-label { cursor: pointer; font-size: 0.875rem; }
                    #venn-info { font-size: 0.875rem; color: #666; min-height: 1.5em; }
                    #venn-project-list input[disabled] + label { cursor: default; }
                </style>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <p class="text-muted mb-0">Hier werden Schnittmengen zwischen <em>Schnitzler Briefwechsel mit Autorinnen und Autoren</em> und anderen Projekten angezeigt.</p>
                            </div>
                            <div class="card-body">
                                <ul class="nav nav-tabs mb-3" id="vennEntityTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" data-entity="person"
                                            type="button" role="tab" aria-selected="true">Personen</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="work" type="button"
                                            role="tab" aria-selected="false">Werke</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="place" type="button"
                                            role="tab" aria-selected="false">Orte</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="org" type="button"
                                            role="tab" aria-selected="false">Institutionen</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-entity="event" type="button"
                                            role="tab" aria-selected="false">Ereignisse</button>
                                    </li>
                                </ul>
                                <div class="row">
                                    <div class="col-md-3 border-end pe-3">
                                        <h6 class="fw-bold mb-1">Projekte</h6>
                                        <p class="text-muted mb-2" style="font-size:0.78rem;"><em>schnitzler-briefe</em> ist immer ausgewählt. Max. 2 weitere (= 3 Kreise). Ausgeblendet = für diesen Entitätstyp keine Daten.</p>
                                        <div id="venn-project-list">
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-briefe"
                                                    value="schnitzler-briefe"
                                                    checked="checked" disabled="disabled"/>
                                                <label class="form-check-label fw-semibold"
                                                    for="vproj-schnitzler-briefe"
                                                    style="color:#A63437;">Briefe</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-auden-musulin-papers"
                                                    value="auden-musulin-papers"/>
                                                <label class="form-check-label"
                                                    for="vproj-auden-musulin-papers"
                                                    style="color:#b59890;">Auden-Musulin</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-bahr-tsn"
                                                    value="bahr-tsn"/>
                                                <label class="form-check-label"
                                                    for="vproj-bahr-tsn"
                                                    style="color:#ce0000;">Bahr Tagebücher</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-bahr-textverzeichnis"
                                                    value="bahr-textverzeichnis"/>
                                                <label class="form-check-label"
                                                    for="vproj-bahr-textverzeichnis"
                                                    style="color:#8E4162;">Bahr Textverzeichnis</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-ansorge"
                                                    value="ansorge"/>
                                                <label class="form-check-label"
                                                    for="vproj-ansorge"
                                                    style="color:#2C3E50;">Conrad Ansorge</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-brenner"
                                                    value="brenner"/>
                                                <label class="form-check-label"
                                                    for="vproj-brenner"
                                                    style="color:#bbc168;">Der Brenner</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schaubuehne"
                                                    value="schaubuehne"/>
                                                <label class="form-check-label"
                                                    for="vproj-schaubuehne"
                                                    style="color:#11759a;">Die Schaubühne</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-dritte-walpurgisnacht"
                                                    value="dritte-walpurgisnacht"/>
                                                <label class="form-check-label"
                                                    for="vproj-dritte-walpurgisnacht"
                                                    style="color:#a21a17;">Dritte Walpurgisnacht</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-interviews"
                                                    value="schnitzler-interviews"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-interviews"
                                                    style="color:#3D5A80;">Interviews</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-kultur"
                                                    value="schnitzler-kultur"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-kultur"
                                                    style="color:#6B4C5A;">Kulturveranstaltungen</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-lektueren"
                                                    value="schnitzler-lektueren"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-lektueren"
                                                    style="color:#022954;">Leseliste</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-bahr"
                                                    value="schnitzler-bahr"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-bahr"
                                                    style="color:#639FF9;">Schnitzler/Bahr</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-fischer"
                                                    value="schnitzler-fischer"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-fischer"
                                                    style="color:#3D4F9F;">Schnitzler – S. Fischer</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schoenberg-ue"
                                                    value="schoenberg-ue"/>
                                                <label class="form-check-label"
                                                    for="vproj-schoenberg-ue"
                                                    style="color:#C8884A;">Schönberg Universaledition</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-tagebuch"
                                                    value="schnitzler-tagebuch"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-tagebuch"
                                                    style="color:#037a33;">Tagebuch</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-thun-korrespondenz"
                                                    value="thun-korrespondenz"/>
                                                <label class="form-check-label"
                                                    for="vproj-thun-korrespondenz"
                                                    style="color:#0063a6;">Thun-Korrespondenz</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-wedekind-korrespondenz"
                                                    value="wedekind-korrespondenz"/>
                                                <label class="form-check-label"
                                                    for="vproj-wedekind-korrespondenz"
                                                    style="color:#d4a346;">Wedekind-Korrespondenz</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-wienerschnitzler"
                                                    value="wienerschnitzler"/>
                                                <label class="form-check-label"
                                                    for="vproj-wienerschnitzler"
                                                    style="color:#6F5106;">Wiener Schnitzler</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-schnitzler-zeitungen"
                                                    value="schnitzler-zeitungen"/>
                                                <label class="form-check-label"
                                                    for="vproj-schnitzler-zeitungen"
                                                    style="color:#8E8575;">Zeitungsausschnitte</label>
                                            </div>
                                            <div class="form-check mb-1">
                                                <input class="form-check-input" type="checkbox"
                                                    id="vproj-zweig-digital"
                                                    value="zweig-digital"/>
                                                <label class="form-check-label"
                                                    for="vproj-zweig-digital"
                                                    style="color:#631a34;">Zweig digital</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-9">
                                        <div id="venn-container" style="height:500px; min-width:300px;"/>
                                        <div id="venn-info" class="text-center mt-2"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script src="js/venn.js"/>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () { initVennChart(); });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
