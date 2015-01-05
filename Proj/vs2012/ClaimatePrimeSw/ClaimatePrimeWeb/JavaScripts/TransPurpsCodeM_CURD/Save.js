$(document).ready(function () {
    _AlertMsgID = "TransactionPurposeCode_TransactionSetPurposeCodeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#TransactionPurposeCode_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#TransactionPurposeCode_TransactionSetPurposeCodeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "TransactionPurposeCode_TransactionSetPurposeCodeCode");
            return false;
        }

        if ($("#TransactionPurposeCode_TransactionSetPurposeCodeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "TransactionPurposeCode_TransactionSetPurposeCodeName");
            return false;
        }
        return true;
    }
    return false;
}