<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl tei xs" version="3.0">
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget add_header-navigation-custom-title.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied in html:body.</p>
            <p>The template "add_header-navigation-custom-title" creates a custom header without
                using tei:title but includes prev and next urls.</p>
        </desc>
    </doc>
    <xsl:template name="header-nav">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleSmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="prev">
            <xsl:value-of
                select="concat(descendant::tei:correspDesc[1]/tei:correspContext[1]/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]/@target, '.html')"
            />
        </xsl:variable>
        <xsl:variable name="next">
            <xsl:value-of
                select="concat(descendant::tei:correspDesc[1]/tei:correspContext[1]/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]/@target, '.html')"
            />
        </xsl:variable>
        <div class="row" id="title-nav">
            <div class="col-md-2 col-lg-2 col-sm-12">
                <xsl:if test="ends-with($prev, '.html')">
                    <h1>
                        <nav class="navbar navbar-previous-next">
                            <i class="fas fa-chevron-left nav-link" href="#"
                                id="navbarDropdown" role="button" data-bs-toggle="dropdown"
                                aria-expanded="false"/>
                            <!--<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                                    role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                </a>-->
                            <ul class="dropdown-menu unstyled" aria-labelledby="navbarDropdown">
                                <xsl:if
                                    test="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]">
                                    <span class="dropdown-item-text">In der Sammlung </span>
                                    <xsl:for-each
                                        select="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if
                                    test="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter'][1]">
                                    <span class="dropdown-item-text">In der Korrespondenz</span>
                                    <xsl:for-each
                                        select="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:if>
                            </ul>
                        </nav>
                    </h1>
                </xsl:if>
            </div>
            <div class="col-md-8">
                <h1 align="center">
                    <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']"/>
                </h1>
            </div>
            <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                <xsl:if test="ends-with($next, '.html')">
                    <h1>
                        <nav class="navbar navbar-previous-next">
                            <span style="position: absolute;
                                left: 80%;"><i class="fas fa-chevron-right nav-link" href="#"
                                id="navbarDropdown" role="button" data-bs-toggle="dropdown"
                                aria-expanded="false"/></span>
                            <!--<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                                    role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                </a>-->
                            <ul class="dropdown-menu unstyled" aria-labelledby="navbarDropdown">
                                <xsl:if
                                    test="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]">
                                    <span class="dropdown-item-text">In der Sammlung </span>
                                    <xsl:for-each
                                        select="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:if
                                    test="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter'][1]">
                                    <span class="dropdown-item-text">In der Korrespondenz</span>
                                    <xsl:for-each
                                        select="descendant::tei:correspDesc[1]/tei:correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter']">
                                        <xsl:call-template name="mam:nav-li-item">
                                            <xsl:with-param name="eintrag" select="."/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:if>
                            </ul>
                        </nav>
                    </h1>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="mam:nav-li-item">
        <xsl:param name="eintrag" as="node()"/>
        <xsl:element name="li">
            <xsl:element name="a">
                <xsl:attribute name="class">
                    <xsl:text>dropdown-item</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="target">
                    <xsl:value-of select="concat($eintrag/@target, '.html')"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="contains($eintrag/@subtype, 'next')">
                        <i class="fas fa-chevron-right"/>&#160; </xsl:when>
                    <xsl:when test="contains($eintrag/@subtype, 'previous')">
                        <i class="fas fa-chevron-left"/>&#160; </xsl:when>
                </xsl:choose>
                <xsl:value-of select="$eintrag"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
