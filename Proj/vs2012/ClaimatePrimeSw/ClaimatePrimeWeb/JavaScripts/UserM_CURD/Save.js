$(document).ready(function () {

   

    _AlertMsgID = "User_UserName";
    $("#" + _AlertMsgID).focus();
});



function validateSave() {

    if (canSubmit()) {
        if (!(($('#User_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }


        showDivPageLoading("Js");

        if ($("#User_UserName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("USER_NAME2"), "User_UserName");
            return false;
        }

        if ($("#User_Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), "User_Email");
            return false;
        }

        if ($("#User_LastName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LASTNAME2"), "User_LastName");
            return false;
        }
        if ($("#User_FirstName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FNAME2"), "User_LastName");
            return false;
        }
        if ($("#User_PhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), "User_PhoneNumber");
            return false;
        }

        return true;
    }
    return false;

}

