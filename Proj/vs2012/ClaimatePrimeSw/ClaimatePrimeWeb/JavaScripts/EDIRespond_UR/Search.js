$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);
    setDatePickerFromTo("DOSFrom", false, "DOSTo", false);
    loadSearchResult();
});
function loadSearchResult() {
    loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);

    var params = "{'pSearchName' : '" + $("#SearchName").val() + "', 'pDateFrom' : '" + $("#DateFrom").val() + "', 'pDateTo' : '" + $("#DateTo").val() + "', 'pDOSFrom' : '" + $("#DOSFrom").val() + "', 'pDOSTo' : '" + $("#DOSTo").val() + "', 'pStartBy' : '" + $("#StartBy").val() + "', 'pOrderByField' : '" + $("#OrderByField").val() + "', 'pOrderByDirection' : '" + $("#OrderByDirection").val() + "', 'pCurrPageNumber' : '" + $("#CurrPageNumber").val() + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            searchSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("EDIRespond_UR --> SearchAjaxCall", req, status, errorObj);
        }
    });

    return false;
}
function searchSuccess(data, status) {
    var hml = $("#divSearchResult").html();
    if (hml.length == 0) {

        hml = hml + "<table class=\"table-grid\">";
        hml = hml + "<tr>";

        hml = hml + "<td width=\"50%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "CreatedOn") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('CreatedOn', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('CreatedOn', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('CreatedOn', 'A');\">";
        }
        hml = hml + AlertMsgs.get("CREATED_ON");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"30%\" class=\"td-gridhead\">";
        hml = hml + "&nbsp;";
        hml = hml + "</td>";

        hml = hml + "</tr>";
    }
    else {
        hml = hml.replace(new RegExp("</table>", "g"), "");
    }

    var retAns = "";
    var i = -1;

    if (data != null) {

        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[i];

                    retAns = retAns + "<tr>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";

                    retAns = retAns + "<a href=\"#\" rel=\"control_tile\" class=\"aEdit\" onclick=\"javascript:return setEdit('";
                    retAns = retAns + d.ID;
                    retAns = retAns + "');\">";
                    retAns = retAns + AlertMsgs.get("EDIT");
                    retAns = retAns + "</a>";

                    retAns = retAns + "<a href=\"#\" onclick=\"javascript:return printFile('";
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "')\" rel=\"control_tile\" title =\"X12\" class =\"aDownload1\">";
                    retAns = retAns + AlertMsgs.get("X12");
                    retAns = retAns + "</a>";

                    retAns = retAns + "<a href=\"#\" onclick=\"javascript:return printFile('";
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "')\" rel=\"control_tile\" title =\"Ref\" class =\"aDownload1\">";
                    retAns = retAns + AlertMsgs.get("REF");
                    retAns = retAns + "</a>";

                    retAns = retAns + "</td>";

                    retAns = retAns + "</tr>";
                }

                retAns = retAns + "</table>";
            }
        }
    }

    i = parseInt(i, 10) + 1;

    if (parseInt(i, 10) > 0) {
        $("#divSearchResult").html(hml + "" + retAns);

        if (parseInt(i, 10) < parseInt(_SearchRecordPerPage, 10)) {
            $("#aSearchResult").fadeOut();
        }
        else {
            $("#aSearchResult").fadeIn();
        }
    }
    else {
        $("#aSearchResult").fadeOut();
    }

    if ($("#divSearchResult").html().length <= 0) {
        hml = "";
        hml = hml + "<div class=\"dv-norec\">";
        hml = hml + AlertMsgs.get("NO_REC");
        hml = hml + "</div>";
        $("#divSearchResult").html(hml);
    }
    hideSearchLoading();

}