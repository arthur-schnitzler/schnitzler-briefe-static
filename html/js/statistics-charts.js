// Statistics Charts using Highcharts
// Loads visualization data from JSON files and creates interactive charts

document.addEventListener('DOMContentLoaded', function() {
    // Load all visualization data
    Promise.all([
        fetch('js-data/viz1_all_pieces_by_year.json').then(r => r.json()),
        fetch('js-data/viz2_received_by_schnitzler.json').then(r => r.json()),
        fetch('js-data/viz3_big_five_comparison.json').then(r => r.json()),
        fetch('js-data/viz4_all_text_length.json').then(r => r.json()),
        fetch('js-data/viz5_goldmann_hofmannsthal_length.json').then(r => r.json()),
        fetch('js-data/viz6_diary_mentions.json').then(r => r.json())
    ])
    .then(([viz1, viz2, viz3, viz4, viz5, viz6]) => {
        createChart1(viz1);
        createChart2(viz2);
        createChart3(viz3);
        createChart4(viz4);
        createChart5(viz5);
        createChart6(viz6);
    })
    .catch(error => {
        console.error('Error loading visualization data:', error);
    });
});

// Chart 1: All pieces by year (line chart)
function createChart1(data) {
    const container = document.getElementById('chart1');
    if (!container) return;

    Highcharts.chart('chart1', {
        chart: {
            type: 'line',
            height: 500
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Anzahl Korrespondenzstücke'
            }
        },
        series: [{
            name: 'Korrespondenzstücke',
            data: data.counts,
            color: '#A63437'
        }],
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
        }
    });
}

// Chart 2: Received by Schnitzler (area chart with multiple correspondents)
function createChart2(data) {
    const container = document.getElementById('chart2');
    if (!container) return;

    // Prepare series data
    const series = data.correspondents.map(corr => ({
        name: corr.name,
        data: corr.counts
    }));

    Highcharts.chart('chart2', {
        chart: {
            type: 'area',
            height: 600
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Anzahl Briefe'
            }
        },
        plotOptions: {
            area: {
                stacking: 'normal',
                lineColor: '#666666',
                lineWidth: 1,
                marker: {
                    enabled: false
                }
            }
        },
        series: series,
        credits: {
            enabled: false
        }
    });
}

// Chart 3: Big Five comparison (line chart)
function createChart3(data) {
    const container = document.getElementById('chart3');
    if (!container) return;

    // Color mapping for the big five
    const colorMap = {
        'Bahr': '#FF6384',
        'Beer-Hofmann': '#36A2EB',
        'Goldmann': '#FFCE56',
        'Hofmannsthal': '#4BC0C0',
        'Salten': '#9966FF'
    };

    const series = data.correspondents.map(corr => ({
        name: corr.name,
        data: corr.counts,
        color: colorMap[corr.name] || undefined
    }));

    Highcharts.chart('chart3', {
        chart: {
            type: 'line',
            height: 500
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Anzahl Briefe'
            }
        },
        series: series,
        credits: {
            enabled: false
        }
    });
}

// Chart 4: All text length (line chart)
function createChart4(data) {
    const container = document.getElementById('chart4');
    if (!container) return;

    Highcharts.chart('chart4', {
        chart: {
            type: 'line',
            height: 500
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Textlänge (Zeichen)'
            }
        },
        series: [{
            name: 'Textlänge',
            data: data.text_lengths,
            color: '#A63437'
        }],
        legend: {
            enabled: false
        },
        credits: {
            enabled: false
        }
    });
}

// Chart 5: Goldmann vs Hofmannsthal length comparison (line chart)
function createChart5(data) {
    const container = document.getElementById('chart5');
    if (!container) return;

    Highcharts.chart('chart5', {
        chart: {
            type: 'line',
            height: 500
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Textlänge (Zeichen)'
            }
        },
        series: [{
            name: 'Goldmann',
            data: data.goldmann,
            color: '#FFCE56'
        }, {
            name: 'Hofmannsthal',
            data: data.hofmannsthal,
            color: '#4BC0C0'
        }],
        credits: {
            enabled: false
        }
    });
}

// Chart 6: Diary mentions (combination chart with letters and diary mentions)
function createChart6(data) {
    const container = document.getElementById('chart6');
    if (!container) return;

    // Build series from the data structure
    const series = [];

    // Goldmann letters
    series.push({
        name: 'Goldmann (Briefe)',
        data: data.goldmann.letters,
        type: 'column',
        color: '#FFCE56'
    });

    // Goldmann diary mentions (if available)
    if (data.goldmann.diary_mentions && data.goldmann.diary_mentions.length > 0) {
        series.push({
            name: 'Goldmann (Tagebuch)',
            data: data.goldmann.diary_mentions,
            type: 'line',
            color: '#FFA500'
        });
    }

    // Hofmannsthal letters
    series.push({
        name: 'Hofmannsthal (Briefe)',
        data: data.hofmannsthal.letters,
        type: 'column',
        color: '#4BC0C0'
    });

    // Hofmannsthal diary mentions (if available)
    if (data.hofmannsthal.diary_mentions && data.hofmannsthal.diary_mentions.length > 0) {
        series.push({
            name: 'Hofmannsthal (Tagebuch)',
            data: data.hofmannsthal.diary_mentions,
            type: 'line',
            color: '#20B2AA'
        });
    }

    Highcharts.chart('chart6', {
        chart: {
            height: 500
        },
        title: {
            text: data.title
        },
        xAxis: {
            categories: data.years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            title: {
                text: 'Anzahl'
            }
        },
        plotOptions: {
            column: {
                grouping: true
            }
        },
        series: series,
        credits: {
            enabled: false
        }
    });
}
