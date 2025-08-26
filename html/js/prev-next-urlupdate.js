/* de-micro-editor aot features class */
const dse_feat1 = "features-1";
const dse_feat2 = "features-2";

/* html prev and next buttons -> link id */
const prev_btn = "prev-doc";
const next_btn = "next-doc";
const prev_btn2 = "prev-doc2";
const next_btn2 = "next-doc2";

window.onload = nextPrevUrl();

var features1 = document.getElementsByClassName(dse_feat1);
var features2 = document.getElementsByClassName(dse_feat2);

[].forEach.call(features1, (opt) => {
  opt.addEventListener("click", nextPrevUrlUpdate);
});

[].forEach.call(features2, (opt) => {
  opt.addEventListener("click", nextPrevUrlUpdate);
});

function nextPrevUrl() {
  var prev = document.getElementById(prev_btn);
  var next = document.getElementById(next_btn);
  var prev2 = document.getElementById(prev_btn2);
  var next2 = document.getElementById(next_btn2);
  var urlparam = new URLSearchParams(document.location.search);
  var domain = document.location.origin;
  var path = document.location.pathname;
  var path = path.split("/");
  if (path.length > 2) {
    path = path[1];
  } else {
    path = "";
  }
  if (prev) {
    var prev_href = prev.getAttribute("href");
    if (urlparam.size > 0) {
      var new_prev = new URL(`${domain}/${path}/${prev_href}?${urlparam}`);
    } else {
      var new_prev = new URL(`${domain}/${path}/${prev_href}`);
    }
    prev.setAttribute("href", new_prev);
  }
  if (next) {
    var next_href = next.getAttribute("href");
    if (urlparam.size > 0) {
      var new_next = new URL(`${domain}/${path}/${next_href}?${urlparam}`);
    } else {
      var new_next = new URL(`${domain}/${path}/${next_href}`);
    }
    next.setAttribute("href", new_next);
  }
  if (prev2) {
    var prev_href = prev2.getAttribute("href");
    if (urlparam.size > 0) {
      var new_prev = new URL(`${domain}/${path}/${prev_href}?${urlparam}`);
    } else {
      var new_prev = new URL(`${domain}/${path}/${prev_href}`);
    }
    prev2.setAttribute("href", new_prev);
  }
  if (next2) {
    var next_href = next2.getAttribute("href");
    if (urlparam.size > 0) {
      var new_next = new URL(`${domain}/${path}/${next_href}?${urlparam}`);
    } else {
      var new_next = new URL(`${domain}/${path}/${next_href}`);
    }
    next2.setAttribute("href", new_next);
  }
}

function nextPrevUrlUpdate() {
  var prev = document.getElementById(prev_btn);
  var next = document.getElementById(next_btn);
  var prev2 = document.getElementById(prev_btn2);
  var next2 = document.getElementById(next_btn2);
  var urlparam = new URLSearchParams(document.location.search);
  if (prev) {
    var base_href = prev.getAttribute("href").replace(/\?.+/, '');
    if (urlparam.size > 0) {
      var new_href = `${base_href}?${urlparam.toString()}`;
    } else {
      var new_href = base_href;
    }
    prev.setAttribute("href", new_href);
  }
  if (prev2) {
    var base_href = prev2.getAttribute("href").replace(/\?.+/, '');
    if (urlparam.size > 0) {
      var new_href = `${base_href}?${urlparam.toString()}`;
    } else {
      var new_href = base_href;
    }
    prev2.setAttribute("href", new_href);
  }
  if (next) {
    var base_href = next.getAttribute("href").replace(/\?.+/, '');
    if (urlparam.size > 0) {
      var new_href = `${base_href}?${urlparam.toString()}`;
    } else {
      var new_href = base_href;
    }
    next.setAttribute("href", new_href);
  }
  if (next2) {
    var base_href = next2.getAttribute("href").replace(/\?.+/, '');
    if (urlparam.size > 0) {
      var new_href = `${base_href}?${urlparam.toString()}`;
    } else {
      var new_href = base_href;
    }
    next2.setAttribute("href", new_href);
  }
}
