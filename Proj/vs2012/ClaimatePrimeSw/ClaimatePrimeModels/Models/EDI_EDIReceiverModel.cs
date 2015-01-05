using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeModels.Models
{
    #region Class-EDISettings-Assigend Claims

    public class EDISettingsModel : BaseSaveModel
    {
        # region Properties

        public usp_GetByPatientID_EDIReceiver_Result EDIReceiver { get; set; }

        public string EDIReceiver_AuthorizationInformationQualifier { get; set; }

        public string EDIReceiver_SecurityInformationQualifier { get; set; }

        public string EDIReceiver_ClaimMedia { get; set; }

        public string EDIReceiver_TransactionSetPurposeCode { get; set; }

        public string EDIReceiver_TransactionTypeCode { get; set; }

        public string EDIReceiver_InterchangeUsageIndicator { get; set; }

        public string EDIReceiver_SenderInterchangeIDQualifier { get; set; }

        public string EDIReceiver_ReceiverInterchangeIDQualifier { get; set; }

        public string EDIReceiver_SubmitterEntityIdentifierCode { get; set; }

        public string EDIReceiver_ReceiverEntityIdentifierCode { get; set; }

        public string EDIReceiver_BillingProviderEntityIdentifierCode { get; set; }

        public string EDIReceiver_SubscriberEntityIdentifierCode { get; set; }

        public string EDIReceiver_PayerEntityIdentifierCode { get; set; }

        public string EDIReceiver_EntityTypeQualifier { get; set; }

        public string EDIReceiver_CurrencyCode { get; set; }

        public string EDIReceiver_PayerResponsibilitySequenceNumberCode { get; set; }

        public string EDIReceiver_EmailCommunicationNumberQualifier { get; set; }

        public string EDIReceiver_FaxCommunicationNumberQualifier { get; set; }

        public string EDIReceiver_PhoneCommunicationNumberQualifier { get; set; }

        public string EDIReceiver_PatientEntityTypeQualifier { get; set; }

        public string EDIReceiver_ProviderEntityTypeQualifier { get; set; }

        public string EDIReceiver_InsuranceEntityTypeQualifier { get; set; }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    EDIReceiver = (new List<usp_GetByPatientID_EDIReceiver_Result>(ctx.usp_GetByPatientID_EDIReceiver(pID))).FirstOrDefault();
                }
            }

            if (EDIReceiver == null)
            {
                EDIReceiver = new usp_GetByPatientID_EDIReceiver_Result() { IsActive = true };
            }

            # region Auto Complete Fill

            # region AuthorizationQualifier

            if (EDIReceiver.AuthorizationInformationQualifierID > 0)
            {
                usp_GetByPkId_AuthorizationInformationQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(EDIReceiver.AuthorizationInformationQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_AuthorizationInformationQualifier = string.Concat(stateRes.AuthorizationInformationQualifierName, " [", stateRes.AuthorizationInformationQualifierCode, "]");
                }
            }

            # endregion

            # region SecurityQualifier

            if (EDIReceiver.SecurityInformationQualifierID > 0)
            {
                usp_GetByPkId_SecurityInformationQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(EDIReceiver.SecurityInformationQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SecurityInformationQualifier = string.Concat(stateRes.SecurityInformationQualifierName + " [", stateRes.SecurityInformationQualifierCode, "]");
                }
            }

            # endregion

            # region ClaimMedia

            if (EDIReceiver.ClaimMediaID > 0)
            {
                usp_GetByPkId_ClaimMedia_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(EDIReceiver.ClaimMediaID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ClaimMedia = string.Concat(stateRes.ClaimMediaName + " [", stateRes.ClaimMediaCode, "]");
                }
            }

            # endregion

            # region TransactionPurposeCode

            if (EDIReceiver.TransactionSetPurposeCodeID > 0)
            {
                usp_GetByPkId_TransactionSetPurposeCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(EDIReceiver.TransactionSetPurposeCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_TransactionSetPurposeCode = string.Concat(stateRes.TransactionSetPurposeCodeName, " [", stateRes.TransactionSetPurposeCodeCode, "]");
                }
            }

            # endregion

            # region TransactionTypeCode

            if (EDIReceiver.TransactionTypeCodeID > 0)
            {
                usp_GetByPkId_TransactionTypeCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_TransactionTypeCode_Result>(ctx.usp_GetByPkId_TransactionTypeCode(EDIReceiver.TransactionTypeCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_TransactionTypeCode = string.Concat(stateRes.TransactionTypeCodeName, " [", stateRes.TransactionTypeCodeCode, "]");
                }
            }

            # endregion

            # region InterchangeUsageIndicator

            if (EDIReceiver.InterchangeUsageIndicatorID > 0)
            {
                usp_GetByPkId_InterchangeUsageIndicator_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(EDIReceiver.InterchangeUsageIndicatorID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_InterchangeUsageIndicator = string.Concat(stateRes.InterchangeUsageIndicatorName, " [", stateRes.InterchangeUsageIndicatorCode, "]");
                }
            }

            # endregion

            # region SenderInterchangeIDQualifier

            if (EDIReceiver.SenderInterchangeIDQualifierID > 0)
            {
                usp_GetByPkId_InterchangeIDQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(EDIReceiver.SenderInterchangeIDQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SenderInterchangeIDQualifier = string.Concat(stateRes.InterchangeIDQualifierName, " [", stateRes.InterchangeIDQualifierCode, "]");
                }
            }

            # endregion

            # region ReceiverInterchangeIDQualifier

            if (EDIReceiver.ReceiverInterchangeIDQualifierID > 0)
            {
                usp_GetByPkId_InterchangeIDQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(EDIReceiver.ReceiverInterchangeIDQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ReceiverInterchangeIDQualifier = string.Concat(stateRes.InterchangeIDQualifierName, " [", stateRes.InterchangeIDQualifierCode, "]");
                }
            }

            # endregion

            # region SubmitterEntityIdentifierCode

            if (EDIReceiver.SubmitterEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.SubmitterEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SubmitterEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region ReceiverEntityIdentifierCode

            if (EDIReceiver.ReceiverEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.ReceiverEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ReceiverEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region BillingProviderEntityIdentifierCode

            if (EDIReceiver.BillingProviderEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.BillingProviderEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_BillingProviderEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region SubscriberEntityIdentifierCode

            if (EDIReceiver.SubscriberEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.SubscriberEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SubscriberEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region PayerEntityIdentifierCode

            if (EDIReceiver.PayerEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.PayerEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PayerEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region EntityTypeQualifier

            if (EDIReceiver.EntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_EntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region CurrencyCode

            if (EDIReceiver.CurrencyCodeID > 0)
            {
                usp_GetByPkId_CurrencyCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CurrencyCode_Result>(ctx.usp_GetByPkId_CurrencyCode(EDIReceiver.CurrencyCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_CurrencyCode = string.Concat(stateRes.CurrencyCodeName, " [", stateRes.CurrencyCodeCode, "]");
                }
            }

            # endregion

            # region PayerResponsibilitySequenceNumberCode

            if (EDIReceiver.PayerResponsibilitySequenceNumberCodeID > 0)
            {
                usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetByPkId_PayerResponsibilitySequenceNumberCode(EDIReceiver.PayerResponsibilitySequenceNumberCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PayerResponsibilitySequenceNumberCode = string.Concat(stateRes.PayerResponsibilitySequenceNumberCodeName, " [", stateRes.PayerResponsibilitySequenceNumberCodeCode, "]");
                }
            }

            # endregion

            # region EmailCommunicationNumberQualifier

            if (EDIReceiver.EmailCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.EmailCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_EmailCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion

            # region FaxCommunicationNumberQualifier

            if (EDIReceiver.FaxCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.FaxCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_FaxCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion

            # region PhoneCommunicationNumberQualifier

            if (EDIReceiver.PhoneCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.PhoneCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PhoneCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion

            # region PatientEntityTypeQualifier

            if (EDIReceiver.PatientEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PatientEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region ProviderEntityTypeQualifier

            if (EDIReceiver.ProviderEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.ProviderEntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ProviderEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region InsuranceEntityTypeQualifier

            if (EDIReceiver.InsuranceEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.InsuranceEntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_InsuranceEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion


            # endregion

            //throw new Exception("protected override void FillByID(long pID, bool? pIsActive)");
        }

        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion


        
    }

    #endregion

    #region EDIAutoComplete
    public class EDIModel : BaseModel
    {
        # region Public Methods



        #endregion
    }
    #endregion

    #region EDISearchModel

    /// <summary>
    /// 
    /// </summary>
    public class EDISearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_EDIReceiver_Result> EDIResults { get; set; }



        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDISearchModel()
        {
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ppIsActive"></param>
        protected override void FillByAZ(bool? ppIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="ppIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? ppIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                EDIResults = new List<usp_GetBySearch_EDIReceiver_Result>(ctx.usp_GetBySearch_EDIReceiver(OrderByField, OrderByDirection, ppIsActive));
            }


        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #region EDISaveModel

    /// <summary>
    /// 
    /// </summary>
    public class EDISaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// Get or set
        /// </summary>
        public usp_GetByPkId_EDIReceiver_Result EDIReceiver
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_AuthorizationInformationQualifier
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_SecurityInformationQualifier
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_SenderInterchangeIDQualifier
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_ReceiverInterchangeIDQualifier
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_TransactionSetPurposeCode
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_TransactionTypeCode
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_InterchangeUsageIndicator
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_SubmitterEntityIdentifierCode
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_ClaimMedia
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_ReceiverEntityIdentifierCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public string EDIReceiver_BillingProviderEntityIdentifierCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_SubscriberEntityIdentifierCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_PayerEntityIdentifierCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_EntityTypeQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_CurrencyCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_PayerResponsibilitySequenceNumberCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_EmailCommunicationNumberQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_FaxCommunicationNumberQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_PhoneCommunicationNumberQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_PatientEntityTypeQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_ProviderEntityTypeQualifier
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public string EDIReceiver_InsuranceEntityTypeQualifier
        {
            get;
            set;
        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {

            ObjectParameter eDIReceiverID = ObjParam("EDIReceiver");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_EDIReceiver(EDIReceiver.EDIReceiverCode, EDIReceiver.EDIReceiverName, EDIReceiver.AuthorizationInformationQualifierID, EDIReceiver.AuthorizationInformation,
                                           EDIReceiver.SecurityInformationQualifierID, EDIReceiver.SecurityInformation, EDIReceiver.SecurityInformationQualifierUserName, EDIReceiver.SecurityInformationQualifierPassword
                                           , EDIReceiver.LastInterchangeControlNumber, EDIReceiver.SenderInterchangeIDQualifierID, EDIReceiver.SenderInterchangeID, EDIReceiver.ReceiverInterchangeIDQualifierID, EDIReceiver.ReceiverInterchangeID, EDIReceiver.TransactionSetPurposeCodeID, EDIReceiver.TransactionTypeCodeID, EDIReceiver.IsGroupPractice, EDIReceiver.ClaimMediaID, EDIReceiver.ApplicationSenderCode, EDIReceiver.ApplicationReceiverCode, EDIReceiver.InterchangeUsageIndicatorID, EDIReceiver.FunctionalIdentifierCode, EDIReceiver.SubmitterEntityIdentifierCodeID, EDIReceiver.ReceiverEntityIdentifierCodeID, EDIReceiver.BillingProviderEntityIdentifierCodeID, EDIReceiver.SubscriberEntityIdentifierCodeID, EDIReceiver.PayerEntityIdentifierCodeID, EDIReceiver.EntityTypeQualifierID, EDIReceiver.CurrencyCodeID, EDIReceiver.PayerResponsibilitySequenceNumberCodeID, EDIReceiver.EmailCommunicationNumberQualifierID, EDIReceiver.FaxCommunicationNumberQualifierID, EDIReceiver.PhoneCommunicationNumberQualifierID, EDIReceiver.PatientEntityTypeQualifierID
                                          , EDIReceiver.ProviderEntityTypeQualifierID, EDIReceiver.InsuranceEntityTypeQualifierID, string.Empty, pUserID, eDIReceiverID);
                if (HasErr(eDIReceiverID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="ppIsActive"></param>
        protected override void FillByID(Int32 pID, bool? pIsActive)
        {

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    EDIReceiver = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (EDIReceiver == null)
            {
                EDIReceiver = new usp_GetByPkId_EDIReceiver_Result() { IsActive = true };
            }

            # region Auto Complete Fill

            # region AuthorizationQualifier

            if (EDIReceiver.AuthorizationInformationQualifierID > 0)
            {
                usp_GetByPkId_AuthorizationInformationQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(EDIReceiver.AuthorizationInformationQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_AuthorizationInformationQualifier = string.Concat(stateRes.AuthorizationInformationQualifierName, " [", stateRes.AuthorizationInformationQualifierCode, "]");
                }
            }

            # endregion

            # region SecurityQualifier

            if (EDIReceiver.SecurityInformationQualifierID > 0)
            {
                usp_GetByPkId_SecurityInformationQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(EDIReceiver.SecurityInformationQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SecurityInformationQualifier = string.Concat(stateRes.SecurityInformationQualifierName + " [", stateRes.SecurityInformationQualifierCode, "]");
                }
            }

            # endregion


            # region ClaimMedia

            if (EDIReceiver.ClaimMediaID > 0)
            {
                usp_GetByPkId_ClaimMedia_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(EDIReceiver.ClaimMediaID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ClaimMedia = string.Concat(stateRes.ClaimMediaName + " [", stateRes.ClaimMediaCode, "]");
                }
            }

            # endregion

            # region TransactionPurposeCode

            if (EDIReceiver.TransactionSetPurposeCodeID > 0)
            {
                usp_GetByPkId_TransactionSetPurposeCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(EDIReceiver.TransactionSetPurposeCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_TransactionSetPurposeCode = string.Concat(stateRes.TransactionSetPurposeCodeName, " [", stateRes.TransactionSetPurposeCodeCode, "]");
                }
            }

            # endregion

            # region TransactionTypeCode

            if (EDIReceiver.TransactionTypeCodeID > 0)
            {
                usp_GetByPkId_TransactionTypeCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_TransactionTypeCode_Result>(ctx.usp_GetByPkId_TransactionTypeCode(EDIReceiver.TransactionTypeCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_TransactionTypeCode = string.Concat(stateRes.TransactionTypeCodeName, " [", stateRes.TransactionTypeCodeCode, "]");
                }
            }

            # endregion

            # region InterchangeUsageIndicator

            if (EDIReceiver.InterchangeUsageIndicatorID > 0)
            {
                usp_GetByPkId_InterchangeUsageIndicator_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(EDIReceiver.InterchangeUsageIndicatorID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_InterchangeUsageIndicator = string.Concat(stateRes.InterchangeUsageIndicatorName, " [", stateRes.InterchangeUsageIndicatorCode, "]");
                }
            }

            # endregion

            # region SenderInterchangeIDQualifier

            if (EDIReceiver.SenderInterchangeIDQualifierID > 0)
            {
                usp_GetByPkId_InterchangeIDQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(EDIReceiver.SenderInterchangeIDQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SenderInterchangeIDQualifier = string.Concat(stateRes.InterchangeIDQualifierName, " [", stateRes.InterchangeIDQualifierCode, "]");
                }
            }

            # endregion

            # region ReceiverInterchangeIDQualifier

            if (EDIReceiver.ReceiverInterchangeIDQualifierID > 0)
            {
                usp_GetByPkId_InterchangeIDQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(EDIReceiver.ReceiverInterchangeIDQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ReceiverInterchangeIDQualifier = string.Concat(stateRes.InterchangeIDQualifierName, " [", stateRes.InterchangeIDQualifierCode, "]");
                }
            }

            # endregion


            # region SubmitterEntityIdentifierCode

            if (EDIReceiver.SubmitterEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.SubmitterEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SubmitterEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion


            # region ReceiverEntityIdentifierCode

            if (EDIReceiver.ReceiverEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.ReceiverEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ReceiverEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region BillingProviderEntityIdentifierCode

            if (EDIReceiver.BillingProviderEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.BillingProviderEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_BillingProviderEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region SubscriberEntityIdentifierCode

            if (EDIReceiver.SubscriberEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.SubscriberEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_SubscriberEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region PayerEntityIdentifierCode

            if (EDIReceiver.PayerEntityIdentifierCodeID > 0)
            {
                usp_GetByPkId_EntityIdentifierCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(EDIReceiver.PayerEntityIdentifierCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PayerEntityIdentifierCode = string.Concat(stateRes.EntityIdentifierCodeName, " [", stateRes.EntityIdentifierCodeCode, "]");
                }
            }

            # endregion

            # region EntityTypeQualifier

            if (EDIReceiver.EntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_EntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region CurrencyCode

            if (EDIReceiver.CurrencyCodeID > 0)
            {
                usp_GetByPkId_CurrencyCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CurrencyCode_Result>(ctx.usp_GetByPkId_CurrencyCode(EDIReceiver.CurrencyCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_CurrencyCode = string.Concat(stateRes.CurrencyCodeName, " [", stateRes.CurrencyCodeCode, "]");
                }
            }

            # endregion

            # region PayerResponsibilitySequenceNumberCode

            if (EDIReceiver.PayerResponsibilitySequenceNumberCodeID > 0)
            {
                usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetByPkId_PayerResponsibilitySequenceNumberCode(EDIReceiver.PayerResponsibilitySequenceNumberCodeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PayerResponsibilitySequenceNumberCode = string.Concat(stateRes.PayerResponsibilitySequenceNumberCodeName, " [", stateRes.PayerResponsibilitySequenceNumberCodeCode, "]");
                }
            }

            # endregion

            # region EmailCommunicationNumberQualifier

            if (EDIReceiver.EmailCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.EmailCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_EmailCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion



            # region FaxCommunicationNumberQualifier

            if (EDIReceiver.FaxCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.FaxCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_FaxCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion



            # region PhoneCommunicationNumberQualifier

            if (EDIReceiver.PhoneCommunicationNumberQualifierID > 0)
            {
                usp_GetByPkId_CommunicationNumberQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(EDIReceiver.PhoneCommunicationNumberQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PhoneCommunicationNumberQualifier = string.Concat(stateRes.CommunicationNumberQualifierName, " [", stateRes.CommunicationNumberQualifierCode, "]");
                }
            }

            # endregion

            # region PatientEntityTypeQualifier

            if (EDIReceiver.PatientEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_PatientEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region ProviderEntityTypeQualifier

            if (EDIReceiver.ProviderEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.ProviderEntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_ProviderEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion

            # region InsuranceEntityTypeQualifier

            if (EDIReceiver.InsuranceEntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(EDIReceiver.InsuranceEntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EDIReceiver_InsuranceEntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }
            }

            # endregion





            # endregion

            EncryptAudit(EDIReceiver.EDIReceiverID, EDIReceiver.LastModifiedBy, EDIReceiver.LastModifiedOn);

        }

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="pUserID"></param>
        ///// <returns></returns>
        ///// 
        //public void fillByID(byte pID, bool? ppIsActive)
        //{
        //    # region Patient

        //    if (pID > 0)
        //    {
        //        using (EFContext ctx = new EFContext())
        //        {
        //            EDI = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(pID, ppIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (EDI == null)
        //    {
        //        EDI = new usp_GetByPkId_EDIReceiver_Result();
        //    }

        //    EncryptAudit(EDI.EDIReceiverID, EDI.LastModifiedBy, EDI.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {

            ObjectParameter eDIReceiverID = ObjParam("EDIReceiver");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_EDIReceiver(EDIReceiver.EDIReceiverCode, EDIReceiver.EDIReceiverName, EDIReceiver.AuthorizationInformationQualifierID, EDIReceiver.AuthorizationInformation,
                                           EDIReceiver.SecurityInformationQualifierID, EDIReceiver.SecurityInformation, EDIReceiver.SecurityInformationQualifierUserName, EDIReceiver.SecurityInformationQualifierPassword
                                           , EDIReceiver.LastInterchangeControlNumber, EDIReceiver.SenderInterchangeIDQualifierID, EDIReceiver.SenderInterchangeID,
                                           EDIReceiver.ReceiverInterchangeIDQualifierID, EDIReceiver.ReceiverInterchangeID, EDIReceiver.TransactionSetPurposeCodeID,
                                           EDIReceiver.TransactionTypeCodeID, EDIReceiver.IsGroupPractice, EDIReceiver.ClaimMediaID, EDIReceiver.ApplicationSenderCode,
                                           EDIReceiver.ApplicationReceiverCode, EDIReceiver.InterchangeUsageIndicatorID, EDIReceiver.FunctionalIdentifierCode, EDIReceiver.SubmitterEntityIdentifierCodeID, EDIReceiver.ReceiverEntityIdentifierCodeID, EDIReceiver.BillingProviderEntityIdentifierCodeID, EDIReceiver.SubscriberEntityIdentifierCodeID, EDIReceiver.PayerEntityIdentifierCodeID, EDIReceiver.EntityTypeQualifierID, EDIReceiver.CurrencyCodeID, EDIReceiver.PayerResponsibilitySequenceNumberCodeID, EDIReceiver.EmailCommunicationNumberQualifierID, EDIReceiver.FaxCommunicationNumberQualifierID, EDIReceiver.PhoneCommunicationNumberQualifierID, EDIReceiver.PatientEntityTypeQualifierID
                                          , EDIReceiver.ProviderEntityTypeQualifierID, EDIReceiver.InsuranceEntityTypeQualifierID, EDIReceiver.Comment, EDIReceiver.IsActive, LastModifiedBy, LastModifiedOn, pUserID, eDIReceiverID);


                if (HasErr(eDIReceiverID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;

        }

        #endregion

    }

    #endregion

    #region EDIReceiverSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class EDIReceiverSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_EDIReceiver_Result EDIReceiver
        {
            get;
            set;
        }

        public string EDIReceiver_ClaimMedia
        {
            get;
            set;
        }



        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            //ObjectParameter EDIReceiverID = ObjParam("EDIReceiver");

            //using (EFContext ctx = new EFContext())
            //{
            //    BeginDbTrans(ctx);
            //    ctx.usp_Insert_EDIReceiver(EDIReceiver.EDIID,EDIReceiver.EDIReceiverCode,EDIReceiver.ClaimMediaID,EDIReceiver.Comment,pUserID,EDIReceiverID);

            //    if (HasErr(EDIReceiverID, ctx))
            //    {
            //        RollbackDbTrans(ctx);

            //        return false;
            //    }

            //    CommitDbTrans(ctx);
            //}

            //return true;
            throw new Exception("SaveInsert(int pUserID)");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(byte pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    EDIReceiver = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(pID, pIsActive))).FirstOrDefault();

                    #region AutoComplete

                    # region ClaimMedia


                    usp_GetByPkId_ClaimMedia_Result ClaimMediaRes = null;


                    ClaimMediaRes = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(pID, pIsActive))).FirstOrDefault();


                    if (ClaimMediaRes != null)
                    {
                        EDIReceiver_ClaimMedia = string.Concat(ClaimMediaRes.ClaimMediaName + "[", ClaimMediaRes.ClaimMediaCode, "]");
                    }


                    # endregion
                    #endregion
                }
            }

            if (EDIReceiver == null)
            {
                EDIReceiver = new usp_GetByPkId_EDIReceiver_Result() { IsActive = true };
            }

            EncryptAudit(EDIReceiver.EDIReceiverID, EDIReceiver.LastModifiedBy, EDIReceiver.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        /// 
        public void fillByID(byte pID, bool? pIsActive)
        {
            # region Patient

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    EDIReceiver = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (EDIReceiver == null)
            {
                EDIReceiver = new usp_GetByPkId_EDIReceiver_Result();
            }

            EncryptAudit(EDIReceiver.EDIReceiverID, EDIReceiver.LastModifiedBy, EDIReceiver.LastModifiedOn);

            # endregion

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            //ObjectParameter EDIReceiverID = ObjParam("EDIReceiver");

            //using (EFContext ctx = new EFContext())
            //{
            //    BeginDbTrans(ctx);

            //    ctx.usp_Update_EDIReceiver(EDIReceiver.EDIID,EDIReceiver.EDIReceiverCode,EDIReceiver.ClaimMediaID,EDIReceiver.Comment,EDIReceiver.IsActive,LastModifiedBy,LastModifiedOn,pUserID,EDIReceiverID);

            //    if (HasErr(EDIReceiverID, ctx))
            //    {
            //        RollbackDbTrans(ctx);

            //        return false;
            //    }

            //    CommitDbTrans(ctx);
            //}

            //return true;
            throw new Exception("SaveUpdate(int pUserID)");
        }

        #endregion

    }

    #endregion

    #region EDIReceiverSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class EDIReceiverSearchModel : BaseSearchModel
    {
        # region Properties
        //By sharon
        //public List<usp_GetBySearch_EDIReceiver_Result> EDIReceiverResults { get; set; }



        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIReceiverSearchModel()
        {
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            //using (EFContext ctx = new EFContext())
            //{
            //    EDIReceiverResults = new List<usp_GetBySearch_EDIReceiver_Result>(ctx.usp_GetBySearch_EDIReceiver(null,null,1,200,OrderByField,OrderByDirection,pIsActive));
            //}

            throw new Exception("FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)");
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #region EDI Display Tile

    public class EDIReceiverDisplayModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetNameCode_EDIReceiver_Result> EDIReceiverResult
        {
            get;
            set;
        }

        public List<Int32> EDIReciverCount
        {
            get;
            set;
        }

        public Nullable<int> ClinicID { get; set; }

        public string StatusIDs { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIReceiverDisplayModel()
        {
        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                EDIReceiverResult = new List<usp_GetNameCode_EDIReceiver_Result>(ctx.usp_GetNameCode_EDIReceiver(ClinicID, StatusIDs, null));
            }
        }

        #endregion

        #region public Methods

        #endregion
    }

    #endregion
}
