$(document).ready(function () {

    setAutoComplete("mPageLockIdleTimeInMin", "PageLockIdleTimeInMin");
    setAutoComplete("mSessionOutFromPageLockInMin", "SessionOutFromPageLockInMin");
    setAutoComplete("mSearchRecordPerPage", "SearchRecordPerPage");
    setAutoComplete("mBACompleteFromDOSInDay", "BACompleteFromDOSInDay");
    setAutoComplete("mQACompleteFromDOSInDay", "QACompleteFromDOSInDay");
    setAutoComplete("mEDIFileSentFromDOSInDay", "EDIFileSentFromDOSInDay");
    setAutoComplete("mClaimDoneFromDOSInDay", "ClaimDoneFromDOSInDay");
    setAutoComplete("mUploadMaxSizeInMB", "UploadMaxSizeInMB");

    _AlertMsgID = "mUserAccEmailSubject";
    $("#" + _AlertMsgID).focus();

});

function PageLockIdleTimeInMinID() {
}

function SearchRecordPerPageID() {
}

function SessionOutFromPageLockInMinID() {
}

function BACompleteFromDOSInDayID() {
}

function QACompleteFromDOSInDayID() {
}

function EDIFileSentFromDOSInDayID() {
}

function ClaimDoneFromDOSInDayID() {
}

function UploadMaxSizeInMBID() {
}

function validateSave() {

    if (canSubmit()) {
        showDivPageLoading("Js");

        if (($("#mUserAccEmailSubject").val().length == 0) || ($("#mUserAccEmailSubject").val() == 0)) {
            alertErrMsg(AlertMsgs.get("USER_CRED_SUB"), "mUserAccEmailSubject");
            return false;
        }

        if (($("#mSearchRecordPerPage").val().length == 0) || ($("#mSearchRecordPerPage").val() == 0)) {
            alertErrMsg(AlertMsgs.get("SEARCH_REC"), "mSearchRecordPerPage");
            return false;
        }

        if (($("#mPageLockIdleTimeInMinID").val().length == 0) || ($("#mPageLockIdleTimeInMinID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("PAGE_AUTOLOCK"), "mPageLockIdleTimeInMin");
            return false;
        }

        if (($("#mSessionOutFromPageLockInMinID").val().length == 0) || ($("#mSessionOutFromPageLockInMinID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("SESSION_TIMEOUT"), "mSessionOutFromPageLockInMin");
            return false;
        }

        if ((($("#mSessionOutFromPageLockInMinID").val()) < (3 * ($("#mPageLockIdleTimeInMinID").val())))) {
            alertErrMsg(AlertMsgs.get("TIMEOUT_CHECK_ERROR"), "mSessionOutFromPageLockInMin");
            return false;
        }

        if (($("#mBACompleteFromDOSInDayID").val().length == 0) || ($("#mBACompleteFromDOSInDayID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("MAX_DAYS_DOC_ATTACH"), "mBACompleteFromDOSInDay");
            return false;
        }

        if (($("#mQACompleteFromDOSInDayID").val().length == 0) || ($("#mQACompleteFromDOSInDayID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("MAX_DAYS_DOS_CREATE_CLAIM"), "mQACompleteFromDOSInDay");
            return false;
        }

        if (($("#mEDIFileSentFromDOSInDayID").val().length == 0) || ($("#mEDIFileSentFromDOSInDayID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("MAX_DAYS_QA_CLAIM_CONF"), "mEDIFileSentFromDOSInDay");
            return false;
        }

        if (($("#mClaimDoneFromDOSInDayID").val().length == 0) || ($("#mClaimDoneFromDOSInDayID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("MAX_DAYS_KEEP_STAT_HOLD"), "mClaimDoneFromDOSInDay");
            return false;
        }

        if (($("#mUploadMaxSizeInMBID").val().length == 0) || ($("#mUploadMaxSizeInMBID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("UPLOAD_MAX_SIZE_IN_MB"), "mUploadMaxSizeInMB");
            return false;
        }
        return true;
    }
    return false;
}