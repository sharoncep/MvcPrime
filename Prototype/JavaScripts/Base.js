// Disable: Back Button. I am not sure about unload. Starts
// http://stackoverflow.com/questions/158319/cross-browser-onload-event-and-the-back-button

history.go(+1);
$(window).bind("unload", function () { history.go(+1); });
//alert($(window).height()); alert($(window).width());

// Disable: Back Button. I am not sure about unload. Ends


// Block AutoComplete STARTS

$(document).ready(function () {
    if (document.getElementsByTagName) {
        var inputElements = document.getElementsByTagName("input");
        for (i = 0; inputElements[i]; i++) {
            if (inputElements[i].type == "text") {
                try {
                    $(inputElements[i]).removeAttr("autocomplete");
                }
                catch (e)
               { }
                try {
                    $(inputElements[i]).attr("autocomplete", "off");
                }
                catch (e)
                 { }
            }
        }
    }
});

 // Block AutoComplete ENDS