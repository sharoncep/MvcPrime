$(document).ready(function () {

    setDatePickerFromTo("PatientHospitalizationResult_AdmittedOn", true, "PatientHospitalizationResult_DischargedOn", false);

   
    setAutoComplete("PatientHospitalizationResult_FacilityDoneHospital","HospitalName");
   

   _AlertMsgID = "ChartNumber";
    $("#" + _AlertMsgID).focus();
});

function HospitalNameID() {
}


function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if (!(($('#PatientHospitalizationResult_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        if ($("#PatientHospitalizationResult_PatientID").val() == 0) {
            alertErrMsg(AlertMsgs.get("CHART_NO"), "PatientHospitalizationResult_Patient");
            return false;
        }

        if ($("#PatientHospitalizationResult_FacilityDoneHospitalID").val() == 0) {
            alertErrMsg(AlertMsgs.get("HOSPITAL_NAME"), "PatientHospitalizationResult_FacilityDoneHospital");
            return false;
        }


        if ($("#PatientHospitalizationResult_AdmittedOn").val().length == 0) {
            alertErrMsg(AlertMsgs.get("ADMITTED_ON"), "PatientHospitalizationResult_AdmittedOn");
            return false;
        }

       

        return true;
    }
    return false;
}