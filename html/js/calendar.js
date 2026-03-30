// Calendar initialization for schnitzler-briefe-static
// Uses SimpleCalendar instead of js-year-calendar

let calendar;
let data = [];
let years = [];

// Convert calendarData format to SimpleCalendar format
let activeFilters = new Set(['as-sender', 'as-empf', 'umfeld', 'gedruckt', 'fischer']); // All active by default
window.activeFilters = activeFilters; // Make globally available for SimpleCalendar

function processCalendarData() {
  data = calendarData.map(r => ({
    startDate: r.startDate,
    endDate: r.startDate, // Same day event
    name: r.name,
    linkId: r.id,
    category: r.category,
    tageszaehler: r.tageszaehler,
    bibliographic: r.bibliographic,  // Preserve bibliographic data for printed letters
    link_url: r.link_url             // External link URL (e.g. Fischer Briefdatenbank)
  }));

  // Get available years
  years = Array.from(new Set(calendarData.map(r =>
    r.startDate.split('-')[0]
  ))).sort();
}

// Filter data based on active categories
function getFilteredData() {
  return data.filter(event => activeFilters.has(event.category));
}


// Day click handler - preserves original functionality
function handleDayClick(e) {
  const events = e.events;
  const date = e.date;

  if (events.length === 1) {
    // Single event - check if it's a printed/CMIF letter
    if (events[0].category === 'gedruckt' || events[0].category === 'fischer') {
      showPrintedLetterPopup(events[0]);
    } else {
      // Navigate to regular letter
      window.location.href = events[0].linkId;
    }
  } else if (events.length > 1) {
    // Multiple events - show modal
    showEventsModal(events, date);
  }
}

// Show popup for printed letters - make globally available
function showPrintedLetterPopup(event) {
  window.showPrintedLetterPopup = showPrintedLetterPopup; // Make globally available
  const categoryColors = {
    'gedruckt': 'rgb(101, 67, 33)',
    'fischer': '#3D4F9F'
  };
  const color = categoryColors[event.category] || 'rgb(101, 67, 33)';
  let html = "<div class='modal fade' id='printedLetterModal' tabindex='-1' aria-labelledby='printedLetterModalLabel' aria-hidden='true'>";
  html += "<div class='modal-dialog' role='document'>";
  html += "<div class='modal-content'>";
  html += "<div class='modal-header'>";
  html += "<h5 class='modal-title' id='printedLetterModalLabel'>Externer Brief</h5>";
  html += "<button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>";
  html += "</div><div class='modal-body'>";

  // Letter title
  html += "<h6 style='color: " + color + ";'>" + event.name + "</h6>";

  // Source information
  if (event.category === 'fischer' && event.link_url) {
    html += "<p style='color: " + color + ";'><a href='" + event.link_url + "' style='color: " + color + ";'>S. Fischer-Briefdatenbank</a></p>";
  } else {
    html += "<p style='color: " + color + ";'><strong>Gedruckt in:</strong><br>";
    html += event.bibliographic || "Bibliographische Angabe nicht verfügbar";
    html += "</p>";
  }

  html += "</div>";
  html += "<div class='modal-footer'>";
  html += "<button type='button' class='btn btn-secondary' data-bs-dismiss='modal'>Schließen</button>";
  html += "</div></div></div></div>";

  // Remove existing modal and add new one
  $('#printedLetterModal').remove();
  $('#loadModal').append(html);
  $('#printedLetterModal').modal('show');
}

// Show events modal (preserves original modal functionality) - make globally available
function showEventsModal(events, date) {
  window.showEventsModal = showEventsModal; // Make globally available
  // Format date for title without leading zeros
  const day = date.getDate();
  const month = date.getMonth() + 1;
  const year = date.getFullYear();
  const dateStr = `${day}.${month}.${year}`;

  let html = "<div class='modal fade' id='dialogForLinks' tabindex='-1' aria-labelledby='modalLabel' aria-hidden='true'>";
  html += "<div class='modal-dialog' role='document'>";
  html += "<div class='modal-content'>";
  html += "<div class='modal-header'>";
  html += "<h5 class='modal-title' id='modalLabel'>Briefe vom " + dateStr + "</h5>";
  html += "<button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>";
  html += "</div><div class='modal-body'>";

  // Category colors mapping
  const categoryColors = {
    'as-sender': '#A63437',    // Briefe Schnitzlers (red)
    'as-empf': '#1C6E8C',      // Briefe an Schnitzler (blue)
    'umfeld': '#68825b',       // Umfeldbriefe (green)
    'gedruckt': 'rgb(101, 67, 33)',  // Gedruckte Briefe (brown)
    'fischer': '#3D4F9F'       // S. Fischer
  };

  // Separate printed/CMIF letters from regular letters
  const regularEvents = events.filter(event => event.category !== 'gedruckt' && event.category !== 'fischer');
  const printedEvents = events.filter(event => event.category === 'gedruckt' || event.category === 'fischer');

  // Sort regular events by tageszaehler (preserving original sorting logic)
  let numbersTitlesAndIds = [];
  regularEvents.forEach((event, i) => {
    numbersTitlesAndIds.push({
      'i': i,
      'position': event.tageszaehler,
      'linkTitle': event.name,
      'id': event.linkId,
      'category': event.category
    });
  });

  numbersTitlesAndIds.sort((a, b) => {
    let positionOne = parseInt(a.position);
    let positionTwo = parseInt(b.position);
    if (positionOne < positionTwo) return -1;
    if (positionOne > positionTwo) return 1;
    return 0;
  });

  // Add regular letters
  numbersTitlesAndIds.forEach(item => {
    const color = categoryColors[item.category] || '#999999';
    html += "<div class='indent' style='margin: 8px 0;'>";
    html += "<a href='" + item.id + "' style='color: " + color + "; text-decoration: none; font-weight: 500; display: block; padding: 4px 0;'>" + item.linkTitle + "</a>";
    html += "</div>";
  });

  // Add printed letters section if there are any
  if (printedEvents.length > 0) {
    if (regularEvents.length > 0) {
      html += "<hr style='margin: 16px 0; border-color: #dee2e6;'>";
    }
    html += "<h6 style='margin: 12px 0 8px 0; color: #6c757d;'>Externe Briefe</h6>";

    printedEvents.forEach(event => {
      const color = categoryColors[event.category] || 'rgb(101, 67, 33)';
      html += "<div class='indent' style='margin: 8px 0; padding: 8px;'>";
      html += "<div style='color: " + color + "; font-weight: 500; margin-bottom: 4px;'>" + event.name + "</div>";
      if (event.category === 'fischer' && event.link_url) {
        html += "<div style='font-size: 0.9em;'><a href='" + event.link_url + "' style='color: " + color + ";'>S. Fischer-Briefdatenbank</a></div>";
      } else {
        html += "<div style='font-size: 0.9em; color: " + color + ";'><strong>Gedruckt in:</strong><br>";
        html += (event.bibliographic || "Bibliographische Angabe nicht verfügbar");
        html += "</div>";
      }
      html += "</div>";
    });
  }

  html += "</div>";
  html += "<div class='modal-footer'>";
  html += "<button type='button' class='btn btn-secondary' data-bs-dismiss='modal'>Schließen</button>";
  html += "</div></div></div></div>";

  // Remove existing modal and add new one
  $('#dialogForLinks').remove();
  $('#loadModal').append(html);
  $('#dialogForLinks').modal('show');
}

// Initialize calendar when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Process calendar data
  processCalendarData();

  // Make functions globally available for simple-calendar.js
  window.showPrintedLetterPopup = showPrintedLetterPopup;
  window.showEventsModal = showEventsModal;

  // Initialize SimpleCalendar
  calendar = new SimpleCalendar('calendar', {
    startYear: 1900,
    dataSource: data,  // Use all data, filtering is handled inside SimpleCalendar
    clickDay: handleDayClick
  });
});
