
// External JavaScript file
function createStatistik1(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik1/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik1', {
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
            text: 'Anzahl der Korrespondenzstücke'
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
            name: 'von Schnitzler',
            color: '#A63437',
        }, {
            name: 'an Schnitzler',
            color: '#3785A6'
        }]
    });
}

function createStatistik2(csvFilename) {
    
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik2/${csvFilename}`;
    
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

function createStatistik3(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik3/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik3', {
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
            text: 'Textmenge der Korrespondenzstücke'
        },
        xAxis: {
            type: 'category' // Set x-axis type to category
        },
        yAxis: {
            title: {
                text: 'Zeichenanzahl'
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
            name: 'von Schnitzler',
            color: '#A63437',
        }, 
        {
            name: 'an Schnitzler',
            color: '#3785A6'
        }]
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
    
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik4/${updatedFilename}`;
    
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
    
    const csvURLb = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik4/${updatedFilenameb}`;
    
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

