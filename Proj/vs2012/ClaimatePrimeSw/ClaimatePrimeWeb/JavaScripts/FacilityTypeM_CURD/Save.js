$(document).ready(function () {
    _AlertMsgID = "FacilityType_FacilityTypeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#FacilityType_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");

        if ($("#FacilityType_FacilityTypeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "FacilityType_FacilityTypeCode");
            return false;
        }

        if ($("#FacilityType_FacilityTypeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "FacilityType_FacilityTypeName");
            return false;
        }
        return true;
    }
    return false;

}