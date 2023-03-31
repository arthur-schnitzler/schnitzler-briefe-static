<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget annotation options.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>Custom template to create interactive options for text annoations.</p>
        </desc>
    </doc>
    <xsl:template name="annotation-options">
        <div class="modal fade" id="editor-widget" tabindex="-1"
            aria-labelledby="ueberlieferungLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLongTitle">Einstellungen</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close"/>
                    </div>
                    <div class="modal-body">
                        <annotation-slider opt="ef"/>
                        <annotation-slider opt="wrk"/>
                        <image-switch opt="es"/>
                        <font-size opt="fs"/>
                        <font-family opt="ff"/>
                        <annotation-slider opt="prs"/>
                        <annotation-slider opt="plc"/>
                        <annotation-slider opt="org"/>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"
                            >Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
