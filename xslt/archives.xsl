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
        <xsl:variable name="doc_title" select="'Archive'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header">
                                <h1>Archive</h1>
                                <div class="btn-group" role="group" aria-label="Ansicht wechseln">
                                    <button type="button" class="btn btn-primary active" id="btn-detail-view">Detailansicht</button>
                                    <button type="button" class="btn btn-outline-primary" id="btn-summary-view">Archivübersicht</button>
                                </div>
                            </div>
                            <div class="card-body">
                                <!-- Detail View -->
                                <div id="detail-view">
                                <table class="table table-sm display" id="tabulator-table-archives">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Datum</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Titel</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Institution</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Ort</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Land</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="collection('../data/editions/?select=*.xml')/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <xsl:variable name="titel"
                                                select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"
                                                as="xs:string"/>
                                            <xsl:variable name="sortdate"
                                                select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                as="xs:date?"/>
                                            <xsl:for-each
                                                select="descendant::tei:listWit[1]/tei:witness">
                                                <xsl:variable name="id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                </xsl:variable>
                                                <xsl:variable name="schnitzler-als-empfänger">
                                                    <xsl:choose>
                                                        <xsl:when test="ancestor::tei:TEI/descendant::tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = '#pmb2121']">
                                                            <xsl:text>as-sender</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when
                                                            test="not(ancestor::tei:TEI/descendant::tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = '#pmb2121'][1]) and not(ancestor::tei:TEI/descendant::tei:correspAction[@type = 'received'][1]/tei:persName[@ref = '#pmb2121'][1])"> 
                                                            <xsl:text>umfeld</xsl:text> 
                                                        </xsl:when>
                                                        <xsl:otherwise> 
                                                            <xsl:text>as-empf</xsl:text>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:variable>
                                                <tr>
                                                  <td>
                                                  <xsl:value-of select="$sortdate"/>
                                                  </td>
                                                  <td>
                                                      <span hidden="true">
                                                          <xsl:value-of select="$titel"/>
                                                      </span>
                                                      
                                                  <a>
                                                      <xsl:attribute name="class">
                                                          <xsl:choose>
                                                              <xsl:when test="$schnitzler-als-empfänger = 'as-empf'">
                                                                  <xsl:text>sender-color</xsl:text>
                                                              </xsl:when>
                                                              <xsl:when test="$schnitzler-als-empfänger = 'umfeld'">
                                                                  <xsl:text>umfeld-color</xsl:text>
                                                              </xsl:when>
                                                              <xsl:otherwise>
                                                                  <xsl:text>theme-color</xsl:text>
                                                              </xsl:otherwise>
                                                          </xsl:choose>
                                                      </xsl:attribute>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="$titel"/>
                                                  </a>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="descendant::tei:repository[1]/text()"/>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="descendant::tei:settlement[1]/text()"/>
                                                  </td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="descendant::tei:country[1]/text()"/>
                                                  </td>
                                                </tr>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                </div>

                                <!-- Summary View -->
                                <div id="summary-view" style="display: none;">
                                <table class="table table-sm display" id="tabulator-table-archives-summary">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Archiv</th>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Ort</th>
                                            <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Anzahl</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each-group select="collection('../data/editions/?select=*.xml')/tei:TEI/descendant::tei:listWit[1]/tei:witness"
                                            group-by="concat(descendant::tei:repository[1]/text(), '|', descendant::tei:settlement[1]/text())">
                                            <xsl:sort select="descendant::tei:repository[1]/text()"/>
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="descendant::tei:repository[1]/text()"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="descendant::tei:settlement[1]/text()"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="count(current-group())"/>
                                                </td>
                                            </tr>
                                        </xsl:for-each-group>
                                    </tbody>
                                </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <!-- Separate Tabulator config for archives -->
                    <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
                    <script src="tabulator-js/config.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            // Detail View Table
                            var table = new Tabulator("#tabulator-table-archives", {
                                pagination: "local",
                                paginationSize: 25,
                                paginationCounter: "rows",
                                layout: "fitColumns",
                                responsiveLayout: "hide",
                                autoResize: true,
                                tooltips: true,
                                addRowPos: "top",
                                history: true,
                                movableColumns: true,
                                resizableRows: false,
                                responsiveLayoutCollapseStartOpen: false,
                                placeholder: "Keine Daten verfügbar",
                                initialSort: [
                                    {column: "datum", dir: "desc"}
                                ],
                                columns: [
                                    {title: "Datum", field: "datum", headerFilter: "input", formatter: "html"},
                                    {title: "Titel", field: "titel", headerFilter: "input", formatter: "html"},
                                    {title: "Institution", field: "institution", headerFilter: "input", formatter: "html"},
                                    {title: "Ort", field: "ort", headerFilter: "input", formatter: "html"},
                                    {title: "Land", field: "land", headerFilter: "input", formatter: "html"}
                                ]
                            });

                            // Summary View Table
                            var summaryTable = new Tabulator("#tabulator-table-archives-summary", {
                                pagination: "local",
                                paginationSize: 25,
                                paginationCounter: "rows",
                                layout: "fitColumns",
                                responsiveLayout: "hide",
                                autoResize: true,
                                tooltips: true,
                                addRowPos: "top",
                                history: true,
                                movableColumns: true,
                                resizableRows: false,
                                responsiveLayoutCollapseStartOpen: false,
                                placeholder: "Keine Daten verfügbar",
                                initialSort: [
                                    {column: "anzahl", dir: "desc"}
                                ],
                                columns: [
                                    {title: "Archiv", field: "archiv", headerFilter: "input", formatter: "html"},
                                    {title: "Ort", field: "ort", headerFilter: "input", formatter: "html"},
                                    {title: "Anzahl", field: "anzahl", headerFilter: "input", formatter: "html", sorter: "number"}
                                ]
                            });

                            // View Toggle
                            var btnDetailView = document.getElementById("btn-detail-view");
                            var btnSummaryView = document.getElementById("btn-summary-view");
                            var detailView = document.getElementById("detail-view");
                            var summaryView = document.getElementById("summary-view");

                            btnDetailView.addEventListener("click", function() {
                                detailView.style.display = "block";
                                summaryView.style.display = "none";
                                btnDetailView.classList.add("active");
                                btnDetailView.classList.remove("btn-outline-primary");
                                btnDetailView.classList.add("btn-primary");
                                btnSummaryView.classList.remove("active");
                                btnSummaryView.classList.remove("btn-primary");
                                btnSummaryView.classList.add("btn-outline-primary");
                            });

                            btnSummaryView.addEventListener("click", function() {
                                detailView.style.display = "none";
                                summaryView.style.display = "block";
                                btnSummaryView.classList.add("active");
                                btnSummaryView.classList.remove("btn-outline-primary");
                                btnSummaryView.classList.add("btn-primary");
                                btnDetailView.classList.remove("active");
                                btnDetailView.classList.remove("btn-primary");
                                btnDetailView.classList.add("btn-outline-primary");
                            });

                            // Download buttons
                            document.getElementById("download-csv").addEventListener("click", function() {
                                table.download("csv", "archive.csv");
                            });
                            document.getElementById("download-json").addEventListener("click", function() {
                                table.download("json", "archive.json");
                            });
                            document.getElementById("download-xlsx").addEventListener("click", function() {
                                table.download("xlsx", "archive.xlsx", {sheetName: "Archive"});
                            });
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
