<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:_="urn:acdh"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mam="whatever" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget tei-facsimile.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>The template "view type" generates various view types e.g. reading, diplomatic,
                commentary.</p>
            <p>Select between a type with or without images.</p>
            <p>Bootstrap is required.</p>
        </desc>
    </doc>
    <!--<xsl:function name="_:ano">
        <xsl:param name="node"/>
        <xsl:for-each-group select="$node" group-by="$node">
            <xsl:sequence
                select="concat('(', count(current-group()[current-grouping-key() = .]), ' ', current-grouping-key(), ')')"
            />
        </xsl:for-each-group>
    </xsl:function>-->
    <xsl:template name="mam:view-type-img">
        <xsl:variable name="hand" select="'font-family: Times New Roman, serif; font-size: 22px;'"/>
        <div class="tab-content">
            <xsl:choose>
                <xsl:when
                    test="descendant::tei:pb[1]/@facs and not(starts-with(descendant::tei:pb[1]/@facs, 'http') or starts-with(descendant::tei:pb[1]/@facs, 'www.')) and not(contains(descendant::tei:pb[1]/@facs, '.pdf'))">
                    <div id="container-resize" class="row transcript active">
                        <xsl:for-each select="//tei:body">
                        <div id="text-resize" class="col-md-6 col-lg-6 col-sm-12 text yes-index">
                            <div id="section">
                                    <div class="card-body">
                                        <div class="card-body-text">
                                            <xsl:apply-templates select="//tei:text"/>
                                            <xsl:element name="ol">
                                                <xsl:attribute name="class">
                                                  <xsl:text>list-for-footnotes</xsl:text>
                                                </xsl:attribute>
                                                <xsl:apply-templates
                                                  select="descendant::tei:note[@type = 'footnote']"
                                                  mode="footnote"/>
                                            </xsl:element>
                                        </div>
                                    </div>
                                    <xsl:if test="//tei:note[@type = 'footnote']">
                                        <div class="card-footer">
                                            <a class="anchor" id="footnotes"/>
                                            <ul class="footnotes">
                                                <xsl:for-each select="//tei:note[@place = 'foot']">
                                                  <li>
                                                  <a class="anchorFoot" id="{@xml:id}"/>
                                                  <span class="footnote_link">
                                                  <a href="#{@xml:id}_inline" class="nounderline">
                                                  <xsl:value-of select="@n"/>
                                                  </a>
                                                  </span>
                                                  <span class="footnote_text">
                                                  <xsl:apply-templates/>
                                                  </span>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                    </xsl:if>
                            </div>
                        </div>
                            <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                                <div id="viewer">
                                    <div id="container_facs_1">
                                        <div class="card-body-iif">
                                            <xsl:variable name="facsimiles">
                                                <xsl:value-of
                                                  select="distinct-values(descendant::tei:pb[not(starts-with(@facs, 'http') or starts-with(@facs, 'www.') or @facs = '' or empty(@facs)) and not(preceding-sibling::tei:tp/@facs = @facs) or (not(@facs))]/@facs)"
                                                />
                                            </xsl:variable>
                                            <xsl:variable name="url-of-facsimile">
                                                <xsl:for-each select="tokenize($facsimiles, ' ')">
                                                  <xsl:text>"https://iiif.acdh-dev.oeaw.ac.at/iiif/images/schnitzler-briefe/</xsl:text>
                                                  <xsl:value-of select="."/>
                                                  <xsl:text>.jp2/info.json"</xsl:text>
                                                  <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                  </xsl:if>
                                                </xsl:for-each>
                                            </xsl:variable>
                                            <xsl:variable name="tileSources" select="concat('tileSources:[', $url-of-facsimile, '], ')"/>
                                            <div id="openseadragon-photo" style="height:800px;">
                                                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/openseadragon.min.js"/>
                                                <script type="text/javascript">
                                                    var viewer = OpenSeadragon({
                                                        id: "openseadragon-photo",
                                                        protocol: "http://iiif.io/api/image",
                                                        prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/",
                                                        sequenceMode: true,
                                                        showNavigationControl: true,
                                                        referenceStripScroll: 'horizontal',
                                                        showReferenceStrip: true,
                                                        defaultZoomLevel: 0,
                                                        fitHorizontally: true,
                                                        <xsl:value-of select="$tileSources"/>
                                                    // Initial rotation angle
                                                    degrees: 0,
                                                    // Show rotation buttons
                                                    showRotationControl: true,
                                                    // Enable touch rotation on tactile devices
                                                    gestureSettingsTouch: {
                                                        pinchRotate: true
                                                    }
                                                });</script>
                                                <div class="image-rights">
                                                  <xsl:text>Bildrechte © </xsl:text>
                                                  <xsl:value-of
                                                  select="//tei:fileDesc/tei:sourceDesc[1]/tei:listWit[1]/tei:witness[1]/tei:msDesc[1]/tei:msIdentifier[1]/tei:repository[1]"/>
                                                  <xsl:text>, </xsl:text>
                                                  <xsl:value-of
                                                  select="//tei:fileDesc/tei:sourceDesc[1]/tei:listWit[1]/tei:witness[1]/tei:msDesc[1]/tei:msIdentifier[1]/tei:settlement[1]"
                                                  />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                </xsl:for-each>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="card-body-normalertext">
                        <xsl:apply-templates select="//tei:text"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
</xsl:stylesheet>
