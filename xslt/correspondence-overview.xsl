<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

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

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Einzelne Korrespondenzen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Einzelne Korrespondenzen</h1>
                                <p>Wählen Sie eine Korrespondenz aus, um detaillierte Statistiken, Netzwerke und Karten zu sehen.</p>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group mb-3">
                                            <input type="text" id="correspondence-search" class="form-control" placeholder="Korrespondenz suchen..."/>
                                        </div>

                                        <div class="correspondence-grid">
                                            <xsl:for-each select="//tei:personGrp[not(@xml:id = 'correspondence_null') and not(@ana = 'planned')]">
                                                <xsl:sort select="tei:persName[@role = 'main'][1]/text()"/>
                                                <xsl:variable name="corr-id" select="substring-after(@xml:id, 'correspondence_')"/>
                                                <xsl:variable name="corr-name" select="string-join(mam:vorname-vor-nachname(tei:persName[@role = 'main'][1]/text()), '')"/>
                                                <xsl:variable name="is-female" select="@corresp = 'female-correspondence-partner'"/>
                                                <xsl:variable name="status" select="@ana"/>

                                                <div class="correspondence-card" data-name="{$corr-name}">
                                                    <div class="card mb-3">
                                                        <div class="card-body">
                                                            <xsl:if test="$status = 'corrections-in-progress'">
                                                                <p class="text-muted small">
                                                                    <i class="fa fa-info-circle"></i> Alle Korrespondenzstücke aufgenommen, Korrekturen laufen noch
                                                                </p>
                                                            </xsl:if>
                                                            <xsl:if test="$status = 'edition-in-progress'">
                                                                <p class="text-muted small">
                                                                    <i class="fa fa-info-circle"></i> Edition noch nicht vollständig
                                                                </p>
                                                            </xsl:if>
                                                            <h5 class="card-title">
                                                                <xsl:value-of select="$corr-name"/>
                                                                <xsl:if test="$is-female">
                                                                    <span class="badge bg-info me-2">Schriftstellerin</span>
                                                                </xsl:if>
                                                            </h5>

                                                            <div class="btn-group" role="group">
                                                                <a href="{concat('toc_', $corr-id, '.html')}" class="btn btn-sm btn-primary">
                                                                    <i class="fa fa-list"></i> Briefe
                                                                </a>
                                                                <a href="{concat('statistik_pmb', $corr-id, '.html')}" class="btn btn-sm btn-secondary">
                                                                    <i class="fa fa-chart-bar"></i> Statistiken
                                                                </a>
                                                                <a href="{concat('netzwerke_pmb', $corr-id, '.html')}" class="btn btn-sm btn-secondary">
                                                                    <i class="fa fa-project-diagram"></i> Netzwerke
                                                                </a>
                                                                <a href="{concat('karte_pmb', $corr-id, '.html')}" class="btn btn-sm btn-secondary">
                                                                    <i class="fa fa-map-marked-alt"></i> Karte
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>

                <script>
                    // Search functionality
                    document.getElementById('correspondence-search').addEventListener('input', function(e) {
                        const searchTerm = e.target.value.toLowerCase();
                        const cards = document.querySelectorAll('.correspondence-card');

                        cards.forEach(card => {
                            const name = card.dataset.name.toLowerCase();
                            card.style.display = name.includes(searchTerm) ? 'block' : 'none';
                        });
                    });
                </script>

                <style>
                    .correspondence-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                        gap: 1rem;
                    }

                    .correspondence-card .card {
                        height: 100%;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .correspondence-card .card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                    }

                    .btn-group {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 0.25rem;
                    }

                    .btn-group .btn {
                        flex: 1;
                        min-width: 0;
                    }
                </style>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
