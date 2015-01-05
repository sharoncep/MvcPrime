$(document).ready(function () { });

function saveSuccessDxView(jsonData) {

    var i = -1;
    var retAns = "";
    var CLAIM_NO_PREV = -1;



    retAns = retAns + "<div>";
    retAns = retAns + "<table class=\"table-grid-view\">";

    for (i in jsonData) {
        var d = jsonData[i];

        if (CLAIM_NO_PREV != d.CLAIM_NUMBER) {
            CLAIM_NO_PREV = d.CLAIM_NUMBER

            retAns = retAns + "<tr class=\"tr-claim-number1\">";
            retAns = retAns + "<td>";
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
        retAns = retAns + d.NAME_CODE;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

    }

    retAns = retAns + "</table>";
    retAns = retAns + "</div>";

    if (i == -1) {
        retAns = "<div class=\"dv-norec1\">";
        retAns = retAns + AlertMsgs.get("NO_REC");
        retAns = retAns + "</div>";
    }

    $("#divSelDxList").html(retAns);
    return false;
}

function descTypeClickDx(obj) {
    var preVal = $("#txtDescTypeDx").val();
    var curVal = $(obj).val();

    if (preVal != curVal) {
        $("#divDxC").removeAttr("class");
        $("#divDxC").attr("class", "dv-claim-loading");

        $("#txtDescTypeDx").val(curVal);

        reLoadPnlDiv("Dx");
    }

    return true;
}