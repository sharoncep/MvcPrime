$(document).ready(function () { });

function saveSuccessProvider(jsonData) {

    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<table class=\"table-view\">";

        if (!(d.IS_ACTIVE)) {
            retAns = retAns + "<tr>";
            retAns = retAns + "<td colspan = \"4\" class=\"td-insblocked\">";
            retAns = retAns + AlertMsgs.get("BLOCKED");
            retAns = retAns + "</td>";
            retAns = retAns + "</tr>";
        }

        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("CLINIC_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.CLINIC_NAME;

        retAns = retAns + "</td>";

        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("LASTNAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.LAST_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FNAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FIRST_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("MID_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.MIDDLE_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CREDENTIAL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CREDENTIAL;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.SEX != null) {
            retAns = retAns + d.SEX;
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("NPI");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.NPI;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("TAX_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TAX_ID;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SSN");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SSN;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PRIMARY_OPTION");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.IS_TAX_ID_PRIMARY_OPTION) {
            retAns = retAns + AlertMsgs.get("TAX_ID");
        }
        else {
            retAns = retAns + AlertMsgs.get("SSN");
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SPECIALTY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SPECIALTY_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PHOTO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td class=\"td-image\">";
        retAns = retAns + " <ul class=\"ul_imgEnlarge\">";
        retAns = retAns + "<li class=\"imgPhoto\">";
        retAns = retAns + " <img id=\"imgPhoto\" src=\"";
        retAns = retAns + d.PHOTO_REL_PATH;
        retAns = retAns + "\" alt=\"\" style=\"width: 60px; height: 60px;\" onclick=\"javascript:return enlargePhoto(this);\" title=\" ";
        retAns = retAns + AlertMsgs.get("ENLARGE_CLICK");
        retAns = retAns + "\" />";
        retAns = retAns + "</li></ul></td>";
       
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("HAS_SIGN_FILE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.IS_SIGNED_FILE) {
            retAns = retAns + AlertMsgs.get("YES");
        }
        else {
            retAns = retAns + AlertMsgs.get("NO");
        }
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SIGN_DATE");
        retAns = retAns + "</td>";

        retAns = retAns + "<td>";
        retAns = retAns + d.SIGNED_DATE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("LICENSE_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.LICENSE_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CLIA_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CLIA_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td class=\"td-heading\" colspan=\"4\">";
        retAns = retAns + "<div class=\"dv-subheading-view\">";
        retAns = retAns + AlertMsgs.get("CONT_DETAILS");
        retAns = retAns + " </div>";
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PHONE_NUMBER;
        retAns = retAns + "</td>";

        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECONDARY_PHONE_NUMBER;
        retAns = retAns + "</td>";

        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.EMAIL
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECONDARY_EMAIL;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FAX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FAX;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "</table>";
    }
    $("#divProviderTable").html(retAns);
    return false;
}
