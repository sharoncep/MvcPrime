$(document).ready(function () {
    _AlertMsgID = "PrintSign_PrintSignCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#PrintSign_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#PrintSign_PrintSignCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "PrintSign_PrintSignCode");
            return false;
        }

        if ($("#PrintSign_PrintSignName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "PrintSign_PrintSignName");
            return false;
        }

        return true;
    }
    return false;
}