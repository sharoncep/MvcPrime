$(document).ready(function () {
    _AlertMsgID = "SecurityQualifier_SecurityInformationQualifierCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#SecurityQualifier_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#SecurityQualifier_SecurityInformationQualifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "SecurityQualifier_SecurityInformationQualifierCode");
            return false;
        }

        if ($("#SecurityQualifier_SecurityInformationQualifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "SecurityQualifier_SecurityInformationQualifierName");
            return false;
        }
        return true;
    }
    return false;
}