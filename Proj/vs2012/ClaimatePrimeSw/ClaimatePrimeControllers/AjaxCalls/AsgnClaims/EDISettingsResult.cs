using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class EDISettingsResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int EDI_RECEIVER_ID { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string EDI_RECEIVER_CODE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string EDI_RECEIVER_NAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string AUTHORIZATION_INFORMATION { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECURITY_INFORMATION { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECURITY_INFORMATION_QUALIFIER_USERNAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECURITY_INFORMATION_QUALIFIER_PASSWORD { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long LAST_INTERCHANGE_CONTROL_NUMBER { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SENDER_INTERCHANGE_ID { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string RECEIVER_INTERCHANGE_ID { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_GROUP_PRACTICE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string APPLICATION_SENDER_CODE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string APPLICATION_RECEIVER_CODE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string FUNCTIONAL_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string AUTHORIZATION_INFORMATION_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string SECURITY_INFORMATION_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string CLAIM_MEDIA { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string TRANSACTION_SET_PURPOSE_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string TRANSACTION_TYPE_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string INTER_CHANGE_USAGE_INDICATOR { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SENDER_INTERCHANGE_ID_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string RECEIVER_INTERCHANGE_ID_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string SUBMITTER_ENTITY_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string RECEIVER_ENTITY_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string BILLING_PROVIDER_ENTITY_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string SUBSCRIBER_ENTITY_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string PAYER_ENTITY_IDENTIFIER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string ENTITY_TYPE_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string CURRENCY_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string PAYER_RESPONSIBILITY_SEQUENCE_NUMBER_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string EMAIL_COMMUNICATION_NUMBER_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string FAX_COMMUNICATION_NUMBER_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string PHONE_COMMUNICATION_NUMBER_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string PATIENT_ENTITY_TYPE_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]

        public string PROVIDER_ENTITY_TYPE_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_ENTITY_TYPE_QUALIFIER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_ACTIVE { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator EDISettingsResult(EDISettingsModel pResult)
        {
            return (new EDISettingsResult()
            {

                EDI_RECEIVER_ID = pResult.EDIReceiver.EDIReceiverID
      ,
                EDI_RECEIVER_CODE = pResult.EDIReceiver.EDIReceiverCode
      ,
                EDI_RECEIVER_NAME = pResult.EDIReceiver.EDIReceiverName
      ,
                AUTHORIZATION_INFORMATION_QUALIFIER = pResult.EDIReceiver_AuthorizationInformationQualifier
      ,
                AUTHORIZATION_INFORMATION = string.IsNullOrWhiteSpace(pResult.EDIReceiver.AuthorizationInformation) ? string.Empty : (pResult.EDIReceiver.AuthorizationInformation)
      ,
                SECURITY_INFORMATION_QUALIFIER = pResult.EDIReceiver_SecurityInformationQualifier
      ,
                SECURITY_INFORMATION = string.IsNullOrWhiteSpace(pResult.EDIReceiver.SecurityInformation) ? string.Empty : (pResult.EDIReceiver.SecurityInformation)
      ,
                SECURITY_INFORMATION_QUALIFIER_USERNAME = string.IsNullOrWhiteSpace(pResult.EDIReceiver.SecurityInformationQualifierUserName) ? string.Empty : (pResult.EDIReceiver.SecurityInformationQualifierUserName)
      ,
                SECURITY_INFORMATION_QUALIFIER_PASSWORD = string.IsNullOrWhiteSpace(pResult.EDIReceiver.SecurityInformationQualifierPassword) ? string.Empty : (pResult.EDIReceiver.SecurityInformationQualifierPassword)
      ,
                LAST_INTERCHANGE_CONTROL_NUMBER = pResult.EDIReceiver.LastInterchangeControlNumber
      ,
                SENDER_INTERCHANGE_ID_QUALIFIER = pResult.EDIReceiver_SenderInterchangeIDQualifier
      ,
                SENDER_INTERCHANGE_ID = string.IsNullOrWhiteSpace(pResult.EDIReceiver.SenderInterchangeID) ? string.Empty : (pResult.EDIReceiver.SenderInterchangeID)
      ,
                RECEIVER_INTERCHANGE_ID_QUALIFIER = pResult.EDIReceiver_ReceiverInterchangeIDQualifier
      ,
                RECEIVER_INTERCHANGE_ID = pResult.EDIReceiver.ReceiverInterchangeID
      ,
                TRANSACTION_SET_PURPOSE_CODE = pResult.EDIReceiver_TransactionSetPurposeCode
      ,
                TRANSACTION_TYPE_CODE = pResult.EDIReceiver_TransactionTypeCode
      ,
                IS_GROUP_PRACTICE = pResult.EDIReceiver.IsGroupPractice
      ,
                CLAIM_MEDIA = pResult.EDIReceiver_ClaimMedia
      ,
                APPLICATION_SENDER_CODE = pResult.EDIReceiver.ApplicationSenderCode
      ,
                APPLICATION_RECEIVER_CODE = pResult.EDIReceiver.ApplicationReceiverCode
      ,
                INTER_CHANGE_USAGE_INDICATOR = pResult.EDIReceiver_InterchangeUsageIndicator
      ,
                FUNCTIONAL_IDENTIFIER_CODE = pResult.EDIReceiver.FunctionalIdentifierCode
      ,
                SUBMITTER_ENTITY_IDENTIFIER_CODE = pResult.EDIReceiver_SubmitterEntityIdentifierCode
      ,
                RECEIVER_ENTITY_IDENTIFIER_CODE = pResult.EDIReceiver_ReceiverEntityIdentifierCode
      ,
                BILLING_PROVIDER_ENTITY_IDENTIFIER_CODE = pResult.EDIReceiver_BillingProviderEntityIdentifierCode
      ,
                SUBSCRIBER_ENTITY_IDENTIFIER_CODE = pResult.EDIReceiver_SubscriberEntityIdentifierCode
      ,
                PAYER_ENTITY_IDENTIFIER_CODE = pResult.EDIReceiver_PayerEntityIdentifierCode
      ,
                ENTITY_TYPE_QUALIFIER = pResult.EDIReceiver_EntityTypeQualifier
      ,
                CURRENCY_CODE = pResult.EDIReceiver_CurrencyCode
      ,
                PAYER_RESPONSIBILITY_SEQUENCE_NUMBER_CODE = pResult.EDIReceiver_PayerResponsibilitySequenceNumberCode
      ,
                EMAIL_COMMUNICATION_NUMBER_QUALIFIER = pResult.EDIReceiver_EmailCommunicationNumberQualifier
      ,
                FAX_COMMUNICATION_NUMBER_QUALIFIER = pResult.EDIReceiver_FaxCommunicationNumberQualifier
      ,
                PHONE_COMMUNICATION_NUMBER_QUALIFIER = pResult.EDIReceiver_PhoneCommunicationNumberQualifier
      ,
                PATIENT_ENTITY_TYPE_QUALIFIER = pResult.EDIReceiver_PatientEntityTypeQualifier
      ,
                PROVIDER_ENTITY_TYPE_QUALIFIER = pResult.EDIReceiver_ProviderEntityTypeQualifier
      ,
                INSURANCE_ENTITY_TYPE_QUALIFIER = pResult.EDIReceiver_InsuranceEntityTypeQualifier
                ,
                IS_ACTIVE = pResult.EDIReceiver.IsActive

            });
        }

        # endregion
    }
}
