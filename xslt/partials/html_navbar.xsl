<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="./params.xsl"/>
    <xsl:template match="/" name="nav_bar">
        <div class="wrapper-fluid wrapper-navbar sticky-top hide-reading" id="wrapper-navbar">
            <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
            <nav class="navbar navbar-expand-lg">
                <div class="container-fluid">
                    <!-- Your site title as branding in the menu -->
                    <a href="index.html" class="navbar-brand custom-logo-link" rel="home"
                        itemprop="url">
                        <img src="{$project_logo}" class="img-fluid" title="{$project_short_title}"
                            alt="{$project_short_title}" itemprop="logo"/>
                    </a>
                    <!-- end custom logo -->
                    <!--<a class="navbar-brand site-title-with-logo" rel="home" href="index.html" title="{$project_short_title}" itemprop="url"><xsl:value-of select="$project_short_title"/></a>-->
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarSupportedContent"
                        aria-controls="navbarSupportedContent" aria-expanded="false"
                        aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"/>
                    </button>
                    <div class="collapse navbar-collapse justify-content-end"
                        id="navbarSupportedContent">
                        <ul class="navbar-nav mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                    data-bs-toggle="dropdown" aria-expanded="false"> Projekt </a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about.html">Zum Projekt</a>
                                        <a class="dropdown-item" href="status.html"
                                            >Projektstatus</a>
                                        <a class="dropdown-item" href="editionsrichtlinien.html"
                                            >Editionsrichtlinien</a>
                                        <a class="dropdown-item" href="danksagung.html"
                                            >Danksagung</a>
                                        <a class="dropdown-item" href="kooperationen.html"
                                            >Kooperationen</a>
                                        <div class="dropdown-divider"/>
                                        <a class="dropdown-item" href="drucke.html">Gedruckte
                                            Briefwechsel</a>
                                        <a class="dropdown-item" href="andere-drucke.html">Weitere
                                            Druckdigitalisate</a>
                                        <a class="dropdown-item" href="gedruckte-korrespondenz.html"
                                            >Korrespondenz-Bibliografie</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="calendar.html">Kalender</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                    data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false"> Index </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="listperson.html">Personen</a>
                                    <a class="dropdown-item" href="listwork.html">Werke</a>
                                    <a class="dropdown-item" href="listplace.html">Orte</a>
                                    <a class="dropdown-item" href="listorg.html">Institutionen</a>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                    data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false"> Briefe </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="toc.html">Briefe</a>
                                    <a class="dropdown-item" href="tocs.html">Korrespondenzen</a>
                                    <a class="dropdown-item" href="correspaction.html">Versand</a>
                                    <a class="dropdown-item" href="archives.html">Archive</a>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                    data-toggle="dropdown" aria-haspopup="true"
                                    aria-expanded="false"> Technisches </a>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="elemente.html">Verwendete
                                        Elemente</a>
                                </div>
                            </li>
                            <li class="nav-item">
                                <a title="Suche" class="nav-link" href="search.html"><svg
                                        xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                        viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2" stroke-linecap="round"
                                        stroke-linejoin="round" class="feather feather-search">
                                        <circle cx="11" cy="11" r="8"/>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                    </svg> SUCHE</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            <!-- .site-navigation -->
        </div>
    </xsl:template>
</xsl:stylesheet>
