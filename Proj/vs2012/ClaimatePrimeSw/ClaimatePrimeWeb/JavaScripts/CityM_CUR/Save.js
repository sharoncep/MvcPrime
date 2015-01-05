$(document).ready(function () {
    _AlertMsgID = "City_ZipCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#City_ZipCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_ZIPCODE"), "City_ZipCode");
            return false;
        }
        if ($("#City_CityName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "City_CityName");
            return false;
        }
        if (!($("#City_CityName").val().startsAlpha())) {
            alertErrMsg(AlertMsgs.get("MSG_ALPHA"), "City_CityName");
            return false;
        }

        if ($("#City_CityCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "City_CityCode");
            return false;
        }
        return true;
    }
    return false;
}