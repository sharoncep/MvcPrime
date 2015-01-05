$(document).ready(function () {
});

function validateSave() {

    if (canSubmit()) {
        if ($("#Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("REGISTERED_EMAIL"), "Email");
            return false;
        }

        return true;
    }
    return false;
}