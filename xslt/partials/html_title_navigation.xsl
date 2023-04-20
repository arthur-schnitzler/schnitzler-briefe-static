<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsl tei xs" version="2.0">
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
            <xsl:value-of select=".//tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="prev">
            <xsl:value-of
                select="concat(descendant::tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]/@target, '.html')"
            />
        </xsl:variable>
        <xsl:variable name="next">
            <xsl:value-of
                select="concat(descendant::tei:correspDesc/tei:correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]/@target, '.html')"
            />
        </xsl:variable>
            <div class="row" id="title-nav">
                    <div class="col-md-2 col-lg-2 col-sm-12">
                        <xsl:if test="ends-with($prev,'.html')">
                            <h1>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$prev"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                    <xsl:value-of select="document(concat($prev, '.xml'))/descendant::tei:titleStmt[1]/tei:title[@level='a'][1]"/>


                                    </xsl:attribute>
                                    <i class="fas fa-chevron-left" title="prev"/>
                                </a>
                            </h1>
                        </xsl:if>
                    </div>
                <div class="col-md-8">
                        <h1 align="center">
                            <xsl:for-each
                                select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']">
                                <xsl:apply-templates/>
                                <br/>
                            </xsl:for-each>
                        </h1>
                </div>
                <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                    <xsl:if test="ends-with($next, '.html')">
                        <h1>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$next"/>
                                </xsl:attribute>
                                 <xsl:attribute name="title">
                                    <xsl:value-of select="document(concat($next, '.xml'))/descendant::tei:titleStmt[1]/tei:title[@level='a'][1]"/>


                                    </xsl:attribute>
                                <i class="fas fa-chevron-right" title="next"/>
                            </a>
                        </h1>
                    </xsl:if>
                </div>
            </div>
        
        <!-- .row -->
        <!-- .card-header -->
    </xsl:template>
</xsl:stylesheet>
