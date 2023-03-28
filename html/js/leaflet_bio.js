$(".leaflet-maps").each(function () {
    var lat = $(this).attr('lat');
    var long = $(this).attr('long');
    var mymap = L.map(this).setView([lat,long], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &amp;copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.openstreetmap.org/">OpenStreetMap</a>',
        maxZoom: 18,
        zIndex: 1
    }).addTo(mymap);

    L.marker([lat, long]).addTo(mymap);
});