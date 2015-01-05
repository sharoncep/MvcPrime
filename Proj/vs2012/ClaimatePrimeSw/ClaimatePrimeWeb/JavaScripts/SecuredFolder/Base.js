// Disable: Back Button. I am not sure about unload. Starts
// http://stackoverflow.com/questions/158319/cross-browser-onload-event-and-the-back-button

history.go(+1);
$(window).bind("unload", function () { history.go(+1); _SessTimeOutUsed = 15397; });
//alert($(window).height()); alert($(window).width());

// Disable: Back Button. I am not sure about unload. Ends


// Block Mouse Right Click Starts

// http://www.dynamicdrive.com/dynamicindex9/noright.htm

//Disable right mouse click Script
//By Maximus (maximus@nsimail.com) w/ mods by DynamicDrive
//For full source code, visit http://www.dynamicdrive.com

function clickIE4() {
    if (event.button == 2) {
        alertErrMsg(AlertMsgs.get("NO_RIGHT_CLICK"), "");
        return false;
    }

    return true;
}

function clickNS4(e) {
    if (document.layers || document.getElementById && !document.all) {
        if (e.which == 2 || e.which == 3) {
            alertErrMsg(AlertMsgs.get("NO_RIGHT_CLICK"), "");
            return false;
        }
    }

    return true;
}

if (document.layers) {
    document.captureEvents(Event.MOUSEDOWN);
    document.onmousedown = clickNS4;
}
else if (document.all && !document.getElementById) {
    document.onmousedown = clickIE4;
}

document.oncontextmenu = new Function('alertErrMsg("' + AlertMsgs.get("NO_RIGHT_CLICK") + '", ""); return false;')

// Block Mouse Right Click Ends

// Block Backspace & Enter Key Starts

// Prevent the backspace key from navigating back.
// http://stackoverflow.com/questions/1495219/how-can-i-prevent-the-backspace-key-from-navigating-back
// http://stackoverflow.com/questions/2645681/how-to-disable-backspace-if-anything-other-than-input-field-is-focused-on-using
$(document).unbind('keydown').bind('keydown', function (event) {
    if ((event.keyCode === 8) || (event.keyCode === 13)) {
        var doPrevent = false;
        var d = event.srcElement || event.target;

        if (event.keyCode === 8) {
            if ((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'TEXT' || d.type.toUpperCase() === 'PASSWORD')) || (d.tagName.toUpperCase() === 'TEXTAREA')) {
                doPrevent = d.readOnly || d.disabled;
            }
            else {
                doPrevent = true;
            }

            if (doPrevent) {
                event.preventDefault();
                alertErrMsg(AlertMsgs.get("NO_BACK_SPACE"), "");
            }
        }
        else if (event.keyCode === 13) {
            try {
                if ((d.tagName.toUpperCase() === 'INPUT') || (d.tagName.toUpperCase() === 'A')) {
                    if (((d.tagName.toUpperCase() === 'INPUT' && (d.type.toUpperCase() === 'BUTTON' || d.type.toUpperCase() === 'SUBMIT'))) || (d.tagName.toUpperCase() === 'A')) {
                        // no issue
                    }
                    else {
                        $(d).blur();

                        if (_CtrlrName == "PreLogIn") {
                            if ($("#btnLogIn").exists()) {
                                setTimeout(function () {
                                    if (canSubmit()) {
                                        $("#btnLogIn").click();
                                    }
                                }, 300);
                            }
                            else if ($("#btnSave").exists()) {
                                setTimeout(function () {
                                    if (canSubmit()) {
                                        $("#btnSave").click();
                                    }
                                }, 300);
                            }
                            else {
                                doPrevent = true;
                            }
                        }
                        else if (_SessTimeOutUsed == 0) {
                            if ($("#btnSave").exists()) {
                                setTimeout(function () {
                                    if (canSubmit()) {
                                        $("#btnSave").click();
                                    }
                                }, 300);
                            }
                            else if ($("#btnSearch").exists()) {
                                setTimeout(function () {
                                    if (canSubmit()) {
                                        $("#btnSearch").click();
                                    }
                                }, 300);
                            }
                            else {
                                doPrevent = true;
                            }
                        }
                        else {
                            $("#btnLogIn").click();
                        }
                    }
                }
                else {
                    doPrevent = true;
                }
            }
            catch (e) {
                doPrevent = true;
            }

            if (doPrevent) {
                event.preventDefault();
                alertErrMsg(AlertMsgs.get("NO_ENTER_KEY"), "");
            }
        }
    }
});

// Block Backspace & Enter Key Ends

// Block AutoComplete Starts

// http://stackoverflow.com/questions/5274407/disable-autocomplete-on-html-helper-textbox-in-mvc

$(document).ready(function () {
    try {
        if (document.getElementsByTagName) {
            var inputElements = document.getElementsByTagName("input");
            for (i = 0; inputElements[i]; i++) {
                if (inputElements[i].type == "text") {
                    try {
                        $(inputElements[i]).removeAttr("autocomplete");
                    }
                    catch (e)
                    { }
                    try {
                        $(inputElements[i]).attr("autocomplete", "off");
                    }
                    catch (e)
                    { }
                }
            }
        }
    }
    catch (e)
    { }

    // Show or Hide Success or Error Msg Starts

    if (($('input[name="txtErrMsg"]') == null) || ($('input[name="txtErrMsg"]').val() == "undefined") || ($('input[name="txtErrMsg"]').val() == undefined) || ($('input[name="txtErrMsg"]').val() == "")) {
        $("#divErrMsg").hide();
    }
    else {
        $("#divErrMsgInner").html($('input[name="txtErrMsg"]').val());
        $('input[name="txtErrMsg"]').val("");
        $("#divErrMsg").fadeIn();
        setTimeout("$(\"#aErrClose\").focus();", 250);
    }

    if (($('input[name="txtSuccMsg"]') == null) || ($('input[name="txtSuccMsg"]').val() == "undefined") || ($('input[name="txtSuccMsg"]').val() == undefined) || ($('input[name="txtSuccMsg"]').val() == "")) {
        $("#divSuccMsg").hide();
    }
    else {
        $("#divSuccMsgInner").html($('input[name="txtSuccMsg"]').val());
        $('input[name="txtSuccMsg"]').val("");
        $("#divSuccMsg").fadeIn();
        setTimeout("$(\"#aSuccClose\").focus();", 250);
    }

    // Show or Hide Success or Error Msg Ends

    // Date Picker Culture Set
    $.datepicker.setDefaults($.datepicker.regional[_DefaultDateCulture]);

    // Custom Auto Compete 
    $.ui.autocomplete.prototype._renderItem = function (ul, item) {
        this.term = this.term.replace(new RegExp("'", "g"), "");
        var stsKy = ($.trim(this.term)).toLowerCase();
        //
        var trmLen = stsKy.length;
        var spn = "";
        var txt = "";

        //
        item.label = item.label.replace(new RegExp("<", "g"), "&lt;");
        item.label = item.label.replace(new RegExp("<", "g"), "&gt;");
        //

        if (trmLen == 0) {
            spn = $("<span>").append("");
            txt = item.label;
        }
        else {
            var stIdx = item.label.toLowerCase().indexOf(stsKy);

            if (stIdx > -1) {
                var stVal = item.label.substr(0, stIdx);
                var stsVl = item.label.substr(stIdx, trmLen);

                spn = $("<span>").append(stVal).append($("<span class='auto-complete-high'>").append(stsVl));
                txt = item.label.substr((stIdx + trmLen), (item.label.length - (stIdx + trmLen)));
            }
            else {
                spn = $("<span>").append("");
                txt = item.label;
            }
        }

        return ($("<li>").append($("<a>").append(spn).append(txt)).appendTo(ul));
    };
});

// Block AutoComplete Ends

// CAPS LOCK CHECKING STARTS

// http://www.experts-exchange.com/Programming/Languages/.NET/ASP.NET/Q_27394907.html

function checkCapsLock(e) {
    var myKeyCode = 0;
    var myShiftKey = false;
    var retAns = true;

    // Internet Explorer 4+
    if (document.all) {
        myKeyCode = e.keyCode;
        myShiftKey = e.shiftKey;

        // Netscape 4
    }
    else if (document.layers) {
        myKeyCode = e.which;
        myShiftKey = (myKeyCode == 16) ? true : false;

        // Netscape 6
    }
    else if (document.getElementById) {
        myKeyCode = e.which;
        myShiftKey = (myKeyCode == 16) ? true : false;
    }

    if (myShiftKey == false) {
        myShiftKey = e.shiftKey;
    }

    // Upper case letters are seen without depressing the Shift key, therefore Caps Lock is on
    if ((myKeyCode >= 65 && myKeyCode <= 90) && !myShiftKey) {
        retAns = false;

        // Lower case letters are seen while depressing the Shift key, therefore Caps Lock is on
    }
    else if ((myKeyCode >= 97 && myKeyCode <= 122) && myShiftKey) {
        retAns = false;
    }

    if (retAns == false) {
        $("#divCapsLockOn").fadeIn();
    }
    else {
        $("#divCapsLockOn").fadeOut('slow');
    }

    return true;
}

// CAPS LOCK CHECKING ENDS

// SET CURSOR POSITION STARTS

function setCursor(node, pos) {
    var node = (typeof node == "string" || node instanceof String) ? document.getElementById(node) : node;
    if (!node) {
        return false;
    }
    else if (node.createTextRange) {
        var textRange = node.createTextRange();
        textRange.collapse(true);
        textRange.moveEnd(pos);
        textRange.moveStart(pos);
        textRange.select();
        return true;
    }
    else if (node.setSelectionRange) {
        node.setSelectionRange(pos, pos);
        return true;
    }
    else {
    }
    return false;
}

// SET CURSOR POSITION ENDS

function showDivPageLoading() {
    var argLen = arguments.length;
    var ky;

    if (argLen == 0) {
        ky = "";
    }
    else if (argLen == 1) {
        ky = arguments[0];
    }
    else {
        alertErrMsg(AlertMsgs.get("ARGS_LEN"), '');
    }

    $("#divPageLoading" + ky).show();
}

function hideDivPageLoading() {
    var argLen = arguments.length;
    var ky;

    if (argLen == 0) {
        ky = "";
    }
    else if (argLen == 1) {
        ky = arguments[0];
    }
    else {
        alertErrMsg(AlertMsgs.get("ARGS_LEN"), '');
    }

    $("#divPageLoading" + ky).fadeOut("fast");
}

function showSearchLoading() {
    $("#divaSearchResult").hide();
    $("#divSearchLoading").show();
}

function hideSearchLoading() {
    var argLen = arguments.length;
    var spd;

    if (argLen == 0) {
        spd = "slow";
    }
    else if (argLen == 1) {
        spd = arguments[0];
    }
    else {
        alertErrMsg(AlertMsgs.get("ARGS_LEN"), '');
    }

    $("#divaSearchResult").show();
    $("#divSearchLoading").fadeOut(spd);
}

function registerBlurFn() {
    _RegBlurFns.push(_RegBlurFns.length);
    return true;
}

jQuery.extend(jQuery.expr[':'], {
    focus: "a == document.activeElement"
});

function unRegisterBlurFn() {
    var ln = _RegBlurFns.length;
    if (ln > 0) {
        _RegBlurFns.pop(_RegBlurFns.length);
        return true;
    }

    if ($(document.activeElement).get(0).tagName == "BODY") {
        alertErrMsg(AlertMsgs.get("UNRG_ERROR"), "");
        return false;
    }

    return true;
}

function canSubmit() {
    if (_RegBlurFns.length == 0) {
        return true;
    }

    alertErrMsg(AlertMsgs.get("SUBM_ERROR").replace(new RegExp("XKEYX", "g"), _RegBlurFns.toString()), "");
    return false;
}

function setAutoComplete() {
    var argLen = arguments.length;
    if ((argLen < 1) || (argLen > 3)) {
        alertErrMsg(AlertMsgs.get("ARGS_LEN"), '');
    }

    var objId = arguments[0];
    var objIdIDVal = "";
    var objValFocus = "";
    var objValBlur = "";
    var mvcActn = "";
    var conti = "";
    var params = "";
    var hasReg = false;

    $("#" + objId).removeAttr("rel");
    $("#" + objId).attr("rel", "ac_text");

    if (argLen == 1) {
        mvcActn = objId;
    }
    else {
        if (arguments[1].length > 0) {
            mvcActn = arguments[1];
        }
        else {
            mvcActn = objId;
        }

        if (argLen == 3) {
            conti = arguments[2];
        }
    }

    if (!($("#" + objId + "ID").exists())) {
        alertErrMsg(AlertMsgs.get("NO_AC_ID").replace(new RegExp("XKEYX", "g"), (objId + "ID")), objId);
        return false;
    }

    $("#" + objId).bind({
        focus: function () {
            objIdIDVal = $("#" + objId + "ID").val();
            $("#" + objId + "ID").val("");
            objValFocus = $("#" + objId).val();
        }
    });

    $("#" + objId).autocomplete({
        source: function (request, response) {
            if (!(hasReg)) {
                registerBlurFn();
                hasReg = true;
            }
            request.term = request.term.replace(new RegExp("'", "g"), "");
            $("#" + objId).removeAttr("rel");
            $("#" + objId).attr("rel", "loading");
            $("#" + objId).val(request.term);

            if (argLen < 3) {
                params = "{'stats' : '" + request.term + "'}";   // if no params need to use "{}"
            }
            else {
                var contiVal = $("#" + conti).val();
                params = "{'stats' : '" + request.term + "', 'conti' : '" + contiVal + "'}";   // if no params need to use "{}"
            }
            $.ajax({
                url: (_AppDomainPath + "AutoComplete/" + mvcActn + "/0/0/"),
                type: 'POST',
                data: params,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                success: function (data) {
                    response(data); // You may have to perform post-processing here depending on your data.
                    $("#" + objId).removeAttr("rel");
                    $("#" + objId).attr("rel", "ac_text");
                },
                error: function (req, status, errorObj) {
                    ajaxCallError("AutoComplete Fetching", req, status, errorObj);
                    $("#" + objId).removeAttr("rel");
                    $("#" + objId).attr("rel", "ac_text");
                }
            });
        }
        , minLength: 1
        , autoFocus: true
        , delay: 5
    });

    $("#" + objId).bind({
        blur: function () {
            keyUpTrim($("#" + objId));
            $("#" + objId).val($("#" + objId).val().replace(new RegExp("'", "g"), ""));
            objValBlur = $("#" + objId).val();

            if (objValFocus == objValBlur) {
                $("#" + objId + "ID").val(objIdIDVal);

                if (hasReg) {
                    unRegisterBlurFn();
                    hasReg = false;
                }
            }
            else {
                if (objValBlur.length > 0) {
                    var params = "{'selText' : '" + objValBlur + "'}";   // if no params need to use "{}"
                    $.ajax({
                        url: (_AppDomainPath + "AutoComplete/" + mvcActn + "ID/0/0/"),
                        type: 'POST',
                        data: params,
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        success: function (data, status) {
                            if (data != null) {
                                if (status.toLowerCase() == 'success') {
                                    var jsonData = data;

                                    if (jsonData != null) {
                                        var d = jsonData[0];
                                        if (d == "0") {
                                            $("#" + objId).val("");
                                        }
                                        else {
                                            $("#" + objId + "ID").val(d);
                                        }
                                    }
                                }
                            }

                            if (hasReg) {
                                setTimeout("unRegisterBlurFn()", 14);
                                hasReg = false;
                            }

                            setTimeout(("" + mvcActn + "ID()"), 10);
                        },
                        error: function (req, status, errorObj) {
                            ajaxCallError("AutoComplete ID Fetching", req, status, errorObj);
                            hasReg = false;
                        }
                    });
                }
                else {
                    if (hasReg) {
                        unRegisterBlurFn();
                        hasReg = false;
                    }

                    setTimeout(("" + mvcActn + "ID()"), 1);
                }
            }
        }
    });
}

function getDateCurrStr(isPrevMn) {
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
    retAns = retAns + _DefaultDateSeparator;

    tmp = dt.getDate();
    if (tmp < 10) {
        retAns = retAns + "" + "0" + tmp.toString();
    }
    else {
        retAns = retAns + "" + tmp.toString();
    }
    retAns = retAns + _DefaultDateSeparator;

    tmp = dt.getFullYear()
    retAns = retAns + "" + tmp.toString();

    return retAns;
}

function getDateStr(dt) {
    var retAns = "";

    if ((dt != null) && (dt.length > 0)) {
        dt = dt.toString();
        dt = dt.split(" ")[0];

        var dtArr = dt.split(_DefaultDateSeparator);

        if (dtArr[0].length < 2) {
            retAns = retAns + "0";
        }

        retAns = retAns + dtArr[0] + _DefaultDateSeparator;

        if (dtArr[1].length < 2) {
            retAns = retAns + "0";
        }

        retAns = retAns + dtArr[1] + _DefaultDateSeparator;

        retAns = retAns + dtArr[2];
    }

    return retAns;
}

function isMinDatePicker(dt) {
    var dtArr = getDateStr(dt).split(_DefaultDateSeparator);
    dt = dtArr[2] + "" + dtArr[0] + "" + dtArr[1];

    if (parseInt(dt, 10) < 19000101) {
        return true;
    }

    return false;
}

function setDatePicker(objId, isNotNull) {
    var yrMin = 1900;
    var yrMax = (new Date().getFullYear()) + 100;
    var yrRng = "" + yrMin + ":" + yrMax + "";

    $("#" + objId).datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , dateFormat: _DefaultDate.substr(0, _DefaultDate.length - 2)
        , numberOfMonths: 1
        , yearRange: yrRng
    });

    if (isMinDatePicker($("#" + objId).val())) {
        $("#" + objId).val("");
    }

    if ((isNotNull) && ($("#" + objId).val().length == 0)) {
        $("#" + objId).val(getDateCurrStr(false));
    }
    else {
        $("#" + objId).val(getDateStr($("#" + objId).val()));
    }
}

function setDatePickerDob(objId, isNotNull) {
    var yrMin = 1900;
    var yrMax = new Date().getFullYear();
    var yrRng = "" + yrMin + ":" + yrMax + "";

    $("#" + objId).datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , dateFormat: _DefaultDate.substr(0, _DefaultDate.length - 2)
        , numberOfMonths: 1
        , yearRange: yrRng
        , maxDate: (new Date())
    });

    if (isMinDatePicker($("#" + objId).val())) {
        $("#" + objId).val("");
    }

    if ((isNotNull) && ($("#" + objId).val().length == 0)) {
        $("#" + objId).val(getDateCurrStr(false));
    }
    else {
        $("#" + objId).val(getDateStr($("#" + objId).val()));
    }
}

function setDatePickerFromTo(objIdFrom, isNotNullFrom, objIdTo, isNotNullTo) {
    var yrMin = 1900;
    var yrMax = (new Date().getFullYear()) + 100;
    var yrRng = "" + yrMin + ":" + yrMax + "";

    $("#" + objIdFrom).datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , dateFormat: _DefaultDate.substr(0, _DefaultDate.length - 2)
        , numberOfMonths: 1
        , yearRange: yrRng
        , onClose: function (selectedDate) { $("#" + objIdTo).datepicker("option", "minDate", selectedDate); }
    });

    if (isMinDatePicker($("#" + objIdFrom).val())) {
        $("#" + objIdFrom).val("");
    }

    if ((isNotNullFrom) && ($("#" + objIdFrom).val().length == 0)) {
        $("#" + objIdFrom).val(getDateCurrStr(false));
    }
    else {
        $("#" + objIdFrom).val(getDateStr($("#" + objIdFrom).val()));
    }

    // 

    $("#" + objIdTo).datepicker({
        defaultDate: "+1w"
        , changeMonth: true
        , changeYear: true
        , gotoCurrent: true
        , showOtherMonths: true
        , selectOtherMonths: true
        , dateFormat: _DefaultDate.substr(0, _DefaultDate.length - 2)
        , numberOfMonths: 1
        , yearRange: yrRng
        , onClose: function (selectedDate) { $("#" + objIdFrom).datepicker("option", "maxDate", selectedDate); }
    });

    if (isMinDatePicker($("#" + objIdTo).val())) {
        $("#" + objIdTo).val("");
    }

    if ((isNotNullTo) && ($("#" + objIdTo).val().length == 0)) {
        $("#" + objIdTo).val(getDateCurrStr(true));
    }
    else {
        $("#" + objIdTo).val(getDateStr($("#" + objIdTo).val()));
    }

    //

    reSetDatePickerFromTo(objIdFrom, objIdTo);
}

function reSetDatePickerFromTo(objIdFrom, objIdTo) {
    var yrMin = 1900;
    var yrMax = (new Date().getFullYear()) + 100;
    var dtFm = $("#" + objIdFrom).val();
    var dtTo = $("#" + objIdTo).val();

    if (dtFm.length == 0) {
        dtFm = new Date(yrMin, 0, 1);
    }

    if (dtTo.length == 0) {
        dtTo = new Date(yrMax, 11, 31);
    }

    $("#" + objIdTo).datepicker("option", "minDate", dtFm);
    $("#" + objIdFrom).datepicker("option", "maxDate", dtTo);
}

function clearDatePicker(objId) {
    $("#" + objId).val("");

    return false;
}

function clearDatePickerDob(objId) {
    clearDatePicker(objId);

    return false;
}

function clearDatePickerFromTo(objId, objIdFrom, objIdTo) {
    clearDatePicker(objId);
    reSetDatePickerFromTo(objIdFrom, objIdTo);

    return false;
}

function ajaxCallError(ky, req, status, errorObj) {
    alertErrMsg(("ky: " + ky + " ---> req: " + req + " ---> req.responseText: " + req.responseText + " ---> status: " + status + " ---> errorObject" + errorObj), "");
}

function loadSearch(pStartBy, pOrderByField, pOrderByDirection, isAjax) {
    //if (($("#divaSearchResult").exists()) && ($("#divSearchLoading").exists())) {
    if (isAjax) {
        showSearchLoading();
    }
    else {
        showDivPageLoading('Js');
    }

    if (pStartBy.length == 0) {
        pStartBy = "A";
    }

    if (pOrderByField.length == 0) {
        pOrderByField = "LastModifiedOn";
    }

    if (pOrderByDirection.length == 0) {
        pOrderByDirection = "D";
    }

    $("#StartBy").val(pStartBy);
    $("#OrderByField").val(pOrderByField);
    $("#OrderByDirection").val(pOrderByDirection);
    $("#CurrNumber").val(0);
    $("#CurrPageNumber").val(parseInt($("#CurrPageNumber").val(), 10) + 1);

    return false;
}

function setSearch(pStartBy, pOrderByField, pOrderByDirection) {
    loadSearch(pStartBy, pOrderByField, pOrderByDirection, false);
    $("#btnSearch").click();

    return false;
}

function setSort(pOrderByField, pOrderByDirection) {
    loadSearch($("#StartBy").val(), pOrderByField, pOrderByDirection, false);
    $("#btnSearch").click();

    return false;
}

function setEdit(pCurrNumber) {
    loadSearch('', '', '', false);
    $("#CurrNumber").val(pCurrNumber);
    $("#btnSearch").click();

    return false;
}

function expandDiv(ky) {
    $("#a" + ky + "E").fadeOut("fast", "linear", function () { $("#a" + ky + "C").fadeIn("slow", "linear", function () { }); });
    $("#div" + ky + "C").fadeIn("slow", "linear", function () { });

    return false;
}

function collapseDiv(ky) {
    $("#div" + ky + "C").fadeOut("slow", "linear", function () { });
    $("#a" + ky + "C").fadeOut("fast", "linear", function () { $("#a" + ky + "E").fadeIn("slow", "linear", function () { }); });

    return false;
}

function checkBoxChkAll(hdrID, dtaStrt, dtaEnd) {
    //[id^='...'] - The id must start with ....
    //[id*='...'] - The id must contains ....
    //[id$='...'] - The id must end with ....

    $('input[type="checkbox"][id^="' + dtaStrt + '"][id*="_"][id$="' + dtaEnd + '"]').attr("checked", $("#" + hdrID).is(":checked"));

    return true;
}

function checkBoxUnChkAll(hdrID, dtaStrt, dtaEnd) {
    //[id^='...'] - The id must start with ....
    //[id*='...'] - The id must contains ....
    //[id$='...'] - The id must end with ....

    var hasUnChk = false;
    var objs = $('input[type="checkbox"][id^="' + dtaStrt + '"][id*="_"][id$="' + dtaEnd + '"]');

    $.each(objs, function (i, obj) {
        if (!($(obj).is(':checked'))) {
            hasUnChk = true;
        }
    });

    $("#" + hdrID).attr("checked", (!(hasUnChk)));

    return true;
}

function fileBrowseChange(obj) {
    var selFileNm = $(obj).val();
    var isInValidFile = true;
    var validFilTyp = "";

    if ((selFileNm == null) || (selFileNm.length == 0)) {
        isInValidFile = false;
    }
    else {
        var selFileNmArr = selFileNm.split(".");
        var selFileTyp = selFileNmArr[selFileNmArr.length - 1];
        var validAccept = $(obj).attr("accept");

        if ((validAccept == null) || (validAccept.length == 0)) {
            isInValidFile = false;
        }
        else {
            selFileTyp = selFileTyp.toLowerCase();
            validAccept = validAccept.toLowerCase();

            var validAcceptArr = validAccept.split(",");

            $.each(validAcceptArr, function (i, validAcpt) {
                var validAcptArr = validAcpt.split("/");

                if (validAcptArr.length == 2) {
                    var validAcptTyp = validAcptArr[1];
                    validFilTyp = validFilTyp + validAcptTyp + ", ";

                    if (selFileTyp == validAcptTyp) {
                        isInValidFile = false;
                    }
                }
            });
        }
    }

    if (isInValidFile) {
        $(obj).val("");
        validFilTyp = validFilTyp.substr(0, validFilTyp.length - 2);

        var lstIndx = validFilTyp.lastIndexOf(",");

        if (lstIndx != -1) {
            validFilTyp = validFilTyp.splice(lstIndx, 1, " &");
        }

        alertErrMsg((AlertMsgs.get("INVALID_UPLOAD").replace(new RegExp("XKEYX", "g"), validFilTyp)), $(obj).attr("id"));
    }

    $("#txt" + ($(obj).attr("id"))).val($(obj).val());
}

function fileBrowseClick(obj) {
    var objId = $(obj).attr("id");
    objId = objId.substr(3, (objId.length - 3));

    $("#" + objId).click();
}

// http://stackoverflow.com/questions/2255291/print-the-contents-of-a-div
function printDivElem(elem) {
    return printDivPopup($(elem).html());
}

function printDivPopup(data) {
    var mywindow = window.open("", 'my div', 'height=400,width=600');
    mywindow.document.write('<html><head><title>my div</title>');
    mywindow.document.write('</head><body >');
    mywindow.document.write(data);
    mywindow.document.write('</body></html>');
    mywindow.document.close();
    mywindow.print();
    return true;
}

function alertErrMsg(msg, objID) {
    if (msg == null) {
        msg = "";
    }
    else {
        msg = $.trim(msg);
    }

    _AlertMsgID = objID;

    $("#divErrMsgInner").html(msg);
    $("#divErrMsg").fadeIn("slow", "linear", function () { $("#aErrClose").focus(); });

    hideDivPageLoading("Js");
}

function hideSuccErrMsgDiv(objId) {
    $("#" + objId).fadeOut("slow");

    if ((_AlertMsgID != null) && (_AlertMsgID.length > 0)) {
        try {
            $("#" + _AlertMsgID).focus();
        }
        catch (err) {
            //
        }
    }

    return false;
}

// http://api.jquery.com/jQuery.trim/
function blurTrim(obj) {
    keyUpTrim(obj);

    unRegisterBlurFn();
    return true;
}

function blurTrimPwd(obj) {
    $(obj).val($.trim($(obj).val()));

    unRegisterBlurFn();
    return true;
}

// Key Up

function keyUpTrim(obj) {
    $(obj).val($.trim($(obj).val()));
    $(obj).val($(obj).val().toUpperCase());

    return true;
}

function keyUpUIntNumeric(obj) {
    if ($(obj).val().length > 0) {
        var i = 0;

        for (i = 0; i < $(obj).val().length; i++) {
            var lastChar = $(obj).val().substr(i, 1);

            if (validIsIntNumericChar(lastChar)) {
                continue;
            }

            $(obj).val(($(obj).val().substr(0, i)) + "" + ($(obj).val().substr((i + 1), ($(obj).val().length - i))));
            return keyUpUIntNumeric(obj);
        }
    }

    return true;
}

function keyUpUIntNumericLen(obj, maxLen) {
    keyUpUIntNumeric(obj);

    if ($(obj).val().length > parseInt(maxLen, 10)) {
        $(obj).val($(obj).val().substr(0, parseInt(maxLen, 10)));
    }

    return true;
}

function keyUpIntNumeric(obj) {
    if ($(obj).val().length > 0) {
        var i = 0;

        for (i = 0; i < $(obj).val().length; i++) {
            var lastChar = $(obj).val().substr(i, 1);

            if ((i == 0) && (lastChar == "-")) {
                continue;
            }

            if (validIsIntNumericChar(lastChar)) {
                continue;
            }

            $(obj).val(($(obj).val().substr(0, i)) + "" + ($(obj).val().substr((i + 1), ($(obj).val().length - i))));
            return keyUpIntNumeric(obj);
        }
    }

    return true;
}

function keyUpIntNumericLen(obj, maxLen) {
    keyUpIntNumeric(obj);

    if ($(obj).val().length > parseInt(maxLen, 10)) {
        $(obj).val($(obj).val().substr(0, parseInt(maxLen, 10)));
    }

    return true;
}

function keyUpUNumeric(obj) {
    if ($(obj).val().length > 0) {
        var i = 0;
        var hasDeciPoint = false;

        for (i = 0; i < $(obj).val().length; i++) {
            var lastChar = $(obj).val().substr(i, 1);

            if ((!(hasDeciPoint)) && (lastChar == ".")) {
                hasDeciPoint = true;
                continue;
            }

            if (validIsIntNumericChar(lastChar)) {
                continue;
            }

            $(obj).val(($(obj).val().substr(0, i)) + "" + ($(obj).val().substr((i + 1), ($(obj).val().length - i))));
            return keyUpUNumeric(obj);
        }
    }

    return true;
}

function keyUpUNumericLen(obj, maxLen) {
    keyUpUNumeric(obj);

    if ($(obj).val().length > parseInt(maxLen, 10)) {
        $(obj).val($(obj).val().substr(0, parseInt(maxLen, 10)));
    }

    return true;
}

function keyUpNumeric(obj) {
    if ($(obj).val().length > 0) {
        var i = 0;
        var hasDeciPoint = false;

        for (i = 0; i < $(obj).val().length; i++) {
            var lastChar = $(obj).val().substr(i, 1);

            if ((i == 0) && (lastChar == "-")) {
                continue;
            }

            if ((!(hasDeciPoint)) && (lastChar == ".")) {
                hasDeciPoint = true;
                continue;
            }

            if (validIsIntNumericChar(lastChar)) {
                continue;
            }

            $(obj).val(($(obj).val().substr(0, i)) + "" + ($(obj).val().substr((i + 1), ($(obj).val().length - i))));
            return keyUpNumeric(obj);
        }
    }

    return true;
}

function keyUpNumericLen(obj, maxLen) {
    keyUpNumeric(obj);

    if ($(obj).val().length > parseInt(maxLen, 10)) {
        $(obj).val($(obj).val().substr(0, parseInt(maxLen, 10)));
    }

    return true;
}

function validIsIntNumericChar(lastChar) {
    var validChars = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
    var i = 0;

    for (i = 0; i < validChars.length; i++) {
        if (lastChar == validChars[i]) {
            return true;
        }
    }

    return false;
}

// Blur

// http://jquerybyexample.blogspot.in/2011/04/validate-email-address-using-jquery.html
// http://jsfiddle.net/jquerybyexample/DxPuU/
function blurValidateEmail(obj) {
    var address = $(obj).val();

    if (address.length == 0) {

        unRegisterBlurFn();
        return true;
    }

    var filter = /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{1,4}$/;

    if (filter.test(address)) {

        unRegisterBlurFn();
        return true;
    }

    alertErrMsg(AlertMsgs.get("INVALID_EMAIL"), $(obj).attr("id"));
    $(obj).val("");
    unRegisterBlurFn();
    return false;
}

// http: //stackoverflow.com/questions/2723140/validating-url-with-jquery-without-the-validate-plugin
function blurValidateWeb(obj) {

    var address = $(obj).val();

    if (address.length == 0) {

        unRegisterBlurFn();
        return true;
    }

    var filter = /^([a-z]([a-z]|\d|\+|-|\.)*):(\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?((\[(|(v[\da-f]{1,}\.(([a-z]|\d|-|\.|_|~)|[!\$&'\(\)\*\+,;=]|:)+))\])|((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=])*)(:\d*)?)(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*|(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)){0})(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/;

    if (filter.test(address)) {

        unRegisterBlurFn();
        return true;
    }

    alertErrMsg(AlertMsgs.get("INVALID_WEB"), $(obj).attr("id"));
    $(obj).val("");
    unRegisterBlurFn();
    return false;
}

function blurValidatePhone(obj) {
    keyUpUIntNumericLen(obj, 10);

    if ($(obj).val().length > 0) {
        if ($(obj).val().length == 0) {
            unRegisterBlurFn();
            return true;
        }

        if ($(obj).val().length != 10) {
            alertErrMsg(AlertMsgs.get("INVALID_PHONE"), $(obj).attr("id"));
            $(obj).val("");
            unRegisterBlurFn();
            return false;
        }
        else {
            $(obj).val("(" + $(obj).val().substr(0, 3) + ")" + $(obj).val().substr(3, 3) + "-" + $(obj).val().substr(6, 4));
        }
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateZip(obj) {
    keyUpUIntNumericLen(obj, 9);

    if ($(obj).val().length > 0) {
        if ($(obj).val().length == 0) {
            unRegisterBlurFn();
            return true;
        }

        if ($(obj).val().length == 9) {
            $(obj).val($(obj).val().substr(0, 5) + '-' + $(obj).val().substr(5, 4));
        }
        else if ($(obj).val().length == 5) {
            $(obj).val($(obj).val() + '-0000');
        }
        else {
            alertErrMsg(AlertMsgs.get("INVALID_ZIP"), $(obj).attr("id"));
            $(obj).val("");
            unRegisterBlurFn();
            return false;
        }
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateUIntNumber(obj) {
    keyUpUIntNumeric(obj);

    if ($(obj).val().length > 0) {
        $(obj).val(parseInt($(obj).val(), 10));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateUIntNumberLen(obj, maxLen) {
    keyUpUIntNumericLen(obj, maxLen);

    if ($(obj).val().length > 0) {
        $(obj).val(parseInt($(obj).val(), 10));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateIntNumber(obj) {
    keyUpIntNumeric(obj);

    if ($(obj).val().length > 0) {
        $(obj).val(parseInt($(obj).val(), 10));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateIntNumberLen(obj, maxLen) {
    keyUpIntNumericLen(obj, maxLen);

    if ($(obj).val().length > 0) {
        $(obj).val(parseInt($(obj).val(), 10));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateUNumber(obj) {
    keyUpUNumeric(obj);

    if ($(obj).val().length > 0) {
        $(obj).val(parseFloat($(obj).val()));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateUNumberLen(obj, maxLen) {
    keyUpUNumericLen(obj, maxLen);

    if ($(obj).val().length > 0) {
        $(obj).val(parseFloat($(obj).val()));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateNumber(obj) {
    keyUpNumeric(obj);

    if ($(obj).val().length > 0) {
        $(obj).val(parseFloat($(obj).val()));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateNumberLen(obj, maxLen) {
    keyUpNumericLen(obj, maxLen);

    if ($(obj).val().length > 0) {
        $(obj).val(parseFloat($(obj).val()));
    }

    unRegisterBlurFn();
    return true;
}

function blurValidateDatePicker(obj) {
    keyUpUIntNumeric(obj);

    if ($(obj).val().length > 0) {
        if ($(obj).val().length == 0) {

            unRegisterBlurFn();
            return true;
        }

        if ($(obj).val().length != 8) {
            alertErrMsg(AlertMsgs.get("INVALID_DATE"), $(obj).attr("id"));
            $(obj).val("");
            unRegisterBlurFn();
            return false;
        }
        else {
            $(obj).val($(obj).val().substr(0, 2) + _DefaultDateSeparator + $(obj).val().substr(2, 2) + AlertMsgs.get("DEFAULT_DATE_SEPARATOR") + $(obj).val().substr(4, 4));

            if (!(validateIsDate($(obj).val()))) {
                alertErrMsg(AlertMsgs.get("INVALID_DATE"), $(obj).attr("id"));
                $(obj).val("");
                unRegisterBlurFn();
                return false;
            }
        }
    }
    else {
        $(obj).val("");
    }

    unRegisterBlurFn();
    return true;
}

function subValidateDateRange(valDt1, valDt2) {
    var arrPastDate = valDt1.split(_DefaultDateSeparator);
    var arrFutureDate = valDt2.split(_DefaultDateSeparator);

    if (parseInt(arrPastDate[2], 10) < parseInt(arrFutureDate[2], 10)) {
        return true;
    }

    if (parseInt(arrPastDate[2], 10) > parseInt(arrFutureDate[2], 10)) {
        return false;
    }

    if (parseInt(arrPastDate[0], 10) < parseInt(arrFutureDate[0], 10)) {
        return true;
    }

    if (parseInt(arrPastDate[0], 10) > parseInt(arrFutureDate[0], 10)) {
        return false;
    }

    if (parseInt(arrPastDate[1], 10) > parseInt(arrFutureDate[1], 10)) {
        return false;
    }

    return true;
}

function blurValidateSsn(obj) {
    keyUpUIntNumeric(obj);

    if ($(obj).val().length > 0) {
        if ($(obj).val().length == 0) {
            unRegisterBlurFn();
            return true;
        }

        if ($(obj).val().length != 9) {
            alertErrMsg(AlertMsgs.get("INVALID_SSN"), $(obj).attr("id"));
            $(obj).val("");
            unRegisterBlurFn();
            return false;
        }
        else {
            if ($(obj).val().length == 9) {
                $(obj).val(($(obj).val().substr(0, 3) + "-" + $(obj).val().substr(3, 2) + "-" + $(obj).val().substr(5, 4)));
            }
            else {
                $(obj).val(defVal);
            }
        }
    }

    unRegisterBlurFn();
    return true;
}

function getRandomNumber() {
    // http://css-tricks.com/generate-a-random-number/
    var tday = new Date();
    var numRand = Math.floor(Math.random() * (tday.getMilliseconds() + tday.getSeconds()));
    return numRand;
}

function enlargePhoto(obj) {
    var srcNl = $(obj).attr("src");
    var srcEn = $("#imgEnlargePhoto").attr("src");
    if (srcEn != srcNl) {
        $("#imgEnlargePhoto").attr("src", srcNl);
    }

    $("#divEnlargePhoto").fadeIn();
    return false;
}

function resizePhoto() {
    $("#divEnlargePhoto").fadeOut();

    return false;
}

function printFile(wUrl) {
    // http://www.w3schools.com/jsref/met_win_open.asp
    var wName = "ClaimatePrime";
    var wFeatures = "channelmode='0', directories='0', fullscreen='1', height='0px', left='0px', location='0', menubar='1', resizable='0', scrollbars='1', status='0', titlebar='0', toolbar='0', top='0px', width='0px'";
    var wReplace = true;

    window.open(wUrl, wName, wFeatures, wReplace);

    return false;
}

function printImage() {
    return printFile($("#imgEnlargePhoto").attr("src"));
}

function windowScrlTop() {
    location.hash = "#divWindowTop";
}

// String Prototype -- Starts

String.prototype.startsWith = function (str) { return (this.match("^" + str) == str); }
String.prototype.endsWith = function (str) { return (this.match(str + "$") == str); }
String.prototype.contains = function (str) { return (this.indexOf(str) != (-1)); }
String.prototype.splice = function (idx, remLen, str) { return (this.slice(0, idx) + str + this.slice(idx + Math.abs(remLen))); };
String.prototype.startsAlpha = function () { if (this.length == 0) { return false; } else { if (AlertMsgs.get("START_CHAR").indexOf(this.substr(0, 1).toUpperCase()) == -1) { return false; } else { return true; } } }

// String Prototype -- Ends

// jQuery Prototype -- Starts

jQuery.fn.exists = function () { return this.length > 0; }

// jQuery Prototype -- Starts