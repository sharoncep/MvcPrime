$(document).ready(function () {
    _AlertMsgID = "DiagnosisGroup_DiagnosisGroupCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        if (!(($('#DiagnosisGroup_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#DiagnosisGroup_DiagnosisGroupCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "DiagnosisGroup_DiagnosisGroupCode");
            return false;
        }

        if ($("#DiagnosisGroup_DiagnosisGroupDescription").val().length == 0) {
            alertErrMsg(AlertMsgs.get("DESCR"), "DiagnosisGroup_DiagnosisGroupDescription");
            return false;
        }
        if ($("#DiagnosisGroup_Amount").val() == 0) {
            alertErrMsg(AlertMsgs.get("AMOUNT"), "DiagnosisGroup_Amount");
            return false;
        }
        return true;
    }
    return false;
}