<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- hier sind die verschiedenen tabellentypen. die unterscheidung dient vor allem der sortierung am anfang -->
    
    <xsl:template match="/" name="tabulator_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            // Erste Tabelle mit Sortierung nach "urheber_in" und "titel"
            var table = new Tabulator("#tabulator-table", {
            pagination:"local",       //paginate the data
            paginationSize:25,         //allow 25 rows per page of data
            paginationCounter:"rows", //display count of paginated rows in footer
            movableColumns:true,
            initialSort:[
            {column:"urheber_in", dir:"asc"}, 
            {column:"titel", dir:"asc"}
            ],
            langs:{
            "de-de":{ //German language definition
            "pagination":{
            "first":"Erste",
            "first_title":"Erste Seite",
            "last":"Letzte",
            "last_title":"Letzte Seite",
            "prev":"Vorige",
            "prev_title":"Vorige Seite",
            "next":"Nächste",
            "next_title":"Nächste Seite",
            "all":"Alle",
            "counter":{
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten",
            }
            },
            },
            },
            locale: "de-de"
            });
            
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_work_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            // Erste Tabelle mit Sortierung nach "urheber_in" und "titel"
            var table = new Tabulator("#tabulator-table-work", {
            pagination:"local",       //paginate the data
            paginationSize:25,         //allow 25 rows per page of data
            paginationCounter:"rows", //display count of paginated rows in footer
            movableColumns:true,
            layout:"fitColumns",
            initialSort:[
            {column:"urheber_in", dir:"asc"}, 
            {column:"titel", dir:"asc"}
            ],
            langs:{
            "de-de":{ //German language definition
            "pagination":{
            "first":"Erste",
            "first_title":"Erste Seite",
            "last":"Letzte",
            "last_title":"Letzte Seite",
            "prev":"Vorige",
            "prev_title":"Vorige Seite",
            "next":"Nächste",
            "next_title":"Nächste Seite",
            "all":"Alle",
            "counter":{
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten",
            }
            },
            },
            },
            locale: "de-de"
            });
            
          
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_event_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            var table = new Tabulator("#tabulator-table-event", {
            pagination:"local",       //paginate the data
            paginationSize:25,         //allow 25 rows per page of data
            paginationCounter:"rows", //display count of paginated rows in footer
            movableColumns:true,
            layout:"fitColumns",
            autoColumns:true,         //auto generate columns from HTML table structure
            autoColumnsDefinitions:function(definitions){
                //auto columns returns columns with basic titles and field names
                //this callback allows you to edit each column definition before they are used
                definitions.forEach(function(column, index){
                    column.formatter = "html";  //set formatter to html for all columns
                    column.headerFilter = "input"; //add header filters
                    
                    // Fix header capitalization for events table
                    if (column.title === "datum") {
                        column.title = "Datum";
                    } else if (column.title === "ereignis") {
                        column.title = "Ereignis";
                    } else if (column.title === "werk") {
                        column.title = "Werk";
                    } else if (column.title === "ort") {
                        column.title = "Ort";
                    } else if (column.title === "typ") {
                        column.title = "Typ";
                    } else if (column.title === "arbeitskraft") {
                        column.title = "Arbeitskraft";
                    } else if (column.title === "teilnehmer_innen") {
                        column.title = "Teilnehmer:innen";
                    } else if (column.title === "organisation") {
                        column.title = "Organisation";
                    }
                    
                    // Hide the first column if it's an id column
                    if (index === 0 <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> (column.field === "1" || column.title === "" || column.title.toLowerCase() === "id")) {
                        column.visible = false;
                    }
                });
                return definitions;
            },
            initialSort:[
            {column:"datum", dir:"asc"}, 
            {column:"ereignis", dir:"asc"}
            ],
            langs:{
            "de-de":{ //German language definition
            "pagination":{
            "first":"Erste",
            "first_title":"Erste Seite",
            "last":"Letzte",
            "last_title":"Letzte Seite",
            "prev":"Vorige",
            "prev_title":"Vorige Seite",
            "next":"Nächste",
            "next_title":"Nächste Seite",
            "all":"Alle",
            "counter":{
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten",
            }
            },
            },
            },
            locale: "de-de"
            });
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_person_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            // Erste Tabelle mit Sortierung nach "urheber_in" und "titel"
            var table = new Tabulator("#tabulator-table-person", {
            pagination:"local",       //paginate the data
            paginationSize:25,         //allow 25 rows per page of data
            paginationCounter:"rows", //display count of paginated rows in footer
            movableColumns:true,
            layout:"fitColumns",
            columns: [
            {title: "Vorname", field: "vorname", sorter: "string", formatter: "html"},
            {title: "Nachname", field: "nachname", sorter: "string", formatter: "html"},
            {title: "Namensvarianten", field: "namensvarianten", sorter: "string"},
            {title: "Lebensdaten", field: "lebensdaten", sorter: "string"},
            {title: "Berufe", field: "berufe", sorter: "string"}
            ],
            initialSort:[
            {column:"vorname", dir:"asc"},
            {column:"nachname", dir:"asc"}
            
            ],
            langs:{
            "de-de":{ //German language definition
            "pagination":{
            "first":"Erste",
            "first_title":"Erste Seite",
            "last":"Letzte",
            "last_title":"Letzte Seite",
            "prev":"Vorige",
            "prev_title":"Vorige Seite",
            "next":"Nächste",
            "next_title":"Nächste Seite",
            "all":"Alle",
            "counter":{
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten",
            }
            },
            },
            },
            locale: "de-de"
            });
            
            
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_org_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            // Erste Tabelle mit Sortierung nach "urheber_in" und "titel"
            var table = new Tabulator("#tabulator-table-org", {
            pagination: "local",       // paginate the data
            paginationSize: 25,         // allow 25 rows per page of data
            paginationCounter: "rows", // display count of paginated rows in footer
            movableColumns: true,
            layout:"fitColumns",
            columns: [
            { title: "Name", field: "name", sorter: "string" },
            { title: "Namensvarianten", field: "namensvarianten", sorter: "string" },
            { title: "Zugehörigkeiten", field: "zugehoerigkeiten", sorter: "string" },
            { title: "Typ", field: "typ", sorter: "string" }
            ],
            initialSort: [
            { column: "zugehoerigkeiten", dir: "asc" },
            { column: "name", dir: "asc" }
            ],
            langs: {
            "de-de": { // German language definition
            "pagination": {
            "first": "Erste",
            "first_title": "Erste Seite",
            "last": "Letzte",
            "last_title": "Letzte Seite",
            "prev": "Vorige",
            "prev_title": "Vorige Seite",
            "next": "Nächste",
            "next_title": "Nächste Seite",
            "all": "Alle",
            "counter": {
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten"
            }
            }
            }
            },
            locale: "de-de"
            });
            
            
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_archives_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            var table = new Tabulator("#tabulator-table-archives", {
            pagination: "local",       // paginate the data
            paginationSize: 25,         // allow 25 rows per page of data
            paginationCounter: "rows", // display count of paginated rows in footer
            movableColumns: true,
            layout:"fitColumns",
            autoColumns:true,         //auto generate columns from HTML table structure
            autoColumnsDefinitions:function(definitions){
                //auto columns returns columns with basic titles and field names
                //this callback allows you to edit each column definition before they are used
                definitions.forEach(function(column, index){
                    column.formatter = "html";  //set formatter to html for all columns
                    column.headerFilter = "input"; //add header filters
                    
                    // Fix header capitalization for archives table
                    if (column.title === "datum") {
                        column.title = "Datum";
                    } else if (column.title === "titel") {
                        column.title = "Titel";
                    } else if (column.title === "institution") {
                        column.title = "Institution";
                    } else if (column.title === "ort") {
                        column.title = "Ort";
                    } else if (column.title === "land") {
                        column.title = "Land";
                    }
                    
                    // Hide the first column if it's an id column
                    if (index === 0 <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> (column.field === "1" || column.title === "" || column.title.toLowerCase() === "id")) {
                        column.visible = false;
                    }
                });
                return definitions;
            },
            rowFormatter:function(row){
                var rowData = row.getData();
                var rowElement = row.getElement();
                
                // Extract schnitzler role from hidden span or data attribute
                var schnitzlerRole = "";
                var cells = rowElement.querySelectorAll("td");
                cells.forEach(function(cell) {
                    var hiddenSpan = cell.querySelector("span[data-schnitzler-role]");
                    if (hiddenSpan) {
                        schnitzlerRole = hiddenSpan.getAttribute("data-schnitzler-role");
                    }
                });
                
                // Apply row coloring based on schnitzler role
                if (schnitzlerRole === "as-empf") {
                    rowElement.classList.add("sender-color");
                } else if (schnitzlerRole === "umfeld") {
                    rowElement.classList.add("umfeld-color");
                }
                // as-sender gets no special class (default styling)
            },
            initialSort: [
            { column: "datum", dir: "asc" }
            ],
            langs: {
            "de-de": { // German language definition
            "pagination": {
            "first": "Erste",
            "first_title": "Erste Seite",
            "last": "Letzte",
            "last_title": "Letzte Seite",
            "prev": "Vorige",
            "prev_title": "Vorige Seite",
            "next": "Nächste",
            "next_title": "Nächste Seite",
            "all": "Alle",
            "counter": {
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten"
            }
            }
            }
            },
            locale: "de-de"
            });
            
            
            table.on("dataLoaded", function (data) {
            var el = document.getElementById("counter1");
            if(el) el.innerHTML = `${data.length}`;
            var el2 = document.getElementById("counter2");
            if(el2) el2.innerHTML = `${data.length}`;
            });
            
            table.on("dataFiltered", function (filters, data) {
            var el = document.getElementById("counter1");
            if(el) el.innerHTML = `${data.length}`;
            }); 
        </script>
        
    </xsl:template>
    
    <xsl:template match="/" name="tabulator_correspaction_js">
        <link href="https://unpkg.com/tabulator-tables@6.2.1/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"/>
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.2.1/dist/js/tabulator.min.js"></script>
        <script src="tabulator-js/config.js"></script>
        <script>
            var table = new Tabulator("#tabulator-table-correspaction", {
            pagination: "local",       // paginate the data
            paginationSize: 25,         // allow 25 rows per page of data
            paginationCounter: "rows", // display count of paginated rows in footer
            movableColumns: true,
            layout:"fitColumns",
            autoColumns:true,         //auto generate columns from HTML table structure
            autoColumnsDefinitions:function(definitions){
                //auto columns returns columns with basic titles and field names
                //this callback allows you to edit each column definition before they are used
                definitions.forEach(function(column, index){
                    column.formatter = "html";  //set formatter to html for all columns
                    column.headerFilter = "input"; //add header filters
                    
                    // Fix header capitalization for correspaction table
                    if (column.title === "titel") {
                        column.title = "Titel";
                    } else if (column.title === "sendedatum") {
                        column.title = "Sendedatum";
                    } else if (column.title === "sendeort") {
                        column.title = "Sendeort";
                    } else if (column.title === "weitere stationen") {
                        column.title = "weitere Stationen";
                    } else if (column.title === "empfangsdatum") {
                        column.title = "Empfangsdatum";
                    } else if (column.title === "empfangsort") {
                        column.title = "Empfangsort";
                    }
                    
                    // Hide the first column if it's an id column
                    if (index === 0 <xsl:text disable-output-escaping="yes">&amp;&amp;</xsl:text> (column.field === "1" || column.title === "" || column.title.toLowerCase() === "id")) {
                        column.visible = false;
                    }
                });
                return definitions;
            },
            rowFormatter:function(row){
                var rowData = row.getData();
                var rowElement = row.getElement();
                
                // Extract schnitzler role from hidden span or data attribute
                var schnitzlerRole = "";
                var cells = rowElement.querySelectorAll("td");
                cells.forEach(function(cell) {
                    var hiddenSpan = cell.querySelector("span[data-schnitzler-role]");
                    if (hiddenSpan) {
                        schnitzlerRole = hiddenSpan.getAttribute("data-schnitzler-role");
                    }
                });
                
                // Apply row coloring based on schnitzler role
                if (schnitzlerRole === "as-empf") {
                    rowElement.classList.add("sender-color");
                } else if (schnitzlerRole === "umfeld") {
                    rowElement.classList.add("umfeld-color");
                }
                // as-sender gets no special class (default styling)
            },
            initialSort: [
            { column: "sendedatum", dir: "asc" }
            ],
            langs: {
            "de-de": { // German language definition
            "pagination": {
            "first": "Erste",
            "first_title": "Erste Seite",
            "last": "Letzte",
            "last_title": "Letzte Seite",
            "prev": "Vorige",
            "prev_title": "Vorige Seite",
            "next": "Nächste",
            "next_title": "Nächste Seite",
            "all": "Alle",
            "counter": {
            "showing": "Zeige",
            "of": "von",
            "rows": "Reihen",
            "pages": "Seiten"
            }
            }
            }
            },
            locale: "de-de"
            });
            
            
            table.on("dataLoaded", function (data) {
            var el = document.getElementById("counter1");
            if(el) el.innerHTML = `${data.length}`;
            var el2 = document.getElementById("counter2");
            if(el2) el2.innerHTML = `${data.length}`;
            });
            
            table.on("dataFiltered", function (filters, data) {
            var el = document.getElementById("counter1");
            if(el) el.innerHTML = `${data.length}`;
            }); 
        </script>
        
    </xsl:template>
    
    
    
    
    
    <xsl:template match="/" name="tabulator_dl_buttons">
        <h4>Tabelle laden</h4>
        <div class="button-group">
            <button type="button" class="btn btn-outline-secondary" id="download-csv" title="Download CSV">
                <span>CSV</span>
            </button>
            <span>&#160;</span>
            <button type="button" class="btn btn-outline-secondary" id="download-json" title="Download JSON">
                <span>JSON</span>
            </button>
            <span>&#160;</span>
            <button type="button" class="btn btn-outline-secondary" id="download-html" title="Download HTML">
                <span>HTML</span>
            </button>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>