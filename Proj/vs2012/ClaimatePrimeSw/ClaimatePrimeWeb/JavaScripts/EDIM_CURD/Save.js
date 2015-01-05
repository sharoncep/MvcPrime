$(document).ready(function () {

    setAutoComplete("EDIReceiver_AuthorizationInformationQualifier","AuthorizationQualifier");
    setAutoComplete("EDIReceiver_SecurityInformationQualifier", "SecurityQualifier");
    setAutoComplete("EDIReceiver_TransactionSetPurposeCode","TransactionPurposeCode");
    setAutoComplete("EDIReceiver_TransactionTypeCode", "TransactionTypeCode");
    setAutoComplete("EDIReceiver_InterchangeUsageIndicator","UsageIndicator");
    setAutoComplete("EDIReceiver_ClaimMedia", "ClaimMedia");
    setAutoComplete("EDIReceiver_SenderInterchangeIDQualifier", "SenderInterchangeIDQualifier");
    setAutoComplete("EDIReceiver_ReceiverInterchangeIDQualifier", "ReceiverInterchangeIDQualifier");
    setAutoComplete("EDIReceiver_SubmitterEntityIdentifierCode", "SubmitterEntityIdentifierCode");
    setAutoComplete("EDIReceiver_ReceiverEntityIdentifierCode", "ReceiverEntityIdentifierCode");
    setAutoComplete("EDIReceiver_BillingProviderEntityIdentifierCode", "BillingProviderEntityIdentifierCode");
    setAutoComplete("EDIReceiver_SubscriberEntityIdentifierCode", "SubscriberEntityIdentifierCode");
    setAutoComplete("EDIReceiver_PayerEntityIdentifierCode", "PayerEntityIdentifierCode");
    setAutoComplete("EDIReceiver_CurrencyCode", "CurrencyCode");
    setAutoComplete("EDIReceiver_PayerResponsibilitySequenceNumberCode", "PayerResponsibilitySequenceNumberCode");
    setAutoComplete("EDIReceiver_EmailCommunicationNumberQualifier", "EmailCommunicationNumberQualifier");
    setAutoComplete("EDIReceiver_FaxCommunicationNumberQualifier", "FaxCommunicationNumberQualifier");
    setAutoComplete("EDIReceiver_PhoneCommunicationNumberQualifier", "PhoneCommunicationNumberQualifier");
    setAutoComplete("EDIReceiver_PatientEntityTypeQualifier", "PatientEntityTypeQualifier");
    setAutoComplete("EDIReceiver_ProviderEntityTypeQualifier", "ProviderEntityTypeQualifier");
    setAutoComplete("EDIReceiver_InsuranceEntityTypeQualifier", "InsuranceEntityTypeQualifier");
    setAutoComplete("EDIReceiver_EntityTypeQualifier", "EntityType")

    _AlertMsgID = "EDIReceiver_EDIReceiverCode";
    $("#" + _AlertMsgID).focus();
});

function AuthorizationQualifierID(selId) {
   

}
function SecurityQualifierID(selId) {
  

}

function TransactionPurposeCodeID(selId) {
  

}
function TransactionTypeCodeID(selId) {
    

}
function UsageIndicatorID(selId) {
    

}
function ClaimMediaID(selId) {

   
}
function SenderInterchangeIDQualifierID(selId) {


}
function ReceiverInterchangeIDQualifierID(selId) {


}
function SubmitterEntityIdentifierCodeID(selId) {


}
function ReceiverEntityIdentifierCodeID(selId) {


}
function BillingProviderEntityIdentifierCodeID(selId) {


}
function SubscriberEntityIdentifierCodeID(selId) {


}
function PayerEntityIdentifierCodeID(selId) {


}
function CurrencyCodeID(selId) {


}
function PayerResponsibilitySequenceNumberCodeID(selId) {


}
function EmailCommunicationNumberQualifierID(selId) {


}
function FaxCommunicationNumberQualifierID(selId) {


}
function PhoneCommunicationNumberQualifierID(selId) {


}
function PatientEntityTypeQualifierID(selId) {


}
function ProviderEntityTypeQualifierID(selId) {


}
function InsuranceEntityTypeQualifierID(selId) {


}
function EntityTypeID(selId) {


}


function validateSave() {

    if (canSubmit()) {
        if (!(($('#EDIReceiver_IsActive').is(':checked')))) {
            if (!(confirm(AlertMsgs.get("BLOCK_CONFIRM")))) {
                return false;
            }
        }
        showDivPageLoading("Js");

        if ($("#EDIReceiver_EDIReceiverCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_CODE"), "EDIReceiver_EDIReceiverCode");
            return false;
        }
        if ($("#EDIReceiver_EDIReceiverName").val().length == 0) {
            alertErrMsg(AlertMsgs.get("MSG_NAME"), "EDIReceiver_EDIReceiverName");
            return false;
        }

        if ($("#EDIReceiver_AuthorizationInformationQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("AUTH_ID"), "EDIReceiver_AuthorizationInformationQualifier");
            return false;
        }
        
     
        if ($("#EDIReceiver_SecurityInformationQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("SECURITY_ID"), "EDIReceiver_SecurityInformationQualifier");
            return false;
        }
        if ($("#EDIReceiver_LastInterchangeControlNumber").val().length == 0) {
            alertErrMsg(AlertMsgs.get("LAST_INTERCHANGE_CONTROL_NUMBER"), "EDIReceiver_LastInterchangeControlNumber");
            return false;
        }
       
        if ($("#EDIReceiver_SenderInterchangeIDQualifier").val().length == 0) {
            alertErrMsg(AlertMsgs.get("INTER_SENDERID"), "EDIReceiver_SenderInterchangeIDQualifier");
            return false;
        }
        if ($("#EDIReceiver_SenderInterchangeID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("SENDER_INTERCHANGEID"), "EDIReceiver_SenderInterchangeID");
            return false;
        }
        if ($("#EDIReceiver_ReceiverInterchangeIDQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("RECEIVER_INTERCHANGEID_QUALIFIER"), "EDIReceiver_ReceiverInterchangeIDQualifier");
            return false;
        }
        if ($("#EDIReceiver_ReceiverInterchangeID").val().length == 0) {
            alertErrMsg(AlertMsgs.get("RECEIVER_INTERCHANGEID"), "EDIReceiver_ReceiverInterchangeID");
            return false;
        }
        if ($("#EDIReceiver_TransactionSetPurposeCodeID").val()== 0) {
            alertErrMsg(AlertMsgs.get("TRANSACTION_PURPOSECODE_ID"), "EDIReceiver_TransactionSetPurposeCode");
            return false;
        }
        if ($("#EDIReceiver_TransactionTypeCodeID").val()== 0) {
            alertErrMsg(AlertMsgs.get("TRANSACTION_TYPE_CODE_ERR"), "EDIReceiver_TransactionTypeCode");
            return false;
        }
        if ($("#EDIReceiver_ClaimMediaID").val() == 0) {
            alertErrMsg(AlertMsgs.get("CLAIM_MEDIAID"), "EDIReceiver_ClaimMedia");
            return false;
        }
        if ($("#EDIReceiver_ApplicationSenderCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("APPLN_SENDER_CODE"), "EDIReceiver_ApplicationSenderCode");
            return false;
        }
        if ($("#EDIReceiver_ApplicationReceiverCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("APPLN_RECEIVER_CODE"), "EDIReceiver_ApplicationReceiverCode");
            return false;
        }

        if ($("#EDIReceiver_InterchangeUsageIndicatorID").val() == 0) {
            alertErrMsg(AlertMsgs.get("USAGEINDICATOR_ID"), "EDIReceiver_InterchangeUsageIndicator");
            return false;
        }

        if ($("#EDIReceiver_FunctionalIdentifierCode").val().length == 0) {
            alertErrMsg(AlertMsgs.get("FUNCTIONAL_IDENTIFIER_CODE_ERR"), "EDIReceiver_FunctionalIdentifierCode");
            return false;
        }
        if ($("#EDIReceiver_SubmitterEntityIdentifierCodeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("SUBMITTER_ENTITYIDENTIFIER_CODE"), "EDIReceiver_SubmitterEntityIdentifierCode");
            return false;
        }
        if ($("#EDIReceiver_ReceiverEntityIdentifierCodeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("RECEIVER_ENTITYIDENTIFIER_CODE"), "EDIReceiver_ReceiverEntityIdentifierCode");
            return false;
        }
        if ($("#EDIReceiver_EntityTypeQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("ENTITYTYPE_QUALIFIER"), "EDIReceiver_EntityTypeQualifier");
            return false;
        }
        
        if ($("#EDIReceiver_CurrencyCodeID").val() == 0) {
           
            alertErrMsg(AlertMsgs.get("CURRENCY_CODE"), "EDIReceiver_CurrencyCode");
            return false;
        }
        
        if ($("#EDIReceiver_PayerResponsibilitySequenceNumberCodeID").val() == 0) {
            
            alertErrMsg(AlertMsgs.get("PAYER_RESPONSIBILITY_SEQUENCENUMBER_CODE"), "EDIReceiver.PayerResponsibilitySequenceNumberCode");
            return false;
        }
        if ($("#EDIReceiver_BillingProviderEntityIdentifierCodeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("BILLINGPROVIDER_ENTITYIDENTIFIER_CODE"), "EDIReceiver_BillingProviderEntityIdentifierCode");
            return false;
        }
      
        if ($("#EDIReceiver_SubscriberEntityIdentifierCodeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("SUBSCRIBER_ENTITYIDENTIFIER_CODE"), "EDIReceiver_SubscriberEntityIdentifierCode");
            return false;
        }
        if ($("#EDIReceiver_PayerEntityIdentifierCodeID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PAYER_ENTITYIDENTIFIER_CODE"), "EDIReceiver_PayerEntityIdentifierCode");
            return false;
        }
        if ($("#EDIReceiver_EmailCommunicationNumberQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("EMAIL_COMMUNICATION_NUMBERQUALIFIER"), "EDIReceiver_EmailCommunicationNumberQualifier");
            return false;
        }
        if ($("#EDIReceiver_FaxCommunicationNumberQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("FAX_COMMUNICATIONNUMBER_QUALIFIER"), "EDIReceiver_FaxCommunicationNumberQualifier");
            return false;
        }
        if ($("#EDIReceiver_PhoneCommunicationNumberQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PHONE_COMMUNICATIONNUMBER_QUALIFIER"), "EDIReceiver_PhoneCommunicationNumberQualifier");
            return false;
        }
        if ($("#EDIReceiver_PatientEntityTypeQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PATIENT_ENTITYTYPE_QUALIFIER"), "EDIReceiver_PatientEntityTypeQualifier");
            return false;
        }
        if ($("#EDIReceiver_ProviderEntityTypeQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("PROVIDER_ENTITYTYPE_QUALIFIER"), "EDIReceiver_ProviderEntityTypeQualifier");
            return false;
        }
        if ($("#EDIReceiver_InsuranceEntityTypeQualifierID").val() == 0) {
            alertErrMsg(AlertMsgs.get("INSURANCE_ENTITYTYPE_QUALIFIER"), "EDIReceiver_InsuranceEntityTypeQualifier");
            return false;
        }
        return true;
    }
    return false;

}