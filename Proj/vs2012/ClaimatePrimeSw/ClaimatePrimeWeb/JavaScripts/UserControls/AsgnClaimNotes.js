$(document).ready(function () { });

function saveSuccessNotes(jsonData) {
    var retAns = "<table class=\"table-grid-view\">";

    retAns = retAns + "<tr>";
    retAns = retAns + "<td style=\"width:25%\" class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("NAME");
    retAns = retAns + "</td>";
    retAns = retAns + "<td style=\"width:75%\" class=\"td-gridhead1\">";
    retAns = retAns + AlertMsgs.get("NOTES");
    retAns = retAns + "</td>";
    retAns = retAns + "</tr>";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + d.NAME_CODE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COMMENTS;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
    }

    retAns = retAns + "</table>";

    $("#divNotesList").html(retAns);

    return false;
}