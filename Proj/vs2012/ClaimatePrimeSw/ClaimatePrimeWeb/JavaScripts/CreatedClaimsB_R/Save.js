﻿$(document).ready(function () {

});

function expandPnlDiv(ky) {
    expandDiv(ky);

    var divTit = $("#div" + ky + "C").attr("title");

    if (divTit != ky) {
        // Not loaded yet

        $("#div" + ky + "C").removeAttr("class");
        $("#div" + ky + "C").attr("class", "dv-claim-loading");

        var params = "";
        var urlActn = "";

        if (ky == "Dx") {

            
            params = "{'pKy' : '" + $("#txtDescTypeDx").val() + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCallDx/0/0/");
          
        }
        
       else if (ky == "Cpt") {
            params = "{'pKy' : '" + $("#txtDescTypeDxPro").val() + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCallCpt/0/0/");
        }
        else if (ky == "FacilityDone") {
            if (($("#FacilityDoneID").val().length > 0) && ($("#FacilityDoneID").val() > 0)) {
                params = "{'pKy' : '" + $("#FacilityDoneID").val() + "'}";   // if no params need to use "{}"
                urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCallFacilityDone/0/0/");
            }

            else {
                setTimeout("expandPnlDiv('FacilityDone')", 900);
                setTimeout("collapsePnlDiv('Clinic')", 700);

                return expandPnlDiv("Clinic");
            }
        }
        else if (ky == "PrevVisits") {
            params = "{'pKy' : '" + $("#tdPatVisitDOS").html() + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCallPrevVisits/0/0/");
        }
        else if (ky.startsWith("PrevVisitsDOS_")) {
            params = "{'pKy' : '" + ky.split("_")[1] + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/GetPrevVisitsDetails/0/0/");
        }
        else if (ky.startsWith("PrevVisitsStatus_")) {
            params = "{'pKy' : '" + ky.split("_")[1] + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCallPrevStatus/0/0/");
        }
        else {
            params = "{'pKy' : '" + ky + "'}";   // if no params need to use "{}"
            urlActn = (_AppDomainPath + _CtrlrName + "/SaveAjaxCall/0/0/");
        }
        $.ajax({
            url: urlActn,
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                saveSuccess(data, status, ky);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("AssgnClaims_R --> SaveAjaxCall", req, status, errorObj);
            }
        });
    }

    return false;
}

function collapsePnlDiv(ky) {
    return collapseDiv(ky);
}

function saveSuccess(data, status, ky) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                if ((ky == "Visit")  || (ky == "Visitdoc") || (ky == "DrNote") || (ky == "SuperBill")) {
                    saveSuccessVisitView(jsonData);

                    $("#divVisitC").attr("title", "Visit");
                    $("#divVisitdocC").attr("title", "Visitdoc");
                    $("#divDrNoteC").attr("title", "DrNote");
                    $("#divSuperBillC").attr("title", "SuperBill");
              
                }
                else if (ky == "Dx") {
                    saveSuccessDxView(jsonData);
                }
                else if (ky == "Dxprimary") {
                    saveSuccessPrimaryDxView(jsonData);
                }
                else if (ky == "Settings") {
                    saveSuccessEDISettings(jsonData);
                }
                else if (ky == "Insurance") {
                    saveSuccessInsurance(jsonData);
                }
                else if (ky == "Cpt") {
                    saveSuccessCPTView(jsonData);
                }
                else if (ky == "Notes") {
                    saveSuccessNotesView(jsonData);
                }
                else if (ky == "Claim") {
                    saveSuccessStatus(jsonData);
                }
                else if (ky == "PatientDoc") {
                    saveSuccessPatientDoc(jsonData);
                }
                else if (ky == "Patient") {
                    saveSuccessPatient(jsonData);
                }

                else if (ky == "Provider") {
                    saveSuccessProvider(jsonData);
                }
                else if (ky == "Ipa") {
                    saveSuccessIpa(jsonData);
                }
                else if (ky == "Clinic") {
                    saveSuccessClinic(jsonData);

                    if (($("#FacilityDoneID").val().length == 0) || ($("#FacilityDoneID").val() == 0)) {
                        $("#divFacilityDoneC").html($("#divClinicC").html());
                        $("#divFacilityDoneC").attr("title", "FacilityDone");
                    }
                }
                else if (ky == "FacilityDone") {
                    saveSuccessFacility(jsonData);
                }
                else if (ky == "PatientDoc") {
                    saveSuccessPatientDoc(jsonData);
                }
                else if (ky == "PrevVisits") {
                    saveSuccessPrevVisit(jsonData);
                }
                else if (ky.startsWith("PrevVisitsDOS_")) {
                    saveSuccessVisitDetails(jsonData, ky);
                }
                else if (ky.startsWith("PrevVisitsStatus_")) {
                    saveSuccessPrevStatus(jsonData, ky);
                }
                else {
                }

                $("#div" + ky + "C").attr("title", ky);
            }
        }
    }

    $("#div" + ky + "C").removeAttr("class");
    $("#div" + ky + "C").attr("class", "dv-bdr");

    return false;
}

function reLoadPnlDiv(ky) {
    $("#div" + ky + "C").attr("title", "");
    expandPnlDiv(ky);
}