$(document).ready(function () {
    _AlertMsgID = "PrintPin_PrintPinCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#PrintPin_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#PrintPin_PrintPinCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "PrintPin_PrintPinCode");
            return false;
        }

        if ($("#PrintPin_PrintPinName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "PrintPin_PrintPinName");
            return false;
        }
        return true;
    }
    return false;
}