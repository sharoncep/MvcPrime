$(document).ready(function () { });

function saveSuccessEDISettings(jsonData) {

    var retAns = "";

    for (i in jsonData) {
        var d = jsonData[i];

        retAns = retAns + "<table class=\"table-view\">"; if (!(d.IS_ACTIVE)) {
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
        retAns = retAns + d.EDI_RECEIVER_CODE;
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 20%\">";
        retAns = retAns + AlertMsgs.get("EDI_RECEIVER_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td style=\"width: 30%\">";
        retAns = retAns + d.EDI_RECEIVER_NAME
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("AUTH_INFO_QUALI");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.AUTHORIZATION_INFORMATION_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("AUT_INFO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.AUTHORIZATION_INFORMATION
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SECU_INFO_QUALI");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECURITY_INFORMATION_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SECU_INFO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECURITY_INFORMATION
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SECURITY_INFO_QUALIFIER_UNAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECURITY_INFORMATION_QUALIFIER_USERNAME
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SECURITY_INFO_QUALIFIER_PWD");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SECURITY_INFORMATION_QUALIFIER_PASSWORD
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("LAST_INTERCHANGE_CNTRL_NO");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.LAST_INTERCHANGE_CONTROL_NUMBER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SENDER_INTERCHANGE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SENDER_INTERCHANGE_ID_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SENDER_INTERCHANGE_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SENDER_INTERCHANGE_ID
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("RECEIVER_INTERCHANGE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.RECEIVER_INTERCHANGE_ID_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("RECEIVER_INTERCHANGE_ID");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.RECEIVER_INTERCHANGE_ID
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("TRANSACTION_PURPOSE_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TRANSACTION_SET_PURPOSE_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("TRANSACTION_TYPE_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.TRANSACTION_TYPE_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("IS_GROUP_PRACTICE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        if (d.IS_GROUP_PRACTICE) {
            retAns = retAns + AlertMsgs.get("YES");
        }
        else {
            retAns = retAns + AlertMsgs.get("NO");
        }
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        //retAns = retAns + "<tr>";
        //retAns = retAns + "<td>";
        //retAns = retAns +  AlertMsgs.get("LAST_FILE_ID");
        //retAns = retAns + "</td>";
        //retAns = retAns + "<td>";
        //retAns = retAns + d.FILE_ID
        //retAns = retAns + "</td>";
        //retAns = retAns + "<td>";
        //retAns = retAns + AlertMsgs.get("BLOCK_STATUS");
        //retAns = retAns + "</td>";
        //retAns = retAns + "<td>";
        //retAns = retAns + "</td>";
        //retAns = retAns + "</tr>";


        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CLAIM_MEDIA");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CLAIM_MEDIA
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("GS02");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.APPLICATION_SENDER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("GS03");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.APPLICATION_RECEIVER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("INTERCHANGE_USAGE_INDICATOR");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.INTER_CHANGE_USAGE_INDICATOR
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FUNCTIONAL_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FUNCTIONAL_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SUBMITTER_ENTITY_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SUBMITTER_ENTITY_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("RECEIVER_ENTITY_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.RECEIVER_ENTITY_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("BILLING_PROVIDER_ENTITY_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.BILLING_PROVIDER_ENTITY_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("SUBSCRIBER_ENTITY_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.SUBSCRIBER_ENTITY_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PAYER_ENTITY_IDENTIFIER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PAYER_ENTITY_IDENTIFIER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("ENTITY_TYPE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.ENTITY_TYPE_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("CURRENCY_CODE_NAME");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.CURRENCY_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PAYER_RESPONSIBILITY_SEQUENCE_NUMBER_CODE");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PAYER_RESPONSIBILITY_SEQUENCE_NUMBER_CODE
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("EMAIL_COMMUNICATION_NUMBER_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.EMAIL_COMMUNICATION_NUMBER_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("FAX_COMMUNICATION_NUMBER_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.FAX_COMMUNICATION_NUMBER_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PHONE_COMMUNICATION_NUMBER_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PHONE_COMMUNICATION_NUMBER_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PATIENT_ENTITY_TYPE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PATIENT_ENTITY_TYPE_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("PROVIDER_ENTITY_TYPE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.PROVIDER_ENTITY_TYPE_QUALIFIER
        retAns = retAns + "</td>";

        retAns = retAns + "<tr>";
        retAns = retAns + "<td>";
        retAns = retAns + AlertMsgs.get("INSURANCE_ENTITY_TYPE_QUALIFIER");
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + d.INSURANCE_ENTITY_TYPE_QUALIFIER
        retAns = retAns + "</td>";
        retAns = retAns + "<td>";
        retAns = retAns + "</tr>";

        retAns = retAns + "</table>";
    }
    $("#divEDISettingsTable").html(retAns);

    return false;
}