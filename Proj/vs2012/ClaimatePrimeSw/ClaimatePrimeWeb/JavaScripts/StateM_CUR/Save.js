$(document).ready(function () {
    _AlertMsgID = "State_StateCode";
    $("#" + _AlertMsgID).focus();
});
function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#State_StateCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("STATE_CODE"), "State_StateCode");
            return false;
        }

        if ($("#State_StateName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("STATE_NAME"), "State_StateName");
            return false;
        }
        if (!($("#State_StateName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "State_StateName");
            return false;
        }
        return true;
    }
    return false;
}