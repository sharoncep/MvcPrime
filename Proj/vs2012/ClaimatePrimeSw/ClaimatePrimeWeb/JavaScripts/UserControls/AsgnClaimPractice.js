$(document).ready(function () { });

function saveSuccessClinic(jsonData) {
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
        retAns = retAns + AlertMsgs.get("CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.CLINIC_CODE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.CLINIC_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("NPI");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.NPI;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("TAX_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TAX_ID;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("ENTITY_TYPE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.ENTITY_TYPE_NAME;
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
        retAns = retAns + AlertMsgs.get("ICD_FORMAT1");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.ICD_FORMAT != null) {
            retAns = retAns + d.ICD_FORMAT;
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("IPA_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.IPA_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("MANAGER_NAME1");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.MANAGER_NAME != null) {
            retAns = retAns + d.MANAGER_NAME;
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PATIENT_VISIT_COMPLEXITY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PATIENT_VISIT_COMPLEXITY;
        retAns = retAns + "</td>";

        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("IS_PATIENT_DEMOGRAPHICS_PULL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.IS_PATIENT_DEMOGRAPHICS_PULL) {
            retAns = retAns + AlertMsgs.get("YES");
        }
        else {
            retAns = retAns + AlertMsgs.get("NO");
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("IS_PAT_VISIT_DOC_MANADATORY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.IS_PAT_VISIT_DOC_MANADATORY) {
            retAns = retAns + AlertMsgs.get("YES");
        }
        else {
            retAns = retAns + AlertMsgs.get("NO");
        }
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";

        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("LOGO");
        retAns = retAns + "</td>";

        retAns = retAns + "<td class=\"td-image\">";
        retAns = retAns + " <ul class=\"ul_imgEnlarge\">";
        retAns = retAns + "<li class=\"imgPhoto\">";
        retAns = retAns + " <img id=\"imgPhoto\" src=\"";
        retAns = retAns + d.LOGO_REL_PATH;
        retAns = retAns + "\" alt=\"\" style=\"width: 60px; height: 60px;\" onclick=\"javascript:return enlargePhoto(this);\" title=\" ";
        retAns = retAns + AlertMsgs.get("ENLARGE_CLICK");
        retAns = retAns + "\" />";
        retAns = retAns + "</li></ul></td>";
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
        retAns = retAns + d.CITY_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("STATE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.STATE_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("COUNTY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COUNTY_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("COUNTRY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COUNTRY_NAME
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

        retAns = retAns + "<tr>";
        retAns = retAns + "<td class=\"td-heading\" colspan=\"4\">";
        retAns = retAns + "<div class=\"dv-subheading-view\">";
        retAns = retAns + AlertMsgs.get("CONTACT_PERSON_DETAILS");
        retAns = retAns + "</div>";
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("LASTNAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_LAST_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FNAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_FIRST_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("MID_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_MIDDLE_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_PHONE_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EXTENSION");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_PHONE_NUMBER_EXTN;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_PH_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_SECONDARY_PHONE_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EXTENSION");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_SECONDARY_PHONE_NUMBER_EXTN;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_EMAIL;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_SECONDARY_EMAIL;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FAX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CONTACT_PERSON_FAX;
        retAns = retAns + "</td>";

        retAns = retAns + "</tr>";

        retAns = retAns + "</table>";

    }

    $("#divClinicC").html(retAns);
    return false;
}