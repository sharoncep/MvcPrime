$(document).ready(function () {
    setTimeout("docReadyClinic('');", 300);
   
});

function validateSave() {
    if (canSubmit()) {
        if (!(($('#ClinicResult_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        return validateSavePatDemoSub("");
        return true;
    }
    return false;
}

