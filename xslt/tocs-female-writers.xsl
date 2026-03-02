<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:java="http://www.java.com/" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title"
            select="'Verzeichnis der Korrespondenzen mit Schriftstellerinnen'"/>
        <xsl:variable name="listperson" select="document('../data/indices/listperson.xml')"/>
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
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Verzeichnis der Korrespondenzen mit Schriftstellerinnen</h1>
                                <div class="btn-group mt-3" role="group" aria-label="Ansicht auswählen">
                                    <button type="button" class="btn btn-primary" id="view-gallery-btn" onclick="showGalleryView()">Galerie</button>
                                    <button type="button" class="btn btn-outline-primary" id="view-table-btn" onclick="showTableView()">Tabelle</button>
                                </div>
                            </div>
                            <div class="card-body">
                                <!-- Einleitung -->
                                <div id="intro-view">
                                    <div style="display: flex; justify-content: center; width: 100%; margin-bottom: 1.5rem;">
                                        <div style="max-width: 800px; text-align: left;">
                                            <p>Die Korrespondenzen, die Schnitzler mit Schriftstellerinnen
                                                geführt hat, sind nicht besonders umfangreich. Auf seiner <a href="https://schnitzler-lektueren.acdh.oeaw.ac.at/listperson.html" target="_blank">Leseliste</a>
                                                kommt im Schnitt eine Autorin auf neun männliche Autoren. In beiden
                                                Fällen kann nicht ein ausgeglichenes Verhältnis konstatiert werden. Es lässt sich
                                                aber festhalten, dass Schnitzler Schriftstellerinnen
                                                wahrnahm und sie rezipierte.</p>
                                            <p>Die vorliegende Edition strebt
                                                eine vollständige Edition aller dazugehörigen
                                                Korrespondenzen an, sofern ein tatsächlicher Austausch
                                                anzunehmen ist. Nicht berücksichtigt wurden bislang zwei
                                                umfangreichere Korrespondenzen an der Grenzlinie zwischen
                                                persönlicher und beruflicher Freundschaft. Beide liegen
                                                eingebettet in autobiografische Zeugnisse des Gegenübers
                                                vor: Clara Katharina Pollaczek, die Lebensgefährtin
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
                                        </div>
                                    </div>
                                </div>

                                <!-- Gallery View -->
                                <div id="gallery-view">
                                    <div class="mb-3">
                                        <input type="text" id="gallery-search" class="form-control"
                                            placeholder="Korrespondenz suchen…"
                                            oninput="filterGallery(this.value)"/>
                                    </div>
                                    <div class="correspondence-grid">
                                        <xsl:for-each
                                            select="document('../data/indices/listcorrespondence.xml')/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:listPerson[1]/tei:personGrp[not(@xml:id = 'correspondence_null') and not(@ana = 'planned') and @corresp = 'female-correspondence-partner']">
                                            <xsl:sort select="tei:persName[@role = 'main'][1]/text()"/>
                                            <xsl:variable name="corr-id" select="replace(@xml:id, 'correspondence_', '')"/>
                                            <xsl:variable name="person-ref" select="substring-after(tei:persName[@role = 'main'][1]/@ref, '#')"/>
                                            <xsl:variable name="corr-name" select="mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text())"/>
                                            <xsl:variable name="status" select="@ana"/>
                                            <xsl:variable name="person-image" select="$listperson//tei:person[@xml:id = $person-ref]/tei:figure/tei:graphic/@url"/>
                                            <xsl:variable name="brief-count" select="count(document(concat('../data/tocs/toc_', $corr-id, '.xml'))/tei:TEI[1]/tei:text[1]/tei:body[1]/tei:list[1]/tei:item)"/>

                                            <div class="correspondence-card">
                                                <div class="card mb-3">
                                                    <xsl:choose>
                                                        <xsl:when test="$person-image != ''">
                                                            <img src="{$person-image}" class="card-img-top" alt="{$corr-name}"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <img src="img/schattenriss_1900.jpg" class="card-img-top" alt="{$corr-name}"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <div class="card-body">
                                                        <h5 class="card-title">
                                                            <xsl:value-of select="$corr-name"/>
                                                        </h5>
                                                        <p class="card-text">
                                                            <strong><xsl:value-of select="$brief-count"/></strong>
                                                            <xsl:text> </xsl:text>
                                                            <xsl:choose>
                                                                <xsl:when test="$brief-count = 1">Brief</xsl:when>
                                                                <xsl:otherwise>Briefe</xsl:otherwise>
                                                            </xsl:choose>
                                                        </p>
                                                        <xsl:if test="$status = 'corrections-in-progress'">
                                                            <p class="text-muted small mb-2">
                                                                <i class="fa fa-info-circle"></i> Alle Korrespondenzstücke aufgenommen, Korrekturen laufen noch
                                                            </p>
                                                        </xsl:if>
                                                        <xsl:if test="$status = 'edition-in-progress'">
                                                            <p class="text-muted small mb-2">
                                                                <i class="fa fa-info-circle"></i> Edition noch nicht vollständig
                                                            </p>
                                                        </xsl:if>
                                                        <div class="correspondence-buttons">
                                                            <a href="{concat('toc_', $corr-id, '.html')}" class="btn btn-briefe w-100 mb-2" style="background-color: #A63437; border-color: #A63437; color: white;">
                                                                <i class="fa fa-list"></i> Briefe
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </div>

                                <!-- Table View -->
                                <div id="table-view" style="display: none;">
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
                                                        <xsl:choose>
                                                            <xsl:when test="@ana='planned'">
                                                                <xsl:value-of
                                                                    select="tei:persName[@role = 'main']/text()"/>
                                                                <xsl:text> (geplant)</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <a>
                                                                    <xsl:attribute name="class">
                                                                        <xsl:text>sender-color</xsl:text>
                                                                    </xsl:attribute>
                                                                    <xsl:attribute name="href">
                                                                        <xsl:value-of
                                                                            select="concat(replace(@xml:id, 'correspondence', 'toc'), '.html')"
                                                                        />
                                                                    </xsl:attribute>
                                                                    <xsl:value-of
                                                                        select="tei:persName[@role = 'main']/text()"/>
                                                                </a>
                                                                <xsl:choose>
                                                                    <xsl:when test="@ana = 'corrections-in-progress'">
                                                                        <xsl:text> (Korrektur läuft)</xsl:text>
                                                                    </xsl:when>
                                                                    <xsl:when test="@ana = 'edition-in-progress'">
                                                                        <xsl:text> (Briefaufnahme läuft)</xsl:text>
                                                                    </xsl:when>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
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
                                    <xsl:call-template name="tabulator_dl_buttons"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"/>
                    <script src="tabulator-js/tabulator-limited.js"/>
                    <style>
                        .correspondence-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                            gap: 1.5rem;
                            margin-top: 1rem;
                        }

                        .correspondence-card .card {
                            display: flex;
                            flex-direction: column;
                            height: 100%;
                            transition: transform 0.2s, box-shadow 0.2s;
                            overflow: hidden;
                        }

                        .correspondence-card .card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
                        }

                        .correspondence-card .card-img-top {
                            height: 280px;
                            width: 100%;
                            object-fit: cover;
                            object-position: top;
                            flex-shrink: 0;
                        }

                        .correspondence-card .card-body {
                            display: flex;
                            flex-direction: column;
                            gap: 0.75rem;
                            flex: 1;
                        }

                        .correspondence-card .card-title {
                            margin-bottom: 0;
                            font-size: 1.1rem;
                            min-height: 2.5em;
                        }

                        .correspondence-buttons {
                            display: flex;
                            flex-direction: column;
                            gap: 0.5rem;
                            margin-top: auto;
                        }

                        .btn-briefe {
                            font-size: 0.95rem;
                            padding: 0.5rem 1rem;
                            font-weight: 500;
                        }
                    </style>
                    <script>
                        function filterGallery(query) {
                            var cards = document.querySelectorAll('.correspondence-card');
                            var q = query.toLowerCase();
                            cards.forEach(function(card) {
                                var title = card.querySelector('.card-title');
                                if (title &amp;&amp; title.textContent.toLowerCase().includes(q)) {
                                    card.style.display = '';
                                } else {
                                    card.style.display = 'none';
                                }
                            });
                        }

                        function showGalleryView() {
                            document.getElementById('gallery-view').style.display = 'block';
                            document.getElementById('intro-view').style.display = 'block';
                            document.getElementById('table-view').style.display = 'none';
                            document.getElementById('view-gallery-btn').classList.remove('btn-outline-primary');
                            document.getElementById('view-gallery-btn').classList.add('btn-primary');
                            document.getElementById('view-table-btn').classList.remove('btn-primary');
                            document.getElementById('view-table-btn').classList.add('btn-outline-primary');
                        }

                        function showTableView() {
                            document.getElementById('gallery-view').style.display = 'none';
                            document.getElementById('intro-view').style.display = 'none';
                            document.getElementById('table-view').style.display = 'block';
                            document.getElementById('view-gallery-btn').classList.remove('btn-primary');
                            document.getElementById('view-gallery-btn').classList.add('btn-outline-primary');
                            document.getElementById('view-table-btn').classList.remove('btn-outline-primary');
                            document.getElementById('view-table-btn').classList.add('btn-primary');
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
