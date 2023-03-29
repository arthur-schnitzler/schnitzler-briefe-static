<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="page" style="background-color:#f1f1f1;">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <!-- ******************* The Hero Area ******************* -->
                    <div class="wrapper" id="wrapper-hero-content"
                        style="background-image:url(https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/hero-bg.jpg);">
                        <div class="container-fluid-empty hero-light" id="wrapper-hero-inner"
                            tabindex="-1">
                            <div>
                                <h3 class="mt-3">Arthur Schnitzler</h3>
                                <h1 class="mt-3">Briefwechsel mit Autorinnen und Autoren </h1>
                                <h3 class="mt-3">1888–1931</h3>
                            </div>
                            <p class="mt-3">Diese Website bringt 44 vollständige Korrespondenzen mit
                                über 3.000 Briefen von und an Arthur Schnitzler (1862–1931). Viele
                                davon werden erstmals veröffentlicht. Alle sind nach den Originalen
                                in Archiven in Europa und Amerika durchgesehen und korrigiert.</p>
                            <p class="mt-3" style="padding-bottom: 50px;">Die 45. Korrespondenz, jene mit Paul Goldmann, wird
                                derzeit ediert, 300 Briefe sind bereits aufgenommen. Von der 46. Korrespondenz liegen die
                            Briefe Schnitzlers vor.</p>
                            <a href="L00001.html">
                                <button class="btn btn-round">Lesen</button>
                            </a>
                            <span>&#160;&#160;</span>
                            <a href="about.html">
                                <button class="btn btn-round">Weiter</button>
                            </a>
                        </div>
                    </div>
                    <div class="container-fluid" style="margin:2em auto;">
                        <div class="row wrapper img_bottom">
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="tocs.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/korrespondenzen.jpg"
                                                title="Quelle: ANNO, Die Bühne, datum=19310315"
                                                alt="Schnitzlers Arbeitstisch"/>
                                        </div>
                                        <div class="card-header">
                                            <h4>Korrespondenzen
                                            </h4>
                                            <p>Auswahl anhand der Korrespondenzpartnerinnen und
                                                -partner.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="toc.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/brief.jpg"
                                                alt="Briefumschlag mit Schnitzlers aufgedruckter Absenderadresse"
                                            />
                                        </div>
                                        <div class="card-header">
                                            <h4>Korrespondenzstücke</h4>
                                            <p>Verzeichnis aller edierten Briefe, Karten,
                                                Widmungsexemplare und Telegramme.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="calendar.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img  class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/calendar.jpg"
                                                title="Detail aus http://www.ifm-wolfen.de/index.php?id=110005000534 CC BY-NC-SA"
                                                alt="Kalenderdetail"/>
                                        </div>
                                        <div class="card-header">
                                            <h4>Kalender</h4>
                                            <p>Korrespondenzstücke anhand eines Datums finden.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listperson.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/persons.jpg"
                                                title="Zwei der Kinder von Felix Salten, aus einem Brief von Salten an Schnitzler, Cambridge University Library"
                                                alt="Zwei der Kinder von Felix Salten, aus einem Brief von diesem an Schnitzler, Cambridge University Library"
                                            />
                                        </div>
                                        <div class="card-header">
                                            <h4>Personen</h4>
                                            <p>In den Korrespondenzstücken erwähnte
                                                Personen.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listwork.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/werke.jpg"
                                                title="Nahaufnahme von Buchrücken CC BY 0"
                                                alt="Nahaufnahme von Buchrücken"
                                            />
                                        </div>
                                        <div class="card-header">
                                            <h4>Werkverzeichnis</h4>
                                            <p>Erwähnungen von Werken der Literatur und der bildenden Kunst, von Gebrauchstexten
                                                und von Periodika.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listplace.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img  class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/places.jpg"
                                                alt="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                                title="Stadtplan von Wien innerhalb des Gürtels, Beilage zum Meyers Konversationslexikon von 1905."
                                            />
                                        </div>
                                        <div class="card-header">
                                            <h4>Orte</h4>
                                            <p>Erwähnte geografische Orte. Diese sind auch über ihre Koordinaten
                                                erschlossen.</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="listorg.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/org.jpg"
                                                title="Briefkopf d’Ora" alt="Briefkopf d’Ora"
                                            ></img>
                                        </div>
                                        <div class="card-header">
                                            <h4>Institutionen und Organisationen</h4>
                                            <p>Vorkommende Verlage, Redaktionen, Institutionen, 
                                                Gesellschaften, Firmen, Preise…</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="https://schnitzler.acdh.oeaw.ac.at/" class="index-link" target="_blank">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img  class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-acdh.jpg"
                                                title="Schnitzler am ACDH-CH" alt="Schnitzler am ACDH-CH"/>
                                        </div>
                                        <div class="card-header">
                                            <p>Schnitzler am ACDH-CH</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="https://github.com/arthur-schnitzler" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img  class="d-block w-100"
                                                src="https://shared.acdh.oeaw.ac.at/schnitzler-briefe/img/schnitzler-github.jpg"
                                                title="Schnitzler Repositories auf Github" alt="Schnitzler Repositories auf Github"/>
                                        </div>
                                        <div class="card-header">
                                            <p>Quelldaten dieser Website auf Github</p>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            
                            
                            <!--<div class="col-md-6 col-lg-6 col-sm-12">
                                <a href="search.html" class="index-link">
                                    <div class="card index-card">
                                        <div class="card-body">
                                            <img src="images/example-img-1.jpg"
                                                class="d-block w-100" alt="..."/>
                                        </div>
                                        <div class="card-header">
                                            <p> Datenbanksuche </p>
                                        </div>
                                    </div>
                                </a>
                            </div>-->
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
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
</xsl:stylesheet>
