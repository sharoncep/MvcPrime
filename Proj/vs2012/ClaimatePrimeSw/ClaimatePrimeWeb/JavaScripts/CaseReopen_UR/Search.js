$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);
    loadSearchResult();
});

function loadSearchResult() {
    if (($('#chkHasRec').is(':checked'))) {
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
                ajaxCallError("CreatedClaimsB_R --> SearchAjaxCall", req, status, errorObj);
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

        hml = hml + "<td width=\"30%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "PatName") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatName', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatName', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('PatName', 'A');\">";
        }
        hml = hml + AlertMsgs.get("NAME");
        hml = hml + "</a>";
        hml = hml + "</td>";

        hml = hml + " <td width=\"15%\" class=\"td-gridhead\">";
        hml = hml + "<a href=\"\" ";
        if ($("#OrderByField").val() == "PatChartNumber") {
            if ($("#OrderByDirection").val() == "D") {
                hml = hml + "class=\"sort_descending\" title=\"";
                hml = hml + AlertMsgs.get("DECENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatChartNumber', 'A');\">";
            }
            else {
                hml = hml + "class=\"sort_acending\" title=\"";
                hml = hml + AlertMsgs.get("ACCENDING");
                hml = hml + "\" onclick=\"javascript:return setSort('PatChartNumber', 'D');\">";
            }
        }
        else {
            hml = hml + "class=\"sort_normal\" onclick=\"javascript:return setSort('PatChartNumber', 'A');\">";
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
                    retAns = retAns + "<a id=\"aSerRes\" href=\"#\" rel=\"control_tile\" class=\"aReOpen\" onclick=\"javascript:return valBlockUnBlock('";
                    retAns = retAns + d.ID;
                    retAns = retAns + "');\">";
                    retAns = retAns + AlertMsgs.get("OPEN");
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
function valBlockUnBlock(id) {
  
        var params = "{'pID' : '" + id + "'}";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/BlockUnBlockAjaxCall/0/0/"),
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
    

    return false;
}
function blockUnBlockSuccess(data, status, id) {

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {

                   
       
                     
                        $("#trSerRes" + id).attr("style", "display:none");
                    
                }
                else {
                    alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "");
                }
            }
        }
    }
}