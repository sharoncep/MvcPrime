$(document).ready(function () {
    _AlertMsgID = "CurrencyCode_CurrencyCodeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#CurrencyCode_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#CurrencyCode_CurrencyCodeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "CurrencyCode_CurrencyCodeCode");
            return false;
        }

        if ($("#CurrencyCode_CurrencyCodeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "CurrencyCode_CurrencyCodeName");
            return false;
        }
        return true;
    }
    return false;
}