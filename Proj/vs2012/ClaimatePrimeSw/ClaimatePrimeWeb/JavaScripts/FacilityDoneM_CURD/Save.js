$(document).ready(function () {

    setAutoComplete("FacilityDone_FacilityType","FacilityType");
    setAutoComplete("FacilityDone_State","StateName");
    setAutoComplete("FacilityDone_County","CountyName");
    setAutoComplete("FacilityDone_Country","CountryName");
    setAutoComplete("FacilityDone_City","CityName");

    _AlertMsgID = "FacilityDone_FacilityDoneCode";
    $("#" + _AlertMsgID).focus();
});

function FacilityTypeID(selId) {
   

}
function StateNameID(selId) {
  

}

function CountyNameID(selId) {
  

}
function CountryNameID(selId) {
    

}
function CityNameID(selId) {
    

}
function validateSave() {

    if (canSubmit()) {
        if (!(($('#FacilityDone_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");

        if ($("#FacilityDone_FacilityDoneCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "FacilityDone_FacilityDoneCode");
            return false;
        }
        if ($("#FacilityDone_FacilityDoneName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "FacilityDone_FacilityDoneName");
            return false;
        }
        if ($("#FacilityDone_FacilityType").val() == 0) {
            alertErrMsg(AlertMsgs.get("FACILITY_TYPE"), "FacilityDone_FacilityType");
            return false;
        }
        return true;

    }
    return false;

}