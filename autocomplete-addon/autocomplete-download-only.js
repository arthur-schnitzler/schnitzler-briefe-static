/* 
###################################################################################
###################################################################################

Autocomplete ADD-ON for staticSearch https://github.com/projectEndings/staticSearch
developed by https://github.com/linxOD for https://github.com/acdh-oeaw

Download only: used at any static html site to download and cache data before
staticSearch search page is loaded to reduce possible loading time.

###################################################################################
###################################################################################
*/

openFile = ARCHEapi.openFile;

var config = getConfig();
setTimeout(() => {
    getData(config[0], `autocomplete-addon/${config[0]}.txt`);
}, 1000);

/* 
###################################################################################
###################################################################################

CUSTOM FUNCTIONS: 

getConfig, getData, download

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
            download(txtFilePath, dir)
            .then((data) => {
                setTimeout( () => {
                    localStorage.setItem(`${projectname}-staticSearch-ac`, JSON.stringify(data));
                }, 5000);                   
            }); 
        }
        
    } else {
        download(txtFilePath)
        .then((data) => {            
            setTimeout( () => {
                localStorage.setItem(`${projectname}-staticSearch-ac`, JSON.stringify(data));
            }, 5000); 
        });
    }
}

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