document.addEventListener('DOMContentLoaded', function () {
    const container = document.getElementById('bluesky-post-container');
    if (!container) return;

    fetch('https://public.api.bsky.app/xrpc/app.bsky.feed.searchPosts?q=%23ArthurSchnitzler&author=encore.at&limit=5&sort=latest')
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
            var safeText = text
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/\n/g, '<br>');

            document.getElementById('bluesky-post-content').innerHTML =
                '<p style="margin-bottom:0.75em;">' + safeText + '</p>' +
                '<p class="text-muted small mb-0">' +
                '<a href="' + postUrl + '" target="_blank" rel="noopener noreferrer">' + dateStr + '</a>' +
                '&#160;&#8211;&#160;' +
                '<a href="' + profileUrl + '" target="_blank" rel="noopener noreferrer">@encore.at auf Bluesky</a>' +
                '</p>';

            container.style.display = '';
        })
        .catch(function () { /* API nicht erreichbar – Block bleibt verborgen */ });
});
