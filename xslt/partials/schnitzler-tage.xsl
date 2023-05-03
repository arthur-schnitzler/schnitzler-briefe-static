<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./LOD-idnos.xsl"/>
    <xsl:template name="mam:schnitzler-tage">
        <xsl:param name="datum-iso" as="xs:date"/>
        <xsl:param name="teiSource" as="xs:string"/>
        <xsl:variable name="link">
            <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
        </xsl:variable>
        <xsl:variable name="fetchUrl"
            select="document(concat('https://schnitzler-tage.acdh.oeaw.ac.at/', $datum-iso, '.xml'))"
            as="node()"/>
        <xsl:variable name="doc_title">
            <xsl:value-of
                select="$fetchUrl/descendant::tei:titleStmt[1]/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="prev">
            <xsl:value-of select="concat($datum-iso - xs:dayTimeDuration('P1D'), '.html')"/>
        </xsl:variable>
        <xsl:variable name="next">
            <xsl:value-of select="concat($datum-iso + xs:dayTimeDuration('P1D'), '.html')"/>
        </xsl:variable>
        <div id="tag-fuer-tag-modal-body">
            <xsl:apply-templates select="$fetchUrl/descendant::tei:body//tei:listEvent"
                mode="schnitzler-tage"/>
            <div class="weiteres" style="margin-top:2.5em;">
                <h3>Weiteres</h3>
                <ul>
                    <li>
                        <xsl:text>Zeitungen vom </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('https://anno.onb.ac.at/cgi-content/anno?datum=', replace(string($datum-iso), '-', ''))"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of
                                select="$datum-iso"
                            />
                        </xsl:element>
                        <xsl:text> bei </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('https://anno.onb.ac.at/cgi-content/anno?datum=', replace(string($datum-iso), '-', ''))"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                            <xsl:text>ANNO</xsl:text>
                        </xsl:element>
                    </li>
                    <li>
                        <xsl:text>Briefe vom </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('https://correspsearch.net/de/suche.html?d=', $datum-iso, '&amp;x=1&amp;w=0')"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="$datum-iso"/>
                        </xsl:element>
                        <xsl:text> bei </xsl:text>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('https://correspsearch.net/de/suche.html?d=', $datum-iso, '&amp;x=1&amp;w=0')"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">
                                <xsl:text>_blank</xsl:text>
                            </xsl:attribute>
                            <xsl:text>correspSearch</xsl:text>
                        </xsl:element>
                    </li>
                </ul>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="tei:listEvent" mode="schnitzler-tage">
        <xsl:variable name="eventtype"
            select="'Arthur-Schnitzler-digital,schnitzler-tagebuch,schnitzler-briefe,pollaczek,schnitzler-bahr,schnitzler-orte,schnitzler-tage-manuell,pmb,schnitzler-cmif,kalliope-verbund'"/>
        <xsl:variable name="current-group" select="." as="node()"/>
        <xsl:for-each select="tokenize($eventtype, ',')">
            <xsl:variable name="e-type" as="xs:string" select="."/>
            <xsl:element name="div">
                <xsl:attribute name="class">
                    <xsl:value-of select="$e-type"/>
                </xsl:attribute>
                <xsl:if test="not(position() = 1)">
                    <xsl:attribute name="style">
                        <xsl:text>margin-top: 3.5em;</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$current-group/tei:event/tei:idno[@type = $e-type][1]">
                    <xsl:variable name="idnos-of-current" as="node()">
                        <xsl:element name="nodeset">
                            <xsl:copy-of
                                select="$current-group/tei:event/tei:idno[@type = $e-type][1]"/>
                        </xsl:element>
                    </xsl:variable>
                    <p>
                        <xsl:call-template name="mam:idnosToLinks">
                            <xsl:with-param name="idnos-of-current" select="$idnos-of-current"/>
                        </xsl:call-template>
                    </p>
                    <div style="margin-left: 10px">
                        <xsl:apply-templates
                            select="$current-group/tei:event[tei:idno/@type = $e-type]"/>
                    </div>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="tei:event[tei:idno/@type[not(contains($eventtype, .))]]">
            <xsl:apply-templates mode="desc"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:event">
        <h3>
            <xsl:choose>
                <xsl:when test="starts-with(tei:idno[1]/text(), 'http')">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="tei:idno[1]/text()"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">
                            <xsl:text>_blank</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="tei:head"/>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="starts-with(tei:idno[1]/text(), 'doi')">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('https://', tei:idno[1]/text())"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">
                            <xsl:text>_blank</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="tei:head"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="tei:head"/>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <p>
            <xsl:if test="not(normalize-space(tei:desc) = '')">
                <xsl:apply-templates select="tei:desc" mode="desc"/>
            </xsl:if>
        </p>
    </xsl:template>
    <xsl:template match="tei:event/tei:desc" mode="desc">
        <xsl:if
            test="child::tei:listPerson or child::tei:listBibl or child::tei:listPlace or child::tei:listOrg">
            <ul>
                <xsl:apply-templates
                    select="child::tei:listPerson | child::tei:listBibl | child::tei:listPlace | child::tei:listOrg"
                    mode="desc"/>
            </ul>
        </xsl:if>
        <xsl:if
            test="tei:*[not(self::tei:listPerson or self::tei:listBibl or self::tei:listPlace or self::tei:listOrg)]">
            <xsl:apply-templates
                select="tei:*[not(self::tei:listPerson or self::tei:listBibl or self::tei:listPlace or self::tei:listOrg)]"
                mode="desc"/>
        </xsl:if>
        <xsl:if test="text()[not(normalize-space(.) = '')]">
            <p>
                <xsl:value-of select="normalize-space(text()[not(normalize-space(.) = '')])"/>
            </p>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:listPerson" mode="desc">
        <xsl:variable name="type" select="ancestor::tei:event/tei:idno/@type"/>
        <xsl:variable name="type-farbe">
            <xsl:choose>
                <xsl:when test="key('only-relevant-uris', $type, $relevant-uris)/*:color != '#fff'">
                    <xsl:value-of select="key('only-relevant-uris', $type, $relevant-uris)/*:color"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>blue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <i>Erwähnte Personen: </i>
            <xsl:for-each select="tei:person/tei:persName">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(@ref, 'https://d-nb') or starts-with(@ref, 'http://d-nb') and $type = 'schnitzler-cmif'">
                        <xsl:variable name="normalize-gnd-ohne-http"
                            select="replace(@ref, 'https', 'http')" as="xs:string"/>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://correspsearch.net/de/suche.html?s=', $normalize-gnd-ohne-http)"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="starts-with(@ref, 'pmb') or starts-with(@ref, 'person_')">
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://', $type, '.acdh.oeaw.ac.at/', @ref, '.html')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template match="tei:listOrg" mode="desc">
        <xsl:variable name="type" select="ancestor::tei:event/tei:idno/@type"/>
        <xsl:variable name="type-farbe">
            <xsl:choose>
                <xsl:when test="key('only-relevant-uris', $type, $relevant-uris)/*:color != '#fff'">
                    <xsl:value-of select="key('only-relevant-uris', $type, $relevant-uris)/*:color"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>blue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <i>Erwähnte Institutionen: </i>
            <xsl:for-each select="tei:org/tei:orgName">
                <xsl:choose>
                    <xsl:when
                        test="starts-with(@ref, 'https://d-nb') or starts-with(@ref, 'http://d-nb') and $type = 'schnitzler-cmif'">
                        <xsl:variable name="normalize-gnd-ohne-http"
                            select="replace(@ref, 'https', 'http')" as="xs:string"/>
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://correspsearch.net/de/suche.html?s=', $normalize-gnd-ohne-http)"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="starts-with(@ref, 'pmb')">
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://', $type, '.acdh.oeaw.ac.at/', @ref, '.html')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template match="tei:listPlace" mode="desc">
        <xsl:variable name="type" select="ancestor::tei:event/tei:idno/@type"/>
        <xsl:variable name="type-farbe">
            <xsl:choose>
                <xsl:when test="key('only-relevant-uris', $type, $relevant-uris)/*:color != '#fff'">
                    <xsl:value-of select="key('only-relevant-uris', $type, $relevant-uris)/*:color"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>blue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <i>Erwähnte Orte: </i>
            <xsl:for-each select="tei:place/tei:placeName">
                <xsl:choose>
                    <xsl:when test="starts-with(@ref, 'pmb')">
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://', $type, '.acdh.oeaw.ac.at/', @ref, '.html')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template match="tei:desc/tei:listBibl" mode="desc">
        <xsl:variable name="type" select="ancestor::tei:event/tei:idno/@type"/>
        <xsl:variable name="type-farbe">
            <xsl:choose>
                <xsl:when test="key('only-relevant-uris', $type, $relevant-uris)/*:color != '#fff'">
                    <xsl:value-of select="key('only-relevant-uris', $type, $relevant-uris)/*:color"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>blue</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <i>Erwähnte Werke: </i>
            <xsl:for-each select="descendant::tei:title">
                <xsl:choose>
                    <xsl:when test="starts-with(@ref, 'pmb')">
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                                <xsl:text>badge rounded-pill</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="style">
                                <xsl:text>background-color: </xsl:text>
                                <xsl:value-of select="$type-farbe"/>
                                <xsl:text>; color: white;</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="style">
                                    <xsl:text>color: white; </xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('https://', $type, '.acdh.oeaw.ac.at/', @ref, '.html')"
                                    />
                                </xsl:attribute>
                                <xsl:attribute name="target">
                                    <xsl:text>_blank</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </li>
    </xsl:template>
    <xsl:template match="tei:bibl[parent::tei:desc]" mode="desc">
        <p>
            <xsl:text>Erscheinungsort: </xsl:text>
            <i>
                <xsl:value-of select="."/>
            </i>
        </p>
    </xsl:template>
</xsl:stylesheet>
