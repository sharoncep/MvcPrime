var retAns = "";
var CLAIM_NO_PREV = -1;

retAns = retAns + "<div class=\"dv-subheading-cpt\">";
retAns = retAns + AlertMsgs.get("PROCEDURE_LIST");
retAns = retAns + "</div>";

retAns = retAns + "<div>";
retAns = retAns + "<table class=\"table-grid-view-claim\">";

for (i in jsonData) {
    var d = jsonData[i];

    if (CLAIM_NO_PREV != d.CLAIM_NUMBER) {
        CLAIM_NO_PREV = d.CLAIM_NUMBER

        retAns = retAns + "<tr class=\"tr-claim-number\">";
        retAns = retAns + "<td colspan=\"2\">";
        retAns = retAns + AlertMsgs.get("CLAIM_NUMBER");
        retAns = retAns + " : ";
        retAns = retAns + d.CLAIM_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

    }

    retAns = retAns + "<tr>";
    retAns = retAns + "<td title=\"";
    retAns = retAns + d.NAME_CODE;
    retAns = retAns + "\">";
    retAns = retAns + d.DX_CODE;
    retAns = retAns + "</td>";

    retAns = retAns + "<td title=\"";
    retAns = retAns + AlertMsgs.get("REMOVE");
    retAns = retAns + "\">";

    retAns = retAns + "<a id=\"";
    retAns = retAns + d.CLAIM_DIAGNOSIS_ID
    retAns = retAns + "\" ";
    retAns = retAns + "href=\"#\" class=\"aDelete1\" onclick=\"javascript:return removeDx(this);\">";
    retAns = retAns + "</a>";

    retAns = retAns + "</td>";


}

retAns = retAns + "</table>";
retAns = retAns + "</div>";


$("#tdDxList").html(retAns);