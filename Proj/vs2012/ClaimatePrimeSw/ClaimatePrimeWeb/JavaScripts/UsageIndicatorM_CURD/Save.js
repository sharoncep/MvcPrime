$(document).ready(function () {
    _AlertMsgID = "UsageIndicator_InterchangeUsageIndicatorCode";
    $("#" + _AlertMsgID).focus();
});
function validateSave() {

    if (canSubmit()) {
        if (!(($('#UsageIndicator_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#UsageIndicator_InterchangeUsageIndicatorCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "UsageIndicator_InterchangeUsageIndicatorCode");
            return false;
        }

        if ($("#UsageIndicator_InterchangeUsageIndicatorName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "UsageIndicator_InterchangeUsageIndicatorName");
            return false;
        }

        return true;
    }
    return false;
}