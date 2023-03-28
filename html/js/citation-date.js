
const citDate = document.getElementById("citation-date");

function changeToCurrentDate() {
    let date = new Date();
    let options = { 
        // weekday: 'long', 
        year: 'numeric',
        month: 'long', 
        day: 'numeric'
    };
    citDate.innerHTML = date.toLocaleDateString('en-EN', options);
}

changeToCurrentDate();