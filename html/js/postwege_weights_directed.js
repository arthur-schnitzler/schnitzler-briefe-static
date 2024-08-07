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

    const flowData = data.connections.map(connection => {
        const fromLocation = data.locations.get(connection.from);
        const toLocation = data.locations.get(connection.to);
        if (fromLocation && toLocation) {
            return {
                id: `${connection.from}-${connection.to}`,
                geometry: {
                    type: 'LineString',
                    coordinates: [
                        [fromLocation.lon, fromLocation.lat],
                        [toLocation.lon, toLocation.lat]
                    ]
                },
                properties: {
                    from: fromLocation.name,
                    to: toLocation.name,
                    weight: connection.weight
                }
            };
        } else {
            console.log(`Invalid connection: from ${connection.from} to ${connection.to}`);
            return null;
        }
    }).filter(item => item !== null);

    console.log("City Data:", cityData);
    console.log("Flow Data:", flowData);

    Highcharts.mapChart('container', {
        chart: {
            map: topology
        },
        title: {
            text: null
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
            mapline: {
                color: '#8B5F8F',
                lineWidth: 2,
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
                    pointFormat: '{point.properties.from} -> {point.properties.to}: {point.properties.weight}'
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
                lineWidth: 2,
                lineColor: '#ffaa00'
            }
        }, {
            type: 'mapline',
            name: 'Korrespondenzstücke',
            accessibility: {
                description: 'Landkarte mit Linien zwischen Versand- und Empfangsort'
            },
            color: '#8B5F8F',  // Always use this color
            data: flowData,
            lineWidth: 2,
            states: {
                hover: {
                    enabled: true,
                    color: '#8B5F8F',
                    brightness: 0
                },
                inactive: {
                    opacity: 1
                }
            }
        }]
    });
}

createKarte1();
