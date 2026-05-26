(function () {
    var BASE_URL = 'https://raw.githubusercontent.com/arthur-schnitzler/schnitzler-briefe-charts/main/venn/';

    var dataCache = {};
    var currentEntity = 'person';
    var chart = null;
    var selectedProjects = { 'schnitzler-briefe': true };

    function getCombinations(arr, size) {
        if (size === 1) { return arr.map(function (x) { return [x]; }); }
        var result = [];
        for (var i = 0; i <= arr.length - size; i++) {
            var sub = getCombinations(arr.slice(i + 1), size - 1);
            for (var j = 0; j < sub.length; j++) {
                result.push([arr[i]].concat(sub[j]));
            }
        }
        return result;
    }

    function intersectionKey(projects) {
        return projects.slice().sort().join('|');
    }

    function getCheckedProjects() {
        var result = [];
        document.querySelectorAll('#venn-project-list input[type="checkbox"]:not([disabled]):checked').forEach(function (cb) {
            result.push(cb.value);
        });
        return result;
    }

    function buildVennData(data, selected) {
        var points = [];
        for (var i = 0; i < selected.length; i++) {
            var pid = selected[i];
            var proj = data.projects[pid];
            if (!proj) { continue; }
            var countStr = proj.count.toLocaleString('de-AT');
            points.push({
                sets: [pid],
                value: proj.count,
                name: proj.label,
                label: proj.label + ': ' + countStr,
                color: proj.color
            });
        }
        for (var size = 2; size <= selected.length; size++) {
            var combos = getCombinations(selected, size);
            for (var c = 0; c < combos.length; c++) {
                var combo = combos[c];
                var key = intersectionKey(combo);
                var count = data.intersections[key];
                if (count !== undefined) {
                    var names = combo.map(function (id) {
                        return data.projects[id] ? data.projects[id].label : id;
                    });
                    var countStr2 = count.toLocaleString('de-AT');
                    points.push({
                        sets: combo,
                        value: Math.max(count, 0.5),
                        name: countStr2,
                        label: names.join(' ∩ ') + ': ' + countStr2
                    });
                }
            }
        }
        return points;
    }

    function updateProjectAvailability(data) {
        document.querySelectorAll('#venn-project-list input[type="checkbox"]').forEach(function (cb) {
            var available = Object.prototype.hasOwnProperty.call(data.projects, cb.value);
            cb.disabled = !available;
            var row = cb.closest('.form-check');
            if (row) { row.style.display = available ? '' : 'none'; }
            if (!available) {
                cb.checked = false;
            } else {
                cb.checked = !!selectedProjects[cb.value];
            }
        });
    }

    function loadData(entity, callback) {
        if (dataCache[entity]) { callback(null, dataCache[entity]); return; }
        fetch(BASE_URL + entity + '.json')
            .then(function (r) {
                if (!r.ok) { throw new Error('HTTP ' + r.status); }
                return r.json();
            })
            .then(function (data) {
                dataCache[entity] = data;
                callback(null, data);
            })
            .catch(function (err) { callback(err, null); });
    }

    function renderChart() {
        var selected = getCheckedProjects();
        var infoEl = document.getElementById('venn-info');

        if (selected.length < 2) {
            infoEl.textContent = 'Bitte mindestens zwei Projekte auswählen.';
            if (chart) { chart.destroy(); chart = null; }
            return;
        }

        infoEl.textContent = 'Lade Daten…';

        loadData(currentEntity, function (err, data) {
            if (err) {
                infoEl.textContent = 'Daten noch nicht verfügbar (' + currentEntity + '.json).';
                return;
            }

            updateProjectAvailability(data);

            var available = getCheckedProjects();
            if (available.length < 2) {
                infoEl.textContent = 'Für diesen Entitätstyp sind keine weiteren Projekte verfügbar.';
                if (chart) { chart.destroy(); chart = null; }
                return;
            }

            var vennData = buildVennData(data, available);
            if (chart) { chart.destroy(); chart = null; }

            chart = Highcharts.chart('venn-container', {
                chart: { type: 'venn' },
                title: { text: null },
                series: [{ type: 'venn', data: vennData }],
                tooltip: {
                    formatter: function () { return this.point.label; }
                },
                credits: { enabled: false },
                exporting: {
                    enabled: true,
                    buttons: { contextButton: { menuItems: ['downloadPNG', 'downloadSVG'] } }
                }
            });

            infoEl.textContent = '';
        });
    }

    function onEntityChange(entity) {
        currentEntity = entity;
        loadData(entity, function (err, data) {
            if (err) {
                document.getElementById('venn-info').textContent = 'Daten nicht verfügbar.';
                return;
            }
            updateProjectAvailability(data);
            renderChart();
        });
    }

    window.initVennChart = function () {
        document.querySelectorAll('#vennEntityTabs button[data-entity]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('#vennEntityTabs button').forEach(function (b) {
                    b.classList.remove('active');
                    b.setAttribute('aria-selected', 'false');
                });
                this.classList.add('active');
                this.setAttribute('aria-selected', 'true');
                onEntityChange(this.getAttribute('data-entity'));
            });
        });

        document.querySelectorAll('#venn-project-list input[type="checkbox"]').forEach(function (cb) {
            cb.addEventListener('change', function () {
                var checkedCount = document.querySelectorAll(
                    '#venn-project-list input[type="checkbox"]:not([disabled]):checked'
                ).length;
                if (checkedCount > 3) {
                    this.checked = false;
                    document.getElementById('venn-info').textContent =
                        'Maximal 3 Projekte können ausgewählt werden (3 Kreise).';
                    return;
                }
                if (this.checked) {
                    selectedProjects[this.value] = true;
                } else {
                    delete selectedProjects[this.value];
                }
                renderChart();
            });
        });

        var defaultCb = document.getElementById('vproj-schnitzler-tagebuch');
        if (defaultCb) {
            defaultCb.checked = true;
            selectedProjects['schnitzler-tagebuch'] = true;
        }
        renderChart();
    };
}());
