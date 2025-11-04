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

            <head>
                <!-- Highcharts for statistics visualization -->
                <script src="https://code.highcharts.com/highcharts.js"></script>
                <script src="https://code.highcharts.com/modules/exporting.js"></script>
            </head>

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
                <!-- Load statistics charts -->
                <script src="js/statistics-charts.js"></script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[not(@type)]">
        <div class="mb-4">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='image']">
        <div class="row mb-5">
            <div class="col-md-12">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:figure">
        <xsl:variable name="image-url" select="tei:graphic/@url"/>
        <xsl:variable name="chart-id">
            <xsl:choose>
                <xsl:when test="contains($image-url, 'image1.png')">chart1</xsl:when>
                <xsl:when test="contains($image-url, 'image2.png')">chart2</xsl:when>
                <xsl:when test="contains($image-url, 'image5.png')">chart3</xsl:when>
                <xsl:when test="contains($image-url, 'image4.png')">chart4</xsl:when>
                <xsl:when test="contains($image-url, 'image3.png')">chart5</xsl:when>
                <xsl:when test="contains($image-url, 'image6.png')">chart6</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <figure class="my-4">
            <xsl:choose>
                <!-- Special handling for chart6: two separate charts -->
                <xsl:when test="$chart-id = 'chart6'">
                    <div class="row">
                        <div class="col-md-6">
                            <div id="chart6-goldmann" style="width: 100%; min-height: 400px;"></div>
                        </div>
                        <div class="col-md-6">
                            <div id="chart6-hofmannsthal" style="width: 100%; min-height: 400px;"></div>
                        </div>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div id="{$chart-id}" style="width: 100%; min-height: 500px;"></div>
                </xsl:otherwise>
            </xsl:choose>
            <figcaption class="text-center text-muted mt-2">
                <xsl:apply-templates select="tei:caption"/>
            </figcaption>
        </figure>
    </xsl:template>

    <xsl:template match="tei:caption">
        <xsl:apply-templates/>
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

    <xsl:template match="tei:hi[@rend='italics']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="tei:c[@rendition='#prozent']">
        <xsl:text>%</xsl:text>
    </xsl:template>

</xsl:stylesheet>