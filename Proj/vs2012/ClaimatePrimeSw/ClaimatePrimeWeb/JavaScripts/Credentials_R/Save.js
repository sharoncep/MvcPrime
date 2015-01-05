$(document).ready(function () {
    _AlertMsgID = "Credential_CredentialCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {

        if (!(($('#Credential_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#Credential_CredentialCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Credential_CredentialCode");
            return false;
        }

        if ($("#Credential_CredentialName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Credential_CredentialName");
            return false;
        }
        if (!($("#County_CountyName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "County_CountyName");
            return false;
        }
        return true;
    }
    return false;
}