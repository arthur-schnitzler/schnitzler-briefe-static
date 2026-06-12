// Balkendiagramm "Bildpostkarten pro Jahr" über der Tabulator-Tabelle.
// Wird aus bildpostkarten.html aufgerufen und aktualisiert sich bei jedem
// Filtern der Tabelle (Tabulator-Event "dataFiltered").
function initBildpostkartenChart(table, color) {
    var container = document.getElementById("bildpostkarten-chart");
    if (!container || typeof Highcharts === "undefined") return;

    var chart = null;

    // Jahr aus dem Datum-Feld ziehen: das HTML beginnt mit einem versteckten
    // ISO-Datum (<span hidden>1905-07-21</span>…), erster 4-Zeichen-Treffer genügt
    function yearOf(datumHtml) {
        var m = /(\d{4})/.exec(String(datumHtml));
        return m ? m[1] : null;
    }

    function buildSeries(rows) {
        var counts = {};
        rows.forEach(function (row) {
            var y = yearOf(row.getData().datum);
            if (y === null) return;
            if (counts[y] === undefined) counts[y] = 0;
            counts[y] += 1;
        });
        var years = Object.keys(counts).map(Number);
        var categories = [];
        var data = [];
        if (years.length > 0) {
            var min = Math.min.apply(null, years);
            var max = Math.max.apply(null, years);
            for (var y = min; y <= max; y++) {
                categories.push(String(y));
                data.push(counts[y] || 0);
            }
        }
        return { categories: categories, data: data };
    }

    function render(rows) {
        var s = buildSeries(rows);
        if (chart === null) {
            chart = Highcharts.chart(container, {
                chart: { type: "column", height: 250 },
                title: { text: null },
                xAxis: { categories: s.categories },
                yAxis: {
                    title: { text: "Anzahl" },
                    allowDecimals: false
                },
                legend: { enabled: false },
                credits: { enabled: false },
                exporting: { enabled: false },
                tooltip: { pointFormat: "Bildpostkarten: <b>{point.y}</b>" },
                plotOptions: {
                    column: { color: color, borderWidth: 0 }
                },
                series: [{ name: "Bildpostkarten", data: s.data }]
            });
        } else {
            chart.xAxis[0].setCategories(s.categories, false);
            chart.series[0].setData(s.data, true);
        }
    }

    // Erstes Rendern, sobald die Tabelle steht; danach bei jedem Filtern
    table.on("tableBuilt", function () {
        render(table.getRows("active"));
    });
    table.on("dataFiltered", function (filters, rows) {
        render(rows);
    });
}
