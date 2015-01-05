$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);
    chkReImport();
});

function reImport(pKy) {
    showDivPageLoading("Js");

    var params = "{'pKy' : '" + pKy + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/DateWiseAjax/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            reImportSuccess(data, status, pKy);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function reImportSuccess(data, status, pKy) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    setTimeout("reImportRefresh()", 30000);
                }
                else {
                    alertErrMsg(d, "");
                }
            }
        }
    }
}

function downloadExcelClinicDate(ky) {

    var wUrl = _AppDomainPath + "RptAgentWise_R/DownloadDateExcel/0/0/?ky=" + ky;
    return printFile(wUrl);
}

function chkReImport() {
    var dvs = $("div[id^='divReImport']:not([id^='divReImportMsg'])");

    $.each(dvs, function (i, dv) {
        if ($(dv).attr("style").length == 0) {
            setTimeout(function () { reImportProc(dv); }, (1000 * (i + 1)));
        }
    });
}

function reImportRefresh() {
    window.location.href = _AppDomainPath + _CtrlrName + "/DateWise/0/0/";
}

function reImportProc(dv) {

    var params = "{'pky' : '" + $(dv).attr("title") + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/ReImportStatus/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            reImportProcSuccess(data, status, dv);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function reImportProcSuccess(data, status, dv) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];
                if (d.IS_REIMPORT_DONE) {
                    reImportRefresh();
                }
                else {
                    setTimeout(function () { reImportProc(dv); }, 1000);
                }
            }
        }
    }
}
