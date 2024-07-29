document.addEventListener('DOMContentLoaded', () => {
    console.log('Document is ready');

    function resizeChartContainer() {
        const container = document.getElementById('container');
        if (container) {
            container.style.width = window.innerWidth + 'px';
            container.style.height = window.innerHeight + 'px';
        } else {
            console.error('Container not found');
        }

        // Reflow the chart to adjust its size
        if (window.chart) {
            window.chart.reflow();
        }
    }

    // Call the function once to set initial size
    resizeChartContainer();

    // Adjust the chart size when the window is resized
    window.addEventListener('resize', resizeChartContainer);

    // Fetch the CSV file
    fetch('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/correspondence_weights_undirected/correspondence_weights_undirected.csv')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            console.log('CSV file fetched');
            return response.text();
        })
        .then(csvText => {
            console.log('CSV file content:', csvText);

            // Parse the CSV file
            Papa.parse(csvText, {
                header: true,
                complete: function (results) {
                    console.log('Parsed CSV data:', results);

                    const data = results.data;

                    // Check if data is being parsed correctly
                    if (!data.length) {
                        console.error('Parsed data is empty or incorrectly formatted');
                        return;
                    }

                    // Format the data for Highcharts
                    const nodes = {};
                    const links = [];
                    const sourceColor = '#A63437';
                    const targetColor = '#3785A6';
                    const minNodeSize = 2;
                    const maxNodeSize = 20;
                    const fixedSourceNodeSize = 10; // Fixed size for source nodes

                    data.forEach(row => {
                        const source = row.Source ? row.Source.trim() : null;
                        const target = row.Target ? row.Target.trim() : null;
                        const targetId = row.ID ? row.ID.trim() : null;
                        const weight = row.Weight ? parseInt(row.Weight, 10) : 0; // Ensure weight is an integer

                        console.log(`Processing row: source=${source}, target=${target}, targetId=${targetId}, weight=${weight}`);

                        if (source && target) {
                            if (!nodes[source]) {
                                nodes[source] = { id: source, weight: 0, marker: { fillColor: sourceColor, radius: fixedSourceNodeSize } };
                            }

                            if (!nodes[target]) {
                                nodes[target] = { id: target, weight: 0, marker: { fillColor: targetColor } };
                            }

                            if (targetId) {
                                const url = `https://schnitzler-briefe.acdh.oeaw.ac.at/toc_${targetId}.html`;
                                nodes[target].url = url;
                                console.log(`Assigned URL for ${target} with ID ${targetId}: ${nodes[target].url}`);
                            } else {
                                console.warn(`No targetId for target ${target}`);
                            }

                            nodes[target].weight += weight; // Only increase weight for target nodes

                            links.push({
                                from: source,
                                to: target,
                                value: weight
                            });
                        } else {
                            console.warn('Row missing source or target:', row);
                        }
                    });

                    // Calculate and assign node sizes based on weights
                    const weights = Object.values(nodes).filter(node => node.id !== 'Arthur Schnitzler').map(node => node.weight);
                    const minWeight = Math.min.apply(null, weights); // Use apply for compatibility
                    const maxWeight = Math.max.apply(null, weights); // Use apply for compatibility

                    Object.values(nodes).forEach(node => {
                        if (node.id !== 'Arthur Schnitzler') { // Apply size changes only to target nodes
                            const normalizedWeight = (node.weight - minWeight) / (maxWeight - minWeight);
                            node.marker.radius = minNodeSize + normalizedWeight * (maxNodeSize - minNodeSize);
                        }
                    });

                    // Convert nodes object to an array
                    const nodeArray = Object.values(nodes);

                    console.log('Formatted nodes:', nodeArray);
                    console.log('Formatted links:', links);

                    // Check if nodes and links arrays are populated
                    if (!nodeArray.length || !links.length) {
                        console.error('Nodes or links arrays are empty');
                        return;
                    }

                    // Create the Highcharts chart
                    window.chart = Highcharts.chart('container', {
                        chart: {
                            type: 'networkgraph'
                        },
                        title: {
                            text: 'Anzahl der Korrespondenzstücke aller Korrespondenzen in ungerichteten Graphen'
                        },
                        tooltip: {
                            formatter: function () {
                                if (this.point.isNode && this.point.marker.fillColor === '#3785A6') {
                                    return `<b>${this.point.id}</b><br>Korrespondenzstücke: ${this.point.weight}`;
                                }
                                return `<b>${this.point.id}</b>`;
                            }
                        },
                        plotOptions: {
                            networkgraph: {
                                keys: ['from', 'to'],
                                layoutAlgorithm: {
                                    enableSimulation: true,
                                    linkLength: 25 // Increase this value to make distances bigger
                                }
                            }
                        },
                        series: [{
                            dataLabels: {
                                enabled: true,
                                linkFormat: '',
                                allowOverlap: true,
                                style: {
                                    textOutline: 'none'
                                }
                            },
                            nodes: nodeArray,
                            data: links,
                            point: {
                                events: {
                                    click: function () {
                                        console.log('Node clicked:', this.id, this.url); // Log the node click event
                                        if (this.url) {
                                            window.open(this.url, '_blank');
                                        } else {
                                            console.warn('No URL found for this node:', this.id);
                                        }
                                    }
                                }
                            }
                        }],
                        exporting: {
                            enabled: true // Enable the export menu
                        }
                    });
                },
                error: function (error) {
                    console.error('Error parsing the CSV file:', error);
                }
            });
        })
        .catch(error => {
            console.error('Error loading the CSV file:', error);
        });
});