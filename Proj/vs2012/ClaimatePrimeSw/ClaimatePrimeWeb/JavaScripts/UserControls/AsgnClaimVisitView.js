$(document).ready(function () {
    expandPnlDiv("Visit");
});

function saveSuccessVisitView(jsonData) {
    
    var retAns = "";
    var retAnsDoc = "";
    var retStat = "";
    for (i in jsonData) {
        var d = jsonData[i];
       
        //

        $("#embDrNote").removeAttr("src");
        $("#embDrNote").attr("src", d.TMP_URL_DR_NOTE);

        $("#embSupBill").removeAttr("src");
        $("#embSupBill").attr("src", d.TMP_URL_SUP_BILL);

        //

        retAns = retAns + "<table class=\"table-view-claim\">";
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
        retAns = retAns + AlertMsgs.get("PATIENT_VISIT_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PATIENT_VISIT_ID;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("ILLNESS_INDI_DATE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.ILLNESS_INDICATOR_DATE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FACILITY_TYPE_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FACILITY_TYPE;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FACILITY_DONE_NAME1");
        retAns = retAns + "</td>";
        retAns = retAns + "<td colspan=\"3\">";
        retAns = retAns + d.FACILITY_DONE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"display:none\">";
        retAns = retAns + "<input type='text' style='display:none;' id='FacilityDoneID' value ="

        if (d.FACILITY_DONE_ID == null) {
            retAns = retAns + "0";
        }
        else {
            retAns = retAns + d.FACILITY_DONE_ID;
        }
        retAns = retAns + "></input>";
        retAns = retAns + "</td>";

        retAns = retAns + "<tr>";

        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CASE_DESC1");
        retAns = retAns + "</td>";
        retAns = retAns + "<td colspan=\"3\">";
        retAns = retAns + d.PATIENT_VISIT_DESC;
        retAns = retAns + "</td>";

        retAns = retAns + "</tr>";

        retAns = retAns + "</table>";

        retAnsDoc = retAnsDoc + "<table class=\"table-grid-view\">";

        retAnsDoc = retAnsDoc + "<tr>";

        retAnsDoc = retAnsDoc + "<td class=\"td-gridhead-claim\">";
        retAnsDoc = retAnsDoc + AlertMsgs.get("DOC_NOTES");
        retAnsDoc = retAnsDoc + "</td>";

        retAnsDoc = retAnsDoc + "</tr>";

        retAnsDoc = retAnsDoc + "<tr>";

        retAnsDoc = retAnsDoc + "<td class=\"td-lists\">";
        retAnsDoc = retAnsDoc + "<img src=\"";
        retAnsDoc = retAnsDoc + d.IMG_SRC_DR_NOTE;
        retAnsDoc = retAnsDoc + "\" alt=\"\" style=\"width: 60px; height: 60px; cursor:pointer;\" onclick=\"return printFile('";
        retAnsDoc = retAnsDoc + d.IMG_PRINT_SRC_DR_NOTE
        retAnsDoc = retAnsDoc + "')\" title=\"";
        retAnsDoc = retAnsDoc + AlertMsgs.get("PRINT_CLICK");
        retAnsDoc = retAnsDoc + "\" />";
        retAnsDoc = retAnsDoc + "</td>";

        retAnsDoc = retAnsDoc + "</tr>";

        retAnsDoc = retAnsDoc + "<tr>";

        retAnsDoc = retAnsDoc + "<td class=\"td-gridhead-claim\">";
        retAnsDoc = retAnsDoc + AlertMsgs.get("SUPERBILLS");
        retAnsDoc = retAnsDoc + "</td>";

        retAnsDoc = retAnsDoc + "</tr>";
        retAnsDoc = retAnsDoc + "<tr>";
        retAnsDoc = retAnsDoc + "<td class=\"td-lists\">";
        retAnsDoc = retAnsDoc + "<img src=\"";
        retAnsDoc = retAnsDoc + d.IMG_SRC_SUP_BILL;
        retAnsDoc = retAnsDoc + "\" alt=\"\" style=\"width: 60px; height: 60px; cursor:pointer;\" onclick=\"return printFile('";
        retAnsDoc = retAnsDoc + d.IMG_PRINT_SRC_SUP_BILL
        retAnsDoc = retAnsDoc + "')\" title=\"";
        retAnsDoc = retAnsDoc + AlertMsgs.get("PRINT_CLICK");
        retAnsDoc = retAnsDoc + "\" />";
        retAnsDoc = retAnsDoc + "</td>";

        retAnsDoc = retAnsDoc + "</tr>";
        retAnsDoc = retAnsDoc + "</table>";

        //Fill Div Claim Status

        retStat = retStat + "<table class=\"table-view-claim\">";
        retStat = retStat + "<tr>";
        retStat = retStat + "<td style=\"width:20%\">";
        retStat = retStat + "Claim Status";
        retStat = retStat + "</td>";
        retStat = retStat + "<td style=\"width:30%\">";
        retStat = retStat + d.CLAIM_STATUS_NAME;
        retStat = retStat + "</td>";
        retStat = retStat + "<td style=\"width:20%\">";
        retStat = retStat + "Assigned To";
        retStat = retStat + "</td>";
        retStat = retStat + "<td style=\"width:30%\">";
        retStat = retStat + d.ASSIGNED_TO_NAME;
        retStat = retStat + "</td>";
        retStat = retStat + "</tr>";
        retStat = retStat + "<tr>";
        retStat = retStat + "<td>";
        retStat = retStat + "Target BA User";
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + d.TARGET_BA_USER;
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + "Target QA User";
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + d.TARGET_QA_USER;
        retStat = retStat + "</td>";
        retStat = retStat + "</tr>";
        retStat = retStat + "<tr>";
        retStat = retStat + "<td>";
        retStat = retStat + "Target EA User";
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + d.TARGET_EA_USER;
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + "Visit Complexity";
        retStat = retStat + "</td>";
        retStat = retStat + "<td>";
        retStat = retStat + d.PATIENT_VISIT_COMPLEXITY;
        retStat = retStat + "</td>";
        retStat = retStat + "</tr>";
        retStat = retStat + "</table>";
    }
    $("#divVisitStatus").html(retStat);
    $("#divVisitC").html(retAns);
    $("#divVisitdocC").html(retAnsDoc);


    return false;
}