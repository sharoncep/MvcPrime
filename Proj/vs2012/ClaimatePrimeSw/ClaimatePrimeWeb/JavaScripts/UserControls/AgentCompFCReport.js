$(document).ready(function () {
});

function getDatePickerVal(objID) {
    var dt = $("#" + objID).val();
    var dtArr = dt.split(_DefaultDateSeparator);

    return (dtArr[2] + "" + dtArr[0] + "" + dtArr[1]);
}

function showChartAgent() {
    showDivPageLoading("Js");

    $("#divPie").html("");
    $("#divDoughnut").html("");

    var params = "{'pDtFrm' : '" + getDatePickerVal('DateFrom') + "', 'pDtTo' : '" + getDatePickerVal('DateTo') + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCallComp/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: showChartAgentSuccess,
        error: showChartAgentError
    });

    return false;
}

function showChartAgentSuccess(data, status) {
    var pieXml = '<graph showNames="1" decimalPrecision="0" formatNumber="0" formatNumberScale="0" showBorder="0" showLegend="0" showhovercap="0" caption="">';
    var doughnutXml = '<graph showNames="1" decimalPrecision="0" formatNumber="0" formatNumberScale="0" showBorder="0" showLegend="0" showhovercap="0" caption="">';
    var clrs = ["401663", "9053a1", "542c8e", "baa0cc", "98258f", "98258f", "baa0cc", "542c8e", "9053a1", "401663"];
    var hasPie = false;
    var hasDou = false;

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                for (var i in jsonData) {
                    var d = jsonData[i];

                    if (i < 5) {    // Leading
                        if (d.VISITS > 0) {
                            hasPie = true;
                        }
                        pieXml = pieXml + '<set name="' + d.X_AXIS_NAME + '" value="' + d.VISITS + '" color="' + clrs[i] + '" />';
                    }
                    else {  // Trailing
                        if (d.VISITS > 0) {
                            hasDou = true;
                        }
                        doughnutXml = doughnutXml + '<set name="' + d.X_AXIS_NAME + '" value="' + d.VISITS + '" color="' + clrs[i] + '" />';
                    }
                }
            }
        }
    }

    pieXml = pieXml + '</graph>';
    doughnutXml = doughnutXml + '</graph>';

    $("#divDatePicked").html($("#DateFrom").val() + " - " + $("#DateTo").val());

    var chart1 = null;

    if (hasPie) {
        fusionChartRender();
        chart1 = new FusionCharts((_AppDomainPath + "FusionChartSwf/Pie2D.swf"), "ChartId", "490", "240");
        chart1.setDataXML(pieXml);
        chart1.render("divPie");
    }
    else {
        $("#divPie").html("<span class='span-date-range'>" + AlertMsgs.get("NO_DATA") + "</span>");
    }

    if (hasDou) {
        fusionChartRender();
        chart1 = new FusionCharts((_AppDomainPath + "FusionChartSwf/Doughnut2D.swf"), "ChartId", "490", "240");
        chart1.setDataXML(doughnutXml);
        chart1.render("divDoughnut");
    }
    else {
        $("#divDoughnut").html("<span class='span-date-range1'>" + AlertMsgs.get("NO_DATA") + "</span>");
    }

    hideDivPageLoading("Js");
}

function showChartAgentError(req, status, errorObj) {
    ajaxCallError("showChartAgentError", req, status, errorObj)
}