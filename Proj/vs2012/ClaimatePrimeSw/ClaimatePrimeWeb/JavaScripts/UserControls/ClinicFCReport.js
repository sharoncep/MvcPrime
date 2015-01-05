$(document).ready(function () {
});

function fusionChart(typ) {
    hideChart();
    $("#hdnFusChrtTyp").val(typ);
    setTimeout("showChart('')", 500);
}

function hideChart() {
    $("#divYear").hide();
    $("#divMon").hide();
    $("#divChart").animate(
        {
            "top": "0px"
            , "left": "0px"
            , "opacity": "0.25"
        }
        , {
            "duration": "slow"
            , complete: function () {
                $("#divChart").css("opacity", "1");
            }
        });
    $("#hdnFusChrtWid").val("0");
    $("#divChart").html("");
    $("#divChartLeg").hide();
    $("#divChartPg").hide();
    $("#aChartPgP").hide();
    $("#spnChartPgP").show();
    $("#aChartPgN").hide();
    $("#spnChartPgN").show();
}

function showChart(sumtyp) {
    showDivPageLoading("Js");

    var params = "{'pSUMMARY_TYPE' : '" + sumtyp + "'}";   // if no params need to use "{}"

    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/SearchAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data, status) { showChartSuccess(data, status, sumtyp); },
        error: showChartError
    });

    return false;
}

function showChartSuccess(data, status, sumtyp) {
    var retAns = '';

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                retAns = getChartXml(jsonData, sumtyp);
            }
        }
    }

    if (parseInt($("#hdnFusChrtWid").val(), 10) < 975) {
        $("#hdnFusChrtWid").val("975");
    }
    else {
        $("#aChartPgN").fadeIn("slow");
        $("#spnChartPgN").fadeOut("slow");
    }

    hideDivPageLoading("Js");

    fusionChartRender();
    var chart1 = new FusionCharts((_AppDomainPath + "FusionChartSwf/MSColumn2D.swf"), "ChartId", $("#hdnFusChrtWid").val(), "450");
    chart1.setDataXML(retAns);
    chart1.render("divChart");

    $("#divChartLeg").fadeIn("slow");
    $("#divChartPg").fadeIn("slow");
}

function showChartError(req, status, errorObj) {
    ajaxCallError("showChartError", req, status, errorObj);
}

function getChartXml(jsonData, sumtyp) {
    var retAns = "";
    var yrPrev = 1900;
    var yrIndx = 0;
    var mx = 0;
    var totVst = 0;
    var totInp = 0;
    var totRts = 0;
    var totSent = 0;
    var totDone = 0;

    var gph = "";
    var cat = "";
    var dsVst = "";
    var dsInProg = "";
    var dsRts = "";
    var dsSent = "";
    var dsDone= "";

    gph = gph + "<graph xaxisname='[XAXISX]' yaxisname='" + AlertMsgs.get("CLAIMS") + "' hovercapbg='DEDEBE' hovercapborder='889E6D' rotateNames='0' yAxisMinValue='0' yAxisMaxValue='[XMAX_VALX]' numdivlines='[XNUM_DIVX]' divLineColor='CCCCCC' divLineAlpha='80' decimalPrecision='0' showAlternateHGridColor='1' AlternateHGridAlpha='30' AlternateHGridColor='CCCCCC' formatNumber='1' formatNumberScale='0' showBorder='0' showLegend='0' caption='' subcaption=''>";
    cat = cat + "<categories font='Segoe' fontSize='14' fontColor='000000'>";
    dsVst = dsVst + "<dataset seriesname='" + AlertMsgs.get("VISITS") + "' color='bc00a8;'>";
    dsInProg = dsInProg + "<dataset seriesname='" + AlertMsgs.get("IN_PROGRESS") + "' color='fec3f8;'>";
    dsRts = dsRts + "<dataset seriesname='" + AlertMsgs.get("READY_TO_SEND") + "' color='401663'>";
    dsSent = dsSent + "<dataset seriesname='" + AlertMsgs.get("SENT") + "' color='542c8e'>";
    dsDone = dsDone + "<dataset seriesname='" + AlertMsgs.get("DONE") + "' color='baa0cc'>";

    if (sumtyp.length == 0) {
        yrPrev = $("#ddlYear").val();
        $("#ddlYear").removeAttr("onchange");
        $("#ddlYear").empty();
    }

    for (var i in jsonData) {
        var d = jsonData[i];
       
        if (d.VISITS > mx) {
            mx = d.VISITS;
        }

        if (d.IN_PROGRESS > mx) {            
            mx = d.IN_PROGRESS;            
        }

        if (d.READY_TO_SEND > mx) {
            mx = d.READY_TO_SEND;
        }

        if (d.SENT > mx) {
            mx = d.SENT;
        }

        if (d.DONE > mx) {
            mx = d.DONE;
        }       

        if (sumtyp.length == 0) {
            //$('#mySelect').append( new Option(text, value) );});
            $("#ddlYear").append(new Option(d.X_AXIS_NAME, d.X_AXIS_NAME));

            if (yrPrev == d.X_AXIS_NAME) {
                yrIndx = i;
            }
        }

        $("#hdnFusChrtWid").val(parseInt($("#hdnFusChrtWid").val(), 10) + 75);

        totVst += d.VISITS;
        totInp += d.IN_PROGRESS;
        totRts += d.READY_TO_SEND;
        totSent += d.SENT;
        totDone += d.DONE;
        

        if (sumtyp.startsWith("MONTHLY_")) {
            cat = cat + "<category name='" + getDispMon(d.X_AXIS_NAME) + "'/>";
        }
        else if (sumtyp.startsWith("DAILY_")) {
            cat = cat + "<category name='" + getDispDay(d.X_AXIS_NAME) + "'/>";
        }
        else {
            cat = cat + "<category name='" + d.X_AXIS_NAME + "'/>";
        }

        dsVst = dsVst + "<set value='" + d.VISITS + "'/>";
        dsInProg = dsInProg+ "<set value='" + d.IN_PROGRESS + "'/>";
        dsRts = dsRts + + "<set value='" + d.READY_TO_SEND + "'/>";
        dsSent = dsSent +"<set value='" + d.SENT + "'/>";
        dsDone = dsDone + "<set value='" + d.DONE + "'/>";
        
    }

    cat = cat + "</categories>";
    dsVst = dsVst + "</dataset>";
    dsInProg= dsInProg + "</dataset>";
    dsRts = dsRts + "</dataset>";
    dsSent = dsSent + "</dataset>";
    dsDone = dsDone + "</dataset>";
   

    retAns = gph + cat + dsVst + dsInProg  + dsRts + dsSent  + dsDone + "</graph>";

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

    if (sumtyp.startsWith("MONTHLY_")) {
        retAns = retAns.replace("[XAXISX]", AlertMsgs.get("MONTH"));
    }
    else if (sumtyp.startsWith("DAILY_")) {
        retAns = retAns.replace("[XAXISX]", AlertMsgs.get("DAY"));
    }
    else {
        retAns = retAns.replace("[XAXISX]", AlertMsgs.get("YEAR"));
    }

    $("#liVisit").html(formatTot(totVst));
    $("#liInProg").html(formatTot(totInp));
    $("#liReadyToSend").html(formatTot(totRts));
    $("#liSent").html(formatTot(totSent));
    $("#liDone").html(formatTot(totDone));
   

    if (sumtyp.length == 0) {
        $("#ddlYear").selectedIndex = yrIndx;
        $("#ddlYear").attr("onchange", "return fusionChartDdl();");
    }

    return retAns;
}

function formatTot(tot) {
    tot = tot.toString();
    var tot1 = tot.split("").reverse().join("");

    var retAns = "";

    for (var i = 1; i <= tot1.length; i++) {
        retAns = tot1.substr((i - 1), 1) + "" + retAns;

        if ((i % 3) == 0) {
            retAns = "," + "" + retAns;
        }
    }

    if (retAns.startsWith(",")) {
        retAns = retAns.substr(1, retAns.length - 1);
    }

    return retAns;
}

function fusionChartPg(pgDr) {
    $("#aChartPgP").fadeOut("slow");
    $("#spnChartPgP").fadeOut("slow");
    $("#aChartPgN").fadeOut("slow");
    $("#spnChartPgN").fadeOut("slow");

    var lft = $("#divChart").position().left;
    var sts = "M";

    if (pgDr == "P") {
        lft += 675;

        if (lft > 0) {
            lft = 0;
            sts = "B";
        }
    }
    else {
        lft -= 675;

        if ((parseInt($("#hdnFusChrtWid").val(), 10) + lft) < 975) {
            lft = (parseInt($("#hdnFusChrtWid").val(), 10) - 975) * -1;
            sts = "E";
        }
    }

    lft = lft.toString() + "px";

    $("#divChart").animate(
        {
            "top": "0px"
            , "left": lft
            , "opacity": "0.25"
        }
        , {
            "duration": "slow"
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

function fusionChartDdl() {
    showDivPageLoading("Js");
    hideChart();

    var val = $("#ddlPeriod").val();
    var sumtyp;

    if (val == "DAILY") {
        $("#divYear").show();
        $("#divMon").show();

        sumtyp = "DAILY_" + $("#ddlYear").val() + "_" + $("#ddlMon").val();
    }
    else if (val == "MONTHLY") {
        $("#divYear").show();

        sumtyp = "MONTHLY_" + $("#ddlYear").val();
    }
    else {
        sumtyp = '';
    }

    hideDivPageLoading("Js");

    showChart(sumtyp);

    return true;
}

function getDispMon(val) {
    var retAns = $("#ddlYear").val();
    val = val.toString();

    if (val.length == 1) {
        retAns = "0" + val + "-" + retAns;
    }
    else {
        retAns = val + "-" + retAns;
    }

    return retAns;
}

function getDispDay(val) {
    var retAns = $("#ddlMon").val() + "/_X_/" + $("#ddlYear").val();
    val = val.toString();

    if (val.length == 1) {
        retAns = retAns.replace(new RegExp("_X_", "g"), ("0" + val));
    }
    else {
        retAns = retAns.replace(new RegExp("_X_", "g"), val);
    }

    return retAns;
}