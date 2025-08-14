// Calendar initialization for schnitzler-briefe-static
// Uses SimpleCalendar instead of js-year-calendar

let calendar;
let data = [];
let years = [];

// Convert calendarData format to SimpleCalendar format
let activeFilters = new Set(['as-sender', 'as-empf', 'umfeld']); // All active by default
window.activeFilters = activeFilters; // Make globally available for SimpleCalendar

function processCalendarData() {
  data = calendarData.map(r => ({
    startDate: r.startDate,
    endDate: r.startDate, // Same day event
    name: r.name,
    linkId: r.id,
    category: r.category,
    tageszaehler: r.tageszaehler
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
    // Single event - navigate directly
    window.location.href = events[0].linkId;
  } else if (events.length > 1) {
    // Multiple events - show modal
    showEventsModal(events, date);
  }
}

// Show events modal (preserves original modal functionality)
function showEventsModal(events, date) {
  let html = "<div class='modal fade' id='dialogForLinks' tabindex='-1' aria-labelledby='modalLabel' aria-hidden='true'>";
  html += "<div class='modal-dialog' role='document'>";
  html += "<div class='modal-content'>";
  html += "<div class='modal-header'>";
  html += "<h5 class='modal-title' id='modalLabel'>Links</h5>";
  html += "<button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>";
  html += "</div><div class='modal-body'>";
  
  // Category colors mapping
  const categoryColors = {
    'as-sender': '#A63437',    // Briefe Schnitzlers (red)
    'as-empf': '#1C6E8C',      // Briefe an Schnitzler (blue)
    'umfeld': '#68825b'        // Umfeldbriefe (green)
  };
  
  // Sort events by tageszaehler (preserving original sorting logic)
  let numbersTitlesAndIds = [];
  events.forEach((event, i) => {
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
  
  numbersTitlesAndIds.forEach(item => {
    const color = categoryColors[item.category] || '#999999';
    html += "<div class='indent' style='margin: 8px 0;'>";
    html += "<a href='" + item.id + "' style='color: " + color + "; text-decoration: none; font-weight: 500; display: block; padding: 4px 0;'>" + item.linkTitle + "</a>";
    html += "</div>";
  });
  
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
  
  // Initialize SimpleCalendar
  calendar = new SimpleCalendar('calendar', {
    startYear: 1900,
    dataSource: data,  // Use all data, filtering is handled inside SimpleCalendar
    clickDay: handleDayClick
  });
});