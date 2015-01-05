$(document).ready(function () {
    getClockDtTm();
});

function getClockDtTm() {
    var dtTm = new Date();
    var tmp = "";
    var dys = new Array("SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY");
    var mns = new Array("JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER");

    //

    tmp = dtTm.getHours().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    $("#liHour").html(tmp);

    tmp = dtTm.getMinutes().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    $("#liMinute").html(tmp);

    tmp = dtTm.getSeconds().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    $("#liSecond").html(tmp);

    //

    tmp = dys[dtTm.getDay()];
    $("#liDayName").html(tmp);

    tmp = dtTm.getDate().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    $("#liDay").html(tmp);

    tmp = mns[dtTm.getMonth()];
    $("#liMonthName").html(tmp);

    $("#liYear").html(dtTm.getFullYear());

    //
    contiClockDtTm();
    //

    return false;
}

function contiClockDtTm() {
    setTimeout("getClockDtTm()", 900);
}