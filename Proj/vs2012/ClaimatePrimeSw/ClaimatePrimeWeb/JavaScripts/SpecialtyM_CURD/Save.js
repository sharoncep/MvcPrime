$(document).ready(function () {
    _AlertMsgID = "Specialty_SpecialtyCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#Specialty_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#Specialty_SpecialtyCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Specialty_SpecialtyCode");
            return false;
        }

        if ($("#Specialty_SpecialtyName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Specialty_SpecialtyName");
            return false;
        }
        if (!($("#Specialty_SpecialtyName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "Specialty_SpecialtyName");
            return false;
        }
        return true;
    }
    return false;
}