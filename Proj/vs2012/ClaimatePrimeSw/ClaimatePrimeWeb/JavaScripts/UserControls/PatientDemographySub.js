$(document).ready(function () { });

function docReadyPatient(ky) {
    setDatePickerDob(ky + "PatientResult_DOB", true);
    setDatePickerFromTo(ky + "PatientResult_InsuranceEffectFrom", true, ky + "PatientResult_InsuranceEffectTo", false);
    setDatePickerDob(ky + "PatientResult_SignedDate", false);

    setAutoComplete(ky + "PatientResult_State", "StateName");
    setAutoComplete(ky + "PatientResult_County", "CountyName");
    setAutoComplete(ky + "PatientResult_City", "CityName");
    setAutoComplete(ky + "PatientResult_Country", "CountryName");
    setAutoComplete(ky + "PatientResult_Provider", "PatientProviderName");
    setAutoComplete(ky + "PatientResult_Insurance", "InsuranceName");
    setAutoComplete(ky + "PatientResult_Relationship", "RelationshipName");

    var objs = $('input[type="radio"][name="rdoSex"]');

    $.each(objs, function (i, obj) {
        if ($("#" + ky + "PatientResult_Sex").val() == $(obj).val()) {
            $(obj).attr("checked", true);
        }
    });

    _AlertMsgID = ky + "PatientResult_ChartNumber";
    $("#" + _AlertMsgID).focus();
}

function StateNameID() {
}

function CountyNameID() {
}

function CountryNameID() {
}

function CityNameID() {
}

function PatientProviderNameID() {
}

function InsuranceNameID() {
}

function RelationshipNameID() {
}

function validateSavePatDemoSub(ky) {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#" + ky + "PatientResult_ChartNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("CHART_NO"), ky + "PatientResult_ChartNumber");
            return false;
        }
        if ($("#" + ky + "PatientResult_MedicareID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MEDICAREID"), ky + "PatientResult_MedicareID");
            return false;
        }

        if ($("#" + ky + "PatientResult_LastName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LAST_NAME"), ky + "PatientResult_LastName");
            return false;
        }

        if ($("#" + ky + "PatientResult_FirstName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FIRST_NAME"), ky + "PatientResult_FirstName");
            return false;
        }


        if ($("#" + ky + "PatientResult_ProviderID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PROVIDER_NAME"), ky + "PatientResult_Provider");
            return false;
        }


        if ($("#" + ky + "PatientResult_InsuranceID").val() == 0) {
            alertErrMsg(AlertMsgs.get("INSURANCE_NAME2"), ky + "PatientResult_Insurance");
            return false;
        }

        if ($("#" + ky + "PatientResult_PolicyNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("POLICY_NUMBER2"), ky + "PatientResult_PolicyNumber");
            return false;
        }

        if ($("#" + ky + "PatientResult_RelationshipID").val() == 0) {
            alertErrMsg(AlertMsgs.get("RELATIONSHIP"), ky + "PatientResult_Relationship");
            return false;
        }

        if ($("#" + ky + "PatientResult_StreetName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STREET"), ky + "PatientResult_StreetName");
            return false;
        }

        if ($("#" + ky + "PatientResult_CityID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_CITY"), ky + "PatientResult_City");
            return false;
        }

        if ($("#" + ky + "PatientResult_StateID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_STATE"), ky + "PatientResult_State");
            return false;
        }

        if ($("#" + ky + "PatientResult_CountryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_COUNTRY"), ky + "PatientResult_Country");
            return false;
        }

        if (!($('#PatientResult_IsInsuranceBenefitAccepted').is(':checked'))) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_ISINSURANCEBENEFITACCEPTED"), ky + "PatientResult_IsInsuranceBenefitAccepted");
            return false;
        }

        if (!($('#PatientResult_IsCapitated').is(':checked'))) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_ISCAPITATED"), ky + "PatientResult_IsCapitated");
            return false;
        }

        if (!($('#PatientResult_IsSignedFile').is(':checked'))) {
            alertErrMsg(AlertMsgs.get("PATIENTRESULT_ISSIGNEDFILE"), ky + "PatientResult_IsSignedFile");
            return false;
        }

        return true;
    }
    return false;
}

function blurValidateMedicareID(obj) {
    keyUpTrim(obj);

    var vl = $(obj).val().length;
    if ((vl == 0) || (vl == 11) || (vl = 12)) {

        unRegisterBlurFn();
        return true;
    }

    alertErrMsg(AlertMsgs.get("INVALID_MEDICARE"), $(obj).attr("id"));

    return false;
}

function blurChartNo(obj) {
    keyUpTrim(obj);
    $("#spnChartNo").html($(obj).val());

    unRegisterBlurFn();
    return true;
}