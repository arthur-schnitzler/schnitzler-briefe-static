async function createKarte4(title) {
    let mapDataUrl;

    if (title.endsWith("pmb11485") || title.endsWith("pmb2167") || title.endsWith("pmb11740") || title.endsWith("pmb10863")) {
        mapDataUrl = 'https://code.highcharts.com/mapdata/custom/world.topo.json';
    } else {
        mapDataUrl = 'https://code.highcharts.com/mapdata/custom/europe.topo.json';
    }

    const topology = await fetch(mapDataUrl).then(response => response.json());
    const jsonURL = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/statistiken/karte/${title}.json`;

    let chartInstance = null;
    let allLetters = [];
    let minYear = Infinity;
    let maxYear = -Infinity;

    fetch(jsonURL)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            if (!data || !data.letters || !Array.isArray(data.letters)) {
                throw new Error('Ungültiges JSON-Format');
            }

            allLetters = data.letters;

            // Berechne Jahresbereich
            allLetters.forEach(letter => {
                if (letter.date) {
                    const year = parseInt(letter.date.substring(0, 4));
                    if (year < minYear) minYear = year;
                    if (year > maxYear) maxYear = year;
                }
            });

            // Fallback wenn keine Daten
            if (minYear === Infinity || maxYear === -Infinity) {
                minYear = 1890;
                maxYear = 1930;
            }

            // Initialisiere Filter
            document.getElementById('direction-filter').value = 'both';
            document.getElementById('year-from').min = minYear;
            document.getElementById('year-from').max = maxYear;
            document.getElementById('year-from').value = minYear;
            document.getElementById('year-to').min = minYear;
            document.getElementById('year-to').max = maxYear;
            document.getElementById('year-to').value = maxYear;
            document.getElementById('year-from-label').textContent = minYear;
            document.getElementById('year-to-label').textContent = maxYear;

            // Event-Listener für Filter
            document.getElementById('direction-filter').addEventListener('change', updateMap);
            document.getElementById('show-umfeld').addEventListener('change', updateMap);
            document.getElementById('year-from').addEventListener('input', function() {
                document.getElementById('year-from-label').textContent = this.value;
                updateRangeBackground('year-from');
                updateMap();
            });
            document.getElementById('year-to').addEventListener('input', function() {
                document.getElementById('year-to-label').textContent = this.value;
                updateRangeBackground('year-to');
                updateMap();
            });

            // Initiale Range-Backgrounds setzen
            updateRangeBackground('year-from');
            updateRangeBackground('year-to');

            // Initialisiere Karte
            updateMap();
        })
        .catch(error => {
            console.error('Fehler beim Laden der Kartendaten:', error);
            const container = document.getElementById('karte4');
            container.innerHTML = `
                <div style="display: flex; align-items: center; justify-content: center; height: 100%; background-color: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 5px;">
                    <div style="text-align: center; padding: 2em;">
                        <h3 style="color: #6c757d; margin-bottom: 1em;">⚠️ Kartendaten nicht verfügbar</h3>
                        <p style="color: #6c757d;">Die Kartendaten für diese Korrespondenz konnten nicht geladen werden.</p>
                        <p style="color: #6c757d; font-size: 0.9em; margin-top: 1em;">URL: <code>${jsonURL}</code></p>
                        <p style="color: #6c757d; font-size: 0.9em;">Fehler: ${error.message}</p>
                    </div>
                </div>
            `;
        });

    function updateRangeBackground(id) {
        const input = document.getElementById(id);
        const min = parseFloat(input.min);
        const max = parseFloat(input.max);
        const val = parseFloat(input.value);
        const percentage = ((val - min) / (max - min)) * 100;

        if (id === 'year-from') {
            // Für year-from: grau links, rot rechts vom Thumb
            input.style.background = `linear-gradient(to right, #e9ecef 0%, #e9ecef ${percentage}%, #A63437 ${percentage}%, #A63437 100%)`;
        } else {
            // Für year-to: rot links, grau rechts vom Thumb
            input.style.background = `linear-gradient(to right, #A63437 0%, #A63437 ${percentage}%, #e9ecef ${percentage}%, #e9ecef 100%)`;
        }
    }

    function updateMap() {
        const direction = document.getElementById('direction-filter').value;
        const showUmfeld = document.getElementById('show-umfeld').checked;
        const yearFrom = parseInt(document.getElementById('year-from').value);
        const yearTo = parseInt(document.getElementById('year-to').value);

        // Filtere Briefe
        let filteredLetters = allLetters.filter(letter => {
            // Prüfe Datum
            if (!letter.date) return false;
            const year = parseInt(letter.date.substring(0, 4));
            if (year < yearFrom || year > yearTo) return false;

            // Prüfe Umfeldbriefe
            if (!showUmfeld && letter.type && (
                letter.type === 'umfeld' ||
                letter.type === 'umfeld schnitzler' ||
                letter.type === 'umfeld partner'
            )) {
                return false;
            }

            // Prüfe Richtung (nur wenn nicht Umfeldbrief)
            if (direction === 'from-schnitzler') {
                if (letter.type === 'von schnitzler' || letter.type === 'umfeld schnitzler') {
                    // OK
                } else {
                    return false;
                }
            } else if (direction === 'to-schnitzler') {
                if (letter.type === 'von partner' || letter.type === 'umfeld partner') {
                    // OK
                } else {
                    return false;
                }
            }
            // Bei 'both' werden alle nicht-Umfeld-Briefe oder alle wenn showUmfeld=true angezeigt

            // Prüfe gültige Koordinaten
            if (!letter.from || !letter.to) return false;
            if (!letter.from.lat || !letter.from.lon || !letter.to.lat || !letter.to.lon) return false;

            return true;
        });

        // Sammle Orte und Verbindungen
        const locationsMap = new Map();
        const connectionsMap = new Map();

        filteredLetters.forEach(letter => {
            // Orte sammeln
            if (!locationsMap.has(letter.from.ref)) {
                locationsMap.set(letter.from.ref, {
                    id: letter.from.name,
                    lat: letter.from.lat,
                    lon: letter.from.lon
                });
            }
            if (!locationsMap.has(letter.to.ref)) {
                locationsMap.set(letter.to.ref, {
                    id: letter.to.name,
                    lat: letter.to.lat,
                    lon: letter.to.lon
                });
            }

            // Verbindungen sammeln (aggregiert nach von-nach und Typ)
            const connectionKey = `${letter.from.name}->${letter.to.name}-${letter.type || 'unknown'}`;
            if (!connectionsMap.has(connectionKey)) {
                connectionsMap.set(connectionKey, {
                    from: letter.from.name,
                    to: letter.to.name,
                    weight: 0,
                    letters: [],
                    type: letter.type || 'unknown'
                });
            }
            const conn = connectionsMap.get(connectionKey);
            conn.weight++;
            conn.letters.push(letter);
        });

        const cityData = Array.from(locationsMap.values());

        // Füge Farbcodierung zu den Verbindungen hinzu
        const flowData = Array.from(connectionsMap.values()).map(conn => {
            let color;
            switch(conn.type) {
                case 'von schnitzler':
                    color = '#A63437'; // theme-color
                    break;
                case 'von partner':
                    color = '#1C6E8C'; // sender-color
                    break;
                case 'umfeld schnitzler':
                    color = '#D4787A'; // helleres rot
                    break;
                case 'umfeld partner':
                    color = '#5A9CB8'; // helleres blau
                    break;
                case 'umfeld':
                    color = '#68825b'; // umfeld-color (grün)
                    break;
                default:
                    color = '#999999'; // grau für unbekannt
            }
            return {
                ...conn,
                color: color
            };
        });

        // Berechne Bounding Box für optimalen Zoom
        let minLat = Infinity, maxLat = -Infinity;
        let minLon = Infinity, maxLon = -Infinity;

        if (cityData.length === 0) {
            // Fallback auf Europa-Ansicht
            minLat = 35;
            maxLat = 70;
            minLon = -10;
            maxLon = 40;
        } else {
            cityData.forEach(city => {
                if (city.lat < minLat) minLat = city.lat;
                if (city.lat > maxLat) maxLat = city.lat;
                if (city.lon < minLon) minLon = city.lon;
                if (city.lon > maxLon) maxLon = city.lon;
            });

            // Berechne die Spanne
            const latSpan = maxLat - minLat;
            const lonSpan = maxLon - minLon;

            // Füge minimales Padding hinzu, abhängig von der Datenmenge
            // Bei nur einem Ort: 1 Grad Padding (ca. 110km)
            // Bei mehreren Orten: 3-5% der Spanne (min 0.3 Grad)
            let latPadding, lonPadding;

            if (cityData.length === 1) {
                latPadding = 1;
                lonPadding = 1;
            } else {
                latPadding = Math.max(0.3, latSpan * 0.04);
                lonPadding = Math.max(0.3, lonSpan * 0.04);
            }

            minLat -= latPadding;
            maxLat += latPadding;
            minLon -= lonPadding;
            maxLon += lonPadding;
        }

        // Erstelle oder aktualisiere Karte
        if (chartInstance) {
            chartInstance.destroy();
        }

        let titleText = 'Versandwege aller Korrespondenzstücke';
        if (direction === 'from-schnitzler') {
            titleText = 'Versandwege von Schnitzler verfasster Korrespondenzstücke';
        } else if (direction === 'to-schnitzler') {
            titleText = 'Versandwege an Schnitzler gerichteter Korrespondenzstücke';
        }

        if (showUmfeld) {
            titleText += ' (inkl. Umfeldbriefe)';
        }

        chartInstance = Highcharts.mapChart('karte4', {
            chart: {
                map: topology,
                events: {
                    load: function() {
                        // Zoome auf die Bounding Box nach dem Laden
                        if (cityData.length > 0 && isFinite(minLat) && isFinite(maxLat) && isFinite(minLon) && isFinite(maxLon)) {
                            try {
                                this.mapView.fitToBounds([
                                    [minLon, minLat],
                                    [maxLon, maxLat]
                                ]);
                            } catch (e) {
                                console.warn('Konnte Karte nicht auf Bounds zoomen:', e);
                            }
                        }
                    }
                }
            },

            title: {
                text: titleText
            },

            subtitle: {
                text: `Zeitraum: ${yearFrom}–${yearTo}`
            },

            mapNavigation: {
                enabled: true,
                buttonOptions: {
                    alignTo: 'spacingBox'
                }
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
                flowmap: {
                    tooltip: {
                        headerFormat: '',
                        pointFormatter: function() {
                            // Finde die Verbindung mit dem gleichen Typ
                            let conn = null;
                            for (let [key, value] of connectionsMap) {
                                if (value.from === this.from && value.to === this.to && value.type === this.options.type) {
                                    conn = value;
                                    break;
                                }
                            }

                            if (!conn) return '';

                            let typeLabel = '';
                            switch(conn.type) {
                                case 'von schnitzler': typeLabel = 'Von Schnitzler'; break;
                                case 'von partner': typeLabel = 'Von Korrespondenzpartner'; break;
                                case 'umfeld schnitzler': typeLabel = 'Umfeld (von Schnitzler)'; break;
                                case 'umfeld partner': typeLabel = 'Umfeld (von Partner)'; break;
                                case 'umfeld': typeLabel = 'Umfeld (Dritte)'; break;
                                default: typeLabel = conn.type;
                            }

                            let tooltipText = `<b>${this.from} → ${this.to}</b><br>`;
                            tooltipText += `<span style="color: ${this.color}">${typeLabel}</span><br>`;
                            tooltipText += `Anzahl Briefe: ${this.weight}<br><br>`;
                            tooltipText += '<ul style="margin:0; padding-left:20px;">';
                            conn.letters.forEach(letter => {
                                tooltipText += `<li>${letter.title}</li>`;
                            });
                            tooltipText += '</ul>';
                            return tooltipText;
                        }
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
                id: 'cities',
                name: 'Orte',
                dataLabels: {
                    format: '{point.id}'
                },
                data: cityData
            }, {
                type: 'flowmap',
                name: 'Korrespondenzstücke',
                accessibility: {
                    description: 'Landkarte mit Bögen zwischen Versand- und Empfangsort'
                },
                linkedTo: ':previous',
                minWidth: 1,
                maxWidth: 25,
                growTowards: true,
                markerEnd: {
                    width: '50%',
                    height: '50%'
                },
                fillOpacity: 0.7,
                data: flowData.map(flow => ({
                    from: flow.from,
                    to: flow.to,
                    weight: flow.weight,
                    color: flow.color,
                    fillColor: flow.color,
                    type: flow.type
                }))
            }]
        });
    }
}