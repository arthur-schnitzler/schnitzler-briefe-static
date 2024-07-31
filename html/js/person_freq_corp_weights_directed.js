document.addEventListener('DOMContentLoaded', () => {
    console.log('Document is ready');

    const resizeChartContainer = () => {
        const container = document.getElementById('container');
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

    fetch('https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-networks/main/person_freq_corp_weights_directed/person_freq_corp_weights_directed.csv')
        .then(response => response.ok ? response.text() : Promise.reject('Network response was not ok ' + response.statusText))
        .then(csvText => {
            console.log('CSV file content:', csvText);

            Papa.parse(csvText, {
                header: true,
                complete: ({ data }) => {
                    if (!data.length) return console.error('Parsed data is empty or incorrectly formatted');

                    const nodes = {}, links = [];
                    const [nodeColor, minNodeSize, maxNodeSize, minLinkWidth, maxLinkWidth] = ['#3785A6', 2, 20, 0.1, 5];

                    const targets = new Set();
                    data.forEach(row => {
                        const [source, target, sourceId, targetId, overallCount, weight] = [
                            row.Source?.trim(),
                            row.Target?.trim(),
                            row.SID?.trim(),
                            row.TID?.trim(),
                            parseInt(row.Overallcount, 10) || 0,
                            parseInt(row.Weight, 10) || 0
                        ];

                        if (!source || !target) return console.warn('Row missing source or target:', row);

                        targets.add(target);

                        if (!nodes[source]) {
                            nodes[source] = { id: source, correspondences: [], marker: { fillColor: nodeColor }, url: `https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${sourceId}.html` };
                        }

                        if (!nodes[target]) {
                            nodes[target] = { id: target, overallCount: overallCount, correspondences: [], marker: { fillColor: nodeColor }, url: `https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${targetId}.html` };
                        }

                        nodes[target].correspondences.push({ from: source, weight });

                        links.push({ from: source, to: target, value: weight, source, target, weight });
                    });

                    // Filter nodes and links to include only those appearing as targets
                    const targetNodes = Object.values(nodes).filter(node => targets.has(node.id));
                    const targetLinks = links.filter(link => targets.has(link.source) && targets.has(link.target));

                    const [minWeight, maxWeight] = [Math.min(...targetNodes.map(n => n.overallCount)), Math.max(...targetNodes.map(n => n.overallCount))];

                    targetNodes.forEach(node => {
                        const normalizedWeight = (node.overallCount - minWeight) / (maxWeight - minWeight);
                        node.marker.radius = minNodeSize + normalizedWeight * (maxNodeSize - minNodeSize);
                    });

                    if (!targetNodes.length || !targetLinks.length) return console.error('Nodes or links arrays are empty');

                    const minLinkWeight = Math.min(...targetLinks.map(link => link.value));
                    const maxLinkWeight = Math.max(...targetLinks.map(link => link.value));

                    targetLinks.forEach(link => {
                        link.width = minLinkWidth + ((link.value - minLinkWeight) / (maxLinkWeight - minLinkWeight)) * (maxLinkWidth - minLinkWidth);
                    });

                    window.chart = Highcharts.chart('container', {
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
                                    const { id, overallCount, correspondences } = this.point;
                                    let tooltipText = `<b>${id}</b><br>Erwähnungen: ${overallCount}`;
                                    if (correspondences.length > 0) {
                                        const sortedCorrespondences = correspondences.sort((a, b) => b.weight - a.weight);
                                        sortedCorrespondences.forEach(correspondence => {
                                            tooltipText += `<br>Erwähnungen in Korrespondenz ${correspondence.from}: ${correspondence.weight}`;
                                        });
                                    }
                                    return tooltipText;
                                }
                                return `<b>${this.point.id}</b>`;
                            }
                        },
                        plotOptions: {
                            networkgraph: {
                                keys: ['from', 'to'],
                                layoutAlgorithm: {
                                    initialPositions: 'circle',
                                    enableSimulation: true,
                                    gravitationalConstant: 0,
                                    linkLength: 50,
                                    friction: -0.9
                                },
                                dataLabels: {
                                    enabled: true,
                                    linkFormat: '',
                                    allowOverlap: false,
                                    style: {
                                        textOutline: 'none'
                                    },
                                    formatter: function () {
                                        return this.point.id;
                                    }
                                },
                                link: {
                                    marker: {
                                        enabled: true,
                                        radius: 5,
                                        width: 1
                                    },
                                    width: 'width'
                                }
                            }
                        },
                        series: [{
                            dataLabels: {
                                enabled: true, linkFormat: '', allowOverlap: true, style: { textOutline: 'none' },
                                formatter: function () { return this.point.id; }
                            },
                            nodes: targetNodes,
                            data: targetLinks,
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
                            enabled: true
                        }
                    });
                },
                error: error => console.error('Error parsing the CSV file:', error)
            });
        })
        .catch(error => console.error('Error loading the CSV file:', error));
});