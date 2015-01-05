$(document).ready(function () {
    getClockDtTmLoad();
});

$(document).keypress(function () {
    _SessTimeOutIdleUsed = 0;
});

$(document).click(function () {
    _SessTimeOutIdleUsed = 0;
});

$(document).mousemove(function () {
    _SessTimeOutIdleUsed = 0;
});

function getClockDtTmLoad() {
    var obj = $(document).find('form');
    var len1 = (obj == null) ? 0 : (obj.length);

    if (len1 > 1) {
        window.location.href = _AppDomainPath + "PreLogIn/LogIn/0/0/?RR=MFM"; // More than one form is not allowed
    }

    obj = $(document).find('form[id="frmArivaForm"]');
    var len2 = (obj == null) ? 0 : (obj.length);

    if (len1 != len2) {
        window.location.href = _AppDomainPath + "PreLogIn/LogIn/0/0/?RR=NAD"; // More than one form is not allowed
    }

    hideDivPageLoading();

    getClockDtTm();
    setTimeout("startSessionTime()", 1500);

    return false;
}

function getClockDtTm() {
    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + 'PreLogIn/ClockAjaxCall/0/0/'),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: getClockDtTmSuccess,
        error: function (req, status, errorObj) {
            contiClockDtTm();
        }
    });

    return false;
}

function getClockDtTmSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];
                showClockDtTm(d.I_YEAR, d.I_MONTH, d.I_DAY, d.I_HOUR, d.I_MINUTE, d.I_SECOND, d.I_MILLISECOND);
            }
        }
    }

    contiClockDtTm();
}

function showClockDtTm(yr, mn, dy, hr, mi, sc, ms, svr) {
    var dtTm = new Date(yr, mn, dy, hr, mi, sc, ms);
    var monthNames = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
    var dayNames = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"];
    var tmp = 0;

    dtTm.setSeconds(dtTm.getSeconds() + 1);

    $("#liDayName").html(dayNames[dtTm.getDay()]);
    tmp = dtTm.getDate().toString();
    if (tmp.length == 2) {
        $("#liDay").html(tmp);
    }
    else {
        $("#liDay").html("0" + tmp);
    }
    $("#liMonthName").html(monthNames[dtTm.getMonth()]);
    $("#liYear").html(dtTm.getFullYear());
    //

    tmp = dtTm.getHours().toString();
    if (tmp.length == 2) {
        $("#liHour").html(tmp);
    }
    else {
        $("#liHour").html("0" + tmp);
    }
    tmp = dtTm.getMinutes().toString();
    if (tmp.length == 2) {
        $("#liMinute").html(tmp);
    }
    else {
        $("#liMinute").html("0" + tmp);
    }
    tmp = dtTm.getSeconds().toString();
    if (tmp.length == 2) {
        $("#liSecond").html(tmp);
    }
    else {
        $("#liSecond").html("0" + tmp);
    }

    var fn = "showClockDtTm('" + dtTm.getFullYear() + "', '" + dtTm.getMonth() + "', '" + dtTm.getDate() + "', '" + dtTm.getHours() + "', '" + dtTm.getMinutes() + "', '" + dtTm.getSeconds() + "', '" + dtTm.getMilliseconds() + "')";
    setTimeout(fn, 1000);
}

function contiClockDtTm() {
    setTimeout("getClockDtTm()", 120101);
}

function startSessionTime() {
    if (_SessTimeOutUsed == 0) {
        if (_SessTimeOutIdleUsed < _SessTimeOutIdleMax) {
            _SessTimeOutIdleUsed++;
        }
        else {
            lockScreen();
        }
    }
    else {
        if (_SessTimeOutUsed < _SessTimeOutMax) {
            updateSession();
        }
        else {
            window.location.href = _AppDomainPath + "PreLogIn/LogIn/0/0/?RR=IVS"; // Invalid Session
        }
    }

    setTimeout("startSessionTime()", 1000);

    return false;
}

function lockScreen() {
    $("#divSessionTimeOut").fadeIn();

    var params = "{}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + 'Home/LockAjaxCall/0/0/'),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: lockScreenSuccess,
        error: function (req, status, errorObj) {
            ajaxCallError("Lock Screen", req, status, errorObj);
        }
    });

    return false;
}

function lockScreenSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    _SessTimeOutUsed = 1;
                    updateSession();
                }
                else {
                    alertErrMsg(d, "");
                }
            }
        }
    }

    return false;
}

function updateSession() {
    _SessTimeOutUsed++;
    var sec = _SessTimeOutMax - _SessTimeOutUsed;
    var min = Math.floor(sec / 60);
    sec = sec % 60;
    var hr = Math.floor(min / 60);
    min = min % 60;

    if (hr < 0) {
        hr = "00";
    }
    else if (hr < 10) {
        hr = "0" + hr.toString();
    }
    else {
        hr = hr.toString();
    }

    if (min < 0) {
        min = "00";
    }
    else if (min < 10) {
        min = "0" + min.toString();
    }
    else {
        min = min.toString();
    }

    if (sec < 0) {
        sec = "00";
    }
    else if (sec < 10) {
        sec = "0" + sec.toString();
    }
    else {
        sec = sec.toString();
    }

    $("#spnBalTime").html(hr + ":" + min + ":" + sec);

    return false;
}

function unLockScreen() {
    if ($("#txtPassword").val().length > 0) {
        var params = "{'pPwd' : '" + (Sha1.hash($("#txtPassword").val())) + "'}";   // if no params need to use "{}"
        $("#txtPassword").val("");

        $.ajax({
            url: (_AppDomainPath + 'Home/UnLockAjaxCall/0/0/'),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: unLockScreenSuccess,
            error: function (req, status, errorObj) {
                $("#divErrorLock").html("Ajax Call Error: UnLock Screen" + req.toString() + status.toString() + errorObj.toString());
                $("#divErrorLock").fadeIn();
            }
        });
    }
    return false;
}

function unLockScreenSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;

            if (jsonData != null) {
                var d = jsonData[0];

                if (d.length == 0) {
                    _SessTimeOutUsed = 0;
                    $("#divSessionTimeOut").fadeOut();
                }
                else {
                    if (d == "NBT") {
                        window.location.href = _AppDomainPath + "PreLogIn/LogIn/0/0/?RR=NBT"; // No balance trail
                    }
                    else {
                        $("#divErrorLock").html(d);
                        $("#divErrorLock").fadeIn();
                    }
                }
            }
        }
    }

    return false;
}

function lockPwdFocus() {
    registerBlurFn();

    $("#divErrorLock").html("");
    $("#divErrorLock").fadeOut();

    return false;
}