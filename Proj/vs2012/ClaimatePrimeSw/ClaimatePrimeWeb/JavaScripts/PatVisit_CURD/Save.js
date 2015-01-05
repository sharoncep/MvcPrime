$(document).ready(function () {
    objs = $('input[type="text"][id^="DOSs"][id*="_"]');

    $.each(objs, function (i, obj) {
        setDatePickerDob($(obj).attr("id"), true);
        clearDatePickerDob($(obj).attr("id"))
    });
});

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");
        var objs = $('input[type="text"][id^="DOSs_"][id$="_"]');
        var hasVal = false;
        $.each(objs, function (i, obj) {
            if ((!hasVal) & ($(obj).val().length > 0)) {
                hasVal = true;
            }
        });

        if (hasVal) {
            return true;
        }
        alertErrMsg(AlertMsgs.get("DOS_ERROR"), "DOSs_0_");
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

    //$("#DOSs_" + (parseInt($("#txtShowMore").val(), 10) - 4).toString() + "_").focus();

    return false;
}