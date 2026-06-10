<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl tei xs" version="3.0">
    <!-- The template "add_header-navigation-custom-title" creates a custom header without
                using tei:title but includes prev and next urls. -->
    <xsl:template name="header-nav">
        <div class="row" id="title-nav">
            <div class="col-12">
                <h1 itemprop="headline name">
                    <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']"/>
                </h1>
            </div>
        </div>
    </xsl:template>
    <!-- Blätterfunktion (vorheriger/nächster Brief), rechtsbündig im roten Action-Balken -->
    <xsl:template name="header-nav-arrows">
        <xsl:variable name="correspContext" as="node()?"
            select="descendant::tei:correspDesc[1]/tei:correspContext"/>
        <span class="neighbors">
            <xsl:if test="$correspContext/tei:ref/@subtype = 'previous_letter'">
                <span class="dropdown" aria-label="Vorheriger Brief">
                    <button type="button" id="navbarDropdownLeft" data-bs-toggle="dropdown"
                        aria-expanded="false" title="Vorheriger Brief">
                        <i class="fas fa-chevron-left"/>
                    </button>
                    <ul class="dropdown-menu unstyled" aria-labelledby="navbarDropdownLeft">
                            <xsl:if
                                test="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]">
                                <span class="dropdown-item-text">Vorheriger Brief </span>
                                <xsl:for-each
                                    select="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter']">
                                    <xsl:call-template name="mam:nav-li-item">
                                        <xsl:with-param name="eintrag" select="."/>
                                        <xsl:with-param name="direction" select="'prev-doc'"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when
                                    test="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter'][1]">
                                    <xsl:variable name="corrPmb"
                                        select="substring-after($correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/@target, 'correspondence_')"/>
                                    <xsl:variable name="corrNameRaw"
                                        select="$correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/text()"/>
                                    <xsl:variable name="corrName">
                                        <xsl:choose>
                                            <xsl:when test="contains($corrNameRaw, ', ')">
                                                <xsl:value-of select="concat(substring-after($corrNameRaw, ', '), ' ', substring-before($corrNameRaw, ', '))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$corrNameRaw"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <a class="dropdown-item" href="toc_{$corrPmb}.html"
                                        style="background-color: #1C6E8C; color: white; padding: 2px 5px; margin: 3px 0; border-radius: 2px; text-align: center; display: block; text-decoration: none; font-size: 9px;">
                                        <xsl:text>Korrespondenz </xsl:text>
                                        <xsl:value-of select="$corrName"/>
                                    </a>
                                    <xsl:for-each
                                        select="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                            <xsl:with-param name="direction" select="'prev-doc2'"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="corrPmb"
                                        select="substring-after($correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/@target, 'correspondence_')"/>
                                    <xsl:variable name="corrNameRaw"
                                        select="$correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/text()"/>
                                    <xsl:variable name="corrName">
                                        <xsl:choose>
                                            <xsl:when test="contains($corrNameRaw, ', ')">
                                                <xsl:value-of select="concat(substring-after($corrNameRaw, ', '), ' ', substring-before($corrNameRaw, ', '))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$corrNameRaw"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <a class="dropdown-item" href="toc_{$corrPmb}.html"
                                        style="background-color: #1C6E8C; color: white; padding: 2px 5px; margin: 3px 0; border-radius: 2px; text-align: center; display: block; text-decoration: none; font-size: 9px;">
                                        <xsl:text>Korrespondenz </xsl:text>
                                        <xsl:value-of select="$corrName"/>
                                    </a>
                                    <span class="dropdown-item-text">keine früheren Überlieferungen</span>
                                </xsl:otherwise>
                            </xsl:choose>
                    </ul>
                </span>
            </xsl:if>
            <xsl:if test="$correspContext/tei:ref/@subtype = 'next_letter'">
                <span class="dropdown" aria-label="Nächster Brief">
                    <button type="button" id="navbarDropdownRight" data-bs-toggle="dropdown"
                        aria-expanded="false" title="Nächster Brief">
                        <i class="fas fa-chevron-right"/>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdownRight">
                            <xsl:if
                                test="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]">
                                <span class="dropdown-item-text">Nächster Brief </span>
                                <xsl:for-each
                                    select="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter']">
                                    <xsl:call-template name="mam:nav-li-item">
                                        <xsl:with-param name="eintrag" select="."/>
                                        <xsl:with-param name="direction" select="'next-doc'"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when
                                    test="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter'][1]">
                                    <xsl:variable name="corrPmb"
                                        select="substring-after($correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/@target, 'correspondence_')"/>
                                    <xsl:variable name="corrNameRaw"
                                        select="$correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/text()"/>
                                    <xsl:variable name="corrName">
                                        <xsl:choose>
                                            <xsl:when test="contains($corrNameRaw, ', ')">
                                                <xsl:value-of select="concat(substring-after($corrNameRaw, ', '), ' ', substring-before($corrNameRaw, ', '))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$corrNameRaw"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <a class="dropdown-item" href="toc_{$corrPmb}.html"
                                        style="background-color: #1C6E8C; color: white; padding: 2px 5px; margin: 3px 0; border-radius: 2px; text-align: center; display: block; text-decoration: none; font-size: 9px;">
                                        <xsl:text>Korrespondenz </xsl:text>
                                        <xsl:value-of select="$corrName"/>
                                    </a>
                                    <xsl:for-each
                                        select="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                            <xsl:with-param name="direction" select="'next-doc2'"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="corrPmb"
                                        select="substring-after($correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/@target, 'correspondence_')"/>
                                    <xsl:variable name="corrNameRaw"
                                        select="$correspContext/tei:ref[@type = 'belongsToCorrespondence'][1]/text()"/>
                                    <xsl:variable name="corrName">
                                        <xsl:choose>
                                            <xsl:when test="contains($corrNameRaw, ', ')">
                                                <xsl:value-of select="concat(substring-after($corrNameRaw, ', '), ' ', substring-before($corrNameRaw, ', '))"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$corrNameRaw"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <a class="dropdown-item" href="toc_{$corrPmb}.html"
                                        style="background-color: #1C6E8C; color: white; padding: 2px 5px; margin: 3px 0; border-radius: 2px; text-align: center; display: block; text-decoration: none; font-size: 9px;">
                                        <xsl:text>Korrespondenz </xsl:text>
                                        <xsl:value-of select="$corrName"/>
                                    </a>
                                    <span class="dropdown-item-text">keine späteren Überlieferungen</span>
                                </xsl:otherwise>
                            </xsl:choose>
                    </ul>
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    <xsl:template name="mam:nav-li-item">
        <xsl:param name="eintrag" as="node()"/>
        <xsl:param name="direction"/>
        <xsl:element name="li">
            <xsl:element name="a">
                <xsl:attribute name="id">
                    <xsl:value-of select="$direction"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>dropdown-item theme-color</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="replace(concat($eintrag/@target, '.html'), '//', '/')"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="contains($eintrag/@subtype, 'next')">
                        <span>›</span>&#160; </xsl:when>
                    <xsl:when test="contains($eintrag/@subtype, 'previous')">
                        <span>‹</span>&#160; </xsl:when>
                </xsl:choose>
                <xsl:value-of select="$eintrag"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
