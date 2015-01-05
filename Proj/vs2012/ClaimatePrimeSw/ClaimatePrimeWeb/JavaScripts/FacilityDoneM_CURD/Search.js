$(document).ready(function () {
    loadSearchResult();

    _AlertMsgID = "SearchName";
    $("#" + _AlertMsgID).focus();
});

function loadSearchResult() {
    if (($('#chkHasRec').is(':checked'))) {
        loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);

        var params = "{'pSearchName' : '" + $("#SearchName").val() + "', 'pStartBy' : '" + $("#StartBy").val() + "', 'pOrderByField' : '" + $("#OrderByField").val() + "', 'pOrderByDirection' : '" + $("#OrderByDirection").val() + "', 'pCurrPageNumber' : '" + $("#CurrPageNumber").val() + "'}";   // if no params need to use "{}"
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
                ajaxCallError("FacilityDoneM_CUR --> SearchAjaxCall", req, status, errorObj);
            }
        });
    }

    return false;
}

function searchSuccess(data, status) {
    var hml = $("#divSearchResult").html();

    if (hml.length == 0) {
        hml = hml + "<table class=\"table-grid\">";
        hml = hml + "<tr>";

        hml = hml + "<td width=\"40%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "FacilityDoneName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FacilityDoneName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FacilityDoneName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('FacilityDoneName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("NAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"40%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "FacilityDoneCode") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FacilityDoneCode', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('FacilityDoneCode', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('FacilityDoneCode', 'A');\">";
        }
        hml = hml + AlertMsgs.get("CODE");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"40%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "NPI") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('NPI', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('NPI', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('NPI', 'A');\">";
        }
        hml = hml + AlertMsgs.get("NPI");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"20%\" class=\"td-gridhead\">";
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

                    retAns = retAns + "<tr id=\"trSerRes";
                    retAns = retAns + d.ID;
                    retAns = retAns + "\" ";
                    if (!(d.IsActive)) {
                        retAns = retAns + "rel=\"rel-block\" ";
                    }
                    retAns = retAns + ">";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    if (d.DISP3 != null) {
                        retAns = retAns + d.DISP3;
                        retAns = retAns + "</td>";
                    }
                    else {
                        retAns = retAns + "</td>";
                    }

                    retAns = retAns + "<td>";
                    retAns = retAns + "<a id=\"aSerRes";
                    retAns = retAns + d.ID;
                    retAns = retAns + "<td>";
                    retAns = retAns + "<a href=\"#\" rel=\"control_tile\" class=\"aEdit\" onclick=\"javascript:return setEdit('";
                    retAns = retAns + d.ID;
                    retAns = retAns + "');\">";
                    retAns = retAns + AlertMsgs.get("EDIT");
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

    hideSearchLoading();
}


