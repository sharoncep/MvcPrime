$(document).ready(function () {
    _AlertMsgID = "UserLogin_UserName";
    $("#" + _AlertMsgID).focus();
});

function focusUname() {
    registerBlurFn();
    $("#UserLogin_Password").val("");
}

function validateCult(obj) {
    $("#UserCulture").val($(obj).val())
    $("#btnUserCulture").click();
}

function validateSave(seed) {

    if (canSubmit()) {
        if ($("#UserLogin_UserName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("USER_NAME"), "UserLogin_UserName");
            return false;
        }

        if ($("#UserLogin_Password").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PASSWORD_ERR"), "UserLogin_Password");
            return false;
        }

        $("#UserLogin_Password").val(Sha1.hash(seed + Sha1.hash($("#UserLogin_Password").val())));

        return true;
    }
    return false;
}