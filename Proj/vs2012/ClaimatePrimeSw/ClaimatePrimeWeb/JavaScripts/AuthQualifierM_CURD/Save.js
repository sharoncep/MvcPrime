$(document).ready(function () {
    _AlertMsgID = "AuthorizationQualifier_AuthorizationInformationQualifierCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        if (!(($('#AuthorizationQualifier_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#AuthorizationQualifier_AuthorizationInformationQualifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "AuthorizationQualifier_AuthorizationInformationQualifierCode");
            return false;
        }

        if ($("#AuthorizationQualifier_AuthorizationInformationQualifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "AuthorizationQualifier_AuthorizationInformationQualifierName");
            return false;
        }
        return true;
    }
    return false;
}