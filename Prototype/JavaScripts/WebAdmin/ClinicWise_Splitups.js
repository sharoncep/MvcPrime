$(document).ready(function () {
    var dtTm = new Date();
    var tmp = "";
    var dys = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
    var mns = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    var ans = "";

    //

    tmp = dys[dtTm.getDay()];
    ans += tmp + " - ";

    tmp = dtTm.getDate().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    ans += tmp + " ";

    tmp = mns[dtTm.getMonth()];
    ans += tmp + " ";

    tmp = dtTm.getFullYear();
    ans += tmp + " ";

    //

    tmp = dtTm.getHours().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    ans += tmp + ":";

    tmp = dtTm.getMinutes().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    } 
    ans += tmp + ":";

    tmp = dtTm.getSeconds().toString();
    while (tmp.length < 2) {
        tmp = "0" + tmp;
    }
    ans += tmp;
    
    $("#spnDashboard").html(ans);
});

function showDashPop() {
    $("#divDashPop").fadeIn();
    return false;
}

function hideDashPop() {
    $("#divDashPop").fadeOut();
    return false;
}