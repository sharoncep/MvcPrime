
var _LockPgCounter = 0;
var _LockedPg = 0;

setInterval("doLockPgCounter()", 1000);

$(document).ready(function () {
    _LockPgCounter = 0;
});

$(document).keypress(function () {
    _LockPgCounter = 0;
});

$(document).click(function () {
    _LockPgCounter = 0;
});

$(document).mousemove(function () {
    _LockPgCounter = 0;
});

function doLockPgCounter() {
    if (_LockedPg == 0) {
        _LockPgCounter++;

        if (_LockPgCounter > 30) {
            lockPg();
        }
    }
    else {
        _LockedPg--;
        $("#spnUnlock").html(_LockedPg);

        if (_LockedPg < 1) {
            window.location.href = "/ClaimatePrime/index.html";
        }
    }
}

function lockPg() {
    _LockedPg = 300;
    $("#spnUnlock").html(_LockedPg);
    $("#divLockMsg").fadeIn();
//    $("#txtPassword").focus();

    return false;
}

function unLockPg() {
    var pwd = $("#txtPassword").val();
    if (pwd == "123") {
        $("#txtPassword").val("zxkh7yhnabbfisaifsflm1349nnad76582");
        $("#divLockMsg").fadeOut();
        _LockedPg = 0;
    }

    $("#txtPassword").val("");

    return false;
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