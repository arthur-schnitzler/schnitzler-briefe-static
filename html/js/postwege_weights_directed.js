// Farbcodierung folgt der Kategorisierung, die auch die Links in der Tabelle auf
// correspaction.xsl einfärbt (theme-color/sender-color/umfeld-color in style.css):
//   Brief von Schnitzler ("as-sender")   -> rot
//   Brief an Schnitzler  ("as-empf")     -> blau
//   Umfeldbrief          ("umfeld")      -> grün
// Diese Kategorie kennt nur die Brief-/Tabellendaten aus correspaction.xsl (Spalte
// "kategorie"), nicht die aggregierte CSV aus schnitzler-briefe-charts (die nur
// Orts-Paare + Gewicht kennt, ohne Bezug zu Schnitzler). Die CSV liefert deshalb nur
// noch die Koordinaten je Ort; Linien und Punkte werden aus den Tabellenzeilen gebaut.
const COLOR_VON_SCHNITZLER = '#A63437';
const COLOR_AN_SCHNITZLER = '#1C6E8C';
const COLOR_UMFELD = '#68825b';

function kategorieFarbe(kategorie) {
    if (kategorie === 'as-empf') return COLOR_AN_SCHNITZLER;
    if (kategorie === 'umfeld') return COLOR_UMFELD;
    return COLOR_VON_SCHNITZLER; // 'as-sender' (default)
}

function hexToRgb(hex) {
    var n = parseInt(hex.replace('#', ''), 16);
    return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 };
}

function rgbToHex(r, g, b) {
    return '#' + [r, g, b].map(function(c) {
        return Math.max(0, Math.min(255, Math.round(c))).toString(16).padStart(2, '0');
    }).join('');
}

// Mischt die Punktfarbe gewichtet, falls ein Ort über verschiedene Briefe hinweg
// mehrere Rollen hatte (z.B. einmal Standort Schnitzlers, in einem anderen Brief
// Aufenthaltsort des Briefpartners).
function blendColor(weights) {
    var total = 0, r = 0, g = 0, b = 0;
    Object.keys(weights).forEach(function(hex) {
        var w = weights[hex];
        var rgb = hexToRgb(hex);
        total += w;
        r += rgb.r * w;
        g += rgb.g * w;
        b += rgb.b * w;
    });
    if (!total) return '#ffaa00';
    return rgbToHex(r / total, g / total, b / total);
}

// Baut aus den Tabellenzeilen (routeids + kategorie je Brief) die Liniensegmente
// und die Ortsrollen für die Punktfarben.
//
// Liniensegmente: jede Etappe eines Briefs (auch Zwischenstationen) bekommt die
// Gesamtfarbe des Briefs (rot/blau/grün je nach Kategorie); gleiche Etappe+Kategorie
// über mehrere Briefe hinweg wird zu einem Gewicht zusammengefasst.
//
// Punktrollen: bei Umfeldbriefen sind alle Stationen grün. Sonst ist die erste
// Station (Sendeort) und letzte Station (Empfangsort) eindeutig Schnitzler bzw.
// Briefpartner (je nach Richtung); Zwischenstationen bekommen die Gesamtfarbe des
// Briefs. Sendeort = Empfangsort (einstufiger Postweg) zählt für beide Rollen.
//
// Mit wienIds (Set der Orts-IDs in Wien) bleiben nur Etappen zwischen zwei verschiedenen
// Orten in Wien übrig, und nur deren Stationen werden zu Punkten. Etappen von oder nach
// außerhalb fallen weg, ebenso Briefe innerhalb ein und desselben Ortes (z.B. Wien -> Wien),
// die keine Verbindung ergeben, die sich zeichnen ließe.
function buildFromRows(rows, wienIds) {
    var segmentWeights = new Map(); // "fromId|toId|color" -> weight
    var pointWeights = new Map();   // ortId -> { farbe: gewicht }

    function addPoint(id, color, weight) {
        if (!id) return;
        if (!pointWeights.has(id)) pointWeights.set(id, {});
        var bucket = pointWeights.get(id);
        bucket[color] = (bucket[color] || 0) + weight;
    }

    rows.forEach(function(data) {
        var kategorie = data.kategorie;
        var lineColor = kategorieFarbe(kategorie);
        var stations = (data.routeids || '').split('|').filter(function(id) { return id; });
        if (!stations.length) return;

        // Stationen, die an einer gezeichneten Etappe beteiligt sind (ohne Wien-Filter alle)
        var used = stations.map(function() { return !wienIds; });

        stations.slice(1).forEach(function(toId, idx) {
            var fromId = stations[idx];
            if (wienIds && !(fromId !== toId && wienIds.has(fromId) && wienIds.has(toId))) return;
            used[idx] = true;
            used[idx + 1] = true;
            var key = fromId + '|' + toId + '|' + lineColor;
            segmentWeights.set(key, (segmentWeights.get(key) || 0) + 1);
        });

        var sendeortFarbe = kategorie === 'as-empf' ? COLOR_AN_SCHNITZLER : COLOR_VON_SCHNITZLER;
        var empfangsortFarbe = kategorie === 'as-empf' ? COLOR_VON_SCHNITZLER : COLOR_AN_SCHNITZLER;

        stations.forEach(function(id, i) {
            if (!used[i]) return;
            if (kategorie === 'umfeld') {
                addPoint(id, COLOR_UMFELD, 1);
                return;
            }
            var isSendeort = i === 0;
            var isEmpfangsort = i === stations.length - 1;
            if (isSendeort) addPoint(id, sendeortFarbe, 1);
            if (isEmpfangsort) addPoint(id, empfangsortFarbe, 1);
            if (!isSendeort && !isEmpfangsort) addPoint(id, lineColor, 1);
        });
    });

    var lineSegments = Array.from(segmentWeights.entries()).map(function(entry) {
        var parts = entry[0].split('|');
        return { from: parts[0], to: parts[1], color: parts[2], weight: entry[1] };
    });

    return { lineSegments: lineSegments, pointWeights: pointWeights };
}

const OVERVIEW_CENTER = [48, 16];
const OVERVIEW_ZOOM = 4;
const WIEN_CENTER = [48.2082, 16.3738];
const WIEN_ZOOM = 13;

async function createKarte1() {
    const csvUrl = 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/postwege_weights_directed/postwege_weights_directed.csv';

    const map = L.map('container', { preferCanvas: true }).setView(OVERVIEW_CENTER, OVERVIEW_ZOOM);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&#169; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 18
    }).addTo(map);

    const linesLayer = L.layerGroup().addTo(map);
    const citiesLayer = L.layerGroup().addTo(map);

    // Ortskoordinaten kommen weiterhin aus der aggregierten CSV aus
    // schnitzler-briefe-charts (dort bereits über listplace.xml aufgelöst);
    // die Kategorisierung selbst kommt aus den Tabellenzeilen dieser Seite.
    const locations = new Map();
    const locationsReady = fetch(csvUrl).then(function(response) { return response.text(); }).then(function(csv) {
        const splitCSVLine = (line) => {
            const regex = /,(?=(?:(?:[^"]*"){2})*[^"]*$)/;
            return line.split(regex).map(item => item.replace(/^"|"$/g, ''));
        };
        csv.split('\n').slice(1).forEach((line) => {
            const columns = splitCSVLine(line);
            if (columns.length < 9) return;
            const [Source, SourceID, LatLongSender, Target, TargetID, LatLongReceiver] = columns;
            if (LatLongSender === 'nicht vorhanden' || LatLongReceiver === 'nicht vorhanden' || !SourceID || !TargetID) return;
            const [senderLat, senderLon] = LatLongSender.split(' ').map(coord => parseFloat(coord.replace(',', '.')));
            const [receiverLat, receiverLon] = LatLongReceiver.split(' ').map(coord => parseFloat(coord.replace(',', '.')));
            if (!isNaN(senderLat) && !isNaN(senderLon) && Source !== 'Unbekannt' && !locations.has(SourceID)) {
                locations.set(SourceID, { id: SourceID, name: Source, lat: senderLat, lon: senderLon });
            }
            if (!isNaN(receiverLat) && !isNaN(receiverLon) && Target !== 'Unbekannt' && !locations.has(TargetID)) {
                locations.set(TargetID, { id: TargetID, name: Target, lat: receiverLat, lon: receiverLon });
            }
        });
    });

    // IDs (ohne "pmb") aller Orte in Wien. correspaction.xsl ermittelt sie aus der
    // located_in_place-Hierarchie in listplace.xml: Wien (pmb50), die Bezirke (pmb51-pmb73)
    // und alle Orte, die einen von ihnen als Vorfahren haben.
    const wienIds = new Set((document.getElementById('container').dataset.wienIds || '').split(' ').filter(Boolean));

    // Zeichnet Liniensegmente + Ortspunkte neu; wird bei jedem Neuaufbau der Karte aufgerufen
    // (initial, bei gefilterter Tabelle, beim Umschalten des Wien-Switches).
    function render(built) {
        linesLayer.clearLayers();
        citiesLayer.clearLayers();

        built.lineSegments.forEach(function(seg) {
            const from = locations.get(seg.from);
            const to = locations.get(seg.to);
            if (!from || !to) return;
            L.polyline([[from.lat, from.lon], [to.lat, to.lon]], {
                color: seg.color,
                weight: Math.max(0.5, Math.min(seg.weight / 3, 4)),
                opacity: 0.55
            }).addTo(linesLayer).bindTooltip(
                `${from.name} → ${to.name}: ${seg.weight}`
            );
        });

        let maxWeight = 1;
        built.pointWeights.forEach(function(weights) {
            const w = Object.values(weights).reduce(function(a, b) { return a + b; }, 0);
            maxWeight = Math.max(maxWeight, w);
        });

        built.pointWeights.forEach(function(weights, id) {
            const loc = locations.get(id);
            if (!loc) return;
            const w = Object.values(weights).reduce(function(a, b) { return a + b; }, 0);
            const tooltipLines = [`<b>${loc.name}</b>`];
            if (weights[COLOR_VON_SCHNITZLER]) tooltipLines.push(`Standort Schnitzler: ${weights[COLOR_VON_SCHNITZLER]}`);
            if (weights[COLOR_AN_SCHNITZLER]) tooltipLines.push(`Aufenthaltsort Briefpartner: ${weights[COLOR_AN_SCHNITZLER]}`);
            if (weights[COLOR_UMFELD]) tooltipLines.push(`Umfeld: ${weights[COLOR_UMFELD]}`);
            L.circleMarker([loc.lat, loc.lon], {
                radius: 2 + (w / maxWeight) * 10,
                fillColor: blendColor(weights),
                color: '#fff',
                weight: 1,
                fillOpacity: 0.9
            }).addTo(citiesLayer)
                .bindTooltip(tooltipLines.join('<br>'))
                .on('click', () => window.open(`https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${id}.html`, '_blank'));
        });
    }

    let lastRows = [];
    let rowsFiltered = false; // Tabelle per Headerfilter eingeschränkt: Ausschnitt folgt dem Filter
    let wienOnly = false;     // Switch "Nur Verbindungen innerhalb Wiens"

    // Hinweis auf der Karte, falls im Wien-Modus keine Verbindung übrig bleibt
    const wienHinweis = L.control({ position: 'topright' });
    wienHinweis.onAdd = function() {
        const div = L.DomUtil.create('div', 'leaflet-bar');
        div.setAttribute('role', 'status');
        div.style.cssText = 'display:none; max-width:280px; background:#fff; padding:6px 10px;';
        div.textContent = 'Keine Verbindungen innerhalb Wiens in der aktuellen Auswahl.';
        return div;
    };
    wienHinweis.addTo(map);

    // Baut die Karte aus den aktuellen Tabellenzeilen im aktuellen Modus (alle Verbindungen bzw.
    // nur Verbindungen innerhalb Wiens). Liefert den Umfang der gezeichneten Verbindungen oder
    // null, wenn keine übrig ist.
    function redraw() {
        const built = buildFromRows(lastRows, wienOnly ? wienIds : null);
        render(built);
        const pts = [];
        built.lineSegments.forEach(function(seg) {
            const from = locations.get(seg.from);
            const to = locations.get(seg.to);
            if (from) pts.push([from.lat, from.lon]);
            if (to) pts.push([to.lat, to.lon]);
        });
        const bounds = pts.length ? L.latLngBounds(pts) : null;
        wienHinweis.getContainer().style.display = wienOnly && !bounds ? 'block' : 'none';
        return bounds;
    }

    // Fliegt nach dem Wechsel des Modus (Wien-Switch, Filter aufgehoben) auf den passenden
    // Kartenausschnitt: Wien-Modus -> alle Verbindungen in Wien (ohne Treffer: Wien-Mitte),
    // sonst gefilterte Tabelle -> deren Verbindungen, sonst Gesamtübersicht.
    function flyToView(bounds) {
        if (wienOnly) {
            if (bounds) map.flyToBounds(bounds, { padding: [25, 25] });
            else map.flyTo(WIEN_CENTER, WIEN_ZOOM);
        } else if (rowsFiltered && bounds) {
            map.flyToBounds(bounds.pad(0.2));
        } else {
            map.flyTo(OVERVIEW_CENTER, OVERVIEW_ZOOM);
        }
    }

    window.postwegeMap = {
        // Initialer Aufbau mit allen Tabellenzeilen (siehe correspaction.xsl, table "tableBuilt").
        init(rows) {
            lastRows = rows;
            rowsFiltered = false;
            locationsReady.then(redraw);
        },
        // Aufruf bei gefilterter Tabelle (siehe correspaction.xsl, table "dataFiltered").
        setConnections(rows) {
            lastRows = rows;
            rowsFiltered = true;
            locationsReady.then(function() {
                const bounds = redraw();
                if (bounds) map.fitBounds(bounds.pad(0.2));
            });
        },
        // Aufruf, wenn die Headerfilter der Tabelle wieder aufgehoben sind: die Karte zeigt
        // wieder alle Briefe (nur nötig, wenn sie zuvor einem Filter folgte).
        resetConnections(rows) {
            if (!rowsFiltered) return;
            lastRows = rows;
            rowsFiltered = false;
            locationsReady.then(function() { flyToView(redraw()); });
        },
        reset() {
            locationsReady.then(redraw);
        },
        // Switch "Nur Verbindungen innerhalb Wiens" (siehe correspaction.xsl): zeigt nur die
        // Verbindungen zwischen Orten in Wien und fliegt auf sie; ausgeschaltet kommen wieder alle
        // Verbindungen.
        setWienOnly(flag) {
            wienOnly = !!flag;
            locationsReady.then(function() { flyToView(redraw()); });
        }
    };
}

createKarte1();
