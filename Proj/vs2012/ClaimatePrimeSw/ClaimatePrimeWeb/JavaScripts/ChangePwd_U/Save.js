$(document).ready(function () {
    _AlertMsgID = "CurrPwd";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#CurrPwd").val().length == 0) {
            alertErrMsg(AlertMsgs.get("USERRESULT_PASSWORD"), "CurrPwd");
            return false;
        }

        if ($("#NewPwd").val().length == 0) {
            alertErrMsg(AlertMsgs.get("NWPASSWORD"), "NewPwd");
            return false;
        }

        if ($("#ConfPwd").val().length == 0) {
            alertErrMsg(AlertMsgs.get("CONPASSWORD"), "ConfPwd");
            return false;
        }

        if ($("#NewPwd").val() != $("#ConfPwd").val()) {


            alertErrMsg(AlertMsgs.get("NOMATCH"), "ConPassword");
            return false;
        }

        return true;
    }
    return false;
}