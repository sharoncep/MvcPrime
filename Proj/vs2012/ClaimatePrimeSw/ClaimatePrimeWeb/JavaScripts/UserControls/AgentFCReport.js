$(document).ready(function () {
});

function hideChart() {
    $("#divChart").animate(
        { "top": "0px"
            , "left": "0px"
            , "opacity": "0.25"
        }
        , { "duration": "slow"
            , complete: function () {
                $("#divChart").css("opacity", "1");
            }
        });
    $("#hdnFusChrtWid").val("0");
    $("#divChart").html("");
    $("#divChartPg").hide();
    $("#aChartPgP").hide();
    $("#spnChartPgP").show();
    $("#aChartPgN").hide();
    $("#spnChartPgN").show();
}

function showChartAgent(agnTyp) {
   

    showDivPageLoading("Js");

    hideChart();

    if (agnTyp.endsWith("Wise")) {
        return showChartAgentWise();
    }

    return showChartAgentAll();
}

function getDatePickerVal(objID) {
    var dt = $("#" + objID).val();
    var dtArr = dt.split(_DefaultDateSeparator);

    return (dtArr[2] + "" + dtArr[0] + "" + dtArr[1]);
}

function showChartAgentAll() {
    var params = "{'pDtFrm' : '" + getDatePickerVal('DateFrom') + "', 'pDtTo' : '" + getDatePickerVal('DateTo') + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: showChartAgentAllSuccess,
        error: showChartAgentAllError
    });
   
    return false;
}

function showChartAgentAllSuccess(data, status) {
    var retAns = '<graph xAxisName="' + AlertMsgs.get("AGENTS") + '" yAxisName="' + AlertMsgs.get("CLAIMS") + '" hovercapbg="DEDEBE" hovercapborder="889E6D" rotateNames="1" yAxisMinValue="0" yAxisMaxValue="[XMAX_VALX]" numdivlines="[XNUM_DIVX]" divLineColor="CCCCCC" divLineAlpha="80" decimalPrecision="0" showAlternateHGridColor="1" AlternateHGridAlpha="30" AlternateHGridColor="CCCCCC" formatNumber="1" formatNumberScale="0" showBorder="0" showLegend="0" caption="" subcaption="">';
    var clrs = ["401663", "98258f"];
    var mx = 0;

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                for (var i in jsonData) {
                    var d = jsonData[i];

                    if (d.CLAIM_COUNT> mx) {
                        mx = d.VISITS;
                    }

                    $("#hdnFusChrtWid").val(parseInt($("#hdnFusChrtWid").val(), 10) + 50);

                    retAns = retAns + '<set name="' + d.X_AXIS_NAME + '" value="' + d.VISITS + '" color="' + clrs[(i % 2)] + '" />';
                }
            }
        }
    }

    retAns = retAns + '</graph>';

    var tmpMx = mx;
    var powMx = tmpMx.toString().length - 1;

    tmpMx = parseInt((Math.pow(10, powMx) * 0.1).toString(), 10);
    mx += tmpMx;
    mx++;

    tmpMx = Math.pow(10, powMx);
    while ((mx % tmpMx) != 0) {
        mx++;
    }

    var numDiv = 9;
    if (mx < 11) {
        numDiv = mx - 1;
    }

    retAns = retAns.replace("[XMAX_VALX]", mx.toString());
    retAns = retAns.replace("[XNUM_DIVX]", numDiv.toString());

    if (parseInt($("#hdnFusChrtWid").val(), 10) < 975) {
        $("#hdnFusChrtWid").val("975");
    }
    else {
        $("#aChartPgN").fadeIn("slow");
        $("#spnChartPgN").fadeOut("slow");
    }

    $("#divDatePicked").html($("#DateFrom").val() + " - " + $("#DateTo").val());

    hideDivPageLoading("Js");

    fusionChartRender();
    var chart1 = new FusionCharts((_AppDomainPath + "FusionChartSwf/Column2D.swf"), "ChartId", $("#hdnFusChrtWid").val(), "450");
    chart1.setDataXML(retAns);
    chart1.render("divChart");

    $("#divChartPg").fadeIn("slow");
}

function showChartAgentAllError(req, status, errorObj) {
    ajaxCallError("showChartAgentAllError", req, status, errorObj)
}

function showChartAgentWise() {
    var params = "{'pDtFrm' : '" + getDatePickerVal('DateFrom') + "', 'pDtTo' : '" + getDatePickerVal('DateTo') + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: showChartAgentWiseSuccess,
        error: showChartAgentWiseError
    });

    return false;
}

function showChartAgentWiseSuccess(data, status) {
    var retAns = '<graph xAxisName="' + AlertMsgs.get("DAY") + '" yAxisName="' + AlertMsgs.get("CLAIMS") + '" hovercapbg="DEDEBE" hovercapborder="889E6D" rotateNames="1" yAxisMinValue="0" yAxisMaxValue="[XMAX_VALX]" numdivlines="[XNUM_DIVX]" divLineColor="CCCCCC" divLineAlpha="80" decimalPrecision="0" showAlternateHGridColor="1" AlternateHGridAlpha="30" AlternateHGridColor="CCCCCC" formatNumber="1" formatNumberScale="0" showBorder="0" showLegend="0" caption="" subcaption="">';
    var clrs = ["401663", "98258f"];
    var mx = 0;

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                for (var i in jsonData) {
                    var d = jsonData[i];

                    if (d.CLAIM_COUNT > mx) {
                        mx = d.CLAIM_COUNT;
                    }

                    $("#hdnFusChrtWid").val(parseInt($("#hdnFusChrtWid").val(), 10) + 50);

                    retAns = retAns + '<set name="' + d.CLAIM_DATE + '" value="' + d.CLAIM_COUNT + '" color="' + clrs[(i % 2)] + '" />';
                }
            }
        }
    }

    retAns = retAns + '</graph>';

    var tmpMx = mx;
    var powMx = tmpMx.toString().length - 1;

    tmpMx = parseInt((Math.pow(10, powMx) * 0.1).toString(), 10);
    mx += tmpMx;
    mx++;

    tmpMx = Math.pow(10, powMx);
    while ((mx % tmpMx) != 0) {
        mx++;
    }

    var numDiv = 9;
    if (mx < 11) {
        numDiv = mx - 1;
    }

    retAns = retAns.replace("[XMAX_VALX]", mx.toString());
    retAns = retAns.replace("[XNUM_DIVX]", numDiv.toString());

    if (parseInt($("#hdnFusChrtWid").val(), 10) < 975) {
        $("#hdnFusChrtWid").val("975");
    }
    else {
        $("#aChartPgN").fadeIn("slow");
        $("#spnChartPgN").fadeOut("slow");
    }

   

    hideDivPageLoading("Js");

    fusionChartRender();
    var chart1 = new FusionCharts((_AppDomainPath + "FusionChartSwf/Column2D.swf"), "ChartId", $("#hdnFusChrtWid").val(), "450");
    chart1.setDataXML(retAns);
    chart1.render("divChart");

    $("#divChartPg").fadeIn("slow");
}

function showChartAgentWiseError(req, status, errorObj) {
    ajaxCallError("showChartAgentWiseError", req, status, errorObj)
}

function fusionChartPg(pgDr) {
    $("#aChartPgP").fadeOut("slow");
    $("#spnChartPgP").fadeOut("slow");
    $("#aChartPgN").fadeOut("slow");
    $("#spnChartPgN").fadeOut("slow");

    var lft = $("#divChart").position().left;
    var sts = "M";

    if (pgDr == "P") {
        lft += 700;

        if (lft > 0) {
            lft = 0;
            sts = "B";
        }
    }
    else {
        lft -= 700;

        if ((parseInt($("#hdnFusChrtWid").val(), 10) + lft) < 975) {
            lft = (parseInt($("#hdnFusChrtWid").val(), 10) - 975) * -1;
            sts = "E";
        }
    }

    lft = lft.toString() + "px";

    $("#divChart").animate(
        { "top": "0px"
            , "left": lft
            , "opacity": "0.25"
        }
        , { "duration": "slow"
            , complete: function () {
                if (sts == "B") {
                    $("#aChartPgN").fadeIn("slow");
                    $("#spnChartPgP").fadeIn("slow");
                }
                else if (sts == "E") {
                    $("#spnChartPgN").fadeIn("slow");
                    $("#aChartPgP").fadeIn("slow");
                }
                else {
                    $("#aChartPgN").fadeIn("slow");
                    $("#aChartPgP").fadeIn("slow");
                }

                $("#divChart").css("opacity", "1");
            }
        });

    return false;
}