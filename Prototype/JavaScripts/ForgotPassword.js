function forgotPwd() {
    var unm = $("#txtEmail").val();
    //    var unms = new Array("WebAdmin@ClaimatePrime.com", "WebAdmin", "Manager@ClaimatePrime.com", "Manager", "BillingAgent@ClaimatePrime.com", "BillingAgent", "QAAgent@ClaimatePrime.com", "QAAgent", "EDIAgent@ClaimatePrime.com", "EDIAgent");
    var unms = new Array("WebAdmin@ClaimatePrime.com", "WebAdmin");
    var uni = -1;

    $.each(unms, function (index, item) {
        if (unm.toLowerCase() == item.toLowerCase()) {
            uni = index;
        }
    });

    if (uni < 0) {
        $("#divErrMsgInner").html("Please enter the registered email address.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Eg: " + (unms.toString().replace(new RegExp(",", "g"), " / ")));
        $("#divErrMsg").fadeIn();
        $("#txtEmail").val("");
        $("#txtEmail").focus();
        return;
    }

    $("#divSuccMsg").fadeIn();
}

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

// http://jquerybyexample.blogspot.in/2011/04/validate-email-address-using-jquery.html
// http://jsfiddle.net/jquerybyexample/DxPuU/
function blurValidateEmailAddress(obj) {
    blurTrim(obj);
    var address = $(obj).val();

    if (address.length == 0) {
        return true;
    }

    var filter = /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{1,4}$/;

    if (filter.test(address)) {
        return true;
    }

    $("#divErrMsgInner").html("Please enter a valid email address");
    $("#divErrMsg").fadeIn();
    $(obj).val("");
    $(obj).focus();

    return false;
}