$(document).ready(function () {
    _AlertMsgID = "TransactionTypeCode_TransactionTypeCodeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#TransactionTypeCode_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#TransactionTypeCode_TransactionTypeCodeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "TransactionTypeCode_TransactionTypeCodeCode");
            return false;
        }

        if ($("#TransactionTypeCode_TransactionTypeCodeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "TransactionTypeCode_TransactionTypeCodeName");
            return false;
        }
        return true;
    }
    return false;
}