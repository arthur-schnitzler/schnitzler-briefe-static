document.addEventListener('DOMContentLoaded', () => {
    console.log('Interactive Networks loaded');

    let currentChart = null;
    let allData = {};
    let labelsEnabled = true;

    // Search functionality
    const searchInput = document.getElementById('correspondence-search');
    const correspondenceItems = document.querySelectorAll('.correspondence-item');

    searchInput.addEventListener('input', (e) => {
        const searchTerm = e.target.value.toLowerCase();
        correspondenceItems.forEach(item => {
            const name = item.dataset.name.toLowerCase();
            item.style.display = name.includes(searchTerm) ? 'block' : 'none';
        });
    });

    // Select/Clear all buttons
    document.getElementById('select-all').addEventListener('click', () => {
        document.querySelectorAll('.correspondence-checkbox:not([style*="display: none"])').forEach(cb => {
            cb.checked = true;
        });
    });

    document.getElementById('clear-all').addEventListener('click', () => {
        document.querySelectorAll('.correspondence-checkbox').forEach(cb => {
            cb.checked = false;
        });
    });

    // Range sliders
    const minMentionsSlider = document.getElementById('min-mentions');
    const minMentionsValue = document.getElementById('min-mentions-value');
    minMentionsSlider.addEventListener('input', (e) => {
        minMentionsValue.textContent = e.target.value;
    });

    const maxNodesSlider = document.getElementById('max-nodes');
    const maxNodesValue = document.getElementById('max-nodes-value');
    maxNodesSlider.addEventListener('input', (e) => {
        maxNodesValue.textContent = e.target.value;
    });

    // Toggle labels button
    const toggleLabelsBtn = document.getElementById('toggle-labels');
    if (toggleLabelsBtn) {
        toggleLabelsBtn.addEventListener('click', () => {
            labelsEnabled = !labelsEnabled;
            if (currentChart && currentChart.series[0]) {
                currentChart.series[0].update({
                    dataLabels: {
                        enabled: labelsEnabled
                    }
                });
            }
        });
    }

    // Toggle fullscreen button
    const toggleFullscreenBtn = document.getElementById('toggle-fullscreen');
    const networkContainer = document.getElementById('network-container');
    if (toggleFullscreenBtn && networkContainer) {
        toggleFullscreenBtn.addEventListener('click', () => {
            if (!document.fullscreenElement) {
                networkContainer.requestFullscreen().catch(err => {
                    console.error(`Error attempting to enable fullscreen: ${err.message}`);
                });
                toggleFullscreenBtn.innerHTML = '<i class="fa fa-compress"></i> Vollbild beenden';
            } else {
                document.exitFullscreen();
                toggleFullscreenBtn.innerHTML = '<i class="fa fa-expand"></i> Vollbild';
            }
        });

        // Update button text when exiting fullscreen via ESC
        document.addEventListener('fullscreenchange', () => {
            if (!document.fullscreenElement) {
                toggleFullscreenBtn.innerHTML = '<i class="fa fa-expand"></i> Vollbild';
            }
        });
    }

    // Helper function to get entity type configuration
    const getEntityTypeConfig = (entityType) => {
        const configs = {
            person: { idColumn: 'PersID', path: 'person_freq_corr_weights_directed' },
            place: { idColumn: 'PlaceID', path: 'place_freq_corr_weights_directed' },
            institution: { idColumn: 'OrgID', path: 'institution_freq_corr_weights_directed' },
            work: { idColumn: 'WorkID', path: 'work_freq_corr_weights_directed' },
            event: { idColumn: 'EventID', path: 'event_freq_corr_weights_directed' }
        };
        return configs[entityType];
    };

    // Load CSV data for a correspondence and entity type
    const loadCorrespondenceData = async (corrId, entityType) => {
        const config = getEntityTypeConfig(entityType);
        // Try local file first, then GitHub as fallback
        const localUrl = `network-data/${config.path}_correspondence_${corrId}_alle.csv`;
        const githubUrl = `https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/netzwerke/${config.path}/${config.path}_correspondence_${corrId}_alle.csv`;

        try {
            // Try local file first
            let response = await fetch(localUrl);
            if (!response.ok) {
                // Fallback to GitHub
                console.log(`Local file not found, trying GitHub for ${corrId} ${entityType}`);
                response = await fetch(githubUrl);
                if (!response.ok) return null;
            }

            const csvText = await response.text();
            return new Promise((resolve, reject) => {
                Papa.parse(csvText, {
                    header: true,
                    complete: ({ data }) => {
                        console.log(`Loaded ${data.length} rows for ${corrId} ${entityType}`);
                        resolve({ corrId, entityType, data, config });
                    },
                    error: reject
                });
            });
        } catch (error) {
            console.warn(`Could not load data for correspondence ${corrId}, entity ${entityType}:`, error);
            return null;
        }
    };

    // Combine data from multiple correspondences
    const combineNetworkData = (datasets, minMentions, maxNodes) => {
        console.log('combineNetworkData called with:', {
            datasetsCount: datasets.length,
            minMentions,
            maxNodes
        });

        const nodes = {};
        const links = [];
        const correspondenceColors = [
            '#A63437', '#3785A6', '#37A663', '#A67837', '#8437A6',
            '#37A6A6', '#A63785', '#85A637', '#3737A6', '#A6A637'
        ];

        // Track which entities appear in multiple correspondences
        const entityOccurrences = {};
        let processedRows = 0;
        let skippedRows = 0;

        datasets.forEach((dataset, idx) => {
            if (!dataset || !dataset.data) {
                console.warn('Empty dataset at index', idx);
                return;
            }

            const { corrId, data, config } = dataset;
            const color = correspondenceColors[idx % correspondenceColors.length];
            console.log(`Processing dataset ${idx}: corrId=${corrId}, rows=${data.length}, idColumn=${config.idColumn}`);

            data.forEach(row => {
                const source = row.Source?.trim();
                const corrIdFromRow = row.CorrID?.trim();
                const target = row.Target?.trim();
                const targetId = row[config.idColumn]?.trim();
                const weight = parseInt(row.Weight, 10) || 0;
                const overallCount = parseInt(row.Overallcount, 10) || 0;

                if (!source || !target || weight < minMentions) {
                    skippedRows++;
                    return;
                }

                processedRows++;

                // Track source nodes (correspondence partners)
                if (!nodes[source]) {
                    nodes[source] = {
                        id: source,
                        weight: 0,
                        correspondences: new Set(),
                        marker: { fillColor: color },
                        isSource: true
                    };
                }
                nodes[source].correspondences.add(corrId);

                // Track target nodes (entities)
                const targetKey = `${target}_${targetId || 'no-id'}`;
                if (!nodes[targetKey]) {
                    nodes[targetKey] = {
                        id: targetKey,  // Use targetKey as id for uniqueness
                        name: target,   // Store display name separately
                        weight: 0,
                        overallWeight: overallCount,
                        correspondences: new Set(),
                        marker: { fillColor: '#6c757d' },
                        url: targetId ? `https://schnitzler-briefe.acdh.oeaw.ac.at/pmb${targetId}.html` : null
                    };
                    entityOccurrences[targetKey] = 0;
                }

                nodes[targetKey].weight += weight;
                nodes[targetKey].correspondences.add(corrId);
                entityOccurrences[targetKey]++;

                // Create link
                links.push({
                    from: source,
                    to: targetKey,
                    value: weight,
                    color: color,
                    correspondence: corrId
                });
            });
        });

        // Calculate overlaps (entities appearing in multiple correspondences)
        const overlaps = Object.values(entityOccurrences).filter(count => count > 1).length;

        // Highlight nodes that appear in multiple correspondences
        Object.entries(nodes).forEach(([key, node]) => {
            if (node.correspondences.size > 1 && !node.isSource) {
                node.marker.fillColor = '#ffc107'; // Yellow for overlapping entities
                node.isOverlap = true;
            }
        });

        // Sort nodes by weight and limit to maxNodes
        const sortedNodes = Object.values(nodes)
            .filter(n => !n.isSource) // Don't count source nodes in limit
            .sort((a, b) => b.weight - a.weight)
            .slice(0, maxNodes);

        // Keep all source nodes plus top entities
        const nodeIds = new Set([
            ...Object.values(nodes).filter(n => n.isSource).map(n => n.id),
            ...sortedNodes.map(n => n.id)
        ]);

        // Filter links to only include nodes we're keeping
        const filteredLinks = links.filter(link =>
            nodeIds.has(link.from) && nodeIds.has(link.to)
        );

        // Build final node list
        const finalNodes = Object.values(nodes).filter(n => nodeIds.has(n.id));

        // Normalize node sizes
        const weights = finalNodes.filter(n => !n.isSource).map(n => n.weight);
        const minWeight = Math.min(...weights);
        const maxWeight = Math.max(...weights);
        const minNodeSize = 5;
        const maxNodeSize = 25;

        finalNodes.forEach(node => {
            if (!node.isSource) {
                const normalizedWeight = weights.length > 1
                    ? (node.weight - minWeight) / (maxWeight - minWeight)
                    : 0.5;
                node.marker.radius = minNodeSize + normalizedWeight * (maxNodeSize - minNodeSize);
            } else {
                node.marker.radius = 15; // Fixed size for correspondence nodes
            }
        });

        console.log('combineNetworkData results:', {
            processedRows,
            skippedRows,
            totalNodesBeforeFilter: Object.keys(nodes).length,
            totalLinksBeforeFilter: links.length,
            finalNodes: finalNodes.length,
            filteredLinks: filteredLinks.length,
            overlaps
        });

        return {
            nodes: finalNodes,
            links: filteredLinks,
            stats: {
                totalNodes: finalNodes.length,
                totalLinks: filteredLinks.length,
                overlaps: overlaps
            }
        };
    };

    // Render the network graph
    const renderNetwork = (networkData, correspondenceCount) => {
        const container = document.getElementById('network-container');

        if (!networkData.nodes.length || !networkData.links.length) {
            document.getElementById('network-info').innerHTML =
                '<p class="alert alert-warning">Keine Daten für die ausgewählten Korrespondenzen und Einstellungen gefunden.</p>';
            document.getElementById('network-stats').style.display = 'none';
            container.innerHTML = '';
            return;
        }

        document.getElementById('network-info').style.display = 'none';
        document.getElementById('network-stats').style.display = 'block';
        document.getElementById('network-controls').style.display = 'block';

        // Update stats
        document.getElementById('stat-correspondences').textContent = correspondenceCount;
        document.getElementById('stat-nodes').textContent = networkData.stats.totalNodes;
        document.getElementById('stat-connections').textContent = networkData.stats.totalLinks;
        document.getElementById('stat-overlaps').textContent = networkData.stats.overlaps;

        // Destroy previous chart if exists
        if (currentChart) {
            currentChart.destroy();
        }

        // Create new chart
        currentChart = Highcharts.chart('network-container', {
            chart: {
                type: 'networkgraph',
                panning: { enabled: true, type: 'xy' },
                panKey: 'shift',
                zoomType: 'xy',
                height: 600
            },
            title: { text: null },
            tooltip: {
                formatter: function () {
                    if (this.point.isNode) {
                        const { id, name, weight, overallWeight, correspondences, isSource, isOverlap } = this.point;
                        const displayName = name || id;
                        if (isSource) {
                            return `<b>${displayName}</b><br>Korrespondenz-Partner<br>Korrespondenzen: ${correspondences.size}`;
                        }
                        let tooltip = `<b>${displayName}</b><br>`;
                        tooltip += `Erwähnungen gesamt: ${overallWeight || weight}<br>`;
                        tooltip += `Erwähnungen in ausgewählten Korrespondenzen: ${weight}<br>`;
                        tooltip += `Vorkommend in ${correspondences.size} Korrespondenz${correspondences.size > 1 ? 'en' : ''}`;
                        if (isOverlap) {
                            tooltip += '<br><span style="color: #ffc107;">★ Überschneidung</span>';
                        }
                        return tooltip;
                    }
                    return false;
                }
            },
            plotOptions: {
                networkgraph: {
                    keys: ['from', 'to'],
                    layoutAlgorithm: {
                        enableSimulation: true,
                        linkLength: 100,
                        integration: 'verlet',
                        approximation: 'barnes-hut'
                    }
                }
            },
            series: [{
                dataLabels: {
                    enabled: labelsEnabled,
                    linkFormat: '',
                    allowOverlap: false,
                    style: { textOutline: 'none', fontSize: '11px' },
                    formatter: function () {
                        return this.point.name || this.point.id;
                    }
                },
                nodes: networkData.nodes,
                data: networkData.links,
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
    };

    // Main generate button handler
    document.getElementById('generate-network').addEventListener('click', async () => {
        const selectedCorrespondences = Array.from(
            document.querySelectorAll('.correspondence-checkbox:checked')
        ).map(cb => cb.value);

        const selectedEntityTypes = Array.from(
            document.querySelectorAll('.entity-type-checkbox:checked')
        ).map(cb => cb.value);

        if (selectedCorrespondences.length === 0) {
            alert('Bitte wählen Sie mindestens eine Korrespondenz aus.');
            return;
        }

        if (selectedEntityTypes.length === 0) {
            alert('Bitte wählen Sie mindestens einen Entitätstyp aus.');
            return;
        }

        const minMentions = parseInt(minMentionsSlider.value);
        const maxNodes = parseInt(maxNodesSlider.value);

        // Update labels setting from checkbox
        const showLabelsCheckbox = document.getElementById('show-labels');
        if (showLabelsCheckbox) {
            labelsEnabled = showLabelsCheckbox.checked;
        }

        // Show loading indicator
        document.getElementById('loading-indicator').style.display = 'block';
        document.getElementById('network-container').innerHTML = '';
        document.getElementById('network-stats').style.display = 'none';

        try {
            // Load all data
            const loadPromises = [];
            selectedCorrespondences.forEach(corrId => {
                selectedEntityTypes.forEach(entityType => {
                    loadPromises.push(loadCorrespondenceData(corrId, entityType));
                });
            });

            const datasets = await Promise.all(loadPromises);
            const validDatasets = datasets.filter(d => d !== null);

            if (validDatasets.length === 0) {
                document.getElementById('network-info').innerHTML =
                    '<p class="alert alert-warning">Keine Netzwerkdaten für die ausgewählten Korrespondenzen gefunden.</p>';
                document.getElementById('loading-indicator').style.display = 'none';
                return;
            }

            // Combine and render
            const networkData = combineNetworkData(validDatasets, minMentions, maxNodes);
            renderNetwork(networkData, selectedCorrespondences.length);

        } catch (error) {
            console.error('Error generating network:', error);
            document.getElementById('network-info').innerHTML =
                '<p class="alert alert-danger">Fehler beim Laden der Netzwerkdaten.</p>';
        } finally {
            document.getElementById('loading-indicator').style.display = 'none';
        }
    });
});
