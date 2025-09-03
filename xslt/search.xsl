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
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseYear" aria-expanded="true" aria-controls="collapseYear" style="cursor: pointer;">
                                                    Jahr <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseYear" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="range-input"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseSender" aria-expanded="true" aria-controls="collapseSender" style="cursor: pointer;">
                                                    Sender <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseSender" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-sender"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseReceiver" aria-expanded="true" aria-controls="collapseReceiver" style="cursor: pointer;">
                                                    Empfänger <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseReceiver" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-receiver"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapsePersons" aria-expanded="true" aria-controls="collapsePersons" style="cursor: pointer;">
                                                    Personen <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapsePersons" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-persons"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapsePlaces" aria-expanded="true" aria-controls="collapsePlaces" style="cursor: pointer;">
                                                    Orte <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapsePlaces" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-places"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseOrgs" aria-expanded="true" aria-controls="collapseOrgs" style="cursor: pointer;">
                                                    Institutionen <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseOrgs" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-orgs"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseWorks" aria-expanded="true" aria-controls="collapseWorks" style="cursor: pointer;">
                                                    Werke <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseWorks" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-works"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="card">
                                                <h4 class="card-header" data-bs-toggle="collapse" data-bs-target="#collapseEvents" aria-expanded="true" aria-controls="collapseEvents" style="cursor: pointer;">
                                                    Ereignisse <i class="fa fa-chevron-down float-end"></i>
                                                </h4>
                                                <div id="collapseEvents" class="collapse show">
                                                    <div class="card-body">
                                                        <div id="refinement-list-events"></div>
                                                    </div>
                                                </div>
                                            </div>
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