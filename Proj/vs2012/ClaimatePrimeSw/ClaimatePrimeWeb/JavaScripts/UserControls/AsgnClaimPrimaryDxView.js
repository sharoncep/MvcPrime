$(document).ready(function () {

});

function saveSuccessPrimaryDxView(jsonData) {

    var i = -1;
    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<table class=\"table-view-claim\">";
        retAns = retAns + " <tr>";
        retAns = retAns + "<td colspan=\"4\" class=\"td-heading\">";
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("PRIMARY_DX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 80%\" >";
        if (d.PRIMARY_DX_NAME != null) {
            retAns = retAns + d.PRIMARY_DX_NAME;
        }
        retAns = retAns + "</td>";
        retAns = retAns + "</table>";

    }

    if (i == -1) {
        retAns = "<div class=\"dv-norec1\">";
        retAns = retAns + AlertMsgs.get("NO_REC");
        retAns = retAns + "</div>";
    }

    $("#divDxprimaryC").html(retAns);

    return false;
}
