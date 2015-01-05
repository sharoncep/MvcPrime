$(document).ready(function () {
    loadSearchResult();
});

function loadSearchResult() {   // Load Clinic ID only
    loadSearch($("#StartBy").val(), $("#OrderByField").val(), $("#OrderByDirection").val(), true);
    var params = "{'pStartBy' : '" + $("#StartBy").val() + "'}";   // if no params need to use "{}"

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
            //ajaxCallError("SummaryAgent_R --> SearchAjaxCall", req, status, errorObj);     // Here error forcefully suppressed to handing parital loading
        }
    });


    return false;
}

function searchSuccess(data, status) {
    var retAns = "";
    var jsonData = data;

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<div class=\"dv-splits-wrap\">";

        retAns = retAns + "<div class=\"dv-subhead-split1\" >";
        retAns = retAns + d.NAME;
        retAns = retAns + "</div>";

        retAns = retAns + "<div class=\"dv-table-wrap1\">";

        retAns = retAns + "<div id=\"divDashSummary";
        retAns = retAns + d.USER_ID;
        retAns = retAns + "\"  class=\"dv-table-wrap-summary-loading\">";
        retAns = retAns + "</div>";

        retAns = retAns + "</div>";

        retAns = retAns + "</div>";
    }

    $("#divSearchResult").html(retAns);


    for (i in jsonData) {
        var d = jsonData[i];

        loadDashTableResult(d.USER_ID);
    }

    return false;
}

function loadDashTableResult(userID) {
    var params = "{'pUserID' : '" + userID + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallTableCount/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessDash(data, status, userID);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);      // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}

function SearchSuccessDash(jsonData, status, userID) {
    if ($("#divDashSummary" + userID).exists()) {
        var retAns = "";

        retAns = retAns + "<table class=\"table-dash\">";

        retAns = retAns + "<tr class=\"tr-head\">";
        retAns = retAns + "<td width=\"24%\" style=\"text-align:left\">";
        retAns = retAns + AlertMsgs.get("CLAIMS");
        retAns = retAns + "</td>";
        retAns = retAns + "<td width=\"12%\">";
        retAns = retAns + AlertMsgs.get("TODAY");
        retAns = retAns + "<span></span>";
        retAns = retAns + "</td>";
        retAns = retAns + "<td width=\"14%\">";
        retAns = retAns + "1-7";
        retAns = retAns + "<span>";
        retAns = retAns + AlertMsgs.get("DAYS");
        retAns = retAns + "</span>";
        retAns = retAns + "</td>";
        retAns = retAns + "<td width=\"16%\">";
        retAns = retAns + "8-30";
        retAns = retAns + "<span>";
        retAns = retAns + AlertMsgs.get("DAYS");
        retAns = retAns + "</span>";
        retAns = retAns + "</td>";
        retAns = retAns + "<td width=\"18%\">";
        retAns = retAns + "31+";
        retAns = retAns + "<span>";
        retAns = retAns + AlertMsgs.get("DAYS");
        retAns = retAns + "</span>";
        retAns = retAns + " </td>";
        retAns = retAns + "<td width=\"16%\">";
        retAns = retAns + AlertMsgs.get("TOT");
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        for (i in jsonData) {
            var d = jsonData[i];
            retAns = retAns + "<tr class=\"tr-row1\">";
            retAns = retAns + "<td class=\"td-claims\">";
            retAns = retAns + d.DESC;
            retAns = retAns + "</td>";
            retAns = retAns + "<td>";
            if (d.COUNT1 == 0) {
                retAns = retAns + "<span>";
                retAns = retAns + d.COUNT1;
                retAns = retAns + "</span>";
            }
            else {
                retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('";
                retAns = retAns + d.DESC;
                retAns = retAns + "','ONE','";
                retAns = retAns + userID;
                retAns = retAns + "');\">";
                retAns = retAns + d.COUNT1;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "<td>";
            if (d.COUNT7 == 0) {
                retAns = retAns + "<span>";
                retAns = retAns + d.COUNT7;
                retAns = retAns + "</span>";
            }
            else {
                retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('";
                retAns = retAns + d.DESC;
                retAns = retAns + "','SEVEN','";
                retAns = retAns + userID;
                retAns = retAns + "');\">";
                retAns = retAns + d.COUNT7;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "<td>";
            if (d.COUNT30 == 0) {
                retAns = retAns + "<span>";
                retAns = retAns + d.COUNT30;
                retAns = retAns + "</span>";
            }
            else {
                retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('";
                retAns = retAns + d.DESC;
                retAns = retAns + "','THIRTY','";
                retAns = retAns + userID;
                retAns = retAns + "');\">";
                retAns = retAns + d.COUNT30;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "<td>";
            if (d.COUNT30PLUS == 0) {
                retAns = retAns + "<span>";
                retAns = retAns + d.COUNT31PLUS;
                retAns = retAns + "</span>";
            }
            else {
                retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('";
                retAns = retAns + d.DESC;
                retAns = retAns + "','THIRTYPLUS','";
                retAns = retAns + userID;
                retAns = retAns + "');\">";
                retAns = retAns + d.COUNT31PLUS;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "<td>";
            if (d.TOTRECS == 0) {
                retAns = retAns + "<span>";
                retAns = retAns + d.COUNTTOTAL;
                retAns = retAns + "</span>";
            }
            else {
                retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('";
                retAns = retAns + d.DESC;
                retAns = retAns + "','TOTAL','";
                retAns = retAns + userID;
                retAns = retAns + "');\">";
                retAns = retAns + d.COUNTTOTAL;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "</tr>";
        }

        retAns = retAns + "</table>";
        retAns = retAns + "<div class=\"dv-nit-sum\" id=\"divTotDash";
        retAns = retAns + userID;
        retAns = retAns + "\"></div>";
        retAns = retAns + "<div class=\"dv-clear\">";
        retAns = retAns + "</div>";

        loadTotalDashResult(retAns, userID);
    }

    return false;
}

function loadTotalDashResult(sumAns, userID) {
    var params = "{'pUserID' : '" + userID + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallTotTableCount/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessTotalDash(data, status, sumAns, userID);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallTotalDash", req, status, errorObj);  // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}

function SearchSuccessTotalDash(jsonData, status, sumAns, userID) {
    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<ul class=\"ul-list-nit\">";

        retAns = retAns + "<li>";
        retAns = retAns + AlertMsgs.get("BLOCKED");
        retAns = retAns + " - ";
        if (d.DISP1 == 0) {
            retAns = retAns + "<span>";
            retAns = retAns + d.DISP1;
            retAns = retAns + "</span>";
        }
        else {
            retAns = retAns + "<a rel=\"block\" href=\"#\" onclick=\"javascript:return showDashPop('Blocked','ALL','";
            retAns = retAns + userID;
            retAns = retAns + "');\">";
            retAns = retAns + d.DISP1;
            retAns = retAns + "</a>";
        }
        retAns = retAns + "</li>";

        retAns = retAns + "<li>|</li>";

        retAns = retAns + "<li>";
        retAns = retAns + AlertMsgs.get("NOT_IN_TRACK");
        retAns = retAns + " - ";
        if (d.DISP2 == 0) {
            retAns = retAns + "<span>";
            retAns = retAns + d.DISP2;
            retAns = retAns + "</span>";
            retAns = retAns + " / " + d.DISP3;
        }
        else {
            retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('NIT','ALL','";
            retAns = retAns + userID;
            retAns = retAns + "');\">";
            retAns = retAns + d.DISP2;
            retAns = retAns + "</a>";
            retAns = retAns + " / " + d.DISP3;
        }
        retAns = retAns + "</li>";

        retAns = retAns + "</ul>";
    }

    $("#divDashSummary" + userID).html(sumAns);
    $("#divTotDash" + userID).html(retAns);

    $("#divDashSummary" + userID).removeAttr("class");
    $("#divDashSummary" + userID).attr("class", "dv-table-wrap-summary");

    return false;
}

function showDashPop(desc, dayCount, userID) {

    $("#aToBrowser").removeAttr("href");
    $("#aToBrowser").attr('href', _AppDomainPath + _CtrlrName + "/Save/0/0/?desc=" + desc + "&dayCount=" + dayCount + "&pUserID=" + userID);

    $("#aToExcel").removeAttr("onclick");
    $("#aToExcel").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SaveExcel/0/0/?desc=" + desc + "&dayCount=" + dayCount + "&pUserID=" + userID + "')"));

    $("#aToPdf").removeAttr("onclick");
    $("#aToPdf").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SavePdf/0/0/?desc=" + desc + "&dayCount=" + dayCount + "&pUserID=" + userID + "')"));

    $("#divDashPop").fadeIn();
    return false;
}

function saveDashPop(wUrl) {
    showDivPageLoading('Js');
    printFile(wUrl);
    hideDashPop();
    hideDivPageLoading('Js');
}

function hideDashPop() {
    $("#divDashPop").fadeOut();
    return false;
}