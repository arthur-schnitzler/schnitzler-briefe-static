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
        <xsl:variable name="doc_title" select="'Impressum'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1><xsl:value-of select="Impressum"/></h1>
                            </div>
                            <div class="card-body">
                                <h2>Offenlegung gemäß §§ 24, 25 Mediengesetz und § 5 E-Commerce-Gesetz:</h2>
                                <h3>Medieninhaberin, Herausgeberin, inhaltliche und redaktionelle Verantwortung, Dienstanbieterin:</h3>
                                <p><a href="https://www.oeaw.ac.at">Österreichische Akademie der Wissenschaften</a> <br/>
                                    Juristische Person öffentlichen Rechts (BGBl 569/1921 idF BGBl I 130/2003) <br/>
                                        <a href="https://acdh.oeaw.ac.at">Austrian Centre for Digital Humanities (ACDH)</a> <br/>
                                            Dr. Ignaz Seipel-Platz 2, 1010 Wien, Österreich <br/>
                                    E-Mail: <a href="mailto:acdh-helpdesk@oeaw.ac.at">acdh-helpdesk(at)oeaw.ac.at</a></p>
                                <p>Die Edition wurde geschaffen von Martin Anton Müller mit Gerd-Hermann Susen, Laura Untner und Selma Jahnke.</p>
                                <h3>Unternehmensgegenstand:</h3>
                                <p>Die Österreichische Akademie der Wissenschaften (ÖAW) hat den gesetzlichen Auftrag, die Wissenschaft
                                    in jeder Hinsicht zu fördern. Als Gelehrtengesellschaft pflegt die ÖAW den Diskurs und die
                                    Zusammenarbeit der Wissenschaft mit Öffentlichkeit, Politik und Wirtschaft.</p>
                                <p>Das Austrian Centre for Digital Humanities (ACDH) ist ein Institut der ÖAW,
                                    das mit dem Ziel gegründet wurde, digitale Methoden und Ansätze in den geisteswissenschaftlichen
                                    Disziplinen zu fördern. Das ACDH unterstützt digitale Forschung in vielfältiger Weise.</p>
                                <p>Es handelt sich um eine wissenschaftliche Briefedition. Die Urheberrechte wurden entsprechend des Österreichischen Rechts gewahrt. Eine Aufnahme von Objekten auf die Seite bedeutet nicht, dass diese nunmehr urheberrechtsfrei sind, sondern nur, dass uns für unsere Edition die Verwendung erlaubt wurde.</p>
                                <h3>Vertretungsbefugte Organe:</h3>
                                <p>Präsident: Univ.-Prof. Dr. phil. Heinz Faßmann <br/>
                                    Vizepräsidentin: Univ.-Prof. DI Dr. techn. Ulrike Diebold <br/>
                                        Klassenpräsidentin: Univ.-Prof. Dr. iur. Christiane Wendehorst LL.M. (CANTAB.) <br/>
                                            Klassenpräsident: Prof. Dr. Wolfgang Baumjohann <br/>
                                                Als Aufsichtsorgan besteht der Akademierat. Siehe mehr dazu unter
                                                <a href="https://www.oeaw.ac.at/oeaw/gremien/akademierat/">https://www.oeaw.ac.at/oeaw/gremien/akademierat/</a></p>
                                <h3>Grundlegende Richtung:</h3>
                                <p>Die Website gibt Zugang zur beruflichen Korrespondenz von Arthur Schnitzler (1862–1931).</p>
                                <h3>Haftungsausschluss:</h3>
                                <p>Die Österreichische Akademie der Wissenschaften übernimmt keinerlei Gewähr für die Aktualität,
                                    Korrektheit, Vollständigkeit oder Qualität der bereitgestellten Informationen.</p>
                                <p>Im Falle des Bestehens von Links auf Webseiten anderer Medieninhaber, für deren Inhalt die ÖAW weder
                                    direkt oder indirekt mitverantwortlich ist, übernimmt die ÖAW keine Haftung für deren Inhalte und
                                    schließt jegliche Haftung hierfür aus.</p>
                                <h3>Urheberrechtlicher Hinweis:</h3>
                                <p>Alle Angebote der Website sind unter der Lizenz CC 4.0 BY veröffentlicht. Ausgenommen sind die Brieffaksimiles. Die Rechte an diesen liegen in den meisten Fällen bei den Institutionen, von denen sie bezogen wurden und sind über diese zu beziehen.</p>
                                <h3>Datenschutzrechtlicher Hinweis:</h3>
                                <p>Wir weisen darauf hin, dass zum Zwecke der Systemsicherheit und der Übersicht über das
                                    Nutzungsverhalten der Besuchenden im Rahmen von Cookies diverse personenbezogene Daten
                                    (Besuchszeitraum, Betriebssystem, Browserversion, innere Auflösung des Browserfensters, Herkunft
                                    nach Land, wievielter Besuch seit Beginn der Aufzeichnung) mittels
                                    <a href="https://matomo.org/">Matomo-Tracking</a> gespeichert werden. Die Daten werden bis auf weiteres
                                    gespeichert. Soweit dies erfolgt, werden diese Daten nicht ohne Ihre ausdrückliche Zustimmung an
                                    Dritte weitergegeben.</p>
                                <p>Durch die Nutzung der Website erklären Sie sich mit der Art und Weise sowie dem Zweck der
                                    Datenverarbeitung einverstanden. Durch eine entsprechende Einstellung in Ihrem Browser können Sie
                                    die Speicherung der Cookies verhindern. In diesem Fall stehen Ihnen aber gegebenenfalls nicht alle
                                    Funktionen der Website zur Verfügung.</p>
                                <p>Die ausführliche Datenschutzerklärung der ÖAW finden Sie
                                    <a href="https://www.oeaw.ac.at/oeaw/datenschutz">hier</a>. Die im Rahmen der Impressumspflicht
                                    veröffentlichten Kontaktdaten dürfen von Dritten nicht zur Übersendung von nicht ausdrücklich
                                    angeforderter Werbung und Informationsmaterialien verwendet werden. Einer derartigen Verwendung wird
                                    hiermit ausdrücklich widersprochen.</p>
                                
                            </div>
                        </div>
                    </div>
                    
                    <xsl:call-template name="html_footer"/>
                    
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>