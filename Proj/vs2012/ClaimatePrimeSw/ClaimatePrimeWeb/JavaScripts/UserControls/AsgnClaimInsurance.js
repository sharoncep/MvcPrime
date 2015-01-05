$(document).ready(function () { });

function saveSuccessInsurance(jsonData) {

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
        //retAns = retAns + "<tr>";
        //retAns = retAns + "<td class=\"td-mandatory\" colspan=\"4\"></td>";
        //retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.INSURANCE_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.INSURANCE_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PAYERID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PAYER_ID
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("INSURANCETYPE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.INSURANCE_TYPE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EDI_RECEIVER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.EDI_RECEIVER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PRINT_PIN_ON_FILE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PRINT_PIN
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PRINT_SIGN_ON_FILE_PAT");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PATIENT_PRINT_SIGN
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PRINT_SIGN_ON_FILE_INS");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.INSURED_PRINT_SIGN
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PRINT_SIGN_ON_FILE_PROV");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PHYSICIAN_PRINT_SIGN
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td class=\"td-heading\" colspan=\"4\">";
        retAns = retAns + "<div class=\"dv-subheading-view\">";
        retAns = retAns + AlertMsgs.get("OFFICE_ADDRESS");
        retAns = retAns + "</div>";
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("STREET");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.STREET_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SUITE_NO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SUITE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CITY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CITY
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("STATE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.STATE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("COUNTY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COUNTY
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("COUNTRY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COUNTRY
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PHONE_NUMBER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EXTENSION");
        retAns = retAns + "</td >";
        retAns = retAns + "<td>";
        retAns = retAns + d.PHONE_NUMBER_EXTN
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECONDARY_PHONE_NUMBER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EXTENSION");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECONDARY_PHONE_NUMBER_EXTN
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
        retAns = retAns + d.SECONDARY_EMAIL
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FAX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FAX
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "</table>";
    }

    $("#divInsuranceC").html(retAns);
    return false;
}
