
// External JavaScript file
function createStatistik1a(csvFilename, correspondenceName) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik1/${csvFilename}`;
    
    // Load data to calculate totals for pie chart
    fetch(csvURL)
        .then(response => response.text())
        .then(csvText => {
            const lines = csvText.trim().split('\n');
            let totalVonSchnitzler = 0;
            let totalVonPartner = 0;
            let totalUmfeldSchnitzler = 0;
            let totalUmfeldPartner = 0;
            
            // Process each line to calculate totals
            lines.forEach((line, index) => {
                if (index === 0 && isNaN(line.split(',')[1])) return; // Skip header
                
                const values = line.split(',');
                totalVonSchnitzler += parseInt(values[1]) || 0; // von Schnitzler
                totalUmfeldSchnitzler += parseInt(values[2]) || 0; // von Schnitzler Umfeld  
                totalVonPartner += parseInt(values[3]) || 0; // an Schnitzler (vom Partner)
                totalUmfeldPartner += parseInt(values[4]) || 0; // an Schnitzler Umfeld (vom Partner)
            });
            
            // Create pie chart data
            const pieData = [];
            
            if (totalVonSchnitzler > 0) {
                pieData.push({
                    name: 'von Schnitzler',
                    y: totalVonSchnitzler,
                    color: '#A63437'
                });
            }
            
            if (totalVonPartner > 0) {
                pieData.push({
                    name: 'von ' + (correspondenceName || 'Partner'),
                    y: totalVonPartner,
                    color: '#3785A6'
                });
            }
            
            if (totalUmfeldSchnitzler > 0) {
                pieData.push({
                    name: 'Umfeldbriefe von Schnitzler',
                    y: totalUmfeldSchnitzler,
                    color: '#68825b'
                });
            }
            
            if (totalUmfeldPartner > 0) {
                pieData.push({
                    name: 'Umfeldbriefe von ' + (correspondenceName || 'Partner'),
                    y: totalUmfeldPartner,
                    color: '#68825b'
                });
            }
            
            // Create the pie chart
            const chart = Highcharts.chart('statistik1a', {
                chart: {
                    type: 'pie'
                },
                title: {
                    text: 'Gesamtverteilung der Korrespondenzstücke'
                },
                plotOptions: {
                    pie: {
                        innerSize: '40%', // Donut chart
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.y} ({point.percentage:.1f}%)'
                        }
                    }
                },
                series: [{
                    name: 'Korrespondenzstücke',
                    data: pieData
                }]
            });
        });
}

function createStatistik1(csvFilename, correspondenceName) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik1/${csvFilename}`;
    
    // First load the data to process it manually
    fetch(csvURL)
        .then(response => response.text())
        .then(csvText => {
            const lines = csvText.trim().split('\n');
            const processedData = [];
            
            // Process each line (skip header if exists)
            lines.forEach((line, index) => {
                if (index === 0 && isNaN(line.split(',')[1])) return; // Skip header
                
                const values = line.split(',');
                const year = values[0];
                const val1 = parseInt(values[1]) || 0; // von Schnitzler
                const val2 = parseInt(values[2]) || 0; // von Schnitzler Umfeld  
                const val3 = parseInt(values[3]) || 0; // an Schnitzler
                const val4 = parseInt(values[4]) || 0; // an Schnitzler Umfeld
                
                processedData.push({
                    year: year,
                    val1: val1, // von Schnitzler direkt
                    val2: val2, // von Schnitzler Umfeld
                    val3: val3, // an Schnitzler direkt
                    val4: val4, // an Schnitzler Umfeld
                    negativePart: -(val1 + val2), // Combined negative (below x-axis)
                    positivePart: val3 + val4      // Combined positive (above x-axis)
                });
            });
            
            // Create the chart with processed data
            window.processedDataForTooltip = processedData; // Global scope for tooltip access
            const chart = Highcharts.chart('statistik1', {
                chart: {
                    type: 'column'
                },
                title: {
                    text: 'Anzahl der Korrespondenzstücke'
                },
                xAxis: {
                    categories: processedData.map(d => d.year)
                },
                yAxis: {
                    title: {
                        text: 'Anzahl'
                    },
                    labels: {
                        formatter: function () {
                            return Math.abs(this.value);
                        }
                    }
                },
                plotOptions: {
                    column: {
                        stacking: 'normal',
                        groupPadding: 0.1,
                        pointPadding: 0.1
                    }
                },
                tooltip: {
                    formatter: function () {
                        const year = this.category || this.x;
                        const dataPoint = window.processedDataForTooltip.find(d => d.year == year);
                        
                        if (!dataPoint) {
                            return '<b>' + this.series.name + '</b><br/>' + year + ': ' + Math.abs(this.y);
                        }
                        
                        let tooltipContent = '<b>' + year + '</b><br/>';
                        
                        // Von Schnitzler Sektion (negative Werte)
                        tooltipContent += '<br/><b>Von Schnitzler:</b><br/>';
                        tooltipContent += 'Schnitzler direkt: ' + (dataPoint.val1 || 0) + '<br/>';
                        tooltipContent += 'Schnitzler Umfeld: ' + (dataPoint.val2 || 0) + '<br/>';
                        tooltipContent += '<b>Gesamt: ' + ((dataPoint.val1 || 0) + (dataPoint.val2 || 0)) + '</b><br/>';
                        
                        // An Schnitzler Sektion (positive Werte)
                        tooltipContent += '<br/><b>An Schnitzler:</b><br/>';
                        tooltipContent += 'Schnitzler direkt: ' + (dataPoint.val3 || 0) + '<br/>';
                        tooltipContent += 'Schnitzler Umfeld: ' + (dataPoint.val4 || 0) + '<br/>';
                        tooltipContent += '<b>Gesamt: ' + ((dataPoint.val3 || 0) + (dataPoint.val4 || 0)) + '</b>';
                        
                        return tooltipContent;
                    }
                },
                legend: {
                    reversed: false
                },
                series: [{
                    name: 'Umfeldbriefe (unten)',
                    color: '#68825b',
                    data: processedData.map(d => -d.val2) // Negative für unteren Balken
                }, {
                    name: 'von Schnitzler',
                    color: '#A63437',
                    data: processedData.map(d => -d.val1) // Negative für unteren Balken
                }, {
                    name: 'Umfeldbriefe',
                    color: '#68825b',
                    data: processedData.map(d => d.val4) // Positive für oberen Balken
                }, {
                    name: 'von ' + (correspondenceName || 'Partner'),
                    color: '#3785A6', 
                    data: processedData.map(d => d.val3) // Positive für oberen Balken
                }]
            });
        });
}

function createStatistik3a(csvFilename, correspondenceName) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik3/${csvFilename}`;
    
    // Load data to calculate totals for bubble chart
    fetch(csvURL)
        .then(response => response.text())
        .then(csvText => {
            const lines = csvText.trim().split('\n');
            let totalVonSchnitzler = 0;
            let totalVonPartner = 0;
            let totalUmfeldSchnitzler = 0;
            let totalUmfeldPartner = 0;
            
            // Process each line to calculate totals
            lines.forEach((line, index) => {
                if (index === 0 && isNaN(line.split(',')[1])) return; // Skip header
                
                const values = line.split(',');
                totalVonSchnitzler += parseInt(values[1]) || 0; // von Schnitzler
                totalUmfeldSchnitzler += parseInt(values[2]) || 0; // von Schnitzler Umfeld  
                totalVonPartner += parseInt(values[3]) || 0; // an Schnitzler (vom Partner)
                totalUmfeldPartner += parseInt(values[4]) || 0; // an Schnitzler Umfeld (vom Partner)
            });
            
            // Find maximum value for scaling
            const maxValue = Math.max(totalVonSchnitzler, totalVonPartner, totalUmfeldSchnitzler, totalUmfeldPartner);
            
            // Create bubble chart data - each circle represents one category
            const bubbleData = [
                {
                    name: 'von Schnitzler',
                    data: [{
                        x: 1,
                        y: 1,
                        z: totalVonSchnitzler,
                        color: '#A63437',
                        label: 'von Schnitzler',
                        value: totalVonSchnitzler
                    }]
                },
                {
                    name: 'von ' + (correspondenceName || 'Partner'),
                    data: [{
                        x: 2,
                        y: 1,
                        z: totalVonPartner,
                        color: '#3785A6',
                        label: 'von ' + (correspondenceName || 'Partner'),
                        value: totalVonPartner
                    }]
                },
                {
                    name: 'Umfeldbriefe von Schnitzler',
                    data: [{
                        x: 3,
                        y: 1,
                        z: totalUmfeldSchnitzler,
                        color: '#68825b',
                        label: 'Umfeldbriefe von Schnitzler',
                        value: totalUmfeldSchnitzler
                    }]
                },
                {
                    name: 'Umfeldbriefe von ' + (correspondenceName || 'Partner'),
                    data: [{
                        x: 4,
                        y: 1,
                        z: totalUmfeldPartner,
                        color: '#68825b',
                        label: 'Umfeldbriefe von ' + (correspondenceName || 'Partner'),
                        value: totalUmfeldPartner
                    }]
                }
            ];
            
            // Filter out empty data sets
            const filteredData = bubbleData.filter(series => series.data[0].z > 0);
            
            // Create the bubble chart
            const chart = Highcharts.chart('statistik3a', {
                chart: {
                    type: 'bubble',
                    plotBorderWidth: 0,
                    zoomType: 'xy'
                },
                title: {
                    text: 'Zeichenanzahl der Korrespondenzstücke'
                },
                xAxis: {
                    categories: ['', 'Schnitzler', (correspondenceName || 'Partner'), 
                               'Umfeld Schnitzler', 'Umfeld ' + (correspondenceName || 'Partner')],
                    gridLineWidth: 0,
                    lineWidth: 0,
                    tickWidth: 0,
                    labels: {
                        enabled: false
                    },
                    title: {
                        text: null
                    }
                },
                yAxis: {
                    startOnTick: false,
                    endOnTick: false,
                    title: {
                        text: null
                    },
                    labels: {
                        enabled: false
                    },
                    gridLineWidth: 0,
                    lineWidth: 0,
                    tickWidth: 0,
                    min: 0.5,
                    max: 1.5
                },
                legend: {
                    enabled: false
                },
                plotOptions: {
                    bubble: {
                        minSize: 20,
                        maxSize: 120,
                        zMin: 0,
                        zMax: maxValue,
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.label}</b><br/>{point.value:,.0f} Zeichen',
                            style: {
                                fontSize: '11px',
                                fontWeight: 'bold'
                            }
                        }
                    }
                },
                tooltip: {
                    useHTML: true,
                    headerFormat: '<table>',
                    pointFormat: '<tr><th colspan="2"><h3>{point.label}</h3></th></tr>' +
                                '<tr><th>Zeichenanzahl:</th><td>{point.z:,.0f}</td></tr>',
                    footerFormat: '</table>',
                    followPointer: true
                },
                series: filteredData
            });
        });
}

function createStatistik2(csvFilename) {
    
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik2/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik2', {
        data: {
            csvURL,
            seriesMapping:[ {
                x: 0, // Year
                y: 1 // Value
            }]
        },
        chart: {
            type: 'column',
            inverted: false
        },
        title: {
            text: 'Korrespondenzstücke und Erwähnungen im Tagebuch'
        },
        xAxis: {
            type: 'category' // Set x-axis type to category
        },
        yAxis: {
            title: {
                text: 'Anzahl'
            },
            labels: {
                formatter: function () {
                    return Math.abs(this.value);
                    // Display absolute value without the leading "-"
                }
            }
        },
         tooltip: {
            formatter: function () {
                return '<b>' + this.series.name + '</b><br/>' +
                    this.x + ': ' + Math.abs(this.y);
                // Display positive values in the tooltip
            }
        },
        series:[ {
            name: 'Korrespondenzstücke',
            color: '#8B5F8F',
        }, {
            name: 'Tagebuch',
            color: '#037A33'
        }]
    });
}

function createStatistik3(csvFilename, correspondenceName) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik3/${csvFilename}`;
    
    // First load the data to process it manually
    fetch(csvURL)
        .then(response => response.text())
        .then(csvText => {
            const lines = csvText.trim().split('\n');
            const processedData = [];
            
            // Process each line (skip header if exists)
            lines.forEach((line, index) => {
                if (index === 0 && isNaN(line.split(',')[1])) return; // Skip header
                
                const values = line.split(',');
                const year = values[0];
                const val1 = parseInt(values[1]) || 0; // von Schnitzler
                const val2 = parseInt(values[2]) || 0; // von Schnitzler Umfeld  
                const val3 = parseInt(values[3]) || 0; // an Schnitzler
                const val4 = parseInt(values[4]) || 0; // an Schnitzler Umfeld
                
                processedData.push({
                    year: year,
                    val1: val1, // von Schnitzler direkt
                    val2: val2, // von Schnitzler Umfeld
                    val3: val3, // an Schnitzler direkt
                    val4: val4, // an Schnitzler Umfeld
                    negativePart: -(val1 + val2), // Combined negative (below x-axis)
                    positivePart: val3 + val4      // Combined positive (above x-axis)
                });
            });
            
            // Create the chart with processed data
            window.processedDataForTooltipStat3 = processedData; // Global scope for tooltip access
            const chart = Highcharts.chart('statistik3', {
                chart: {
                    type: 'column'
                },
                title: {
                    text: 'Textmenge der Korrespondenzstücke'
                },
                xAxis: {
                    categories: processedData.map(d => d.year)
                },
                yAxis: {
                    title: {
                        text: 'Zeichenanzahl'
                    },
                    labels: {
                        formatter: function () {
                            return Math.abs(this.value);
                        }
                    }
                },
                plotOptions: {
                    column: {
                        stacking: 'normal',
                        groupPadding: 0.1,
                        pointPadding: 0.1
                    }
                },
                tooltip: {
                    formatter: function () {
                        const year = this.x;
                        const dataPoint = window.processedDataForTooltipStat3.find(d => d.year == year);
                        
                        if (!dataPoint) {
                            return '<b>' + this.series.name + '</b><br/>' + year + ': ' + Math.abs(this.y);
                        }
                        
                        let tooltipContent = '<b>' + year + '</b><br/>';
                        
                        // Von Schnitzler Sektion (negative Werte)
                        tooltipContent += '<br/><b>Von Schnitzler:</b><br/>';
                        tooltipContent += 'Schnitzler direkt: ' + (dataPoint.val1 || 0) + '<br/>';
                        tooltipContent += 'Schnitzler Umfeld: ' + (dataPoint.val2 || 0) + '<br/>';
                        tooltipContent += '<b>Gesamt: ' + ((dataPoint.val1 || 0) + (dataPoint.val2 || 0)) + '</b><br/>';
                        
                        // An Schnitzler Sektion (positive Werte)
                        tooltipContent += '<br/><b>An Schnitzler:</b><br/>';
                        tooltipContent += 'Schnitzler direkt: ' + (dataPoint.val3 || 0) + '<br/>';
                        tooltipContent += 'Schnitzler Umfeld: ' + (dataPoint.val4 || 0) + '<br/>';
                        tooltipContent += '<b>Gesamt: ' + ((dataPoint.val3 || 0) + (dataPoint.val4 || 0)) + '</b>';
                        
                        return tooltipContent;
                    }
                },
                series: [{
                    name: 'Umfeldbriefe (unten)',
                    color: '#68825b',
                    data: processedData.map(d => -d.val2) // Negative für unteren Balken
                }, {
                    name: 'von Schnitzler',
                    color: '#A63437',
                    data: processedData.map(d => -d.val1) // Negative für unteren Balken
                }, {
                    name: 'Umfeldbriefe',
                    color: '#68825b',
                    data: processedData.map(d => d.val4) // Positive für oberen Balken
                }, {
                    name: 'von ' + (correspondenceName || 'Partner'),
                    color: '#3785A6', 
                    data: processedData.map(d => d.val3) // Positive für oberen Balken
                }]
            });
        });
}

// Grundfarben für statistik4a (7 Kategorien)
var colorMapA = {
    'anderes': '#A63437',        // Rot (dunkel)
    'bild': '#3785A6',           // Blau (dunkel) 
    'brief': '#2E8B57',          // Grün (dunkel)
    'karte': '#FF8C00',          // Orange (dunkel)
    'kartenbrief': '#9932CC',    // Violett (dunkel)
    'telegramm': '#008B8B',      // Türkis (dunkel)
    'umschlag': '#8B4513',       // Braun (dunkel)
    'widmung': '#DC143C'         // Karmesinrot (dunkel)
};

// Farbvariationen für statistik4b basierend auf Grundfarben
var colorMapB = {
    // Anderes - Rot-Familie
    'anderes': '#A63437',
    
    // Bild - Blau-Familie  
    'bild': '#3785A6',
    'bild-fotografie': '#5AA3C7',
    
    // Brief - Grün-Familie
    'brief': '#2E8B57',
    'brief-entwurf': '#4AA371',
    
    // Karte - Orange-Familie
    'karte': '#FF8C00',
    'karte-postkarte': '#FFA500',
    'karte-bildpostkarte': '#FFB84D',
    'karte-briefkarte': '#FFCA80',
    'karte-visitenkarte': '#FFDDB3',
    
    // Kartenbrief - Violett-Familie (bleibt gleich)
    'kartenbrief': '#9932CC',
    
    // Telegramm - Türkis-Familie
    'telegramm': '#008B8B',
    'telegramm-entwurf': '#20B2AA',
    
    // Umschlag - Braun-Familie (bleibt gleich)
    'umschlag': '#8B4513',
    
    // Widmung - Karmesinrot-Familie
    'widmung': '#DC143C',
    'widmung-widmung_umschlag': '#E6476F',
    'widmung-widmung_vorsatzblatt': '#F04A9B',
    'widmung-widmung_schmutztitel': '#C41E3A',
    'widmung-widmung_reihentitelblatt': '#E8537A',
    'widmung-widmung_titelblatt': '#B91831',
    'widmung-widmung_einlegeblatt': '#ED5F8D'
};


function createStatistik4a(csvFilename) {
    const updatedFilename = csvFilename.replace('.csv', '-a.csv');
    
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik4/${updatedFilename}`;
    
    const chart = Highcharts.chart('statistik4a', {
        data: {
            csvURL
        },
        chart: {
            type: 'pie',
            inverted: false
        },
        title: {
            text: 'Textträger'
        },
        plotOptions: {
            pie: {
                innerSize: '60%', // Make it a donut chart
                ignoreHiddenPoint: true,
                dataLabels: {
                    enabled: true,
                    formatter: function() {
                        // Check if the data value is non-zero before displaying the label
                        if (this.y !== 0) {
                            return '<b>' + this.point.name + '</b>: ' + this.y;
                        } else {
                            return null; // Return null to hide the label for zero values
                        }
                    }
                },
                colors: Object.keys(colorMapA).map(seriesName => colorMapA[seriesName])
            }
        }
    });
}

function createStatistik4b(csvFilenameb) {
    const updatedFilenameb = csvFilenameb.replace('.csv', '-b.csv');
    
    const csvURLb = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/statistik4/${updatedFilenameb}`;
    
    const chartb = Highcharts.chart('statistik4b', {
        data: {
            csvURL: csvURLb
        },
        chart: {
            type: 'pie',
            inverted: false
        },
        title: {
            text: 'Detaillierte Textträger'
        },
        plotOptions: {
            pie: {
                innerSize: '60%', // Make it a donut chart
                ignoreHiddenPoint: true,
                dataLabels: {
                    enabled: true,
                    formatter: function() {
                        // Check if the data value is non-zero before displaying the label
                        if (this.y !== 0) {
                            return '<b>' + this.point.name + '</b>: ' + this.y;
                        } else {
                            return null; // Return null to hide the label for zero values
                        }
                    }
                },
                colors: Object.keys(colorMapB).map(seriesName => colorMapB[seriesName])
            }
        }
    });
};

