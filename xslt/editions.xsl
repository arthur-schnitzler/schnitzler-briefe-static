<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>
    <xsl:import href="./partials/html_title_navigation.xsl"/>
    <xsl:import href="./partials/view-type.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
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
            select="concat(normalize-space(//tei:titleStmt/tei:title[@level = 'a']), '. In: Arthur Schnitzler: Briefwechsel mit Autorinnen und Autoren. Digitale Edition. Hg. Martin Anton Müller, Gerd Hermann Susen und Laura Untner, ', $quotationURL, ' (Abfrage ', $currentDate, ')')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleSmt/tei:title[@level = 'a'][1]/text()"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleSmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
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
                        <xsl:variable name="facs_id" select="concat(@type, '_img_', generate-id())"/>
                        <xsl:variable name="facs_item" select="descendant::tei:pb[1]/@facs"/>
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
            </head>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="wp-transcript">
                            <div class="card" data-index="true">
                                <div class="card-header">
                                    <xsl:call-template name="header-nav"/>
                                </div>
                                <div id="container-resize" class="row transcript active">
                                    <xsl:for-each select="descendant::tei:body">
                                        <xsl:call-template name="mam:view-type-img"/>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <div class="card-footer" style="clear: both;">
                                <div id="editor-widget">
                                    <xsl:call-template name="annotation-options"/>
                                </div>
                                <nav class="navbar navbar-expand-lg">
                                    <div class="container-fluid">
                                        <div>
                                            <ul id="secondary-menu" class="navbar-nav mb-2 mb-lg-0">
                                                <xsl:if
                                                  test="not(descendant::tei:teiHeader[1]/tei:revisionDesc[1]/@status = 'approved')">
                                                  <li class="nav-item">
                                                      &#160;<a href="#" data-bs-target="#qualitaet" type="button"
                                                          data-bs-toggle="modal">
                                                  <i class="fas fa-landmark"/>
                                                  <span style="color: orange;">ENTWURF</span>
                                                      </a>&#160;
                                                  </li>
                                                </xsl:if>
                                                <li class="nav-item">
                                                    &#160;<a href="#" data-bs-target="#ueberlieferung" type="button"
                                                        data-bs-toggle="modal">
                                                        <i class="fas fa-landmark"/> ÜBERLIEFERUNG </a>&#160;
                                                </li>
                                                <li class="nav-item">
                                                    &#160;<a href="#" data-bs-target="#zitat" type="button"
                                                        data-bs-toggle="modal">
                                                        <i class="fas fa-quote-right"/> ZITIEREN</a>&#160;
                                                </li>
                                                <li class="nav-item">
                                                  <xsl:variable name="datum">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when"
                                                  />
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notBefore"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@notAfter"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:variable>
                                                  <a class="nav-link">
                                                  <xsl:attribute name="target">
                                                  <xsl:text>_blank</xsl:text>
                                                  </xsl:attribute>
                                                      <xsl:attribute name="type">
                                                          <xsl:text>button</xsl:text>
                                                      </xsl:attribute>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', $datum, '.html')"
                                                  />
                                                  </xsl:attribute><!--<span style="color:#037a33;">-->
                                                  <i class="fas fa-external-link-alt"/>
                                                  TAGEBUCH<!--</span>-->
                                                  </a>
                                                </li>
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
                                <h5 class="modal-title" id="exampleModalLongTitle">
                                    <xsl:for-each
                                        select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"/>
                            </div>
                            <div class="modal-body">
                                <table class="table table-striped">
                                    <tbody>
                                        <xsl:for-each select="//tei:correspAction">
                                            <tr>
                                                <th>
                                                  <xsl:choose>
                                                  <xsl:when test="@type = 'sent'"> Versand: </xsl:when>
                                                  <xsl:when test="@type = 'received'"> Empfangen: </xsl:when>
                                                  <xsl:when test="@type = 'forwarded'">
                                                  Weitergeleitet: </xsl:when>
                                                  <xsl:when test="@type = 'redirected'"> Umgeleitet: </xsl:when>
                                                  <xsl:when test="@type = 'delivered'"> Zustellung: </xsl:when>
                                                  <xsl:when test="@type = 'transmitted'">
                                                  Übermittelt: </xsl:when>
                                                  </xsl:choose>
                                                </th>
                                                <td> </td>
                                                <td>
                                                  <xsl:if test="./tei:date">
                                                  <xsl:value-of select="./tei:date"/>
                                                  <br/>
                                                  </xsl:if>
                                                  <xsl:if test="./tei:persName">
                                                  <xsl:value-of select="./tei:persName"
                                                  separator="; "/>
                                                  <br/>
                                                  </xsl:if>
                                                  <xsl:if test="./tei:placeName">
                                                  <xsl:value-of select="./tei:placeName"
                                                  separator="; "/>
                                                  <br/>
                                                  </xsl:if>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                <br/>
                                <!-- Modal Überlieferung -->
                                <div class="modal-body">
                                    <xsl:for-each select="//tei:witness">
                                        <h5>TEXTZEUGE <xsl:value-of select="@n"/>
                                        </h5>
                                        <table class="table table-striped">
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
                                                <xsl:if test="//tei:physDesc">
                                                  <tr>
                                                  <th>Beschreibung </th>
                                                  <td>
                                                  <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:objectDesc"/>
                                                  </td>
                                                  </tr>
                                                  <xsl:if
                                                  test="tei:msDesc/tei:physDesc/tei:typeDesc">
                                                  <xsl:apply-templates
                                                  select="tei:msDesc/tei:physDesc/tei:typeDesc"/>
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
                                        <h5>DRUCK <xsl:value-of select="position()"/>
                                        </h5>
                                        <table class="table table-striped">
                                            <tbody>
                                                <tr>
                                                  <th/>
                                                  <td>
                                                  <xsl:value-of
                                                  select="mam:bibliografische-angabe(.)"/>
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
                <div class="modal fade" id="zitat" tabindex="-1"
                    aria-labelledby="zitatModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel"
                                    >Zitat</h5>
                                <button type="button" class="btn-close"
                                    data-bs-dismiss="modal" aria-label="Close"/>
                            </div>
                            <div class="modal-body">
                                <p>Eine zitierfähige Angabe dieser Seite lautet:</p>
                                <blockquote>
                                    <xsl:value-of select="$quotationString"/>
                                </blockquote>
                                <p/>
                                <p>Für gekürzte Zitate reicht die Angabe der
                                    Briefnummer aus, die eindeutig und persistent ist:
                                    »<b><xsl:value-of
                                        select="replace(tokenize(base-uri(), '/')[last()], '.xml', '')"
                                    /></b>«.</p>
                                <p>Für Belege in der Wikipedia kann diese Vorlage
                                    benutzt werden:</p>
                                <blockquote>
                                    <code>{{Internetquelle |url=<xsl:value-of
                                        select="base-uri()"/> |titel=<xsl:value-of
                                            select="$doc_title"/> |werk=Arthur Schnitzler:
                                        Briefwechsel mit Autorinnen und Autoren
                                        |hrsg=Martin Anton Müller, Gerd-Hermann Susen,
                                        Laura Untner |sprache=de |datum=<xsl:value-of
                                            select="//tei:titleStmt/tei:title[@type = 'iso-date']/@when-iso"
                                        /> |abruf=<xsl:value-of
                                            select="format-date(current-date(), '[Y4]-[M2]-[D2]')"
                                        /> }} </code>
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
                                <h5 class="modal-title" id="exampleModalLabel"
                                    >Textqualität</h5>
                                <button type="button" class="btn-close"
                                    data-bs-dismiss="modal" aria-label="Close"/>
                            </div>
                            <div class="modal-body">
                                <!-- <p>Diese Abschrift wurde noch nicht ausreichend mit
                                                  dem Original abgeglichen. Sie sollte derzeit nicht
                                                  – oder nur durch eigenen Abgleich mit dem
                                                  Faksimile, falls vorliegend – als Zitatvorlage
                                                  dienen.</p>-->
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://unpkg.com/de-micro-editor@0.2.6/dist/de-editor.min.js"/>
                <script type="text/javascript" src="js/run.js"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:back"/>
</xsl:stylesheet>
