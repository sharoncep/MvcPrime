$(document).ready(function () { });

function saveSuccessStatus(jsonData) {

    var retAnsStat = "";

    retAnsStat = retAnsStat + "<table class=\"table-grid-view-claim\">";
    retAnsStat = retAnsStat + "<tr>";
    retAnsStat = retAnsStat + "<td class=\"td-grid-subhead-claim\" colspan=\"7\">";
    retAnsStat = retAnsStat + AlertMsgs.get("TAT");

    retAnsStat = retAnsStat + "</td>";
    retAnsStat = retAnsStat + "</tr>";

    retAnsStat = retAnsStat + "<tr>";
    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("CLAIM_STATUS");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("ASSIGNEE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("START_DATE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("END_DATE");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("DURATION");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("NOTES");

    retAnsStat = retAnsStat + "</td>";

    retAnsStat = retAnsStat + "<td class=\"td-gridhead-claim\">";
    retAnsStat = retAnsStat + AlertMsgs.get("EDI_FILE");
    retAnsStat = retAnsStat + "</td>";


    retAnsStat = retAnsStat + "</tr>";
    for (i in jsonData) {
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


    $("#divClaimProcessStatus").html(retAnsStat);

    return false;
}