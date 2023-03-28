<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="tei xsl xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/params.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren'"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="wrapper" id="wrapper-hero">
                        <!-- ******************* The Hero Area ******************* -->
                        <div class="wrapper" id="wrapper-hero-content"
                            style="background-image:url(https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/hero-bg.jpg);">
                            <div class="container-fluid-empty hero-light" id="wrapper-hero-inner"
                                tabindex="-1">
                                <div>
                                    <h3 class="mt-3">Arthur Schnitzler</h3>
                                    <h1 class="mt-3">Briefwechsel mit Autorinnen und
                                        Autoren </h1>
                                    <h3 class="mt-3">1888–1931</h3>
                                </div>
                                <p class="mt-3">Diese Website bringt 44 vollständige
                                    Korrespondenzen mit knapp 3.000 Briefen von und an
                                    Arthur Schnitzler (1862–1931). Viele davon werden
                                    erstmals veröffentlicht. Alle sind nach den
                                    Originalen in Archiven in Europa und Amerika
                                    durchgesehen und korrigiert.</p>
                                <p  class="mt-3">Die 45. Korrespondenz, jene mit Paul Goldmann, wird derzeit
                                ediert, 300 Briefe sind bereits aufgenommen. </p>
                                <a
                                    href="L00001.html">
                                    <button class="btn btn-round">Lesen</button>
                                </a>
                                <span>&#160;&#160;</span>
                                <a
                                    href="about.html">
                                    <button class="btn btn-round">Weiter</button>
                                </a>
                            </div>
                        </div>
                        <!-- #wrapper-hero-content -->
                        <div class="wrapper" id="index-wrapper">
                            <div class="container-fluid-start" id="content" tabindex="-1">
                                <div class="row">
                                    <!-- Do the left sidebar check and opens the primary div -->
                                    <div class="col-md-12 content-area" id="primary">
                                        <main class="site-main" id="main">
                                            <!-- Use custom content block templates if they are defined -->
                                            <div class="card-wrapper">
                                                <!--<article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="#" rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/brief.jpg"
                                                                alt=""/>
                                                        </a>
                                                        <script src="https://randojs.com/1.0.0.js"></script>
                                                        <script>
                                                            var lower = 0;
                                                            var upper = 2900;
                                                            var url = "L0"+(Math.floor(Math.random()*(upper-lower))+lower)+".html"
                                                            var a = document.createElement('a');
                                                            var linkText = document.createTextNode("my title text");
                                                            a.appendChild(linkText);
                                                            a.title = "my title text";
                                                            a.href = $url;
                                                            document.body.appendChild(a);
                                                            a = document.createElement("a");
                                                            p.innerHTML = "Your name is "+lengthOfName+" characters long.";
                                                            document.body.appendChild(p);
                                                        </script>
                                                    </div>-\->
                                                    <!-\- .card-inner -\->
                                                </article>-->
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;"
                                                            href="tocs.html" rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/korrespondenzen.jpg"
                                                                title="Quelle: ANNO, Die Bühne, datum=19310315"
                                                                alt="Schnitzlers Arbeitstisch"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="tocs.html" rel="bookmark"
                                                                        class="light">Einzelne Korrespondenzen</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Auswahl anhand der Korrespondenzpartnerinnen
                                                                    und -partner.</p>
                                                                <a class="btn btn-round mb-1"
                                                                    href="tocs.html">Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="calendar.html"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/calendar.jpg"
                                                                title="Detail aus http://www.ifm-wolfen.de/index.php?id=110005000534 CC BY-NC-SA"
                                                                alt="Kalenderdetail"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="calendar.html" rel="bookmark"
                                                                        class="light">Kalenderansicht</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Korrespondenzstücke anhand eines Datums
                                                                    finden.</p>
                                                                <a class="btn btn-round mb-1" href="calendar.html"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="persons.html"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/persons.jpg"
                                                                title="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an Schnitzler, Cambridge University Library"
                                                                alt="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an Schnitzler, Cambridge University Librar"
                                                            />
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="listperson.html" rel="bookmark"
                                                                        class="light">Personenverzeichnis</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>In den Korrespondenzstücken vorkommende
                                                                    Personen.</p>
                                                                <a class="btn btn-round mb-1" href="listperson.html"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="listwork.html"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/werke.jpg"
                                                                title="Nahaufnahme von Buchrücken CC BY 0"
                                                                alt="Nahaufnahme von Buchrücken"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="listwork.html" rel="bookmark" class="light"
                                                                        >Werkverzeichnis</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Erwähnungen von literarischen und
                                                                    künstlerischen Werken.</p>
                                                                <a class="btn btn-round mb-1" href="listwork.html"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="listplace.html"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/places.jpg"
                                                                alt="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                                title="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                            />
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="listplace.html" rel="bookmark" class="light"
                                                                        >Ortsverzeichnis</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Erwähnte geografische Orte. Diese sind auch über ihre Koordinaten
                                                                    erschlossen.</p>
                                                                <a class="btn btn-round mb-1" href="listplace.html"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                                <!-- #post-## -->
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="listorg.html"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/org.jpg"
                                                                title="Briefkopf d’Ora" alt="Briefkopf d’Ora"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="listorg.html" rel="bookmark" class="light"
                                                                        >Institutionen und Organisationen</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Vorkommende Verlage, Institutionen, 
                                                                    Gesellschaften, Firmen, Preise …</p>
                                                                <a class="btn btn-round mb-1" href="listorg.html"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="https://schnitzler.acdh.oeaw.ac.at/"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-acdh.jpg"
                                                                title="Schnitzler am ACDH-CH" alt="Schnitzler am ACDH-CH"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="https://schnitzler.acdh.oeaw.ac.at/" target="_blank" rel="bookmark" class="light"
                                                                        >Arthur Schnitzler am ACDH-CH</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Arthur Schnitzler am ACDH-CH</p>
                                                                <a class="btn btn-round mb-1" href="https://schnitzler.acdh.oeaw.ac.at/" target="_blank"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <article class="card col-md-4 flat-style">
                                                    <div class="card-inner card-vertical"
                                                        style="min-height:420px;">
                                                        <a class="entry-top-thumbnail"
                                                            style="height:230px;" href="https://github.com/arthur-schnitzler"
                                                            rel="bookmark">
                                                            <img width="1024" height="684"
                                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-github.jpg"
                                                                title="Schnitzler Repositories auf Github" alt="Schnitzler Repositories auf Github"/>
                                                        </a>
                                                        <div class="entry-text-content">
                                                            <header class="entry-header">
                                                                <h4 class="entry-title">
                                                                    <a href="https://github.com/arthur-schnitzler" target="_blank" rel="bookmark" class="light"
                                                                        >Quelldaten auf Github</a>
                                                                </h4>
                                                            </header>
                                                            <!-- .entry-header -->
                                                            <div class="entry-content">
                                                                <p>Quelldaten auf Github</p>
                                                                <a class="btn btn-round mb-1" href="https://github.com/arthur-schnitzler" target="_blank"
                                                                    >Weiter</a>
                                                            </div>
                                                            <!-- .entry-content -->
                                                        </div>
                                                        <!-- .entry-text-content -->
                                                    </div>
                                                    <!-- .card-inner -->
                                                </article>
                                                <!-- #post-## -->
                                            </div>
                                            <!-- .card-wrapper -->
                                        </main>
                                        <!-- #main -->
                                        <!-- The pagination component -->
                                    </div>
                                    <!-- #primary -->
                                    <!-- Do the right sidebar check -->
                                </div>
                                <!-- .row -->
                            </div>
                            <!-- Container end -->
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
   <!-- <xsl:template match="tei:div//tei:head">
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
    </xsl:template>-->
</xsl:stylesheet>
