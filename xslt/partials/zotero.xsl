<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math tei"
    version="3.0">
    <xsl:template name="zoterMetaTags">
        <xsl:param name="zoteroTitle" select="false()"></xsl:param>
        <xsl:param name="pageId" select="''"></xsl:param>
        <xsl:param name="customUrl" select="$base_url"></xsl:param>
        <xsl:variable name="fullUrl" select="concat($customUrl, '/', $pageId)"/>
        <xsl:if test="$zoteroTitle">
            <meta name="citation_title" content="{$zoteroTitle}"/>
        </xsl:if>
        <!--<xsl:for-each select="//tei:titleStmt/tei:author">
            <meta name="citation_author" content="{normalize-space(.)}"/>
        </xsl:for-each>-->
        
        <meta name="citation_editor" content="Martin Anton Müller"/>
        <meta name="citation_editor" content="Gerd-Hermann Susen"/>
        <meta name="citation_editor" content="Laura Untner"/>
        <meta name="citation_editor" content="Selma Jahnke"/>
        <meta name="citation_publisher" content="Austrian Centre for Digital Humanities (ACDH)"/>
        <meta name="citation_book_title" content="{$project_title}"/>
        <meta name="citation_public_url" content="{$fullUrl}"/>
        <!-- Extract publication date from TEI header -->
        <xsl:variable name="pubDate" select="//tei:publicationStmt/tei:date/@when"/>
        <meta name="citation_date" content="{if ($pubDate) then $pubDate else '2023'}"/>
    </xsl:template>
</xsl:stylesheet>