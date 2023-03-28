function resize(position) {
    let isResizing = false,
        lastDownX = 0;

    $(function () {
        let container = $(`#container-resize-${position}`),
            left_container = $(`#text-resize-${position}`),
            right_container = $(`#img-resize-${position}`),
            handle = $(`#img-expand-${position}`),
            viewer = $(`#viewer-${position}`).children('div'),
            text = $(left_container).children('div');
        
        handle.on('mousedown', function (e) {
            isResizing = true;
            lastDownX = e.clientX;
        });

        $(document).on('mousemove', function (e) {
            // we don't want to do anything if we aren't resizing.
            if (!isResizing) 
                return;
            
            let offsetLeft = container.width() - (e.clientX + container.offset().left);
            let offsetRight = container.width() - handle.val();

            if (handle.val() < 936) {
                left_container.css('max-width', `${container.width() - offsetLeft}px`);
                right_container.css('max-width', `${offsetLeft}px`);
                viewer.css('width', `${offsetLeft}px`);
                viewer.css('height', `${offsetLeft}px`);
            } else if (handle.val() > 936) {
                left_container.css('max-width', `${handle.val()}px`);
                text.css('width', `${handle.value}px`);
                right_container.css('max-width', `${offsetRight}px`);
                viewer.css('width', `${offsetRight}px`);
                viewer.css('height', `${offsetRight}px`);
            } else if (handle.val() === 936) {
                left_container.css('max-width', '50%');
                text.css('width', '50%');
                right_container.css('max-width', '50%');
                viewer.style.width = `${right_container.offsetWidth}px`;
                viewer.style.height = `${right_container.offsetHeight}px`;
            }
            

        }).on('mouseup', function () {
            // stop resizing
            isResizing = false;
        });
    });

    // function getOSD() {
    //     let viewerID = `canvas`;
    //     let viewer = $(viewerID).children('div');
    //     let style = viewer.attr('style');
    //     console.log(style);
    //     var regex = /\d+px/g;
    //     var match = regex.exec(style);
    //     console.log(match[0]);
    //     console.log(match);
    //     $('#clear-link').on("click", function() {
    //         viewer.css({"height": match[0], "width": match[0]});
    //     });
    // };
}
