<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" exclude-result-prefixes="xs" version="3.0">

    <!-- Funktion für See/Cf-Präfixe -->
    <xsl:function name="local:seecf-prefix" as="xs:string">
        <xsl:param name="subtype" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="$subtype = 'See'">
                <xsl:text>Siehe </xsl:text>
            </xsl:when>
            <xsl:when test="$subtype = 'Cf'">
                <xsl:text>Vgl. </xsl:text>
            </xsl:when>
            <xsl:when test="$subtype = 'see'">
                <xsl:text>siehe </xsl:text>
            </xsl:when>
            <xsl:when test="$subtype = 'cf'">
                <xsl:text>vgl. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="tei:ref[@type = 'URL']">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:attribute name="target">
                <xsl:text>_blank</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="normalize-space(.) = ''">
                    <xsl:text>Link</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template
        match="tei:ref[not(@type = 'schnitzler-tagebuch') and not(@type = 'schnitzler-briefe') and not(@type = 'schnitzler-bahr') and not(@type = 'schnitzler-lektueren') and not(@type = 'schnitzler-interviews') and not(@type = 'URL') and not(@type = 'schnitzler-kultur') and not(@type = 'wienerschnitzler') and not(@type = 'schnitzler-zeitungen') and not(@type = 'schnitzler-mikrofilme')]">
        <xsl:choose>
            <xsl:when test="@target[ends-with(., '.xml')]">
                <xsl:element name="a">
                    <xsl:if test="@type != ''">
                        <xsl:attribute name="class">
                            <xsl:value-of select="@type"/>
                            <xsl:text> font-weight-bold</xsl:text>
                        </xsl:attribute>
                    </xsl:if>
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
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
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
                <xsl:value-of select="local:seecf-prefix(@subtype)"/>
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
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
    <xsl:template match="tei:ref[@type = 'wienerschnitzler']">
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://wienerschnitzler.org/tag.html#', @target)"/>
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
                <xsl:value-of select="local:seecf-prefix(@subtype)"/>
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of
                            select="concat('https://wienerschnitzler.org/tag.html#', @target)"/>
                    </xsl:attribute>
                    <xsl:text>Wiener Schnitzler – Schnitzlers Wien, </xsl:text>
                    <xsl:value-of select="format-date(@target, '[D].&#160;[M].&#160;[Y]')"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzler-zeitungen']">
        <xsl:value-of select="local:seecf-prefix(@subtype)"/>
        <a>
            <xsl:attribute name="class">
                <xsl:value-of select="@type"/>
                <xsl:text> font-weight-bold</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of
                    select="concat('https://schnitzler-zeitungen.acdh.oeaw.ac.at/', @target, '.html')"
                />
            </xsl:attribute>
            <xsl:text>Arthur Schnitzler: Archiv der Zeitungssausschitte, </xsl:text>
            <xsl:value-of select="@target"/>
        </a>
    </xsl:template>
    <xsl:template match="tei:ref[@type = 'schnitzler-mikrofilme']">
        <xsl:value-of select="local:seecf-prefix(@subtype)"/>
        <a>
            <xsl:attribute name="class">
                <xsl:value-of select="@type"/>
                <xsl:text> font-weight-bold</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of
                    select="concat('https://schnitzler-mikrofilme.acdh.oeaw.ac.at/', @target, '.html')"
                />
            </xsl:attribute>
            <xsl:text>Arthur Schnitzler: Mikrofilme, </xsl:text>
            <xsl:value-of select="@target"/>
        </a>
    </xsl:template>
    <xsl:template match="
            tei:ref[@type = 'schnitzler-briefe' or @type = 'schnitzler-bahr' or @type = 'schnitzler-lektueren' or @type = 'schnitzler-interviews' or @type = 'schnitzler-kultur'
            ]">
        <xsl:variable name="type-url" as="xs:string">
            <xsl:choose>
                <xsl:when test="@type = 'schnitzler-briefe'">
                    <xsl:text/>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-bahr'">
                    <xsl:text>https://schnitzler-bahr.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-lektueren'">
                    <xsl:text>https://schnitzler-lektueren.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-interviews'">
                    <xsl:text>https://schnitzler-interviews.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'schnitzler-kultur'">
                    <xsl:text>https://schnitzler-kultur.acdh.oeaw.ac.at/</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref-mit-endung" as="xs:string">
            <xsl:choose>
                <xsl:when test="contains(@target, '.xml')">
                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                </xsl:when>
                <xsl:when test="contains(@target, '.html')">
                    <xsl:value-of select="@target"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(@target, '.html')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@subtype = 'date-only'">
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($type-url, $ref-mit-endung)"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@type = 'schnitzler-briefe'">
                            <xsl:value-of
                                select="document(concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:correspDesc[1]/tei:correspAction[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                        <xsl:when test="@type = 'schnitzler-interviews'">
                            <xsl:value-of
                                select="document(concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-interviews-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:titleStmt[1]/tei:title[@type = 'iso-date'][1]/text()"
                            />
                        </xsl:when>
                        <xsl:when test="@type = 'schnitzler-bahr'">
                            <xsl:value-of
                                select="document(concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-bahr-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml')))/descendant::tei:dateSender[1]/tei:date[1]/text()"
                            />
                        </xsl:when>
                        <xsl:when test="@type = 'schnitzler-kultur'">
                            <xsl:value-of select="
                                    format-date(
                                    xs:date(document('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-kultur/refs/heads/main/data/editions/listevent.xml')/tei:TEI/tei:text[1]/tei:body[1]/tei:listEvent[1]/tei:event[@xml:id = replace($ref-mit-endung, '.html', '')]/@when-iso),
                                    '[D].&#160;[M].&#160;[Y]'
                                    )"/>
                        </xsl:when>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="local:seecf-prefix(@subtype)"/>
                <a>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                        <xsl:text> font-weight-bold</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($type-url, $ref-mit-endung)"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@type = 'schnitzler-kultur'">
                            <xsl:value-of
                                select="normalize-space(document('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-kultur/refs/heads/main/data/editions/listevent.xml')/tei:TEI/tei:text[1]/tei:body[1]/tei:listEvent[1]/tei:event[@xml:id = replace($ref-mit-endung, '.html', '')]/tei:eventName/text())"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="dateiname-xml" as="xs:string?">
                                <xsl:choose>
                                    <xsl:when test="@type = 'schnitzler-briefe'">
                                        <xsl:value-of
                                            select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                        />
                                    </xsl:when>
                                    <xsl:when test="@type = 'schnitzler-bahr'">
                                        <xsl:value-of
                                            select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-bahr-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                        />
                                    </xsl:when>
                                    <xsl:when test="@type = 'schnitzler-lektueren'">
                                        <xsl:value-of
                                            select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-lektueren/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                        />
                                    </xsl:when>
                                    <xsl:when test="@type = 'schnitzler-interviews'">
                                        <xsl:value-of
                                            select="concat('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-interviews-data/main/data/editions/', replace($ref-mit-endung, '.html', '.xml'))"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when
                                    test="$dateiname-xml != '' and doc-available($dateiname-xml)">
                                    <xsl:value-of
                                        select="document($dateiname-xml)/descendant::tei:titleStmt[1]/tei:title[@level = 'a'][1]/text()"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$ref-mit-endung"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
