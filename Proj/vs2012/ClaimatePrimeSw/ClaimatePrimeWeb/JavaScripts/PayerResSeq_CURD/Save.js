$(document).ready(function () {
    _AlertMsgID = "PayerResponsibilitySequenceNumberCode_PayerResponsibilitySequenceNumberCodeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#PayerResponsibilitySequenceNumberCode_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#PayerResponsibilitySequenceNumberCode_PayerResponsibilitySequenceNumberCodeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "PayerResponsibilitySequenceNumberCode_PayerResponsibilitySequenceNumberCodeCode");
            return false;
        }

        if ($("#PayerResponsibilitySequenceNumberCode_PayerResponsibilitySequenceNumberCodeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "PayerResponsibilitySequenceNumberCode_PayerResponsibilitySequenceNumberCodeName");
            return false;
        }
        return true;
    }
    return false;
}