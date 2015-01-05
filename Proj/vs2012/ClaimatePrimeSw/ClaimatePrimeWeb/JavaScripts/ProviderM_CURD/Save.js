$(document).ready(function () {

    _AlertMsgID = "Provider_ProviderCode";
    $("#" + _AlertMsgID).focus();

    setDatePickerDob("Provider_SignedDate", false);

    var objs = $('input[type="radio"][name="rdoSex"]');

    $.each(objs, function (i, obj) {
        if ($("#Provider_Sex").val() == $(obj).val()) {
            $(obj).attr("checked", true);
        }
    });

    setAutoComplete("Provider_Specialty", "Specialty");
    setAutoComplete("Provider_State", "StateName");
    setAutoComplete("Provider_County","CountyName");
    setAutoComplete("Provider_Country","CountryName");
    setAutoComplete("Provider_City","CityName");
    setAutoComplete("Provider_Credential","Credential");

});


function SpecialtyID(selId) {


}
function StateNameID(selId) {


}

function CountyNameID(selId) {


}
function CountryNameID(selId) {


}
function CityNameID(selId) {


}
function CredentialID(selId) {


}

function validateSave() {

    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#Provider_ProviderCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Provider_ProviderCode");
            return false;
        }
        if ($("#Provider_LastName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LAST_NAME"), "Provider_LastName");
            return false;
        }
        if ($("#Provider_FirstName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FIRST_NAME"), "Provider_FirstName");
            return false;
        }
        if ($("#Provider_SpecialtyID").val() == 0) {
            alertErrMsg(AlertMsgs.get("SPEC"), "Provider_Specialty");
            return false;
        }
        if ($("#Provider_NPI").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NPI"), "Provider_NPI");
            return false;
        }

        if ($("#Provider_CredentialID").val() == 0) {
            alertErrMsg(AlertMsgs.get("CRED"), "Provider_Credential");
            return false;
        }
        if ($("#Provider_StreetName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STREET"), "Provider_StreetName");
            return false;
        }
        if ($("#Provider_CityID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_CITY"), "Provider_City");
            return false;
        }

        if ($("#Provider_StateID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STATE"), "Provider_State");
            return false;
        }

        if ($("#Provider_CountryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_COUNTRY"), "Provider_Country");
            return false;
        }
        if ($("#Provider_PhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), "Provider_PhoneNumber");
            return false;
        }
        if ($("#Provider_Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), "Provider_Email");
            return false;
        }
        return true;
    }
    return false;

}