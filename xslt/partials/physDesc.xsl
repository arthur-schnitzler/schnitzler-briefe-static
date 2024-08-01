<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="tei:incident/tei:desc/tei:stamp">
        
        <xsl:text>Stempel </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>:</xsl:text>
        <ul style="list-style-type: none; padding: 0; margin: 0;">
        <xsl:if test="tei:placeName">
            <li>Ort: 
                    <a class="theme-color">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat(replace(tei:placeName/@ref, '#', ''), '.html')"
                            />
                        </xsl:attribute>
                        <xsl:value-of select="tei:placeName"/>
                    </a>
            </li>
        </xsl:if>
            <xsl:if test="tei:date"><li>Datum: <xsl:apply-templates select="./tei:date"/>
            </li>
        </xsl:if>
            <xsl:if test="tei:time"><li>Zeit: <xsl:apply-templates select="./tei:time"/>
            </li>
        </xsl:if>
            <xsl:if test="tei:addSpan"><li>Vorgang: <xsl:apply-templates select="./tei:addSpan"/>
            </li>
        </xsl:if>
        </ul>
    </xsl:template>
    <xsl:template match="tei:incident">
        <tr>
            <xsl:apply-templates select="tei:desc"/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:additions">
        <xsl:apply-templates select="tei:incident[@type = 'supplement']"/>
        <xsl:apply-templates select="tei:incident[@type = 'postal']"/>
        <xsl:apply-templates select="tei:incident[@type = 'receiver']"/>
        <xsl:apply-templates select="tei:incident[@type = 'archival']"/>
        <xsl:apply-templates select="tei:incident[@type = 'additional-information']"/>
        <xsl:apply-templates select="tei:incident[@type = 'editorial']"/>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'supplement']/tei:desc">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'supplement'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'supplement'])">
                    <th>Beilage</th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'supplement']">
                    <th>Beilagen</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'postal']]">
        <xsl:variable name="poschitzion"
            select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'postal'])"/>
        <xsl:choose>
            <xsl:when test="$poschitzion &gt; 0">
                <tr>
                    <th/>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'postal'])">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
            <xsl:when
                test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'postal']">
                <tr>
                    <th>
                        <xsl:text>Versand</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </tr>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:incident[@type = 'receiver']/tei:desc">
        <tr>
            <xsl:variable name="receiver"
                select="substring-before(ancestor::tei:teiHeader//tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1], ',')"/>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'receiver'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'receiver']">
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <th>
                        <xsl:value-of select="$receiver"/>
                    </th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'archival']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'archival'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'archival'])">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'archival']">
                    <th>
                        <xsl:text>Ordnung</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'additional-information']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'additional-information'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information'])">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'additional-information']">
                    <th>
                        <xsl:text>Zusatz</xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:desc[parent::tei:incident[@type = 'editorial']]">
        <tr>
            <xsl:variable name="poschitzion"
                select="count(parent::tei:incident/preceding-sibling::tei:incident[@type = 'editorial'])"/>
            <xsl:choose>
                <xsl:when test="$poschitzion &gt; 0">
                    <td/>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and not(parent::tei:incident/following-sibling::tei:incident[@type = 'editorial'])">
                    <th>Editorischer Hinweis</th>
                    <td>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
                <xsl:when
                    test="$poschitzion = 0 and parent::tei:incident/following-sibling::tei:incident[@type = 'editorial']">
                    <th>Editorischer Hinweise</th>
                    <td>
                        <xsl:value-of select="$poschitzion + 1"/>
                        <xsl:text>) </xsl:text>
                        <xsl:value-of select="mam:incident-rend(parent::tei:incident/@rend)"/>
                        <xsl:apply-templates/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:typeDesc/tei:typeNote">
        <tr>
            <th>Herstellung</th>
            <xsl:choose>
                <xsl:when test="@medium = 'schreibmaschine'">
                    <td>Schreibmaschine</td>
                </xsl:when>
                <xsl:when test="@medium = 'maschinell'">
                    <td>maschinell</td>
                </xsl:when>
                <xsl:when test="@medium = 'druck'">
                    <td>Druck</td>
                </xsl:when>
                <xsl:when test="@medium = 'anderes'">
                    <td>
                        <xsl:apply-templates select="child::tei:p"/>
                    </td>
                </xsl:when>
            </xsl:choose>
        </tr>
    </xsl:template>
    <xsl:template match="tei:handDesc">
        <xsl:choose>
            <!-- Nur eine Handschrift, diese demnach vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and not(tei:handNote/@corresp)">
                <tr>
                    <th>Handschrift</th>
                    <td>
                        <xsl:value-of select="mam:handNote(tei:handNote)"/>
                    </td>
                </tr>
            </xsl:when>
            <!-- Nur eine Handschrift, diese nicht vom Autor/der Autorin: -->
            <xsl:when test="not(child::tei:handNote[2]) and (tei:handNote/@corresp)">
                <xsl:choose>
                    <xsl:when test="handNote/@corresp = 'schreibkraft'">
                        <tr>
                            <th>Handschrift einer Schreibkraft</th>
                            <td>
                                <xsl:value-of select="mam:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="sender"
                            select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']/tei:persName[@ref = tei:handNote/@corresp]"/>
                        <tr>
                            <th>Handschrift <xsl:value-of select="$sender"/>
                            </th>
                            <td>
                                <xsl:value-of select="mam:handNote(tei:handNote)"/>
                            </td>
                        </tr>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="handDesc-v" select="current()"/>
                <xsl:variable name="sender"
                    select="ancestor::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent']"
                    as="node()"/>
                <xsl:for-each select="distinct-values(tei:handNote/@corresp)">
                    <xsl:variable name="corespi" select="."/>
                    <xsl:variable name="corespi-name" select="$sender/tei:persName[@ref = $corespi]"/>
                    <xsl:choose>
                        <xsl:when test="count($handDesc-v/tei:handNote[@corresp = $corespi]) = 1">
                            <tr>
                                <th>Handschrift <xsl:value-of
                                        select="mam:vorname-vor-nachname($corespi-name)"/>
                                </th>
                                <td>
                                    <xsl:value-of
                                        select="mam:handNote($handDesc-v/tei:handNote[@corresp = $corespi])"
                                    />
                                </td>
                            </tr>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$handDesc-v/tei:handNote[@corresp = $corespi]">
                                <tr>
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <th>Handschrift <xsl:value-of
                                                  select="mam:vorname-vor-nachname($corespi-name)"/>
                                            </th>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <th/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <td>
                                        <xsl:variable name="poschitzon" select="position()"/>
                                        <xsl:value-of select="$poschitzon"/>
                                        <xsl:text>) </xsl:text>
                                        <xsl:value-of select="mam:handNote(current())"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="mam:handNote">
        <xsl:param name="entry" as="node()"/>
        <xsl:choose>
            <xsl:when test="$entry/@medium = 'bleistift'">
                <xsl:text>Bleistift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'roter-buntstift'">
                <xsl:text>roter Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blauer-buntstift'">
                <xsl:text>blauer Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruener-buntstift'">
                <xsl:text>grüner Buntstift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'schwarze-tinte'">
                <xsl:text>schwarze Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'lila-tinte'">
                <xsl:text>lila Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'blaue-tinte'">
                <xsl:text>blaue Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'gruene-tinte'">
                <xsl:text>grüne Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'rote-tinte'">
                <xsl:text>rote Tinte</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@medium = 'anderes'">
                <xsl:text>anderes Schreibmittel</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="not($entry/@style = 'nicht-anzuwenden')">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$entry/@style = 'deutsche-kurrent'">
                <xsl:text>deutsche Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'lateinische-kurrent'">
                <xsl:text>lateinische Kurrentschrift</xsl:text>
            </xsl:when>
            <xsl:when test="$entry/@style = 'gabelsberger'">
                <xsl:text>Gabelsberger Kurzschrift</xsl:text>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="string-length(normalize-space($entry/.)) &gt; 1">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="($entry/.)"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:function>
    <xsl:template match="tei:objectDesc">
        <xsl:if test="@form">
            <xsl:choose>
                <xsl:when test="@form = 'durchschlag'">
                    <xsl:text>Durchschlag</xsl:text>
                </xsl:when>
                <xsl:when test="@form = 'fotografische_vervielfaeltigung'">
                    <xsl:text>Fotografische Vervielfältigung</xsl:text>
                </xsl:when>
                <xsl:when test="@form = 'fotokopie'">
                    <xsl:text>Fotokopie</xsl:text>
                </xsl:when>
                <xsl:when test="@form = 'hs_abschrift'">
                    <xsl:text>Handschriftliche Abschrift</xsl:text>
                </xsl:when>
                <xsl:when test="@form = 'ms_abschrift'">
                    <xsl:text>Maschinenschriftliche Abschrift</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="child::tei:supportDesc"/>
    </xsl:template>
    <xsl:template match="tei:supportDesc">
        <xsl:apply-templates select="tei:extent"/>
        <xsl:if test="tei:support">
            <xsl:apply-templates select="tei:support"/>
        </xsl:if>
        <xsl:if test="tei:condition/@ana = 'fragment'">
            <xsl:text>, Fragment</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:extent">
        <xsl:variable name="unitOrder" select="'blatt seite karte kartenbrief widmung umschlag zeichenanzahl'"/>
        <xsl:variable name="measures" select="." as="node()"/>
        <xsl:for-each select="tokenize($unitOrder, ' ')">
            <xsl:variable name="current" select="."/>
            <xsl:for-each select="$measures/tei:measure[@unit=$current]">
                <xsl:apply-templates select="."/>
                <xsl:variable name="unitOrderRest" select="normalize-space(substring-after($unitOrder, $current))" as="xs:string?"/>
                <xsl:if test="exists($measures/tei:measure[@unit=tokenize($unitOrderRest, ' ')]) and $measures/tei:measure[not(@unit='karte' and @quantity='1') and not(@unit='widmung' and @quantity='1') and not(@unit='kartenbrief' and @quantity='1')][2]">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='seite']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'">
                <xsl:text>1&#160;Seite</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Seiten</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='blatt']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'">
                <xsl:text>1&#160;Blatt</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Blätter</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='umschlag']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'">
                <xsl:text>Umschlag</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Umschläge</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='widmung']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'"/>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Widmungen</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='kartenbrief']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'"/>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Kartenbriefe</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='karte']">
        <xsl:choose>
            <xsl:when test="@quantity = '1'"/>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
                <xsl:text>&#160;Karten</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:measure[@unit='zeichenanzahl']">
        <xsl:variable name="string" select="@quantity" as="xs:string"/>
        <xsl:variable name="laenge" select="string-length($string)" as="xs:integer"/>
        <xsl:variable name="rest" select="$laenge mod 3" />
        <xsl:choose>
            <xsl:when test="$laenge &gt; 3">
                <xsl:if test="$rest != 0">
                    <xsl:value-of select="substring($string, 1, $rest)"/>
                <xsl:text>.</xsl:text></xsl:if>
                <xsl:variable name="uebrig" select="substring($string, $rest + 1, $laenge)"/>
                <xsl:choose>
                    <xsl:when test="string-length($uebrig) = 6">
                        <xsl:value-of select="substring($uebrig, 1, 3)"/>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="substring($uebrig, 4)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$uebrig"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@quantity"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#160;Zeichen</xsl:text>
    </xsl:template>
    <xsl:template match="tei:support">
        <xsl:text> (</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:function name="mam:incident-rend">
        <xsl:param name="rend" as="xs:string?"/>
        <xsl:choose>
            <xsl:when test="$rend = 'bleistift'">
                <xsl:text>mit Bleistift </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'roter-buntstift'">
                <xsl:text>mit rotem Buntstift </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'blauer-buntstift'">
                <xsl:text>mit blauem Buntstift </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'gruener-buntstift'">
                <xsl:text>mit grünem Buntstift </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'schwarze-tinte'">
                <xsl:text>mit schwarzer Tinte </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'blaue-tinte'">
                <xsl:text>mit blauer Tinte </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'gruene-tinte'">
                <xsl:text>mit grüner Tinte </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'rote-tinte'">
                <xsl:text>mit roter Tinte </xsl:text>
            </xsl:when>
            <xsl:when test="$rend = 'lila-tinte'">
                <xsl:text>lila Tinte</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="mam:vorname-vor-nachname">
        <xsl:param name="autorname"/>
        <xsl:choose>
            <xsl:when test="contains($autorname, ', ')">
                <xsl:value-of select="substring-after($autorname, ', ')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring-before($autorname, ', ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$autorname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
