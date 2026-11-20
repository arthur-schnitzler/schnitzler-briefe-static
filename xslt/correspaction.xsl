<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <!-- Orte in Wien (für den Switch "Nur Verbindungen innerhalb Wiens"): Wien (pmb50), die
         Bezirke (pmb51–pmb73) und jeder Ort, der direkt oder über Zwischenstufen (Straße, Haus,
         Postamt …) per located_in_place in einem davon liegt, d. h. einen von ihnen als Vorfahren
         hat. Die Menge wird von diesen Wurzeln abwärts aufgebaut, bis nichts mehr dazukommt; die
         Wurzeln zählen auch dann, wenn sie selbst keinen Eintrag in listplace.xml haben. -->
    <xsl:variable name="listplace" select="document('../data/indices/listplace.xml')"/>
    <xsl:key name="place-by-parent" match="tei:place"
        use="tei:location[@type = 'located_in_place']/tei:placeName/@key"/>
    <xsl:function name="local:orte-in" as="xs:string*">
        <xsl:param name="ids" as="xs:string*"/>
        <xsl:variable name="erweitert" as="xs:string*"
            select="distinct-values(($ids, for $p in key('place-by-parent', $ids, $listplace) return string($p/@xml:id)))"/>
        <xsl:sequence
            select="if (count($erweitert) = count($ids)) then $ids else local:orte-in($erweitert)"/>
    </xsl:function>
    <xsl:variable name="wien-ids" as="xs:string*"
        select="local:orte-in(for $n in 50 to 73 return concat('pmb', $n))"/>
    <!-- Städteansicht (Switch "Nur Städte anzeigen"): schnitzler-briefe-cmif.xml enthält dieselben
         Briefe mit denselben Stationen wie die Briefe selbst (deren genaue Orte stehen auch in
         schnitzler-briefe-cmif_precise-location.xml), die Orte sind aber durch den übergeordneten
         Ort ersetzt, z. B. Wien statt einer Adresse in Wien. Fehlt die Datei oder ein Brief darin,
         zeigt die Städteansicht für diesen Brief die genauen Orte. -->
    <xsl:variable name="cmif-staedte-pfad" select="'../data/indices/schnitzler-briefe-cmif.xml'"/>
    <xsl:variable name="cmif-staedte"
        select="if (doc-available($cmif-staedte-pfad)) then doc($cmif-staedte-pfad) else ()"/>
    <xsl:key name="cmif-brief" match="tei:correspDesc" use="@xml:id"/>
    <xsl:key name="place-by-id" match="tei:place" use="@xml:id"/>
    <xsl:function name="local:json-string" as="xs:string">
        <xsl:param name="s" as="xs:string"/>
        <xsl:sequence
            select="concat('&quot;', replace(replace($s, '\\', '\\\\'), '&quot;', '\\&quot;'), '&quot;')"/>
    </xsl:function>
    <!-- Orte der Städteansicht für die Karte (data-stadt-orte am #container), als JSON
         {"50": [Breite, Länge, "Wien", true], …}. Die Koordinaten kommen aus listplace.xml; hat ein
         Ort dort keinen Eintrag (manche Orte kommen nur als übergeordneter Ort vor), die des ersten
         Orts in listplace.xml, der in ihm liegt. Der letzte Wert sagt, ob es eine Seite zum Ort gibt
         (die Ortsseiten entstehen aus listplace.xml). -->
    <xsl:variable name="stadt-orte-json" as="xs:string">
        <xsl:variable name="eintraege" as="xs:string*">
            <xsl:for-each-group
                select="$cmif-staedte//tei:correspAction/tei:placeName[starts-with(@ref, '#pmb')]"
                group-by="substring-after(@ref, '#')">
                <xsl:variable name="id" select="current-grouping-key()"/>
                <xsl:variable name="ort" select="key('place-by-id', $id, $listplace)[1]"/>
                <xsl:variable name="geo"
                    select="tokenize(normalize-space(string((($ort/tei:location[@type = 'coords']/tei:geo), key('place-by-parent', $id, $listplace)/tei:location[@type = 'coords']/tei:geo)[normalize-space()][1])), ' ')"/>
                <xsl:variable name="breite" select="translate(string($geo[1]), ',', '.')"/>
                <xsl:variable name="laenge" select="translate(string($geo[2]), ',', '.')"/>
                <xsl:if test="$breite castable as xs:decimal and $laenge castable as xs:decimal">
                    <xsl:sequence
                        select="concat('&quot;', substring-after($id, 'pmb'), '&quot;:[', xs:decimal($breite), ',', xs:decimal($laenge), ',', local:json-string(normalize-space(string(($ort/tei:placeName[1], current-group()[1])[1]))), ',', exists($ort), ']')"/>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:sequence select="concat('{', string-join($eintraege, ','), '}')"/>
    </xsl:variable>
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
                                    data-wien-ids="{string-join(for $id in $wien-ids return replace($id, '^pmb', ''), ' ')}"
                                    data-stadt-orte="{$stadt-orte-json}"
                                    style="height:600px; width:100%; margin: 0 auto 20px; border-radius:4px;"/>
                                <script src="js/postwege_weights_directed.js"/>
                                <style type="text/css">
                                    #toggle-uncertain:checked { background-color: #A63437; border-color: #A63437; }
                                    #toggle-wien-view:checked { background-color: #A63437; border-color: #A63437; }
                                    #toggle-staedte:checked { background-color: #A63437; border-color: #A63437; }
                                </style>
                                <div class="mb-2">
                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                        id="toggle-info" aria-expanded="false"
                                        aria-controls="postwege-info">
                                        <span aria-hidden="true">ⓘ</span> Infotext anzeigen
                                    </button>
                                </div>
                                <div id="postwege-info" class="alert alert-light border mb-3" hidden="hidden">
                                    <p class="mb-2">Die Karte zeigt die Postwege der Korrespondenzstücke in
                                        der Edition: Jede Linie verbindet den Ort, an dem ein Brief
                                        abgeschickt wurde, mit dem Ort, an dem er empfangen wurde, wobei
                                        er über weitere Stationen (z. B. Postämter) geleitet worden sein kann. Je mehr Briefe
                                        denselben Weg nahmen, desto dicker erscheint die Linie; die Größe
                                        der Kreise entspricht der Zahl der Briefe, die an einem Ort
                                        geschrieben oder empfangen wurden. Die <span style="color:#A63437;">rote</span> Projektfarbe verweist
                                        auf von Schnitzler verfasste Korrespondenzstücke, <span style="color:#1C6E8C;">blau</span> auf solche,
                                        die an ihn gerichtet waren. Umfeldbriefe sind in  <span style="color:#68825b;">grün</span>  dargestellt.</p>
                                    <p>Mit dem Schalter »Nur Städte anzeigen« treten in Karte und Tabelle
                                        an die Stelle genauer Ortsangaben wie Adressen, Hotels oder Postämter
                                        die übergeordneten Orte (z. B. Wien). So lassen sich Briefe auch
                                        über diese Orte finden.</p>
                                    <p class="mb-0">Die Tabelle darunter steuert die Karte: Wenn Sie
                                        in den Spaltenköpfen filtern, zeigt die Karte nur die
                                        passenden Briefe.</p>
                                </div>
                                <div class="d-flex flex-wrap align-items-center mb-3" style="column-gap: 1.5rem; row-gap: .5rem;">
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" id="toggle-staedte"/>
                                        <label class="form-check-label" for="toggle-staedte">Nur Städte anzeigen</label>
                                    </div>
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" id="toggle-wien-view"/>
                                        <label class="form-check-label" for="toggle-wien-view">Nur Verbindungen innerhalb Wiens</label>
                                    </div>
                                    <div class="form-check form-switch mb-0">
                                        <input class="form-check-input" type="checkbox" id="toggle-uncertain" checked="checked"/>
                                        <label class="form-check-label" for="toggle-uncertain">Unsichere Datierungen anzeigen</label>
                                    </div>
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
                                            <th scope="col" tabulator-visible="false">fromId</th>
                                            <th scope="col" tabulator-visible="false">toId</th>
                                            <th scope="col" tabulator-visible="false">routeIds</th>
                                            <th scope="col" tabulator-visible="false">uncertain</th>
                                            <th scope="col" tabulator-visible="false">kategorie</th>
                                            <!-- Städteansicht: Sendeort, weitere Stationen, Empfangsort und
                                                 Stationen aus schnitzler-briefe-cmif.xml (siehe $cmif-staedte).
                                                 tabulator-visible="false" an allen versteckten Spalten: Tabulator legt
                                                 zuerst aus den th vorläufige Spalten an (je 40px) und versteckt dabei
                                                 schon Spalten für das mobile Einklappen; dieser Zähler wird nicht
                                                 zurückgesetzt, wenn autoColumns die richtigen Spalten anlegt. Zählten
                                                 die versteckten Spalten mit, klappte mobil die falsche bzw. gar keine
                                                 Spalte ein. -->
                                            <th scope="col" tabulator-visible="false">sendeortStadt</th>
                                            <th scope="col" tabulator-visible="false">stationenStadt</th>
                                            <th scope="col" tabulator-visible="false">empfangsortStadt</th>
                                            <th scope="col" tabulator-visible="false">routeIdsStadt</th>
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
                                            <xsl:variable name="farbklasse" as="xs:string"
                                                select="if ($schnitzler-als-empfänger = 'as-empf') then 'sender-color' else if ($schnitzler-als-empfänger = 'umfeld') then 'umfeld-color' else 'theme-color'"/>
                                            <!-- Städteansicht: derselbe Brief in schnitzler-briefe-cmif.xml, sonst der Brief selbst -->
                                            <xsl:variable name="brief-id"
                                                select="replace(tokenize($full_path, '/')[last()], '\.xml$', '')"/>
                                            <xsl:variable name="stadt-cd" as="element(tei:correspDesc)?"
                                                select="((if ($cmif-staedte) then key('cmif-brief', $brief-id, $cmif-staedte) else ()), descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1])[1]"/>
                                            <xsl:variable name="route-ids-stadt" select="
                                                    string-join(
                                                    for $ca in $stadt-cd/tei:correspAction[tei:placeName[1]/@ref]
                                                    return replace(string($ca/tei:placeName[1]/@ref), '#pmb', ''),
                                                    '|')
                                                    "/>
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
                                                <td><xsl:value-of select="$schnitzler-als-empfänger"/></td>
                                                <!-- Städteansicht, aufgebaut wie die Zellen Sendeort, weitere Stationen
                                                     und Empfangsort oben -->
                                                <td>
                                                    <xsl:variable name="ort" select="$stadt-cd/tei:correspAction[1]/tei:placeName[1]"/>
                                                    <span hidden="true">
                                                        <xsl:value-of select="normalize-space($ort)"/>
                                                    </span>
                                                    <xsl:call-template name="stadt-ort">
                                                        <xsl:with-param name="placeName" select="$ort"/>
                                                        <xsl:with-param name="farbklasse" select="$farbklasse"/>
                                                    </xsl:call-template>
                                                </td>
                                                <td>
                                                    <xsl:for-each
                                                        select="$stadt-cd/tei:correspAction[not(position() = 1 or position() = last())]">
                                                        <xsl:if test="tei:date">
                                                            <xsl:value-of select="normalize-space(string-join(tei:date, ' '))"/>
                                                        </xsl:if>
                                                        <xsl:if test="tei:date and tei:placeName">
                                                            <xsl:text> </xsl:text>
                                                        </xsl:if>
                                                        <xsl:if test="tei:placeName">
                                                            <xsl:call-template name="stadt-ort">
                                                                <xsl:with-param name="placeName" select="tei:placeName[1]"/>
                                                                <xsl:with-param name="farbklasse" select="$farbklasse"/>
                                                                <xsl:with-param name="vermutet" select="@evidence = 'conjecture'"/>
                                                            </xsl:call-template>
                                                        </xsl:if>
                                                        <xsl:if test="not(position() = last())">
                                                            <br/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </td>
                                                <td>
                                                    <xsl:call-template name="stadt-ort">
                                                        <xsl:with-param name="placeName"
                                                            select="$stadt-cd/tei:correspAction[last()]/tei:placeName[1]"/>
                                                        <xsl:with-param name="farbklasse" select="$farbklasse"/>
                                                    </xsl:call-template>
                                                </td>
                                                <td><xsl:value-of select="$route-ids-stadt"/></td>
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
                                    var hidden = ["id", "fromid", "toid", "routeids", "uncertain", "kategorie", "sendeortstadt", "stationenstadt", "empfangsortstadt", "routeidsstadt"];
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

                            // Switch "Nur Städte anzeigen": Die Tabelle hält zwei Fassungen derselben Briefe,
                            // mit den genauen Orten (wie im Brief) und mit den übergeordneten Orten aus
                            // schnitzler-briefe-cmif.xml (versteckte Spalten *stadt). Umgeschaltet wird, indem
                            // die Tabelle die andere Fassung lädt; Headerfilter und Sortierung bleiben dabei
                            // erhalten und wirken dann auf die Städte (z. B. Sendeort "Wien").
                            var genaueDaten = null;
                            var stadtDaten = null;
                            var datenTausch = false; // während des Umschaltens: Karte erst danach neu zeichnen

                            function hatHeaderfilter() {
                                return table.getFilters(true).some(function(f) {
                                    return f.field !== "uncertain";
                                });
                            }

                            function zeigeNurStaedte(nurStaedte) {
                                if (!genaueDaten) return;
                                var geladen;
                                datenTausch = true;
                                try {
                                    geladen = table.replaceData(nurStaedte ? stadtDaten : genaueDaten);
                                } finally {
                                    datenTausch = false;
                                }
                                geladen.then(function() {
                                    var gefiltert = hatHeaderfilter();
                                    window.postwegeMap.replaceConnections(gefiltert ? table.getData("active") : table.getData(), gefiltert);
                                });
                            }

                            // Karte initial aus allen Zeilen aufbauen, sobald die Tabelle steht
                            // (liefert routeIds + kategorie je Brief für die Einfärbung der Karte)
                            table.on("tableBuilt", function() {
                                genaueDaten = table.getData();
                                stadtDaten = genaueDaten.map(function(d) {
                                    return Object.assign({}, d, {
                                        sendeort: d.sendeortstadt,
                                        weitere_stationen: d.stationenstadt,
                                        empfangsort: d.empfangsortstadt,
                                        routeids: d.routeidsstadt
                                    });
                                });
                                window.postwegeMap.init(table.getData());
                                // Browser können den Zustand der Switches beim Neuladen wiederherstellen
                                if (document.getElementById("toggle-wien-view").checked) {
                                    window.postwegeMap.setWienOnly(true);
                                }
                                if (document.getElementById("toggle-staedte").checked) {
                                    zeigeNurStaedte(true);
                                }
                            });

                            // Karte aktualisieren wenn Tabelle gefiltert wird
                            // (nicht beim Toggle-Filter, nur bei Header-Filtern)
                            table.on("dataFiltered", function(filters, rows) {
                                if (datenTausch) return;
                                var hasNonToggleFilter = filters.some(function(f) {
                                    return f.field !== "uncertain";
                                });
                                if (hasNonToggleFilter) {
                                    updateMapFromRows(rows);
                                } else if (window.postwegeMap) {
                                    // Headerfilter aufgehoben: Karte wieder aus allen Zeilen aufbauen
                                    window.postwegeMap.resetConnections(table.getData());
                                }
                            });

                            // Infotext ein-/ausblenden
                            document.getElementById("toggle-info").addEventListener("click", function() {
                                var info = document.getElementById("postwege-info");
                                var open = info.hasAttribute("hidden");
                                if (open) info.removeAttribute("hidden"); else info.setAttribute("hidden", "hidden");
                                this.setAttribute("aria-expanded", open ? "true" : "false");
                                this.lastChild.textContent = open ? " Infotext ausblenden" : " Infotext anzeigen";
                            });

                            // Toggle: genaue Orte / nur Städte (übergeordnete Orte)
                            document.getElementById("toggle-staedte").addEventListener("change", function() {
                                zeigeNurStaedte(this.checked);
                            });

                            // Toggle: alle Verbindungen / nur Verbindungen zwischen Orten in Wien
                            document.getElementById("toggle-wien-view").addEventListener("change", function() {
                                if (!window.postwegeMap) return;
                                window.postwegeMap.setWienOnly(this.checked);
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
                            window.postwegeMap.setConnections(rows.map(function(row) {
                                return row.getData();
                            }));
                        }
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
    <!-- Ort in einer Zelle der Städteansicht: Link auf die Ortsseite, wie bei den genauen Orten;
         Orte ohne Eintrag in listplace.xml haben keine Seite und erscheinen ohne Link. -->
    <xsl:template name="stadt-ort">
        <xsl:param name="placeName" as="element(tei:placeName)?"/>
        <xsl:param name="farbklasse" as="xs:string"/>
        <xsl:param name="vermutet" as="xs:boolean" select="$placeName/@evidence = 'conjecture'"/>
        <xsl:variable name="id" select="substring-after(string($placeName/@ref), '#')"/>
        <xsl:variable name="name" select="normalize-space($placeName)"/>
        <xsl:choose>
            <xsl:when test="$id != '' and key('place-by-id', $id, $listplace)">
                <a class="{$farbklasse}" href="{$id}.html">
                    <xsl:value-of select="$name"/>
                </a>
            </xsl:when>
            <xsl:when test="$name != ''">
                <span class="{$farbklasse}">
                    <xsl:value-of select="$name"/>
                </span>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="$vermutet">
            <xsl:text> (?)</xsl:text>
        </xsl:if>
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
