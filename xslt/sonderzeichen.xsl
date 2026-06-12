<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:decimal-format name="de" grouping-separator="." decimal-separator=","/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">Sonderzeichen</xsl:variable>

        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <!-- Breadcrumbs -->
                        <nav class="crumbs mt-1" aria-label="Brotkrumennavigation" style="--project-color: {$current-colour};">
                            <span class="type-pill">Technisches</span> <span class="sep">/</span>
                            <xsl:text>Sonderzeichen</xsl:text>
                        </nav>
                        <div class="card">
                            <div class="card-header">
                                <h2>Sonderzeichen</h2>
                            </div>
                            <div class="card-body">
                                <div class="entity-theme" style="--project-color: {$current-colour};">
                                    <div class="entity-tabs" role="tablist" aria-label="Sonderzeichen">
                                        <xsl:for-each select="/sonderzeichen/charType">
                                            <button type="button" role="tab"
                                                id="tab-{@type}"
                                                data-tab="pane-{@type}"
                                                aria-controls="pane-{@type}">
                                                <xsl:attribute name="class">
                                                    <xsl:text>entity-tab-btn</xsl:text>
                                                    <xsl:if test="position() = 1"> active</xsl:if>
                                                </xsl:attribute>
                                                <xsl:attribute name="aria-selected">
                                                    <xsl:value-of select="position() = 1"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="@label"/>
                                            </button>
                                        </xsl:for-each>
                                    </div>
                                    <xsl:for-each select="/sonderzeichen/charType">
                                        <xsl:variable name="type" select="@type"/>
                                        <xsl:variable name="char" select="@char"/>
                                        <xsl:variable name="total" select="meta/totalOccurrences"/>
                                        <xsl:variable name="unique" select="meta/uniqueWords"/>
                                        <xsl:variable name="max_count" select="max(words/word/@count)"/>
                                        <div role="tabpanel"
                                            id="pane-{@type}"
                                            aria-labelledby="tab-{@type}">
                                            <xsl:attribute name="class">
                                                <xsl:text>entity-tab-panel</xsl:text>
                                                <xsl:if test="position() = 1"> active</xsl:if>
                                            </xsl:attribute>

                                            <!-- Einleitung -->
                                            <xsl:choose>
                                                <xsl:when test="$type = 'langesS'">
                                                    <div class="mb-4">
                                                        <p class="text-muted mb-0">Die meisten Schreibenden, deren Texte hier
                                                            ediert werden, verwendeten zwei unterschiedliche Formen von s: »s« und »ſ«. Diese
                                                            sind lautlich nicht zu unterscheiden, aber das trifft auch für andere
                                                            Zeichen und Zeichenketten der deutschen Sprache zu (»f«, »ph«, »v«) zu. Eine wissenschaftliche
                                                            Edition sollte dieser Unterscheidung Rechnung tragen.</p>
                                                        <p class="text-muted mb-0">Zudem sind viele der
                                                            Schreibenden im österreichischen Schulsystem vor der Orthografiereform 1901
                                                            ausgebildet und verwendeten andere Rechtschreibregeln als die in Deutschland üblichen. Dazu gehören Unterschiede
                                                            bei der »ſs«- und »ß«-Schreibung. Kurz gefasst: In Österreich schrieb man bis zur Reform 1901 »dass«, danach wurde
                                                            das »daß« aus Deutschland zur Norm. Die Rechtschreibreform von 1997 wechselte wieder zum »dass«. Während
                                                            also lange Zeit die Rechtschreibung von Schnitzler und seinen Landsleuten zur deutschen ›normalisiert‹ wurde und zwei
                                                            Regeln für die Umschrift zum Einsatz kamen (»ſs« wird zu »ß«, »ſ« zu »s«), genügt heute eine
                                                            einfache Ersetzung: »ſ« wird zu »s«.</p>
                                                        <p class="text-muted mb-0">Wir kennen keine unmittelbare Verwendung für die folgende
                                                            Liste. Auch sind verschiedenen Wortformen (»iſt«, »ſein«; »dieſer«, »dieſe« …) nicht zusammengeführt.
                                                            Wir glauben aber trotzdem, dass jemand sie hilfreich finden wird, als Mosaiksteinchen der
                                                            Sprachpraxis in Österreich um 1900.</p>
                                                    </div>
                                                </xsl:when>
                                                <xsl:when test="$type = 'gemination-m'">
                                                    <!-- Einleitung Gemination m̅: hier einfügen -->
                                                    <div class="mb-4">
                                                        <p class="text-muted mb-0">Eine Verdoppelung von Konsonanten durch einen 
                                                        Überstrich war eine häufige Praxis. In dem von uns bearbeiteten Korpus
                                                        fällt auf, dass es innerhalb einer Handschrift zumeist beide Formen gab,
                                                        also dass sich die Grenze nicht zwischen verschiedenen Schreibenden, sondern innerhalb der Praxis eines Schreibenden befindet. 
                                                        </p>
                                                        <p class="text-muted mb-0">Es folgt eine Aufstellung, bei denen das »m« gedoppelt wurde.</p>
                                                        </div>
                                                </xsl:when>
                                                <xsl:when test="$type = 'gemination-n'">
 <!-- Einleitung Gemination m̅: hier einfügen -->
                                                    <div class="mb-4">
                                                        <p class="text-muted mb-0">Eine Verdoppelung von Konsonanten durch einen 
                                                        Überstrich war eine häufige Praxis. In dem von uns bearbeiteten Korpus
                                                        fällt auf, dass es innerhalb einer Handschrift zumeist beide Formen gab,
                                                        also dass sich die Grenze nicht zwischen verschiedenen Schreibenden, sondern innerhalb der Praxis eines Schreibenden befindet. 
                                                        </p>
                                                        <p class="text-muted mb-0">Es folgt eine Aufstellung, bei denen das »n« gedoppelt wurde.</p>
                                                        </div>                                                </xsl:when>
                                            </xsl:choose>

                                            <div class="row mb-4">
                                                <div class="col-md-4">
                                                    <div class="card text-center border-secondary">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Vorkommen gesamt</h5>
                                                            <p class="display-6">
                                                                <xsl:value-of select="format-number(number($total), '#.###', 'de')"/>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="card text-center border-secondary">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Einzigartige Wörter</h5>
                                                            <p class="display-6">
                                                                <xsl:value-of select="format-number(number($unique), '#.###', 'de')"/>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="card text-center border-secondary">
                                                        <div class="card-body">
                                                            <h5 class="card-title">Häufigstes Wort</h5>
                                                            <p class="display-6">
                                                                <xsl:value-of select="words/word[1]"/>
                                                                <small class="text-muted fs-6">
                                                                    <xsl:text> (</xsl:text>
                                                                    <xsl:value-of select="words/word[1]/@count"/>
                                                                    <xsl:text>×)</xsl:text>
                                                                </small>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3 d-flex gap-2">
                                                <input type="text" id="filter-{@type}" class="form-control"
                                                    placeholder="Wort suchen (heutige Schreibweise)"
                                                    onkeyup="filterTable('{@type}')"
                                                    aria-label="Wörter filtern"/>
                                                <button class="btn btn-outline-secondary text-nowrap" onclick="downloadCSV('{@type}')">
                                                    &#x2B07; CSV
                                                </button>
                                            </div>

                                            <div style="max-height: 75vh; overflow-y: auto;">
                                                <table class="table table-striped table-sm table-hover" id="table-{@type}">
                                                    <thead class="sticky-top table-dark">
                                                        <tr>
                                                            <th style="width:3em">#</th>
                                                            <th>Wort (modern)</th>
                                                            <th>
                                                                <xsl:value-of select="concat('Wort (mit ', $char, ')')"/>
                                                            </th>
                                                            <th style="width:6em" class="text-end">Anzahl</th>
                                                            <th>Häufigkeit</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <xsl:for-each select="words/word">
                                                            <xsl:variable name="rank" select="position()"/>
                                                            <xsl:variable name="count" select="@count"/>
                                                            <xsl:variable name="bar_pct" select="format-number(number($count) div number($max_count) * 100, '0.0')"/>
                                                            <tr>
                                                                <td class="text-muted">
                                                                    <xsl:value-of select="$rank"/>
                                                                </td>
                                                                <td>
                                                                    <xsl:value-of select="string(.)"/>
                                                                </td>
                                                                <td class="font-monospace">
                                                                    <xsl:value-of select="@original"/>
                                                                </td>
                                                                <td class="text-end">
                                                                    <xsl:value-of select="$count"/>
                                                                </td>
                                                                <td>
                                                                    <div class="progress" style="height:1.1em; min-width:4em;">
                                                                        <div class="progress-bar"
                                                                            role="progressbar"
                                                                            style="width:{$bar_pct}%; background-color:#A63437;"
                                                                            aria-valuenow="{$count}"
                                                                            aria-valuemin="0"
                                                                            aria-valuemax="{$max_count}">
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </xsl:for-each>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <p class="text-muted mt-2 small">
                                                Wörter werden aus dem unmittelbaren Textkontext des
                                                <code>&lt;c rendition="#<xsl:value-of select="$type"/>"&gt;</code>-Elements rekonstruiert.
                                            </p>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
                <script>
                    function downloadCSV(type) {
                        var rows = document.querySelectorAll('#table-' + type + ' tbody tr');
                        var lines = ['Rang\tWort (modern)\tWort (original)\tAnzahl'];
                        var rank = 1;
                        rows.forEach(function(row) {
                            if (row.style.display === 'none') return;
                            var cells = row.getElementsByTagName('td');
                            var modern = cells[1] ? cells[1].textContent.trim() : '';
                            var original = cells[2] ? cells[2].textContent.trim() : '';
                            var count  = cells[3] ? cells[3].textContent.trim() : '';
                            lines.push(rank++ + '\t' + modern + '\t' + original + '\t' + count);
                        });
                        var bom = '\uFEFF';
                        var blob = new Blob([bom + lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
                        var url = URL.createObjectURL(blob);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = 'sonderzeichen-' + type + '.csv';
                        a.click();
                        URL.revokeObjectURL(url);
                    }

                    function filterTable(type) {
                        var filter = document.getElementById('filter-' + type).value.toLowerCase();
                        var rank = 1;
                        Array.from(document.querySelectorAll('#table-' + type + ' tbody tr')).forEach(function(row) {
                            var cells = row.getElementsByTagName('td');
                            var word = cells[1] ? cells[1].textContent.toLowerCase() : '';
                            if (word.includes(filter)) {
                                row.style.display = '';
                                cells[0].textContent = rank++;
                            } else {
                                row.style.display = 'none';
                            }
                        });
                    }
                </script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
