<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="./params.xsl"/>
    <xsl:template match="/" name="html_head">
        <xsl:param name="html_title" select="$project_short_title"/>
        <xsl:param name="html_description" select="''"/>
        <xsl:param name="html_url" select="''"/>
        <xsl:param name="html_image" select="concat($base_url, '/img/og-image.jpg')"/>

        <!-- Construct canonical URL if not provided -->
        <xsl:variable name="canonical_url">
            <xsl:choose>
                <!-- If caller provided a URL, use it -->
                <xsl:when test="normalize-space($html_url) != ''">
                    <xsl:value-of select="$html_url"/>
                </xsl:when>
                <!-- Otherwise, construct URL from source filename -->
                <xsl:otherwise>
                    <xsl:variable name="current_file">
                        <xsl:choose>
                            <!-- For index/meta pages, use base URL -->
                            <xsl:when test="contains(base-uri(), 'index.xml') or contains(base-uri(), 'meta.xml')">
                                <xsl:value-of select="''"/>
                            </xsl:when>
                            <!-- For other files, extract filename and change extension to .html -->
                            <xsl:otherwise>
                                <xsl:value-of select="replace(tokenize(base-uri(), '/')[last()], '.xml', '.html')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$current_file != ''">
                            <xsl:value-of select="concat($base_url, '/', $current_file)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$base_url"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="html_title1">
            <!-- brachialer Eingriff für index -->
            <xsl:choose>
                <xsl:when test="$html_title = 'Meta' or $html_title = 'meta'">
                    <xsl:text>Arthur Schnitzler Briefwechsel – Digitale Edition (1885–1931) | Hg. Martin Anton Müller mit Gerd-Hermann
Susen, Laura Untner und Selma Jahnke</xsl:text>
                </xsl:when>
                <xsl:when test="normalize-space(string-join($html_title, '')) = ''">
                    <xsl:value-of select="$project_short_title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$html_title"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="html_description1">
            <xsl:choose>
                <xsl:when test="normalize-space(string-join($html_description, '')) != ''">
                    <xsl:value-of select="$html_description"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Die Website enthält </xsl:text>
                    <xsl:value-of select="$total_letters_formatted"/>
                    <xsl:text> Briefe von und an Arthur Schnitzler (1862–1931). Veröffentlicht werden </xsl:text>
                    <xsl:value-of select="$complete_correspondences_formatted"/>
                    <xsl:text> vollständige Korrespondenzen in textkritischer Wiedergabe mit Faksimiles. Digitale Edition. Herausgegeben von Martin Anton Müller mit Gerd-Hermann Susen, Laura Untner und Selma Jahnke.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        <meta name="mobile-web-app-capable" content="yes"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <meta name="apple-mobile-web-app-title" content="{$html_title1}"/>
        <meta name="msapplication-TileColor" content="#ffffff"/>
        <meta name="msapplication-TileImage" content="./img/favicon/ms-icon-144x144.png"/>
        <link rel="icon" type="image/x-icon" href="./img/favicon/favicon.ico"/>
        <link rel="apple-touch-icon" sizes="57x57" href="./img/favicon/apple-icon-57x57.png"/>
        <link rel="apple-touch-icon" sizes="60x60" href="./img/favicon/apple-icon-60x60.png"/>
        <link rel="apple-touch-icon" sizes="72x72" href="./img/favicon/apple-icon-72x72.png"/>
        <link rel="apple-touch-icon" sizes="76x76" href="./img/favicon/apple-icon-76x76.png"/>
        <link rel="apple-touch-icon" sizes="114x114" href="./img/favicon/apple-icon-114x114.png"/>
        <link rel="apple-touch-icon" sizes="120x120" href="./img/favicon/apple-icon-120x120.png"/>
        <link rel="apple-touch-icon" sizes="144x144" href="./img/favicon/apple-icon-144x144.png"/>
        <link rel="apple-touch-icon" sizes="152x152" href="./img/favicon/apple-icon-152x152.png"/>
        <link rel="apple-touch-icon" sizes="180x180" href="./img/favicon/apple-icon-180x180.png"/>
        <link rel="icon" type="image/png" sizes="192x192" href="./img/favicon/android-icon-192x192.png"/>
        <link rel="icon" type="image/png" sizes="32x32" href="./img/favicon/favicon-32x32.png"/>
        <link rel="icon" type="image/png" sizes="96x96" href="./img/favicon/favicon-96x96.png"/>
        <link rel="icon" type="image/png" sizes="16x16" href="./img/favicon/favicon-16x16.png"/>
        <link rel="manifest" href="./img/favicon/manifest.json"/>
        <meta name="msapplication-config" content="./img/favicon/browserconfig.xml"/>
        <link rel="profile" href="http://gmpg.org/xfn/11"/>
        <title>
            <xsl:value-of select="$html_title1"/>
        </title>

        <!-- SEO Meta Tags -->
        <meta name="description" content="{$html_description1}"/>
        <link rel="canonical" href="{$canonical_url}"/>

        <!-- Open Graph / Facebook -->
        <meta property="og:type" content="website"/>
        <meta property="og:url" content="{$canonical_url}"/>
        <meta property="og:title" content="{$html_title1}"/>
        <meta property="og:description" content="{$html_description1}"/>
        <meta property="og:image" content="{$html_image}"/>
        <meta property="og:locale" content="de_AT"/>
        <meta property="og:site_name" content="Arthur Schnitzler Briefwechsel"/>

        <!-- Twitter -->
        <meta property="twitter:card" content="summary_large_image"/>
        <meta property="twitter:url" content="{$canonical_url}"/>
        <meta property="twitter:title" content="{$html_title1}"/>
        <meta property="twitter:description" content="{$html_description1}"/>
        <meta property="twitter:image" content="{$html_image}"/>

        <!-- Font Awesome with font-display:swap for better performance -->
        <link rel="preload"
            href="css/fontawesome-optimized.min.css"
            as="style"
            onload="this.onload=null;this.rel='stylesheet'"/>
        <noscript>
            <link rel="stylesheet" href="css/fontawesome-optimized.min.css"/>
        </noscript>
        <link rel="preload" type="text/css"
            href="https://cdn.datatables.net/v/bs4/jq-3.3.1/jszip-2.5.0/dt-1.11.0/b-2.0.0/b-html5-2.0.0/cr-1.5.4/r-2.2.9/sp-1.4.0/datatables.min.css"
            as="style"
            onload="this.onload=null;this.rel='stylesheet'"/>
        <noscript>
            <link rel="stylesheet" type="text/css"
                href="https://cdn.datatables.net/v/bs4/jq-3.3.1/jszip-2.5.0/dt-1.11.0/b-2.0.0/b-html5-2.0.0/cr-1.5.4/r-2.2.9/sp-1.4.0/datatables.min.css"/>
        </noscript>
        <link rel="profile" href="http://gmpg.org/xfn/11"/>
        <!-- Critical CSS: Bootstrap loaded asynchronously -->
        <link rel="preload"
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
            as="style"
            onload="this.onload=null;this.rel='stylesheet'"
            integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
            crossorigin="anonymous"/>
        <noscript>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
                rel="stylesheet"
                integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
                crossorigin="anonymous"/>
        </noscript>
        <!-- Critical CSS inline for immediate rendering -->
        <style>
/* Critical CSS for above-the-fold */
*,:after,:before{box-sizing:border-box}body{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;line-height:1.5}.theme-color{color:#A63437}a{color:#A63437;text-decoration:none}.navbar{position:relative;display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;padding:.5rem 1rem}.navbar-brand{display:inline-block;padding-top:.3125rem;padding-bottom:.3125rem;margin-right:1rem;font-size:1.25rem;line-height:inherit;white-space:nowrap}.intro{background-color:#fff;height:93vh;overflow:hidden;border-bottom:3px solid #A63437}.intro_left{padding:2rem}.intro_left h1,.intro_left h3,.intro_left h4{margin:1rem 0}.btn{display:inline-block;font-weight:400;text-align:center;white-space:nowrap;vertical-align:middle;user-select:none;border:1px solid transparent;padding:.375rem .75rem;font-size:1rem;line-height:1.5;border-radius:.25rem;transition:color .15s ease-in-out,background-color .15s ease-in-out}.btn-round{background-color:#A63437;color:#fff;border-radius:2rem;padding:.5rem 2rem}.btn-round:hover{background-color:#8a2a2d;color:#fff}.d-block{display:block!important}.w-100{width:100%!important}.img-fluid{max-width:100%;height:auto}.container,.container-fluid{width:100%;padding-right:15px;padding-left:15px;margin-right:auto;margin-left:auto}.row{display:flex;flex-wrap:wrap;margin-right:-15px;margin-left:-15px}.col-md-6{flex:0 0 50%;max-width:50%;padding-right:15px;padding-left:15px}@media (max-width:768px){.col-md-6{flex:0 0 100%;max-width:100%}.intro{height:auto}}
        </style>
        <!-- Full stylesheet loaded asynchronously -->
        <link rel="preload" href="css/style.css" as="style" onload="this.onload=null;this.rel='stylesheet'"/>
        <noscript>
            <link rel="stylesheet" href="css/style.css" type="text/css"/>
        </noscript>
        <!-- Scripts with defer for optimal loading -->
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous" defer="defer"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous" defer="defer"/>
        <script src="js/listStopProp.js" defer="defer"/>
        <script src="js/toggle-commentary-mentions.js" defer="defer"/>
        <script src="js/fragezeichen.js" defer="defer"></script>
        <script src="js/accessibility-enhancements.js" defer="defer"></script>
        <script src="js/lemma-anchor-scroll.js" defer="defer"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.3.0/papaparse.min.js" defer="defer"/>
        <xsl:if test="descendant::tei:div[@xml:id = 'jung-wien-container-ohne-slider'] or descendant::tei:div[@xml:id = 'jung-wien-container-mit-slider'] or descendant::tei:div[@xml:id = 'jung-wien-container-nebeneinander'] or descendant::tei:div[@xml:id = 'jung-wien-container-nebeneinander-mit-slider']">
            <script src="https://code.highcharts.com/highcharts.js" defer="defer"/>
            <script src="https://code.highcharts.com/modules/networkgraph.js" defer="defer"/>
            <script src="https://code.highcharts.com/modules/exporting.js" defer="defer"/>
            <script src="https://d3js.org/d3.v7.min.js" defer="defer"/>
        </xsl:if>
        <!-- Matomo -->
        <script type="text/javascript">
            var _paq = _paq ||[];
            /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
            _paq.push([ 'trackPageView']);
            _paq.push([ 'enableLinkTracking']);
            (function () {
                var u = "https://matomo.acdh.oeaw.ac.at/";
                _paq.push([ 'setTrackerUrl', u + 'piwik.php']);
                _paq.push([ 'setSiteId', '171']);<!--
                171 is Matomo Code schnitzler - briefe//-->
            var d = document, g = d.createElement('script'), s = d.getElementsByTagName('script')[0];
            g.type = 'text/javascript';
            g. async = true;
            g.defer = true;
            g.src = u + 'piwik.js';
            s.parentNode.insertBefore(g, s);
        })();</script>
        <!-- End Matomo Code -->
    </xsl:template>
</xsl:stylesheet>
