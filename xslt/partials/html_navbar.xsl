<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <nav class="navbar navbar-expand-md" style="padding-top:1px;">
            <div class="container-fluid">
                <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                    <img src="{$project_logo}" class="img-fluid" title="{$project_short_title}"
                        alt="{$project_short_title}" itemprop="logo"/>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                    aria-label="Toggle navigation" style="border: none;">
                    <span class="navbar-toggler-icon"/>
                </button>
                <div class="collapse navbar-collapse " id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false">Projekt</a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="about.html">Zum Projekt</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="status.html">Projektstand</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="editionsrichtlinien.html"
                                        >Editionsrichtlinien</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="ansichten.html">Ansichten</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="statistiken.html">Statistiken</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="danksagung.html">Danksagung</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="kooperationen.html">Kooperationen</a>
                                </li>
                                <div class="dropdown-divider"/>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="epub.html">EPUB</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="drucke.html">Druckausgaben</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="gedruckte-korrespondenz.html"
                                        >Korrespondenzverzeichnisse</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a title="Schnitzler am ACDH-CH"
                                        href="https://schnitzler.acdh.oeaw.ac.at" class="nav-link"
                                        target="_blank">Schnitzler am ACDH-CH</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="calendar.html">Kalender</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false"> Briefe </a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="toc.html">Alle Briefe</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="tocs.html">Korrespondenzen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="correspaction.html">Postwege</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="archives.html">Archive</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false">Index</a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listperson.html">Personen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listwork.html">Werke</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listplace.html">Orte</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listorg.html">Institutionen</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false">Technisches</a>
                            <ul class="dropdown-menu">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="elemente.html"
                                        >Kodierungsrichtlinien</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="arbeitsablauf.html"
                                        >Arbeitsablauf</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link"
                                        href="quelldatenUndAPI.html"
                                        >Quelldaten und API</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link"
                                        href="https://github.com/arthur-schnitzler/schnitzler-briefe-static/"
                                        target="_blank">App auf GitHub</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link"
                                        href="https://hdl.handle.net/21.11115/0000-000E-7538-0"
                                        target="_blank">Langzeitarchivierte Daten (ARCHE)</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a title="Suche" class="nav-link" href="search.html"><svg
                                    xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                    class="feather feather-search">
                                    <circle cx="11" cy="11" r="8"/>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                </svg> SUCHE</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>


    </xsl:template>
</xsl:stylesheet>
