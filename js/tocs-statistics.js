function createStatistik5() {
  (async () => {
    const topology = await fetch(
      'https://code.highcharts.com/mapdata/custom/europe.topo.json'
    ).then(response => response.json());

    Highcharts.mapChart('statistik5', {
      chart: {
        map: topology
      },
      title: {
        text: 'Highmaps basic flowmap demo'
      },
      subtitle: {
        text: 'Highcharts Maps flow map'
      },
      mapNavigation: {
        enabled: true
      },
      legend: {
        enabled: false
      },
      accessibility: {
        point: {
          valueDescriptionFormat: '{xDescription}.'
        }
      },
      plotOptions: {
        mappoint: {
          tooltip: {
            headerFormat: '{point.point.id}<br>',
            pointFormat: 'Lat: {point.lat} Lon: {point.lon}'
          }
        }
      },
      series: [{
        name: 'Basemap',
        showInLegend: false,
        states: {
          inactive: {
            enabled: false
          }
        }
      }, {
        type: 'mappoint',
        id: 'europe',
        name: 'Cities',
        dataLabels: {
          format: '{point.id}'
        },
        data: [{
          id: 'Oslo',
          lat: 59.91,
          lon: 10.76
        }, {
          id: 'Warszawa',
          lat: 52.17,
          lon: 20.97
        }, {
          id: 'Paris',
          lat: 48.73,
          lon: 2.37
        }, {
          id: 'Roma',
          lat: 41.8,
          lon: 12.6
        }, {
          id: 'Madrid',
          lat: 40.47,
          lon: -3.57
        }, {
          id: 'Dublin',
          lat: 53.43,
          lon: -6.24
        }, {
          id: 'Helsinki',
          lat: 60.32,
          lon: 24.97
        }, {
          id: 'Budapest',
          lat: 47.43,
          lon: 19.26
        }, {
          id: 'Sofia',
          lat: 42.69,
          lon: 23.4
        }]
      }, {
        type: 'flowmap',
        name: 'Flow route',
        accessibility: {
          description: 'This is a demonstration of the flowmap using weighted links.'
        },
        linkedTo: ':previous',
        minWidth: 5,
        maxWidth: 15,
        growTowards: true,
        markerEnd: {
          width: '50%',
          height: '50%'
        },
        fillColor: '#31c2cc',
        fillOpacity: 0.2,
        color: '#0000FF',
        data: [{
          from: 'Oslo',
          to: 'Helsinki',
          weight: 20,
          markerEnd: {
            width: '70%',
            height: '70%'
          }
        }, {
          from: 'Oslo',
          to: 'Dublin',
          weight: 70,
          fillOpacity: 0.7
        }, {
          from: 'Warszawa',
          to: 'Helsinki',
          weight: 10
        }, {
          from: 'Warszawa',
          to: 'Paris',
          weight: 5
        }, {
          from: 'Warszawa',
          to: 'Madrid',
          weight: 20
        }, {
          from: 'Warszawa',
          to: 'Budapest',
          weight: 0.1
        }, {
          from: 'Warszawa',
          to: 'Sofia',
          weight: 60,
          growTowards: true,
          fillColor: '#1cd635',
          fillOpacity: 0.4
        }, {
          from: 'Warszawa',
          to: 'Roma',
          weight: 2,
          markerEnd: {
            width: 14,
            height: 24
          }
        }]
      }]
    });
  })();
}

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

