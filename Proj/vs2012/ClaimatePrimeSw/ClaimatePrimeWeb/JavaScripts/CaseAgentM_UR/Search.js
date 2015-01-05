$(document).ready(function () {
    setDatePickerFromTo("DateFrom", false, "DateTo", false);

    var objs = $('input[type="text"][id^="ClaimAgentResults"][id*="_"][id$="TARGET_BA_USER"]');

    $.each(objs, function (i, obj) {
       
        setAutoComplete($(obj).attr("id"), 'TargetBAUserName');
    });
    var objs = $('input[type="text"][id^="ClaimAgentResults"][id*="_"][id$="TARGET_EA_USER"]');

    $.each(objs, function (i, obj) {
        setAutoComplete($(obj).attr("id"), 'TargetEAUserName');
    });

    var objs = $('input[type="text"][id^="ClaimAgentResults"][id*="_"][id$="TARGET_QA_USER"]');

    $.each(objs, function (i, obj) {
        setAutoComplete($(obj).attr("id"), 'TargetQAUserName');
    });

});

function TargetBAUserNameID(selId) {

   
}
function TargetEAUserNameID(selId) {


}

function TargetQAUserNameID(selId) {


}

function validateSave() {
    if (canSubmit()) {
        return true;
    }
    return false;
}