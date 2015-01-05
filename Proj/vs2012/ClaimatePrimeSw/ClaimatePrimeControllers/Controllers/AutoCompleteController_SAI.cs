using System;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeConstants;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public partial class AutoCompleteController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CityName(string stats)
        {
            return new JsonResultExtension { Data = (new CityAutoCompleteModel()).GetAutoCompleteCity(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ChartNumberPatient(string stats)
        {
            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompleteChartNumber(stats, ArivaSession.Sessions().SelClinicID) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param> 
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ChartNumber(string stats)
        {
            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompleteChartNumber(stats, ArivaSession.Sessions().SelClinicID) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult HospitalName(string stats)
        {


            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompleteClinicName(stats, Convert.ToByte(ArivaSession.Sessions().SelClinicID)) };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult StateName(string stats)
        {
            return new JsonResultExtension { Data = (new StateModel()).GetAutoCompleteState(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ClaimMedia(string stats)
        {
            return new JsonResultExtension { Data = (new ClaimMediaModel()).GetAutoCompleteClaimMedia(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ClaimMediaID(string selText)
        {

            return new JsonResultExtension { Data = (new ClaimMediaModel()).GetAutoCompleteClaimMediaID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DiagnosisGroup(string stats)
        {
            return new JsonResultExtension { Data = (new DiagnosisGroupModel()).GetAutoCompleteDiagnosisGroup(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DiagnosisGroupID(string selText)
        {

            return new JsonResultExtension { Data = (new DiagnosisGroupModel()).GetAutoCompleteDiagnosisGroupID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Credential(string stats)
        {
            return new JsonResultExtension { Data = (new CredentialModel()).GetAutoCompleteCredential(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CredentialID(string selText)
        {

            return new JsonResultExtension { Data = (new CredentialModel()).GetAutoCompleteCredentialID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetBAUserName(string stats)
        {
            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteNewUser(stats, Convert.ToByte(Role.EA_ROLE_ID)) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetBAUserNameID(string selText)
        {

            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteUserID(selText) };
        }
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetEAUserName(string stats)
        {
            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteNewUser(stats, Convert.ToByte(Role.EA_ROLE_ID)) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetEAUserNameID(string selText)
        {

            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteUserID(selText) };
        }
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetQAUserName(string stats)
        {
            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteNewUser(stats, Convert.ToByte(Role.EA_ROLE_ID)) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TargetQAUserNameID(string selText)
        {

            return new JsonResultExtension { Data = (new User_UserModel()).GetAutoCompleteUserID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult IPA(string stats)
        {
            return new JsonResultExtension { Data = (new IPAModel()).GetAutoCompleteIPA(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult IPAID(string selText)
        {

            return new JsonResultExtension { Data = (new IPAModel()).GetAutoCompleteIPAID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Specialty(string stats)
        {
            return new JsonResultExtension { Data = (new SpecialtyModel()).GetAutoCompleteSpecialty(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SpecialtyID(string selText)
        {

            return new JsonResultExtension { Data = (new SpecialtyModel()).GetAutoCompleteSpecialtyID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CurrencyCode(string stats)
        {
            return new JsonResultExtension { Data = (new CurrencyCodeModel()).GetAutoCompleteCurrencyCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CurrencyCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new CurrencyCodeModel()).GetAutoCompleteCurrencyCodeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PayerResponsibilitySequenceNumberCode(string stats)
        {
            return new JsonResultExtension { Data = (new PayerResponsibilitySequenceNumberCodeModel()).GetAutoCompletePayerResponsibilitySequenceNumberCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PayerResponsibilitySequenceNumberCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new PayerResponsibilitySequenceNumberCodeModel()).GetAutoCompletePayerResponsibilitySequenceNumberCodeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EmailCommunicationNumberQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EmailCommunicationNumberQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifierID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult FaxCommunicationNumberQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult FaxCommunicationNumberQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifierID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PhoneCommunicationNumberQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PhoneCommunicationNumberQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new CommunicationNumberQualifierModel()).GetAutoCompleteCommunicationNumberQualifierID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EntityType(string stats)
        {
            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityType(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EntityTypeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityTypeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientEntityTypeQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityType(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientEntityTypeQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityTypeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ProviderEntityTypeQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityType(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ProviderEntityTypeQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityTypeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceEntityTypeQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityType(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceEntityTypeQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityTypeQualifierModel()).GetAutoCompleteEntityTypeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AuthorizationQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new AuthorizationQualifierModel()).GetAutoCompleteAuthorizationQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AuthorizationQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new AuthorizationQualifierModel()).GetAutoCompleteAuthorizationQualifierID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SecurityQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new SecurityQualifierModel()).GetAutoCompleteSecurityQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SecurityQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new SecurityQualifierModel()).GetAutoCompleteSecurityQualifierID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TransactionPurposeCode(string stats)
        {
            return new JsonResultExtension { Data = (new TransactionPurposeCodeModel()).GetAutoCompleteTransactionPurposeCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TransactionPurposeCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new TransactionPurposeCodeModel()).GetAutoCompleteTransactionPurposeCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TransactionTypeCode(string stats)
        {
            return new JsonResultExtension { Data = (new TransactionTypeCodeModel()).GetAutoCompleteTransactionTypeCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult TransactionTypeCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new TransactionTypeCodeModel()).GetAutoCompleteTransactionTypeCodeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SenderInterchangeIDQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new InterchangeIDQualifierModel()).GetAutoCompleteInterchangeIDQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SenderInterchangeIDQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new InterchangeIDQualifierModel()).GetAutoCompleteInterchangeIDQualifierID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReceiverInterchangeIDQualifier(string stats)
        {
            return new JsonResultExtension { Data = (new InterchangeIDQualifierModel()).GetAutoCompleteInterchangeIDQualifier(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReceiverInterchangeIDQualifierID(string selText)
        {

            return new JsonResultExtension { Data = (new InterchangeIDQualifierModel()).GetAutoCompleteInterchangeIDQualifierID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SubmitterEntityIdentifierCode(string stats)
        {
            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SubmitterEntityIdentifierCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReceiverEntityIdentifierCode(string stats)
        {
            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReceiverEntityIdentifierCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult BillingProviderEntityIdentifierCode(string stats)
        {
            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult BillingProviderEntityIdentifierCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SubscriberEntityIdentifierCode(string stats)
        {
            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SubscriberEntityIdentifierCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PayerEntityIdentifierCode(string stats)
        {
            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCode(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PayerEntityIdentifierCodeID(string selText)
        {

            return new JsonResultExtension { Data = (new EntityIdentifierCodeModel()).GetAutoCompleteEntityIdentifierCodeID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UsageIndicator(string stats)
        {
            return new JsonResultExtension { Data = (new UsageIndicatorModel()).GetAutoCompleteUsageIndicator(stats) };
            //return View();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UsageIndicatorID(string selText)
        {

            return new JsonResultExtension { Data = (new UsageIndicatorModel()).GetAutoCompleteUsageIndicatorID(selText) };
            //return View();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManagerName(string stats)
        {
            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteManagerName(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Manager(string stats)
        {
            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteManagerName(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManagerClinic(string stats)
        {
            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteManagerNameClinic(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DocCategory(string stats)
        {
            return new JsonResultExtension { Data = (new PatientDocumentSaveModel()).GetAutoCompleteDocumentCategory(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DocCategoryID(string selText)
        {
            return new JsonResultExtension { Data = (new PatientDocumentSaveModel()).GetAutoCompleteDocumentCategoryID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceType(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteInsuranceType(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceTypeID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteInsuranceTypeID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EDIReceiver(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteEDIReceiver(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EDIReceiverID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteEDIReceiverID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PrintPin(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintPin(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PrintPinID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintPinID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientPrintSign(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSign(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientPrintSignID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSignID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuredPrintSign(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSign(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuredPrintSignID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSignID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PhysicianPrintSign(string stats)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSign(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PhysicianPrintSignID(string selText)
        {
            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompletePrintSignID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientProviderName(string stats)
        {
            int clinicid = int.Parse(ArivaSession.Sessions().SelClinicID.ToString());
            return new JsonResultExtension { Data = (new ProviderModel()).GetAutoCompleteProvider(stats, clinicid) };
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult StateNameID(string selText)
        {

            return new JsonResultExtension { Data = (new StateModel()).GetAutoCompleteStateID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManagerNameID(string selText)
        {

            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteUserID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManagerID(string selText)
        {

            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteUserID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ManagerClinicID(string selText)
        {

            return new JsonResultExtension { Data = (new UserRoleSearchModel()).GetAutoCompleteUserID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult HospitalNameID(string selText)
        {

            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompleteClinicID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ChartNumberPatientID(string selText)
        {

            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompletePatientID(ArivaSession.Sessions().SelClinicID, selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ChartNumberID(string selText)
        {

            return new JsonResultExtension { Data = (new PatientHospitalizationSaveModel()).GetAutoCompletePatientID(ArivaSession.Sessions().SelClinicID, selText) };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountryNameID(string selText)
        {

            return new JsonResultExtension { Data = (new CountryModel()).GetAutoCompleteCountryID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PatientProviderNameID(string selText)
        {

            return new JsonResultExtension { Data = (new ProviderModel()).GetAutoCompleteProviderID(selText) };
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceName(string stats)
        {

            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteInsurance(stats) };
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RelationshipName(string stats)
        {

            return new JsonResultExtension { Data = (new Relationship()).GetAutoCompleteRelationship(stats) };
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult InsuranceNameID(string selText)
        {

            return new JsonResultExtension { Data = (new InsuranceModel()).GetAutoCompleteInsuranceID(selText) };
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RelationshipNameID(string selText)
        {

            return new JsonResultExtension { Data = (new Relationship()).GetAutoCompleteRelationshipID(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountyNameID(string selText)
        {

            return new JsonResultExtension { Data = (new CountyModel()).GetAutoCompleteCountyID(selText) };
        }
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CityNameID(string selText)
        {

            return new JsonResultExtension { Data = (new CityAutoCompleteModel()).GetByZipCodeCity(selText) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountyName(string stats)
        {
            return new JsonResultExtension { Data = (new CountyModel()).GetAutoCompleteCounty(stats) };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CountryName(string stats)
        {
            return new JsonResultExtension { Data = (new CountryModel()).GetAutoCompleteCountry(stats) };
        }
    }
}
