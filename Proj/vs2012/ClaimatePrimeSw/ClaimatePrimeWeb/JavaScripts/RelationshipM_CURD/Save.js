$(document).ready(function () {
    _AlertMsgID = "Relationship_RelationshipCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#Relationship_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");

        if ($("#Relationship_RelationshipCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Relationship_RelationshipCode");
            return false;
        }

        if ($("#Relationship_RelationshipName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Relationship_RelationshipName");
            return false;
        }
        return true;
    }
    return false;
}