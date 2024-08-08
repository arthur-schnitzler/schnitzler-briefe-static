async function createKarte1() {
    const mapDataUrl = 'https://code.highcharts.com/mapdata/custom/world.topo.json';
    const csvUrl = 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/postwege_weights_directed/postwege_weights_directed.csv';

    const topology = await fetch(mapDataUrl).then(response => response.json());
    console.log("Topology Data:", topology);

    const csvData = await fetch(csvUrl).then(response => response.text());
    console.log("CSV Data:", csvData);

    const processData = (csv) => {
        const lines = csv.split('\n');
        const result = {
            locations: new Map(),
            connections: []
        };

        const splitCSVLine = (line) => {
            const regex = /,(?=(?:(?:[^"]*"){2})*[^"]*$)/;
            return line.split(regex).map(item => item.replace(/^"|"$/g, ''));
        };

        lines.slice(1).forEach((line, index) => {
            const columns = splitCSVLine(line);
            console.log(`Processing line ${index + 2}:`, columns);

            if (columns.length < 9) {
                console.log(`Line ${index + 2} is invalid (less than 9 columns).`);
                return;
            }

            const [Source, SourceID, LatLongSender, Target, TargetID, LatLongReceiver, Type, Label, Weight] = columns;
            console.log(`Line ${index + 2} data:`, { Source, SourceID, LatLongSender, Target, TargetID, LatLongReceiver, Type, Label, Weight });

            if (LatLongSender !== 'nicht vorhanden' && LatLongReceiver !== 'nicht vorhanden' && SourceID && TargetID) {
                const senderCoords = LatLongSender.split(' ');
                const receiverCoords = LatLongReceiver.split(' ');

                if (senderCoords.length === 2 && receiverCoords.length === 2) {
                    const senderLat = parseFloat(senderCoords[0].replace(',', '.'));
                    const senderLon = parseFloat(senderCoords[1].replace(',', '.'));
                    const receiverLat = parseFloat(receiverCoords[0].replace(',', '.'));
                    const receiverLon = parseFloat(receiverCoords[1].replace(',', '.'));

                    if (!isNaN(senderLat) && !isNaN(senderLon) && !isNaN(receiverLat) && !isNaN(receiverLon)) {
                        if (Source !== 'Unbekannt' && !result.locations.has(SourceID)) {
                            result.locations.set(SourceID, {
                                id: SourceID,
                                name: Source,
                                lat: senderLat,
                                lon: senderLon
                            });
                            console.log(`Added location: ${Source} (${SourceID})`);
                        }

                        if (Target !== 'Unbekannt' && !result.locations.has(TargetID)) {
                            result.locations.set(TargetID, {
                                id: TargetID,
                                name: Target,
                                lat: receiverLat,
                                lon: receiverLon
                            });
                            console.log(`Added location: ${Target} (${TargetID})`);
                        }

                        result.connections.push({
                            from: SourceID,
                            to: TargetID,
                            weight: parseFloat(Weight)
                        });
                        console.log(`Added connection from ${SourceID} to ${TargetID} with weight ${Weight}`);
                    } else {
                        console.log(`Line ${index + 2} has invalid coordinates.`);
                    }
                } else {
                    console.log(`Line ${index + 2} has invalid coordinate format.`);
                }
            } else {
                console.log(`Line ${index + 2} has invalid data points.`);
            }
        });

        return result;
    };

    const data = processData(csvData);
    console.log("Processed Data:", data);

    const cityData = Array.from(data.locations.values()).map(location => ({
        id: location.id,
        lat: location.lat,
        lon: location.lon,
        name: location.name
    }));

    const combinedWeights = {};
    data.connections.forEach(connection => {
        const key = `${connection.from}-${connection.to}`;
        const reverseKey = `${connection.to}-${connection.from}`;
        if (combinedWeights[key]) {
            combinedWeights[key].weight += connection.weight;
        } else if (combinedWeights[reverseKey]) {
            combinedWeights[reverseKey].weight += connection.weight;
        } else {
            combinedWeights[key] = {
                from: connection.from,
                to: connection.to,
                weight: connection.weight
            };
        }
    });

    const createFlowData = () => {
        return Object.values(combinedWeights).map(connection => {
            const fromLocation = data.locations.get(connection.from);
            const toLocation = data.locations.get(connection.to);
            if (fromLocation && toLocation) {
                return {
                    from: {
                        lat: fromLocation.lat,
                        lon: fromLocation.lon
                    },
                    to: {
                        lat: toLocation.lat,
                        lon: toLocation.lon
                    },
                    weight: connection.weight,
                    tooltip: `${fromLocation.name} → ${toLocation.name}: ${connection.weight}`,
                    lineWidth: Math.max(0.1, Math.min(connection.weight, 1)) // Adjust the scaling as needed
                };
            } else {
                console.log(`Invalid connection: from ${connection.from} to ${connection.to}`);
                return null;
            }
        }).filter(item => item !== null);
    };

    let flowData = createFlowData();

    console.log("City Data:", cityData);
    console.log("Flow Data:", flowData);

    const chart = Highcharts.mapChart('container', {
        chart: {
            map: topology,
            events: {
                redraw: debounce(function () {
                    flowData = createFlowData();
                    chart.get('flowmap').setData(flowData, true, false, false);
                }, 200)
            }
        },
        title: {
            text: null
        },
        exporting: {
            enabled: false, // Disable exporting
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
                    headerFormat: '<b>{point.name}</b>',
                    pointFormat: '<b>{point.name}</b>'
                },
                states: {
                    hover: {
                        enabled: true,
                        halo: {
                            size: 9
                        }
                    }
                },
                point: {
                    events: {
                        click: function () {
                            window.open(`https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${this.id}.html`, '_blank');
                        }
                    }
                }
            },
            flowmap: {
                minWidth: 0.1,
                maxWidth: 100,
                growTowards: true,
                markerEnd: {
                    width: '50%',
                    height: '50%'
                },
                fillColor: '#8B5F8F',
                fillOpacity: 1,
                color: '#8B5F8F',
                states: {
                    hover: {
                        enabled: true,
                        color: '#8B5F8F',
                        halo: {
                            size: 0
                        }
                    },
                    inactive: {
                        opacity: 1
                    }
                },
                tooltip: {
                    headerFormat: '',
                    pointFormat: '{point.tooltip}'
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
            id: 'world',
            name: 'Cities',
            dataLabels: {
                format: '{point.name}'
            },
            data: cityData,
            marker: {
                fillColor: '#ffaa00',
                lineWidth: 1,
                lineColor: '#ffaa00'
            }
        }, 
        {
            type: 'flowmap',
            id: 'flowmap',
            name: 'Korrespondenzstücke',
            accessibility: {
                description: 'Landkarte mit Pfeilen zwischen Versand- und Empfangsort'
            },
            data: flowData,
            lineWidth: '{point.lineWidth}' // This binds the lineWidth to the point's lineWidth property
        }]
    });

    console.log("Highcharts configuration complete.");

    // Debounce function to limit the rate at which a function can fire
    function debounce(func, wait) {
        let timeout;
        return function (...args) {
            const context = this;
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(context, args), wait);
        };
    }
}

createKarte1();
