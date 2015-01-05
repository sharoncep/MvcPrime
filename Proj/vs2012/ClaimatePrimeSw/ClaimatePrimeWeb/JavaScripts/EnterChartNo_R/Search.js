$(document).ready(function () {

    setAutoComplete("ChartNo");

    _AlertMsgID = "ChartNo";
    $("#" + _AlertMsgID).focus();
});

function ChartNoID() {
}

function validateSave() {
    if (canSubmit()) {
        showDivPageLoading("Js");

        if ($("#ChartNo").val().length == 0) {
            alertErrMsg(AlertMsgs.get("CHART_NO"), "ChartNo");
            return false;
        }
        return true;
    }
    return false;
}