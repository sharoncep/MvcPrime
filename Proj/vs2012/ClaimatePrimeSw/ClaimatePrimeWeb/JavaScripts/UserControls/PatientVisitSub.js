$(document).ready(function () {
    setDatePicker("PatientVisitResult_IllnessIndicatorDate", true);
    setAutoComplete("IllnessIndicatorName");
    setAutoComplete("FacilityTypeName");
    setAutoComplete("FacilityDoneName", "PatientVisitResult_FacilityTypeID");

    _AlertMsgID = "FacilityDoneName";
    $("#" + _AlertMsgID).focus();
});



function IllnessIndicatorNameID(selId) {
    $("#PatientVisitResult_IllnessIndicatorID").val(selId);
}

function FacilityTypeNameID(selId) {
    $("#PatientVisitResult_FacilityTypeID").val(selId);
    $("#PatientVisitResult_FacilityTypeClinicID").val(0);
    $("#FacilityDoneName").val("");

    if (($("#PatientVisitResult_FacilityTypeID").val() != "0") && ($("#PatientVisitResult_FacilityTypeID").val() != $("#txtOwnClinic").val())) {
        $("#divOwnClinic").hide();
        $("#divNonOwnClinic").show();
        $("#FacilityDoneName").focus();
    }
    else {
        $("#divOwnClinic").show();
        $("#divNonOwnClinic").hide();
    }
}

function FacilityDoneNameID(selId) {
    $("#PatientVisitResult_FacilityTypeClinicID").val(selId);
}
function validateSave() {

    if (canSubmit()) {
        if (!(($('#PatientVisitResult_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if (($("#FacilityTypeName").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("FACILITY_TYPE"), "FacilityTypeName");
            return false;
        }

        if (($("#PatientVisitResult_FacilityTypeID").val() != "0") && ($("#PatientVisitResult_FacilityTypeID").val() != $("#txtOwnClinic").val()) && ($("#FacilityDoneName").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("FACILITY_DONE_NAME"), "FacilityDoneName");
            return false;
        }

        return true;
    }
    return false;
}

