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
        <xsl:variable name="doc_title" select="'Registernetzwerke'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <script src="https://code.highcharts.com/highcharts.js"/>
            <script src="https://code.highcharts.com/modules/networkgraph.js"/>
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
                </style>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <p class="text-muted mb-0">Häufigkeitsnetzwerke der am stärksten vernetzten Einträge aus den Registern</p>
                            </div>
                            <div class="card-body">
                                <ul class="nav nav-tabs mb-3" id="netzwerkeTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="tab-person-btn"
                                            data-bs-toggle="tab" data-bs-target="#tab-person"
                                            type="button" role="tab" aria-controls="tab-person"
                                            aria-selected="true">Personen</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="tab-work-btn"
                                            data-bs-toggle="tab" data-bs-target="#tab-work"
                                            type="button" role="tab" aria-controls="tab-work"
                                            aria-selected="false">Werke</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="tab-institution-btn"
                                            data-bs-toggle="tab" data-bs-target="#tab-institution"
                                            type="button" role="tab" aria-controls="tab-institution"
                                            aria-selected="false">Institutionen</button>
                                    </li>
                                </ul>
                                <div class="tab-content" id="netzwerkeTabContent">
                                    <div class="tab-pane fade show active" id="tab-person"
                                        role="tabpanel" aria-labelledby="tab-person-btn">
                                        <div class="text-center mb-3">
                                            <button class="btn mx-1 chart-btn-person"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top30.csv"
                                                >Top 30</button>
                                            <button class="btn mx-1 chart-btn-person"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top100.csv"
                                                >Top 100</button>
                                            <button class="btn mx-1 chart-btn-person"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/person_freq_corp_weights_directed/person_freq_corp_weights_directed_top500.csv"
                                                >Top 500</button>
                                        </div>
                                        <div id="container-person"
                                            style="width:100%; margin: auto; padding-bottom: 20px;"/>
                                        <div style="text-align: right; margin-top: 4px;">
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-person" data-zoom-factor="1.25">+</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-person" data-zoom-factor="0.8">&#x2212;</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 0.875rem;"
                                                data-zoom-container="container-person" data-zoom-factor="0">Reset</button>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="tab-work" role="tabpanel"
                                        aria-labelledby="tab-work-btn">
                                        <div class="text-center mb-3">
                                            <button class="btn mx-1 chart-btn-work"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top30.csv"
                                                >Top 30</button>
                                            <button class="btn mx-1 chart-btn-work"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top100.csv"
                                                >Top 100</button>
                                            <button class="btn mx-1 chart-btn-work"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/work_freq_corp_weights_directed/work_freq_corp_weights_directed_top500.csv"
                                                >Top 500</button>
                                        </div>
                                        <div id="container-work"
                                            style="width:100%; margin: auto; padding-bottom: 20px;"/>
                                        <div style="text-align: right; margin-top: 4px;">
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-work" data-zoom-factor="1.25">+</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-work" data-zoom-factor="0.8">&#x2212;</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 0.875rem;"
                                                data-zoom-container="container-work" data-zoom-factor="0">Reset</button>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="tab-institution" role="tabpanel"
                                        aria-labelledby="tab-institution-btn">
                                        <div class="text-center mb-3">
                                            <button class="btn mx-1 chart-btn-institution"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top30.csv"
                                                >Top 30</button>
                                            <button class="btn mx-1 chart-btn-institution"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top100.csv"
                                                >Top 100</button>
                                            <button class="btn mx-1 chart-btn-institution"
                                                style="background-color: #A63437; color: white; border: none; padding: 5px 10px; font-size: 0.875rem;"
                                                data-csv="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/institution_freq_corp_weights_directed/institution_freq_corp_weights_directed_top500.csv"
                                                >Top 500</button>
                                        </div>
                                        <div id="container-institution"
                                            style="width:100%; margin: auto; padding-bottom: 20px;"/>
                                        <div style="text-align: right; margin-top: 4px;">
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-institution" data-zoom-factor="1.25">+</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 1rem;"
                                                data-zoom-container="container-institution" data-zoom-factor="0.8">&#x2212;</button>
                                            <button class="btn mx-1"
                                                style="background-color: #A63437; color: white; border: none; padding: 3px 10px; font-size: 0.875rem;"
                                                data-zoom-container="container-institution" data-zoom-factor="0">Reset</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script src="js/netzwerke.js"/>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            initNetworkChart('container-person', '.chart-btn-person');
                            document.getElementById('tab-work-btn').addEventListener('shown.bs.tab', function () {
                                initNetworkChart('container-work', '.chart-btn-work');
                            });
                            document.getElementById('tab-institution-btn').addEventListener('shown.bs.tab', function () {
                                initNetworkChart('container-institution', '.chart-btn-institution');
                            });
                        });
                    </script>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
