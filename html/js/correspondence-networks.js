document.addEventListener('DOMContentLoaded', () => {
    console.log('Document is ready');

    const resizeChartContainer = () => {
        const containers = ['person-container', 'place-container', 'institution-container', 'work-container'];
        containers.forEach(id => {
            const container = document.getElementById(id);
            if (container) {
                container.style.width = window.innerWidth * 0.8 + 'px';
                container.style.height = window.innerHeight * 0.6 + 'px';
                if (window.charts && window.charts[id]) {
                    window.charts[id].reflow();
                }
            } else {
                console.error(`Container ${id} not found`);
            }
        });
    };

    resizeChartContainer();
    window.addEventListener('resize', resizeChartContainer);

    const loadCSVData = (csvUrl, containerId, title) => {
        fetch(csvUrl)
            .then(response => response.ok ? response.text() : Promise.reject('Network response was not ok ' + response.statusText))
            .then(csvText => {
                console.log('CSV file content:', csvText);

                Papa.parse(csvText, {
                    header: true,
                    complete: ({ data }) => {
                        if (!data.length) {
                            console.error('Parsed data is empty or incorrectly formatted');
                            const container = document.getElementById(containerId);
                            if (container) container.remove();
                            return;
                        }

                        const nodes = {}, links = [];
                        const [sourceColor, targetColor, minNodeSize, maxNodeSize] = ['#A63437', '#3785A6', 2, 20];

                        let sourceNodeName = data[0].Source?.trim();
                        let sourceId = data[0].CorrID?.trim();

                        let targetIdColumn;
                        switch (containerId) {
                            case 'person-container':
                                targetIdColumn = 'PersID';
                                break;
                            case 'place-container':
                                targetIdColumn = 'PlaceID';
                                break;
                            case 'institution-container':
                                targetIdColumn = 'OrgID';
                                break;
                            case 'work-container':
                                targetIdColumn = 'WorkID';
                                break;
                            default:
                                console.error('Unknown containerId:', containerId);
                                return;
                        }

                        data.forEach(row => {
                            const [source, corrId, target, targetId, overallCount, weight] = [
                                row.Source?.trim(),
                                row.CorrID?.trim(),
                                row.Target?.trim(),
                                row[targetIdColumn]?.trim(),
                                parseInt(row.Overallcount, 10) || 0,
                                parseInt(row.Weight, 10) || 0
                            ];
                            if (!source || !target || !corrId) return console.warn('Row missing source, target, or corrId:', row);

                            nodes[source] = nodes[source] || { id: source, weight: 0, marker: { fillColor: sourceColor }, isSource: true };
                            nodes[target] = nodes[target] || { id: target, weight: 0, overallWeight: overallCount, marker: { fillColor: targetColor } };

                            nodes[target].weight += weight;

                            nodes[target].url = `https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${targetId}.html`;

                            links.push({ from: source, to: target, value: weight });
                        });

                        // Calculate total weights for nodes
                        const weights = Object.values(nodes).filter(n => n.id !== sourceId).map(n => n.weight);
                        const [minWeight, maxWeight] = [Math.min(...weights), Math.max(...weights)];

                        Object.values(nodes).forEach(node => {
                            if (node.id !== sourceId) {
                                const normalizedWeight = (node.weight - minWeight) / (maxWeight - minWeight);
                                node.marker.radius = minNodeSize + normalizedWeight * (maxNodeSize - minNodeSize);
                            }
                        });

                        if (!Object.values(nodes).length || !links.length) {
                            console.error('Nodes or links arrays are empty');
                            const container = document.getElementById(containerId);
                            if (container) container.remove();
                            return;
                        }

                        window.charts = window.charts || {};
                        window.charts[containerId] = Highcharts.chart(containerId, {
                            chart: {
                                type: 'networkgraph',
                                panning: { enabled: true, type: 'xy' },
                                margin: [0, 0, 0, 0],
                                panKey: 'shift',
                                zoomType: 'xy'
                            },
                            title: { text: title },
                            tooltip: {
                                formatter: function () {
                                    if (this.point.isNode && !this.point.isSource) {
                                        const { id, weight, overallWeight } = this.point;
                                        return `<b>${id}</b><br>Erwähnungen in allen Korrespondenzstücken: ${overallWeight}<br>Erwähnungen in Korrespondenz ${sourceNodeName}: ${weight}`;
                                    }
                                    return false;
                                }
                            },
                            plotOptions: {
                                networkgraph: {
                                    keys: ['from', 'to'],
                                    layoutAlgorithm: {
                                        enableSimulation: true,
                                        linkLength: 85,
                                        integration: 'verlet',
                                        approximation: 'none',
                                    }
                                }
                            },
                            series: [{
                                groupPadding: 0,
                                pointPadding: 0,
                                dataLabels: {
                                    enabled: true, linkFormat: '', allowOverlap: false, style: { textOutline: 'none' },
                                    formatter: function () { return this.point.id; }
                                },
                                nodes: Object.values(nodes),
                                data: links,
                                point: {
                                    events: {
                                        click: function () {
                                            console.log('Node clicked:', this.id, this.url);
                                            if (this.url) window.open(this.url, '_blank');
                                        }
                                    }
                                }
                            }],
                            exporting: {
                                enabled: false,
                            }
                        });
                    },
                    error: error => console.error('Error parsing the CSV file:', error)
                });
            })
            .catch(error => console.error('Error loading the CSV file:', error));
    };

    const getCorrespondenceIdFromURL = () => {
        const url = window.location.href;
        const match = url.match(/netzwerke_pmb(\d+)\.html/);
        return match ? match[1] : null;
    };

    const correspondenceId = getCorrespondenceIdFromURL();

    if (correspondenceId) {
        const baseUrls = [
            { url: `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/person_freq_corr_weights_directed/person_freq_corr_weights_directed_correspondence_${correspondenceId}.csv`},
            { url: `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/place_freq_corr_weights_directed/place_freq_corr_weights_directed_correspondence_${correspondenceId}.csv`},
            { url: `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/institution_freq_corr_weights_directed/institution_freq_corr_weights_directed_correspondence_${correspondenceId}.csv`},
            { url: `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/work_freq_corr_weights_directed/work_freq_corr_weights_directed_correspondence_${correspondenceId}.csv`}
        ];

        const containers = ['person-container', 'place-container', 'institution-container', 'work-container'];

        baseUrls.forEach((item, index) => {
            const containerId = containers[index];
            fetch(item.url)
                .then(response => response.ok ? response.text() : Promise.reject('Network response was not ok ' + response.statusText))
                .then(csvText => {
                    Papa.parse(csvText, {
                        header: true,
                        complete: ({ data }) => {
                            if (data.length) {
                                const container = document.getElementById(containerId);
                                if (container) {
                                    loadCSVData(item.url, containerId, item.title);
                                }
                            } else {
                                const container = document.getElementById(containerId);
                                if (container) container.remove();
                            }
                        },
                        error: error => {
                            console.error('Error parsing the CSV file:', error);
                            const container = document.getElementById(containerId);
                            if (container) container.remove();
                        }
                    });
                })
                .catch(error => {
                    console.error('Error loading the CSV file:', error);
                    const container = document.getElementById(containerId);
                    if (container) container.remove();
                });
        });
    } else {
        console.error('Correspondence ID not found in the URL');
    }
});
