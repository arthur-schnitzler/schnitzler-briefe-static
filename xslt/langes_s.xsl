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
        <xsl:variable name="doc_title">Wörter mit langem ſ</xsl:variable>
        <xsl:variable name="total" select="/langesS/meta/totalOccurrences"/>
        <xsl:variable name="unique" select="/langesS/meta/uniqueWords"/>
        <xsl:variable name="max_count" select="max(/langesS/words/word/@count)"/>

        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header text-center">
                                <h2>Wörter mit langem ſ</h2>
                                <p class="text-muted mb-0">Die meisten Schreibenden, deren Texte hier
                                    ediert werden, verwendeten zwei unterschiedliche Formen von s: »s« und »ſ«. Diese
                                    sind lautlich nicht zu unterscheiden, aber das trifft auch für andere
                                    Zeichen und Zeichenketten zu (»f«, »ph«, »v«) zu. Eine wissenschaftliche
                                    Edition sollte dieser Unterscheidung Rechnung tragen.</p>
                                <p class="text-muted mb-0">Zudem sind viele der
                                    Schreibenden im österreichischen Schulsystem vor der Orthografiereform 1901
                                    ausgebildet und verwendeten andere Rechtschreibregeln. Dazu gehörten Unterschiede
                                    bei der »ſs«- und »ß«-Schreibung. Während lange Zeit die Ersetzungsregel 
                                    »ſs« wird zu »ß« galt, ist seit der Reform von 1997 der Ersatz »ſ« wird zu »s« und folglich 
                                    »ſs« zu »ss«
                                    sinnvoller, da er genauer den damals angewandten Regeln entspricht.</p>
                                <p class="text-muted mb-0">Wir kennen keine unmittelbare Verwendung für die folgende
                                    Liste. Auch sind Wortformen (»iſt«, »ſein«; »dieſer«, »dieſe« …) nicht zusammengeführt.
                                    Wir glauben aber trotzdem, dass jemand sie hilfreich finden wird, als Mosaiksteinchen der 
                                    Sprachpraxis in Österreich um 1900.</p>
                            </div>
                            <div class="card-body">
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
                                                    <xsl:value-of select="/langesS/words/word[1]"/>
                                                    <small class="text-muted fs-6">
                                                        <xsl:text> (</xsl:text>
                                                        <xsl:value-of select="/langesS/words/word[1]/@count"/>
                                                        <xsl:text>×)</xsl:text>
                                                    </small>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-3 d-flex gap-2">
                                    <input type="text" id="wordFilter" class="form-control"
                                        placeholder="Wort suchen (heutige Schreibweise)"
                                        onkeyup="filterTable()"
                                        aria-label="Wörter filtern"/>
                                    <button class="btn btn-outline-secondary text-nowrap" onclick="downloadCSV()">
                                        &#x2B07; CSV
                                    </button>
                                </div>

                                <div style="max-height: 75vh; overflow-y: auto;">
                                    <table class="table table-striped table-sm table-hover" id="langesS-table">
                                        <thead class="sticky-top table-dark">
                                            <tr>
                                                <th style="width:3em">#</th>
                                                <th>Wort (modern)</th>
                                                <th>Wort (mit ſ)</th>
                                                <th style="width:6em" class="text-end">Anzahl</th>
                                                <th>Häufigkeit</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:for-each select="/langesS/words/word">
                                                <xsl:variable name="rank" select="position()"/>
                                                <xsl:variable name="count" select="@count"/>
                                                <xsl:variable name="word_text" select="string(.)"/>
                                                <xsl:variable name="bar_pct" select="format-number(number($count) div number($max_count) * 100, '0.0')"/>
                                                <tr>
                                                    <td class="text-muted">
                                                        <xsl:value-of select="$rank"/>
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="$word_text"/>
                                                    </td>
                                                    <td class="font-monospace">
                                                        <xsl:value-of select="@langesS"/>
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
                                    <code>&lt;c rendition="#langesS"&gt;</code>-Elements rekonstruiert
                                    und in Kleinbuchstaben zusammengeführt.
                                </p>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
                <script>
                    function downloadCSV() {
                        var rows = document.querySelectorAll('#langesS-table tbody tr');
                        var lines = ['Rang\tWort (modern)\tWort (mit \u017F)\tAnzahl'];
                        var rank = 1;
                        rows.forEach(function(row) {
                            if (row.style.display === 'none') return;
                            var cells = row.getElementsByTagName('td');
                            var modern = cells[1] ? cells[1].textContent.trim() : '';
                            var langesS = cells[2] ? cells[2].textContent.trim() : '';
                            var count  = cells[3] ? cells[3].textContent.trim() : '';
                            lines.push(rank++ + '\t' + modern + '\t' + langesS + '\t' + count);
                        });
                        var bom = '\uFEFF';
                        var blob = new Blob([bom + lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
                        var url = URL.createObjectURL(blob);
                        var a = document.createElement('a');
                        a.href = url;
                        a.download = 'langes-s.csv';
                        a.click();
                        URL.revokeObjectURL(url);
                    }

                    function filterTable() {
                        var input = document.getElementById('wordFilter');
                        var filter = input.value.toLowerCase();
                        var tbody = document.querySelector('#langesS-table tbody');
                        var rows = tbody.getElementsByTagName('tr');
                        var rank = 1;
                        for (var i = 0; i &lt; rows.length; i++) {
                            var cells = rows[i].getElementsByTagName('td');
                            var word = cells[1] ? cells[1].textContent.toLowerCase() : '';
                            if (word.indexOf(filter) &gt; -1) {
                                rows[i].style.display = '';
                                cells[0].textContent = rank++;
                            } else {
                                rows[i].style.display = 'none';
                            }
                        }
                    }
                </script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
