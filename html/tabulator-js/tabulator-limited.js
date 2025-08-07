var table = new Tabulator("#tabulator-table-limited", {
            pagination:"local",       //paginate the data
            paginationSize:25,         //allow 25 rows per page of data
            paginationCounter:"rows", //display count of paginated rows in footer
            layout:"fitColumns",
            autoColumns:true,         //auto generate columns from HTML table structure
            autoColumnsDefinitions:function(definitions){
                //auto columns returns columns with basic titles and field names
                //this callback allows you to edit each column definition before they are used
                
                // Debug: Log all columns to see what we're working with
                console.log("Tabulator columns:", definitions.map(d => ({title: d.title, field: d.field})));
                
                definitions.forEach(function(column, index){
                    column.formatter = "html";  //set formatter to html for all columns
                    column.headerFilter = "input"; //add header filters
                    
                    // Ensure correct capitalization of headers
                    if (column.title === "titel") {
                        column.title = "Titel";
                    } else if (column.title === "datum_(iso)" || column.title === "datum (iso)") {
                        column.title = "Datum (ISO)";
                    } else if (column.title === "briefnummer") {
                        column.title = "Briefnummer";
                    } else if (column.title === "korrespondenz") {
                        column.title = "Korrespondenz";
                    } else if (column.title === "enthält" || column.title === "Enthält") {
                        column.title = "enthält";
                    } else if (column.title === "anzahl") {
                        column.title = "Anzahl";
                    }
                    
                    // Hide the first column if it's a counter/id column
                    if (index === 0 && (column.field === "1" || column.title === "" || column.title.toLowerCase() === "id")) {
                        column.visible = false;
                        console.log("Hiding first column:", column.title, column.field);
                    }
                });
                return definitions;
            },
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