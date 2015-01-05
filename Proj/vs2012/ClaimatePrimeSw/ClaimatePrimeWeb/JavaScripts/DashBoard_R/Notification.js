$(document).ready(function () {
    loadSearchResult();
});
function loadSearchResult() {
    loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);

    var params = "{'pSearchName' : '" + $("#SearchName").val() + "', 'pDateFrom' : '" + $("#DateFrom").val() + "', 'pDateTo' : '" + $("#DateTo").val() + "', 'pStartBy' : '" + $("#StartBy").val() + "', 'pOrderByField' : '" + $("#OrderByField").val() + "', 'pOrderByDirection' : '" + $("#OrderByDirection").val() + "', 'pCurrPageNumber' : '" + $("#CurrPageNumber").val() + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallNotification/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            searchSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashboardNotification --> SearchAjaxCall", req, status, errorObj);
        }
    });

    return false;
}
function searchSuccess(data, status) {
    var hml = $("#divSearchResult").html();
    if (hml.length == 0) {

        hml = hml + "<table class=\"table-grid-view\">";
        hml = hml + "<tr>";

        //hml = hml + "<td width=\"10%\" class=\"td-gridhead\">";

        //hml = hml + AlertMsgs.get("SL_NO");

        //hml = hml + "</td>";

        hml = hml + "<td width=\"25%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "Email") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('Email', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('Email', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('Email', 'A');\">";
        }
        hml = hml + AlertMsgs.get("EMAIL");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "LastName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('LastName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('LastName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('LastName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("LASTNAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "FirstName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FirstName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FirstName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('FirstName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("FNAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "MiddleName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('MiddleName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('MiddleName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('MiddleName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("MID_NAME");
        hml = hml + "</a>";
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
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP4;
                    retAns = retAns + "</td>";

                    retAns = retAns + "</tr>";
                    //alert(retAns);
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