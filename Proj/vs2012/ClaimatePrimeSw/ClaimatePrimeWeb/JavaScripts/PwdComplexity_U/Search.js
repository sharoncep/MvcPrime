$(document).ready(function () {
    setAutoComplete("mMinLength", "MinimumLength");
    setAutoComplete("mMaxLength", "MaximumLength");
    setAutoComplete("mUpperCaseMinCount", "UpperCaseMinCount");
    setAutoComplete("mNumberMinCount", "NumbersMinCount");
    setAutoComplete("mSplCharCount", "SpecialCharMinCount");
    setAutoComplete("mExpiryDayMaxCount", "MaximumPassAge");
    setAutoComplete("mTrialMaxCount", "PassTrialMaxCount");
    setAutoComplete("mHistoryReuseStatus", "HistoryPassReuseStat");

    _AlertMsgID = "mMinLength";
    $("#" + _AlertMsgID).focus();
});

function MinimumLengthID() {
}

function MaximumLengthID() {

}

function UpperCaseMinCountID() {
    if ($("#mUpperCaseMinCount").val().length == 0) {
        $("#mUpperCaseMinCount").val(0);
        $("#mUpperCaseMinCountID").val(0);
    }
}

function NumbersMinCountID() {
    if ($("#mNumberMinCount").val().length == 0) {
        $("#mNumberMinCount").val(0);
        $("#mNumberMinCountID").val(0);
    }
}

function SpecialCharMinCountID() {
    if ($("#mSplCharCount").val().length == 0) {
        $("#mSplCharCount").val(0);
        $("#mSplCharCountID").val(0);
    }
}

function MaximumPassAgeID() {
    if ($("#mExpiryDayMaxCount").val().length == 0) {
        $("#mExpiryDayMaxCount").val(0);
        $("#mExpiryDayMaxCountID").val(0);
    }
}

function PassTrialMaxCountID() {
}

function HistoryPassReuseStatID() {
    if ($("#mHistoryReuseStatus").val().length == 0) {
        $("#mHistoryReuseStatus").val(0);
        $("#mHistoryReuseStatusID").val(0);
    }
}

function validateSave() {

    if (canSubmit()) {
        showDivPageLoading("Js");

        if (($("#mMinLength").val().length == 0) || (($("#mMinLength").val() == 0)) || ($("#mMinLengthID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("MIN_LENGTH_ERR"), "mMinLength");
            return false;
        }

        if (($("#mMaxLength").val().length == 0) || (($("#mMaxLength").val() == 0)) || ($("#mMaxLengthID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("MAX_LENGTH_ERR"), "mMaxLength");
            return false;
        }

        if (($("#mUpperCaseMinCount").val().length == 0) || ($("#mUpperCaseMinCountID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("UPPER_CASE_MIN_COUNT_ERR"), "mUpperCaseMinCount");
            return false;
        }

        if (($("#mNumberMinCount").val().length == 0) || ($("#mNumberMinCountID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("NUM_MIN_COUNT_ERR"), "mNumberMinCount");
            return false;
        }

        if (($("#mSplCharCount").val().length == 0) || ($("#mSplCharCountID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("SPECIAL_CHAR_MIN_COUNT_ERR"), "mSplCharCount");
            return false;
        }

        if (($("#mExpiryDayMaxCount").val().length == 0) || ($("#mExpiryDayMaxCountID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("PWD_AGE_ERR"), "mExpiryDayMaxCount");
            return false;
        }

        if (($("#mTrialMaxCount").val().length == 0) || (($("#mTrialMaxCount").val() == 0)) || ($("#mTrialMaxCountID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("TRIAL_MAX_COUNT_ERR"), "mTrialMaxCount");
            return false;
        }

        if (($("#mHistoryReuseStatus").val().length == 0) || ($("#mHistoryReuseStatusID").val().length == 0)) {
            alertErrMsg(AlertMsgs.get("REUSE_STAT_ERR"), "mHistoryReuseStatus");
            return false;
        }

        if (!(confirm(AlertMsgs.get("RESET_ALERT_CHANGE")))) {
            hideDivPageLoading("Js");
            return false;
        }

        return true;
    }
    return false;
}