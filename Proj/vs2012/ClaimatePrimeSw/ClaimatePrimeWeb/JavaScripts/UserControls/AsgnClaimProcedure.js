$(document).ready(function () {
    setAutoComplete("DiagNamePro", "DiagNamePro", "txtDescTypeDxPro");
    setAutoComplete("ProcCptName", "ProcCptName", "txtDescTypeDxPro");
    setAutoComplete("FacilityTypeName");
    setAutoComplete("ModifierName1");
    setAutoComplete("ModifierName2");
    setAutoComplete("ModifierName3");
    setAutoComplete("ModifierName4");
 
    _AlertMsgID = "DiagNamePro";
    $("#" + _AlertMsgID).focus();
});

function DiagNameProID() {
}

function ProcCptNameID() {
    GetCharge();
}

function FacilityTypeNameID() {
}

function ModifierName1ID() {
}

function ModifierName2ID() {
}

function ModifierName3ID() {
}

function ModifierName4ID() {
}

function descTypeClickDxPro(obj) {
    var preVal = $("#txtDescTypeDxPro").val();
    var curVal = $(obj).val();

    if (preVal != curVal) {
        $("#divCptC").removeAttr("class");
        $("#divCptC").attr("class", "dv-claim-loading");

        $("#txtDescTypeDxPro").val(curVal);

        $("#DiagNamePro").val("");
        $("#DiagNameProID").val("");

        $("#ProcCptName").val("");
        $("#ProcCptNameID").val("");

        reLoadPnlDiv("Cpt");
    }

    return true;
}

function GetCharge() {
    if (($("#ProcCptNameID").val().length == 0) || ($("#ProcCptNameID").val() == 0)) {
        return false;
    }

    var params = "{'pCPTID' : '" + $("#ProcCptNameID").val() + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/GetCharge/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            getChargeSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> GetCharge", req, status, errorObj);
        }
    });

    return false;
}

function getChargeSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    $("#txtChargePerUnit").val(d.CHARGE_PER_UNIT);
                }
            }
        }
    }

    return false;
}

function blurCalcTotCharge(obj) {
    keyUpNumericLen(obj, 9);

    if (parseFloat($(obj).val()) > 999999.99) {
        $(obj).val("");
        alertErrMsg(AlertMsgs.get("MAX_VAL_ERROR"), $(obj).attr("id"));

        registerBlurFn();
        return false;
    }

    if (($("#txtChargePerUnit").val().length > 0) && ($("#txtUnits").val().length > 0)) {
        $("#tdTotAmount").html(parseFloat($("#txtChargePerUnit").val()) * parseFloat($("#txtUnits").val()));
    }


    unRegisterBlurFn();
    return true;
}

//load cpt list
function saveSuccessPro(jsonData) {
    $("#ProcCptNameID").val("");
    $("#ProcCptName").val("");

    $("#txtUnits").val("1");
    $("#txtChargePerUnit").val("");
    $("#tdTotAmount").html("0");

    $("#ModifierName1ID").val("");
    $("#ModifierName1").val("");
    $("#ModifierName2ID").val("");
    $("#ModifierName2").val("");
    $("#ModifierName3ID").val("");
    $("#ModifierName3").val("");
    $("#ModifierName4ID").val("");
    $("#ModifierName4").val("");

    var retAnsSum = "";
    var retAnsDet = "";
    var CLAIM_NO_PREV = -1;
    var DIAG_PREV = "";
    var i = -1;

    retAnsSum = retAnsSum + "<div>";
    retAnsSum = retAnsSum + "<table class=\"table-grid-view-claim\">";

    //retAnsDet = retAnsDet + "<div>";
    //retAnsDet = retAnsDet + "<a href=\"#\" id=\"aProcListDetE\" title=\"";
    //retAnsDet = retAnsDet + AlertMsgs.get("EXPAND");
    //retAnsDet = retAnsDet + "\" onclick=\"javascript:return expandDiv('ProcListDet');\" class=\"aExpand-sub\">";
    //retAnsDet = retAnsDet + AlertMsgs.get("PROCEDURE_DETAIL");
    //retAnsDet = retAnsDet + "</a>";
    //retAnsDet = retAnsDet + "<a href=\"#\" id=\"aProcListDetC\" title=\"";
    //retAnsDet = retAnsDet + AlertMsgs.get("COLLAPSE");
    //retAnsDet = retAnsDet + "\" style=\"display:none;\" onclick=\"javascript:return collapseDiv('ProcListDet');\" class=\"aCollapse-sub\">";
    //retAnsDet = retAnsDet + AlertMsgs.get("PROCEDURE_DETAIL");
    //retAnsDet = retAnsDet + "</a>";
    //retAnsDet = retAnsDet + "</div>";

    //retAnsDet = retAnsDet + "<div id=\"divProcListDetC\" style=\"display: none;\">";

    retAnsDet = retAnsDet + "<div>";
    retAnsDet = retAnsDet + "<table class=\"table-view-cpt\">";

    for (i in jsonData) {
        var d = jsonData[i];

        if (CLAIM_NO_PREV != d.CLAIM_NUMBER) {
            CLAIM_NO_PREV = d.CLAIM_NUMBER

            retAnsSum = retAnsSum + "<tr class=\"tr-claim-number\">";

            retAnsSum = retAnsSum + "<td colspan=\"12\">";
            retAnsSum = retAnsSum + AlertMsgs.get("CLAIM_NUMBER");
            retAnsSum = retAnsSum + " : ";
            retAnsSum = retAnsSum + d.CLAIM_NUMBER;
            retAnsSum = retAnsSum + "</td>";
            retAnsSum = retAnsSum + "</tr>";

            retAnsSum = retAnsSum + "<tr>";

            retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("DOS");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("DOS");
            retAnsSum = retAnsSum + "</td>";

            retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("PROCEDURE");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("PROCEDURE");
            retAnsSum = retAnsSum + "</td>";

            retAnsSum = retAnsSum + "<td style=\"width:15%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
            retAnsSum = retAnsSum + "</td>";

            retAnsSum = retAnsSum + "<td style=\"width:10%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("DIAGNOSIS");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("POINTING_DX");
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
            retAnsSum = retAnsSum + AlertMsgs.get("FAC_TYPE");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("FACILITY");
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

            //

            retAnsDet = retAnsDet + "<tr>";
            retAnsDet = retAnsDet + "<td colspan=\"4\" class=\"td-main-heading\">";
            retAnsDet = retAnsDet + AlertMsgs.get("CLAIM_NUMBER");
            retAnsDet = retAnsDet + " : ";
            retAnsDet = retAnsDet + d.CLAIM_NUMBER;
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "</tr>";

            DIAG_PREV = "";
        }
        retAnsSum = retAnsSum + "<tr>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("DOS");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.CPTDOS;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.CPT_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.CPT_CODE;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.UNIT;
        retAnsSum = retAnsSum + "</td>";

        retAnsSum = retAnsSum + "<td title=\"";
        retAnsSum = retAnsSum + d.DX_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.DX_CODE;
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
        retAnsSum = retAnsSum + d.POS_NAME_CODE;
        retAnsSum = retAnsSum + "\">";
        retAnsSum = retAnsSum + d.POS_CODE;
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
        retAnsSum = retAnsSum + AlertMsgs.get("DEL_PROC");
        retAnsSum = retAnsSum + "\">";

        if (d.CLAIM_DIAGNOSIS_CPT_ID == 0) {
            retAnsSum = retAnsSum + "<span class=\"spDelete\" title=\"&nbsp;\">";
            retAnsSum = retAnsSum + "</span>";
        }
        else {
            retAnsSum = retAnsSum + "<a href=\"#\" class=\"aDelete1\" onclick=\"javascript:return removeCpt('";
            retAnsSum = retAnsSum + d.CLAIM_DIAGNOSIS_CPT_ID
            retAnsSum = retAnsSum + "');\">";
            retAnsSum = retAnsSum + "</a>";
        }

        retAnsSum = retAnsSum + "</td>";
        retAnsSum = retAnsSum + "</tr>";

        //        

        if (DIAG_PREV != d.DX_NAME_CODE) {
            DIAG_PREV = d.DX_NAME_CODE

            retAnsDet = retAnsDet + "<tr>";
            retAnsDet = retAnsDet + "<td colspan=\"4\" class=\"td-heading\">";
            retAnsDet = retAnsDet + AlertMsgs.get("DIAGNOSIS");
            retAnsDet = retAnsDet + " : ";
            retAnsDet = retAnsDet + DIAG_PREV;
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "</tr>";
        }

        if (d.CLAIM_DIAGNOSIS_CPT_ID != 0) {
            retAnsDet = retAnsDet + "<tr>";
            retAnsDet = retAnsDet + "<td colspan=\"4\" class=\"td-proc\">";
            retAnsDet = retAnsDet + AlertMsgs.get("PROCEDURE");
            retAnsDet = retAnsDet + " : ";
            retAnsDet = retAnsDet + d.CPT_NAME_CODE;

            retAnsDet = retAnsDet + "<a href=\"#\" title= \"";
            retAnsDet = retAnsDet + AlertMsgs.get("DELETE");
            retAnsDet = retAnsDet + "\" class=\"aDelete1\" onclick=\"javascript:return removeCpt('";
            retAnsDet = retAnsDet + d.CLAIM_DIAGNOSIS_CPT_ID
            retAnsDet = retAnsDet + "');\">";
            retAnsDet = retAnsDet + "</a>";
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "</tr>";

            retAnsDet = retAnsDet + "<tr>";

            retAnsDet = retAnsDet + "<td style=\"width:20%\">";
            retAnsDet = retAnsDet + AlertMsgs.get("DOS");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td style=\"width:30%\">";
            retAnsDet = retAnsDet + d.CPTDOS;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "<td style=\"width:20%\">";
            retAnsDet = retAnsDet + AlertMsgs.get("FAC_TYPE");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td style=\"width:30%\">";
            retAnsDet = retAnsDet + d.POS_NAME_CODE;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "</tr>";

            retAnsDet = retAnsDet + "<tr>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("MODI1");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.MODI1_NAME_CODE;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("MODI2");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.MODI2_NAME_CODE;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "</tr>";


            retAnsDet = retAnsDet + "<tr>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("MODI3");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.MODI3_NAME_CODE;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("MODI4");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.MODI4_NAME_CODE;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "</tr>";

            retAnsDet = retAnsDet + "<tr>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("UNITS_PRO");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.UNIT;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("CHR_UNIT");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + d.CHARGE_PER_UNIT;
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "</tr>";

            retAnsDet = retAnsDet + "<tr>";

            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("CHR_TOT");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "<td colspan=\"3\">";
            retAnsDet = retAnsDet + (d.UNIT * d.CHARGE_PER_UNIT).toString();
            retAnsDet = retAnsDet + "</td>";

            retAnsDet = retAnsDet + "</tr>";
        }
        else {
            retAnsDet = retAnsDet + "<tr>";
            retAnsDet = retAnsDet + "<td>";
            retAnsDet = retAnsDet + AlertMsgs.get("NO_PROCEDURE");
            retAnsDet = retAnsDet + "</td>";
            retAnsDet = retAnsDet + "</tr>";
        }
    }

    retAnsSum = retAnsSum + "</table>";
    retAnsSum = retAnsSum + "</div>";

    retAnsDet = retAnsDet + "</table>";
    retAnsDet = retAnsDet + "</div>";

    retAnsDet = retAnsDet + "</div>";

    if (i != -1) {
        $("#divProcListSum").html(retAnsSum);
        $("#divProcListDetC").html(retAnsDet);
    }
    else {
        $("#divProcListSum").html("");
        $("#divProcListDetC").html("");
    }

    return false;
}

//remove cpt list
function removeCpt(ky) {
    if (!(confirm(AlertMsgs.get("DELETE_CONFIRM")))) {
        return false;
    }

    $("#divCptC").removeAttr("class");
    $("#divCptC").attr("class", "dv-claim-loading");

    var params = "{'pClaimCPTID' : '" + ky + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/RemoveCptAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            saveProSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> RemoveCptAjaxCall", req, status, errorObj);
        }
    });

    return false;
}

//save procedure
function validateSavePro() {
    if (canSubmit()) {
        //validation
        if (($("#DiagNameProID").val().length == 0) || ($("#DiagNameProID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("DX_NAME"), "DiagNamePro");
            return false;
        }

        if (($("#ProcCptNameID").val().length == 0) || ($("#ProcCptNameID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("PROC_ERROR"), "ProcCptName");
            return false;
        }

        if (($("#FacilityTypeNameID").val().length == 0) || ($("#FacilityTypeNameID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("FACILITY_TYPE"), "FacilityTypeName");
            return false;
        }

        //if (($("#txtChargePerUnit").val().length == 0) || ($("#txtChargePerUnit").val() == 0)) {
        //    alertErrMsg(AlertMsgs.get("BLOCK_CONFIRM"), "txtChargePerUnit");
        //    return false;
        //}

        if (($("#txtUnits").val().length == 0) || ($("#txtUnits").val() == 0)) {
            alertErrMsg(AlertMsgs.get("UNITS"), "txtUnits");
            return false;
        }

        //validate modifiers

        if ((($("#ModifierName4ID").val().length != 0) && ($("#ModifierName4ID").val() != 0)) && (($("#ModifierName3ID").val().length == 0 || $("#ModifierName3ID").val() == 0))) {
            $("#ModifierName4ID").val("");
            $("#ModifierName4").val("");
            alertErrMsg(AlertMsgs.get("MODI_ORDER_ERROR"), "ModifierName3");
            return false;
        }

        if ((($("#ModifierName3ID").val().length != 0) && ($("#ModifierName3ID").val() != 0)) && (($("#ModifierName2ID").val().length == 0 || $("#ModifierName2ID").val() == 0))) {
            $("#ModifierName3ID").val("");
            $("#ModifierName3").val("");
            alertErrMsg(AlertMsgs.get("MODI_ORDER_ERROR"), "ModifierName2");
            return false;
        }

        if ((($("#ModifierName2ID").val().length != 0) && ($("#ModifierName2ID").val() != 0)) && (($("#ModifierName1ID").val().length == 0 || $("#ModifierName1ID").val() == 0))) {
            $("#ModifierName2ID").val("");
            $("#ModifierName2").val("");
            alertErrMsg(AlertMsgs.get("MODI_ORDER_ERROR"), "ModifierName1");
            return false;
        }



        $("#divCptC").removeAttr("class");
        $("#divCptC").attr("class", "dv-claim-loading");

        //save
        var params = "{'pDiagnosisID' : '" + $("#DiagNameProID").val() + "' , 'pCPTID' : '" + $("#ProcCptNameID").val() + "' , 'pFacilityTypeID' : '" + $("#FacilityTypeNameID").val() + "', 'pDOS' : '" + $("#tdPatVisitDOS").html() + "', 'pUnit' : '" + $("#txtUnits").val() + "' , 'pChargePerUnit' : '" + $("#txtChargePerUnit").val() + "' , 'pModifier1' : '" + $("#ModifierName1ID").val() + "' , 'pModifier2' : '" + $("#ModifierName2ID").val() + "' , 'pModifier3' : '" + $("#ModifierName3ID").val() + "' , 'pModifier4' : '" + $("#ModifierName4ID").val() + "' }";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/SaveCPTAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                saveProSuccess(data, status);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("AssgnClaims_R --> SaveCPTAjaxCall", req, status, errorObj);

                $("#divCptC").removeAttr("class");
                $("#divCptC").attr("class", "dv-bdr");
            }
        });

        return true;
    }
    return false;
}

//save success or fail
function saveProSuccess(data, status) {

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    if (d.length == 0) {
                        reLoadPnlDiv("Cpt");
                    }
                    else {
                        alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "DiagName");
                        $("#divCptC").removeAttr("class");
                        $("#divCptC").attr("class", "dv-bdr");
                    }
                }
            }
        }
    }
    return false;
}

