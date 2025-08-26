<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="no" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_head.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@level='a'][1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="concat($doc_title, ' TEI/XML Version')"></xsl:with-param>
                </xsl:call-template>
                <link rel="stylesheet" id="fundament-styles"  href="../dist/fundament/css/fundament.min.css" type="text/css"></link>
                <link rel="stylesheet" href="../css/style.css" type="text/css"></link>
                <style>
                    .xml-view {
                        font-family: 'Courier New', monospace;
                        font-size: 14px;
                        line-height: 1.4;
                        background-color: #f8f9fa;
                        padding: 20px;
                        white-space: pre-wrap;
                        word-wrap: break-word;
                    }
                    .xml-element {
                        color: #0066cc;
                    }
                    .xml-attribute-name {
                        color: #cc0000;
                    }
                    .xml-attribute-value {
                        color: #009900;
                    }
                    .xml-text {
                        color: #000000;
                    }
                    .xml-comment {
                        color: #999999;
                        font-style: italic;
                    }
                </style>
            </head>
            <body>
                <div class="xml-view">
                    <div class="xml-content">
                        <div class="linescroll">
                            <div class="card xml-prev">
                                <div class="card-body xml-viewarea" style="top: 0px; min-width: 100px;">
                                    <xsl:apply-templates select="//tei:TEI" mode="xml-display"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Main template for XML display -->
    <xsl:template match="*" mode="xml-display">
        <xsl:variable name="element-name" select="local-name()"/>
        <xsl:variable name="namespace-prefix" select="if(namespace-uri() = 'http://www.tei-c.org/ns/1.0') then 'tei:' else ''"/>
        
        <!-- Check if this element should be on a new line -->
        <xsl:if test="preceding-sibling::*[1] and not(preceding-sibling::text()[normalize-space(.) != ''][1])">
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        
        <!-- Opening tag -->
        <span class="xml-element">&lt;<xsl:value-of select="concat($namespace-prefix, $element-name)"/>
        
        <!-- Attributes -->
        <xsl:for-each select="@*">
            <xsl:text>&#10;  </xsl:text>
            <span class="xml-attribute-name"><xsl:value-of select="local-name()"/></span>
            <xsl:text>=</xsl:text>
            <span class="xml-attribute-value">"<xsl:value-of select="."/>"</span>
        </xsl:for-each>
        
        <xsl:choose>
            <xsl:when test="node()">
                <xsl:text>&gt;</xsl:text></span>
                
                <!-- Process child nodes -->
                <xsl:for-each select="node()">
                    <xsl:choose>
                        <xsl:when test="self::*">
                            <xsl:apply-templates select="." mode="xml-display"/>
                        </xsl:when>
                        <xsl:when test="self::text()">
                            <xsl:if test="normalize-space(.) != ''">
                                <span class="xml-text"><xsl:value-of select="."/></span>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="self::comment()">
                            <span class="xml-comment">&lt;!--<xsl:value-of select="."/>--&gt;</span>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                
                <!-- Closing tag -->
                <xsl:if test="*[last()] and not(text()[normalize-space(.) != ''][position() = last()])">
                    <xsl:text>&#10;</xsl:text>
                </xsl:if>
                <span class="xml-element">&lt;/<xsl:value-of select="concat($namespace-prefix, $element-name)"/>&gt;</span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>/&gt;</xsl:text></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template for text nodes to preserve meaningful whitespace -->
    <xsl:template match="text()" mode="xml-display">
        <xsl:choose>
            <xsl:when test="normalize-space(.) = ''">
                <!-- Skip whitespace-only text nodes between elements -->
            </xsl:when>
            <xsl:otherwise>
                <span class="xml-text"><xsl:value-of select="."/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template for comments -->
    <xsl:template match="comment()" mode="xml-display">
        <span class="xml-comment">&lt;!--<xsl:value-of select="."/>--&gt;</span>
    </xsl:template>

</xsl:stylesheet>