async function createKarte1() {
    const mapDataUrl = 'https://code.highcharts.com/mapdata/custom/world.topo.json';
    const csvUrl = 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/postwege_weights_directed/postwege_weights_directed.csv';

    const topology = await fetch(mapDataUrl).then(response => response.json());
    const csvData = await fetch(csvUrl).then(response => response.text());

    console.log("Topology and CSV data fetched.");

    const processData = (csv) => {
        const lines = csv.split('\n');
        const locations = new Map();
        const connections = [];

        const splitCSVLine = (line) => {
            const regex = /,(?=(?:(?:[^"]*"){2})*[^"]*$)/;
            return line.split(regex).map(item => item.replace(/^"|"$/g, ''));
        };

        lines.slice(1).forEach((line, index) => {
            const columns = splitCSVLine(line);
            if (columns.length < 9) return;

            const [Source, SourceID, LatLongSender, Target, TargetID, LatLongReceiver, Type, Label, Weight] = columns;
            if (LatLongSender === 'nicht vorhanden' || LatLongReceiver === 'nicht vorhanden' || !SourceID || !TargetID) return;

            const [senderLat, senderLon] = LatLongSender.split(' ').map(coord => parseFloat(coord.replace(',', '.')));
            const [receiverLat, receiverLon] = LatLongReceiver.split(' ').map(coord => parseFloat(coord.replace(',', '.')));

            if (!isNaN(senderLat) && !isNaN(senderLon) && !isNaN(receiverLat) && !isNaN(receiverLon)) {
                if (Source !== 'Unbekannt' && !locations.has(SourceID)) {
                    locations.set(SourceID, { id: SourceID, name: Source, lat: senderLat, lon: senderLon, weight: 0, sourceCount: 0, targetCount: 0 });
                }
                if (Target !== 'Unbekannt' && !locations.has(TargetID)) {
                    locations.set(TargetID, { id: TargetID, name: Target, lat: receiverLat, lon: receiverLon, weight: 0, sourceCount: 0, targetCount: 0 });
                }

                const weightValue = parseFloat(Weight);
                if (locations.has(SourceID)) {
                    const source = locations.get(SourceID);
                    source.weight += weightValue;
                    source.sourceCount += weightValue;
                }
                if (locations.has(TargetID)) {
                    const target = locations.get(TargetID);
                    target.weight += weightValue;
                    target.targetCount += weightValue;
                }

                connections.push({ id: `${SourceID}-${TargetID}-${index}`, from: SourceID, to: TargetID, weight: weightValue });
            }
        });

        return { locations, connections };
    };

    const data = processData(csvData);
    console.log("Data processed:", data);

    const maxWeight = Math.max(...Array.from(data.locations.values()).map(loc => loc.weight));
    let cityData = Array.from(data.locations.values()).map(location => ({
        id: location.id,
        lat: location.lat,
        lon: location.lon,
        name: location.name,
        marker: { radius: 2 + (location.weight / maxWeight) * 20 },
        color: '#ffaa00',
        tooltip: `<b>${location.name}</b><br>Sendeort: ${location.sourceCount}<br>Empfangsort: ${location.targetCount}`
    }));

    let flowData = data.connections.map(connection => {
        const fromLocation = data.locations.get(connection.from);
        const toLocation = data.locations.get(connection.to);
        const reverseConnection = data.connections.find(conn => conn.from === connection.to && conn.to === connection.from);
        const reverseWeight = reverseConnection ? reverseConnection.weight : 0;

        return {
            id: connection.id,
            from: { id: connection.from, lat: fromLocation.lat, lon: fromLocation.lon },
            to: { id: connection.to, lat: toLocation.lat, lon: toLocation.lon },
            weight: connection.weight,
            lineWidth: Math.max(0.1, Math.min(connection.weight, 2)),
            color: '#8B5F8F',
            tooltip: `${fromLocation.name} → ${toLocation.name}: ${connection.weight}<br>${toLocation.name} → ${fromLocation.name}: ${reverseWeight}`
        };
    });

    console.log("Initial cityData and flowData generated.");

    const chart = Highcharts.mapChart('container', {
        chart: {
            map: topology,
            events: {
                redraw: debounce(() => {
                    console.log("Chart redrawn.");
                    updateFlowData();
                    chart.get('flowmap').setData(flowData, true, false, false);
                    restoreHighlightState();
                }, 200)
            }
        },
        title: { text: null },
        exporting: { enabled: false },
        mapNavigation: { enabled: true },
        legend: { enabled: false },
        accessibility: {
            point: { valueDescriptionFormat: '{xDescription}.' }
        },
        plotOptions: {
            mappoint: {
                tooltip: { headerFormat: '', pointFormat: '{point.tooltip}' },
                states: { hover: { enabled: true, halo: { size: 9 } } },
                point: {
                    events: {
                        click: function () {
                            window.open(`https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${this.id}.html`, '_blank');
                        },
                        mouseOver: throttle(function () {
                            highlightNodesAndConnections(this.id, true);
                        }, 100),
                        mouseOut: throttle(function () {
                            highlightNodesAndConnections(this.id, false);
                        }, 100)
                    }
                }
            },
            flowmap: {
                minWidth: 0.1,
                maxWidth: 100,
                growTowards: true,
                markerEnd: { width: '50%', height: '50%' },
                color: '#8B5F8F',
                fillOpacity: 1,
                states: {
                    hover: { enabled: false },
                    inactive: { opacity: 1 }
                },
                tooltip: { headerFormat: '', pointFormat: '{point.tooltip}' },
                point: {
                    events: {
                        mouseOver: throttle(function () {
                            highlightConnection(this.options, true);
                        }, 100),
                        mouseOut: throttle(function () {
                            highlightConnection(this.options, false);
                        }, 100)
                    }
                }
            }
        },
        mapView: { center: [10, 20], zoom: 2.1 },
        series: [
            { name: 'Basemap', showInLegend: false, states: { inactive: { enabled: false } } },
            { type: 'flowmap', id: 'flowmap', name: 'Connections', data: flowData },
            { type: 'mappoint', id: 'world', name: 'Cities', dataLabels: { format: '{point.name}' }, data: cityData }
        ]
    });

    let highlightedNodes = new Set();
    let highlightedConnections = new Set();

    function updateFlowData() {
        console.log("Updating flow data.");
        flowData = data.connections.map(connection => {
            const fromLocation = data.locations.get(connection.from);
            const toLocation = data.locations.get(connection.to);
            const reverseConnection = data.connections.find(conn => conn.from === connection.to && conn.to === connection.from);
            const reverseWeight = reverseConnection ? reverseConnection.weight : 0;

            return {
                id: connection.id,
                from: { id: connection.from, lat: fromLocation.lat, lon: fromLocation.lon },
                to: { id: connection.to, lat: toLocation.lat, lon: toLocation.lon },
                weight: connection.weight,
                lineWidth: Math.max(0.1, Math.min(connection.weight, 2)),
                color: '#8B5F8F',
                tooltip: `${fromLocation.name} → ${toLocation.name}: ${connection.weight}<br>${toLocation.name} → ${fromLocation.name}: ${reverseWeight}`
            };
        });
    }

    function highlightNodesAndConnections(nodeId, highlight) {
        const flowmapSeries = chart.get('flowmap');
        const citySeries = chart.get('world');
        const connections = data.connections.filter(conn => conn.from === nodeId || conn.to === nodeId);

        const updateData = (series, idSet, color, markerColor) => {
            series.data.forEach(point => {
                if (idSet.has(point.id)) {
                    point.update({
                        color: highlight ? color : '#8B5F8F',
                        marker: { fillColor: highlight ? markerColor : '#8B5F8F' }
                    }, false);
                }
            });
        };

        const relatedNodeIds = new Set(connections.flatMap(conn => [conn.from, conn.to]));
        relatedNodeIds.add(nodeId);

        updateData(citySeries, relatedNodeIds, 'red', 'red');
        updateData(flowmapSeries, new Set(connections.map(conn => conn.id)), 'red');

        // Perform a single redraw after updates
        chart.redraw(false);

        if (highlight) {
            highlightedNodes.add(nodeId);
            connections.forEach(conn => highlightedConnections.add(conn.id));
        } else {
            highlightedNodes.delete(nodeId);
            connections.forEach(conn => highlightedConnections.delete(conn.id));
        }
    }

    function highlightConnection(connection, highlight) {
        const flowmapSeries = chart.get('flowmap');
        const citySeries = chart.get('world');
        const nodes = [connection.from.id, connection.to.id];

        const updateData = (series, idSet, color, markerColor) => {
            series.data.forEach(point => {
                if (idSet.has(point.id)) {
                    point.update({
                        color: highlight ? color : '#8B5F8F',
                        marker: { fillColor: highlight ? markerColor : '#8B5F8F' }
                    }, false);
                }
            });
        };

        updateData(citySeries, new Set(nodes), 'red', 'red');
        updateData(flowmapSeries, new Set([connection.id]), 'red');

        // Perform a single redraw after updates
        chart.redraw(false);

        if (highlight) {
            highlightedConnections.add(connection.id);
            nodes.forEach(nodeId => highlightedNodes.add(nodeId));
        } else {
            highlightedConnections.delete(connection.id);
            nodes.forEach(nodeId => highlightedNodes.delete(nodeId));
        }
    }

    function restoreHighlightState() {
        highlightedNodes.forEach(nodeId => {
            highlightNodesAndConnections(nodeId, true);
        });
        highlightedConnections.forEach(connectionId => {
            const connection = flowData.find(conn => conn.id === connectionId);
            if (connection) {
                highlightConnection(connection, true);
            }
        });
    }

    function debounce(func, wait) {
        let timeout;
        return function (...args) {
            const context = this;
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(context, args), wait);
        };
    }

    function throttle(func, limit) {
        let lastFunc;
        let lastRan;
        return function (...args) {
            const context = this;
            if (!lastRan) {
                func.apply(context, args);
                lastRan = Date.now();
            } else {
                clearTimeout(lastFunc);
                lastFunc = setTimeout(function () {
                    if ((Date.now() - lastRan) >= limit) {
                        func.apply(context, args);
                        lastRan = Date.now();
                    }
                }, limit - (Date.now() - lastRan));
            }
        };
    }
}

createKarte1();
