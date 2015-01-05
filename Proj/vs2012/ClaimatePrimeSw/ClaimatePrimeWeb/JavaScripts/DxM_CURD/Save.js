$(document).ready(function () {
    _AlertMsgID = "Diagnosis_DiagnosisCode";
    $("#" + _AlertMsgID).focus();

    setAutoComplete("Diagnosis_DiagnosisGroup", "DiagnosisGroup");
});


function DiagnosisGroupID() {


}

function validateSave() {
    if (canSubmit()) {
        if (!(($('#Diagnosis_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#Diagnosis_DiagnosisCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Diagnosis_DiagnosisCode");
            return false;
        }

        if ($("#Diagnosis_ICDFormat").val().length == 0) {
            alertErrMsg(AlertMsgs.get("ICD_FORMAT"), "Diagnosis_ICDFormat");
            return false;
        }
        if ($("#Diagnosis_ShortDesc").val().length == 0) {

            if ($("#Diagnosis_MediumDesc").val().length == 0 && $("#Diagnosis_LongDesc").val().length == 0 && $("#Diagnosis_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("DESC"), "Diagnosis_ShortDesc");
                return false;
            }

        }
        if ($("#Diagnosis_MediumDesc").val().length == 0) {
            if ($("#Diagnosis_ShortDesc").val().length == 0 && $("#Diagnosis_LongDesc").val().length == 0 && $("#Diagnosis_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("MEDIUM_DESC"), "Diagnosis_MediumDesc");
                return false;
            }

        }
        if ($("#Diagnosis_LongDesc").val().length == 0) {
            if ($("#Diagnosis_ShortDesc").val().length == 0 && $("#Diagnosis_MediumDesc").val().length == 0 && $("#Diagnosis_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("LONG_DESC"), "Diagnosis_LongDesc");
                return false;
            }

        }
        if ($("#Diagnosis_CustomDesc").val().length == 0) {
            if ($("#Diagnosis_ShortDesc").val().length == 0 && $("#Diagnosis_MediumDesc").val().length == 0 && $("#Diagnosis_LongDesc").val().length == 0) {

                alertErrMsg(AlertMsgs.get("CUSTOM_DESC"), "Diagnosis_CustomDesc");
                return false;
            }

        }


        return true;
    }
    return false;
}