function focusUname() {
    $("#txtPassword").val("");
}

function logIn() {
    var unm = $("#txtUsername").val();
    var pwd = $("#txtPassword").val();
    //    var unms = new Array("WebAdmin@ClaimatePrime.com", "WebAdmin", "Manager@ClaimatePrime.com", "Manager", "BillingAgent@ClaimatePrime.com", "BillingAgent", "QAAgent@ClaimatePrime.com", "QAAgent", "EDIAgent@ClaimatePrime.com", "EDIAgent");
    var unms = new Array("WebAdmin@ClaimatePrime.com", "WebAdmin");
    var uni = -1;

    $.each(unms, function (index, item) {
        if (unm.toLowerCase() == item.toLowerCase()) {
            uni = index;
        }
    });

    if (uni < 0) {
        $("#divErrMsgInner").html("Please enter a valid username.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Eg: " + (unms.toString().replace(new RegExp(",", "g"), " / ")));
        $("#divErrMsg").fadeIn();
        $("#txtUsername").val("");
        $("#txtPassword").val("");
        $("#txtUsername").focus();
        return;
    }

    if (pwd != "123") {
        $("#divErrMsgInner").html("Please enter a valid password.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Eg: 123");
        $("#divErrMsg").fadeIn();
        $("#txtPassword").val("");
        $("#txtPassword").focus();
        return;
    }

    $("#txtPassword").val("zxkh7yhnabbfisaifsflm1349nnad76582");

    if ((uni == 0) || (uni == 1)) {
        window.location.href = "WebAdmin/Dashboard.html";
        return;
    }

    $("#divErrMsgInner").html("Code In-Complete");
    $("#divErrMsg").fadeIn();
        
}

function keyPressEnterKeyPwd(e, objID) {
    var retAns = keyPressEnterKey(e, objID);

    if (retAns == true) {
        checkCapsLock(e);

        return true;
    }

    return false;
}

// CAPS LOCK CHECKING STARTS

// http://www.experts-exchange.com/Programming/Languages/.NET/ASP.NET/Q_27394907.html

function checkCapsLock(e) {
    var myKeyCode = 0;
    var myShiftKey = false;
    var retAns = true;

    // Internet Explorer 4+
    if (document.all) {
        myKeyCode = e.keyCode;
        myShiftKey = e.shiftKey;

        // Netscape 4
    }
    else if (document.layers) {
        myKeyCode = e.which;
        myShiftKey = (myKeyCode == 16) ? true : false;

        // Netscape 6
    }
    else if (document.getElementById) {
        myKeyCode = e.which;
        myShiftKey = (myKeyCode == 16) ? true : false;
    }

    if (myShiftKey == false) {
        myShiftKey = e.shiftKey;
    }

    // Upper case letters are seen without depressing the Shift key, therefore Caps Lock is on
    if ((myKeyCode >= 65 && myKeyCode <= 90) && !myShiftKey) {
        retAns = false;

        // Lower case letters are seen while depressing the Shift key, therefore Caps Lock is on
    }
    else if ((myKeyCode >= 97 && myKeyCode <= 122) && myShiftKey) {
        retAns = false;
    }

    if (retAns == false) {
        $("#divCapsLockOn").fadeIn();
    }
    else {
        $("#divCapsLockOn").fadeOut('slow');
    }

    return true;
}

// CAPS LOCK CHECKING ENDS

// Key Press

function keyPressEnterKey(e, objId) {
    var chCode = (e.keyCode) ? e.keyCode : ((e.charCode) ? e.charCode : e.which);
    if (chCode == 13) {
        $("#" + objId).click();
        return false;
    }

    return true;
}

// Blur

// http://api.jquery.com/jQuery.trim/
function blurTrim(obj) {
    $(obj).val($.trim($(obj).val()));
}