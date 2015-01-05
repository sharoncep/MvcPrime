$(document).ready(function () {
});

function saveSuccessPatient(jsonData) {
    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];
        // 

        retAns = retAns + "<table class=\"table-view-claim\">";

        if (!(d.IS_ACTIVE)) {
            retAns = retAns + "<tr>";
            retAns = retAns + "<td colspan = \"4\" class=\"td-insblocked\">";
            retAns = retAns + AlertMsgs.get("BLOCKED");
            retAns = retAns + "</td>";
            retAns = retAns + "</tr>";
        }
        retAns = retAns + " <tr>";
        retAns = retAns + "<td colspan=\"4\" class=\"td-heading\">";
        retAns = retAns + "<div class=\"dv-subheading-view\">";
        retAns = retAns + AlertMsgs.get("PERS_DETAILS");
        retAns = retAns + "</div>";
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("CHART_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\" >";
        retAns = retAns + d.CHART_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 20%\"> "
        retAns = retAns + AlertMsgs.get("MEDI_CARE_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.MEDICARE_ID;
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
        retAns = retAns + AlertMsgs.get("SEX");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SEX;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("DOB");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.DOB;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SSN");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SSN;
        retAns = retAns + "</td> </tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("ASGN_PVDR_NAME");
        retAns = retAns + "</td>"

        retAns = retAns + "<td>";
        retAns = retAns + d.PROVIDER_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("INSURANCE_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.INSURANCE_NAME;
        retAns = retAns + "  </td> </tr>";

        retAns = retAns + "<tr><td>";
        retAns = retAns + AlertMsgs.get("POLICY_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.POLICY_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("GROUP_NUMBER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.GROUP_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";

        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("POL_HOLD_REL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.RELATIONSHIP_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("POL_HOLD_CHART_NO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.POLICY_HOLDER_CHART_NUMBER;
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("INSU_BEN_ACCEPTED");
        retAns = retAns + "</td>";

        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("YES");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CAPITATED");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("YES");
        retAns = retAns + "</td>";
        retAns = retAns + "</tr> <tr><td> ";
        retAns = retAns + AlertMsgs.get("INSU_EFF_FROM");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.INSURANCE_EFFECT_FROM != null) {
            retAns = retAns + d.INSURANCE_EFFECT_FROM;
        }
        retAns = retAns + "</td>";
        retAns = retAns + "<td> ";
        retAns = retAns + AlertMsgs.get("INSU_EFF_TO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.INSURANCE_EFFECT_TO != null) {
            retAns = retAns + d.INSURANCE_EFFECT_TO;
        }
        retAns = retAns + "</td></tr>";
        retAns = retAns + "<tr><td> ";
        retAns = retAns + AlertMsgs.get("HAS_SIGN_FILE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("YES");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SIGN_DATE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SIGNED_DATE;
        retAns = retAns + "</td></tr>";
        retAns = retAns + " <tr> <td colspan=\"4\" class=\"td-heading\">";
        retAns = retAns + " <div class=\"dv-subheading-view\">";
        retAns = retAns + AlertMsgs.get("CONT_DETAILS");
        retAns = retAns + "</div> </td> </tr>";
        retAns = retAns + "<tr><td>";
        retAns = retAns + AlertMsgs.get("STREET");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.STREET_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SUITE_NO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SUITE;
        retAns = retAns + "</td></tr>";
        retAns = retAns + "<tr><td>";
        retAns = retAns + AlertMsgs.get("CITY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CITY_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("STATE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.STATE_NAME;
        retAns = retAns + "</td></tr>";
        retAns = retAns + "<tr><td>";
        retAns = retAns + AlertMsgs.get("COUNTRY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td >";
        retAns = retAns + d.COUNTRY_NAME;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("COUNTY");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COUNTY_NAME;
        retAns = retAns + "</td> </tr>";
        retAns = retAns + "<tr><td>";
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
        retAns = retAns + "</td></tr>";
        retAns = retAns + "<tr><td>";
        retAns = retAns + AlertMsgs.get("EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.EMAIL;
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SEC_EMAIL");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECONDARY_EMAIL;
        retAns = retAns + "</td></tr>";
        //retAns = retAns + "<tr><td colspan=\"4\" class=\"td-heading\">";
        //retAns = retAns + "<div class=\"dv-subheading-view\">Photo</div>";
        //retAns = retAns + "</td>";
        //retAns = retAns + "</tr>";
        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PHOTO");
        retAns = retAns + "</td>";

        retAns = retAns + "<td colspan=\"2\" class=\"td-image\">";
        retAns = retAns + " <ul class=\"ul_imgEnlarge\">";
        retAns = retAns + "<li class=\"imgPhoto\">";
        retAns = retAns + " <img id=\"imgPhoto\" src=\"";
        retAns = retAns + d.IMG_SRC;
        retAns = retAns + "\" alt=\"\" style=\"width: 60px; height: 60px;\" onclick=\"javascript:return enlargePhoto(this);\" title=\" ";
        retAns = retAns + AlertMsgs.get("ENLARGE_CLICK");
        retAns = retAns + "\" />";
        retAns = retAns + "</li></ul></td></tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("NOTES");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.COMMENT;
        retAns = retAns + "</td></tr>";

        retAns = retAns + "</table>";
    }

    $("#divPatientC").html(retAns);

    return false;
}

