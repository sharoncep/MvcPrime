$(document).ready(function () {

    var objs = $('input[type="text"][id^="VisitCharts"][id*="_"][id$="Patient"]');

    $.each(objs, function (i, obj) {
        setAutoComplete($(obj).attr("id"), 'ChartNo');
    });

    objs = $('input[type="text"][id^="VisitCharts"][id*="_"][id$="DateOfService"]');

    $.each(objs, function (i, obj) {
        setDatePickerDob($(obj).attr("id"), true);
    });

    _AlertMsgID = "VisitCharts_0__Patient";
    $("#" + _AlertMsgID).focus();

});

function ChartNoID() {
}

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");
        var objs = $('input[type="text"][id^="VisitCharts_"][id$="__PatientID"]');
        var hasVal = false;
        $.each(objs, function (i, obj) {
            if ((!hasVal) & ($(obj).val() > 0)) {
                hasVal = true;
            }
        });

        if (hasVal) {
            return true;
        }
        alertErrMsg(AlertMsgs.get("CHART_NO"), "VisitCharts_0__Patient");
        return false;
    }
    return false;
}

function showMore() {
    for (var i = 0; i < 5; i++) {
        $("#txtShowMore").val(parseInt($("#txtShowMore").val(), 10) + 1);
        $("#trVisitChart" + $("#txtShowMore").val()).fadeIn();

        if (parseInt($("#txtShowMore").val(), 10) > 48) {
            $("#aShowMore").fadeOut();
            break;
        }
    }

    $("#VisitCharts_" + (parseInt($("#txtShowMore").val(), 10) - 4).toString() + "__Patient").focus();

    return false;
}