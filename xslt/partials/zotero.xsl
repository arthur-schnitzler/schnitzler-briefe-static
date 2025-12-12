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
            <meta name="DC.Title" content="{$zoteroTitle}"/>
        </xsl:if>
        <!-- Extract authors of the letter/chapter -->
        <xsl:for-each select="//tei:titleStmt/tei:author">
            <meta name="citation_author" content="{normalize-space(.)}"/>
            <meta name="DC.Creator" content="{normalize-space(.)}"/>
        </xsl:for-each>

        <!-- Editors of the book/collection -->
        <meta name="citation_editor" content="Müller, Martin Anton"/>
        <meta name="citation_editor" content="Susen, Gerd-Hermann"/>
        <meta name="citation_editor" content="Untner, Laura"/>
        <meta name="citation_editor" content="Jahnke, Selma"/>
        <meta name="DC.Contributor.Editor" content="Müller, Martin Anton"/>
        <meta name="DC.Contributor.Editor" content="Susen, Gerd-Hermann"/>
        <meta name="DC.Contributor.Editor" content="Untner, Laura"/>
        <meta name="DC.Contributor.Editor" content="Jahnke, Selma"/>
        <!--<meta name="citation_publisher" content="Austrian Centre for Digital Humanities (ACDH)"/>-->
        <meta name="citation_book_title" content="{$project_title}"/>
        <meta name="citation_inbook_title" content="{$project_title}"/>
        <meta name="citation_public_url" content="{$fullUrl}"/>
        <meta name="DC.Relation.IsPartOf" content="{$project_title}"/>
        <!-- Extract publication date from TEI header -->
        <meta name="citation_publication_date" content="{//tei:TEI/tei:teiHeader[1]/tei:fileDesc[1]/tei:publicationStmt[1]/tei:date[1]/@when}"/>
        <meta name="citation_fulltext_html_url" content="{$fullUrl}"/>
        <meta name="DC.Identifier" content="{$fullUrl}"/>
        <meta name="DC.Type" content="Text"/>
        <meta name="DC.Format" content="text/html"/>
        <meta name="DC.Language" content="de"/>

        <xsl:variable name="pubDate" select="//tei:publicationStmt/tei:date/@when"/>
        <meta name="citation_date" content="{format-date(current-date(), '[D]. [MNn] [Y0001]', 'de', (), ())}"/>
        <meta name="DC.Date" content="{if ($pubDate) then $pubDate else '2023'}"/>
    </xsl:template>
</xsl:stylesheet>