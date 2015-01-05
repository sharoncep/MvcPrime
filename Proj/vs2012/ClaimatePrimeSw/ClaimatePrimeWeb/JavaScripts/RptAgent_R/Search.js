$(document).ready(function () {
});

function reImport() {
    showDivPageLoading("Js");

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/ReImportAll/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            reImportSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("RptAgent_R --> SearchAjaxCallDash", req, status, errorObj);
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
                    $("#aReImport").hide();
                    $("#divReImportMsg").html(" ");
                    $("#divReImport").show();

                    hideDivPageLoading("Js");
                }
                else {
                    alertErrMsg(d, "");
                }
            }
        }
    }
}

function downloadExcelClinicAll(pky) {
    var wUrl = _AppDomainPath + _CtrlrName + "/DownloadExcelAll/0/0/?ky=" + pky;
    return printFile(wUrl);
}