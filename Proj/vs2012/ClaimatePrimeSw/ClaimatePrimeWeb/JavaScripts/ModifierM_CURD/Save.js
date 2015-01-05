$(document).ready(function () {
    _AlertMsgID = "Modifier_ModifierCode";
    $("#" + _AlertMsgID).focus();
});
function validateSave() {

    if (canSubmit()) {
        if (!(($('#Modifier_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#Modifier_ModifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Modifier_ModifierCode");
            return false;
        }

        if ($("#Modifier_ModifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Modifier_ModifierName");
            return false;
        }
        if (!($("#Modifier_ModifierName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "Modifier_ModifierName");
            return false;
        }
        return true;
    }
    return false;
}