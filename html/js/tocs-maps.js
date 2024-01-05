async function createKarte1(title) {
    const updatedFilename = title.replace('.csv', '.json');
    const jsonURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-statistik/main/statistik5/${updatedFilename}`;
    
    const topology = await fetch(
    'https://code.highcharts.com/mapdata/custom/europe.topo.json').then(response => response.json());
    
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
        
        Highcharts.mapChart('container', {
            chart: {
                map: topology // Use the 'topology' variable as the map data
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
                },
                series: {
                    marker: {
                        fillColor: '#FFFFFF',
                        lineWidth: 2,
                        lineColor: Highcharts.getOptions().colors[1]
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
               fillColor: '#A63437',
                fillOpacity: 0.2,
                color: '#0000FF',
                data: flowData
            }]
        });
    });
}