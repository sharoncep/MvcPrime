$(document).ready(function () {
    expandPnlDiv("Visit");
    setDatePicker("PatientVisit_PatientVisitResult_IllnessIndicatorDate", true);
    setAutoComplete("PatientVisit_PatientVisitResult_IllnessIndicator", "IllnessIndicator");
    setAutoComplete("PatientVisit_PatientVisitResult_FacilityType", "FacilityType");
    setAutoComplete("PatientVisit_PatientVisitResult_FacilityDone", "FacilityTypeClinic", "PatientVisit_PatientVisitResult_FacilityTypeID");

    _AlertMsgID = "PatientVisit_PatientVisitResult_FacilityDone";
    $("#" + _AlertMsgID).focus();
});

function IllnessIndicatorID() {
}

function FacilityTypeID() {
    $("#PatientVisit_PatientVisitResult_FacilityDoneID").val("");
    $("#PatientVisit_PatientVisitResult_FacilityDone").val("");

    if ($("#PatientVisit_PatientVisitResult_FacilityTypeID").val() != $("#txtOwnClinic").val()) {
        $("#divOwnClinic").hide();
        $("#divNonOwnClinic").show();
        $("#PatientVisit_PatientVisitResult_FacilityDone").focus();
    }
    else {
        $("#divOwnClinic").show();
        $("#divNonOwnClinic").hide();
    }

    $("#divFacilityDoneC").attr("title", "");
    collapsePnlDiv("FacilityDone");

    if (($("#divClinicC").attr("title") == "Clinic") && (($("#PatientVisit_PatientVisitResult_FacilityDoneID").val().length == 0) || ($("#PatientVisit_PatientVisitResult_FacilityDoneID").val() == 0))) {
        $("#divFacilityDoneC").html($("#divClinicC").html());
        $("#divFacilityDoneC").attr("title", "FacilityDone");
    }
}

function FacilityTypeClinicID() {

    $("#divFacilityDoneC").attr("title", "");
    collapsePnlDiv("FacilityDone");

    if (($("#divClinicC").attr("title") == "Clinic") && (($("#PatientVisit_PatientVisitResult_FacilityDoneID").val().length == 0) || ($("#PatientVisit_PatientVisitResult_FacilityDoneID").val() == 0))) {
        $("#divFacilityDoneC").html($("#divClinicC").html());
        $("#divFacilityDoneC").attr("title", "FacilityDone");
    }
}

function saveSuccessVisit(jsonData) {
    var retAns = "";
    for (i in jsonData) {
        var d = jsonData[i];

        $("#PatientVisit_AntiForgTokn").val(d.ANTI_FORG_TOKN);
        //

        $("#tdPatVisitDOS").html(d.DOS);
        $("#PatientVisit_PatientVisitResult_DOS").val(d.DOS);

        $("#tdCaseNo").html(d.PATIENT_VISIT_ID);

        $("#tdHospName").html(d.HOSPITAL_NAME);
        $("#PatientVisit_PatientVisitResult_PatientHospitalizationID").val(d.PATIENT_HOSPITALIZATION_ID);

        if (d.PATIENT_HOSPITALIZATION_ID > 0) {
            $("#divOwnClinic").hide();
            $("#divNonOwnClinic").show();

            $("#PatientVisit_PatientVisitResult_PatientVisitDesc").focus();
        }
        else {
            $("#divOwnClinic").show();
            $("#divNonOwnClinic").hide();
        }

        $("#PatientVisit_PatientVisitResult_IllnessIndicatorID").val(d.ILLNESS_INDICATOR_ID);
        $("#PatientVisit_PatientVisitResult_IllnessIndicator").val(d.ILLNESS_INDICATOR_NAME);

        $("#PatientVisit_PatientVisitResult_IllnessIndicatorDate").val(d.ILLNESS_INDICATOR_DATE);

        $("#PatientVisit_PatientVisitResult_FacilityTypeID").val(d.FACILITY_TYPE_ID);
        $("#PatientVisit_PatientVisitResult_FacilityType").val(d.FACILITY_TYPE);

        $("#PatientVisit_PatientVisitResult_FacilityDoneID").val(d.FACILITY_DONE_ID);

        $("#PatientVisit_PatientVisitResult_FacilityDone").val(d.FACILITY_DONE);

        $("#PatientVisit_PatientVisitResult_PatientVisitDesc").val(d.PATIENT_VISIT_DESC);

        $("#PatientVisit_PatientVisitResult_PatientVisitComplexity").val(d.PATIENT_VISIT_COMPLEXITY);
        $("#PatientVisit_PatientVisitResult_TargetBAUserID").val(d.TARGET_BA_USER_ID);
        $("#PatientVisit_PatientVisitResult_TargetQAUserID").val(d.TARGET_QA_USER_ID);
        $("#PatientVisit_PatientVisitResult_TargetEAUserID").val(d.TARGET_EA_USER_ID);

        //
        $("#FacilityTypeNameID").val(d.FACILITY_TYPE_ID);
        $("#FacilityTypeName").val(d.FACILITY_TYPE);
        //

        $("#embDrNote").removeAttr("src");
        $("#embDrNote").attr("src", d.TMP_URL_DR_NOTE);

        $("#embSupBill").removeAttr("src");
        $("#embSupBill").attr("src", d.TMP_URL_SUP_BILL);

        //

        $("#imgDrNote").removeAttr("src");
        $("#imgDrNote").attr("src", d.IMG_SRC_DR_NOTE);
        $("#imgDrNote").removeAttr("onclick");
        $("#imgDrNote").removeAttr("title");

        $("#imgDrNote").attr("onclick", "return printFile('" + d.IMG_PRINT_SRC_DR_NOTE + "');");
        $("#imgDrNote").attr("title", AlertMsgs.get("PRINT_CLICK"));

        //

        $("#imgSupBill").removeAttr("src");
        $("#imgSupBill").attr("src", d.IMG_SRC_SUP_BILL);
        $("#imgSupBill").removeAttr("onclick");
        $("#imgSupBill").removeAttr("title");

        $("#imgSupBill").attr("onclick", "return printFile('" + d.IMG_PRINT_SRC_SUP_BILL + "');");
        $("#imgSupBill").attr("title", AlertMsgs.get("PRINT_CLICK"));

        //
        if ((_CtrlrName == "AssgnClaims_UR") || (_CtrlrName == "AssgnClaimsNITB_UR")) {
            $("#txtDxCount").val(d.DX_COUNT);
        }

        $("#PatientVisit_PatientVisitResult_Comment").val(d.COMMENT);
        //Fill Div Claim Status

        retAns = retAns + "<table class=\"table-view-claim\">";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width:20%\">";
        retAns = retAns + "Claim Status";
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:30%\">";
        retAns = retAns + d.CLAIM_STATUS_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:20%\">";
        retAns = retAns + "Assigned To";
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:30%\">";
        retAns = retAns + d.ASSIGNED_TO_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + "Target BA User";
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TARGET_BA_USER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + "Target QA User";
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TARGET_QA_USER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + "Target EA User";
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TARGET_EA_USER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + "Visit Complexity";
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PATIENT_VISIT_COMPLEXITY;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "</table>";
    }

    $("#divVisitStatus").html(retAns);

    //fill primary dx
    $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis").val(d.PRIMARY_DX_NAME);
    $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val(d.PRIMARY_CASE_DIAGNOSIS_ID);

    return false;
}
