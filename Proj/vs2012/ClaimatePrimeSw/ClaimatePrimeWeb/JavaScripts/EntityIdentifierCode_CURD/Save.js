$(document).ready(function () {
    _AlertMsgID = "EntityIdentifierCode_EntityIdentifierCodeCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#EntityIdentifierCode_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#EntityIdentifierCode_EntityIdentifierCodeCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "EntityIdentifierCode_EntityIdentifierCodeCode");
            return false;
        }

        if ($("#EntityIdentifierCode_EntityIdentifierCodeName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "EntityIdentifierCode_EntityIdentifierCodeName");
            return false;
        }
        return true;
    }
    return false;
}