<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" exclude-result-prefixes="xs" version="2.0">
    <!-- this creates the notes[@type='commentary']. included is a feature that takes the text between anchor and note as input and creates a lemma. if the
  text is too long it abbreviates it-->
    <!-- Kommentar und Textkonstitution -->
    <xsl:template
        match="tei:note[(@type = 'textConst' or @type = 'commentary') and not(ancestor::tei:note[@type = 'footnote'])]"/>
    <xsl:template
        match="tei:note[(@type = 'textConst' or @type = 'commentary') and not(ancestor::tei:note[@type = 'footnote'])]"
        mode="kommentaranhang">
        <p>
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <!-- Der Teil hier bildet das Lemma und kürzt es -->
            <xsl:variable name="lemma-start" as="xs:string"
                select="substring(@xml:id, 1, string-length(@xml:id) - 1)"/>
            <xsl:variable name="lemma-end" as="xs:string" select="@xml:id"/>
            <xsl:variable name="lemmaganz">
                <xsl:for-each-group
                    select="ancestor::tei:*/tei:anchor[@xml:id = $lemma-start]/following-sibling::node()"
                    group-ending-with="tei:note[@xml:id = $lemma-end]">
                    <xsl:if test="position() eq 1">
                        <xsl:apply-templates select="current-group()[position() != last()]"
                            mode="lemma"/>
                    </xsl:if>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="lemma" as="xs:string">
                <xsl:choose>
                    <xsl:when test="not(contains($lemmaganz, ' '))">
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space($lemmaganz)) &gt; 24">
                        <xsl:variable name="lemma-kurz"
                            select="concat(tokenize(normalize-space($lemmaganz), ' ')[1], ' … ', tokenize(normalize-space($lemmaganz), ' ')[last()])"/>
                        <xsl:choose>
                            <xsl:when
                                test="string-length(normalize-space($lemmaganz)) - string-length($lemma-kurz) &lt; 5">
                                <xsl:value-of select="normalize-space($lemmaganz)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$lemma-kurz"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$lemmaganz"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <span class="lemma">
                <xsl:choose>
                    <xsl:when test="string-length($lemma) &gt; 0">
                        <xsl:value-of select="$lemma"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>XXXX Lemmafehler</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>]&#160;</xsl:text>
            </span>
            <span class="kommentar-text">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:apply-templates select="node() except Lemma"/>
            </span>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:subst/tei:del" mode="lemma"/><!-- das verhindert die Wiedergabe des gelöschten Teils von subst in einem Lemma -->
    <xsl:template match="tei:c[@rendition = '#prozent']" mode="lemma">
        <xsl:text>%</xsl:text>
    </xsl:template>
    <xsl:template match="tei:l" mode="lemma">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#dots']" mode="lemma">
        <xsl:value-of select="mam:dots(@n)"/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#langesS']" mode="lemma">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#kaufmannsund']" mode="lemma">
        <xsl:text>&amp;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#tilde']" mode="lemma">~</xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-auf']" mode="lemma">
        <xsl:text>{</xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#geschwungene-klammer-zu']" mode="lemma">
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:space[@unit = 'chars' and @quantity = '1']" mode="lemma">
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-m']" mode="lemma">
        <span class="gemination">mm</span>
    </xsl:template>
    <xsl:template match="tei:c[@rendition = '#gemination-n']" mode="lemma">
        <span class="gemination">nn</span>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'subscript']" mode="lemma">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'superscript']" mode="lemma">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:function name="mam:dots">
        <xsl:param name="anzahl"/> . <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
</xsl:stylesheet>
