<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <nav class="navbar navbar-expand-md" role="navigation" aria-label="Hauptnavigation" style="padding-top:1px;">
            <div class="container-fluid">
                <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url" aria-label="Zur Startseite">
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
                                data-bs-toggle="dropdown" aria-expanded="false" id="projektDropdown" aria-haspopup="true">Projekt</a>
                            <ul class="dropdown-menu" aria-labelledby="projektDropdown">
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
                                    <a class="nav-link" href="jung-wien.html">Netzwerk Jung-Wien</a>
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
                                    <a title="Schnitzler am ACDH"
                                        href="https://schnitzler.acdh.oeaw.ac.at" class="nav-link"
                                        target="_blank">Schnitzler am ACDH</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="calendar.html">Kalender</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false" id="briefeDropdown" aria-haspopup="true"> Briefe </a>
                            <ul class="dropdown-menu" aria-labelledby="briefeDropdown">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="toc.html">Alle Briefe</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="tocs.html">Korrespondenzen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="tocs-female-writers.html">… mit Schriftstellerinnen</a>
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
                                data-bs-toggle="dropdown" aria-expanded="false" id="indexDropdown" aria-haspopup="true">Index</a>
                            <ul class="dropdown-menu" aria-labelledby="indexDropdown">
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listperson.html">Personen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listbibl.html">Werke</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listplace.html">Orte</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listorg.html">Institutionen</a>
                                </li>
                                <li class="nav-item dropdown-submenu">
                                    <a class="nav-link" href="listevent.html">Ereignisse</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                                data-bs-toggle="dropdown" aria-expanded="false" id="technischesDropdown" aria-haspopup="true">Technisches</a>
                            <ul class="dropdown-menu" aria-labelledby="technischesDropdown">
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
                                <!-- Schnitzler-Links Dropdown -->
                                
                            </ul>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="schnitzlerLinksDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">Schnitzler</a>
                            <ul class="dropdown-menu" aria-labelledby="schnitzlerLinksDropdown">
                                <li><a class="dropdown-item" href="https://de.wikipedia.org/wiki/Arthur_Schnitzler" target="_blank">Wikipedia</a></li>
                                <li><a class="dropdown-item" href="https://www.geschichtewiki.wien.gv.at/Arthur_Schnitzler" target="_blank">Wien Geschichte Wiki</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-tagebuch.acdh.oeaw.ac.at/" target="_blank">Tagebuch (1879–1931)</a></li>
                                <li><a class="dropdown-item" href="https://www.arthur-schnitzler.de" target="_blank">Werke digital (1905–1931)</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-mikrofilme.acdh.oeaw.ac.at/" target="_blank">Mikrofilme</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-zeitungen.acdh.oeaw.ac.at/" target="_blank">Archiv der Zeitungsausschnitte</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-interviews.acdh.oeaw.ac.at/" target="_blank">Interviews, Meinungen, Proteste</a></li>
                                <li><a class="dropdown-item" href="https://wienerschnitzler.org/" target="_blank">Wiener Schnitzler – Schnitzlers Wien</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-bahr.acdh.oeaw.ac.at/" target="_blank">Korrespondenz mit Hermann Bahr</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-chronik.acdh.oeaw.ac.at/" target="_blank">Chronik</a></li>
                                <li><a class="dropdown-item" href="https://schnitzler-lektueren.acdh.oeaw.ac.at/" target="_blank">Lektüren</a></li>
                                <li><a class="dropdown-item" href="https://pollaczek.acdh.oeaw.ac.at/" target="_blank">Pollaczek: Schnitzler und ich</a></li>
                                <li><a class="dropdown-item" href="https://pmb.acdh.oeaw.ac.at/" target="_blank" >PMB – Personen der Moderne Basis</a></li>
                                
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a title="Suche" class="nav-link" href="search.html" aria-label="Zur Suchseite"><svg
                                    xmlns="http://www.w3.org/2000/svg" width="24" height="24"
                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                    class="feather feather-search" aria-hidden="true">
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
