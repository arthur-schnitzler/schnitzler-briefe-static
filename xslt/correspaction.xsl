<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Postwege'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
                integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
                crossorigin=""/>
            <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""/>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <!-- Breadcrumbs -->
                        <nav class="crumbs mt-1" aria-label="Brotkrumennavigation" style="--project-color: {$current-colour};">
                            <span class="type-pill">Karten</span> <span class="sep">/</span>
                            <xsl:text>Postwege</xsl:text>
                        </nav>
                        <div class="card">
                            <div class="card-header">
                                <h1>Postwege</h1>
                            </div>
                            <div class="card-body">
                                <div id="container"
                                    style="height:600px; width:100%; margin: 0 auto 20px; border-radius:4px;"/>
                                <script src="js/postwege_weights_directed.js"/>
                                <style type="text/css">
                                    #toggle-uncertain:checked { background-color: #A63437; border-color: #A63437; }
                                </style>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="toggle-uncertain" checked="checked"/>
                                    <label class="form-check-label" for="toggle-uncertain">Unsichere Datierungen anzeigen</label>
                                </div>
                                <div>
                                <table class="table table-sm display"
                                    id="tabulator-table-correspaction">
                                    <thead>
                                        <tr>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Titel</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Sendedatum</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Sendeort</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">weitere Stationen</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Empfangsdatum</th>
                                            <th scope="col" tabulator-headerFilter="input"
                                                tabulator-formatter="html">Empfangsort</th>
                                            <th scope="col">fromId</th>
                                            <th scope="col">toId</th>
                                            <th scope="col">routeIds</th>
                                            <th scope="col">uncertain</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each
                                            select="collection('../data/editions/?select=*.xml')/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <xsl:variable name="uncertain">
                                                <xsl:choose>
                                                    <xsl:when test="contains(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type='sent'][1]/tei:date, '?') or contains(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type='received'][1]/tei:date, '?')">
                                                        <xsl:text>true</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text>false</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:variable name="from-id">
                                                <xsl:value-of select="replace(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type='sent'][1]/tei:placeName[1]/@ref, '#pmb', '')"/>
                                            </xsl:variable>
                                            <xsl:variable name="to-id">
                                                <xsl:value-of select="replace(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type='received'][1]/tei:placeName[1]/@ref, '#pmb', '')"/>
                                            </xsl:variable>
                                            <!-- alle Stationen des Postwegs (nicht nur Versand/Empfang), für die Kartenaktualisierung bei gefilterter Tabelle -->
                                            <xsl:variable name="route-ids">
                                                <xsl:value-of select="
                                                        string-join(
                                                        for $ca in descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[tei:placeName[1]/@ref]
                                                        return replace(string($ca/tei:placeName[1]/@ref), '#pmb', ''),
                                                        '|')
                                                        "/>
                                            </xsl:variable>
                                            <xsl:variable name="schnitzler-als-empfänger">
                                                <xsl:choose>
                                                    <xsl:when test="child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = '#pmb2121']">
                                                        <xsl:text>as-sender</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="not(child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = '#pmb2121'][1]) and not(child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'received'][1]/tei:persName[@ref = '#pmb2121'][1])"> 
                                                        <xsl:text>umfeld</xsl:text> </xsl:when>
                                                    <xsl:otherwise> 
                                                        <xsl:text>as-empf</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <tr data-uncertain="{$uncertain}">
                                                <td>
                                                  <span hidden="true">
                                                      <xsl:value-of
                                                          select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"
                                                      />
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
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"
                                                  />
                                                  </a>
                                                </td>
                                                <td>
                                                 <span hidden="true">
                                                     <xsl:choose>
                                                         <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@when">
                                                             <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@when"/>
                                                         </xsl:when>
                                                         <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@from">
                                                             <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@from"/>
                                                         </xsl:when>
                                                         <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@notBefor">
                                                             <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@notBefore"/>
                                                         </xsl:when>
                                                         <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@notAfter">
                                                             <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@notAfter"/>
                                                         </xsl:when>
                                                         <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@to">
                                                             <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/@to"/>
                                                         </xsl:when>
                                                     </xsl:choose>
                                                  </span>
                                                  <xsl:value-of
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:date"
                                                  />
                                                </td>
                                                <td>
                                                  <span hidden="true">
                                                      <xsl:value-of
                                                          select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:placeName"
                                                      />
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
                                                  select="concat(replace(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:placeName/@ref, '#', ''), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:placeName"
                                                  />
                                                  </a>
                                                    <xsl:if test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[1]/tei:placeName/@evidence='conjecture'">
                                                        <xsl:text> (?)</xsl:text>
                                                    </xsl:if>
                                                </td>
                                                <td>
                                                  <xsl:for-each
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[not(position() = 1 or position() = last())]">
                                                  <xsl:if test="tei:date">
                                                  <xsl:value-of select="tei:date"/>
                                                  </xsl:if>
                                                  <xsl:if test="tei:date and tei:placeName">
                                                  <xsl:text> </xsl:text>
                                                  </xsl:if>
                                                  <xsl:if test="tei:placeName">
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
                                                  select="concat(replace(tei:placeName/@ref, '#', ''), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="tei:placeName"/>
                                                  </a>
                                                      <xsl:if test="@evidence='conjecture'">
                                                          <xsl:text> (?)</xsl:text>
                                                      </xsl:if>
                                                  </xsl:if>
                                                  <xsl:if test="not(position() = last())">
                                                  <br/>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                </td>
                                                <td>
                                                  <span hidden="true">
                                                      <xsl:choose>
                                                          <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@when">
                                                              <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@when"/>
                                                          </xsl:when>
                                                          <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@from">
                                                              <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@from"/>
                                                          </xsl:when>
                                                          <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@notBefor">
                                                              <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@notBefore"/>
                                                          </xsl:when>
                                                          <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@notAfter">
                                                              <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@notAfter"/>
                                                          </xsl:when>
                                                          <xsl:when test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@to">
                                                              <xsl:value-of select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date[1]/@to"/>
                                                          </xsl:when>
                                                      </xsl:choose>
                                                  </span>
                                                  <xsl:value-of
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:date"
                                                  />
                                                </td>
                                                <td>
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
                                                  select="concat(replace(descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:placeName/@ref, '#', ''), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:placeName"
                                                  />
                                                  </a>
                                                    <xsl:if test="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[last()]/tei:placeName/@evidence='conjecture'">
                                                        <xsl:text> (?)</xsl:text>
                                                    </xsl:if>
                                                </td>
                                                <td><xsl:value-of select="$from-id"/></td>
                                                <td><xsl:value-of select="$to-id"/></td>
                                                <td><xsl:value-of select="$route-ids"/></td>
                                                <td><xsl:value-of select="$uncertain"/></td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <!-- Separate Tabulator config for correspaction -->
                    <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
                    <script src="tabulator-js/config.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            var table = new Tabulator("#tabulator-table-correspaction", {
                                pagination: "local",
                                paginationSize: 25,
                                paginationCounter: "rows",
                                layout: "fitColumns",
                                responsiveLayout: "collapse",
                                autoResize: true,
                                tooltips: true,
                                addRowPos: "top",
                                history: true,
                                movableColumns: true,
                                resizableRows: false,
                                responsiveLayoutCollapseStartOpen: false,
                                placeholder: "Keine Daten verfügbar",
                                initialSort: [
                                    {column: "sendedatum", dir: "asc"}
                                ],
                                autoColumns: true,
                                autoColumnsDefinitions: function(definitions) {
                                    var hidden = ["id", "fromid", "toid", "routeids", "uncertain"];
                                    var priorities = {"titel":0,"sendedatum":2,"empfangsdatum":3,"sendeort":4,"empfangsort":5,"weitere_stationen":6};
                                    var minWidths = {"titel":160,"sendedatum":95,"empfangsdatum":95,"sendeort":90,"empfangsort":90};
                                    var titles = {"titel":"Titel","sendedatum":"Sendedatum","empfangsdatum":"Empfangsdatum","sendeort":"Sendeort","empfangsort":"Empfangsort","weitere_stationen":"weitere Stationen"};
                                    definitions.forEach(function(column) {
                                        if (hidden.indexOf(column.field) !== -1) {
                                            column.visible = false;
                                        } else {
                                            column.formatter = "html";
                                            column.headerFilter = "input";
                                            if (titles[column.field]) {
                                                column.title = titles[column.field];
                                            } else if (column.title) {
                                                column.title = column.title.charAt(0).toUpperCase() + column.title.slice(1);
                                            }
                                            if (priorities[column.field] !== undefined) { column.responsive = priorities[column.field]; }
                                            if (minWidths[column.field]) { column.minWidth = minWidths[column.field]; }
                                        }
                                    });
                                    definitions.unshift(tabulatorCollapseColumn);
                                    return definitions;
                                }
                            });

                            // Karte aktualisieren wenn Tabelle gefiltert wird
                            // (nicht beim Toggle-Filter, nur bei Header-Filtern)
                            table.on("dataFiltered", function(filters, rows) {
                                var hasNonToggleFilter = filters.some(function(f) {
                                    return f.field !== "uncertain";
                                });
                                if (hasNonToggleFilter) {
                                    updateMapFromRows(rows);
                                }
                            });

                            // Toggle: unsichere Datierungen aus-/einblenden
                            document.getElementById("toggle-uncertain").addEventListener("change", function() {
                                if (this.checked) {
                                    table.removeFilter("uncertain", "!=", "true");
                                } else {
                                    table.addFilter("uncertain", "!=", "true");
                                }
                            });

                            // Download buttons (nur wenn vorhanden)
                            var dlCsv = document.getElementById("download-csv");
                            if (dlCsv) dlCsv.addEventListener("click", function() { table.download("csv", "postwege.csv"); });
                            var dlJson = document.getElementById("download-json");
                            if (dlJson) dlJson.addEventListener("click", function() { table.download("json", "postwege.json"); });
                            var dlXlsx = document.getElementById("download-xlsx");
                            if (dlXlsx) dlXlsx.addEventListener("click", function() { table.download("xlsx", "postwege.xlsx", {sheetName: "Postwege"}); });
                        });

                        function updateMapFromRows(rows) {
                            if (!window.postwegeMap) return;

                            // routeids listet alle Stationen des Postwegs (nicht nur Versand/Empfang);
                            // jede aufeinanderfolgende Etappe wird als eigene Kante gezählt und über
                            // die sichtbaren Briefe hinweg zu einem Gewicht zusammengefasst.
                            var connectionCounts = {};
                            rows.forEach(function(row) {
                                var data = row.getData();
                                var stationIds = (data.routeids || "").split("|").filter(function(id) { return id; });
                                stationIds.slice(1).forEach(function(toId, idx) {
                                    var key = stationIds[idx] + "|" + toId;
                                    connectionCounts[key] = (connectionCounts[key] || 0) + 1;
                                });
                            });

                            var connections = Object.keys(connectionCounts).map(function(key) {
                                var parts = key.split("|");
                                return { from: parts[0], to: parts[1], weight: connectionCounts[key] };
                            });

                            window.postwegeMap.setConnections(connections);
                        }
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
