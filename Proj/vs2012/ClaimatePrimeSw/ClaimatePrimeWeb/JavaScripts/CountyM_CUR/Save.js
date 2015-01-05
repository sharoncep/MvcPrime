$(document).ready(function () {
    _AlertMsgID = "County_CountyCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#County_CountyCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "County_CountyCode");
            return false;
        }

        if ($("#County_CountyName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "County_CountyName");
            return false;
        }
        if (!($("#County_CountyName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "County_CountyName");
            return false;
        }
        return true;
    }
    return false;

}