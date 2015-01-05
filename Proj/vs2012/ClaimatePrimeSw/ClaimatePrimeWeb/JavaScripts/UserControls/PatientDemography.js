$(document).ready(function () {
    setTimeout("docReadyPatient('');", 300);
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#PatientResult_IsActive').is(':checked')))) {


            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        return validateSavePatDemoSub("");
        return true;
    }
    return false;
}

function sexClickPat(obj) {
    $("#PatientResult_Sex").val($(obj).val());
}