<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <!--<xsl:import href="./partials/aot-options.xsl"/>-->
    <xsl:import href="./partials/html_title_navigation.xsl"/>
    <xsl:import href="./partials/view-type.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <!-- Einstellungen für die Schnitzler-Chronik. Das entfernte XSL wird nur benützt, wenn fetch-locally auf  -->
    <xsl:import
        href="https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-static/refs/heads/main/xslt/export/schnitzler-chronik.xsl"/>
    <!--<xsl:import href="../../schnitzler-chronik-static/xslt/export/schnitzler-chronik.xsl"/>-->
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="tei:p tei:div tei:span tei:hi tei:emph tei:title tei:foreign"/>
    <xsl:param name="schnitzler-chronik_fetch-locally" as="xs:boolean" select="true()"/>
    <xsl:param name="schnitzler-chronik_current-type" as="xs:string" select="'schnitzler-briefe'"/>
    <xsl:variable name="quotationURL">
        <xsl:value-of
            select="concat('https://schnitzler-briefe.acdh.oeaw.ac.at/', replace(tokenize(base-uri(), '/')[last()], '.xml', '.html'))"
        />
    </xsl:variable>
    <xsl:variable name="currentDate">
        <xsl:value-of select="format-date(current-date(), '[D1].&#160;[M1].&#160;[Y4]')"/>
    </xsl:variable>
    <xsl:variable name="quotationString">
        <xsl:value-of
            select="concat(normalize-space(//tei:titleStmt/tei:title[@level = 'a']), '. In: Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren. Digitale Edition. Herausgegeben von Martin Anton Müller mit Gerd Hermann Susen, Laura Untner und Selma Jahnke, ', $quotationURL, ' (Abfrage ', $currentDate, ')')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="teiDoc">
        <xsl:value-of select="concat(data(tei:TEI/@xml:id), '.xml')"/>
    </xsl:variable>
    <xsl:variable name="source_pdf">
        <xsl:value-of select="concat(tei:TEI/@xml:id, '.pdf')"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="concat(replace($teiSource, '.xml', ''), '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
    </xsl:variable>
    <xsl:param name="chronik-dir">../chronik-data</xsl:param>
    <xsl:variable name="chronik-data"
        select="collection(concat($chronik-dir, '/?select=L0*.xml;recurse=yes'))"/>
    <xsl:param name="back" select="tei:TEI/tei:text/tei:back" as="node()?"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title"
                        select="concat($doc_title, ' | Schnitzler Briefe')"/>
                    <xsl:with-param name="html_description">
                        <xsl:value-of
                            select="concat('Brief: ', $doc_title, '. Digital edierte Korrespondenz aus dem Nachlass Arthur Schnitzlers.')"
                        />
                    </xsl:with-param>
                    <xsl:with-param name="html_url" select="$quotationURL"/>
                </xsl:call-template>
                <style>
                    .navBarNavDropdown ul li:nth-child(2) {
                        display: none !important;
                    }</style>
                <meta name="Date of publication" class="staticSearch_date">
                    <xsl:attribute name="content">
                        <xsl:value-of
                            select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"/>
                    </xsl:attribute>
                    <xsl:attribute name="n">
                        <xsl:value-of select="//tei:titleStmt/tei:title[@type = 'iso-date']/@n"/>
                    </xsl:attribute>
                </meta>
                <meta name="docImage" class="staticSearch_docImage">
                    <xsl:attribute name="content">
                        <!--<xsl:variable name="iiif-ext" select="'.jp2/full/,200/0/default.jpg'"/> -->
                        <xsl:variable name="iiif-ext"
                            select="'.jpg?format=iiif&amp;param=/full/,200/0/default.jpg'"/>
                        <xsl:variable name="iiif-domain"
                            select="'https://iiif.acdh-dev.oeaw.ac.at/iiif/images/schnitzler-briefe/'"/>
                        <xsl:variable name="facs_item"
                            select="descendant::tei:pb[not(@facs = '')][1]/@facs"/>
                        <xsl:value-of select="concat($iiif-domain, $facs_item, $iiif-ext)"/>
                    </xsl:attribute>
                </meta>
                <meta name="docTitle" class="staticSearch_docTitle">
                    <xsl:attribute name="content">
                        <xsl:value-of select="//tei:titleStmt/tei:title[@level = 'a']"/>
                    </xsl:attribute>
                </meta>
                <xsl:if test="descendant::tei:back/tei:listPlace/tei:place">
                    <xsl:for-each select="descendant::tei:back/tei:listPlace/tei:place">
                        <meta name="Places" class="staticSearch_feat"
                            content="{if (./tei:settlement) then (./tei:settlement/tei:placeName) else (./tei:placeName)}"
                        > </meta>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="descendant::tei:back/tei:listPerson/tei:person">
                    <xsl:for-each select="descendant::tei:back/tei:listPerson/tei:person">
                        <meta name="Persons" class="staticSearch_feat"
                            content="{concat(./tei:persName/tei:surname, ', ', ./tei:persName/tei:forename)}"
                        > </meta>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="descendant::tei:back/tei:listOrg/tei:org">
                    <xsl:for-each select="descendant::tei:back/tei:listOrg/tei:org">
                        <meta name="Organizations" class="staticSearch_feat"
                            content="{./tei:orgName}"> </meta>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="descendant::tei:back/tei:listBibl[not(parent::tei:person)]/tei:bibl">
                    <xsl:for-each
                        select="descendant::tei:back/tei:listBibl[not(parent::tei:person)]/tei:bibl">
                        <meta name="Literature" class="staticSearch_feat" content="{./tei:title[1]}"
                        > </meta>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="descendant::tei:back/tei:listEvent/tei:event">
                    <xsl:for-each select="descendant::tei:back/tei:listEvent/tei:event">
                        <meta name="Events" class="staticSearch_feat" content="{./tei:eventName}"
                        > </meta>
                    </xsl:for-each>
                </xsl:if>
                <!-- JSON-LD structured data for better Wikipedia/search engine recognition -->
                <script type="application/ld+json">
                {
                  "@context": "https://schema.org",
                  "@type": "Letter",
                  "url": "<xsl:value-of select="$quotationURL"/>",
                  "name": "<xsl:value-of select="normalize-space($doc_title)"/>",
                  "dateCreated": "<xsl:value-of select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"/>",
                  "inLanguage": "de"<xsl:if test="//tei:correspAction[@type = 'sent']/tei:persName">,
                  "author": <xsl:choose>
                    <xsl:when test="count(//tei:correspAction[@type = 'sent']/tei:persName) = 1">
                      <xsl:for-each select="//tei:correspAction[@type = 'sent']/tei:persName">
                        <xsl:variable name="author-id" select="substring-after(@ref, '#')"/>
                        <xsl:variable name="author-gnd" select="//tei:back//tei:person[@xml:id = $author-id]/tei:idno[@type = 'gnd'][1]"/>{
                      "@type": "Person",
                      "name": "<xsl:choose>
                        <xsl:when test="tei:surname and tei:forename"><xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
                      </xsl:choose>"<xsl:if test="$author-gnd != ''">,
                      "@id": "<xsl:value-of select="$author-gnd"/>"</xsl:if>
                    }</xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>[<xsl:for-each select="//tei:correspAction[@type = 'sent']/tei:persName">
                      <xsl:variable name="author-id" select="substring-after(@ref, '#')"/>
                      <xsl:variable name="author-gnd" select="//tei:back//tei:person[@xml:id = $author-id]/tei:idno[@type = 'gnd'][1]"/>
                    {
                      "@type": "Person",
                      "name": "<xsl:choose>
                        <xsl:when test="tei:surname and tei:forename"><xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
                      </xsl:choose>"<xsl:if test="$author-gnd != ''">,
                      "@id": "<xsl:value-of select="$author-gnd"/>"</xsl:if>
                    }<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]</xsl:otherwise>
                  </xsl:choose></xsl:if><xsl:if test="//tei:correspAction[@type = 'received']/tei:persName">,
                  "recipient": <xsl:choose>
                    <xsl:when test="count(//tei:correspAction[@type = 'received']/tei:persName) = 1">
                      <xsl:for-each select="//tei:correspAction[@type = 'received']/tei:persName">
                        <xsl:variable name="recipient-id" select="substring-after(@ref, '#')"/>
                        <xsl:variable name="recipient-gnd" select="//tei:back//tei:person[@xml:id = $recipient-id]/tei:idno[@type = 'gnd'][1]"/>{
                      "@type": "Person",
                      "name": "<xsl:choose>
                        <xsl:when test="tei:surname and tei:forename"><xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
                      </xsl:choose>"<xsl:if test="$recipient-gnd != ''">,
                      "@id": "<xsl:value-of select="$recipient-gnd"/>"</xsl:if>
                    }</xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>[<xsl:for-each select="//tei:correspAction[@type = 'received']/tei:persName">
                      <xsl:variable name="recipient-id" select="substring-after(@ref, '#')"/>
                      <xsl:variable name="recipient-gnd" select="//tei:back//tei:person[@xml:id = $recipient-id]/tei:idno[@type = 'gnd'][1]"/>
                    {
                      "@type": "Person",
                      "name": "<xsl:choose>
                        <xsl:when test="tei:surname and tei:forename"><xsl:value-of select="concat(tei:forename, ' ', tei:surname)"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
                      </xsl:choose>"<xsl:if test="$recipient-gnd != ''">,
                      "@id": "<xsl:value-of select="$recipient-gnd"/>"</xsl:if>
                    }<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]</xsl:otherwise>
                  </xsl:choose></xsl:if>,
                  "isPartOf": {
                    "@type": "Collection",
                    "name": "Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren. Digitale Edition",
                    "editor": [
                      {
                        "@type": "Person",
                        "name": "Martin Anton Müller",
                        "@id": "https://www.wikidata.org/wiki/Q100965214"
                      },
                      {
                        "@type": "Person",
                        "name": "Gerd-Hermann Susen",
                        "@id": "https://www.wikidata.org/wiki/Q112499182"
                      },
                      {
                        "@type": "Person",
                        "name": "Laura Untner",
                        "@id": "https://www.wikidata.org/wiki/Q122733533"
                      },
                      {
                        "@type": "Person",
                        "name": "Selma Jahnke",
                        "@id": "https://www.wikidata.org/wiki/Q133383086"
                      }
                    ]
                  },
                  "publisher": {
                    "@type": "Organization",
                    "name": "Austrian Centre for Digital Humanities",
                    "@id": "https://www.oeaw.ac.at/acdh/"
                  },
                  "license": "https://creativecommons.org/licenses/by/4.0/"
                }
                </script>
            </head>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="wp-transcript">
                            <!-- Wikipedia-compatible semantic structure with Schema.org microdata -->
                            <article class="card" data-index="true" itemscope=""
                                itemtype="http://schema.org/ScholarlyArticle">
                                <link itemprop="mainEntityOfPage" href="{$quotationURL}"/>
                                <meta itemprop="datePublished"
                                    content="{//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso}"/>
                                <meta itemprop="publisher"
                                    content="Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren"/>
                                <meta itemprop="isPartOf"
                                    content="Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren. Digitale Edition"/>
                                <!-- Author information from correspondence metadata -->
                                <xsl:for-each
                                    select="//tei:correspAction[@type = 'sent']/tei:persName">
                                    <meta itemprop="author" itemscope=""
                                        itemtype="http://schema.org/Person">
                                        <xsl:attribute name="content">
                                            <xsl:choose>
                                                <xsl:when test="tei:surname and tei:forename">
                                                  <xsl:value-of
                                                  select="concat(tei:forename, ' ', tei:surname)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </meta>
                                </xsl:for-each>
                                <header class="card-header">
                                    <xsl:call-template name="header-nav"/>
                                </header>
                                <main id="container-resize" class="row transcript active"
                                    itemprop="articleBody">
                                    <xsl:for-each select="descendant::tei:body">
                                        <xsl:call-template name="mam:view-type-img"/>
                                    </xsl:for-each>
                                </main>
                            </article>
                            <div class="card-footer" style="clear: both;">
                                <nav class="navbar navbar-expand-lg" style="box-shadow: none;">
                                    <div class="container-fluid" style="display: flex;
                                        justify-content: center;
                                        align-items: center;">
                                        <div id="navbarSupportedContent">
                                            <ul class="navbar-nav mb-2 mb-lg-0" id="secondary-menu">
                                                <xsl:if
                                                  test="not(descendant::tei:teiHeader[1]/tei:revisionDesc[1]/@status = 'approved')">
                                                  <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#qualitaet" type="button"
                                                  data-bs-toggle="modal">
                                                  <span
                                                  style="filter: drop-shadow(0 0 2px white); text-shadow: 0 0 2px white, 0 0 2px white, 0 0 2px white;"
                                                  >⚠️</span><span style="color: orange;"> ENTWURF
                                                  </span>
                                                  </a>&#160; </li>
                                                </xsl:if>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#editor-widget" type="button"
                                                  data-bs-toggle="modal"><i
                                                  class="fas fa-solid fa-screwdriver-wrench"/>
                                                  EINSTELLUNGEN </a>&#160; </li>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#ueberlieferung" type="button"
                                                  data-bs-toggle="modal">
                                                  <i class="fas fa-landmark"/> ÜBERLIEFERUNG
                                                  </a>&#160; </li>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#entitaeten" type="button"
                                                  data-bs-toggle="modal">
                                                  <i class="fas fa-sharp fa-solid fa-people-group"/>
                                                  LINKS </a>&#160; </li>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#zitat" type="button"
                                                  data-bs-toggle="modal">
                                                  <i class="fas fa-quote-right"/> ZITIEREN</a>&#160; </li>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#downloadModal" type="button"
                                                  data-bs-toggle="modal"><i
                                                  class="fas fa-solid fa-download"/> DOWNLOAD
                                                  </a>&#160; </li>
                                                <li class="nav-item"> &#160;<a href="#"
                                                  data-bs-target="#schnitzler-chronik-modal"
                                                  type="button" data-bs-toggle="modal">
                                                  <i class="fas fa-calendar-day"/> CHRONIK</a>&#160; </li>
                                                <!--<li class="nav-item dropdown">
                                    <span class="nav-link">
                                        <div id="csLink" class="a.grau" data-correspondent-1-name=""
                                            data-correspondent-1-id="all"
                                            data-correspondent-2-name="" data-correspondent-2-id=""
                                            data-start-date="{$datum}" data-end-date=""
                                            data-range="50" data-selection-when="before-after"
                                            data-selection-span="median-before-after"
                                            data-result-max="4" data-exclude-edition=""/>
                                    </span>
                                </li>-->
                                            </ul>
                                        </div>
                                    </div>
                                </nav>
                                <xsl:if
                                    test="descendant::tei:note[@type = 'textConst' or @type = 'commentary']">
                                    <div class="card-body-anhang">
                                        <dl class="kommentarhang">
                                            <xsl:apply-templates
                                                select="descendant::tei:note[@type = 'textConst' or @type = 'commentary']"
                                                mode="kommentaranhang"/>
                                        </dl>
                                    </div>
                                </xsl:if>
                            </div>
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </div>
                </div>
                <!-- Modal -->
                <div class="modal fade" id="ueberlieferung" tabindex="-1"
                    aria-labelledby="ueberlieferungLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLongTitle1">
                                    <xsl:for-each
                                        select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <table class="table table-striped align-top">
                                    <tbody>
                                        <xsl:for-each select="//tei:correspAction">
                                            <tr>
                                                <th>
                                                  <xsl:choose>
                                                  <xsl:when test="@type = 'sent'"> Versand: </xsl:when>
                                                  <xsl:when test="@type = 'received'"> Empfang: </xsl:when>
                                                  <xsl:when test="@type = 'forwarded'">
                                                  Weiterleitung: </xsl:when>
                                                  <xsl:when test="@type = 'redirected'"> Umleitung: </xsl:when>
                                                  <xsl:when test="@type = 'delivered'"> Zustellung: </xsl:when>
                                                  <xsl:when test="@type = 'transmitted'">
                                                  Übermittlung: </xsl:when>
                                                  </xsl:choose>
                                                </th>
                                                <td> </td>
                                                <td>
                                                  <xsl:if test="./tei:date">
                                                  <xsl:value-of select="./tei:date"/>
                                                  <br/>
                                                  </xsl:if>
                                                  <xsl:for-each select="child::tei:persName">
                                                  <a class="theme-color">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(replace((@ref), '#', ''), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:choose>
                                                  <xsl:when test="not(position() = last())">
                                                  <xsl:text>; </xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <br/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                  <xsl:for-each select="child::tei:placeName">
                                                  <a class="theme-color">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(replace((@ref), '#', ''), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </a>
                                                  <xsl:choose>
                                                  <xsl:when test="not(position() = last())">
                                                  <xsl:text>; </xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <br/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:for-each>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                <br/>
                                <!-- Modal Überlieferung -->
                                <div class="modal-body">
                                    <xsl:for-each select="descendant::tei:witness">
                                        <h5>TEXTZEUGE <xsl:value-of select="@n"/>
                                        </h5>
                                        <table class="table table-striped  align-top">
                                            <tbody>
                                                <xsl:if test="tei:msDesc/tei:msIdentifier">
                                                  <tr>
                                                  <th>Signatur </th>
                                                  <td>
                                                  <xsl:for-each
                                                  select="tei:msDesc/tei:msIdentifier/child::*">
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="child::tei:objectType">
                                                  <tr>
                                                  <th>Typ</th>
                                                  <td>
                                                  <xsl:apply-templates select="tei:objectType"/>
                                                  </td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="child::tei:msDesc/tei:physDesc">
                                                  <tr>
                                                  <th>Beschreibung </th>
                                                  <td>
                                                  <xsl:apply-templates
                                                  select="child::tei:msDesc/tei:physDesc/tei:objectDesc"
                                                  />
                                                  </td>
                                                  </tr>
                                                  <xsl:if
                                                  test="tei:msDesc/tei:physDesc/tei:typeDesc/tei:typeNote">
                                                  <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:typeDesc/tei:typeNote"
                                                  />
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:msDesc/tei:physDesc/tei:handDesc">
                                                  <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:handDesc"/>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:msDesc/tei:physDesc/tei:additions">
                                                  <tr>
                                                  <th/>
                                                  <th>Zufügungen</th>
                                                  </tr>
                                                  <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:additions"/>
                                                  </xsl:if>
                                                </xsl:if>
                                            </tbody>
                                        </table>
                                    </xsl:for-each>
                                    <xsl:for-each select="//tei:biblStruct">
                                        <h5>VERÖFFENTLICHUNG <xsl:value-of select="position()"/>
                                        </h5>
                                        <table class="table table-striped  align-top">
                                            <tbody>
                                                <tr>
                                                  <th/>
                                                  <td>
                                                  <xsl:call-template
                                                  name="mam:bibliografische-angabe">
                                                  <xsl:with-param name="biblStruct-input" select="."
                                                  />
                                                  </xsl:call-template>
                                                  </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal Zitat -->
                <div class="modal fade" id="zitat" tabindex="-1" aria-labelledby="zitatModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Zitat</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                                <blockquote class="citation-quote"
                                    style="cursor: pointer; user-select: all; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #A63437;"
                                    onclick="copyToClipboard(this)" title="Klicken zum Kopieren">
                                    <xsl:value-of select="normalize-space($quotationString)"/>
                                </blockquote>
                                <p/>
                                <p>Für gekürzte Zitate reicht die Angabe der Briefnummer aus, die
                                    eindeutig und persistent ist: »<b><xsl:value-of
                                            select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"
                                        /></b>«.</p>
                                <p>Für Belege in der Wikipedia kann diese Vorlage benutzt
                                    werden:</p>
                                <blockquote class="citation-quote"
                                    style="cursor: pointer; user-select: all; padding: 10px; background-color: #f8f9fa; border-left: 4px solid #A63437;"
                                    onclick="copyToClipboard(this)" title="Klicken zum Kopieren">
                                    <code>
                                        <xsl:text>{{Internetquelle |url=https://schnitzler-briefe.acdh.oeaw.ac.at/</xsl:text>
                                        <xsl:value-of select="$link"/>
                                        <xsl:text> |titel=</xsl:text>
                                        <xsl:value-of select="$doc_title"/>
                                        <xsl:text> |werk=Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren |hrsg=Martin Anton Müller mit Gerd-Hermann Susen, Laura Untner und Selma Jahnke |sprache=de |datum=</xsl:text>
                                        <xsl:value-of
                                            select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"/>
                                        <xsl:text> |abruf=</xsl:text>
                                        <xsl:value-of
                                            select="format-date(current-date(), '[Y4]-[M02]-[D02]')"/>
                                        <xsl:text> }}</xsl:text>
                                    </code>
                                </blockquote>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal Qualität -->
                <div class="modal fade" id="qualitaet" tabindex="-1"
                    aria-labelledby="qualitaetModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">Textqualität</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <p>Diese Abschrift wurde noch nicht ausreichend mit dem Original
                                    abgeglichen. Sie sollte derzeit nicht – oder nur durch eigenen
                                    Abgleich mit dem Faksimile, falls vorliegend – als Zitatvorlage
                                    dienen.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal LINKS -->
                <div class="modal fade" id="entitaeten" tabindex="-1"
                    aria-labelledby="entitaetenModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">LINKS</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <div class="entity-details-container">
                                    <!-- Master toggle for all entity links -->
                                    <div style="margin-bottom: 1.5em; padding-bottom: 1em; border-bottom: 1px solid #ddd;">
                                        <div class="entity-toggle" data-type="master"
                                            style="display: inline-block;">
                                            <label class="switch">
                                              <input type="checkbox" checked="checked"
                                              id="master-entity-toggle"/>
                                              <span class="i-slider round"
                                              style="background-color: #A63437;"/>
                                            </label>
                                            <span class="opt-title"> Alle Unterstreichungen</span>
                                        </div>
                                    </div>

                                    <!-- Variable: IDs der Korrespondenz-Personen -->
                                    <xsl:variable name="corresp-person-ids"
                                        select="//tei:correspDesc//tei:persName/@ref/substring-after(., '#')"/>

                                    <!-- Beteiligte an der Korrespondenz -->
                                    <details style="margin-bottom: 1em;">
                                        <summary>Beteiligte an der Korrespondenz</summary>
                                        <div class="details-content" style="padding-left: 20px; margin-top: 0.5em;">
                                            <xsl:for-each select="//tei:correspDesc//tei:persName">
                                                <xsl:variable name="person-id" select="substring-after(@ref, '#')"/>
                                                <div style="display: block; margin-bottom: 8px;">
                                                    <a class="persons">
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat($person-id, '.html')"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                    </a>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </details>

                                    <!-- Personen -->
                                    <details open="open" style="margin-bottom: 1em;">
                                        <summary>Personen (<xsl:value-of
                                                select="count(descendant::tei:text/tei:back/tei:listPerson/tei:person[not(@xml:id = $corresp-person-ids)])"
                                        />)</summary>
                                        <div class="details-content" style="margin-top: 0.5em;">
                                            <!-- Personen toggle -->
                                            <div style="margin-bottom: 1em; padding-bottom: 0.5em; border-bottom: 1px solid #eee;">
                                                <div class="entity-toggle" data-type="persons"
                                                    style="display: inline-block;">
                                                    <label class="switch">
                                                      <input type="checkbox" checked="checked"/>
                                                      <span class="i-slider round"
                                                      style="background-color: #e74c3c;"/>
                                                    </label>
                                                    <span class="opt-title"> Unterstreichungen</span>
                                                </div>
                                            </div>
                                            <xsl:for-each select="descendant::tei:text/tei:back/tei:listPerson/tei:person[not(@xml:id = $corresp-person-ids)]">
                                                <xsl:sort
                                                  select="concat(child::tei:persName[1]/tei:surname[1], child::tei:persName[1]/tei:forename[1])"/>
                                                <xsl:variable name="naname" as="xs:string">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:persName[1]/tei:surname[1] and child::tei:persName[1]/tei:forename[1]">
                                                  <xsl:value-of
                                                  select="concat(child::tei:persName[1]/tei:surname[1], ' ', child::tei:persName[1]/tei:forename[1])"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="child::tei:persName[1]/tei:forename[1]">
                                                  <xsl:value-of select="child::tei:forename[1]"/>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="child::tei:persName[1]/tei:surname[1]">
                                                  <xsl:value-of
                                                  select="child::tei:persName[1]/tei:surname[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="normalize-space(child::tei:persName)"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:variable>
                                                <!-- All persons here have toggles, corresp persons are already filtered out -->
                                                <div class="entity-highlight-toggle" data-type="person" style="display: flex; align-items: flex-start; margin-bottom: 8px;">
                                                    <xsl:attribute name="data-entity-id">
                                                        <xsl:value-of select="data(@xml:id)"/>
                                                    </xsl:attribute>
                                                    <label class="switch" style="flex-shrink: 0;">
                                                        <input type="checkbox"/>
                                                        <span class="i-slider round" style="background-color: #ccc;"></span>
                                                    </label>
                                                    <span class="opt-title" style="margin-left: 10px; flex: 1;">
                                                        <a class="persons">
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat(data(@xml:id), '.html')"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="$naname"/>
                                                        </a>
                                                    </span>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </details>
                                    <!-- Werke -->
                                    <xsl:if test=".//tei:back/tei:listBibl/tei:bibl[1]">
                                        <details style="margin-bottom: 1em;">
                                            <summary>Werke (<xsl:value-of
                                                    select="count(descendant::tei:text/tei:back/tei:listBibl/tei:bibl)"
                                            />)</summary>
                                            <div class="details-content" style="margin-top: 0.5em;">
                                                <!-- Werke toggle -->
                                                <div style="margin-bottom: 1em; padding-bottom: 0.5em; border-bottom: 1px solid #eee;">
                                                    <div class="entity-toggle" data-type="works"
                                                        style="display: inline-block;">
                                                        <label class="switch">
                                                          <input type="checkbox" checked="checked"/>
                                                          <span class="i-slider round"
                                                          style="background-color: #f39c12;"/>
                                                        </label>
                                                        <span class="opt-title"> Unterstreichungen</span>
                                                    </div>
                                                </div>
                                                <xsl:for-each
                                                    select="descendant::tei:text/tei:back/tei:listBibl/tei:bibl">
                                                  <xsl:sort select="child::tei:title[1]"/>
                                                  <div class="entity-highlight-toggle"
                                                  data-type="work"
                                                  style="display: flex; align-items: flex-start; margin-bottom: 8px;">
                                                  <xsl:attribute name="data-entity-id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                  </xsl:attribute>
                                                  <label class="switch"
                                                  style="flex-shrink: 0;">
                                                  <input type="checkbox"/>
                                                  <span class="i-slider round"
                                                  style="background-color: #ccc;"/>
                                                  </label>
                                                  <span class="opt-title" style="margin-left: 10px; flex: 1;">
                                                  <a class="works">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:if
                                                  test="child::tei:author[@role = 'hat-geschaffen' or @role = 'author']">
                                                  <xsl:for-each
                                                  select="child::tei:author[@role = 'hat-geschaffen' or @role = 'author']">
                                                  <xsl:sort
                                                  select="concat(., child::tei:surname[1], child::tei:forename[1])"/>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:surname[1] or child::tei:forename[1]">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:surname[1] and child::tei:forename[1]">
                                                  <xsl:value-of
                                                  select="concat(child::tei:surname[1], ' ', child::tei:forename[1])"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when test="child::tei:forename[1]">
                                                  <xsl:value-of select="child::tei:forename[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="child::tei:surname[1]"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>; </xsl:text>
                                                  </xsl:if>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:if test="position() = last()">
                                                  <xsl:text>: </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:if>
                                                  <xsl:value-of select="./tei:title[1]"/>
                                                  </a>
                                                  </span>
                                                  </div>
                                                </xsl:for-each>
                                            </div>
                                        </details>
                                    </xsl:if>
                                    <!-- Institutionen -->
                                    <xsl:if test=".//tei:back/tei:listOrg/tei:org[1]">
                                        <details style="margin-bottom: 1em;">
                                            <summary>Institutionen (<xsl:value-of
                                                    select="count(descendant::tei:text/tei:back/tei:listOrg/tei:org)"
                                            />)</summary>
                                            <div class="details-content" style="margin-top: 0.5em;">
                                                <!-- Institutionen toggle -->
                                                <div style="margin-bottom: 1em; padding-bottom: 0.5em; border-bottom: 1px solid #eee;">
                                                    <div class="entity-toggle" data-type="orgs"
                                                        style="display: inline-block;">
                                                        <label class="switch">
                                                          <input type="checkbox" checked="checked"/>
                                                          <span class="i-slider round"
                                                          style="background-color: #9b59b6;"/>
                                                        </label>
                                                        <span class="opt-title"> Unterstreichungen</span>
                                                    </div>
                                                </div>
                                                <xsl:for-each select="descendant::tei:text/tei:back/tei:listOrg//tei:org">
                                                  <xsl:sort select="child::tei:orgName[1]"/>
                                                  <div class="entity-highlight-toggle"
                                                  data-type="org"
                                                  style="display: flex; align-items: flex-start; margin-bottom: 8px;">
                                                  <xsl:attribute name="data-entity-id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                  </xsl:attribute>
                                                  <label class="switch"
                                                  style="flex-shrink: 0;">
                                                  <input type="checkbox"/>
                                                  <span class="i-slider round"
                                                  style="background-color: #ccc;"/>
                                                  </label>
                                                  <span class="opt-title" style="margin-left: 10px; flex: 1;">
                                                  <a class="orgs">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="./tei:orgName[1]"/>
                                                  </a>
                                                  </span>
                                                  </div>
                                                </xsl:for-each>
                                            </div>
                                        </details>
                                    </xsl:if>
                                    <!-- Ereignisse -->
                                    <xsl:if test=".//tei:back/tei:listEvent/tei:event[1]">
                                        <details style="margin-bottom: 1em;">
                                            <summary>Ereignisse (<xsl:value-of
                                                    select="count(descendant::tei:text/tei:back/tei:listEvent/tei:event)"
                                            />)</summary>
                                            <div class="details-content" style="margin-top: 0.5em;">
                                                <!-- Ereignisse toggle -->
                                                <div style="margin-bottom: 1em; padding-bottom: 0.5em; border-bottom: 1px solid #eee;">
                                                    <div class="entity-toggle" data-type="events"
                                                        style="display: inline-block;">
                                                        <label class="switch">
                                                          <input type="checkbox" checked="checked"/>
                                                          <span class="i-slider round"
                                                          style="background-color: #27ae60;"/>
                                                        </label>
                                                        <span class="opt-title"> Ereignisse markieren </span>
                                                    </div>
                                                </div>
                                                <xsl:for-each
                                                    select="descendant::tei:text/tei:back/tei:listEvent/tei:event">
                                                  <xsl:sort select="child::tei:eventName[1]"/>
                                                  <div class="entity-highlight-toggle"
                                                  data-type="event"
                                                  style="display: flex; align-items: flex-start; margin-bottom: 8px;">
                                                  <xsl:attribute name="data-entity-id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                  </xsl:attribute>
                                                  <label class="switch"
                                                  style="flex-shrink: 0;">
                                                  <input type="checkbox"/>
                                                  <span class="i-slider round"
                                                  style="background-color: #ccc;"/>
                                                  </label>
                                                  <span class="opt-title" style="margin-left: 10px; flex: 1;">
                                                  <a class="events">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="./tei:eventName[1]"/>
                                                  </a>
                                                  </span>
                                                  </div>
                                                </xsl:for-each>
                                            </div>
                                        </details>
                                    </xsl:if>
                                    <!-- Orte -->
                                    <xsl:if test=".//tei:back/tei:listPlace/tei:place[1]">
                                        <details style="margin-bottom: 1em;">
                                            <summary>Orte (<xsl:value-of
                                                    select="count(descendant::tei:text/tei:back/tei:listPlace/tei:place)"
                                            />)</summary>
                                            <div class="details-content" style="margin-top: 0.5em;">
                                                <!-- Orte toggle -->
                                                <div style="margin-bottom: 1em; padding-bottom: 0.5em; border-bottom: 1px solid #eee;">
                                                    <div class="entity-toggle" data-type="places"
                                                        style="display: inline-block;">
                                                        <label class="switch">
                                                          <input type="checkbox" checked="checked"/>
                                                          <span class="i-slider round"
                                                          style="background-color: #3498db;"/>
                                                        </label>
                                                        <span class="opt-title"> Unterstreichungen</span>
                                                    </div>
                                                </div>
                                                <xsl:for-each select="descendant::tei:text/tei:back/tei:listPlace/tei:place">
                                                  <xsl:sort select="child::tei:placeName[1]"/>
                                                  <div class="entity-highlight-toggle"
                                                  data-type="place"
                                                  style="display: flex; align-items: flex-start; margin-bottom: 8px;">
                                                  <xsl:attribute name="data-entity-id">
                                                  <xsl:value-of select="data(@xml:id)"/>
                                                  </xsl:attribute>
                                                  <label class="switch"
                                                  style="flex-shrink: 0;">
                                                  <input type="checkbox"/>
                                                  <span class="i-slider round"
                                                  style="background-color: #ccc;"/>
                                                  </label>
                                                  <span class="opt-title" style="margin-left: 10px; flex: 1;">
                                                  <a class="places">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(data(@xml:id), '.html')"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="child::tei:placeName[1]/text()"/>
                                                  </a>
                                                  <xsl:if
                                                  test="child::tei:placeName[@type = 'alternative-name' or contains(@type, 'namensvariante')][1]">
                                                  <xsl:text> (</xsl:text>
                                                  <xsl:for-each
                                                  select="distinct-values(child::tei:placeName[@type = 'alternative-name' or contains(@type, 'namensvariante')])">
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                  <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  <xsl:text>)</xsl:text>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="child::tei:location[@type = 'coords']">
                                                  <xsl:text> </xsl:text>
                                                  <xsl:variable name="mlat"
                                                  select="replace(tokenize(tei:location[@type = 'coords'][1]/tei:geo, ' ')[1], ',', '.')"
                                                  as="xs:string"/>
                                                  <xsl:variable name="mlong"
                                                  select="replace(tokenize(tei:location[@type = 'coords'][1]/tei:geo, ' ')[2], ',', '.')"
                                                  as="xs:string"/>
                                                  <xsl:variable name="mappin"
                                                  select="concat('mlat=',$mlat, '&amp;mlon=', $mlong)"
                                                  as="xs:string"/>
                                                  <xsl:variable name="openstreetmapurl"
                                                  select="concat('https://www.openstreetmap.org/?', $mappin, '#map=12/', $mlat, '/', $mlong)"/>
                                                  <a class="theme-color">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$openstreetmapurl"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="target">
                                                  <xsl:text>_blank</xsl:text>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="rel">
                                                  <xsl:text>noopener</xsl:text>
                                                  </xsl:attribute>
                                                  <i class="fa-solid fa-location-dot"/>
                                                  </a>
                                                  </xsl:if>
                                                  </span>
                                                  </div>
                                                </xsl:for-each>
                                            </div>
                                        </details>
                                    </xsl:if>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Einstellungen Modal -->
                <div class="modal fade" id="editor-widget" tabindex="-1"
                    aria-labelledby="ueberlieferungLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLongTitle2"
                                    >Einstellungen</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <details open="open" style="margin-bottom: 1em;">
                                    <summary>Ansicht</summary>
                                    <div style="margin-top: 0.5em;">
                                        <div class="annotation-toggle" data-type="faksimile"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="faksimile-slider"
                                              checked="checked"/>
                                              <span class="i-slider round"
                                              style="background-color: #A63437;"/>
                                            </label>
                                            <span class="opt-title"> Faksimile</span>
                                        </div>

                                        <!-- NEW: Inline image mode toggle -->
                                        <div class="annotation-toggle" data-type="imgmode"
                                            style="display: inline-block; margin-right: 20px;"
                                            id="imgmode-toggle-container">
                                            <label class="switch">
                                              <input type="checkbox" id="image-mode-slider"
                                              disabled="disabled"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Bilder neben dem Text</span>
                                        </div>
                                    </div>
                                </details>

                                <details open="open" style="margin-bottom: 1em;">
                                    <summary>Textkritische Auszeichnungen</summary>
                                    <div style="margin-top: 0.5em;">
                                        <div class="annotation-toggle" data-type="ef2"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="ef2-slider"/>
                                              <span class="i-slider round"
                                              style="background-color: #A63437;"/>
                                            </label>
                                            <span class="opt-title"> Textkritische
                                              Zeichen</span>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="annotation-toggle" data-type="ls"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="langes-s-slider"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Langes-s (ſ)</span>
                                        </div>
                                        <div class="annotation-toggle" data-type="gem-m"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="gemination-m-slider"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Gemination m (m̅)</span>
                                        </div>
                                        <div class="annotation-toggle" data-type="gem-n"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="gemination-n-slider"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Gemination n (n̅)</span>
                                        </div>
                                        <div class="annotation-toggle" data-type="del"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="deleted-slider"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Streichung</span>
                                        </div>
                                        <div class="annotation-toggle" data-type="add"
                                            style="display: inline-block; margin-right: 20px;">
                                            <label class="switch">
                                              <input type="checkbox" id="addition-slider"/>
                                              <span class="i-slider round"/>
                                            </label>
                                            <span class="opt-title"> Hinzufügung</span>
                                        </div>
                                    </div>
                                </details>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal Tag -->
                <div class="modal fade" id="schnitzler-chronik-modal" tabindex="-1"
                    aria-labelledby="downloadModalLabel2" aria-hidden="true">
                    <xsl:variable name="datum-iso">
                        <xsl:variable name="date"
                            select="descendant::tei:correspDesc/tei:correspAction[@type = 'sent'][1]/tei:date"
                            as="node()?"/>
                        <xsl:choose>
                            <xsl:when test="$date/@when">
                                <xsl:value-of select="$date/@when"/>
                            </xsl:when>
                            <xsl:when test="$date/@from">
                                <xsl:value-of select="$date/@from"/>
                            </xsl:when>
                            <xsl:when test="$date/@notBefore">
                                <xsl:value-of select="$date/@notBefore"/>
                            </xsl:when>
                            <xsl:when test="$date/@to">
                                <xsl:value-of select="$date/@to"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$date/@notAfter"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="datum-written" select="
                            format-date($datum-iso, '[D1].&#160;[M1].&#160;[Y0001]',
                            'en',
                            'AD',
                            'EN')"/>
                    <xsl:variable name="wochentag">
                        <xsl:choose>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Monday'">
                                <xsl:text>Montag</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Tuesday'">
                                <xsl:text>Dienstag</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Wednesday'">
                                <xsl:text>Mittwoch</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Thursday'">
                                <xsl:text>Donnerstag</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Friday'">
                                <xsl:text>Freitag</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Saturday'">
                                <xsl:text>Samstag</xsl:text>
                            </xsl:when>
                            <xsl:when test="
                                    format-date($datum-iso, '[F]',
                                    'en',
                                    'AD',
                                    'EN') = 'Sunday'">
                                <xsl:text>Sonntag</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>DATUMSFEHLER</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLongTitle3">
                                    <a
                                        href="{concat('https://schnitzler-chronik.acdh.oeaw.ac.at/', $datum-iso, '.html')}"
                                        target="_blank" style="color: #008B8B">
                                        <xsl:value-of
                                            select="concat($wochentag, ', ', $datum-written)"/>
                                    </a>
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <div id="chronik-modal-body">
                                    <!-- SCHNITZLER-CHRONIK. Zuerst wird der Eintrag geladen, weil das schneller ist, wenn er lokal vorliegt -->
                                    <xsl:variable name="fetchContentsFromURL" as="node()?">
                                        <xsl:choose>
                                            <xsl:when test="$schnitzler-chronik_fetch-locally">
                                                <xsl:copy-of
                                                  select="document(concat('../chronik-data/', $datum-iso, '.xml'))"/>
                                                <!-- das geht davon aus, dass das schnitzler-chronik-repo lokal vorliegt -->
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of
                                                  select="document(concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-chronik-data/refs/heads/main/editions/data/', $datum-iso, '.xml'))"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:call-template name="mam:schnitzler-chronik">
                                        <xsl:with-param name="datum-iso" select="$datum-iso"/>
                                        <xsl:with-param name="current-type"
                                            select="$schnitzler-chronik_current-type"/>
                                        <xsl:with-param name="teiSource" select="$teiSource"/>
                                        <xsl:with-param name="fetchContentsFromURL"
                                            select="$fetchContentsFromURL" as="node()?"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Download Modal -->
                <div class="modal fade" id="downloadModal" tabindex="-1"
                    aria-labelledby="downloadModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLongTitle4"
                                    >Downloadmöglichkeiten</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Schließen"/>
                            </div>
                            <div class="modal-body">
                                <xsl:variable name="id-ohne-l"
                                    select="number(substring-after(tei:TEI/@xml:id, 'L'))"/>
                                <p>
                                    <a class="ml-3" data-bs-toggle="tooltip" title="Brief als PDF">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$source_pdf"/>
                                        </xsl:attribute>
                                        <i class="fa-lg far fa-file-pdf"/> PDF </a>
                                </p>
                                <p>
                                    <a class="ml-3" data-bs-toggle="tooltip"
                                        title="Brief als TEI-Datei">
                                        <xsl:attribute name="href">
                                            <xsl:value-of
                                                select="concat('https://github.com/arthur-schnitzler/schnitzler-briefe-data/blob/main/data/editions/', $teiDoc)"
                                            />
                                        </xsl:attribute>
                                        <xsl:attribute name="target">
                                            <xsl:text>_blank</xsl:text>
                                        </xsl:attribute>
                                        <i class="fa-lg far fa-file-code"/>
                                        <xsl:text> TEI</xsl:text>
                                    </a>
                                    <xsl:text>    (</xsl:text>
                                    <a class="ml-3" data-bs-toggle="tooltip"
                                        title="Brief als TEI-Datei">
                                        <xsl:attribute name="href">
                                            <xsl:value-of
                                                select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-data/refs/heads/main/data/editions/', $teiDoc)"
                                            />
                                        </xsl:attribute>
                                        <xsl:attribute name="target">
                                            <xsl:text>_blank</xsl:text>
                                        </xsl:attribute>
                                        <xsl:text>raw</xsl:text>
                                    </a>
                                    <xsl:text>)</xsl:text>
                                </p>
                                <p>
                                    <a class="ml-3" data-toggle="tooltip"
                                        title="Alle Briefe als EPUB">
                                        <xsl:attribute name="href">
                                            <xsl:text>https://schnitzler-briefe.acdh.oeaw.ac.at/epub.html</xsl:text>
                                        </xsl:attribute>
                                        <i class="fa-lg far fa-file-lines"/> EPUB (alle Briefe) </a>
                                </p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Hier die Modals für mehrere rs/@refs in einem -->
                <xsl:for-each
                    select="descendant::tei:rs[(not(ancestor::tei:note) and contains(@ref, ' ')) or descendant::tei:rs[not(ancestor::tei:note)]]">
                    <xsl:variable name="modalId1" as="xs:string">
                        <xsl:value-of select="string-join(.//@ref[not(ancestor::tei:note)], '')"/>
                    </xsl:variable>
                    <xsl:variable name="modalId">
                        <xsl:value-of
                            select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
                    </xsl:variable>
                    <xsl:call-template name="rsmodal">
                        <xsl:with-param name="modalId" select="replace($modalId, '#', '')"/>
                        <xsl:with-param name="back" select="$back"/>
                    </xsl:call-template>
                </xsl:for-each>
                <!--  rs/@refs in notes brauchen eigenes modal -->
                <xsl:for-each
                    select="descendant::tei:rs[((ancestor::tei:note) and contains(@ref, ' ')) or descendant::tei:rs[(ancestor::tei:note)]]">
                    <xsl:variable name="modalId1" as="xs:string">
                        <xsl:value-of select="string-join(.//@ref[(ancestor::tei:note)], '')"/>
                    </xsl:variable>
                    <xsl:variable name="modalId">
                        <xsl:value-of
                            select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
                    </xsl:variable>
                    <xsl:call-template name="rsmodal">
                        <xsl:with-param name="modalId" select="replace($modalId, '#', '')"/>
                        <xsl:with-param name="back" select="$back"/>
                    </xsl:call-template>
                </xsl:for-each>
                <script type="text/javascript" src="js/text-replacer.js"/>
                <script type="text/javascript" src="js/de-editor-config.js"/>
                <script type="text/javascript" src="js/prev-next-urlupdate.js"/>
                <script type="text/javascript" src="js/copy-to-clipboard.js"/>
                <!-- Schema.org JSON-LD -->
                <script type="application/ld+json">
                {
                  "@context": "https://schema.org",
                  "@type": "Letter",
                  "identifier": "<xsl:value-of select="$teiSource"/>",
                  "url": "<xsl:value-of select="$quotationURL"/>",
                  "name": "<xsl:value-of select="normalize-space($doc_title)"/>",
                  <xsl:if test="//tei:correspAction[@type = 'sent']//tei:persName">
                  "author": {
                    "@type": "Person",
                    "name": "<xsl:value-of select="normalize-space(//tei:correspAction[@type = 'sent']//tei:persName[1])"/>"<xsl:if test="//tei:correspAction[@type = 'sent']//tei:persName[1]/@ref">,
                    "@id": "<xsl:value-of select="replace(//tei:correspAction[@type = 'sent']//tei:persName[1]/@ref, '#pmb', 'https://pmb.acdh.oeaw.ac.at/entity/')"/>"</xsl:if>
                  },
                  </xsl:if>
                  <xsl:if test="//tei:correspAction[@type = 'received']//tei:persName">
                  "recipient": {
                    "@type": "Person",
                    "name": "<xsl:value-of select="normalize-space(//tei:correspAction[@type = 'received']//tei:persName[1])"/>"<xsl:if test="//tei:correspAction[@type = 'received']//tei:persName[1]/@ref">,
                    "@id": "<xsl:value-of select="replace(//tei:correspAction[@type = 'received']//tei:persName[1]/@ref, '#pmb', 'https://pmb.acdh.oeaw.ac.at/entity/')"/>"</xsl:if>
                  },
                  </xsl:if>
                  <xsl:if test="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso">
                  "dateCreated": "<xsl:value-of select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"/>",
                  </xsl:if>
                  "inLanguage": "de",
                  "isPartOf": {
                    "@type": "Collection",
                    "name": "Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren",
                    "url": "https://schnitzler-briefe.acdh.oeaw.ac.at/"
                  },
                  "publisher": {
                    "@type": "Organization",
                    "name": "Austrian Centre for Digital Humanities",
                    "url": "https://www.oeaw.ac.at/acdh/"
                  },
                  "license": "https://creativecommons.org/licenses/by/4.0/"
                }
                </script>
            </body>
        </html>
    </xsl:template>
    <!-- Regeln für Elemente -->
    <xsl:template match="tei:address">
        <xsl:choose>
            <xsl:when test="preceding-sibling::tei:address">
                <div class="column" style="margin-top: 30px;">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="column">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:addrLine">
        <div class="editionText addrLine">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:back"/>
    <xsl:template match="tei:text//tei:note[@type = 'commentary' or @type = 'textConst']//tei:bibl">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:attribute name="class">
                <xsl:text>editionText</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell/text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    <xsl:template match="tei:date[@*]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:div[not(@type = 'address')]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'address']">
        <div class="address-div">
            <xsl:apply-templates/>
        </div>
        <br/>
    </xsl:template>
    <xsl:template match="tei:gap">
        <xsl:choose>
            <xsl:when test="@reason = 'deleted'">
                <span class="del gap">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="data(@reason)"/>
                    </xsl:attribute>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="@reason = 'illegible'">
                <span class="gap">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="data(@reason)"/>
                    </xsl:attribute>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="tei:gap[@unit = 'chars' and (@reason = 'illegible' or @reason = 'textualLoss')]">
        <span class="illegible">
            <xsl:value-of select="mam:gaps(@quantity)"/>
        </span>
    </xsl:template>
    <xsl:function name="mam:gaps">
        <xsl:param name="anzahl"/>
        <xsl:text>×</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:gaps($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'illegible']">
        <div class="illegible">
            <xsl:text> [</xsl:text>
            <xsl:choose>
                <xsl:when test="@quantity = 1">
                    <xsl:text>eine Zeile</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@quantity"/>
                    <xsl:text> Zeilen</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> unleserlich] </xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="tei:gap[@unit = 'lines' and @reason = 'textualLoss']">
        <div class="illegible">
            <xsl:text> [</xsl:text>
            <xsl:choose>
                <xsl:when test="@quantity = 1">
                    <xsl:text>eine Zeile</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@quantity"/>
                    <xsl:text> Zeilen</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> Textverlust] </xsl:text>
        </div>
    </xsl:template>
    <xsl:template match="tei:gap[@reason = 'outOfScope']">
        <span class="outOfScope">[…]</span>
    </xsl:template>
    <!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:if test="@xml:id[starts-with(., 'org') or starts-with(., 'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <h3>
            <div>
                <xsl:apply-templates/>
            </div>
        </h3>
    </xsl:template>
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:lg">
        <span style="display:block;margin: 1em 0;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and not(descendant::lg[@type = 'stanza'])]">
        <div class="editionText poem">
            <ul>
                <xsl:apply-templates/>
            </ul>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'poem' and descendant::lg[@type = 'stanza']]">
        <div class="editionText poem">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:lg[@type = 'stanza']">
        <ul>
            <xsl:apply-templates/>
        </ul>
        <xsl:if test="not(position() = last())">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note[@type = 'footnote']">
        <xsl:if test="preceding-sibling::*[1][name() = 'note' and @type = 'footnote']">
            <!-- Sonderregel für zwei Fußnoten in Folge -->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print'][ancestor::tei:note]">
                        <xsl:text>pre-print</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>reference-black</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#footnote</xsl:text>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'footnote']" mode="footnote">
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:text>footnote</xsl:text>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print'][ancestor::tei:note]">
                        <xsl:text>pre-print</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>reference-black</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
            </sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates mode="footnote"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:note]" mode="footnote">
        <xsl:if test="not(position() = 1)">
            <br/>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:opener">
        <div class="editionText opener" style="margin-bottom: 0.75em;">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:seg[tei:seg[@rend = 'left'] and tei:seg[@rend = 'right']]">
        <div class="editionText flexContainer">
            <span class="seg-left">
                <xsl:apply-templates select="tei:seg[@rend = 'left']"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="seg-right">
                <xsl:apply-templates select="tei:seg[@rend = 'right']"/>
            </span>
        </div>
    </xsl:template>
    <xsl:template
        match="tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(ancestor::tei:note[@type = 'footnote']) and not(ancestor::tei:caption) and not(parent::tei:bibl) and not(parent::tei:quote) and not(child::tei:space[@dim])] | tei:dateline | tei:closer | tei:seg[not(parent::tei:seg) and not(child::tei:seg[@rend = 'left' or @rend = 'right']) and not(tei:seg[@rend = 'left'] and tei:seg[@rend = 'right'])]">
        <xsl:choose>
            <xsl:when test="child::tei:seg">
                <div class="editionText flexContainer">
                    <span class="seg-left">
                        <xsl:apply-templates select="tei:seg[@rend = 'left']"/>
                    </span>
                    <xsl:text> </xsl:text>
                    <span class="seg-right">
                        <xsl:apply-templates select="tei:seg[@rend = 'right']"/>
                    </span>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'right'">
                <div align="right" class="editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'left'">
                <div align="left" class="editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'center'">
                <div align="center" class="editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'inline'">
                <div class="inline editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="editionText">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:p[parent::tei:quote]">
        <xsl:apply-templates/>
        <xsl:if test="not(position() = last())">
            <xsl:text> / </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="tei:p[not(parent::tei:quote) and (ancestor::tei:note or ancestor::tei:note[@type = 'footnote'] or ancestor::tei:caption or parent::tei:bibl)]">
        <xsl:choose>
            <xsl:when test="@rend = 'right'">
                <div align="right">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'left'">
                <div align="left">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'center'">
                <div align="center">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend = 'inline'">
                <div style="inline">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div>
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:persName[@key | @ref]">
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
            <xsl:attribute name="data-key">
                <xsl:value-of select="@key"/>
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:placeName[@key | @ref]">
        <xsl:element name="a">
            <xsl:attribute name="class">reference</xsl:attribute>
            <xsl:attribute name="data-type">listplace.xml</xsl:attribute>
            <xsl:attribute name="data-key">
                <xsl:value-of select="@key"/>
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:salute[parent::tei:opener]">
        <p class="salute editionText">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:salute[not(parent::tei:opener)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:signed">
        <xsl:if test="not(preceding-sibling::node()[1][self::tei:lb])">
            <xsl:text> </xsl:text>
        </xsl:if>
        <span class="editionText signed">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!--<xsl:template match="tei:space[@unit='chars' and not(@quantity = 1)]">
        <span class="space">
            <xsl:value-of select="
                    string-join((for $i in 1 to @quantity
                    return
                        '&#x00A0;'), '')"/>
        </span>
    </xsl:template>-->
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']">
        <xsl:text>&#x00A0;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="verschachtelteA">
        <xsl:text>&#x00A0;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="verschachtelteA">
        <span class="gemination-m" data-original="mm" data-replacement="m̅">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="verschachtelteA">
        <span class="gemination-n" data-original="nn" data-replacement="n̅">nn</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="verschachtelteA">
        <span class="langes-s" data-original="s" data-replacement="ſ">s</span>
    </xsl:template>
    <xsl:template
        match="text()[matches(., '\s+$') and following-sibling::node()[1][self::tei:space[@unit = 'chars' and @quantity = '1']]]"
        mode="verschachtelteA">
        <xsl:value-of select="replace(., '\s+$', '')"/>
    </xsl:template>
    <xsl:template
        match="text()[matches(., '^\s+') and preceding-sibling::node()[1][self::tei:space[@unit = 'chars' and @quantity = '1']]]"
        mode="verschachtelteA">
        <xsl:value-of select="replace(., '^\s+', '')"/>
    </xsl:template>
    <xsl:template match="tei:note" mode="verschachtelteA"/>
    <xsl:template match="tei:hi" mode="verschachtelteA">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@rend = 'underline'">
                        <xsl:choose>
                            <xsl:when test="@n = '1'">
                                <xsl:text>underline</xsl:text>
                            </xsl:when>
                            <xsl:when test="@n = '2'">
                                <xsl:text>doubleUnderline</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>tripleUnderline</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@rend"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'line']">
        <xsl:value-of select="mam:spaci-space(@quantity, @quantity)"/>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and not(@quantity = 1)]">
        <xsl:variable name="weite" select="0.5 * @quantity"/>
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:value-of select="concat('display:inline-block; width: ', $weite, 'em; ')"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:space[@dim = 'vertical' and not(@unit)]">
        <br/>
        <div>
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="@quantity">
                        <xsl:value-of select="concat('margin-bottom:', @quantity, 'em;')"/>
                    </xsl:when>
                    <xsl:otherwise>margin-bottom:1em;</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </div>
    </xsl:template>
    <!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>table editionText</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:attribute name="class">
                    <xsl:text>table editionText</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:function name="mam:dots">
        <xsl:param name="anzahl"/>
        <xsl:text>.&#160;</xsl:text>
        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
    <!-- Wechsel der Schreiber <handShift -->
    <xsl:template match="tei:handShift[not(@scribe)]">
        <xsl:choose>
            <xsl:when test="@medium = 'typewriter'">
                <span class="typewriter">
                    <xsl:text>[maschinenschriftlich:] </xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="handschriftlich">
                    <xsl:text>[handschriftlich:] </xsl:text>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:handShift[@scribe]">
        <xsl:variable name="scribe">
            <xsl:value-of select="replace(@scribe, '#', '')"/>
        </xsl:variable>
        <span class="handschriftlich">
            <xsl:text>[handschriftlich </xsl:text>
            <span class="persons badge-item">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($scribe, '.html')"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>reference-black</xsl:text>
                    </xsl:attribute>
                    <xsl:variable name="schreibername"
                        select="ancestor::tei:TEI/tei:text[1]/tei:back[1]/tei:listPerson[1]/tei:person[@xml:id = $scribe]/tei:persName[1]"
                        as="node()"/>
                    <xsl:choose>
                        <xsl:when test="starts-with($schreibername/tei:surname, '??')">
                            <xsl:text>unbekannte Hand</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="concat($schreibername/tei:forename, ' ', $schreibername/tei:surname)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </span>
            <xsl:text>:] </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="tei:objectType">
        <!-- VVV -->
        <xsl:choose>
            <xsl:when test="text() != ''">
                <!-- für den Fall, dass Textinhalt, wird einfach dieser ausgegeben -->
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@ana">
                <xsl:choose>
                    <xsl:when test="@ana = 'fotografie'">
                        <xsl:text>Fotografie</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'entwurf' and @corresp = 'brief'">
                        <xsl:text>Briefentwurf</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'entwurf' and @corresp = 'telegramm'">
                        <xsl:text>Telegrammentwurf</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'bildpostkarte'">
                        <xsl:text>Bildpostkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'postkarte'">
                        <xsl:text>Postkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'briefkarte'">
                        <xsl:text>Briefkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@ana = 'visitenkarte'">
                        <xsl:text>Visitenkarte</xsl:text>
                    </xsl:when>
                    <xsl:when test="@corresp = 'widmung'">
                        <xsl:choose>
                            <xsl:when test="@ana = 'widmung_vorsatzblatt'">
                                <xsl:text>Widmung am Vorsatzblatt</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_titelblatt'">
                                <xsl:text>Widmung am Titelblatt</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_schmutztitel'">
                                <xsl:text>Widmung am Schmutztitel</xsl:text>
                            </xsl:when>
                            <xsl:when test="@ana = 'widmung_umschlag'">
                                <xsl:text>Widmung am Umschlag</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- ab hier ist nurmehr @corresp zu berücksichtigen, alle @ana-Fälle sind erledigt -->
            <xsl:when test="@corresp = 'anderes'">
                <xsl:text>Sonderfall</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'bild'">
                <xsl:text>Bild</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'brief'">
                <xsl:text>Brief</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'karte'">
                <xsl:text>Karte</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'kartenbrief'">
                <xsl:text>Kartenbrief</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'telegramm'">
                <xsl:text>Telegramm</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'kuvert'">
                <xsl:text>Kuvert</xsl:text>
            </xsl:when>
            <xsl:when test="@corresp = 'widmung'">
                <xsl:text>Widmung</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="rsmodal">
        <xsl:param name="modalId" as="xs:string"/>
        <xsl:param name="back" as="node()?"/>
        <div class="modal fade" id="{$modalId}" tabindex="-1" aria-labelledby="{$modalId}"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle4">Auswahl</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Schließen"/>
                    </div>
                    <div class="modal-body">
                        <ul>
                            <xsl:for-each select="tokenize($modalId, 'pmb')">
                                <xsl:variable name="current" select="concat('pmb', .)"
                                    as="xs:string"/>
                                <xsl:if test=". != ''">
                                    <li>
                                        <xsl:variable name="eintrag"
                                            select="$back//tei:*[@xml:id = $current][1]"
                                            as="node()?"/>
                                        <xsl:variable name="typ" select="$eintrag/name()"
                                            as="xs:string?"/>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat($current, '.html')"/>
                                            </xsl:attribute>
                                            <!-- Add entity-specific CSS class for colored modal links -->
                                            <xsl:attribute name="class">
                                                <xsl:choose>
                                                  <xsl:when test="$typ = 'place'">places</xsl:when>
                                                  <xsl:when test="$typ = 'bibl'">works</xsl:when>
                                                  <xsl:when test="$typ = 'org'">orgs</xsl:when>
                                                  <xsl:when test="$typ = 'event'">events</xsl:when>
                                                  <xsl:when test="$typ = 'person'"
                                                  >persons</xsl:when>
                                                  <xsl:otherwise/>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            <xsl:choose>
                                                <xsl:when test="$typ = 'place'">
                                                  <xsl:value-of select="$eintrag/tei:placeName[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'bibl'">
                                                  <xsl:value-of select="$eintrag/tei:title[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'org'">
                                                  <xsl:value-of select="$eintrag/tei:orgName[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'event'">
                                                  <xsl:value-of select="$eintrag/tei:eventName[1]"/>
                                                </xsl:when>
                                                <xsl:when test="$typ = 'person'">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$eintrag/tei:persName[1]/tei:forename and $eintrag/tei:persName[1]/tei:surname">
                                                  <xsl:value-of
                                                  select="concat($eintrag/tei:persName[1]/tei:forename, ' ', $eintrag/tei:persName[1]/tei:surname)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="$eintrag/tei:persName[1]"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text>offen</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </li>
                                </xsl:if>
                            </xsl:for-each>
                        </ul>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- tei:rs -->
    <!-- erster Fall: alles ganz einfach, keine Verschachtelung, keine note: -->
    <xsl:template
        match="tei:rs[not(ancestor::tei:note)][not(ancestor::tei:rs) and not(descendant::tei:rs[not(ancestor::tei:note)]) and not(contains(@ref, ' '))] | tei:persName | tei:author | tei:placeName | tei:orgName | tei:eventName">
        <xsl:variable name="entity-typ" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'person'">
                    <xsl:text>persons</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'work'">
                    <xsl:text>works</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'place'">
                    <xsl:text>places</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'org'">
                    <xsl:text>orgs</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'event'">
                    <xsl:text>events</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat($entity-typ, ' badge-item entity')"/>
            </xsl:attribute>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat(replace(@ref, '#', ''), '.html')"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when
                        test="ancestor::tei:hi[@rend = 'pre-print'] and not(ancestor::tei:note)">
                        <xsl:attribute name="class">
                            <xsl:text>pre-print</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="ancestor::tei:note[ancestor::tei:hi[@rend = 'pre-print']]">
                        <xsl:attribute name="class">
                            <xsl:text>reference-black</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when
                        test="ancestor::tei:hi[(@rend = 'stamp' and not(ancestor::tei:note)) or (ancestor::tei:note and ancestor::tei:hi[@rend = 'stamp' and ancestor::tei:note])]">
                        <xsl:attribute name="class">
                            <xsl:text>stamp</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="ancestor::tei:damage">
                        <xsl:attribute name="class">
                            <xsl:text>damage-critical</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when
                        test="ancestor::tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(parent::tei:bibl)] or ancestor::tei:opener or ancestor::tei:addrLine or ancestor::tei:signed or ancestor::tei:salute[parent::tei:opener] or ancestor::tei:seg[not(parent::tei:seg)] or ancestor::tei:dateline or ancestor::tei:closer or ancestor::tei:lg or ancestor::tei:l">
                        <xsl:attribute name="class">
                            <xsl:text>reference-black</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:element>
        </span>
    </xsl:template>
    <!-- zweiter Fall: rs ist nicht in einem note und hat entweder mehrere Werte im @ref oder einen Nachkommen,
    der ebenfalls ein @ref hat (und auch nicht im note steht) -->
    <xsl:template
        match="tei:rs[not(ancestor::tei:note) and contains(@ref, ' ') or descendant::tei:rs[not(ancestor::tei:note)]]">
        <xsl:variable name="modalId1" as="xs:string">
            <xsl:value-of select=".//@ref[not(ancestor::tei:note)]"/>
        </xsl:variable>
        <xsl:variable name="modalId">
            <xsl:value-of select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
        </xsl:variable>
        <!-- Create entity-specific span wrapper for colored underlines on nested rs elements -->
        <xsl:variable name="entity-classes">
            <xsl:call-template name="get-nested-entity-classes"/>
        </xsl:variable>
        <span class="{$entity-classes} entity">
            <xsl:element name="a">
                <xsl:attribute name="class">
                    <xsl:text>reference-black</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-bs-toggle">modal</xsl:attribute>
                <xsl:attribute name="data-bs-target">
                    <xsl:value-of select="concat('#', $modalId)"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when
                        test="ancestor::tei:hi[(@rend = 'stamp' and not(ancestor::tei:note)) or (ancestor::tei:note and ancestor::tei:hi[@rend = 'stamp' and ancestor::tei:note])]">
                        <span class="stamp">
                            <xsl:apply-templates mode="verschachtelteA"/>
                        </span>
                    </xsl:when>
                    <xsl:when
                        test="ancestor::tei:hi[(@rend = 'pre-print' and not(ancestor::tei:note)) or (ancestor::tei:note and ancestor::tei:hi[@rend = 'pre-print' and ancestor::tei:note])]">
                        <span class="pre-print">
                            <xsl:apply-templates mode="verschachtelteA"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="verschachtelteA"/>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- hier die Sonderregeln für ein solches rs -->
            </xsl:element>
        </span>
    </xsl:template>
    <!-- Ein rs, das in einem anderen enthalten wird, wird ausgegeben, aber nicht mehr weiter zu einem Link etc. -->
    <xsl:template match="tei_rs" mode="verschachtelteA">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Nun ein einfaches rs in einer note -->
    <xsl:template
        match="tei:rs[ancestor::tei:note][not(ancestor::tei:rs[ancestor::tei:note]) and not(descendant::tei:rs) and not(contains(@ref, ' '))]">
        <xsl:variable name="entity-typ" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'person'">
                    <xsl:text>persons</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'work'">
                    <xsl:text>works</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'place'">
                    <xsl:text>places</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'org'">
                    <xsl:text>orgs</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'event'">
                    <xsl:text>events</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="concat($entity-typ, ' badge-item entity')"/>
            </xsl:attribute>
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat(replace(@ref, '#', ''), '.html')"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print'][ancestor::tei:note]">
                        <xsl:attribute name="class">
                            <xsl:text>pre-print</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="ancestor::tei:hi[@rend = 'pre-print']">
                        <xsl:attribute name="class">
                            <xsl:text>reference-black</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when
                        test="ancestor::tei:hi[(@rend = 'stamp' and not(ancestor::tei:note)) or (ancestor::tei:note and ancestor::tei:hi[@rend = 'stamp' and ancestor::tei:note])]">
                        <xsl:attribute name="class">
                            <xsl:text>stamp</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="ancestor::tei:damage">
                        <xsl:attribute name="class">
                            <xsl:text>damage-critical</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when
                        test="ancestor::tei:p[ancestor::tei:body and not(ancestor::tei:note) and not(parent::tei:bibl)] or ancestor::tei:opener or ancestor::tei:addrLine or ancestor::tei:signed or ancestor::tei:salute[parent::tei:opener] or ancestor::tei:seg[not(parent::tei:seg)] or ancestor::tei:dateline or ancestor::tei:closer or ancestor::tei:lg">
                        <xsl:attribute name="class">
                            <xsl:text>reference-black</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:element>
        </span>
    </xsl:template>
    <!-- ein verschachteltes rs in note -->
    <xsl:template match="tei:rs[ancestor::tei:note][contains(@ref, ' ') or descendant::tei:rs]">
        <xsl:variable name="modalId1" as="xs:string">
            <xsl:value-of select=".//@ref"/>
        </xsl:variable>
        <xsl:variable name="modalId">
            <xsl:value-of select="xs:string(replace(replace($modalId1, ' #', ''), '#', ''))"/>
        </xsl:variable>
        <!-- Create entity-specific span wrapper for colored underlines on nested rs elements in notes -->
        <xsl:variable name="entity-classes">
            <xsl:call-template name="get-nested-entity-classes-note"/>
        </xsl:variable>
        <span class="{$entity-classes} entity">
            <xsl:element name="a">
                <xsl:attribute name="class">
                    <xsl:text>reference-black</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-bs-toggle">modal</xsl:attribute>
                <xsl:attribute name="data-bs-target">
                    <xsl:value-of select="concat('#', $modalId)"/>
                </xsl:attribute>
                <xsl:apply-templates mode="verschachtelteA"/>
                <!-- hier die Sonderregeln für ein solches rs -->
            </xsl:element>
        </span>
    </xsl:template>
    <!-- Template to determine entity classes for nested rs elements -->
    <xsl:template name="get-nested-entity-classes">
        <xsl:param name="back" select="//tei:back" as="node()?"/>
        <xsl:variable name="current-element" select="." as="node()"/>
        <xsl:variable name="all-refs" as="xs:string*">
            <xsl:for-each select=".//@ref[not(ancestor::tei:note)]">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:if test="normalize-space(.) != ''">
                        <xsl:value-of select="replace(normalize-space(.), '^#', '')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="entity-types" as="xs:string*">
            <xsl:for-each select="$all-refs">
                <xsl:variable name="ref" select="."/>
                <xsl:variable name="entity" select="$back//tei:*[@xml:id = $ref][1]"/>
                <xsl:choose>
                    <xsl:when test="$entity/name() = 'person'">persons</xsl:when>
                    <xsl:when test="$entity/name() = 'place'">places</xsl:when>
                    <xsl:when test="$entity/name() = 'org'">orgs</xsl:when>
                    <xsl:when test="$entity/name() = 'bibl'">works</xsl:when>
                    <xsl:when test="$entity/name() = 'event'">events</xsl:when>
                    <xsl:otherwise>
                        <!-- Fallback to @type of current rs element if entity lookup fails -->
                        <xsl:choose>
                            <xsl:when test="$current-element/@type = 'person'">persons</xsl:when>
                            <xsl:when test="$current-element/@type = 'place'">places</xsl:when>
                            <xsl:when test="$current-element/@type = 'org'">orgs</xsl:when>
                            <xsl:when test="$current-element/@type = 'work'">works</xsl:when>
                            <xsl:when test="$current-element/@type = 'event'">events</xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <!-- Return unique entity types joined with space -->
        <xsl:value-of select="string-join(distinct-values($entity-types), ' ')"/>
    </xsl:template>
    <!-- Template to determine entity classes for nested rs elements in notes -->
    <xsl:template name="get-nested-entity-classes-note">
        <xsl:param name="back" select="//tei:back" as="node()?"/>
        <xsl:variable name="current-element" select="." as="node()"/>
        <xsl:variable name="all-refs" as="xs:string*">
            <xsl:for-each select=".//@ref[ancestor::tei:note]">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:if test="normalize-space(.) != ''">
                        <xsl:value-of select="replace(normalize-space(.), '^#', '')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="entity-types" as="xs:string*">
            <xsl:for-each select="$all-refs">
                <xsl:variable name="ref" select="."/>
                <xsl:variable name="entity" select="$back//tei:*[@xml:id = $ref][1]"/>
                <xsl:choose>
                    <xsl:when test="$entity/name() = 'person'">persons</xsl:when>
                    <xsl:when test="$entity/name() = 'place'">places</xsl:when>
                    <xsl:when test="$entity/name() = 'org'">orgs</xsl:when>
                    <xsl:when test="$entity/name() = 'bibl'">works</xsl:when>
                    <xsl:when test="$entity/name() = 'event'">events</xsl:when>
                    <xsl:otherwise>
                        <!-- Fallback to @type of current rs element if entity lookup fails -->
                        <xsl:choose>
                            <xsl:when test="$current-element/@type = 'person'">persons</xsl:when>
                            <xsl:when test="$current-element/@type = 'place'">places</xsl:when>
                            <xsl:when test="$current-element/@type = 'org'">orgs</xsl:when>
                            <xsl:when test="$current-element/@type = 'work'">works</xsl:when>
                            <xsl:when test="$current-element/@type = 'event'">events</xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <!-- Return unique entity types joined with space -->
        <xsl:value-of select="string-join(distinct-values($entity-types), ' ')"/>
    </xsl:template>
    <xsl:template
        match="tei:rs[@type = 'work' and not(ancestor::tei:quote) and ancestor::tei:note and not(@subtype = 'implied')]/text()">
        <span class="works {substring-after(@rendition, '#')}" id="{@xml:id}">
            <span class="italics">
                <xsl:value-of select="."/>
            </span>
        </span>
    </xsl:template>
</xsl:stylesheet>
