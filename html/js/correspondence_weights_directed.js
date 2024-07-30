 document.addEventListener('DOMContentLoaded', () => {
            console.log('Document is ready');

            const resizeChartContainer = () => {
                const container = document.getElementById('tocs-container');
                if (container) {
                    container.style.width = window.innerWidth * 0.8 + 'px';
                    container.style.height = window.innerHeight * 0.6 + 'px';
                    window.chart?.reflow();
                } else {
                    console.error('Container not found');
                }
            };

            resizeChartContainer();
            window.addEventListener('resize', resizeChartContainer);

            fetch('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/correspondence_weights_directed/correspondence_weights_directed.csv')
                .then(response => response.ok ? response.text() : Promise.reject('Network response was not ok ' + response.statusText))
                .then(csvText => {
                    console.log('CSV file content:', csvText);

                    Papa.parse(csvText, {
                        header: true,
                        complete: ({ data }) => {
                            if (!data.length) return console.error('Parsed data is empty or incorrectly formatted');

                            const nodes = {}, links = [];
                            const [sourceColor, targetColor, minNodeSize, maxNodeSize, fixedSourceNodeSize] = ['#A63437', '#3785A6', 2, 20, 10];

                            data.forEach(row => {
                                const [source, target, targetId, weight] = [row.Source?.trim(), row.Target?.trim(), row.ID?.trim(), parseInt(row.Weight, 10) || 0];
                                if (!source || !target) return console.warn('Row missing source or target:', row);

                                nodes[source] = nodes[source] || { id: source, toSchnitzler: 0, fromSchnitzler: 0, marker: { fillColor: source === 'Arthur Schnitzler' ? sourceColor : targetColor, radius: source === 'Arthur Schnitzler' ? fixedSourceNodeSize : undefined } };
                                nodes[target] = nodes[target] || { id: target, toSchnitzler: 0, fromSchnitzler: 0, marker: { fillColor: targetColor } };

                                if (source === 'Arthur Schnitzler') {
                                    nodes[target].fromSchnitzler += weight;
                                } else if (target === 'Arthur Schnitzler') {
                                    nodes[source].toSchnitzler += weight;
                                }

                                if (targetId) nodes[target].url = `https://schnitzler-briefe.acdh.oeaw.ac.at/toc_${targetId}.html`;

                                links.push({ from: source, to: target, value: weight });
                            });

                            Object.values(nodes).forEach(node => {
                                node.weight = node.toSchnitzler + node.fromSchnitzler;
                            });

                            // Calculate total weights for nodes
                            const weights = Object.values(nodes).filter(n => n.id !== 'Arthur Schnitzler').map(n => n.weight);
                            const [minWeight, maxWeight] = [Math.min(...weights), Math.max(...weights)];

                            Object.values(nodes).forEach(node => {
                                if (node.id !== 'Arthur Schnitzler') {
                                    const normalizedWeight = (node.weight - minWeight) / (maxWeight - minWeight);
                                    node.marker.radius = minNodeSize + normalizedWeight * (maxNodeSize - minNodeSize);
                                }
                            });

                            if (!Object.values(nodes).length || !links.length) return console.error('Nodes or links arrays are empty');

                            window.chart = Highcharts.chart('tocs-container', {
                                chart: {
                                    type: 'networkgraph',
                                    panning: { enabled: true, type: 'xy' },
                                    margin: [0, 0, 0, 0],
                                    panKey: 'shift',
                                    zoomType: 'xy',
                                    events: {
                                        load: function () {
                                            const chart = this;
                                            const schnitzlerNode = chart.series[0].nodes.find(node => node.id === 'Arthur Schnitzler');
                                            if (schnitzlerNode) {
                                                schnitzlerNode.fixedPosition = true;
                                                schnitzlerNode.plotX = chart.plotWidth / 2;
                                                schnitzlerNode.plotY = chart.plotHeight / 3;
                                                chart.series[0].nodes.forEach(node => {
                                                    if (node.id !== 'Arthur Schnitzler') {
                                                        node.plotX += chart.plotWidth / 2 - schnitzlerNode.plotX;
                                                        node.plotY += chart.plotHeight / 3 - schnitzlerNode.plotY;
                                                    }
                                                });
                                                chart.redraw();
                                            }
                                        }
                                    }
                                },
                                title: { text: null },
                                tooltip: {
                                    formatter: function () {
                                        if (this.point.isNode) {
                                            const { id, toSchnitzler, fromSchnitzler } = this.point;
                                            const totalWeight = toSchnitzler + fromSchnitzler;
                                            if (id === 'Arthur Schnitzler') {
                                                return `<b>${id}</b>`;
                                            } else {
                                                return `<b>${id}</b><br>Korrespondenzstücke: ${totalWeight}<br>An Schnitzler: ${toSchnitzler}<br>Von Schnitzler: ${fromSchnitzler}`;
                                            }
                                        }
                                        return `<b>${this.point.id}</b>`;
                                    }
                                },
                                plotOptions: {
                                    networkgraph: {
                                        keys: ['from', 'to'],
                                        layoutAlgorithm: { 
                                            enableSimulation: true, 
                                            linkLength: 85, // Increased value to add more distance between the lines
                                            integration: 'verlet',
                                            approximation: 'none',
                                        }
                                    }
                                },
                                series: [{
                                    groupPadding: 0,
                                    pointPadding: 0,
                                    dataLabels: {
                                        enabled: true, linkFormat: '', allowOverlap: true, style: { textOutline: 'none' },
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
                                    enabled: true, // Disable exporting
                                }
                            });
                        },
                        error: error => console.error('Error parsing the CSV file:', error)
                    });
                })
                .catch(error => console.error('Error loading the CSV file:', error));
        });