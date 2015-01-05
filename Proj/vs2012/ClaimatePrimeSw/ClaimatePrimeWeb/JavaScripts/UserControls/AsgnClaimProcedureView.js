$(document).ready(function () {

});

function saveSuccessCPTView(jsonData) {


    var retAnsSum = "";
    var retAnsDet = "";
    var CLAIM_NO_PREV = -1;
    var DIAG_PREV = "";
    var i = -1;

    retAnsSum = retAnsSum + "<div>";
    retAnsSum = retAnsSum + "<table class=\"table-grid-view-claim\">";

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

            retAnsSum = retAnsSum + "<td style=\"width:9%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("UNITS_PRO");
            retAnsSum = retAnsSum + "</td>";

            retAnsSum = retAnsSum + "<td style=\"width:13%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("DIAGNOSIS");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("POINTING_DX");
            retAnsSum = retAnsSum + "</td>";

            retAnsSum = retAnsSum + "<td style=\"width:7%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("MODI1");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("M1");
            retAnsSum = retAnsSum + "</td>";
            retAnsSum = retAnsSum + "<td style=\"width:7%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("MODI2");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("M2");
            retAnsSum = retAnsSum + "</td>";
            retAnsSum = retAnsSum + "<td style=\"width:7%;\" class=\"td-gridhead-claim\" title=\"";
            retAnsSum = retAnsSum + AlertMsgs.get("MODI3");
            retAnsSum = retAnsSum + "\">";
            retAnsSum = retAnsSum + AlertMsgs.get("M3");
            retAnsSum = retAnsSum + "</td>";
            retAnsSum = retAnsSum + "<td style=\"width:7%;\" class=\"td-gridhead-claim\" title=\"";
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
            //retAnsSum = retAnsSum + "<td style=\"width:15%;\" class=\"td-gridhead-claim\">";
            //retAnsSum = retAnsSum + "&nbsp;";
            //retAnsSum = retAnsSum + "</td>";
            retAnsSum = retAnsSum + "</tr>";

            //

            retAnsDet = retAnsDet + "<tr>";
            retAnsDet = retAnsDet + "<td colspan=\"11\" class=\"td-main-heading\">";
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

            //retAnsDet = retAnsDet + "<a href=\"#\" title= \"";
            //retAnsDet = retAnsDet + AlertMsgs.get("DELETE");
            //retAnsDet = retAnsDet + "\" class=\"aDelete1\" onclick=\"javascript:return removeCpt('";
            //retAnsDet = retAnsDet + d.CLAIM_DIAGNOSIS_CPT_ID
            //retAnsDet = retAnsDet + "');\">";
            //retAnsDet = retAnsDet + "</a>";
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
    }

    retAnsSum = retAnsSum + "</table>";
    retAnsSum = retAnsSum + "</div>";

    retAnsDet = retAnsDet + "</table>";
    retAnsDet = retAnsDet + "</div>";

    if (i != -1) {
        $("#divProcListSum").html(retAnsSum);
        $("#divProcListDetC").html(retAnsDet);
    }

    return false;

    $("#divCptC").html(retAnsSum);

    return false;
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
