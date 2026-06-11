// Calendar initialization for schnitzler-briefe-static
// Uses SimpleCalendar instead of js-year-calendar
// Tagesdetails öffnen sich in einer seitlichen Spalte (Drawer) statt in Modals;
// dort kann mit Vortag/Folgetag tageweise geblättert werden.

let calendar;
let data = [];
let years = [];

// Convert calendarData format to SimpleCalendar format
let activeFilters = new Set(['as-sender', 'as-empf', 'umfeld', 'gedruckt', 'fischer']); // All active by default
window.activeFilters = activeFilters; // Make globally available for SimpleCalendar

// Kategorie-Farben (identisch mit simple-calendar.js)
const categoryColors = {
  'as-sender': '#A63437',          // Briefe Schnitzlers (rot)
  'as-empf': '#1C6E8C',            // Briefe an Schnitzler (blau)
  'umfeld': '#68825b',             // Umfeldbriefe (grün)
  'gedruckt': 'rgb(101, 67, 33)',  // Gedruckte Briefe (braun)
  'fischer': '#3D4F9F'             // S. Fischer
};

const categoryLabels = {
  'as-sender': 'Brief von Schnitzler',
  'as-empf': 'Brief an Schnitzler',
  'umfeld': 'Umfeldbrief',
  'gedruckt': 'Gedruckter Brief',
  'fischer': 'S. Fischer'
};

const monthNamesDrawer = ['Jänner', 'Februar', 'März', 'April', 'Mai', 'Juni',
  'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
const dayNamesDrawer = ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag',
  'Freitag', 'Samstag'];

// Einträge nach Datum für das tageweise Blättern im Drawer
let eventsByDate = new Map();
let minDate = null;
let maxDate = null;

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

  // Index by date for the drawer
  eventsByDate = new Map();
  data.forEach(event => {
    if (!eventsByDate.has(event.startDate)) {
      eventsByDate.set(event.startDate, []);
    }
    eventsByDate.get(event.startDate).push(event);
  });
  const keys = [...eventsByDate.keys()].sort();
  minDate = keys[0] || null;
  maxDate = keys[keys.length - 1] || null;
}

// Filter data based on active categories
function getFilteredData() {
  return data.filter(event => activeFilters.has(event.category));
}


// Day click handler
function handleDayClick(e) {
  const events = e.events;
  const date = e.date;

  if (events.length === 1 &&
      events[0].category !== 'gedruckt' && events[0].category !== 'fischer') {
    // Single regular letter: navigate directly
    window.location.href = events[0].linkId;
  } else {
    // Otherwise open the day drawer
    openDayDrawer(dateToKey(date));
  }
}

/* ---------- Tages-Drawer (ersetzt die früheren Modals) ---------- */

function dateToKey(date) {
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${date.getFullYear()}-${m}-${d}`;
}

function keyToDate(key) {
  const p = key.split('-').map(Number);
  return new Date(p[0], p[1] - 1, p[2]);
}

function addDrawerStyles() {
  if (document.getElementById('calendar-drawer-styles')) return;
  const style = document.createElement('style');
  style.id = 'calendar-drawer-styles';
  style.textContent = `
    .cal-drawer-backdrop {
      position: fixed; inset: 0; background: rgba(0,0,0,.35); z-index: 1050;
      animation: cal-drawer-fade .18s ease;
    }
    .cal-drawer {
      position: fixed; top: 0; right: 0; bottom: 0; width: 420px; max-width: 92vw;
      background: #fff; box-shadow: -12px 0 36px rgba(0,0,0,.18);
      overflow: auto; display: flex; flex-direction: column;
      animation: cal-drawer-slide .22s cubic-bezier(.2,.7,.3,1);
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }
    @keyframes cal-drawer-fade { from { opacity: 0; } to { opacity: 1; } }
    @keyframes cal-drawer-slide {
      from { transform: translateX(24px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    .cal-drawer-head {
      position: sticky; top: 0; z-index: 1; background: #fff;
      border-bottom: 1px solid #dee2e6; padding: 18px 22px 14px;
      display: flex; align-items: flex-start; justify-content: space-between; gap: 12px;
    }
    .cal-drawer-wd {
      font-size: 11px; letter-spacing: .12em; text-transform: uppercase;
      color: #6c757d; margin-bottom: 3px;
    }
    .cal-drawer-date { font-size: 22px; font-weight: 600; color: #212529; line-height: 1.1; }
    .cal-drawer-count { font-size: 12.5px; color: #6c757d; margin-top: 5px; }
    .cal-drawer-close {
      width: 32px; height: 32px; flex: none; display: grid; place-items: center;
      border: 1px solid #dee2e6; background: #fff; border-radius: 6px;
      cursor: pointer; color: #6c757d; font-size: 17px; line-height: 1;
    }
    .cal-drawer-close:hover { background: #f8f9fa; }
    .cal-drawer-list { padding: 10px 22px 22px; flex: 1; }
    .cal-drawer-entry {
      display: flex; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f1f3f4;
    }
    .cal-drawer-bar { width: 3px; flex: none; border-radius: 2px; align-self: stretch; }
    .cal-drawer-entry-main { min-width: 0; }
    .cal-drawer-tag {
      font-size: 10.5px; letter-spacing: .06em; text-transform: uppercase; font-weight: 600;
    }
    .cal-drawer-title {
      font-size: 14.5px; line-height: 1.35; color: #212529; margin: 3px 0 2px;
    }
    .cal-drawer-title a { text-decoration: none; font-weight: 500; }
    .cal-drawer-title a:hover { text-decoration: underline; }
    .cal-drawer-bib { font-size: 12px; color: #495057; }
    .cal-drawer-extlink { font-size: 12px; text-decoration: none; }
    .cal-drawer-extlink:hover { text-decoration: underline; }
    .cal-drawer-section {
      font-size: 11px; letter-spacing: .08em; text-transform: uppercase;
      color: #6c757d; margin: 14px 0 2px; font-weight: 600;
    }
    .cal-drawer-empty { color: #adb5bd; font-size: 14px; padding: 20px 0; text-align: center; }
    .cal-drawer-hidden { font-size: 12px; color: #6c757d; font-style: italic; padding-top: 8px; }
    .cal-drawer-foot {
      position: sticky; bottom: 0; background: #fff; border-top: 1px solid #dee2e6;
      padding: 12px 22px; display: flex; justify-content: space-between;
    }
    .cal-drawer-foot button {
      font-size: 13px; color: #495057; background: #f8f9fa; border: 1px solid #dee2e6;
      border-radius: 6px; padding: 7px 13px; cursor: pointer;
    }
    .cal-drawer-foot button:hover:not(:disabled) { background: #e9ecef; }
    .cal-drawer-foot button:disabled { opacity: .4; cursor: default; }
  `;
  document.head.appendChild(style);
}

let drawerKey = null;

function closeDayDrawer() {
  const backdrop = document.getElementById('calendarDayDrawer');
  if (backdrop) backdrop.remove();
  drawerKey = null;
}

function stepDayDrawer(delta) {
  if (!drawerKey) return;
  const d = keyToDate(drawerKey);
  d.setDate(d.getDate() + delta);
  const key = dateToKey(d);
  if (minDate && key < minDate) return;
  if (maxDate && key > maxDate) return;
  openDayDrawer(key);
}

function buildDrawerEntry(event) {
  const color = categoryColors[event.category] || '#999';
  const entry = document.createElement('div');
  entry.className = 'cal-drawer-entry';

  const bar = document.createElement('span');
  bar.className = 'cal-drawer-bar';
  bar.style.background = color;
  bar.setAttribute('aria-hidden', 'true');
  entry.appendChild(bar);

  const main = document.createElement('div');
  main.className = 'cal-drawer-entry-main';

  const tag = document.createElement('div');
  tag.className = 'cal-drawer-tag';
  tag.style.color = color;
  tag.textContent = categoryLabels[event.category] || '';
  main.appendChild(tag);

  const title = document.createElement('div');
  title.className = 'cal-drawer-title';
  if (event.category !== 'gedruckt' && event.category !== 'fischer') {
    const link = document.createElement('a');
    link.href = event.linkId;
    link.style.color = color;
    link.textContent = event.name;
    title.appendChild(link);
  } else {
    title.textContent = event.name;
  }
  main.appendChild(title);

  if (event.category === 'gedruckt') {
    const bib = document.createElement('div');
    bib.className = 'cal-drawer-bib';
    const strong = document.createElement('strong');
    strong.textContent = 'Gedruckt in: ';
    bib.appendChild(strong);
    bib.appendChild(document.createTextNode(
      event.bibliographic || 'Bibliographische Angabe nicht verfügbar'));
    main.appendChild(bib);
  } else if (event.category === 'fischer' && event.link_url) {
    const link = document.createElement('a');
    link.className = 'cal-drawer-extlink';
    link.href = event.link_url;
    link.style.color = color;
    link.textContent = 'S. Fischer-Briefdatenbank →';
    main.appendChild(link);
  }

  entry.appendChild(main);
  return entry;
}

function openDayDrawer(key) {
  addDrawerStyles();
  closeDayDrawer();
  drawerKey = key;

  const date = keyToDate(key);
  const all = eventsByDate.get(key) || [];
  const visible = all.filter(e => activeFilters.has(e.category));
  const hidden = all.length - visible.length;

  // Sortierung wie im Kalender: nach Tageszähler, externe Briefe ans Ende
  const sorted = [...visible].sort((a, b) => {
    const posA = parseInt(a.tageszaehler) || 999;
    const posB = parseInt(b.tageszaehler) || 999;
    return posA - posB;
  });
  const regular = sorted.filter(e => e.category !== 'gedruckt' && e.category !== 'fischer');
  const printed = sorted.filter(e => e.category === 'gedruckt' || e.category === 'fischer');

  const backdrop = document.createElement('div');
  backdrop.className = 'cal-drawer-backdrop';
  backdrop.id = 'calendarDayDrawer';
  backdrop.addEventListener('click', closeDayDrawer);

  const drawer = document.createElement('aside');
  drawer.className = 'cal-drawer';
  drawer.setAttribute('role', 'dialog');
  drawer.setAttribute('aria-modal', 'true');
  drawer.setAttribute('aria-label', 'Briefe des Tages');
  drawer.addEventListener('click', e => e.stopPropagation());

  // Kopf
  const head = document.createElement('div');
  head.className = 'cal-drawer-head';
  const headLeft = document.createElement('div');
  const wd = document.createElement('div');
  wd.className = 'cal-drawer-wd';
  wd.textContent = dayNamesDrawer[date.getDay()];
  const dateEl = document.createElement('div');
  dateEl.className = 'cal-drawer-date';
  dateEl.textContent = `${date.getDate()}. ${monthNamesDrawer[date.getMonth()]} ${date.getFullYear()}`;
  const count = document.createElement('div');
  count.className = 'cal-drawer-count';
  count.textContent = visible.length === 0
    ? 'keine sichtbaren Korrespondenzstücke'
    : visible.length + (visible.length === 1 ? ' Korrespondenzstück' : ' Korrespondenzstücke');
  headLeft.appendChild(wd);
  headLeft.appendChild(dateEl);
  headLeft.appendChild(count);
  const closeBtn = document.createElement('button');
  closeBtn.type = 'button';
  closeBtn.className = 'cal-drawer-close';
  closeBtn.setAttribute('aria-label', 'Schließen');
  closeBtn.textContent = '×';
  closeBtn.addEventListener('click', closeDayDrawer);
  head.appendChild(headLeft);
  head.appendChild(closeBtn);
  drawer.appendChild(head);

  // Liste
  const list = document.createElement('div');
  list.className = 'cal-drawer-list';
  regular.forEach(event => list.appendChild(buildDrawerEntry(event)));
  if (printed.length > 0) {
    if (regular.length > 0) {
      const section = document.createElement('div');
      section.className = 'cal-drawer-section';
      section.textContent = 'Externe Briefe';
      list.appendChild(section);
    }
    printed.forEach(event => list.appendChild(buildDrawerEntry(event)));
  }
  if (visible.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'cal-drawer-empty';
    empty.textContent = 'Keine bekannten Korrespondenzstücke an diesem Tag.';
    list.appendChild(empty);
  }
  if (hidden > 0) {
    const note = document.createElement('div');
    note.className = 'cal-drawer-hidden';
    note.textContent = hidden + (hidden === 1
      ? ' Eintrag ist durch den Filter ausgeblendet.'
      : ' Einträge sind durch den Filter ausgeblendet.');
    list.appendChild(note);
  }
  drawer.appendChild(list);

  // Fuß: tageweise blättern
  const foot = document.createElement('div');
  foot.className = 'cal-drawer-foot';
  const prevBtn = document.createElement('button');
  prevBtn.type = 'button';
  prevBtn.textContent = '‹ Vortag';
  prevBtn.disabled = !!(minDate && key <= minDate);
  prevBtn.addEventListener('click', () => stepDayDrawer(-1));
  const nextBtn = document.createElement('button');
  nextBtn.type = 'button';
  nextBtn.textContent = 'Folgetag ›';
  nextBtn.disabled = !!(maxDate && key >= maxDate);
  nextBtn.addEventListener('click', () => stepDayDrawer(1));
  foot.appendChild(prevBtn);
  foot.appendChild(nextBtn);
  drawer.appendChild(foot);

  backdrop.appendChild(drawer);
  document.body.appendChild(backdrop);
  closeBtn.focus();
}

document.addEventListener('keydown', e => {
  if (e.key === 'Escape' && drawerKey) closeDayDrawer();
});

// Kompatibilität: simple-calendar.js ruft diese Funktion für gedruckte Briefe auf
function showPrintedLetterPopup(event) {
  openDayDrawer(event.startDate);
}

// Initialize calendar when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Process calendar data
  processCalendarData();

  // Make functions globally available for simple-calendar.js
  window.showPrintedLetterPopup = showPrintedLetterPopup;

  // Initialize SimpleCalendar
  calendar = new SimpleCalendar('calendar', {
    startYear: 1900,
    dataSource: data,  // Use all data, filtering is handled inside SimpleCalendar
    clickDay: handleDayClick
  });
});
