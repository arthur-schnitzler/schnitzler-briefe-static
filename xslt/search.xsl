<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Volltextsuche'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1><xsl:value-of select="$doc_title"/></h1>
                            </div>
                            <div class="card-body">
                                <div class="ais-InstantSearch">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div id="stats-container"></div>
                                            <div id="searchbox"></div>
                                            <div id="current-refinements"></div>
                                            <div id="clear-refinements"></div>
                                            <h4>Jahr</h4>
                                            <div id="range-input"></div>
                                            <h4>Sender</h4>
                                            <div id="refinement-list-sender"></div>
                                            <h4>Empfänger</h4>
                                            <div id="refinement-list-receiver"></div>
                                            <h4>Personen</h4>
                                            <div id="refinement-list-persons"></div>
                                            <h4>Orte</h4>
                                            <div id="refinement-list-places"></div>
                                            <h4>Institutionen</h4>
                                            <div id="refinement-list-orgs"></div>
                                            <h4>Werke</h4>
                                            <div id="refinement-list-works"></div>
                                            
                                        </div>
                                        <div class="col-md-8">
                                            <div id="hits"></div>
                                            <div id="pagination"></div>
                                        </div>
                                    </div>
                                </div>                          
                            </div>
                        </div>
                    </div>
                    
                    <xsl:call-template name="html_footer"/>
                    
                </div>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css" />
                <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.46.0"></script>
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"></script>
                 <script src="js/ts_index.js"></script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>