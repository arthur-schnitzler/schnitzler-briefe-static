/* Generic network chart initializer for netzwerke.html */
(function () {
    var sourceColor = '#A63437';
    var targetColor = '#3785A6';
    var minNodeSize = 2, maxNodeSize = 20;
    var minLinkWidth = 0.5, maxLinkWidth = 5;
    var charts = {};

    function resizeContainer(containerId) {
        var el = document.getElementById(containerId);
        if (el) {
            el.style.width = (window.innerWidth * 0.8) + 'px';
            el.style.height = (window.innerHeight * 0.6) + 'px';
            if (charts[containerId]) { charts[containerId].reflow(); }
        }
    }

    function loadCSV(csvUrl, containerId) {
        fetch(csvUrl)
            .then(function (r) { return r.ok ? r.text() : Promise.reject(r.statusText); })
            .then(function (csvText) {
                Papa.parse(csvText, {
                    header: true,
                    complete: function (result) {
                        var data = result.data;
                        if (!data.length) { return; }

                        var nodes = {}, links = [];

                        data.forEach(function (row) {
                            var source = row.Source && row.Source.trim();
                            var target = row.Target && row.Target.trim();
                            var sourceId = row.SID && row.SID.trim();
                            var targetId = row.TID && row.TID.trim();
                            var overallCount = parseInt(row.Overallcount, 10) || 0;
                            var weight = parseInt(row.Weight, 10) || 0;
                            if (!source || !target) { return; }

                            if (!nodes[source]) {
                                nodes[source] = {
                                    id: source,
                                    overallCount: 0,
                                    marker: { fillColor: sourceColor },
                                    url: 'https://schnitzler-briefe.acdh.oeaw.ac.at/toc_' + sourceId + '.html',
                                    correspondences: []
                                };
                            }
                            if (!nodes[target]) {
                                nodes[target] = {
                                    id: target,
                                    overallCount: overallCount,
                                    marker: { fillColor: targetColor },
                                    url: 'https://schnitzler-briefe.acdh.oeaw.ac.at/pmb' + targetId + '.html',
                                    correspondences: []
                                };
                            }
                            nodes[target].correspondences.push({ from: source, weight: weight });
                            links.push({ from: source, to: target, value: weight, width: weight });
                        });

                        var allNodes = Object.values(nodes);
                        var weights = allNodes.map(function (n) { return n.overallCount; });
                        var minW = Math.min.apply(null, weights);
                        var maxW = Math.max.apply(null, weights);

                        allNodes.forEach(function (node) {
                            var norm = (maxW === minW) ? 1 : (node.overallCount - minW) / (maxW - minW);
                            node.marker.radius = minNodeSize + norm * (maxNodeSize - minNodeSize);
                        });

                        var linkVals = links.map(function (l) { return l.value; });
                        var minLW = Math.min.apply(null, linkVals);
                        var maxLW = Math.max.apply(null, linkVals);
                        links.forEach(function (link) {
                            link.width = minLinkWidth + ((link.value - minLW) / (maxLW - minLW)) * (maxLinkWidth - minLinkWidth);
                        });

                        resizeContainer(containerId);

                        charts[containerId] = Highcharts.chart(containerId, {
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
                                        var pt = this.point;
                                        var txt = '<b>' + pt.id + '</b>';
                                        if (pt.marker.fillColor === targetColor && pt.overallCount > 0) {
                                            txt += '<br>Erwähnungen: ' + pt.overallCount;
                                        }
                                        pt.correspondences.sort(function (a, b) { return b.weight - a.weight; }).forEach(function (c) {
                                            txt += '<br>Erwähnungen in Korrespondenz ' + c.from + ': ' + c.weight;
                                        });
                                        return txt;
                                    }
                                    return '<b>' + this.point.id + '</b>';
                                }
                            },
                            plotOptions: {
                                networkgraph: {
                                    keys: ['from', 'to'],
                                    layoutAlgorithm: {
                                        initialPositions: 'circle',
                                        enableSimulation: true,
                                        gravitationalConstant: 0,
                                        linkLength: 35,
                                        friction: -0.9
                                    },
                                    dataLabels: {
                                        enabled: true,
                                        linkFormat: '',
                                        allowOverlap: false,
                                        style: { textOutline: 'none' },
                                        formatter: function () { return this.point.id; }
                                    },
                                    link: { marker: { enabled: true, radius: 5, width: 1 }, width: 'width' }
                                }
                            },
                            series: [{
                                dataLabels: {
                                    enabled: true, linkFormat: '', allowOverlap: false,
                                    style: { textOutline: 'none' },
                                    formatter: function () { return this.point.id; }
                                },
                                nodes: allNodes,
                                data: links,
                                point: {
                                    events: {
                                        click: function () {
                                            if (this.url) { window.open(this.url, '_blank'); }
                                        }
                                    }
                                }
                            }],
                            exporting: { enabled: false }
                        });
                    },
                    error: function (err) { console.error('CSV parse error:', err); }
                });
            })
            .catch(function (err) { console.error('CSV load error:', err); });
    }

    window.initNetworkChart = function (containerId, btnClass) {
        if (charts[containerId]) { return; }
        var buttons = document.querySelectorAll(btnClass);
        buttons.forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                buttons.forEach(function (b) { b.style.backgroundColor = '#A63437'; });
                e.target.style.backgroundColor = '#C04040';
                loadCSV(e.target.getAttribute('data-csv'), containerId);
            });
        });
        if (buttons.length) {
            buttons[0].style.backgroundColor = '#C04040';
            loadCSV(buttons[0].getAttribute('data-csv'), containerId);
        }
    };

    window.addEventListener('resize', function () {
        Object.keys(charts).forEach(resizeContainer);
    });
}());
