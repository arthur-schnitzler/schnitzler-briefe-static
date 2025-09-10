
// External JavaScript file
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
                    name: 'Umfeldbriefe',
                    color: '#68825b',
                    data: processedData.map(d => -d.val2), // Negative für unteren Balken
                    showInLegend: false
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
                    name: 'Umfeldbriefe',
                    color: '#68825b',
                    data: processedData.map(d => -d.val2), // Negative für unteren Balken
                    showInLegend: false
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

var colorMapA = {
    'anderes': '#A63437',
    'bild': '#3785A6',
    'brief': '#A63437',
    'karte': '#3785A6',
    'kartenbrief': '#FF6347',
    'telegramm': '#7FFFD4',
    'umschlag': '#2E8B57',
    'widmung': '#9932CC',
};

var colorMapB = {
    'anderes': '#A63437',
    'bild': '#3785A6',
    'bild-fotografie': '#FF7F50',
    'brief': '#A63437',
    'brief-entwurf': '#008080',
    'karte': '#3785A6',
    'karte-postkarte': '#1E6C8A',
    'karte-bildpostkarte': '#226F93',
    'karte-briefkarte': '#1C748F',
    'karte-visitenkarte': '#1A6A7E',
    'kartenbrief': '#FF6347',
    'telegramm': '#7FFFD4',
    'telegramm-entwurf': '#FF4500',
    'umschlag': '#2E8B57',
    'widmung': '#9932CC',
    'widmung-widmung_umschlag': '#8531B6',
    'widmung-widmung_vorsatzblatt': '#A233D8',
    'widmung-widmung_schmutztitel': '#6F309F',
    'widmung-widmung_vortitel': '#AC32E1',
    'widmung-widmung_titelblatt': '#77308C'
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

