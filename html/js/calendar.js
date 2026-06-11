// Calendar initialization for schnitzler-briefe-static
// Bereitet calendarData auf und initialisiert SimpleCalendar.
// Tagesdetails (inkl. gedruckter Briefe) zeigt SimpleCalendar im Drawer an.

let calendar;
let data = [];

// Aktive Kategoriefilter – global, wird von SimpleCalendar gelesen
let activeFilters = new Set(['as-sender', 'as-empf', 'umfeld', 'gedruckt', 'fischer']);
window.activeFilters = activeFilters;

function processCalendarData() {
  data = calendarData.map(r => ({
    startDate: r.startDate,
    name: r.name,
    linkId: r.id,
    category: r.category,
    categoryLabel: r.categoryLabel,
    tageszaehler: r.tageszaehler,
    bibliographic: r.bibliographic,  // Bibliographische Angabe gedruckter Briefe
    link_url: r.link_url             // Externer Link (z. B. Fischer-Briefdatenbank)
  }));
}

document.addEventListener('DOMContentLoaded', function() {
  processCalendarData();

  calendar = new SimpleCalendar('calendar', {
    startYear: 1900,
    dataSource: data
  });
});
