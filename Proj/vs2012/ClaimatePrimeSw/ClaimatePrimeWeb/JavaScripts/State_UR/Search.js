$(document).ready(function () {
    loadSearchResult();
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
                ajaxCallError("State_UR --> SearchAjaxCall", req, status, errorObj);
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

        hml = hml + "<td width=\"25%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "StateName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('StateName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('StateName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('StateName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("NAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "StateCode") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('StateCode', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('StateCode', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('StateCode', 'A');\">";
        }
        hml = hml + AlertMsgs.get("CODE");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"60%\" class=\"td-gridhead\">";
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
                    retAns = retAns + "<a id=\"aSerRes";
                    retAns = retAns + d.ID;
                    retAns = retAns + "\" href=\"#\" rel=\"control_tile\" ";
                    if (d.IsActive) {
                        retAns = retAns + "class=\"aBlock\" onclick=\"javascript:return valBlockUnBlock('";
                        retAns = retAns + d.ID;
                        retAns = retAns + "', 'B');\">";
                        retAns = retAns + AlertMsgs.get("BLOCK");
                    }
                    else {
                        retAns = retAns + "class=\"aUnblock\" onclick=\"javascript:return valBlockUnBlock('";
                        retAns = retAns + d.ID;
                        retAns = retAns + "', 'U');\">";
                        retAns = retAns + AlertMsgs.get("UN_BLOCK");
                    }
                    retAns = retAns + "</a>";
                    retAns = retAns + " </td>";

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

function valBlockUnBlock(id, ky) {
    var doAct = false;

    if (ky == "B") {
        doAct = confirm(AlertMsgs.get("BLOCK_CONFIRM"));
    }
    else {
        doAct = confirm(AlertMsgs.get("UN_BLOCK_CONFIRM"));
    }

    if (doAct) {
        var params = "{'pID' : '" + id + "', 'pKy' : '" + ky + "'}";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/BlockUnBlockAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                blockUnBlockSuccess(data, status, id, ky);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("State_UR --> SearchAjaxCall", req, status, errorObj);
            }
        });
    }

    return false;
}

function blockUnBlockSuccess(data, status, id, ky) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    if (ky == "B") {
                        $("#trSerRes" + id).removeAttr("rel");
                        $("#trSerRes" + id).attr("rel", "rel-block");

                        $("#aSerRes" + id).removeAttr("class");
                        $("#aSerRes" + id).removeAttr("onclick");
                        $("#aSerRes" + id).attr("class", "aUnblock");
                        $("#aSerRes" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'U')");
                        $("#aSerRes" + id).html(AlertMsgs.get("UN_BLOCK"));
                    }
                    else {
                        $("#trSerRes" + id).removeAttr("rel");

                        $("#aSerRes" + id).removeAttr("class");
                        $("#aSerRes" + id).removeAttr("onclick");
                        $("#aSerRes" + id).attr("class", "aBlock");
                        $("#aSerRes" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'B')");
                        $("#aSerRes" + id).html(AlertMsgs.get("BLOCK"));
                    }
                }
                else {
                    alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "");
                }
            }
        }
    }
}