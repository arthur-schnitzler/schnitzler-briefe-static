async function createKarte1(title) {
     let mapDataUrl;

    if (title.includes("pmb11485.") || title.includes("pmb2167.")) {
        mapDataUrl = 'https://code.highcharts.com/mapdata/custom/world.topo.json';
    } else {
        mapDataUrl = 'https://code.highcharts.com/mapdata/custom/europe.topo.json';
    }

    const topology = await fetch(mapDataUrl).then(response => response.json());

    const jsonURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/karte1/${title}.json`;
    
    
    fetch(jsonURL).then(response => response.json()).then(jsonData => {
        const processData = (data) => {
            const result = {
                locations:[],
                connections:[]
            };
            
            // Store locationsc
            data.series[0].data.forEach((item) => {
                result.locations.push({
                    id: item.id,
                    lat: item.lat,
                    lon: item.lon
                });
            });
            
            // Store connections
            data.series[1].data.forEach((item) => {
                result.connections.push({
                    from: item. from,
                    to: item.to,
                    weight: item.weight
                });
            });
            
            return result;
        };
        
        const flowData = jsonData.series[1].data.map(item => {
            return {
                from: item. from,
                to: item.to,
                weight: item.weight
            };
        });
        
        const cityData = processData(jsonData).locations;
        
        console.log(cityData);
        
        Highcharts.mapChart('karte1', {
            chart: {
                map: topology // Use the 'topology' variable as the map data
            },
            
            title: {
                text: 'Versandwege aller Korrespondenzstücke'
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
                        pointFormat: 'Länge: {point.lat} Breite: {point.lon}'
                    }
                },
                series: {
                    marker: {
                        fillColor: '#ffaa00',
                        lineWidth: 2,
                        lineColor: '#ffaa00'
                    }
                },
                mapline: {
                    colorByPoint: true
                }
            },
            
            series:[ {
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
                data: cityData
            }, {
                type: 'flowmap',
                name: 'Korrespondenzstücke',
                accessibility: {
                    description: 'Landkarte mit Pfeilen zwischen Versand- und Empfangsort'
                },
                linkedTo: ':previous',
                minWidth: 1,
                maxWidth: 25,
                growTowards: true,
                markerEnd: {
                    width: '50%',
                    height: '50%'
                },
                fillColor: '#8B5F8F',
                fillOpacity: 1,
                color: '#8B5F8F',
                data: flowData
            }]
        });
    });
}