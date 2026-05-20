document.addEventListener('DOMContentLoaded', function () {
    var container = document.getElementById('bluesky-post-container');
    if (!container) return;

    fetch('https://api.bsky.app/xrpc/app.bsky.feed.searchPosts?q=%23ArthurSchnitzler&author=encore.at&limit=5&sort=latest')
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (!data.posts || data.posts.length === 0) return;

            var post = data.posts[0];
            var postDate = new Date(post.indexedAt);
            var twoMonthsAgo = new Date();
            twoMonthsAgo.setMonth(twoMonthsAgo.getMonth() - 2);
            if (postDate < twoMonthsAgo) return;

            var rkey = post.uri.split('/').pop();
            var postUrl = 'https://bsky.app/profile/encore.at/post/' + rkey;
            var profileUrl = 'https://bsky.app/profile/encore.at';
            var dateStr = postDate.toLocaleDateString('de-AT', {
                year: 'numeric', month: 'long', day: 'numeric'
            });

            var text = (post.record && post.record.text) ? post.record.text : '';
            var facets = (post.record && post.record.facets) ? post.record.facets : [];
            var renderedText = renderFacets(text, facets);

            document.getElementById('bluesky-post-content').innerHTML =
                '<p style="margin-bottom:0.75em;">' + renderedText + '</p>' +
                '<p class="text-muted small mb-0">' +
                '<a href="' + postUrl + '" target="_blank" rel="noopener noreferrer">' + dateStr + '</a>' +
                '&#160;&#8211;&#160;' +
                '<a href="' + profileUrl + '" target="_blank" rel="noopener noreferrer">@encore.at auf Bluesky</a>' +
                '</p>';

            container.style.display = '';
        })
        .catch(function () { /* API nicht erreichbar – Block bleibt verborgen */ });
});

function escapeHtml(str) {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

function renderFacets(text, facets) {
    if (!facets || facets.length === 0) {
        return escapeHtml(text).replace(/\n/g, '<br>');
    }

    var encoder = new TextEncoder();
    var decoder = new TextDecoder();
    var bytes = encoder.encode(text);

    facets.sort(function (a, b) { return a.index.byteStart - b.index.byteStart; });

    var result = '';
    var pos = 0;

    for (var i = 0; i < facets.length; i++) {
        var facet = facets[i];
        var start = facet.index.byteStart;
        var end = facet.index.byteEnd;
        var feature = facet.features && facet.features[0];

        if (pos < start) {
            result += escapeHtml(decoder.decode(bytes.slice(pos, start)));
        }

        var segment = escapeHtml(decoder.decode(bytes.slice(start, end)));

        if (feature) {
            var type = feature['$type'];
            if (type === 'app.bsky.richtext.facet#link') {
                result += '<a href="' + escapeHtml(feature.uri) + '" target="_blank" rel="noopener noreferrer">' + segment + '</a>';
            } else if (type === 'app.bsky.richtext.facet#tag') {
                result += '<a href="https://bsky.app/hashtag/' + encodeURIComponent(feature.tag) + '" target="_blank" rel="noopener noreferrer">' + segment + '</a>';
            } else if (type === 'app.bsky.richtext.facet#mention') {
                var handle = decoder.decode(bytes.slice(start, end)).replace(/^@/, '');
                result += '<a href="https://bsky.app/profile/' + encodeURIComponent(handle) + '" target="_blank" rel="noopener noreferrer">' + segment + '</a>';
            } else {
                result += segment;
            }
        } else {
            result += segment;
        }

        pos = end;
    }

    if (pos < bytes.length) {
        result += escapeHtml(decoder.decode(bytes.slice(pos)));
    }

    return result.replace(/\n/g, '<br>');
}
