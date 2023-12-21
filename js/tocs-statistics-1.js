// External JavaScript file
function createChartFromXSLT(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik1/${csvFilename}`;
    
    const chart = Highcharts.chart('container', {
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
