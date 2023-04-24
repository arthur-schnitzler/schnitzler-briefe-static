<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:_="urn:acdh"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mam="whatever"
    exclude-result-prefixes="xs xsl tei" version="2.0">
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
        <xsl:choose>
            <xsl:when
                test="descendant::tei:pb[1]/@facs and not(starts-with(descendant::tei:pb[1]/@facs, 'http') or starts-with(descendant::tei:pb[1]/@facs, 'www.')) and not(contains(descendant::tei:pb[1]/@facs, '.pdf'))">
                <div id="text-resize" class="row transcript active">
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
                                <!--<xsl:if test="//tei:note[@type = 'footnote']">
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
                                </xsl:if>-->
                            </div>
                        </div>
                        <div id="img-resize" class="col-md-6 col-lg-6 col-sm-12 facsimiles">
                            <div id="viewer">
                                <div id="container_facsimile">
                                    <div class="card-body-iif">
                                        <xsl:variable name="facsimiles">
                                            <xsl:value-of
                                                select="distinct-values(descendant::tei:pb[not(starts-with(@facs, 'http') or starts-with(@facs, 'www.') or @facs = '' or empty(@facs)) and not(preceding-sibling::tei:tp/@facs = @facs) or (not(@facs))]/@facs)"
                                            />
                                        </xsl:variable>
                                        <xsl:variable name="facs-folder">
                                            <xsl:choose>
                                                <!-- BEINECKE -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1891')]">
                                                  <xsl:text>Beinecke_1891</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1892')]">
                                                  <xsl:text>Beinecke_1892</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1893')]">
                                                  <xsl:text>Beinecke_1893</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1894')]">
                                                  <xsl:text>Beinecke_1894</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1895')]">
                                                  <xsl:text>Beinecke_1895</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1896')]">
                                                  <xsl:text>Beinecke_1896</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1897')]">
                                                  <xsl:text>Beinecke_1897</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1898')]">
                                                  <xsl:text>Beinecke_1898</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1899')]">
                                                  <xsl:text>Beinecke_1899</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1900')]">
                                                  <xsl:text>Beinecke_1900</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1901')]">
                                                  <xsl:text>Beinecke_1901</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1902')]">
                                                  <xsl:text>Beinecke_1902</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1903')]">
                                                  <xsl:text>Beinecke_1903</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1904')]">
                                                  <xsl:text>Beinecke_1904</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1905')]">
                                                  <xsl:text>Beinecke_1905</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1906')]">
                                                  <xsl:text>Beinecke_1906</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1907')]">
                                                  <xsl:text>Beinecke_1907</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1908')]">
                                                  <xsl:text>Beinecke_1908</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1909')]">
                                                  <xsl:text>Beinecke_1909</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1910')]">
                                                  <xsl:text>Beinecke_1910</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1911')]">
                                                  <xsl:text>Beinecke_1911</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1912')]">
                                                  <xsl:text>Beinecke_1912</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1913')]">
                                                  <xsl:text>Beinecke_1913</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1914')]">
                                                  <xsl:text>Beinecke_1914</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1915')]">
                                                  <xsl:text>Beinecke_1915</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1916')]">
                                                  <xsl:text>Beinecke_1916</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1917')]">
                                                  <xsl:text>Beinecke_1917</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1918')]">
                                                  <xsl:text>Beinecke_1918</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1920')]">
                                                  <xsl:text>Beinecke_1920</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1922')]">
                                                  <xsl:text>Beinecke_1922</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1923')]">
                                                  <xsl:text>Beinecke_1923</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1924')]">
                                                  <xsl:text>Beinecke_1924</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1925')]">
                                                  <xsl:text>Beinecke_1925</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1926')]">
                                                  <xsl:text>Beinecke_1926</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1927')]">
                                                  <xsl:text>Beinecke_1927</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., '1928')]">
                                                  <xsl:text>Beinecke_1928</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., 'ASanRBH')]">
                                                  <xsl:text>Beinecke_ASanRBH</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., 'Foto-Innen')]">
                                                  <xsl:text>Beinecke_RBH_Foto-Innen</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Beinecke')] and descendant::tei:graphic/@url[starts-with(., 'undatiert')]">
                                                  <xsl:text>Beinecke_undatiert</xsl:text>
                                                </xsl:when>
                                                <!-- BSB -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Bayerische Staatsbibliothek')]">
                                                  <xsl:text>BSB</xsl:text>
                                                </xsl:when>
                                                <!-- BURGERBIBLIOTHEK -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Burgerbibliothek')]">
                                                  <xsl:text>Burgerbibliothek</xsl:text>
                                                </xsl:when>
                                                <!-- CUL -->
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'Schnitzler, A')]">
                                                  <xsl:text>CUL_A</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'Abschrift')]">
                                                  <xsl:text>CUL_Abschriften</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00001')]">
                                                  <xsl:text>CUL_MS_B1</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00002')]">
                                                  <xsl:text>CUL_MS_B2</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00003')]">
                                                  <xsl:text>CUL_MS_B3</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00004')]">
                                                  <xsl:text>CUL_MS_B4</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00005')]">
                                                  <xsl:text>CUL_MS_B5</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00008')]">
                                                  <xsl:text>CUL_MS_B8</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00012')]">
                                                  <xsl:text>CUL_MS_B12</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00013')]">
                                                  <xsl:text>CUL_MS_B13</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00014')]">
                                                  <xsl:text>CUL_MS_B14</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00015')]">
                                                  <xsl:text>CUL_MS_B15</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00016')]">
                                                  <xsl:text>CUL_MS_B16</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00017')]">
                                                  <xsl:text>CUL_MS_B17</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00019')]">
                                                  <xsl:text>CUL_MS_B19</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00020')]">
                                                  <xsl:text>CUL_MS_B20</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00022')]">
                                                  <xsl:text>CUL_MS_B22</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00025')]">
                                                  <xsl:text>CUL_MS_B25</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00026')]">
                                                  <xsl:text>CUL_MS_B26</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00029')]">
                                                  <xsl:text>CUL_MS_B29</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00030')]">
                                                  <xsl:text>CUL_MS_B30</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00032')]">
                                                  <xsl:text>CUL_MS_B32</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00034')]">
                                                  <xsl:text>CUL_MS_B34</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00035')]">
                                                  <xsl:text>CUL_MS_B35</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00036')]">
                                                  <xsl:text>CUL_MS_B36</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00037')]">
                                                  <xsl:text>CUL_MS_B37</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00039')]">
                                                  <xsl:text>CUL_MS_B39</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00040')]">
                                                  <xsl:text>CUL_MS_B40</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00041')]">
                                                  <xsl:text>CUL_MS_B41</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00042')]">
                                                  <xsl:text>CUL_MS_B42</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00043')]">
                                                  <xsl:text>CUL_MS_B43</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00044')]">
                                                  <xsl:text>CUL_MS_B44</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00046')]">
                                                  <xsl:text>CUL_MS_B46</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00050')]">
                                                  <xsl:text>CUL_MS_B50</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00052')]">
                                                  <xsl:text>CUL_MS_B52</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00055')]">
                                                  <xsl:text>CUL_MS_B55</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00058')]">
                                                  <xsl:text>CUL_MS_B58</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00059')]">
                                                  <xsl:text>CUL_MS_B59</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00060')]">
                                                  <xsl:text>CUL_MS_B60</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00062')]">
                                                  <xsl:text>CUL_MS_B62</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00063')]">
                                                  <xsl:text>CUL_MS_B63</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00064')]">
                                                  <xsl:text>CUL_MS_B64</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00065')]">
                                                  <xsl:text>CUL_MS_B65</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00066')]">
                                                  <xsl:text>CUL_MS_B66</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00067')]">
                                                  <xsl:text>CUL_MS_B67</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00068')]">
                                                  <xsl:text>CUL_MS_B68</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00069')]">
                                                  <xsl:text>CUL_MS_B69</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00070')]">
                                                  <xsl:text>CUL_MS_B70</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00073')]">
                                                  <xsl:text>CUL_MS_B73</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00074')]">
                                                  <xsl:text>CUL_MS_B74</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00078')]">
                                                  <xsl:text>CUL_MS_B78</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00079')]">
                                                  <xsl:text>CUL_MS_B79</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00083')]">
                                                  <xsl:text>CUL_MS_B83</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00084')]">
                                                  <xsl:text>CUL_MS_B84</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00085')]">
                                                  <xsl:text>CUL_MS_B85</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00086')]">
                                                  <xsl:text>CUL_MS_B86</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00088')]">
                                                  <xsl:text>CUL_MS_B88</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00089')]">
                                                  <xsl:text>CUL_MS_B89</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00090')]">
                                                  <xsl:text>CUL_MS_B90</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00091')]">
                                                  <xsl:text>CUL_MS_B91</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00092')]">
                                                  <xsl:text>CUL_MS_B92</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00093')]">
                                                  <xsl:text>CUL_MS_B93</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00096')]">
                                                  <xsl:text>CUL_MS_B96</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00097')]">
                                                  <xsl:text>CUL_MS_B97</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00100')]">
                                                  <xsl:text>CUL_MS_B100</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00103')]">
                                                  <xsl:text>CUL_MS_B103</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00104')]">
                                                  <xsl:text>CUL_MS_B104</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00106')]">
                                                  <xsl:text>CUL_MS_B106</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00107')]">
                                                  <xsl:text>CUL_MS_B107</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00108')]">
                                                  <xsl:text>CUL_MS_B108</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00109')]">
                                                  <xsl:text>CUL_MS_B109</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00111')]">
                                                  <xsl:text>CUL_MS_B111</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00112')]">
                                                  <xsl:text>CUL_MS_B112</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00113')]">
                                                  <xsl:text>CUL_MS_B113</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00114')]">
                                                  <xsl:text>CUL_MS_B114</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00115')]">
                                                  <xsl:text>CUL_MS_B115</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00116')]">
                                                  <xsl:text>CUL_MS_B116</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00117')]">
                                                  <xsl:text>CUL_MS_B117</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00118')]">
                                                  <xsl:text>CUL_MS_B118</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00201')]">
                                                  <xsl:text>CUL_MS_B201</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00521')]">
                                                  <xsl:text>CUL_MS_B521</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-00658')]">
                                                  <xsl:text>CUL_MS_B658</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Cambridge')] and descendant::tei:idno[contains(., 'B-01085')]">
                                                  <xsl:text>CUL_MS_B1085</xsl:text>
                                                </xsl:when>
                                                <!-- DLA -->
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '61.58']">
                                                  <xsl:text>DLA_61.58</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '66.18']">
                                                  <xsl:text>DLA_66.18</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '66.20']">
                                                  <xsl:text>DLA_66.20</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '69.61']">
                                                  <xsl:text>DLA_69.61</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '76.74']">
                                                  <xsl:text>DLA_76.74</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '85.1.']">
                                                  <xsl:text>DLA_85.1.</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '96.34']">
                                                  <xsl:text>DLA_96.34</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '1900-']">
                                                  <xsl:text>DLA_1900-</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = '1907-']">
                                                  <xsl:text>DLA_1907-</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'absch']">
                                                  <xsl:text>DLA_absch</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'D2021']">
                                                  <xsl:text>DLA_D2021</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'DLA_2']">
                                                  <xsl:text>DLA_DLA_2</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'DLA_6']">
                                                  <xsl:text>DLA_DLA_6</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'DLA_7']">
                                                  <xsl:text>DLA_DLA_7</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'DLA_8']">
                                                  <xsl:text>DLA_DLA_8</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'Hs-30']">
                                                  <xsl:text>DLA_Hs-30</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'HS.19']">
                                                  <xsl:text>DLA_HS.19</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'HS.71']">
                                                  <xsl:text>DLA_HS.71</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'HS.NZ']">
                                                  <xsl:text>DLA_HS.NZ</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'HS198']">
                                                  <xsl:text>DLA_HS198</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'NLJ00']">
                                                  <xsl:text>DLA_NLJ00</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="descendant::tei:graphic[substring(@url, 1, 5) = 'Widmu']">
                                                  <xsl:text>DLA_Widmu</xsl:text>
                                                </xsl:when>
                                                <!-- DRUCKE -->
                                                <xsl:when
                                                  test="descendant::tei:sourceDesc[not(tei:listWit)]">
                                                  <xsl:text>Drucke</xsl:text>
                                                </xsl:when>
                                                <!-- HOCHSTIFT -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Hochstift')]">
                                                  <xsl:text>Hochstift</xsl:text>
                                                </xsl:when>
                                                <!-- KLASSIK STIFTUNG WEIMAR -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Klassik Stiftung')]">
                                                  <xsl:text>Klassik_Stiftung_Weimar</xsl:text>
                                                </xsl:when>
                                                <!-- KÖNIGLICHE BIBLIOTHEK KOPENHAGEN -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Kongelige')]">
                                                  <xsl:text>Koenigliche_Bibliothek_Kopenhagen</xsl:text>
                                                </xsl:when>
                                                <!-- LEO BAECK INSTITUTE -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Leo Baeck')]">
                                                  <xsl:text>Leo_Baeck_Institute</xsl:text>
                                                </xsl:when>
                                                <!-- MONACENSIA -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Monacensia')]">
                                                  <xsl:text>Monacensia</xsl:text>
                                                </xsl:when>
                                                <!-- NATIONAL LIBRARY ISRAEL -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Israel')]">
                                                  <xsl:text>National_Library_Israel</xsl:text>
                                                </xsl:when>
                                                <!-- NDL KIEL -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Christian-Albrechts')]">
                                                  <xsl:text>NDL_Kiel</xsl:text>
                                                </xsl:when>
                                                <!-- ÖGL -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Gesellschaft für Literatur')]">
                                                  <xsl:text>OGL</xsl:text>
                                                </xsl:when>
                                                <!-- ÖNB -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Österreichische Nationalbibliothek')]">
                                                  <xsl:text>ONB_Literaturarchiv</xsl:text>
                                                </xsl:when>
                                                <!-- ORIEL LEIBZON -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Leibzon')]">
                                                  <xsl:text>Privatbesitz_Oriel_Leibzon</xsl:text>
                                                </xsl:when>
                                                <!-- REINHARD URBACH -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Urbach')]">
                                                  <xsl:text>Privatbesitz_Reinhard_Urbach</xsl:text>
                                                </xsl:when>
                                                <!-- SBB -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Staatsbibliothek Berlin')]">
                                                  <xsl:text>SBB</xsl:text>
                                                </xsl:when>
                                                <!-- SUB HAMBURG -->
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Hamburg')]">
                                                  <xsl:text>SUB_Hamburg</xsl:text>
                                                </xsl:when>
                                                <!-- UB SALZBURG -->
                                                <xsl:when
                                                  test="descendant::tei:settlement[contains(., 'Salzburg')]">
                                                  <xsl:text>UB_Salzburg</xsl:text>
                                                </xsl:when>
                                                <!-- UB WROCLAW -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Uniwersytecka')]">
                                                  <xsl:text>UB_Wroclaw</xsl:text>
                                                </xsl:when>
                                                <!-- UNITED NATIONS ARCHIVE -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'United Nations')]">
                                                  <xsl:text>United_Nations_Archives</xsl:text>
                                                </xsl:when>
                                                <!-- WBR -->
                                                <xsl:when
                                                  test="descendant::tei:repository[contains(., 'Wienbibliothek')]">
                                                  <xsl:text>WBR</xsl:text>
                                                </xsl:when>
                                                <!-- otherwise -->
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </xsl:variable>
                                        <xsl:variable name="url-of-facsimile">
                                            <xsl:for-each select="tokenize($facsimiles, ' ')">
                                                <xsl:text>"https://iiif.acdh-dev.oeaw.ac.at/iiif/images/schnitzler-briefe/</xsl:text>
                                                <xsl:value-of select="$facs-folder"/>
                                                <xsl:text>/</xsl:text>
                                                <xsl:value-of select="."/>
                                                <xsl:text>.jp2/info.json"</xsl:text>
                                                <xsl:if test="not(position() = last())">
                                                  <xsl:text>, </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:variable>
                                        <xsl:variable name="tileSources"
                                            select="concat('tileSources:[', $url-of-facsimile, '], ')"/>
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
                                                    fitHorizontally: true,<xsl:value-of select="$tileSources"/>
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
    </xsl:template>



</xsl:stylesheet>
