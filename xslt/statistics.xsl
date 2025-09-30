<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/shared.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
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
                            <div class="card-header">
                                <h2 align="center">
                                    <xsl:value-of select="$doc_title"/>
                                </h2>
                                <p class="text-center text-muted">
                                    <em>Hinweis: Diese Statistiken basieren auf den lokalen Daten in diesem Repository und sind möglicherweise nicht vollständig.</em>
                                </p>
                            </div>
                            <div class="card-body">
                                <xsl:apply-templates select="descendant::tei:body"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
                <!-- Load Chart.js for visualizations -->
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
                <script src="js-data/letterStatistics.js"></script>
                <script>
                    // Create charts once the page is loaded
                    document.addEventListener('DOMContentLoaded', function() {
                        if (typeof letterStatistics !== 'undefined') {
                            createLetterCharts(letterStatistics);
                        }
                    });

                    function createLetterCharts(stats) {
                        // Chart 1: Letters by Year
                        const yearCtx = document.getElementById('chartByYear');
                        if (yearCtx &amp;&amp; stats.by_year) {
                            const years = Object.keys(stats.by_year).sort();
                            const counts = years.map(y => stats.by_year[y]);

                            new Chart(yearCtx, {
                                type: 'bar',
                                data: {
                                    labels: years,
                                    datasets: [{
                                        label: 'Anzahl Briefe',
                                        data: counts,
                                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                        borderColor: 'rgba(54, 162, 235, 1)',
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: {
                                                stepSize: 1
                                            }
                                        }
                                    },
                                    plugins: {
                                        title: {
                                            display: true,
                                            text: 'Briefe nach Jahren'
                                        }
                                    }
                                }
                            });
                        }

                        // Chart 2: Schnitzler as Sender/Receiver
                        const roleCtx = document.getElementById('chartByRole');
                        if (roleCtx) {
                            new Chart(roleCtx, {
                                type: 'pie',
                                data: {
                                    labels: ['Von Schnitzler', 'An Schnitzler', 'Umfeldbriefe'],
                                    datasets: [{
                                        data: [
                                            stats.schnitzler_sent || 0,
                                            stats.schnitzler_received || 0,
                                            stats.third_party || 0
                                        ],
                                        backgroundColor: [
                                            'rgba(255, 99, 132, 0.5)',
                                            'rgba(54, 162, 235, 0.5)',
                                            'rgba(255, 206, 86, 0.5)'
                                        ],
                                        borderColor: [
                                            'rgba(255, 99, 132, 1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 206, 86, 1)'
                                        ],
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: {
                                        title: {
                                            display: true,
                                            text: 'Verteilung nach Rolle Schnitzlers'
                                        }
                                    }
                                }
                            });
                        }

                        // Chart 3: Top Correspondences
                        const corrCtx = document.getElementById('chartTopCorrespondences');
                        if (corrCtx &amp;&amp; stats.by_correspondence) {
                            const sortedCorr = Object.entries(stats.by_correspondence)
                                .sort((a, b) => b[1] - a[1])
                                .slice(0, 10);
                            const corrLabels = sortedCorr.map(([id, count]) => 'corr_' + id);
                            const corrCounts = sortedCorr.map(([id, count]) => count);

                            new Chart(corrCtx, {
                                type: 'bar',
                                data: {
                                    labels: corrLabels,
                                    datasets: [{
                                        label: 'Anzahl Briefe',
                                        data: corrCounts,
                                        backgroundColor: 'rgba(75, 192, 192, 0.5)',
                                        borderColor: 'rgba(75, 192, 192, 1)',
                                        borderWidth: 1
                                    }]
                                },
                                options: {
                                    indexAxis: 'y',
                                    responsive: true,
                                    plugins: {
                                        title: {
                                            display: true,
                                            text: 'Top 10 Korrespondenzen'
                                        }
                                    }
                                }
                            });
                        }
                    }
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='statistics']">
        <div class="row mb-4">
            <div class="col-md-12">
                <h3>Überblick</h3>
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='by_year']">
        <div class="row mb-4">
            <div class="col-md-6">
                <h3><xsl:value-of select="tei:head"/></h3>
                <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                    <xsl:apply-templates select="tei:table"/>
                </div>
            </div>
            <div class="col-md-6">
                <canvas id="chartByYear"></canvas>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='top_correspondences']">
        <div class="row mb-4">
            <div class="col-md-6 offset-md-3">
                <canvas id="chartByRole"></canvas>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='data_export']">
        <div class="row mb-4">
            <div class="col-md-12 text-center">
                <p>
                    <xsl:text>Daten herunterladen: </xsl:text>
                    <a href="js-data/letterStatistics.json" title="JSON herunterladen" class="btn btn-sm btn-outline-secondary ms-2">
                        <i class="fa-solid fa-download"></i> JSON
                    </a>
                    <a href="js-data/letterStatistics.js" title="JavaScript herunterladen" class="btn btn-sm btn-outline-secondary ms-2">
                        <i class="fa-solid fa-download"></i> JS
                    </a>
                </p>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:table">
        <table class="table table-striped table-sm">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="tei:row[@role='label']">
        <thead>
            <tr>
                <xsl:apply-templates/>
            </tr>
        </thead>
    </xsl:template>

    <xsl:template match="tei:row[not(@role='label')]">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="tei:cell[parent::tei:row[@role='label']]">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>

    <xsl:template match="tei:cell[not(parent::tei:row[@role='label'])]">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:num">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="tei:ref[@target]">
        <a href="{@target}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:label">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>

</xsl:stylesheet>