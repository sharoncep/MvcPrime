$(document).ready(function () {
    _AlertMsgID = "DocumentCategory_DocumentCategoryCode";
    $("#" + _AlertMsgID).focus();
});
function validateSave() {
    if (canSubmit()) {
        if (!(($('#DocumentCategory_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#DocumentCategory_DocumentCategoryCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "DocumentCategory_DocumentCategoryCode");
            return false;
        }

        if ($("#DocumentCategory_DocumentCategoryName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "DocumentCategory_DocumentCategoryName");
            return false;
        }

        return true;
    }
    return false;
}