// holds shared config for all tabulator-js tables

var config = {
    height: 800,
    layout:"fitColumns",
    autoColumns:true,
    tooltips: true,
    dataLoader: true,
    resizable: true
};

// Toggle-Spalte für responsiveLayout:"collapse": klappt auf schmalen
// Bildschirmen die ausgeblendeten Spalten pro Zeile auf/zu
var tabulatorCollapseColumn = {
    formatter: "responsiveCollapse",
    width: 40,
    minWidth: 40,
    hozAlign: "center",
    resizable: false,
    headerSort: false,
    responsive: 0
};


