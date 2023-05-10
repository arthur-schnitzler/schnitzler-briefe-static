<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" exclude-result-prefixes="xs" version="2.0">
    <xsl:template
        match="tei:ref[not(@type = 'schnitzler-tagebuch') and not(@type = 'schnitzler-briefe') and not(@type = 'schnitzler-bahr') and not(@type = 'schnitzler-lektueren')]">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href"> show.html?ref=<xsl:value-of
                            select="tokenize(./@target, '/')[4]"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzler-tagebuch']">
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                        />
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@target = ''">
                            <xsl:text>FEHLER</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-date(@target, '[D].&#160;[M].&#160;[Y]')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'See'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'Cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://schnitzler-tagebuch.acdh.oeaw.ac.at/entry__', @target, '.html')"
                        />
                    </xsl:attribute>
                    <xsl:text>A. S.: Tagebuch, </xsl:text>
                    <xsl:value-of select="format-date(@target, '[D].&#160;[M].&#160;[Y]')"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="tei:ref[@type = 'schnitzler-briefe' or @type = 'schnitzler-bahr' or @type = 'schnitzler-lektueren']">
        <xsl:variable name="type-url" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'schnitzler-briefe'">
                    <xsl:text>https://arthur-schnitzler.github.io/schnitzler-briefe-static/</xsl:text>
                    <!-- später einfach leer lassen -->
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-bahr'">
                    <xsl:text>https://schnitzler-bahr.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-lektueren'">
                    <xsl:text>https://schnitzler-lektueren.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref-mit-endung" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains(@target, '.xml')">
                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ref-mit-endung"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@type = 'schnitzler-briefe'">
                            <xsl:value-of
                                select="document(concat($type-url, replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:correspAction[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                        <xsl:when test="@type = 'schnitzler-bahr'">
                            <xsl:value-of
                                select="document(concat($type-url, replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:dateSender[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@subtype = 'See'">
                        <xsl:text>Siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'Cf'">
                        <xsl:text>Vgl. </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'see'">
                        <xsl:text>siehe </xsl:text>
                    </xsl:when>
                    <xsl:when test="@subtype = 'cf'">
                        <xsl:text>vgl. </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <a>
                    <xsl:attribute name="class">reference-black</xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ref-mit-endung"/>
                    </xsl:attribute>
                    <xsl:variable name="dateiname-xml"
                        select="concat('https://arthur-schnitzler.github.io/schnitzler-briefe-static/', replace($ref-mit-endung, '.html', '.xml'))" as="xs:string"/>
                   <xsl:choose>
                       <xsl:when test="file:exists($dateiname-xml)">
                           <xsl:value-of
                               select="document($dateiname-xml)/descendant::tei:titleStmt[1]/tei:title[@level = 'a'][1]/text()"
                           />
                       </xsl:when>
                       <xsl:otherwise>
                           <xsl:value-of select="$dateiname-xml"/>
                       </xsl:otherwise>
                   </xsl:choose>
                    
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
