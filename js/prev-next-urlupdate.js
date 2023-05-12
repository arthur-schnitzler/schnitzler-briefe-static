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
    var new_prev = new URL(`${domain}/${path}/${prev_href}?${urlparam}`);
    prev.setAttribute("href", new_prev);
  }
  if (next) {
    var next_href = next.getAttribute("href");
    var new_next = new URL(`${domain}/${path}/${next_href}?${urlparam}`);
    next.setAttribute("href", new_next);
  }
  if (prev2) {
    var prev_href2 = prev2.getAttribute("href");
    var new_prev2 = new URL(`${domain}/${path}/${prev_href2}?${urlparam}`);
    prev2.setAttribute("href", new_prev2);
  }
  if (next2) {
    var next_href2 = next2.getAttribute("href");
    var new_next2 = new URL(`${domain}/${path}/${next_href2}?${urlparam}`);
    next2.setAttribute("href", new_next2);
  }
}

function nextPrevUrlUpdate() {
  var prev = document.getElementById(prev_btn);
  var next = document.getElementById(next_btn);
  var prev2 = document.getElementById(prev_btn2);
  var next2 = document.getElementById(next_btn2);
  var urlparam = new URLSearchParams(document.location.search);
  if (prev) {
    var prev_href = new URL(prev.getAttribute("href"));
    var old_prev_search = new URLSearchParams(prev_href.search);
    urlparam.forEach((value, key) => {
      old_prev_search.set(key, value);
    });
    prev.setAttribute(
      "href",
      `${prev_href.origin}${prev_href.pathname}?${old_prev_search.toString()}`
    );
  }
  if (prev2) {
    var prev_href2 = new URL(prev.getAttribute("href"));
    var old_prev_search2 = new URLSearchParams(prev_href2.search);
    urlparam.forEach((value, key) => {
      old_prev_search2.set(key, value);
    });
    prev2.setAttribute(
      "href",
      `${prev_href2.origin}${
        prev_href2.pathname
      }?${old_prev_search2.toString()}`
    );
  }
  if (next) {
    var next_href = new URL(next.getAttribute("href"));
    var old_next_search = new URLSearchParams(next_href.search);
    urlparam.forEach((value, key) => {
      old_next_search.set(key, value);
    });
    next.setAttribute(
      "href",
      `${next_href.origin}${next_href.pathname}?${old_next_search.toString()}`
    );
  }
  if (next2) {
    var next_href2 = new URL(next.getAttribute("href"));
    var old_next_search2 = new URLSearchParams(next_href2.search);
    urlparam.forEach((value, key) => {
      old_next_search2.set(key, value);
    });
    next2.setAttribute(
      "href",
      `${next_href2.origin}${
        next_href2.pathname
      }?${old_next_search2.toString()}`
    );
  }
}
