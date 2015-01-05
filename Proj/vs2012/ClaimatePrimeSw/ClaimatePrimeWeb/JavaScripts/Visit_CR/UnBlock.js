$(document).ready(function () {
    loadVisitResult();
    loadDxResult();
    loadCptResult();
});

function loadVisitResult() {

    showDivPageLoading("Js");

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallVisit/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessVisit(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("Visit_CR --> SearchAjaxCallVisit", req, status, errorObj);
        }
    });

    
    return false;
}

function SearchSuccessVisit(data, status) {

    var retAns = "";

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[i];

                    retAns = retAns + "<table class=\"table-view-claim\">";

                    if (d.IS_ACTIVE) {

                        retAns = retAns + "<div class=\"dv-subheading-cpt\">";
                        retAns = retAns + AlertMsgs.get("NO_BLOCKED_VISIT");
                        retAns = retAns + "</div>";

                        retAns = retAns + " <tr>";
                        retAns = retAns + "<td colspan=\"4\" class=\"td-heading\">";
                        retAns = retAns + "</td>";
                        retAns = retAns + "</tr>";
                        retAns = retAns + "<tr>";
                        retAns = retAns + "<td style=\"width: 20%\">";
                        retAns = retAns + AlertMsgs.get("DOS");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td style=\"width: 30%\" >";
                        retAns = retAns + d.DOS;
                        retAns = retAns + "</td>";
                        retAns = retAns + " </tr>";

                    }
                    else {
                        retAns = retAns + "<div class=\"dv-subheading-cpt\">";
                        retAns = retAns + AlertMsgs.get("BLOCKED_VISIT");
                        retAns = retAns + "</div>";

                        retAns = retAns + " <tr>";
                        retAns = retAns + "<td colspan=\"4\" class=\"td-heading\">";
                        retAns = retAns + "</td>";
                        retAns = retAns + "</tr>";
                        retAns = retAns + "<tr>";
                        retAns = retAns + "<td style=\"width: 20%\">";
                        retAns = retAns + AlertMsgs.get("DOS");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td style=\"width: 30%\" >";
                        retAns = retAns + d.DOS;
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td style=\"width: 20%\"> "
                        retAns = retAns + AlertMsgs.get("IS_HOSP");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td style=\"width: 30%\">";

                        if (d.PATIENT_HOSPITALIZATION_ID != null) {
                            retAns = retAns + AlertMsgs.get("YES");
                        }
                        else {
                            retAns = retAns + AlertMsgs.get("NO");
                        }
                        retAns = retAns + "</td>";
                        retAns = retAns + "</tr>";

                        if (d.PATIENT_HOSPITALIZATION_ID != null) {

                            retAns = retAns + "<tr>";
                            retAns = retAns + "<td>";
                            retAns = retAns + AlertMsgs.get("HOSP_NAME");
                            retAns = retAns + "</td>";
                            retAns = retAns + "<td>";
                            retAns = retAns + d.HOSPITAL_NAME;
                            retAns = retAns + "</td>";
                            retAns = retAns + "</tr>";
                        }

                        retAns = retAns + "<tr>";

                        retAns = retAns + "<td>";
                        retAns = retAns + AlertMsgs.get("ILLNESS_INDICATOR_NAME");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td>";
                        retAns = retAns + d.ILLNESS_INDICATOR_NAME;
                        retAns = retAns + "</td>";

                        retAns = retAns + "<td>";
                        retAns = retAns + AlertMsgs.get("ILLNESS_INDI_DATE");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td>";
                        retAns = retAns + d.ILLNESS_INDICATOR_DATE;
                        retAns = retAns + "</td>";

                        retAns = retAns + "</tr>";

                        retAns = retAns + "<tr>";

                        retAns = retAns + "<td>";
                        retAns = retAns + AlertMsgs.get("FACILITY_TYPE_NAME");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td>";
                        retAns = retAns + d.FACILITY_TYPE;
                        retAns = retAns + "</td>";

                        retAns = retAns + "<td>";
                        retAns = retAns + AlertMsgs.get("FACILITY_DONE_NAME1");
                        retAns = retAns + "</td>";
                        retAns = retAns + "<td>";
                        retAns = retAns + d.FACILITY_DONE;
                        retAns = retAns + "</td>";
                        retAns = retAns + "</tr>";

                        retAns = retAns + "<tr>";
                        retAns = retAns + "<td>";
                        retAns = retAns + "<input type=\"submit\" name=\"btnUnblock\" id=\"btnUnblock\" value=\" ";
                        retAns = retAns + AlertMsgs.get("UN_BLOCK");
                        retAns = retAns + " \" class=\"button-save\" onclick=\"javascript: return unblockVisit();\"> ";
                        retAns = retAns + "</td>";
                        retAns = retAns + "</tr>";

                    }
                    retAns = retAns + "</table>";
                }
            }
        }
    }

    $("#divVisitView").html(retAns);
    return false;
}

function loadDxResult() {

    var params = "{'pKy' : '" + $("#txtDescTypeDx").val() + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallDx/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessDx(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("Visit_CR --> SearchAjaxCallDx", req, status, errorObj);
        }
    });

    return false;
}

function SearchSuccessDx(jsonData) {

    var i = -1;
    var retAns = "";
    var retNoAns = "";

    retAns = retAns + "<div class=\"dv-subheading-cpt\">";
    retAns = retAns + AlertMsgs.get("BLOCKED_DX_LIST");
    retAns = retAns + "</div>";

    retAns = retAns + "<div>";
    retAns = retAns + "<table class=\"table-grid-view\">";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<tr>";
        retAns = retAns + "<td title=\"";
        retAns = retAns + d.DISP1;
        retAns = retAns + "\">";
        retAns = retAns + d.DISP1;
        retAns = retAns + "</td>";

        //retAns = retAns + "<td>";
        //retAns = retAns + "<input type=\"submit\" name=\"btnUnblockDx\" id=\"btnUnblockDx\" value=\" ";
        //retAns = retAns + AlertMsgs.get("UN_BLOCK");
        //retAns = retAns + " \" class=\"aUnblock\" onclick=\"javascript: return unblockDx(";
        //retAns = retAns + d.ID;
        //retAns = retAns + ");\"> ";
        //retAns = retAns + "</td>";

        retAns = retAns + "<td title=\"";
        retAns = retAns + AlertMsgs.get("UN_BLOCK");
        retAns = retAns + "\">";

        retAns = retAns + "<a id=\"";
        retAns = retAns + d.ID;
        retAns = retAns + "\" ";
        retAns = retAns + "href=\"#\" class=\"aUnblock\" rel=\"control_tile\" onclick=\"javascript:return unblockDx(this);\">";
        retAns = retAns + "Unblock</a>";

        retAns = retAns + "</td>";
    }

    retAns = retAns + "</table>";
    retAns = retAns + "</div>";

    retAns = retAns + "</table>";
    retAns = retAns + "</div>";

    if (i != -1) {
        $("#divDxList").html(retAns);
    }
    //else {
    //    retNoAns = retNoAns + "<div class=\"dv-subheading-cpt\">";
    //    retNoAns = retNoAns + AlertMsgs.get("NO_BLOCKED_DX");
    //    retNoAns = retNoAns + "</div>";

    //    $("#divDxList").html(retNoAns);
    //}

    return false;
}

function loadCptResult() {

    var params = "{'pKy' : '" + $("#txtDescTypeCpt").val() + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallCpt/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessCpt(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("Visit_CR --> SearchAjaxCallCpt", req, status, errorObj);
        }
    });

    return false;
}

function SearchSuccessCpt(jsonData) {


    var retAnsSum = "";
    var retAnsNoSum = "";
    var i = -1;

    retAnsSum = retAnsSum + "<div class=\"dv-subheading-cpt\">";
    retAnsSum = retAnsSum + AlertMsgs.get("BLOCKED_CPT_LIST");
    retAnsSum = retAnsSum + "</div>";

    retAnsSum = retAnsSum + "<div>";
    retAnsSum = retAnsSum + "<table class=\"table-grid-view\">";

    retAnsSum = retAnsSum + "<tr>";
    retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("DIAGNOSIS");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("DX");
    retAnsSum = retAnsSum + "</td>";

    retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("PROCEDURE");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("PROCEDURE");
    retAnsSum = retAnsSum + "</td>";

    retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("DOS");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("DOS");
    retAnsSum = retAnsSum + "</td>";

    retAnsSum = retAnsSum + "<td style=\"width:15%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("FAC_TYPE");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("FACILITY");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:5%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("MODI1");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("M1");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:5%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("MODI2");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("M2");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:5%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("MODI3");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("M3");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:5%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("MODI4");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("M4");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:15%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("UNS");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:8%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("CHR_UNIT");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("CHR");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:7%;\" class=\"td-gridhead-claim\" title=\"";
    retAnsSum = retAnsSum + AlertMsgs.get("CHR_TOT");
    retAnsSum = retAnsSum + "\">";
    retAnsSum = retAnsSum + AlertMsgs.get("TOT");
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "<td style=\"width:15%;\" class=\"td-gridhead-claim\">";
    retAnsSum = retAnsSum + "&nbsp;";
    retAnsSum = retAnsSum + "</td>";
    retAnsSum = retAnsSum + "</tr>";

    for (i in jsonData) {
        var d = jsonData[i];

        retAnsSum = retAnsSum + "<tr>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.DX_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.DX_CODE;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.CPT_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.CPT_CODE;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("DOS");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.CPTDOS;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.POS_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.POS_CODE;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.MODI1_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.MODI1_CODE;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.MODI2_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.MODI2_CODE;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.MODI3_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.MODI3_CODE;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.MODI4_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.MODI4_CODE;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.UNIT;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("CHR_UNIT");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.CHARGE_PER_UNIT;
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("CHR_TOT");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + (d.UNIT * d.CHARGE_PER_UNIT).toString();
        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("UN_BLOCK");
        retAnsSum = retAnsSum + "\">";

        retAnsSum = retAnsSum + "<a href=\"#\" class=\"aUnblock\" rel=\"control_tile\" onclick=\"javascript:return unblockCpt('";
        retAnsSum = retAnsSum + d.CLAIM_DIAGNOSIS_CPT_ID
        retAnsSum = retAnsSum + "');\">";
        retAnsSum = retAnsSum + "Unblock</a>";

        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "</tr>";
    }

    retAnsSum = retAnsSum + "</table>";
    retAnsSum = retAnsSum + "</div>";

    if (i != -1) {
        $("#divProcListSum").html(retAnsSum);
    }
    //else {
    //    retAnsNoSum = retAnsNoSum + "<div class=\"dv-subheading-cpt\">";
    //    retAnsNoSum = retAnsNoSum + AlertMsgs.get("NO_BLOCKED_CPT");
    //    retAnsNoSum = retAnsNoSum + "</div>";

    //    $("#divProcListSum").html(retAnsNoSum);
    //}

    hideDivPageLoading("Js");

    return false;
}

function unblockVisit() {

    if (!(confirm(AlertMsgs.get("UN_BLOCK_CONFIRM")))) {
        return false;
    }

    showDivPageLoading("Js");
    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/UnblockVisitAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            saveVisitSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> UnblockVisitAjaxCall", req, status, errorObj);
        }
    });

    return false;
}

function saveVisitSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    if (d.length == 0) {
                        location.reload(true);
                    }
                    else {
                        alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "DiagName");
                    }
                }
            }
        }
    }
}

function descTypeClickDx(obj) {
    var preVal = $("#txtDescTypeDx").val();
    var curVal = $(obj).val();

    if (preVal != curVal) {
  
        $("#txtDescTypeDx").val(curVal);

    }

    return true;
}

function unblockDx(obj) {
    if (!(confirm(AlertMsgs.get("UN_BLOCK_CONFIRM")))) {
        return false;
    }

    showDivPageLoading("Js");
    var params = "{'pClaimDiagnosisID' : '" + $(obj).attr("id") + "'}";   // if no params need to use "{}"
    //var params = "{'pClaimDiagnosisID' : '" + obj + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/UnblockDxAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            saveDxSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> UnblockDxAjaxCall", req, status, errorObj);
        }
    });

    return false;
}

function saveDxSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    if (d.length == 0) {

                        location.reload(true);
                    }
                    else {
                        alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "DiagName");
                    }
                }
            }
        }
    }
}

function unblockCpt(obj) {

    if (!(confirm(AlertMsgs.get("UN_BLOCK_CONFIRM")))) {
        return false;
    }

    showDivPageLoading("Js");

    var params = "{'pClaimCPTID' : '" + obj + "'}";    // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/UnblockCptAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            saveCptSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> UnblockCptAjaxCall", req, status, errorObj);
        }
    });

    return false;
}

function saveCptSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    if (d.length == 0) {
                        location.reload(true);
                    }
                    else {
                        alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "DiagName");
                    }
                }
            }
        }
    }
}

