<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget annotation options.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>Custom template to create interactive options for text annoations.</p>
        </desc>    
    </doc>
    
    <xsl:template name="annotation-options">
        <div id="aot-navBarNavDropdown" class="navBarNavDropdown dropstart">
            <!-- Your menu goes here -->
            <a title="Annotationen" href="#" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" role="button">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-sliders" viewBox="0 0 16 16">
  <path fill-rule="evenodd" d="M11.5 2a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zM9.05 3a2.5 2.5 0 0 1 4.9 0H16v1h-2.05a2.5 2.5 0 0 1-4.9 0H0V3h9.05zM4.5 7a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zM2.05 8a2.5 2.5 0 0 1 4.9 0H16v1H6.95a2.5 2.5 0 0 1-4.9 0H0V8h2.05zm9.45 4a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zm-2.45 1a2.5 2.5 0 0 1 4.9 0H16v1h-2.05a2.5 2.5 0 0 1-4.9 0H0v-1h9.05z"/>
</svg>
            </a>                    
            <ul class="dropdown-menu">
                <li class="dropdown-item">
                    <full-size opt="fls"></full-size>
                </li>
                <li class="dropdown-item">
                    <image-switch opt="es"></image-switch>
                </li>
                <li class="dropdown-item">
                    <font-size opt="fs"></font-size>
                </li>
                <li class="dropdown-item">
                    <font-family opt="ff"></font-family>
                </li>
                <li class="dropdown-item" style="border-top: 5px dashed lightgrey !important;">
                    <annotation-slider opt="ef"></annotation-slider>
                </li>
                <li class="dropdown-item">
                    <annotation-slider opt="prs"></annotation-slider>
                </li>
                <li class="dropdown-item">
                    <annotation-slider opt="plc"></annotation-slider>
                </li>
                <li class="dropdown-item">
                    <annotation-slider opt="wrk"></annotation-slider>
                </li>
                <li class="dropdown-item">
                    <annotation-slider opt="org"></annotation-slider>
                </li>
            </ul>                                                 
        </div>
        
    </xsl:template>
</xsl:stylesheet>