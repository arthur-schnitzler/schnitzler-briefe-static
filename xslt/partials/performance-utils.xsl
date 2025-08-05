<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">
    
    <!-- Performance-optimized utility templates -->
    
    <!-- Cached entity lookups -->
    <xsl:key name="person-by-id" match="tei:person" use="@xml:id"/>
    <xsl:key name="place-by-id" match="tei:place" use="@xml:id"/>
    <xsl:key name="org-by-id" match="tei:org" use="@xml:id"/>
    <xsl:key name="work-by-id" match="tei:bibl" use="@xml:id"/>
    
    <!-- Performance-optimized entity resolution -->
    <xsl:template name="resolve-entity-fast">
        <xsl:param name="ref" as="xs:string"/>
        <xsl:param name="type" as="xs:string"/>
        
        <xsl:variable name="id" select="replace($ref, '#', '')"/>
        
        <xsl:choose>
            <xsl:when test="$type = 'person'">
                <xsl:variable name="entity" select="key('person-by-id', $id)"/>
                <xsl:if test="$entity">
                    <xsl:value-of select="concat($entity/tei:persName/tei:forename, ' ', $entity/tei:persName/tei:surname)"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$type = 'place'">
                <xsl:variable name="entity" select="key('place-by-id', $id)"/>
                <xsl:if test="$entity">
                    <xsl:value-of select="$entity/tei:placeName[1]"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$type = 'org'">
                <xsl:variable name="entity" select="key('org-by-id', $id)"/>
                <xsl:if test="$entity">
                    <xsl:value-of select="$entity/tei:orgName[1]"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$type = 'work'">
                <xsl:variable name="entity" select="key('work-by-id', $id)"/>
                <xsl:if test="$entity">
                    <xsl:value-of select="$entity/tei:title[1]"/>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Optimized date formatting -->
    <xsl:template name="format-date-efficient">
        <xsl:param name="date" as="xs:string"/>
        <xsl:param name="format" as="xs:string" select="'[D1]. [MNn] [Y]'"/>
        
        <xsl:choose>
            <xsl:when test="matches($date, '^\d{4}-\d{2}-\d{2}$')">
                <xsl:value-of select="format-date(xs:date($date), $format, 'de', (), ())"/>
            </xsl:when>
            <xsl:when test="matches($date, '^\d{4}-\d{2}$')">
                <xsl:value-of select="format-date(xs:date(concat($date, '-01')), '[MNn] [Y]', 'de', (), ())"/>
            </xsl:when>
            <xsl:when test="matches($date, '^\d{4}$')">
                <xsl:value-of select="$date"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$date"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Lazy loading image template -->
    <xsl:template name="lazy-image">
        <xsl:param name="src" as="xs:string"/>
        <xsl:param name="alt" as="xs:string"/>
        <xsl:param name="class" as="xs:string" select="''"/>
        <xsl:param name="loading" as="xs:string" select="'lazy'"/>
        
        <img>
            <xsl:attribute name="data-src" select="$src"/>
            <xsl:attribute name="src">data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1 1'%3E%3C/svg%3E</xsl:attribute>
            <xsl:attribute name="alt" select="$alt"/>
            <xsl:attribute name="loading" select="$loading"/>
            <xsl:if test="$class != ''">
                <xsl:attribute name="class" select="$class"/>
            </xsl:if>
            <xsl:attribute name="onload">this.onload=null;this.src=this.dataset.src;</xsl:attribute>
        </img>
    </xsl:template>
    
    <!-- Critical CSS inlining -->
    <xsl:template name="critical-css">
        <style>
            /* Critical above-the-fold CSS */
            body{font-family:-apple-system,BlinkMacSystemFont,segoe ui,Roboto,helvetica neue,Arial,sans-serif;line-height:1.5;color:#212529}
            .navbar{background-color:#fff;border-bottom:1px solid #dee2e6}
            .container-fluid{padding-right:15px;padding-left:15px;margin-right:auto;margin-left:auto}
            .skip-link{position:absolute;top:-40px;left:6px;z-index:999999;padding:8px 16px;background:#000;color:#fff;text-decoration:none}
            .skip-link:focus{position:static;top:auto;left:auto}
            h1,h2,h3{margin-top:0;margin-bottom:.5rem;font-weight:500}
            .card{background-color:#fff;border:1px solid #dee2e6;border-radius:.25rem}
            .btn{display:inline-block;padding:.375rem .75rem;border:1px solid transparent;border-radius:.25rem;text-decoration:none}
            .visually-hidden{position:absolute!important;width:1px!important;height:1px!important;padding:0!important;margin:-1px!important;overflow:hidden!important;clip:rect(0,0,0,0)!important;white-space:nowrap!important;border:0!important}
        </style>
    </xsl:template>
    
    <!-- Resource hints for performance -->
    <xsl:template name="resource-hints">
        <!-- DNS prefetch for external resources -->
        <link rel="dns-prefetch" href="//cdnjs.cloudflare.com"/>
        <link rel="dns-prefetch" href="//cdn.jsdelivr.net"/>
        <link rel="dns-prefetch" href="//code.jquery.com"/>
        <link rel="dns-prefetch" href="//iiif.acdh-dev.oeaw.ac.at"/>
        
        <!-- Preconnect for critical resources -->
        <link rel="preconnect" href="https://cdnjs.cloudflare.com" crossorigin=""/>
        <link rel="preconnect" href="https://iiif.acdh-dev.oeaw.ac.at" crossorigin=""/>
        
        <!-- Preload critical CSS -->
        <link rel="preload" href="/css/style.css" as="style"/>
        <link rel="preload" href="/js/accessibility-enhancements.js" as="script"/>
    </xsl:template>
    
    <!-- Generate Table of Contents -->
    <xsl:template name="generate-toc">
        <xsl:param name="content" as="node()*"/>
        
        <nav class="table-of-contents" aria-labelledby="toc-heading">
            <h2 id="toc-heading" class="visually-hidden">Inhaltsverzeichnis</h2>
            <ol>
                <xsl:for-each select="$content//h2[@id] | $content//h3[@id] | $content//h4[@id]">
                    <li>
                        <a href="#{@id}">
                            <xsl:value-of select="text()"/>
                        </a>
                        <xsl:if test="local-name() = 'h2' and following-sibling::h3[@id]">
                            <ol>
                                <xsl:for-each select="following-sibling::h3[@id][preceding-sibling::h2[1] = current()]">
                                    <li>
                                        <a href="#{@id}">
                                            <xsl:value-of select="text()"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ol>
                        </xsl:if>
                    </li>
                </xsl:for-each>
            </ol>
        </nav>
    </xsl:template>
    
    <!-- Memory-efficient entity processing -->
    <xsl:template name="process-entities-batch">
        <xsl:param name="entities" as="node()*"/>
        <xsl:param name="batch-size" as="xs:integer" select="50"/>
        
        <xsl:for-each-group select="$entities" group-by="ceiling(position() div $batch-size)">
            <div class="entity-batch" data-batch="{current-grouping-key()}">
                <xsl:for-each select="current-group()">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </div>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>