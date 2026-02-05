// Slideshow state
let currentSlide = 0;
let statsData = null;
const totalSlides = 3;

// Load and display statistics on index page
document.addEventListener('DOMContentLoaded', function() {
    // Load statistics from JSON
    fetch('js-data/gesamtstatistik.json')
        .then(response => response.json())
        .then(data => {
            statsData = data;
            initStatsSlideshow();
            updateTextStatistics();
        })
        .catch(error => {
            console.error('Error loading statistics:', error);
            const container = document.getElementById('stats-content');
            if (container) {
                container.innerHTML = '<p class="text-danger">Fehler beim Laden der Statistiken.</p>';
            }
        });
});

function updateTextStatistics() {
    // No longer needed - values are now rendered server-side in index.xsl
    // using params from params.xsl which are updated by update_params.py
    return;
}

function initStatsSlideshow() {
    showSlide(0);

    // Setup navigation buttons
    document.getElementById('stats-prev-btn').addEventListener('click', () => {
        showSlide(currentSlide > 0 ? currentSlide - 1 : totalSlides - 1);
    });
    document.getElementById('stats-next-btn').addEventListener('click', () => {
        showSlide(currentSlide < totalSlides - 1 ? currentSlide + 1 : 0);
    });

    // Show navigation if we have slides
    document.getElementById('stats-prev-btn').style.display = 'inline-block';
    document.getElementById('stats-next-btn').style.display = 'inline-block';
}

function showSlide(index) {
    currentSlide = index;

    // Update indicator
    document.getElementById('stats-slide-indicator').textContent = (index + 1) + ' / ' + totalSlides;

    // Display the slide
    if (index === 0) {
        displayOverviewSlide();
    } else if (index === 1) {
        displayYearlyChart();
    } else if (index === 2) {
        displayObjectTypeChart();
    }
}

function formatGermanDate(isoDate) {
    if (!isoDate) return '';
    const parts = isoDate.split('-');
    if (parts.length !== 3) return isoDate;
    const day = parseInt(parts[2], 10);
    const month = parseInt(parts[1], 10);
    const year = parts[0];
    const monthNames = ['Jänner', 'Februar', 'März', 'April', 'Mai', 'Juni',
                        'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
    return day + '. ' + monthNames[month - 1] + ' ' + year;
}

function displayOverviewSlide() {
    const container = document.getElementById('stats-content');
    const titleText = document.getElementById('stats-title-text');
    if (!container || !statsData) return;

    // Update title with complete correspondences count
    if (titleText && statsData.complete_correspondences) {
        titleText.textContent = statsData.complete_correspondences + ' vollständige Korrespondenzen';
    }

    // Color mapping for object types
    const colorMap = {
        'anderes': '#A63437',
        'bild': '#3785A6',
        'brief': '#2E8B57',
        'karte': '#FF8C00',
        'kartenbrief': '#9932CC',
        'telegramm': '#008B8B',
        'umschlag': '#8B4513',
        'widmung': '#DC143C'
    };

    // Type name mapping (plural forms)
    const typeNames = {
        'anderes': 'Anderes',
        'bild': 'Bilder',
        'brief': 'Briefe',
        'karte': 'Karten',
        'kartenbrief': 'Kartenbriefe',
        'telegramm': 'Telegramme',
        'umschlag': 'Umschläge',
        'widmung': 'Widmungen'
    };

    let html = '<div style="min-height: 400px;">';

    // First row: Main statistics with large numbers
    html += '<div class="row mb-4">';
    html += '<div class="col-md-3 text-center">';
    html += '<h3 class="display-4">' + (statsData.total_letters || 0) + '</h3>';
    html += '<p class="text-muted">Briefe gesamt</p>';
    html += '</div>';

    html += '<div class="col-md-3 text-center">';
    html += '<h3 class="display-4 theme-color">' + (statsData.schnitzler_sent || 0) + '</h3>';
    html += '<p class="text-muted">von Schnitzler</p>';
    html += '</div>';

    html += '<div class="col-md-3 text-center">';
    html += '<h3 class="display-4 sender-color">' + (statsData.schnitzler_received || 0) + '</h3>';
    html += '<p class="text-muted">an Schnitzler</p>';
    html += '</div>';

    html += '<div class="col-md-3 text-center">';
    html += '<h3 class="display-4 umfeld-color">' + (statsData.third_party || 0) + '</h3>';
    html += '<p class="text-muted">Umfeldbriefe</p>';
    html += '</div>';
    html += '</div>';

    // Second row: Date range and Object types combined
    html += '<div class="row mt-5">';

    // Date range
    if (statsData.date_range && statsData.date_range.earliest && statsData.date_range.latest) {
        html += '<div class="col-md-2 text-center mb-2">';
        html += '<h5 style="color: black; margin-bottom: 0.25rem;">' + formatGermanDate(statsData.date_range.earliest) + '</h5>';
        html += '<p class="text-muted" style="font-size: 0.9rem; margin-bottom: 0;">erstes Stück</p>';
        html += '</div>';
        html += '<div class="col-md-2 text-center mb-2">';
        html += '<h5 style="color: black; margin-bottom: 0.25rem;">' + formatGermanDate(statsData.date_range.latest) + '</h5>';
        html += '<p class="text-muted" style="font-size: 0.9rem; margin-bottom: 0;">letztes Stück</p>';
        html += '</div>';

        // Empty spacer box
        html += '<div class="col-md-2"></div>';
    }

    // Object types (sorted by count descending)
    if (statsData.by_object_type) {
        const types = Object.entries(statsData.by_object_type)
            .sort((a, b) => b[1] - a[1]); // Sort by count descending

        types.forEach(([type, count]) => {
            const color = colorMap[type] || '#999999';
            const name = typeNames[type] || type.charAt(0).toUpperCase() + type.slice(1);
            html += '<div class="col-md-2 text-center mb-2">';
            html += '<h5 style="color: ' + color + '; margin-bottom: 0.25rem;">' + count + '</h5>';
            html += '<p class="text-muted" style="font-size: 0.9rem; margin-bottom: 0;">' + name + '</p>';
            html += '</div>';
        });
    }

    html += '</div>';

    html += '</div>';

    container.innerHTML = html;
}

function displayYearlyChart() {
    const container = document.getElementById('stats-content');
    if (!container) {
        console.error('Container not found');
        return;
    }
    if (!statsData) {
        console.error('Stats data not available');
        return;
    }
    if (!statsData.letters_by_year_and_type) {
        console.error('letters_by_year_and_type not available in stats');
        container.innerHTML = '<p class="text-muted">Jahresdaten werden geladen...</p>';
        return;
    }

    container.innerHTML = '<div id="yearly-chart" style="height: 400px; width: 100%;"></div>';

    // Check if Highcharts is loaded
    if (typeof Highcharts === 'undefined') {
        console.error('Highcharts not loaded');
        container.innerHTML = '<p class="text-danger">Fehler: Highcharts konnte nicht geladen werden.</p>';
        return;
    }

    // Prepare data for Highcharts
    const years = Object.keys(statsData.letters_by_year_and_type).sort();
    const sentData = [];
    const receivedData = [];
    const thirdPartyData = [];

    years.forEach(year => {
        const data = statsData.letters_by_year_and_type[year];
        sentData.push(data.schnitzler_sent || 0);
        receivedData.push(data.schnitzler_received || 0);
        thirdPartyData.push(data.third_party || 0);
    });

    // Create Highcharts stacked column chart
    setTimeout(() => {
        Highcharts.chart('yearly-chart', {
        chart: {
            type: 'column',
            height: 400
        },
        title: {
            text: null
        },
        xAxis: {
            categories: years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Anzahl Briefe'
            },
            stackLabels: {
                enabled: false
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Gesamt: {point.stackTotal}'
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: false
                }
            }
        },
        series: [{
            name: 'von Schnitzler',
            data: sentData,
            color: '#A63437'
        }, {
            name: 'an Schnitzler',
            data: receivedData,
            color: '#1C6E8C'
        }, {
            name: 'Umfeldbriefe',
            data: thirdPartyData,
            color: '#68825b'
        }]
    });
    }, 100);
}

function displayObjectTypeChart() {
    const container = document.getElementById('stats-content');
    if (!container) {
        console.error('Container not found');
        return;
    }
    if (!statsData) {
        console.error('Stats data not available');
        return;
    }
    if (!statsData.letters_by_year_and_object_type) {
        console.error('letters_by_year_and_object_type not available in stats');
        container.innerHTML = '<p class="text-muted">Objekttyp-Daten werden geladen...</p>';
        return;
    }

    container.innerHTML = '<div id="object-type-chart" style="height: 400px; width: 100%;"></div>';

    // Check if Highcharts is loaded
    if (typeof Highcharts === 'undefined') {
        console.error('Highcharts not loaded');
        container.innerHTML = '<p class="text-danger">Fehler: Highcharts konnte nicht geladen werden.</p>';
        return;
    }

    // Color mapping from tocs-statistics.js
    const colorMap = {
        'anderes': '#A63437',
        'bild': '#3785A6',
        'brief': '#2E8B57',
        'karte': '#FF8C00',
        'kartenbrief': '#9932CC',
        'telegramm': '#008B8B',
        'umschlag': '#8B4513',
        'widmung': '#DC143C'
    };

    // Prepare data for Highcharts
    const years = Object.keys(statsData.letters_by_year_and_object_type).sort();

    // Get all unique object types
    const allTypes = new Set();
    years.forEach(year => {
        Object.keys(statsData.letters_by_year_and_object_type[year]).forEach(type => {
            allTypes.add(type);
        });
    });

    // Create series for each object type
    const series = Array.from(allTypes).map(type => {
        const data = years.map(year => {
            return statsData.letters_by_year_and_object_type[year][type] || 0;
        });

        return {
            name: type.charAt(0).toUpperCase() + type.slice(1),
            data: data,
            color: colorMap[type] || '#999999' // Default gray if type not in map
        };
    });

    // Sort series by total count (descending)
    series.sort((a, b) => {
        const sumA = a.data.reduce((acc, val) => acc + val, 0);
        const sumB = b.data.reduce((acc, val) => acc + val, 0);
        return sumB - sumA;
    });

    // Create Highcharts stacked column chart
    setTimeout(() => {
        Highcharts.chart('object-type-chart', {
        chart: {
            type: 'column',
            height: 400
        },
        title: {
            text: null
        },
        xAxis: {
            categories: years,
            labels: {
                rotation: -45,
                style: {
                    fontSize: '11px'
                }
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Anzahl nach Textträger'
            },
            stackLabels: {
                enabled: false
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Gesamt: {point.stackTotal}'
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: false
                }
            }
        },
        series: series
    });
    }, 100);
}

// Deprecated function for backwards compatibility
function displayIndexStats(stats) {
    statsData = stats;
    initStatsSlideshow();
}