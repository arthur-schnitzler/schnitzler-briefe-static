// External JavaScript file
function createChartFromXSLT2(csvFilename) {
    const csvURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik2/${csvFilename}`;
    
    const chart = Highcharts.chart('container2', {
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
            color: '#A63437',
        },{
            name: 'Tagebuch',
            color: '#037A33'}]
    });
}
