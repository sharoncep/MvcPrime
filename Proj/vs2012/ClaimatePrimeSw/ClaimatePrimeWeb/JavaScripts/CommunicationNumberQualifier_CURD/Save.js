$(document).ready(function () {
    _AlertMsgID = "CommunicationNumberQualifier_CommunicationNumberQualifierCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#CommunicationNumberQualifier_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#CommunicationNumberQualifier_CommunicationNumberQualifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "CommunicationNumberQualifier_CommunicationNumberQualifierCode");
            return false;
        }

        if ($("#CommunicationNumberQualifier_CommunicationNumberQualifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "CommunicationNumberQualifier_CommunicationNumberQualifierName");
            return false;
        }
        return true;
    }
    return false;
}