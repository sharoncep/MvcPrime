$(document).ready(function () {
    loadNotification();
    loadDashTableResult();

    if ($("#divSync").attr("style").length == 0) {
        setTimeout("syncProc()", 1000);
    }
});

function loadNotification() {
    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallNotificationCount/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            loadNotificationSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);      // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}

function loadNotificationSuccess(jsonData, status) {
    if ($("#divNotifications").exists()) {
        var retAns = "";

        for (i in jsonData) {
            var d = jsonData[i];
            retAns = retAns + "<span>";
            retAns = retAns + AlertMsgs.get("NOTIFICATION");
            retAns = retAns + "</span>";

            retAns = retAns + "<ul class=\"ul-notification\">";

            if (d.DISP1 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + "1. ";
                retAns = retAns + AlertMsgs.get("USERS_WITHOUT_ROLE");
                retAns = retAns + " - ";
                if (d.DISP1 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('ROLE','NOTIFICATION');\">";
                    retAns = retAns + d.DISP1;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            if (d.DISP2 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + "2. ";
                retAns = retAns + AlertMsgs.get("USERS_WITHOUT_CLINIC");
                retAns = retAns + " - ";
                if (d.DISP2 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('CLINIC','NOTIFICATION');\">";
                    retAns = retAns + d.DISP2;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            if (d.DISP3 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + "3. ";
                retAns = retAns + AlertMsgs.get("MANAGER_WITHOUT_AGENT");
                retAns = retAns + " - ";
                if (d.DISP3 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('AGENT','NOTIFICATION');\">";
                    retAns = retAns + d.DISP3;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            if (d.DISP4 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + "4. ";
                retAns = retAns + AlertMsgs.get("CLINICS_WITHOUT_MANAGER");
                retAns = retAns + " - ";
                if (d.DISP4 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP4;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('MANAGER','NOTIFICATION');\">";
                    retAns = retAns + d.DISP4;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            if (d.DISP5 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + AlertMsgs.get("ASSIGNED_CLINICS");
                retAns = retAns + " - ";
                if (d.DISP3 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP5;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('AGENT_CLINIC','NOTIFICATION');\">";
                    retAns = retAns + d.DISP5;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            if (d.DISP6 != -1) {
                retAns = retAns + "<li>";
                retAns = retAns + "5. ";
                retAns = retAns + AlertMsgs.get("CLINICS_WITH_MANY_MANAGERS");
                retAns = retAns + " - ";

                if (d.DISP6 == 0) {
                    retAns = retAns + "<span>";
                    retAns = retAns + d.DISP6;
                    retAns = retAns + "</span>";
                }
                else {
                    retAns = retAns + "<a style=\"color:#daa6ff\" href=\"#\" onclick=\"javascript:return showDashPop('MULTI_MANAGER','NOTIFICATION');\">";
                    retAns = retAns + d.DISP6;
                    retAns = retAns + "</a>";
                }
                retAns = retAns + "</li>";
            }

            retAns = retAns + "</ul>";

        }

        $("#divNotifications").removeAttr("class");
        $("#divNotifications").attr("class", "dv-notifications");

        $("#divNotifications").html(retAns);
        return false;
    }
}

function loadDashTableResult() {
    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallDash/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessDash(data, status);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);      // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}

function SearchSuccessDash(jsonData, status) {
    if ($("#divDashSummary").exists()) {
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
                retAns = retAns + "','ONE');\">";
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
                retAns = retAns + "','SEVEN');\">";
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
                retAns = retAns + "','THIRTY');\">";
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
                retAns = retAns + "','THIRTYPLUS');\">";
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
                retAns = retAns + "','TOTAL');\">";
                retAns = retAns + d.COUNTTOTAL;
                retAns = retAns + "</a>";
            }
            retAns = retAns + "</td>";

            retAns = retAns + "</tr>";
        }

        retAns = retAns + "</table>";
        retAns = retAns + "<div id=\"divTotDash\"></div>";
        retAns = retAns + "<div class=\"dv-clear\">";
        retAns = retAns + "</div>";

        loadTotalDashResult(retAns);
    }

    return false;
}

function loadTotalDashResult(sumAns) {
    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallTotalDash/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            SearchSuccessTotalDash(data, status, sumAns);
        },
        error: function (req, status, errorObj) {
            // ajaxCallError("DashBoard_R --> SearchAjaxCallTotalDash", req, status, errorObj);  // Here error forcefully suppressed to handing parital loading
        }
    });

    return false;
}

function SearchSuccessTotalDash(jsonData, status, sumAns) {
    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<ul class=\"ul-list-dark\">";

        retAns = retAns + "<li>";
        retAns = retAns + AlertMsgs.get("BLOCKED");
        retAns = retAns + " - ";
        if (d.DISP1 == 0) {
            retAns = retAns + "<span>";
            retAns = retAns + d.DISP1;
            retAns = retAns + "</span>";
        }
        else {
            retAns = retAns + "<a rel=\"block\" href=\"#\" onclick=\"javascript:return showDashPop('Blocked','ALL');\">";
            retAns = retAns + d.DISP1;
            retAns = retAns + "</a>";
        }
        retAns = retAns + "</li>";

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
            retAns = retAns + "<a href=\"#\" onclick=\"javascript:return showDashPop('NIT','ALL');\">";
            retAns = retAns + d.DISP2;
            retAns = retAns + "</a>";
            retAns = retAns + " / " + d.DISP3;
        }
        retAns = retAns + "</li>";

        retAns = retAns + "</ul>";
    }

    $("#divDashSummary").html(sumAns);
    $("#divTotDash").html(retAns);

    $("#divDashSummary").removeAttr("class");
    $("#divDashSummary").attr("class", "dv-table-wrap-dash");

    return false;
}

function showDashPop(desc, ky) {

    if (ky == "NOTIFICATION") {
        if (desc == 'ROLE' || desc == 'CLINIC' || desc == 'AGENT') {
            $("#aToBrowser").removeAttr("href");
            $("#aToBrowser").attr("href", _AppDomainPath + _CtrlrName + "/Notification/0/0/?desc=" + desc + "&dayCount=" + ky);
        }
        else {
            $("#aToBrowser").removeAttr("href");
            $("#aToBrowser").attr("href", _AppDomainPath + _CtrlrName + "/NotificationClinic/0/0/?desc=" + desc + "&dayCount=" + ky);
        }

        $("#aToExcel").removeAttr("onclick");
        $("#aToExcel").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SaveExcelNotification/0/0/?desc=" + desc + "&dayCount=" + ky + "')"));

        //$("#aToExcel").removeAttr("rel");
        //$("#aToExcel").attr("rel", ("menu_tile_ucl"));

        $("#aToPdf").removeAttr("onclick");
        $("#aToPdf").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SavePdfNotification/0/0/?desc=" + desc + "&dayCount=" + ky + "')"));

    }
    else {
        $("#aToBrowser").removeAttr("href");
        $("#aToBrowser").attr("href", _AppDomainPath + _CtrlrName + "/Save/0/0/?desc=" + desc + "&dayCount=" + ky);

        $("#aToExcel").removeAttr("onclick");
        $("#aToExcel").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SaveExcel/0/0/?desc=" + desc + "&dayCount=" + ky + "')"));

        $("#aToPdf").removeAttr("onclick");
        $("#aToPdf").attr("onclick", ("javascript:return saveDashPop('" + _AppDomainPath + _CtrlrName + "/SavePdf/0/0/?desc=" + desc + "&dayCount=" + ky + "')"));

        $("#aToExcel").removeAttr("rel");
        $("#aToExcel").attr("rel", ("menu_tile"));

        $("#aToPdf").removeAttr("rel");
        $("#aToPdf").attr("rel", ("menu_tile"));

    }
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

function Sync() {
    showDivPageLoading("Js");

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/Sync/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            syncSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function syncSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    setTimeout("syncRefresh()", 30000);
                }
                else {
                    alertErrMsg(d, "");
                }
            }
        }
    }
}

function syncRefresh() {
    window.location.href = _AppDomainPath + _CtrlrName + "/Search/0/0/";
}

function syncProc() {

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SyncStatus/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            syncProcSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function syncProcSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.IS_SYNC_DONE) {
                    syncRefresh();
                }
                else {
                    setTimeout("syncProc()", 1000);
                }
            }
        }
    }
}
