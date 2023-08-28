// Extract the xml:id from the XML file being processed
var fs = require('fs');
var path = require('path');
var xml2js = require('xml2js');

var path = document.location.pathname;
var path = path.split("/");

function extractXMLId(callback) {
    fs.readFile(path, 'utf8', function (err, data) {
        if (err) {
            callback(err);
            return;
        }
        
        var parser = new xml2js.Parser();
        parser.parseString(data, function (err, result) {
            if (err) {
                callback(err);
                return;
            }
            
            var xmlId = result[ 'tei:TEI'].$[ 'xml:id'];
            callback(null, xmlId);
        });
    });
}

// Define the variable source_pdf using the extracted xml:id
extractXMLId(function (err, xmlId) {
    if (err) {
        console.error('Error:', err);
        return;
    }
    
    var source_pdf = xmlId + '.pdf';
    
    // Check if the PDF document exists
    var pdfPath = path.join(__dirname, '../html', source_pdf);
    
    function checkPDFExists() {
        try {
            fs.accessSync(pdfPath, fs.constants.F_OK);
            return true;
        }
        catch (err) {
            return false;
        }
    }
    
    // Return true if the PDF document exists
    var pdfExists = checkPDFExists();
    console.log(pdfExists);
});