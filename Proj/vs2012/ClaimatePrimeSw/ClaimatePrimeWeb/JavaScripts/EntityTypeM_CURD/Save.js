$(document).ready(function () {
    _AlertMsgID = "EntityType_EntityTypeQualifierCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#EntityType_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#EntityType_EntityTypeQualifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "EntityType_EntityTypeQualifierCode");
            return false;
        }

        if ($("#EntityType_EntityTypeQualifierName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "EntityType_EntityTypeQualifierName");
            return false;
        }
        return true;
    }
    return false;
}