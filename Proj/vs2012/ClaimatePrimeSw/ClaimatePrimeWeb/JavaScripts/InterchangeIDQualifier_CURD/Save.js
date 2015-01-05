$(document).ready(function () {
    _AlertMsgID = "InterchangeIDQualifier_InterchangeIDQualifierCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#InterchangeIDQualifier_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#InterchangeIDQualifier_InterchangeIDQualifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "InterchangeIDQualifier_InterchangeIDQualifierCode");
            return false;
        }

        if ($("#InterchangeIDQualifier_InterchangeIDQualifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "InterchangeIDQualifier_InterchangeIDQualifierName");
            return false;
        }
        return true;
    }
    return false;
}