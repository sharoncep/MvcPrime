$(document).ready(function () {
    setAutoComplete("DiagName", "DiagName", "txtDescTypeDx");

    _AlertMsgID = "DiagName";
    $("#" + _AlertMsgID).focus();
});

function DiagNameID() {

}

function saveSuccessDx(jsonData) {
    $("#DiagName").val("");
    $("#DiagNameID").val("");

    var i = -1;
    var retAns = "";
    var CLAIM_NO_PREV = -1;

    //retAns = retAns + "<div class=\"dv-subheading-cpt\">";
    //retAns = retAns + AlertMsgs.get("SEL_DX_LIST");
    //retAns = retAns + "</div>";

    retAns = retAns + "<div>";
    retAns = retAns + "<table class=\"table-grid-view-claim\">";

    for (i in jsonData) {
        var d = jsonData[i];

        if (CLAIM_NO_PREV != d.CLAIM_NUMBER) {
            CLAIM_NO_PREV = d.CLAIM_NUMBER

            retAns = retAns + "<tr class=\"tr-claim-number\">";
            retAns = retAns + "<td colspan=\"2\">";
            retAns = retAns + AlertMsgs.get("CLAIM_NUMBER");
            retAns = retAns + " : ";
            retAns = retAns + d.CLAIM_NUMBER;
            retAns = retAns + "</td>";
            retAns = retAns + "</tr>";

        }

        retAns = retAns + "<tr>";
        retAns = retAns + "<td title=\"";
        retAns = retAns + d.NAME_CODE;
        retAns = retAns + "\">";
        retAns = retAns + d.NAME_CODE;
        retAns = retAns + "</td>";

        retAns = retAns + "<td title=\"";
        retAns = retAns + AlertMsgs.get("REMOVE");
        retAns = retAns + "\">";

        retAns = retAns + "<a id=\"";
        retAns = retAns + d.CLAIM_DIAGNOSIS_ID
        retAns = retAns + "\" ";
        retAns = retAns + "href=\"#\" class=\"aDelete1\" onclick=\"javascript:return removeDx(this);\">";
        retAns = retAns + "</a>";

        retAns = retAns + "</td>";

        //assign primary dx and procedure dx field with first dx from dx list
        if (($("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val().length == 0) || ($("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val() == 0)) {
            $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val(d.CLAIM_DIAGNOSIS_ID);
            $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosis").val(d.NAME_CODE);

            $("#DiagNameProID").val(d.CLAIM_DIAGNOSIS_ID);
            $("#DiagNamePro").val(d.NAME_CODE);
        }
    }

    retAns = retAns + "</table>";
    retAns = retAns + "</div>";

    retAns = retAns + "</table>";
    retAns = retAns + "</div>";

    if (i != -1) {
        $("#divSelDxList").html(retAns);
        $("#txtDxCount").val((parseInt(i, 10) + 1));
    }
    else {
        $("#divSelDxList").html("");
    }

    return false;
}

function saveDx() {

    if (canSubmit()) {
        if (($("#DiagNameID").val().length == 0) || ($("#DiagNameID").val() == 0)) {
            alertErrMsg(AlertMsgs.get("DX_NAME"), "DiagName");
            return false;
        }

        $("#divDxC").removeAttr("class");
        $("#divDxC").attr("class", "dv-claim-loading");

        var params = "{'pDiagnosisID' : '" + $("#DiagNameID").val() + "'}";   // if no params need to use "{}"
        $.ajax({
            url: (_AppDomainPath + _CtrlrName + "/SaveDxAjaxCall/0/0/"),
            type: 'POST',
            data: params,
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            success: function (data, status) {
                saveDxSuccess(data, status);
            },
            error: function (req, status, errorObj) {
                ajaxCallError("AssgnClaims_R --> SaveDxAjaxCall", req, status, errorObj);

                $("#divDxC").removeAttr("class");
                $("#divDxC").attr("class", "dv-bdr");
            }
        });

        return true;
    }
    return false;
}

function saveDxSuccess(data, status) {

    if (data != null) {
        if (status.toLowerCase() == 'success') {
            var jsonData = data;
            if (jsonData != null) {
                for (i in jsonData) {
                    var d = jsonData[0];

                    if (d.length == 0) {
                        reLoadPnlDiv("Dx");
                        $("#divCptC").attr("title", "");
                        collapsePnlDiv("Cpt");
                    }
                    else {
                        alertErrMsg(AlertMsgs.get("SAVE_ERROR").replace(new RegExp("XKEYX", "g"), d), "DiagName");

                        $("#divDxC").removeAttr("class");
                        $("#divDxC").attr("class", "dv-bdr");
                    }
                }
            }
        }
    }
}

function descTypeClickDx(obj) {
    var preVal = $("#txtDescTypeDx").val();
    var curVal = $(obj).val();

    if (preVal != curVal) {
        $("#divDxC").removeAttr("class");
        $("#divDxC").attr("class", "dv-claim-loading");

        $("#txtDescTypeDx").val(curVal);
        $("#DiagName").val("");
        $("#DiagNameID").val("");
        reLoadPnlDiv("Dx");
    }

    return true;
}

function removeDx(obj) {

    if ($(obj).attr("id") == $("#PatientVisit_PatientVisitResult_PrimaryClaimDiagnosisID").val()) {
        alertErrMsg(AlertMsgs.get("DX_DEL_ERROR"));
        return false;
    }
    if (!(confirm(AlertMsgs.get("DELETE_CONFIRM")))) {
        return false;
    }

    $("#divDxC").removeAttr("class");
    $("#divDxC").attr("class", "dv-claim-loading");

    var params = "{'pClaimDiagnosisID' : '" + $(obj).attr("id") + "'}";   // if no params need to use "{}"
    $.ajax({
        url: (_AppDomainPath + _CtrlrName + "/RemoveDxAjaxCall/0/0/"),
        type: 'POST',
        data: params,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        success: function (data, status) {
            saveDxSuccess(data, status);
        },
        error: function (req, status, errorObj) {
            ajaxCallError("AssgnClaims_R --> RemoveDxAjaxCall", req, status, errorObj);

            $("#divDxC").removeAttr("class");
            $("#divDxC").attr("class", "dv-bdr");
        }
    });

    return false;
}