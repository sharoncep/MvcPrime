$(document).ready(function () {
    _AlertMsgID = "ClaimMedia_ClaimMediaCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {

        if (!(($('#ClaimMedia_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#ClaimMedia_ClaimMediaCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "ClaimMedia_ClaimMediaCode");
            return false;
        }

        if ($("#ClaimMedia_ClaimMediaName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "ClaimMedia_ClaimMediaName");
            return false;
        }
        if ($("#ClaimMedia_MaxDiagnosis").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MAX_DIAGNOSIS"), "ClaimMedia_ClaimMediaName");
            return false;
        }
        return true
    }
    return false;

}