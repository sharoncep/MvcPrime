$(document).ready(function () {
});

function saveSuccessPrevVisit(jsonData) {
    var retAns = "";

    for (var i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<div class=\"dv-bdr-visit\">";
        retAns = retAns + "<div>"; // Dates expand / collapse
        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "E\" title=\"";
        retAns = retAns + AlertMsgs.get("EXPAND");
        retAns = retAns + "\" onclick=\"javascript:return expandPnlDiv('PrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "');\" class=\"aExpand-sub\">";
        retAns = retAns + d.DOS;
        retAns = retAns + "</a>";
        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "C\" title=\"";
        retAns = retAns + AlertMsgs.get("COLLAPSE");
        retAns = retAns + "\" onclick=\"javascript:return collapsePnlDiv('PrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "');\" style=\"display:none;\" class=\"aCollapse-sub\">";
        retAns = retAns + d.DOS;
        retAns = retAns + "</a>";
        retAns = retAns + "</div>";

        retAns = retAns + "<div id=\"divPrevVisitsDOS_";    // Outer div for Summary, Detail & Claim Status begins
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "C\" style=\"display:none;\" title=\"\">";



        retAns = retAns + "<div id=\"divPrevVisitsDOS_";    // Summary Data
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_Sum\">";
        retAns = retAns + "</div>";

        retAns = retAns + "<div>";    // Ourter div for Detail begins

        retAns = retAns + "<div>";      // Detail expand / collapse
        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_DetE\" title=\"";
        retAns = retAns + AlertMsgs.get("EXPAND");
        retAns = retAns + "\" style=\"display:none;\" onclick=\"javascript:return expandPnlDiv('PrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_Det');\" class=\"aExpand-sub1\">";
        retAns = retAns + AlertMsgs.get("DETAILED_VIEW");
        retAns = retAns + "</a>";
        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_DetC\" title=\"";
        retAns = retAns + AlertMsgs.get("COLLAPSE");
        retAns = retAns + "\" onclick=\"javascript:return collapsePnlDiv('PrevVisitsDOS_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_Det');\" style=\"display:none;\" class=\"aCollapse-sub1\">";
        retAns = retAns + AlertMsgs.get("DETAILED_VIEW");
        retAns = retAns + "</a>";
        retAns = retAns + "</div>";

        retAns = retAns + "<div id=\"divPrevVisitsDOS_";    // Detail data
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "_DetC\" style=\"display:none;\">";
        retAns = retAns + "</div>";

        retAns = retAns + "</div>";     // Ourter div for Detail ends

        retAns = retAns + "<div>";    // Ourter div for Claim Status begins

        retAns = retAns + "<div>";      // Claim Status expand / clollapse
        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsStatus_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "E\" title=\"";
        retAns = retAns + AlertMsgs.get("EXPAND");
        retAns = retAns + "\" onclick=\"javascript:return expandPnlDiv('PrevVisitsStatus_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "');\" class=\"aExpand-sub1\">";
        retAns = retAns + AlertMsgs.get("CLAIM_STATUS");
        retAns = retAns + "</a>";


        retAns = retAns + "<a href=\"#\" id=\"aPrevVisitsStatus_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "C\" title=\"";
        retAns = retAns + AlertMsgs.get("COLLAPSE");
        retAns = retAns + "\" onclick=\"javascript:return collapsePnlDiv('PrevVisitsStatus_";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "');\" style=\"display:none;\" class=\"aCollapse-sub1\">";
        retAns = retAns + AlertMsgs.get("CLAIM_STATUS");
        retAns = retAns + "</a>";

        retAns = retAns + "</div>";

        retAns = retAns + "<div id=\"divPrevVisitsStatus_";     // Patient Visit Current Status Data & Claim Status Data begins
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "C\" style=\"display:none;\">";

        retAns = retAns + "<div class=\"dv-wrap-claim\">";      // Patient Visit Current Status Data
        retAns = retAns + "<table class=\"table-view-claim-stat\">";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width:20%\">";
        retAns = retAns + "Claim Status";
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:30%\">";
        retAns = retAns + d.CLAIM_STATUS;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:20%\">";
        retAns = retAns + "Assigned To";
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width:30%\">";
        retAns = retAns + d.ASSIGNED_TO;
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
        retAns = retAns + "</div>";

        retAns = retAns + "<div id=\"divPrevVisitsStatus_";     // Claim Status Data
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "Data\">";
        retAns = retAns + "</div>";

        retAns = retAns + "</div>";     // Patient Visit Current Status Data & Claim Status Data ends

        retAns = retAns + "</div>";     // Ourter div for Clam Status ends
        retAns = retAns + "</div>";    // Outer div for Summary, Detail & Claim Status ends
        retAns = retAns + "</div>";
    }

    $("#divPrevVisitsC").html(retAns);

    return false;
}

function saveSuccessVisitDetails(jsonData, ky) {
    var retAns = "";
    if (jsonData != null) {

        var i = -1;
        var retAnsSum = "";
        var retAnsDet = "";
        var CLAIM_NO_PREV = -1;
        var DIAG_PREV = "";

        retAnsSum = retAnsSum + "<div>";
        retAnsSum = retAnsSum + "<table class=\"table-grid-view-claim\">";

        retAnsDet = retAnsDet + "<div>";
        retAnsDet = retAnsDet + "<table class=\"table-view-cpt\">";


        for (i in jsonData) {
            var d = jsonData[i];

            if (CLAIM_NO_PREV != d.CLAIM_NUMBER) {
                CLAIM_NO_PREV = d.CLAIM_NUMBER

                retAnsSum = retAnsSum + "<tr class=\"tr-claim-number\">";

                retAnsSum = retAnsSum + "<td colspan=\"11\">";
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
                retAnsDet = retAnsDet + ": ";
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

    }

    $("#div" + ky + "_Sum").html(retAnsSum);
    $("#div" + ky + "_DetC").html(retAnsDet);

    if (i != -1) {
        $("#div" + ky + "_Sum").show();
        $("#a" + ky + "_DetE").show();
    }

    return false;
}

function saveSuccessPrevStatus(jsonData, ky) {
    var retAnsStat = "";

    retAnsStat = retAnsStat + "<table class=\"table-grid-view-claim\">";

    retAnsStat = retAnsStat + "<tr>";
    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:15%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("CLAIM_STATUS");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:20%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("ASSIGNEE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:10%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("START_DATE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:10%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("END_DATE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:10%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("DURATION");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:25%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("NOTES");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\" style=\"width:10%\">";
    retAnsStat = retAnsStat + AlertMsgs.get("EDI_FILE");
    retAnsStat = retAnsStat + "</td>";



    retAnsStat = retAnsStat + "</tr>";
    for (var i in jsonData) {
        var d = jsonData[i];

        retAnsStat = retAnsStat + "<tr>";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + d.CLAIM_STATUS_NAME
        retAnsStat = retAnsStat + "</td>";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + d.ASSIGNED_TO
        retAnsStat = retAnsStat + "</td>";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + d.STATUS_START_ON
        retAnsStat = retAnsStat + "</td>";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + d.STATUS_END_ON
        retAnsStat = retAnsStat + "</td>";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + d.DURATION_MINS
        retAnsStat = retAnsStat + "</td>";

        //retAnsStat = retAnsStat + "<td  class=\"tooltip\"  title=\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ...Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ...\">";

        retAnsStat = retAnsStat + "<td>";
        retAnsStat = retAnsStat + "<div class=\"tooltip\">";
        retAnsStat = retAnsStat + d.COMMENT
        retAnsStat = retAnsStat + "<span>";
        retAnsStat = retAnsStat + "<div class=\"dv-img\">";
        retAnsStat = retAnsStat + "</div>";
        retAnsStat = retAnsStat + d.COMMENT;
        retAnsStat = retAnsStat + "</span>";
        retAnsStat = retAnsStat + "</div>";


        retAnsStat = retAnsStat + "</td>";

        retAnsStat = retAnsStat + "<td class=\"td-dl\">";

        if ((d.IMG_PRINT_SRC_REF_FILE.length == 0) && (d.IMG_PRINT_X12_FILE.length == 0)) {
            retAnsStat = retAnsStat + "&nbsp;";
        }
        else {
            
            if (d.IMG_PRINT_SRC_REF_FILE.length > 0) {
                retAnsStat = retAnsStat + "<a href=\"#\" onclick=\"javascript:return printFile('";
                retAnsStat = retAnsStat + d.IMG_PRINT_SRC_REF_FILE;
                retAnsStat = retAnsStat + "');\" title=\" ";
                retAnsStat = retAnsStat + AlertMsgs.get("REF");
                retAnsStat = retAnsStat + "\" class=\"aButton-download\">";
                retAnsStat = retAnsStat + "</a>";
            }

            if (d.IMG_PRINT_X12_FILE.length > 0) {
                retAnsStat = retAnsStat + "<a href=\"#\" onclick=\"javascript:return printFile('";
                retAnsStat = retAnsStat + d.IMG_PRINT_X12_FILE;
                retAnsStat = retAnsStat + "');\" title=\" ";
                retAnsStat = retAnsStat + AlertMsgs.get("X12");
                retAnsStat = retAnsStat + "\" class=\"aButton-download\">";
                retAnsStat = retAnsStat + "</a>";
            }
            retAnsStat = retAnsStat + d.EDI_CREATED_ON;
        }

        retAnsStat = retAnsStat + "</td>";
        retAnsStat = retAnsStat + "</tr>";
    }

    retAnsStat = retAnsStat + "</table>";

    $("#div" + ky + "Data").html(retAnsStat);

    return false;
}