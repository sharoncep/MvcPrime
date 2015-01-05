$(document).ready(function () {
    _AlertMsgID = "Country_CountryCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#Country_CountryCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Country_CountryCode");
            return false;
        }

        if ($("#Country_CountryName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Country_CountryName");
            return false;
        }

        return true;
    }
    return false;
}