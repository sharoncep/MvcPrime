$(document).ready(function () {

    setAutoComplete("Insurance_InsuranceType","InsuranceType");
    setAutoComplete("Insurance_EDIReceiver","EDIReceiver");
    setAutoComplete("Insurance_PrintPin","PrintPin");
    setAutoComplete("Insurance_PatientPrintSign","PatientPrintSign");
    setAutoComplete("Insurance_InsuredPrintSign","InsuredPrintSign");
    setAutoComplete("Insurance_PhysicianPrintSign","PhysicianPrintSign");
    setAutoComplete("Insurance_City","CityName");
    setAutoComplete("Insurance_State","StateName");
    setAutoComplete("Insurance_County","CountyName");
    setAutoComplete("Insurance_Country","CountryName");

    _AlertMsgID = "Insurance_InsuranceCode";
    $("#" + _AlertMsgID).focus();
  
});

function InsuranceTypeID() {
   

}

function EDIReceiverID() {

   

}
function PrintPinID() {


}
function PatientPrintSignID() {


}
function InsuredPrintSignID() {


}
function PhysicianPrintSignID() {


}
function CityNameID() {


}
function StateNameID() {


}
function CountyNameID() {


}
function CountryNameID() {


}


function validateSave() {

    if (canSubmit()) {
        if (!(($('#Insurance_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");
        if ($("#Insurance_InsuranceCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "Insurance_InsuranceCode");
            return false;
        }

        if ($("#Insurance_InsuranceName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "Insurance_InsuranceName");
            return false;
        }

        if ($("#Insurance_PayerID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PAYER_ID"), "Insurance_FirstName");
            return false;
        }


        if ($("#Insurance_InsuranceTypeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("INSURANCE_TYPE"), "Insurance_InsuranceTypeID");
            return false;
        }


        if ($("#Insurance_EDIReceiverID").val() == 0) {

            alertErrMsg(AlertMsgs.get("EDI_RECEIVER"), "Insurance_EDIReceiverID");
            return false;
        }

        if ($("#Insurance_PrintPinID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PRINT_PIN"), "Insurance_PrintPinID");
            return false;
        }

        if ($("#Insurance_PatientPrintSignID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_PRINTSIGN_ID"), "Insurance_PatientPrintSignID");
            return false;
        }

        if ($("#Insurance_InsuredPrintSignID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("INSURED_PRINT_SIGN"), "Insurance_InsuredPrintSignID");
            return false;
        }
        if ($("#Insurance_PhysicianPrintSignID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PHYSICIAN_PRINT_SIGNID"), "Insurance_PhysicianPrintSignID");
            return false;
        }

        if ($("#Insurance_CityID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_CITY"), "Insurance_CityID");
            return false;
        }

        if ($("#Insurance_StateID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STATE"), "Insurance_StateID");
            return false;
        }

        if ($("#Insurance_CountryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_COUNTRY"), "Insurance_CountryID");
            return false;
        }
        if ($("#Insurance_PhoneNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_PHONENUMBER"), "Insurance_PhoneNumber");
            return false;
        }
        if ($("#Insurance_Email").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_EMAIL"), "Insurance_Email");
            return false;
        }
        if ($("#Insurance_StreetName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STREET"), "Insurance_StreetName");
            return false;
        }

        return true;
    }
    return false;
}