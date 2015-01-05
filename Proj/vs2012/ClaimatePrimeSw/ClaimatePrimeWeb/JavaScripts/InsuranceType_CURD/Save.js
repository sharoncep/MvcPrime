$(document).ready(function () {
    _AlertMsgID = "InsuranceType_InsuranceTypeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {
    if (canSubmit()) {
        if (!(($('#InsuranceType_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#InsuranceType_InsuranceTypeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "InsuranceType_InsuranceTypeCode");
            return false;
        }

        if ($("#InsuranceType_InsuranceTypeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "InsuranceType_InsuranceTypeName");
            return false;
        }
        
    }
    return false;

}