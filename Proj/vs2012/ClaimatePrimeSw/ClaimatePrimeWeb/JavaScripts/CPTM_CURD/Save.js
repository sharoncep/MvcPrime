$(document).ready(function () {
    _AlertMsgID = "CPT_CPTCode";
    $("#" + _AlertMsgID).focus();
});

function validateSave() {

    if (canSubmit()) {
        if (!(($('#CPT_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");

        if ($("#CPT_CPTCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "CPT_CPTCode");
            return false;
        }


        if ($("#CPT_ShortDesc").val().length == 0) {

            if ($("#CPT_MediumDesc").val().length == 0 && $("#CPT_LongDesc").val().length == 0 && $("#CPT_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("DESC"), "CPT_ShortDesc");
                return false;
            }

        }
        if ($("#CPT_MediumDesc").val().length == 0) {
            if ($("#CPT_ShortDesc").val().length == 0 && $("#CPT_LongDesc").val().length == 0 && $("#CPT_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("MEDIUM_DESC"), "CPT_MediumDesc");
                return false;
            }

        }
        if ($("#CPT_LongDesc").val().length == 0) {
            if ($("#CPT_ShortDesc").val().length == 0 && $("#CPT_MediumDesc").val().length == 0 && $("#CPT_CustomDesc").val().length == 0) {
                alertErrMsg(AlertMsgs.get("LONG_DESC"), "CPT_LongDesc");
                return false;
            }

        }
        if ($("#CPT_CustomDesc").val().length == 0) {
            if ($("#CPT_ShortDesc").val().length == 0 && $("#CPT_MediumDesc").val().length == 0 && $("#CPT_LongDesc").val().length == 0) {

                alertErrMsg(AlertMsgs.get("CUSTOM_DESC"), "CPT_CustomDesc");
                return false;
            }

        }
        if ($("#CPT_ChargePerUnit").val().length == 0) {
            alertErrMsg(AlertMsgs.get("CHARGE_PER_UNIT"), "CPT_ChargePerUnit");
            return false;
        }


        return true;
    }
    return false;
}