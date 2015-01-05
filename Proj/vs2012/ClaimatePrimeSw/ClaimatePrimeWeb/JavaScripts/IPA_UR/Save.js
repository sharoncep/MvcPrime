$(document).ready(function () {

    setAutoComplete("IPA_EntityTypeQualifier", "EntityType");
    setAutoComplete("IPA_State", "StateName");
    setAutoComplete("IPA_County","CountyName");
    setAutoComplete("IPA_Country","CountryName");
    setAutoComplete("IPA_City", "CityName");

    _AlertMsgID = "IPA_IPACode";
    $("#" + _AlertMsgID).focus();
});

function EntityTypeID(selId) {


}
function StateNameID(selId) {


}

function CountyNameID(selId) {


}
function CountryNameID(selId) {


}
function CityNameID(selId) {


}

function validateSave() {

    if (canSubmit()) {

        if (!(($('#IPA_IsActive').is(':checked')))) {


            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");
        if ($("#IPA_IPACode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "IPA_IPACode");
            return false;
        }

        if ($("#IPA_IPAName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("IPA_NAME"), "IPA_IPAName");
            return false;
        }

        if ($("#IPA_NPI").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NPI"), "IPA_NPI");
            return false;
        }
        if ($("#IPA_TaxID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_TAX"), "IPA_TaxID");
            return false;
        }


        if ($("#EntityTypeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("ENTITY_TYPEMSG"), "EntityTypeID");
            return false;
        }




        if ($("#IPA_CityID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_CITY"), "IPA_CityID");
            return false;
        }

        if ($("#IPA_StateID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STATE"), "IPA_StateID");
            return false;
        }

        if ($("#IPA_CountryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_COUNTRY"), "IPA_CountryID");
            return false;
        }
        if ($("#IPA_PhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), "IPA_PhoneNumber");
            return false;
        }
        if ($("#IPA_Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), "IPA_Email");
            return false;
        }
        if ($("#IPA_ContactPersonLastName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LAST_NAME"), "IPA_ContactPersonLastName");
            return false;
        }
        if ($("#IPA_ContactPersonFirstName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FIRST_NAME"), "IPA_ContactPersonFirstName");
            return false;
        }
        if ($("#IPA_ContactPersonEmail").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), "IPA_ContactPersonEmail");
            return false;
        }
        return true;
    }
    return false;
}