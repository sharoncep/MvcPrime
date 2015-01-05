$(document).ready(function () {
});

function searchSuccess(data, status) {
    var hml = $("#divSearchResult").html();

    if (hml.length == 0) {
        hml = hml + "<table class=\"table-grid\">";
        hml = hml + "<tr>";

        hml = hml + "<td width=\"30%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "Name") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('Name', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('Name', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('Name', 'A');\">";
        }
        hml = hml + AlertMsgs.get("NAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "ChartNumber") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('ChartNumber', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('ChartNumber', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('ChartNumber', 'A');\">";
        }
        hml = hml + AlertMsgs.get("CHART_NUMBER");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + "<td width=\"15%\" class=\"td-gridhead\">";
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

        hml = hml + "<td width=\"10%\" class=\"td-gridhead\">";
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

        hml = hml + "<td width=\"10%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "PatientVisitComplexity") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatientVisitComplexity', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatientVisitComplexity', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('PatientVisitComplexity', 'A');\">";
        }
        hml = hml + AlertMsgs.get("COMPLEXITY");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"15%\" class=\"td-gridhead\">";
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
                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.ID;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";
                    retAns = retAns + d.DISP4;
                    retAns = retAns + "</td>";

                    retAns = retAns + "<td>";

                    if (d.IsActive) {
                        retAns = retAns + "&nbsp;";

                        //retAns = retAns + "<a href=\"#\" class=\"aUnblock\" rel=\"control_tile\" onclick=\"javascript:return setEdit('";
                        //retAns = retAns + (d.ID * -1)
                        //retAns = retAns + "');\">";
                        //retAns = retAns + AlertMsgs.get("UN_BLOCK");
                        //retAns = retAns + "</a>";
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

                    //if (ky == "B") {
                    //    $("#trSerRes" + id).removeAttr("rel");
                    //    $("#trSerRes" + id).attr("rel", "rel-block");

                    //    $("#aSerRes" + id).removeAttr("class");
                    //    $("#aSerRes" + id).removeAttr("onclick");
                    //    $("#aSerRes" + id).attr("class", "aUnblock");
                    //    $("#aSerRes" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'U')");
                    //    $("#aSerRes" + id).html(AlertMsgs.get("UN_BLOCK"));
                    //}
                    //else {
                    $("#trSerRes" + id).removeAttr("rel");

                    $("#aSerRes" + id).removeAttr("class");
                    $("#aSerRes" + id).removeAttr("onclick");
                    $("#aSerRes" + id).html("");
                    //$("#aSerRes" + id).attr("class", "aBlock");
                    //$("#aSerRes" + id).attr("onclick", "javascript:return valBlockUnBlock('" + id + "', 'B')");
                    //$("#aSerRes" + id).html(AlertMsgs.get("BLOCK"));
                    //}
                }
                else {
                    alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "");
                }
            }
        }
    }

    hideDivPageLoading("Js");
}