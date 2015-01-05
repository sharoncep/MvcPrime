$(document).ready(function () {
    var yr = new Date().getFullYear();
    var yrMin = yr - 50;
    var yrMax = yr + 5;
    var yrRng = "" + yrMin + ":" + yrMax + "";

    $("#from").datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , numberOfMonths: 1
        , yearRange: yrRng
        , onClose: function (selectedDate) { $("#to").datepicker("option", "minDate", selectedDate); }
    });
    $("#from").val(getCurrDate(true));

    $("#to").datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , yearRange: yrRng
        , numberOfMonths: 1
        , onClose: function (selectedDate) { $("#from").datepicker("option", "maxDate", selectedDate); }
    });
    $("#to").val(getCurrDate(false));
});

function getCurrDate(isPrevMn) {
    var retAns = "";
    var dt = new Date();
    var tmp = dt.getMonth();

    if (isPrevMn) {
        dt.setMonth(tmp - 1);
        tmp = dt.getMonth();
    }

    tmp++;
    if (tmp < 10) {
        retAns = retAns + "" + "0" + tmp.toString();
    }
    else {
        retAns = retAns + "" + tmp.toString();
    }
    retAns = retAns + "/";

    tmp = dt.getDate();
    if (tmp < 10) {
        retAns = retAns + "" + "0" + tmp.toString();
    }
    else {
        retAns = retAns + "" + tmp.toString();
    }
    retAns = retAns + "/";

    tmp = dt.getFullYear()
    retAns = retAns + "" + tmp.toString();

    return retAns;
}