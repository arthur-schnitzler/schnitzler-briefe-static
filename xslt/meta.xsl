<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/shared.xsl"/>
    <!--<xsl:import href="partials/tei-facsimile.xsl"/>-->
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h2 align="center">
                                    <xsl:value-of select="$doc_title"/>
                                </h2>
                            </div>
                            <div class="card-body-index">
                                <xsl:apply-templates select="descendant::tei:body"/>
                            </div>
                            <xsl:if test="descendant::tei:note[@type = 'footnote']">
                                <div class="card-body-index">
                                    <p/>
                                    <h3>Fussnoten</h3>
                                    <xsl:element name="ol">
                                        <xsl:attribute name="class">
                                            <xsl:text>list-for-footnotes-meta</xsl:text>
                                        </xsl:attribute>
                                        <xsl:apply-templates
                                            select="descendant::tei:note[@type = 'footnote']"
                                            mode="footnote"/>
                                    </xsl:element>
                                </div>
                            </xsl:if>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:body">
        <xsl:if test="descendant::tei:div[starts-with(@type, 'level')]">
            <xsl:element name="nav">
                <xsl:attribute name="style">
                    <xsl:text>z-index: 0;</xsl:text>
                    <xsl:text>margin: 3em;</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>page-toc</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>navbar navbar-light</xsl:text>
                </xsl:attribute>
                <div class="container">
                    <a class="navbar-brand" href="#">Inhaltsverzeichnis</a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                        data-bs-target="#verticalNavbar" aria-controls="verticalNavbar"
                        aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"/>
                    </button>
                    <div class="collapse navbar-collapse" id="verticalNavbar">
                        <!-- Wenn es divs mit level gibt, Inhaltsverzeichnis am Anfang der Seite -->
                        <xsl:element name="ul">
                            <xsl:attribute name="class">
                                <xsl:text>navbar-nav</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates select="child::tei:div[@type = 'level1']"
                                mode="nav"/>
                        </xsl:element>
                    </div>
                </div>
            </xsl:element>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:div[@type = 'level1']" mode="nav">
        <xsl:apply-templates select="child::tei:head" mode="nav"/>
        <xsl:if test="child::tei:div">
            <xsl:element name="li">
                <xsl:attribute name="class">
                    <xsl:text>nav-item</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select="child::tei:div" mode="nav"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:div[not(@type = 'level1')]" mode="nav">
        <xsl:element name="ul">
            <xsl:attribute name="class">
                <xsl:text>navbar-nav</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::tei:head" mode="nav"/>
            <xsl:if test="child::tei:div">
                <xsl:element name="li">
                    <xsl:attribute name="class">
                        <xsl:text>nav-item</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="child::tei:div" mode="nav"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <!-- Match the head element -->
    <xsl:template match="tei:head" mode="nav">
        <xsl:variable name="linktarget" select="concat('#', @xml:id)"/>
        <li>
            <xsl:attribute name="class">
                <xsl:text>nav-item</xsl:text>
            </xsl:attribute>
            <a href="{$linktarget}">
                <xsl:value-of select="normalize-space(.)"/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="tei:p[@rend = 'center']">
        <p align="center">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:p[@rend = 'right']">
        <p align="right">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template
        match="tei:div[not(@xml:id = 'container-ohne-slider') and not(@xml:id = 'container-mit-slider')]">
        <div id="{generate-id()}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[@xml:id = 'container-ohne-slider']">
        <div style="display: flex; width: 100%;">
            <div
                style="width: 40%; margin: auto; display: flex; flex-direction: column; height: 500px;">
                   <div id="container-ohne-slider" style="width: 100%; flex-grow: 1;"/>
                <div style="width: 100%; height: 55px;"/>
                <figcaption style="text-align: center;">Abb. 8: Alle Korrespondenzen zwischen Arthur
                    Schnitzler, Hermann Bahr, Richard Beer-Hofmann und Hugo von
                    Hofmannsthal</figcaption>
            </div>
            <div
                style="width: 40%; margin: auto; display: flex; flex-direction: column; height: 500px;">
                <div id="container-mit-slider" style="width: 100%; flex-grow: 1;"></div>
                <div style="width: 100%; text-align: center; margin-top: 5px;">
                    <input type="range" id="yearSlider" min="1890" max="1931" value="1900" step="1" style="display: block; margin: 0 auto;"/>
                    <span id="yearDisplay" style="display: block; margin-top: 2px;">1900</span>
                </div>
                <figcaption style="text-align: center; margin-top: auto;">Abb. 9: Alle
                    Korrespondenzen zwischen Arthur Schnitzler, Hermann Bahr, Richard Beer-Hofmann
                    und Hugo von Hofmannsthal im Timeslider</figcaption>
            </div>
        </div>
        <script src="js/jung-wien-exp-charts.js"/>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>unclear</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:del">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:apply-templates/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:caption">
        <xsl:element name="figcaption">
            <xsl:attribute name="class">
                <xsl:apply-templates/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="data(@xml:id)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:text>table</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:head[not(@type = 'sub')]">
        <h2>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:head[(@type = 'sub')]">
        <h3>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'footnote']">
        <!--<xsl:if test="preceding-sibling::*[1][self::tei:note and @type = 'footnote']">
            <!-\- Sonderregel für zwei Fußnoten in Folge -\->
            <sup>
                <xsl:text>,</xsl:text>
            </sup>
        </xsl:if>-->
        <xsl:variable name="fussnotennummer">
            <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
        </xsl:variable>
        <xsl:element name="a">
            <xsl:attribute name="class">
                <xsl:text>reference-black</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('#footnote', $fussnotennummer)"/>
            </xsl:attribute>
            <sup>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat('fussnote-im-text', $fussnotennummer)"/>
                </xsl:attribute>
                <xsl:value-of select="$fussnotennummer"/>
            </sup>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note[@type = 'footnote']" mode="footnote">
        <xsl:variable name="fussnotennummer" as="xs:integer">
            <xsl:number level="any" count="tei:note[@type = 'footnote']" format="1"/>
        </xsl:variable>
        <xsl:element name="li">
            <xsl:attribute name="id">
                <xsl:value-of select="concat('footnote', $fussnotennummer)"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>footnote</xsl:text>
            </xsl:attribute>
            <sup>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#fussnote-im-text', $fussnotennummer)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$fussnotennummer"/>
                </xsl:element>
            </sup>
            <xsl:text> </xsl:text>
            <xsl:apply-templates mode="footnote"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:p" mode="footnote">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::*[1][self::tei:p])">
                <xsl:apply-templates mode="footnote"/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates mode="footnote"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:bibl" mode="footnote">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:rs[@type = 'work']/text()">
        <i>
            <xsl:value-of select="."/>
        </i>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:ptr">
        <xsl:variable name="targett">
            <xsl:choose>
                <xsl:when
                    test="starts-with(@target, 'D041') or starts-with(@target, 'L041') or starts-with(@target, 'T03') or starts-with(@target, 'I041')">
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LD')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('D041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LL')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LI')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'LT')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003', $dateiname, '.html/#', @target)"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KD')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('D041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KK')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('L041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KI')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('I041', $dateiname, '.html/#bottom')"/>
                </xsl:when>
                <xsl:when test="starts-with(@target, 'KT')">
                    <xsl:variable name="dateiname"
                        select="substring-before(substring(@target, 3), '-')"/>
                    <xsl:value-of select="concat('T003', $dateiname, '.html/#bottom')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="{$targett}" class="fas fa-link"/>
    </xsl:template>
    <xsl:template match="tei:list[@type = 'simple-gloss']">
        <ul class="list list_simple-gloss">
            <xsl:variable name="listinhalt" select="." as="node()"/>
            <xsl:for-each select="child::tei:label">
                <xsl:variable name="postion" select="position()"/>
                <li>
                    <span class="tei_label">
                        <xsl:apply-templates/>
                    </span>
                    <span class="item">
                        <xsl:apply-templates select="$listinhalt/tei:item[$postion]"/>
                    </span>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template match="tei:label[parent::tei:list[@type = 'simple-gloss']]">
        <li>
            <span class="list_simple-gloss">
                <xsl:apply-templates/>
            </span>
        </li>
    </xsl:template>
    <xsl:template match="tei:item[parent::tei:list[@type = 'simple-gloss']]">
        <li>
            <span class="list_simple-gloss">
                <xsl:apply-templates/>
            </span>
        </li>
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
    <!-- LISTPLACE -->
    <xsl:template match="tei:listPlace">
        <ul>
            <xsl:apply-templates select="tei:place" mode="listPlace"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:place" mode="listPlace">
        <li>
            <xsl:apply-templates select="tei:placeName" mode="listTitle"/>
            <table>
                <xsl:apply-templates select="tei:*[not(self::tei:placeName)]" mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:placeName | tei:orgName | tei:persName | tei:title" mode="listTitle">
        <b>
            <xsl:apply-templates/>
        </b>
        <br/>
    </xsl:template>
    <!-- LISTORG -->
    <xsl:template match="tei:listOrg">
        <ul>
            <xsl:apply-templates mode="listOrg"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:org" mode="listOrg">
        <li>
            <xsl:apply-templates select="tei:orgName" mode="listTitle"/>
            <table>
                <xsl:apply-templates select="tei:*[not(self::tei:orgName)]" mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:org/tei:place" mode="tabelle">
        <tr>
            <th>Ort</th>
            <td>
                <xsl:apply-templates select="tei:placeName" mode="tabelle"/>
            </td>
        </tr>
        <tr>
            <th/>
            <td>
                <xsl:apply-templates select="tei:location" mode="tabelle"/>
            </td>
        </tr>
    </xsl:template>
    <!-- LISTPERS -->
    <xsl:template match="tei:listPerson">
        <ul>
            <xsl:apply-templates mode="listPerson"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:person" mode="listPerson">
        <li>
            <xsl:apply-templates select="tei:persName" mode="listTitle"/>
            <table>
                <xsl:choose>
                    <xsl:when test="tei:birth and tei:death">
                        <tr>
                            <xsl:choose>
                                <xsl:when test="tei:birth = tei:death">
                                    <th>Vorkommen</th>
                                    <td>
                                        <xsl:value-of select="tei:birth"/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <th>Lebensdaten</th>
                                    <td>
                                        <xsl:value-of select="concat(tei:birth, '–', tei:death)"/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </tr>
                    </xsl:when>
                    <xsl:when test="tei:birth">
                        <tr>
                            <th>Geburt</th>
                            <td>
                                <xsl:value-of select="tei:birth"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:when test="tei:death">
                        <tr>
                            <th>Tod</th>
                            <td>
                                <xsl:value-of select="tei:death"/>
                            </td>
                        </tr>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates
                    select="tei:*[not(self::tei:persName or self::tei:birth or self::tei:death)]"
                    mode="tabelle"/>
            </table>
        </li>
    </xsl:template>
    <xsl:template match="tei:occupation" mode="tabelle">
        <tr>
            <th>Beruf</th>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>
    <!-- LISTWORK -->
    <xsl:template match="tei:listBibl">
        <ul>
            <xsl:apply-templates mode="list"/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:bibl" mode="list">
        <li>
            <xsl:apply-templates select="tei:title" mode="listTitle"/>
        </li>
        <table>
            <xsl:apply-templates select="tei:*[not(self::tei:title)]" mode="tabelle"/>
        </table>
    </xsl:template>
    <xsl:template match="tei:author" mode="tabelle">
        <tr>
            <th>Von</th>
            <td>
                <xsl:value-of select="." separator=", "/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:profileDesc">
        <xsl:if test="descendant::tei:correspDesc[10]">
            <xsl:apply-templates select="tei:correspDesc"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:correspDesc">
        <li style="margin: 2em 0;">
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="@ref"/>
                </xsl:attribute>
                <xsl:value-of select="@ref"/>
            </xsl:element>
            <br/>
            <xsl:for-each select="tei:correspAction">
                <table>
                    <tr>
                        <th style="padding-left: 0;">
                            <xsl:choose>
                                <xsl:when test="@type = 'sent'">
                                    <xsl:text>Sendung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'received'">
                                    <xsl:text>Empfang</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'forwarded'">
                                    <xsl:text>Weiterleitung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'redirected'">
                                    <xsl:text>Umleitung</xsl:text>
                                </xsl:when>
                                <xsl:when test="@type = 'transmitted'">
                                    <xsl:text>Aufgabe</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </th>
                    </tr>
                    <xsl:apply-templates select="tei:date | tei:persName | tei:placeName"
                        mode="cmif"/>
                </table>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:date">
        <tr>
            <td>Datum:</td>
            <td>
                <xsl:value-of select="normalize-space(.)"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:persName">
        <tr>
            <td>Akteur:</td>
            <td>
                <xsl:choose>
                    <xsl:when test="@ref">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <xsl:template mode="cmif" match="tei:placeName">
        <tr>
            <td>Ort:</td>
            <td>
                <xsl:choose>
                    <xsl:when test="@ref">
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    <!-- TABELLENZEILEN -->
    <xsl:template match="tei:desc" mode="tabelle">
        <xsl:apply-templates select="tei:*" mode="tabelle"/>
    </xsl:template>
    <xsl:template match="tei:gloss" mode="tabelle">
        <th>Typ</th>
        <td>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>
    <xsl:template match="tei:date" mode="tabelle">
        <xsl:variable name="datum-von">
            <xsl:choose>
                <xsl:when test="contains(@from-custom, '|')">
                    <xsl:value-of select="substring-before(@from-custom, '|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@from-custom"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="datum-bis">
            <xsl:choose>
                <xsl:when test="contains(@to-custom, '|')">
                    <xsl:value-of select="substring-before(@to-custom, '|')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@to-custom"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <xsl:choose>
                <xsl:when test="(@from-custom and @to-custom) and not(@from-custom = @to-custom)">
                    <th>Zeit</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                        <xsl:text>–</xsl:text>
                        <xsl:value-of select="$datum-bis"/>
                    </td>
                </xsl:when>
                <xsl:when test="(@from-custom and not(@to-custom)) or (@from-custom = @to-custom)">
                    <th>Datum</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                    </td>
                </xsl:when>
                <xsl:when test="@to-custom and not(@from-custom)">
                    <th>Bis</th>
                    <td>
                        <xsl:value-of select="$datum-von"/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:location" mode="tabelle">
        <xsl:variable name="lat" select="tokenize(tei:geo, ' ')[1]"/>
        <xsl:variable name="long" select="tokenize(tei:geo, ' ')[2]"/>
        <tr>
            <th>Länge/Breite</th>
            <td>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://www.openstreetmap.org/?mlat=', $lat, '&amp;mlon=', $long)"
                        />
                    </xsl:attribute>
                    <xsl:value-of select="concat($lat, '/', $long)"/>
                </xsl:element>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="tei:code">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>

    <xsl:template match="tei:figure">
        <xsl:element name="figure">
            <xsl:attribute name="class">
                <xsl:text>d-flex align-items-center</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tei:graphic[@url]">
        <xsl:choose>
            <xsl:when test="ancestor::tei:TEI/@xml:id = 'Kooperationen'">
                <img src="{@url}" class="mx-auto" style="width: 400px"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="modalName" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="string-length(tokenize(@url, '/')[last()]) = 0">
                            <xsl:value-of
                                select="substring-before(tokenize(@url, '/')[last() - 1], '.')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="substring-before(tokenize(@url, '/')[last()], '.')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <img src="{@url}" class="img-fluid clickable-image" data-bs-toggle="modal"
                    data-bs-target="#{$modalName}" style="width: 100%; max-width=100% "/>
                <div class="modal fade" id="{$modalName}" tabindex="-1"
                    aria-labelledby="imageModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content">
                            <div class="modal-body">
                                <img src="{@url}" class="img-fluid" alt="Full Screen Image"/>
                            </div>
                        </div>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>
