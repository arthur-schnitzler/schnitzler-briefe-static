document.addEventListener('DOMContentLoaded', () => {
    console.log('Document is ready');

    // Lese URL-Parameter, z. B. ?year=1900
    const params = new URLSearchParams(window.location.search);
    const urlYear = params.get('year');

    // Liste der verfügbaren CSV-Dateien
    const csvFiles = {
        "Archivstücke": "https://raw.githubusercontent.com/martinantonmueller/presentations/refs/heads/main/2025-03-20_innsbruck/csv/archivstuecke.csv",
        "Verhältnis 1:1": "https://raw.githubusercontent.com/martinantonmueller/presentations/refs/heads/main/2025-03-20_innsbruck/csv/staerkere-seite.csv",
         "Schnitzler-Koeffizient": "https://raw.githubusercontent.com/martinantonmueller/presentations/refs/heads/main/2025-03-20_innsbruck/csv/schnitzler-koeffizient.csv"
    };

    // Wir speichern für jede Instanz die Update-Funktion
    const instances = {};
    let chartLeft, chartRight;

    // Diese Funktion initialisiert eine Instanz im Container mit eigener CSV-Dropdown,
    // lädt die CSV-Daten und kapselt die interne Logik. Das globale Jahresfeld wird
    // nicht in der Instanz angelegt, sondern später zur Aktualisierung beider Instanzen genutzt.
    function initChartWithSlider(containerId, dropdownId) {
        const container = document.getElementById(containerId);
        if (!container) {
            console.error('Container nicht gefunden: ' + containerId);
            return;
        }

        // Erstelle CSV-Dropdown und füge es oberhalb des Containers ein
        const csvDropdown = document.createElement('select');
        csvDropdown.id = dropdownId;
        for (const [label, url] of Object.entries(csvFiles)) {
            const option = document.createElement('option');
            option.value = url;
            option.textContent = label;
            csvDropdown.appendChild(option);
        }

        // Bei rechten Containern (Vergleichsansicht) automatisch die zweite Option auswählen
        if (containerId.includes('right')) {
            csvDropdown.selectedIndex = 1; // Zweite Option (Index 1)
        }
        // Dropdown oberhalb des Chart-Containers einfügen
        // Für nebeneinander-Container: in separaten Dropdown-Container einfügen
        if (containerId.includes('nebeneinander')) {
            const dropdownContainerId = 'dropdown-container-' + containerId.replace('jung-wien-container-', '');
            const dropdownContainer = document.getElementById(dropdownContainerId);
            if (dropdownContainer) {
                dropdownContainer.appendChild(csvDropdown);
            } else {
                container.parentNode.insertBefore(csvDropdown, container);
            }
        } else {
            container.parentNode.insertBefore(csvDropdown, container);
        }

        // Container-Styles festlegen
        container.style.display = 'flex';
        container.style.justifyContent = 'center';
        container.style.alignItems = 'center';
        container.style.width = '100%';
        container.style.height = '600px';

        // Funktion zum Anpassen der Container-Größe (Reflow)
        const resizeChartContainer = () => {
            container.style.width = '100%';
            container.style.height = window.innerHeight * 0.6 + 'px';
            container.style.margin = '0';
            container.chartInstance && container.chartInstance.reflow();
        };

        resizeChartContainer();
        window.addEventListener('resize', resizeChartContainer);

        let dataByYear = {};

        // CSV laden und nach Jahr gruppieren
        const loadCSV = (csvUrl) => {
            fetch(csvUrl)
                .then(response => response.ok ? response.text() : Promise.reject('Netzwerkfehler: ' + response.statusText))
                .then(csvText => {
                    console.log('CSV file content:', csvText);
                    Papa.parse(csvText, {
                        header: true,
                        complete: ({ data }) => {
                            if (!data.length) {
                                console.error('CSV-Daten leer oder falsch formatiert');
                                return;
                            }
                            // Gruppiere Daten nach Jahr
                            dataByYear = data.reduce((acc, row) => {
                                const rawYear = row.Year;
                                if (!rawYear) {
                                    console.warn('Zeile ohne Year-Wert:', row);
                                    return acc;
                                }
                                const year = parseInt(rawYear, 10);
                                if (isNaN(year)) {
                                    console.warn('Ungültiger Jahr-Wert:', rawYear, row);
                                    return acc;
                                }
                                if (!acc[year]) acc[year] = [];
                                acc[year].push(row);
                                return acc;
                            }, {});

                            // Ermittle min und max Jahr – wir gehen davon aus, dass beide CSVs ähnliche Werte haben
                            const years = Object.keys(dataByYear).map(y => parseInt(y, 10));
                            if (years.length === 0) {
                                console.error('Keine gültigen Jahr-Werte gefunden.');
                                return;
                            }
                            const minYear = Math.min(...years);
                            const maxYear = Math.max(...years);

                            // Aktualisiere globales Jahresfeld, falls vorhanden (nur einmal, wenn z. B. noch nicht gesetzt)
                            const yearSlider = document.getElementById('yearSlider') || document.getElementById('yearSliderNebeneinander');
                            let currentYear = minYear;
                            if (yearSlider) {
                                yearSlider.min = minYear;
                                yearSlider.max = maxYear;
                                // Wenn der URL-Parameter vorhanden und gültig ist, nutze ihn; ansonsten nutze den aktuellen Slider-Wert
                                if (urlYear && urlYear >= minYear && urlYear <= maxYear) {
                                    currentYear = parseInt(urlYear, 10);
                                    yearSlider.value = currentYear;
                                } else {
                                    currentYear = parseInt(yearSlider.value, 10) || minYear;
                                    if (currentYear < minYear || currentYear > maxYear) {
                                        currentYear = minYear;
                                        yearSlider.value = currentYear;
                                    }
                                }
                                // Aktualisiere auch das Year-Display
                                const yearDisplay = document.getElementById('yearDisplay') || document.getElementById('yearDisplayNebeneinander');
                                if (yearDisplay) {
                                    yearDisplay.textContent = currentYear;
                                }
                            }

                            // Erstelle initial den Chart für das ermittelte Jahr
                            setTimeout(() => {
                                createChartForYear(currentYear);
                                forceRedraw();
                            }, 100);
                        },
                        error: error => console.error('Error parsing CSV:', error)
                    });
                })
                .catch(error => console.error('Error loading CSV:', error));
        };

        // Funktion zur Erstellung des Charts für ein bestimmtes Jahr
        const createChartForYear = (year) => {
            console.log(`Erstelle Chart für Jahr: ${year} in Container ${containerId}`);
            const nodes = {},
                  links = [],
                  nodeCorrespondences = {},
                  nodeWeightSums = {};
            const [nodeColor, linkColor, minNodeSize, maxNodeSize, minLinkWidth, maxLinkWidth] =
                  ['#000000', '#A63437', 5, 20, 0.1, 10];
            const yearData = dataByYear[year] || [];

            // Vordefinierte Links für Nodes
            const nodeLinks = {
                "Hugo von Hofmannsthal": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc_11740.html",
                "Richard Beer-Hofmann": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc_10863.html",
                "Hermann Bahr": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc_10815.html",
                "Felix Salten": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc_2167.html",
                "Paul Goldmann": "https://schnitzler-briefe.acdh.oeaw.ac.at/toc_11485.html"
            };

            yearData.forEach(row => {
                const source = row.Source?.trim();
                const target = row.Target?.trim();
                const weight = parseInt(row.Weight, 10) || 0;

                if (!source || !target) {
                    console.warn('Row missing source or target:', row);
                    return;
                }

                if (!nodes[source]) {
                    nodes[source] = {
                        id: source,
                        marker: { fillColor: nodeColor },
                        url: nodeLinks[source] || null
                    };
                    nodeCorrespondences[source] = {};
                    nodeWeightSums[source] = 0;
                }
                if (!nodes[target]) {
                    nodes[target] = {
                        id: target,
                        marker: { fillColor: nodeColor },
                        url: nodeLinks[target] || null
                    };
                    nodeCorrespondences[target] = {};
                    nodeWeightSums[target] = 0;
                }

                nodeCorrespondences[source][target] = (nodeCorrespondences[source][target] || 0) + weight;
                nodeCorrespondences[target][source] = (nodeCorrespondences[target][source] || 0) + weight;
                nodeWeightSums[source] += weight;
                nodeWeightSums[target] += weight;

                // Prüfe ob Link bereits existiert und aggregiere Gewichte
                const existingLink = links.find(link => 
                    (link.from === source && link.to === target) ||
                    (link.from === target && link.to === source)
                );
                
                if (existingLink) {
                    existingLink.value += weight;
                    console.log(`🔄 Aggregating: ${source}→${target} now has weight ${existingLink.value}`);
                } else {
                    links.push({
                        from: source,
                        to: target,
                        value: weight,
                        color: linkColor,
                        width: weight
                    });
                }
            });

            const allNodes = Object.values(nodes);
            if (!allNodes.length || !links.length) {
                console.error('Nodes or links arrays are empty');
                return;
            }

            // Sortiere Knoten alphabetisch für konsistente Positionierung
            const sortedNodeNames = Object.keys(nodes).sort();
            const nodeCount = sortedNodeNames.length;
            const radius = 300;

            // Erstelle neues nodes Array mit festen Positionen
            const positionedNodes = sortedNodeNames.map((nodeName, index) => {
                const angle = (index / nodeCount) * 2 * Math.PI;
                const node = nodes[nodeName];
                return {
                    ...node,
                    x: radius * Math.cos(angle),
                    y: radius * Math.sin(angle)
                };
            });

            // Skalierung der Node-Größen
            const minNodeWeight = Math.min(...Object.values(nodeWeightSums));
            const maxNodeWeight = Math.max(...Object.values(nodeWeightSums));
            positionedNodes.forEach(node => {
                const totalWeight = nodeWeightSums[node.id];
                const normalizedSize = minNodeSize + ((totalWeight - minNodeWeight) / (maxNodeWeight - minNodeWeight)) * (maxNodeSize - minNodeSize);
                node.marker.radius = normalizedSize;
            });

            // Skalierung der Link-Dicken
            const minLinkWeight = Math.min(...links.map(link => link.value));
            const maxLinkWeight = Math.max(...links.map(link => link.value));
            links.forEach(link => {
                link.width = minLinkWidth + ((link.value - minLinkWeight) / (maxLinkWeight - minLinkWeight)) * (maxLinkWidth - minLinkWidth);
            });

            // Erstelle den Chart in diesem Container
            container.chartInstance = Highcharts.chart(containerId, {
                chart: {
                    type: 'networkgraph',
                    panning: { enabled: true, type: 'xy' },
                    panKey: 'shift',
                    zoomType: 'xy'
                },
                title: { text: null },
                tooltip: {
                    formatter: function () {
                        if (this.point.isNode) {
                            const correspondences = nodeCorrespondences[this.point.id];
                            let tooltipText = `<b>${this.point.id}</b>`;
                            for (const target in correspondences) {
                                tooltipText += `<br>Briefe mit ${target}: ${correspondences[target]}`;
                            }
                            return tooltipText;
                        }
                        return null;
                    }
                },
                plotOptions: {
                    networkgraph: {
                        keys: ['from', 'to'],
                        layoutAlgorithm: {
                            enableSimulation: true,
                            type: 'reingold-fruchterman',
                            initialPositions: 'random',
                            maxIterations: 500,
                            gravitationalConstant: 0,
                            friction: -0.75,
                            attractiveForce: function(d, k, link) {
                                // Starke gewichtsbasierte Anziehung
                                if (!link) return 0;
                                const weight = link ? link.value || 1 : 1;
                                // Exponentieller Anstieg für hohe Gewichte
                                const weightFactor = Math.pow(weight / 10, 1.5);
                                const force = Math.min(d * 0.02 * weightFactor, 50);

                                // Debug: Log high-weight attractions
                                if (weight >= 30 && Math.random() < 0.01) { // 1% sampling
                                    console.log(`⚡ Attraction: weight=${weight} factor=${weightFactor.toFixed(2)} force=${force.toFixed(2)}`);
                                }

                                return force;
                            },
                            repulsiveForce: function(d, k) {
                                // Standard Abstoßung aber verstärkt
                                return (k * k) / Math.max(d, 5);
                            },
                            maxSpeed: 100
                        },
                        dataLabels: {
                            enabled: true,
                            linkFormat: '',
                            allowOverlap: false,
                            style: { textOutline: 'none',
                                fontSize: '10px' },
                            formatter: function () { return this.point.id; }
                        },
                        link: {
                            color: linkColor,
                            width: 'width'
                        }
                    }
                },
                series: [{
                    dataLabels: {
                        enabled: true,
                        linkFormat: '',
                        allowOverlap: false,
                        style: { textOutline: 'none',
                        fontSize: '10px' },
                        formatter: function () { return this.point.id; }
                    },
                    nodes: positionedNodes,
                    data: links,
                    point: {
                        events: {
                            click: function () {
                                if (this.url) {
                                    window.open(this.url, '_blank');
                                }
                            }
                        }
                    }
                }],
                exporting: { enabled: true }
            });
            forceRedraw();
        };

        // Funktion zum Redraw (Reflow)
        const forceRedraw = () => {
            container.chartInstance && container.chartInstance.reflow();
        };

        // CSV-Dropdown-Event: Bei Änderung CSV neu laden
        csvDropdown.addEventListener('change', () => {
            loadCSV(csvDropdown.value);
        });

        // Initiale CSV-Ladung anhand der ersten Dropdown-Option
        loadCSV(csvDropdown.value);

        // Gib eine Update-Funktion zurück, die später von globalen Listenern genutzt wird
        const instance = { updateChart: createChartForYear };
        instances[containerId] = instance;
        return instance;
    }

    // Initialisiere Chart-Instanzen basierend auf verfügbaren Containern
    if (document.getElementById('jung-wien-container-mit-slider')) {
        initChartWithSlider('jung-wien-container-mit-slider', 'csvDropdown-mit-slider');
    }
    if (document.getElementById('jung-wien-container-nebeneinander-mit-slider-left')) {
        chartLeft = initChartWithSlider('jung-wien-container-nebeneinander-mit-slider-left', 'csvDropdown-nebeneinander-mit-slider-left');
    }
    if (document.getElementById('jung-wien-container-nebeneinander-mit-slider-right')) {
        chartRight = initChartWithSlider('jung-wien-container-nebeneinander-mit-slider-right', 'csvDropdown-nebeneinander-mit-slider-right');
    }

    // Setze Event-Listener für die Slider
    const yearSlider = document.getElementById('yearSlider');
    if (yearSlider) {
        // Falls im URL-Parameter ein Jahr übergeben wurde, setze den Slider
        if (urlYear) {
            yearSlider.value = urlYear;
            const yearDisplay = document.getElementById('yearDisplay');
            if (yearDisplay) {
                yearDisplay.textContent = urlYear;
            }
        }

        // Event-Listener für den einzelnen Slider
        yearSlider.addEventListener('input', () => {
            const year = parseInt(yearSlider.value, 10);
            const yearDisplay = document.getElementById('yearDisplay');
            if (yearDisplay) {
                yearDisplay.textContent = year;
            }
            // Aktualisiere den Chart in diesem Container
            const instance = instances['jung-wien-container-mit-slider'];
            if (instance) {
                instance.updateChart(year);
            }
        });
    }

    const yearSliderNebeneinander = document.getElementById('yearSliderNebeneinander');
    if (yearSliderNebeneinander) {
        // Falls im URL-Parameter ein Jahr übergeben wurde, setze den Slider
        if (urlYear) {
            yearSliderNebeneinander.value = urlYear;
            const yearDisplayNebeneinander = document.getElementById('yearDisplayNebeneinander');
            if (yearDisplayNebeneinander) {
                yearDisplayNebeneinander.textContent = urlYear;
            }
        }

        // Event-Listener für den Vergleichs-Slider: Ändert sich das Jahr, so aktualisieren beide Instanzen
        yearSliderNebeneinander.addEventListener('input', () => {
            const year = parseInt(yearSliderNebeneinander.value, 10);
            const yearDisplayNebeneinander = document.getElementById('yearDisplayNebeneinander');
            if (yearDisplayNebeneinander) {
                yearDisplayNebeneinander.textContent = year;
            }
            console.log('Jahr geändert:', year);
            if (chartLeft && chartLeft.updateChart) {
                chartLeft.updateChart(year);
            }
            if (chartRight && chartRight.updateChart) {
                chartRight.updateChart(year);
            }
        });
    }
});
