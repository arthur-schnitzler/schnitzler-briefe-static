// Eine CSV-Zeile ist eine Etappe eines Postwegs (z.B. Versand -> Übermittlung), nicht
// zwingend Versand -> Empfang; mehrstufige Briefe liefern mehrere Zeilen (siehe
// schnitzler-briefe-charts/netzwerke/postwege_weights_directed/postwege_weights_directed.xsl).
//
// Leaflet statt Highcharts: Highcharts' flowmap-Modul zeichnet pro Kante einen animierten,
// gekrümmten Pfeil und baute bei jedem Zoom/Pan-Redraw alle ~900 Kanten neu auf (spürbar
// langsam). Leaflet muss beim Zoomen/Verschieben nichts neu berechnen (native Reprojektion
// der Vektor-Layer) und zeichnet mit dem Canvas-Renderer auch hunderte Linien nahezu
// augenblicklich.
async function createKarte1() {
    const csvUrl = 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/postwege_weights_directed/postwege_weights_directed.csv';
    const csvData = await fetch(csvUrl).then(response => response.text());

    const processData = (csv) => {
        const lines = csv.split('\n');
        const locations = new Map();
        const connections = [];

        const splitCSVLine = (line) => {
            const regex = /,(?=(?:(?:[^"]*"){2})*[^"]*$)/;
            return line.split(regex).map(item => item.replace(/^"|"$/g, ''));
        };

        lines.slice(1).forEach((line) => {
            const columns = splitCSVLine(line);
            if (columns.length < 9) return;

            const [Source, SourceID, LatLongSender, Target, TargetID, LatLongReceiver, , , Weight] = columns;
            if (LatLongSender === 'nicht vorhanden' || LatLongReceiver === 'nicht vorhanden' || !SourceID || !TargetID) return;

            const [senderLat, senderLon] = LatLongSender.split(' ').map(coord => parseFloat(coord.replace(',', '.')));
            const [receiverLat, receiverLon] = LatLongReceiver.split(' ').map(coord => parseFloat(coord.replace(',', '.')));

            if (!isNaN(senderLat) && !isNaN(senderLon) && !isNaN(receiverLat) && !isNaN(receiverLon)) {
                if (Source !== 'Unbekannt' && !locations.has(SourceID)) {
                    locations.set(SourceID, { id: SourceID, name: Source, lat: senderLat, lon: senderLon });
                }
                if (Target !== 'Unbekannt' && !locations.has(TargetID)) {
                    locations.set(TargetID, { id: TargetID, name: Target, lat: receiverLat, lon: receiverLon });
                }
                connections.push({ from: SourceID, to: TargetID, weight: parseFloat(Weight) });
            }
        });

        return { locations, connections };
    };

    const data = processData(csvData);

    const map = L.map('container', { preferCanvas: true }).setView([48, 16], 4);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&#169; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 18
    }).addTo(map);

    const linesLayer = L.layerGroup().addTo(map);
    const citiesLayer = L.layerGroup().addTo(map);

    // Zeichnet Kanten + Ortspunkte neu; wird initial und bei gefilterter Tabelle aufgerufen.
    function render(connections) {
        linesLayer.clearLayers();
        citiesLayer.clearLayers();

        // Gegenrichtung je Kante einmal vorab nachschlagbar machen (O(n) statt O(n²) pro Redraw).
        const weightByPair = new Map();
        connections.forEach(c => weightByPair.set(c.from + '|' + c.to, c.weight));

        connections.forEach(c => {
            const from = data.locations.get(c.from);
            const to = data.locations.get(c.to);
            if (!from || !to) return;
            const reverseWeight = weightByPair.get(c.to + '|' + c.from) || 0;
            L.polyline([[from.lat, from.lon], [to.lat, to.lon]], {
                color: '#8B5F8F',
                weight: Math.max(0.5, Math.min(c.weight / 3, 4)),
                opacity: 0.45
            }).addTo(linesLayer).bindTooltip(
                `${from.name} → ${to.name}: ${c.weight}<br>${to.name} → ${from.name}: ${reverseWeight}`
            );
        });

        const locationCounts = new Map();
        connections.forEach(c => {
            if (!locationCounts.has(c.from)) locationCounts.set(c.from, { sourceCount: 0, targetCount: 0 });
            if (!locationCounts.has(c.to)) locationCounts.set(c.to, { sourceCount: 0, targetCount: 0 });
            locationCounts.get(c.from).sourceCount += c.weight;
            locationCounts.get(c.to).targetCount += c.weight;
        });

        let maxWeight = 1;
        locationCounts.forEach(counts => { maxWeight = Math.max(maxWeight, counts.sourceCount + counts.targetCount); });

        locationCounts.forEach((counts, id) => {
            const loc = data.locations.get(id);
            if (!loc) return;
            const w = counts.sourceCount + counts.targetCount;
            L.circleMarker([loc.lat, loc.lon], {
                radius: 2 + (w / maxWeight) * 10,
                fillColor: '#ffaa00',
                color: '#fff',
                weight: 1,
                fillOpacity: 0.9
            }).addTo(citiesLayer)
                .bindTooltip(`<b>${loc.name}</b><br>Ausgehende Etappen: ${counts.sourceCount}<br>Eingehende Etappen: ${counts.targetCount}`)
                .on('click', () => window.open(`https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${id}.html`, '_blank'));
        });
    }

    render(data.connections);

    // Schnittstelle für die gefilterte Tabelle auf der Postwege-Seite (siehe correspaction.xsl)
    window.postwegeMap = {
        setConnections(connections) {
            render(connections);
            const pts = [];
            connections.forEach(c => {
                const from = data.locations.get(c.from);
                const to = data.locations.get(c.to);
                if (from) pts.push([from.lat, from.lon]);
                if (to) pts.push([to.lat, to.lon]);
            });
            if (pts.length) map.fitBounds(L.latLngBounds(pts).pad(0.2));
        },
        reset() {
            render(data.connections);
        }
    };
}

createKarte1();
