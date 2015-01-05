$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);
    loadSearchResult();
});
function loadSearchResult() {
    loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);

    var params = "{'pSearchName' : '" + $("#SearchName").val() + "', 'pDateFrom' : '" + $("#DateFrom").val() + "', 'pDateTo' : '" + $("#DateTo").val() + "', 'pStartBy' : '" + $("#StartBy").val() + "', 'pOrderByField' : '" + $("#OrderByField").val() + "', 'pOrderByDirection' : '" + $("#OrderByDirection").val() + "', 'pCurrPageNumber' : '" + $("#CurrPageNumber").val() + "'}";   // if no params need to use "{}"
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
            ajaxCallError("Visit_CR --> SearchAjaxCall", req, status, errorObj);
        }
    });

    return false;
}

function searchSuccess(data, status) {
    var hml = $("#divSearchResult").html();

    if (hml.length == 0) {
        hml = hml + "<table class=\"table-grid\">";
        hml = hml + "<tr>";

        hml = hml + "<td width=\"20%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "DOS") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('DOS', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('DOS', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('DOS', 'A');\">";
        }
        hml = hml + AlertMsgs.get("DOS");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"65%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "PatientVisitID") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatientVisitID', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatientVisitID', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('PatientVisitID', 'A');\">";
        }
        hml = hml + AlertMsgs.get("PATIENT_VISIT_ID");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"10%\" class=\"td-gridhead\">";
        hml = hml + "&nbsp;";
        hml = hml + "</td>";

        hml = hml + " <td width=\"5%\" class=\"td-gridhead\">";
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
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.ID;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";

                    if (d.IsActive) {
                        retAns = retAns + "&nbsp;";
                    }
                    else {
                        retAns = retAns + "<a id=\"aSerRes";
                        retAns = retAns + d.ID;
                        retAns = retAns + "\" href=\"#\" rel=\"control_tile\" ";
                        retAns = retAns + "class=\"aUnblock\" onclick=\"javascript:return valBlockUnBlock('";
                        retAns = retAns + d.ID;
                        retAns = retAns + "');\">";
                        retAns = retAns + AlertMsgs.get("UN_BLOCK");
                        retAns = retAns + "</a>";

                    }

                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + "<a href=\"#\" class=\"aView\" rel=\"control_tile\" onclick=\"javascript:return setEdit('";
                    retAns = retAns + d.ID;
                    retAns = retAns + "');\">";
                    retAns = retAns + AlertMsgs.get("VIEW");
                    retAns = retAns + "</a>";
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

    hideSearchLoading();
}

function valBlockUnBlock(id) {

    if (confirm(AlertMsgs.get("UN_BLOCK_CONFIRM"))) {
        showDivPageLoading("Js");

        var params = "{'pID' : '" + id + "'}";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/UnblockVisitAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                blockUnBlockSuccess(data, status, id);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("CityBlock_UR --> SearchAjaxCall", req, status, errorObj);
            }
        });
    }

    return false;
}

function blockUnBlockSuccess(data, status, id) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    $("#trSerRes" + id).removeAttr("rel");
                    $("#aSerRes" + id).removeAttr("class");
                    $("#aSerRes" + id).removeAttr("onclick");
                    $("#aSerRes" + id).html("");
                }
                else {
                    alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "");
                }
            }
        }
    }

    hideDivPageLoading("Js");
}