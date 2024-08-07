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
                                lon: senderLon,
                                weight: 0, // Initialize weight
                                sourceCount: 0, // Initialize source count
                                targetCount: 0  // Initialize target count
                            });
                            console.log(`Added location: ${Source} (${SourceID})`);
                        }

                        if (Target !== 'Unbekannt' && !result.locations.has(TargetID)) {
                            result.locations.set(TargetID, {
                                id: TargetID,
                                name: Target,
                                lat: receiverLat,
                                lon: receiverLon,
                                weight: 0, // Initialize weight
                                sourceCount: 0, // Initialize source count
                                targetCount: 0  // Initialize target count
                            });
                            console.log(`Added location: ${Target} (${TargetID})`);
                        }

                        const weightValue = parseFloat(Weight);

                        // Update the weight and counts for the source and target locations
                        if (result.locations.has(SourceID)) {
                            result.locations.get(SourceID).weight += weightValue;
                            result.locations.get(SourceID).sourceCount += weightValue;
                        }

                        if (result.locations.has(TargetID)) {
                            result.locations.get(TargetID).weight += weightValue;
                            result.locations.get(TargetID).targetCount += weightValue;
                        }

                        result.connections.push({
                            from: SourceID,
                            to: TargetID,
                            weight: weightValue
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

    const maxWeight = Math.max(...Array.from(data.locations.values()).map(loc => loc.weight));
    const cityData = Array.from(data.locations.values()).map(location => ({
        id: location.id,
        lat: location.lat,
        lon: location.lon,
        name: location.name,
        marker: {
            radius: 4 + (location.weight / maxWeight) * 10 // Scale marker size based on weight
        },
        tooltip: `<b>${location.name}</b><br>Sendeort: ${location.sourceCount}<br>Empfangsort: ${location.targetCount}`
    }));

    const createFlowData = () => {
        const combinedWeights = {};

        data.connections.forEach(connection => {
            const forwardKey = `${connection.from}-${connection.to}`;
            const reverseKey = `${connection.to}-${connection.from}`;

            // Create or update the forward connection
            if (!combinedWeights[forwardKey]) {
                combinedWeights[forwardKey] = {
                    from: connection.from,
                    to: connection.to,
                    forwardWeight: connection.weight,
                    reverseWeight: 0 // Initialize reverse weight
                };
            } else {
                combinedWeights[forwardKey].forwardWeight += connection.weight;
            }

            // Create or update the reverse connection
            if (!combinedWeights[reverseKey]) {
                combinedWeights[reverseKey] = {
                    from: connection.to,
                    to: connection.from,
                    forwardWeight: 0, // Initialize forward weight
                    reverseWeight: connection.weight
                };
            } else {
                combinedWeights[reverseKey].reverseWeight += connection.weight;
            }
        });

        return Object.values(combinedWeights).map(connection => {
            const fromLocation = data.locations.get(connection.from);
            const toLocation = data.locations.get(connection.to);

            if (fromLocation && toLocation) {
                const forwardWeight = connection.forwardWeight;
                const reverseWeight = connection.reverseWeight;

                const tooltip = `
                    ${fromLocation.name} → ${toLocation.name}: ${forwardWeight}<br/>${toLocation.name} → ${fromLocation.name}: ${reverseWeight}
                `.trim();

                return {
                    from: {
                        lat: fromLocation.lat,
                        lon: fromLocation.lon
                    },
                    to: {
                        lat: toLocation.lat,
                        lon: toLocation.lon
                    },
                    weight: forwardWeight + reverseWeight,
                    tooltip: tooltip,
                    lineWidth: Math.max(0.1, Math.min(forwardWeight + reverseWeight, 2)) // Adjust the scaling as needed
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
                redraw: debounce(() => {
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
                    headerFormat: '',
                    pointFormat: '{point.tooltip}'
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
                color: 'rgba(139, 95, 143, 0.5)',
                fillOpacity: 1,
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
        mapView: {
            center: [10, 20], // Set the initial center of the map [longitude, latitude]
            zoom: 2.1 // Set the initial zoom level
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
            type: 'flowmap',
            id: 'flowmap',
            name: 'Korrespondenzstücke',
            accessibility: {
                description: 'Landkarte mit Pfeilen zwischen Versand- und Empfangsort'
            },
            data: flowData,
            lineWidth: '{point.lineWidth}' // This binds the lineWidth to the point's lineWidth property
        }, {
            type: 'mappoint',
            id: 'world',
            name: 'Cities',
            dataLabels: {
                format: '{point.name}'
            },
            data: cityData,
            marker: {
                fillColor: 'rgba(255, 170, 0, 0.3)',
                lineWidth: 0.5,
                lineColor: 'rgba(255, 170, 0, 0.3)',
            }
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
