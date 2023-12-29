// External JavaScript file
function createStatistik1(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik1/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik1', {
        data: {
            csvURL,
            seriesMapping: [{
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
                formatter: function() {
                    return Math.abs(this.value); // Display absolute value without the leading "-"
                }
            }
        },
        series: [{
            name: 'von Schnitzler',
            color: '#A63437',
        },{
            name: 'an Schnitzler',
            color: '#3785A6'}]
    });
}

function createStatistik2(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik2/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik2', {
        data: {
            csvURL,
            seriesMapping: [{
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
                formatter: function() {
                    return Math.abs(this.value); // Display absolute value without the leading "-"
                }
            }
        },
        series: [{
            name: 'Korrespondenzstücke',
            color: '#8B5F8F',
        },{
            name: 'Tagebuch',
            color: '#037A33'}]
    });
}

function createStatistik3(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik3/${csvFilename}`;
    
    const chart = Highcharts.chart('statistik3', {
        data: {
            csvURL,
            seriesMapping: [{
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
                formatter: function() {
                    return Math.abs(this.value); // Display absolute value without the leading "-"
                }
            }
        },
        series: [{
            name: 'von Schnitzler',
            color: '#A63437',
        },{
            name: 'an Schnitzler',
            color: '#3785A6'}]
    });
}
