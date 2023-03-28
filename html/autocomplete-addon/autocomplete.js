/* 
###################################################################################
###################################################################################

Autocomplete ADD-ON for staticSearch https://github.com/projectEndings/staticSearch
developed by https://github.com/linxOD for https://github.com/acdh-oeaw

###################################################################################
###################################################################################
*/

// openFile() is a nodejs imported function from arche-api package https://github.com/acdh-oeaw/arche_api
openFile = ARCHEapi.openFile;

var config = getConfig();
var stems;
setTimeout(() => {
    getData(config[0], `autocomplete-addon/${config[0]}.txt`);
}, 1000);

// ssForm is a staticSearch id for the html form elements
$("#ssForm").find(".ssQueryAndButton").after(`
    <div id="ac-panel"/>`
);
const autocompletePanel = $("#ac-panel");

// ssQuery is a staticSearch id for the html input field
const searchInput = $("#ssQuery");

// turning off default browser autocomplete
searchInput.attr("autocomplete", "off");
searchInput.attr("name", "hidden");

// keyup() event to capture input values and filter for suggestions
searchInput.keyup(() => {        
    autocompletePanel.removeClass("ac-border");
    searchInput.removeClass("ac-border2"); 
    autocompletePanel.empty();

    var searchValue = searchInput
    .val()
    .toLowerCase()
    .replace('"','')
    .replace('+','')
    .replace('-','')
    .replace('"','')
    .replace('*','')
    .replace('?','')
    .replace('[','')
    .replace(']','');

    if (searchValue.includes(' ') == true) {
        // console.log(searchValue.length);
        getValueMany(searchValue);
        getItemMany();
    }
    else if (searchValue.length > 0) {
        // console.log(searchValue.length);
        getValueSingle(searchValue);
        getItem();
    }
});

// ssClear is a staticSearch id for an clear all inputs event
const clearbutton = $("#ssClear");
clearbutton.click(function() {
    autocompletePanel.removeClass("ac-border");
    searchInput.removeClass("ac-border2"); 
    autocompletePanel.empty();
});

/* 
###################################################################################
###################################################################################

CUSTOM FUNCTIONS: 

getConfig, getData, getValueSingle, getValueMany, filterAndSort, 
getItem, getItemMany, download

###################################################################################
###################################################################################
*/

// retrieving configruation data as array
function getConfig() {
    var configuration = [];
    openFile(`autocomplete-addon/config.txt`, (rs) => {
        let conf = rs.split("\n");
        conf.forEach((c) => {
            configuration.push(c);
        });
    });
    return configuration;
}

// retrieves browser cache or fetches staticSearch json files
// if browser cache is older than 7 days it fetches files
// stores data in predefined "var stems"
// specify name to set cache item name
function getData(projectname, txtFilePath) {
    var stemsCache;
    if (localStorage.getItem(`${projectname}-staticSearch-ac`) !== null) {    
        stemsCache = JSON.parse(localStorage.getItem(`${projectname}-staticSearch-ac`));
        const now = new Date();
        const expiry = new Date(stemsCache.date.dateExpiry);
        if (now > expiry) {
            localStorage.removeItem(`${projectname}-staticSearch-ac`);
            download(txtFilePath)
            .then((data) => {
                setTimeout( () => {
                    localStorage.setItem(`${projectname}-staticSearch-ac`, JSON.stringify(data));
                    stems = data.value;
                }, 5000);                   
            }); 
        } else {
            stems = stemsCache.value;
        }
        
    } else {
        download(txtFilePath)
        .then((data) => {            
            setTimeout( () => {
                localStorage.setItem(`${projectname}-staticSearch-ac`, JSON.stringify(data));
                stems = data.value;
            }, 5000); 
        });
    }
}

// takes search input value and filters them against staticSearch json files
// single value input without space
// creates and div container with suggestions
function getValueSingle(input) {
    var suggestions = filterAndSort(stems, input);
    if (suggestions.length !== 0) {
        // console.log(sortedstems);
        suggestions.forEach(function(suggested) {
            autocompletePanel.append(`
                <div class="stem row" style="padding:.5em;">
                    <div class="s-name col-md-9" style="padding-left:1em;">${suggested[0]}</div>
                    <div class="col-md-3" style="text-align:right;"><small>score: ${suggested[1]}</small></div>
                </div>
            `);                
        });
    } else {
        autocompletePanel.append(`
            <div class="stem row" style="padding:.5em;">
                <div class="s-name col-md-9" style="padding-left:1em;">no keywords found</div>
            </div>
        `);
    }

    autocompletePanel.addClass("ac-border");
    searchInput.addClass("ac-border2");
};

// takes search input values and filters them against staticSearch json files
// multi value input seperated by space
// creates and div container with multiple columns of suggestions
function getValueMany(input) {
    autocompletePanel.append(`
        <div class="row" id="ac-panel-many">
            <div class="col-md-12 text-center">
                <svg id="ac-select-all" xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-arrow-up-square" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M15 2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V2zM0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm8.5 9.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707V11.5z"/>
                </svg>
            </div>
        </div>
    `);

    const searchInputPanelMany = $("#ac-panel-many");
    var inputvalues = input.split(' ');
    inputvalues.forEach(function(value) {
        var idRandom = value + Math.ceil(Math.random() * 10) + Math.ceil(Math.random() * 10) + Math.ceil(Math.random() * 10);
        var idRandom2 = value + Math.ceil(Math.random() * 10) + Math.ceil(Math.random() * 10);
        var idRandom3 = value + Math.ceil(Math.random() * 10);
        searchInputPanelMany.append(`
            <div class="col-md-4" id="${idRandom}">
                <div class="row" style="padding:.25em;">
                    <div class="col-md-12 stems-many" style="padding:.5em;">
                        <input id="${idRandom2}" style="max-width:100%;"/>
                    </div>
                </div>
            </div>
        `);

        var suggestions = filterAndSort(stems, value);
        var randomCol = $('#' + idRandom);
        if (suggestions.length !== 0) {
            // console.log(suggestions);
            suggestions.forEach((suggested) => {
                randomCol.append(`                        
                    <div class="stem row" style="padding:.25em;">
                        <div class="s-name-many-${idRandom3} col-md-8" style="padding-left:1em;">${suggested[0]}</div>
                        <div class="col-md-4" style="text-align:right;"><small>${suggested[1]}</small></div>
                    </div>
                `);         
            });
        } else {
            randomCol.append(`
                <div class="row" style="padding:.25em;">
                    <div class="col-md-12" style="padding-left:1em;">no keywords found</div>
                </div>
            `);
        }
        $('.stem .s-name-many-' + idRandom3).on("click", function() {
            var svalue = $(this).text();
            // console.log(svalue);
            var inputMany = $("#" + idRandom2);
            inputMany.val(svalue);
        });     
    });

    autocompletePanel.addClass("ac-border");
    searchInput.addClass("ac-border2");
};

// filters staticSearch data against search input
// used within getValueSingle() and getValueMany()
function filterAndSort(data, input) {
    var stemsuggestions = Object.entries(data).filter(function(stem) {
        // console.log(stem);
        return stem[0].startsWith(input);            
    });

    // console.log(stemsuggestions.length);
    var sortedstems = stemsuggestions.sort(function(a, b) {
        return a[1] - b[1];
    }).reverse();
    return sortedstems;
}

// suggestions of the panel when clicked on are copied to search input field
function getItem() {  
    $(".stem .s-name").on("click", function() {
        var svalue = $(this).text();
        // console.log(svalue);
        searchInput.val(svalue);
        searchInput.focus();
    });
}

// suggestions of each column are copied to the column specific input fields
// arrow symbol button copies all value of column input fileds to the main search input field
function getItemMany() {
    $('#ac-select-all').on("click", function() {
        var svalue = $(".stems-many input");
        var value = "";
        for (var i = 0; i < svalue.length; i++) {                    
            value += svalue[i].value + " ";
        }
        // console.log(value);
        searchInput.val(value);
        searchInput.focus();
    });
}

// openFile() is a nodejs imported function from arche-api package https://github.com/acdh-oeaw/arche_api
// creates the actual download based on filepaths provided by a prior created txt file than contains all staticSearch json filepaths
// returns an object
async function download(filepath) {
    const stemsObj = {
        "value": {},
        "date": {}
    };
    try {
        openFile(filepath, (rs) => {
            var filenames = rs.split('\n');
            filenames.forEach(function(fpath) { 
                if (fpath.length > 1) {
                    try {      
                        openFile(fpath, (file) => {
                            var response = JSON.parse(file);
                            var stem = response.stem;
                            var inst = response.instances;
                            var instances = [];
                            inst.forEach((instance) => {
                                instances.push(instance.score);   
                            });
                            if (instances.length > 1) {
                                var scoreSum = 0;
                                instances.forEach((score) => {
                                    scoreSum += score;
                                });
                                stemsObj.value[stem] = scoreSum;
                            } else {
                                stemsObj.value[stem] = instances[0];
                            }              
                        });
                        
                    } catch (error) {
                        console.log(`Error in downloading data found: ${error}`);
                        console.log(`Verify correct filepath: ${filepath}`);
                        console.log(`Check config.txt to set the correct project directory: ${directory}`);
                    }   
                }
            });
        });
        const date = new Date();
        date.setDate(date.getDate() + 7);
        // console.log(date);
        stemsObj.date["dateExpiry"] = date;
        return stemsObj;

    } catch (error) {
        console.log(`Error in downloading data found: ${error}`);
        console.log(`Verify correct filepath: ${filepath}. Open config.txt to change.`);
    }
};
