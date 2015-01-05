$(document).ready(function () {
    var yr = new Date().getFullYear();
    var yrMin = yr - 50;
    var yrMax = yr + 5;
    var yrRng = "" + yrMin + ":" + yrMax + "";

    $(".txt_cal").datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , numberOfMonths: 1
        , yearRange: yrRng
    });
    $(".txt_cal").val(getCurrDate(true));
});