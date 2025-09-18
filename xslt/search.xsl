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
                                <!-- Typesense Search Container -->
                                <div id="typesense-search-container" style="display: block;">
                                    <div class="ais-InstantSearch">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <!-- Search Engine Toggle -->
                                                <div class="card mb-3">
                                                    <div class="card-header d-flex justify-content-between align-items-center">
                                                        <span>Suchmaschine</span>
                                                        <i class="fas fa-info-circle text-muted"
                                                           data-bs-toggle="tooltip"
                                                           data-bs-placement="right"
                                                           title="Typesense: Schnelle Volltextsuche mit Filtern | Noske: Linguistische Suche mit CQL (z.B. [lemma=&quot;sein&quot;] oder lieb*)"></i>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="btn-group btn-group-sm d-flex" role="group" aria-label="Search engine selection">
                                                            <button type="button" class="btn btn-primary flex-fill" id="btn-typesense">
                                                                <i class="fas fa-search"></i> Typesense
                                                            </button>
                                                            <a href="https://corpus-search.acdh.oeaw.ac.at/crystal/#concordance?corpname=schnitzlerbriefe&tab=basic&keyword=Adresse&attrs=word&viewmode=sen&attr_allpos=all&refs_up=0&shorten_refs=1&glue=1&gdexcnt=300&show_gdex_scores=0&itemsPerPage=20&structs=s%2Cg&refs=doc&showresults=1&showTBL=0&tbl_template=&gdexconf=&f_tab=basic&f_showrelfrq=1&f_showperc=0&f_showreldens=0&f_showreltt=0&c_customrange=0&t_attr=&t_absfrq=0&t_trimempty=1&t_threshold=5&operations=%5B%7B%22name%22%3A%22iquery%22%2C%22arg%22%3A%22Adresse%22%2C%22query%22%3A%7B%22queryselector%22%3A%22iqueryrow%22%2C%22iquery%22%3A%22Adresse%22%7D%2C%22id%22%3A1536%7D%5D" target="_blank" class="btn btn-outline-primary flex-fill" role="button">
                                                                <i class="fas fa-language"></i> Noske
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>

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

                                <!-- Noske Search Container -->
                                <div id="noske-search-container" style="display: none;">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <!-- Search Engine Toggle (same as Typesense) -->
                                            <div class="card mb-3">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <span>Suchmaschine</span>
                                                    <i class="fas fa-info-circle text-muted"
                                                       data-bs-toggle="tooltip"
                                                       data-bs-placement="right"
                                                       title="Typesense: Schnelle Volltextsuche mit Filtern | Noske: Linguistische Suche mit CQL (z.B. [lemma=&quot;sein&quot;] oder lieb*)"></i>
                                                </div>
                                                <div class="card-body">
                                                    <div class="btn-group btn-group-sm d-flex" role="group" aria-label="Search engine selection">
                                                        <button type="button" class="btn btn-outline-primary flex-fill" id="btn-typesense-noske">
                                                            <i class="fas fa-search"></i> Typesense
                                                        </button>
                                                        <a href="https://corpus-search.acdh.oeaw.ac.at/crystal/#concordance?corpname=schnitzlerbriefe&tab=basic&keyword=Adresse&attrs=word&viewmode=sen&attr_allpos=all&refs_up=0&shorten_refs=1&glue=1&gdexcnt=300&show_gdex_scores=0&itemsPerPage=20&structs=s%2Cg&refs=doc&showresults=1&showTBL=0&tbl_template=&gdexconf=&f_tab=basic&f_showrelfrq=1&f_showperc=0&f_showreldens=0&f_showreltt=0&c_customrange=0&t_attr=&t_absfrq=0&t_trimempty=1&t_threshold=5&operations=%5B%7B%22name%22%3A%22iquery%22%2C%22arg%22%3A%22Adresse%22%2C%22query%22%3A%7B%22queryselector%22%3A%22iqueryrow%22%2C%22iquery%22%3A%22Adresse%22%7D%2C%22id%22%3A1536%7D%5D" target="_blank" class="btn btn-primary flex-fill" role="button">
                                                            <i class="fas fa-language"></i> Noske
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="alert alert-info" role="alert">
                                                <h6><i class="fas fa-info-circle"></i> Erweiterte Suche mit Noske</h6>
                                                <p class="mb-2 small">
                                                    <strong>Einfache Suche:</strong> <code>liebe</code> oder <code>lieb*</code> (mit * für beliebige Zeichen)<br/>
                                                    <strong>CQL-Suche:</strong> <code>[lemma="lieben"]</code> • <code>[tag="N.*"]</code> • <code>[word=".*ing"]</code><br/>
                                                    <strong>Platzhalter:</strong> Einfach: <code>*</code> und <code>?</code> • CQL: <code>.*</code> in Anführungszeichen<br/>
                                                    <strong>Beispiele:</strong> <code>lieb*</code> • <code>[word="Lie.*"]</code> • <code>[lemma="sein"]</code>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="mb-3">
                                                <div id="noske-stats" class="mb-2"></div>
                                                <input type="text" id="noske-input" class="form-control form-control-lg"
                                                       placeholder="Suchbegriff eingeben... (z.B. 'lieb*' oder '[lemma=&quot;lieben&quot;]')" />
                                            </div>

                                            <div id="noske-hits" class="mb-3"></div>
                                            <div id="noske-pagination"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <xsl:call-template name="html_footer"/>
                    
                </div>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css" />
                <link rel="stylesheet" href="css/noske-search.css" />
                <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.46.0"></script>
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"></script>
                 <script src="js/ts_index.js"></script>
                 <script type="module" src="js/noske_search.js"></script>
                 <script src="js/search_toggle.js"></script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>