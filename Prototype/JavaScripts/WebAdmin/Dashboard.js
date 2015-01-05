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

function showDashPop(ky) {
    if (ky == "11") {
        $("#divDashPopHdr").html("Detailed View: Visits -> Today");
    }
    else if (ky == "12") {
        $("#divDashPopHdr").html("Detailed View: Visits -> 1-7 Days");
    }
    else if (ky == "13") {
        $("#divDashPopHdr").html("Detailed View: Visits -> 8-30 Days");
    }
    else if (ky == "14") {
        $("#divDashPopHdr").html("Detailed View: Visits -> 31-90 Days");
    }
    else if (ky == "15") {
        $("#divDashPopHdr").html("Detailed View: Visits -> 91+ Days");
    }
    else if (ky == "21") {
        $("#divDashPopHdr").html("Detailed View: Created -> Today");
    }
    else if (ky == "22") {
        $("#divDashPopHdr").html("Detailed View: Created -> 1-7 Days");
    }
    else if (ky == "23") {
        $("#divDashPopHdr").html("Detailed View: Created -> 8-30 Days");
    }
    else if (ky == "24") {
        $("#divDashPopHdr").html("Detailed View: Created -> 31-90 Days");
    }
    else if (ky == "25") {
        $("#divDashPopHdr").html("Detailed View: Created -> 91+ Days");
    }
    else if (ky == "31") {
        $("#divDashPopHdr").html("Detailed View: Hold -> Today");
    }
    else if (ky == "32") {
        $("#divDashPopHdr").html("Detailed View: Hold -> 1-7 Days");
    }
    else if (ky == "33") {
        $("#divDashPopHdr").html("Detailed View: Hold -> 8-30 Days");
    }
    else if (ky == "34") {
        $("#divDashPopHdr").html("Detailed View: Hold -> 31-90 Days");
    }
    else if (ky == "35") {
        $("#divDashPopHdr").html("Detailed View: Hold -> 91+ Days");
    }
    else if (ky == "41") {
        $("#divDashPopHdr").html("Detailed View: Ready to Send -> Today");
    }
    else if (ky == "42") {
        $("#divDashPopHdr").html("Detailed View: Ready to Send -> 1-7 Days");
    }
    else if (ky == "43") {
        $("#divDashPopHdr").html("Detailed View: Ready to Send -> 8-30 Days");
    }
    else if (ky == "44") {
        $("#divDashPopHdr").html("Detailed View: Ready to Send -> 31-90 Days");
    }
    else if (ky == "45") {
        $("#divDashPopHdr").html("Detailed View: Ready to Send -> 91+ Days");
    }
    else if (ky == "51") {
        $("#divDashPopHdr").html("Detailed View: Sent -> Today");
    }
    else if (ky == "52") {
        $("#divDashPopHdr").html("Detailed View: Sent -> 1-7 Days");
    }
    else if (ky == "53") {
        $("#divDashPopHdr").html("Detailed View: Sent -> 8-30 Days");
    }
    else if (ky == "54") {
        $("#divDashPopHdr").html("Detailed View: Sent -> 31-90 Days");
    }
    else if (ky == "55") {
        $("#divDashPopHdr").html("Detailed View: Sent -> 91+ Days");
    }
    else if (ky == "61") {
        $("#divDashPopHdr").html("Detailed View: Accepted -> Today");
    }
    else if (ky == "62") {
        $("#divDashPopHdr").html("Detailed View: Accepted -> 1-7 Days");
    }
    else if (ky == "63") {
        $("#divDashPopHdr").html("Detailed View: Accepted -> 8-30 Days");
    }
    else if (ky == "64") {
        $("#divDashPopHdr").html("Detailed View: Accepted -> 31-90 Days");
    }
    else if (ky == "65") {
        $("#divDashPopHdr").html("Detailed View: Accepted -> 91+ Days");
    }
    else if (ky == "71") {
        $("#divDashPopHdr").html("Detailed View: Rejected -> Today");
    }
    else if (ky == "72") {
        $("#divDashPopHdr").html("Detailed View: Rejected -> 1-7 Days");
    }
    else if (ky == "73") {
        $("#divDashPopHdr").html("Detailed View: Rejected -> 8-30 Days");
    }
    else if (ky == "74") {
        $("#divDashPopHdr").html("Detailed View: Rejected -> 31-90 Days");
    }
    else if (ky == "75") {
        $("#divDashPopHdr").html("Detailed View: Rejected -> 91+ Days");
    }
    else if (ky == "81") {
        $("#divDashPopHdr").html("Detailed View: Re-Submitted -> Today");
    }
    else if (ky == "82") {
        $("#divDashPopHdr").html("Detailed View: Re-Submitted -> 1-7 Days");
    }
    else if (ky == "83") {
        $("#divDashPopHdr").html("Detailed View: Re-Submitted -> 8-30 Days");
    }
    else if (ky == "84") {
        $("#divDashPopHdr").html("Detailed View: Re-Submitted -> 31-90 Days");
    }
    else if (ky == "85") {
        $("#divDashPopHdr").html("Detailed View: Re-Submitted -> 91+ Days");
    }
    else if (ky == "91") {
        $("#divDashPopHdr").html("Detailed View: Total");
    }
    else if (ky == "92") {
        $("#divDashPopHdr").html("Detailed View: Expected Completion");
    }
    else if (ky == "93") {
        $("#divDashPopHdr").html("Detailed View: Actual Completed");
    }
    else if (ky == "94") {
        $("#divDashPopHdr").html("Detailed View: In Progress");
    }
    else if (ky == "95") {
        $("#divDashPopHdr").html("Detailed View: Not in Track");
    }
    else {
        $("#divDashPopHdr").html("Detailed View");
    }

    $("#divDashPop").fadeIn();
    return false;
}

function hideDashPop() {
    $("#divDashPop").fadeOut();
    return false;
}

function showDashPopUser(ky) {
    if (ky == "1") {
        $("#divDashPopUserHdr").html("Detailed View: Users Without Clinic");
    }
    else if (ky == "2") {
        $("#divDashPopUserHdr").html("Detailed View: Managers Without Clinic");
    }
    else if (ky == "3") {
        $("#divDashPopUserHdr").html("Detailed View: Visits -> Users Without Role");
    }
    else {
        $("#divDashPopUserHdr").html("Detailed View");
    }

    $("#divDashPopUser").fadeIn();
    return false;
}

function hideDashPopUser() {
    $("#divDashPopUser").fadeOut();
    return false;
}