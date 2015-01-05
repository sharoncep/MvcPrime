$(document).ready(function () {
    setDatePickerFromTo("PatientDocumentResult_ServiceOrFromDate", true, "PatientDocumentResult_ToDate", false);

    setAutoComplete("PatientDocumentResult_Patient", "ChartNumberPatient");
    setAutoComplete("PatientDocumentResult_DocumentCategory", "DocCategory");

    _AlertMsgID = "ChartNumberPatient";
    $("#" + _AlertMsgID).focus();

    DocCategoryID();
});

function ChartNumberPatientID() {
}

function DocCategoryID() {
    if ($("#PatientDocumentResult_DocumentCategoryID").val() != "0") {
        var params = "{'pDocumentCategoryID' : '" + $("#PatientDocumentResult_DocumentCategoryID").val() + "'}";   // if no params need to use "{}"

        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/IsInPatAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                isInPatientSuccess(data, status);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("MedicalRecords_CR --> SearchAjaxCall", req, status, errorObj);
            }
        });
    }
}

function isInPatientSuccess(data, status) {
    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                var d = jsonData[0];

                if (d) {
                    $("#liServiceDate").show();
                    $("#spanServiceDate").hide();
                    $("#spanFromDate").show();
                    $("#litoDate").show();
                }
                else {
                    $("#liServiceDate").show();
                    $("#spanServiceDate").show();
                    $("#spanFromDate").hide();
                    $("#litoDate").hide();
                }
            }
        }
    }
}

function validateSave() {
    if (canSubmit()) {
        if (!(($('#PatientDocumentResult_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }

        showDivPageLoading("Js");

        if ($("#PatientDocumentResult_PatientID").val() == 0) {
            alertErrMsg(AlertMsgs.get("CHART_NO"), "PatientDocumentResult_PatientID");
            return false;
        }
        if ($("#PatientDocumentResult_DocumentCategoryID").val() == 0) {
            alertErrMsg(AlertMsgs.get("DOCUMENT_CATEGORY_NAME"), "PatientDocumentResult_DocumentCategoryID");
            return false;
        }
        if ($("#PatientDocument_ServiceOrFromDate").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FROM_DATE"), "PatientDocument_ServiceOrFromDate");
            return false;
        }
        return true;
    }

    return false;
}