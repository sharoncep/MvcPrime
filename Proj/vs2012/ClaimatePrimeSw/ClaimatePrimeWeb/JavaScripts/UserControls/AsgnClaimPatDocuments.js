$(document).ready(function () {
});

function saveSuccessPatientDoc(jsonData) {
    var i = -1;
    var retAns = "";

    retAns = retAns + "<table class=\"table-grid-view\">";

    retAns = retAns + "<tr>";

    retAns = retAns + "<td class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("DOC_CATEGORY");
    retAns = retAns + "</td>";

    retAns = retAns + "<td class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("SERVICE_DATE");
    retAns = retAns + "</td>";

    retAns = retAns + "<td class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("TO_DATE");
    retAns = retAns + "</td>";

    retAns = retAns + "<td class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("DOCUMENT");
    retAns = retAns + "</td>";

    retAns = retAns + "</tr>";

    for (i in jsonData) {
        var d = jsonData[i];



        retAns = retAns + "<tr>";

        retAns = retAns + "<td>";
        retAns = retAns + d.NAME_CODE;
        retAns = retAns + "</td>";

        retAns = retAns + "<td>";
        retAns = retAns + d.SERVICE_DATE;
        retAns = retAns + "</td>";

        retAns = retAns + "<td>";
        retAns = retAns + d.TO_DATE;
        retAns = retAns + "</td>";

        retAns = retAns + "<td class=\"td-image\">";
        retAns = retAns + " <ul class=\"ul_imgEnlarge\">";
        retAns = retAns + "<li class=\"imgPhoto\">";
        retAns = retAns + " <img id=\"imgPhoto\" src=\"";

        if (d.DOC_SRC_PREVIEW == d.DOC_SRC) {
            retAns = retAns + d.DOC_SRC;
            retAns = retAns + "\" alt=\"\" style=\"width: 60px; height: 60px;\" onclick=\"javascript:return enlargePhoto(this);\" title=\" ";
            retAns = retAns + AlertMsgs.get("ENLARGE_CLICK");
            retAns = retAns + "\" ";
        }
        else {
            retAns = retAns + d.DOC_SRC_PREVIEW;
            retAns = retAns + "\" alt=\"\" style=\"width: 60px; height: 60px;\" onclick=\"javascript:return printFile('";
            retAns = retAns + d.DOC_SRC;
            retAns = retAns + "');\" title=\" ";
            retAns = retAns + AlertMsgs.get("PRINT_CLICK");
            retAns = retAns + "\" ";
        }

        retAns = retAns + "/>";
        retAns = retAns + "</li></ul></td>";

        retAns = retAns + "</tr>";
    }

    retAns = retAns + "</table>";

    if (i == -1) {
        retAns = "<div class=\"dv-norec1\">";
        retAns = retAns + AlertMsgs.get("NO_REC");
        retAns = retAns + "</div>";
    }

    $("#divPatientDocC").html(retAns);

    return false;
}