$(document).ready(function () {
    _AlertMsgID = "IllnessIndicator_IllnessIndicatorCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        if (!(($('#IllnessIndicator_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#IllnessIndicator_IllnessIndicatorCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "IllnessIndicator_IllnessIndicatorCode");
            return false;
        }

        if ($("#IllnessIndicator_IllnessIndicatorName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "IllnessIndicator_IllnessIndicatorName");
            return false;
        }
        return true;
    }
    return false;
}