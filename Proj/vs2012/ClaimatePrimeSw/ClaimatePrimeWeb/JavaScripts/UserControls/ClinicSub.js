$(document).ready(function () { });

function docReadyClinic(ky) {
  
  

    setAutoComplete(ky + "ClinicResult_State", "StateName");
    setAutoComplete(ky + "ClinicResult_County", "CountyName");
    setAutoComplete(ky + "ClinicResult_City", "CityName");
    setAutoComplete(ky + "ClinicResult_Country", "CountryName");
    setAutoComplete(ky + "ClinicResult_IPA", "IPA");
    setAutoComplete(ky + "ClinicResult_EntityTypeQualifier", "EntityType");
    setAutoComplete(ky + "ClinicResult_Specialty", "Specialty");
    setAutoComplete(ky + "UserResult_User", "ManagerClinic");


    _AlertMsgID = ky + "ClinicResult_IPA";
    $("#" + _AlertMsgID).focus();

  
}

function StateNameID() {
}

function ManagerClinicID() {
}



function CountyNameID() {
}

function CountryNameID() {
}

function CityNameID() {
}

function IPAID() {
}

function EntityTypeID() {
}

function SpecialtyID() {
}

function validateSavePatDemoSub(ky) {
    if (canSubmit()) {
       
        showDivPageLoading("Js");

        if ($("#" + ky + "ClinicResult_IPA").val().length == 0) {
            alertErrMsg(AlertMsgs.get("CLINIC_IPA"), ky + "ClinicResult_IPA");
            return false;
        }
        if ($("#" + ky + "ClinicResult_ClinicCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), ky + "ClinicResult_ClinicCode");
            return false;
        }
        if ($("#" + ky + "ClinicResult_ClinicName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), ky + "ClinicResult_ClinicName");
            return false;
        }
        if ($("#" + ky + "ClinicResult_NPI").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NPI"), ky + "ClinicResult_ClinicName");
            return false;
        }
        if ($("#" + ky + "ClinicResult_EntityTypeQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("ENTITYTYPE_QUALIFIER"), ky + "ClinicResult_EntityTypeQualifier");
            return false;
        }
        if ($("#" + ky + "ClinicResult_SpecialtyID").val() == 0) {
            alertErrMsg(AlertMsgs.get("SPEC"), ky + "ClinicResult_Specialty");
            return false;
        }
        
        if ($("#" + ky + "ClinicResult_PatientVisitComplexity").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_COMPLEXITY"), ky + "ClinicResult_PatientVisitComplexity");
            return false;
        }
        if ($("#" + ky + "ClinicResult_StreetName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STREET"), ky + "ClinicResult_StreetName");
            return false;
        }

        if ($("#" + ky + "ClinicResult_CityID").val() == 0) {

            alertErrMsg(AlertMsgs.get("PATIENT_CITY"), ky + "ClinicResult_City");
            return false;
        }

        if ($("#" + ky + "ClinicResult_StateID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STATE"), ky + "ClinicResult_State");
            return false;
        }

        if ($("#" + ky + "ClinicResult_CountryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_COUNTRY"), ky + "ClinicResult_Country");
            return false;
        }
        if ($("#" + ky + "ClinicResult_PhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), ky + "ClinicResult_PhoneNumber");
            return false;
        }


        if ($("#" + ky + "ClinicResult_Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), ky + "ClinicResult_Email");
            return false;
        }
        if ($("#" + ky + "ClinicResult_ContactPersonLastName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LAST_NAME"), ky + "ClinicResult_ContactPersonLastName");
            return false;
        }
        if ($("#" + ky + "ClinicResult_ContactPersonFirstName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FIRST_NAME"), ky + "ClinicResult_ContactPersonFirstName");
            return false;
        }

        if ($("#" + ky + "ClinicResult_ContactPersonPhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), ky + "ClinicResult_ContactPersonPhoneNumber");
            return false;
        }

        if ($("#" + ky + "ClinicResult_ContactPersonEmail").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), ky + "ClinicResult_ContactPersonEmail");
            return false;
        }

        if ($("#" + ky + "UserResult_User").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MANAGER_NAME"), ky + "UserResult_User");
            return false;
        }
        if ($("#" + ky + "ClinicResult_PatientVisitComplexity").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_COMPLEXITY"), ky + "ClinicResult_PatientVisitComplexity");
            return false;
        }

       
       
        
        return true;
    }
    return false;
}

