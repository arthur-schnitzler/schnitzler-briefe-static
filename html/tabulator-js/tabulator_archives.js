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
                definitions.forEach(function(column){
                    column.formatter = "html";  //set formatter to html for all columns
                    column.headerFilter = "input"; //add header filters
                    
                    // Ensure correct capitalization of headers
                    if (column.title === "titel") {
                        column.title = "Titel";
                    } else if (column.title === "datum_(iso)" || column.title === "datum (iso)") {
                        column.title = "Datum (ISO)";
                    } else if (column.title === "briefnummer") {
                        column.title = "Briefnummer";
                    }
                });
                return definitions;
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