$(document).ready(function () {
    setAutoComplete("PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis", "DiagNamePri", "txtDescTypeDxPri");
});

function DiagNamePriID() {
    $("#DiagNamePro").val($("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis").val());
    $("#DiagNameProID").val($("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val());
}

function descTypeClickDxPri(obj) {
    var preVal = $("#txtDescTypeDxPri").val();
    var curVal = $(obj).val();

    if (preVal != curVal) {
        $("#divDxprimaryC").removeAttr("class");
        $("#divDxprimaryC").attr("class", "dv-claim-loading");

        $("#txtDescTypeDxPri").val(curVal);
        $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis").val("");
        $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val("");
        reLoadPnlDiv("Dxprimary");

    }
    return true;
}

function saveSuccessDxPrime(jsonData) {
    for (i in jsonData) {
        var d = jsonData[i];
        $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis").val(d.DISP1);
        $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val(d.ID);
    }
}


