$(document).ready(function () {
    if ($("#divReImport").attr("style").length == 0) {
        setTimeout("reImportProc()", 1000);
    }

});

function reImport() {
    showDivPageLoading("Js");

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/ReImport/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            reImportSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function reImportSuccess(data, status) {
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

function downloadExcelClinic(pky) {
    var wUrl = _AppDomainPath + _CtrlrName + "/DownloadExcel/0/0/?ky=" + pky;
    return printFile(wUrl);
}

function reImportRefresh() {
    window.location.href = _AppDomainPath + _CtrlrName + "/Search/0/0/";
}

function reImportProc() {

    var params = "{'pky' : '" + $("#divReImport").attr("title") + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/ReImportStatus/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            reImportProcSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("DashBoard_R --> SearchAjaxCallDash", req, status, errorObj);
        }
    });

    return false;
}

function reImportProcSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.IS_REIMPORT_DONE) {
                    reImportRefresh();
                }
                else {
                    setTimeout("reImportProc()", 1000);
                }
            }
        }
    }
}