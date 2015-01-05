using ANSI5010;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.StaticClasses;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using System.Text;

namespace ClaimatePrimeModels.Models
{
    # region OLD

    # region Old SRS From Sarur

    ///// <summary>
    ///// 
    ///// </summary>
    //public class EDIFileSaveModel : BaseSaveModel
    //{
    //    # region Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrRootPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIX12FilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIRefFilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String EDIX12FileRelPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String EDIRefFileRelPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int32 ClinicID
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int16 ClaimMediaID
    //    {
    //        get;
    //        set;
    //    }

    //    # endregion

    //    # region Abstract Methods

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveInsert(int pUserID)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            BeginDbTrans(ctx);

    //            try
    //            {
    //                # region Data

    //                # region Declaration

    //                Int64 eDIFileID;
    //                usp_GetByPkId_EDIReceiver_Result ediReceiverResult;
    //                usp_GetByPkId_AuthorizationInformationQualifier_Result authorizationQualifierResult;
    //                usp_GetByPkId_SecurityInformationQualifier_Result securityQualifierResult;
    //                usp_GetByPkId_TransactionSetPurposeCode_Result TransactionSetPurposeCodeResult;
    //                usp_GetByPkId_TransactionTypeCode_Result transactionTypeCodeResult;
    //                usp_GetByPkId_InterchangeUsageIndicator_Result usageIndicatorResult;
    //                usp_GetByPkId_ClaimMedia_Result claimMediaResult;
    //                usp_GetByPkId_Clinic_Result clinicResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result clinicEntityTypeQualifierResult;
    //                usp_GetByPkId_City_Result clinicCityResult;
    //                usp_GetByPkId_State_Result clinicStateResult;
    //                usp_GetByPkId_Country_Result clinicCountryResult;
    //                usp_GetAnsi837Const_ClaimProcess_Result ansi837ConstResult;
    //                List<usp_GetAnsi837Visit_ClaimProcess_Result> ansi837VisitResults;
    //                List<ANSI837Procedures> objProcedure;
    //                List<usp_GetAnsi837_ClaimDiagnosis_Result> claimNoDiagnosisResults;
    //                int loop;

    //                # endregion

    //                # region Fetch From DB

    //                eDIFileID = (new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("EDI", "EDIFile"))).FirstOrDefault().NEXT_INDENTITY;

    //                ediReceiverResult = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(ClaimMediaID, true))).FirstOrDefault();
    //                if (ediReceiverResult == null)
    //                {
    //                    ediReceiverResult = new usp_GetByPkId_EDIReceiver_Result();
    //                }

    //                authorizationQualifierResult = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(ediReceiverResult.AuthorizationQualifierID, true))).FirstOrDefault();
    //                if (authorizationQualifierResult == null)
    //                {
    //                    authorizationQualifierResult = new usp_GetByPkId_AuthorizationInformationQualifier_Result();
    //                }

    //                securityQualifierResult = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(ediReceiverResult.SecurityQualifierID, true))).FirstOrDefault();
    //                if (securityQualifierResult == null)
    //                {
    //                    securityQualifierResult = new usp_GetByPkId_SecurityInformationQualifier_Result();
    //                }

    //                TransactionSetPurposeCodeResult = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(ediReceiverResult.TransactionSetPurposeCodeID, true))).FirstOrDefault();
    //                if (TransactionSetPurposeCodeResult == null)
    //                {
    //                    TransactionSetPurposeCodeResult = new usp_GetByPkId_TransactionSetPurposeCode_Result();
    //                }

    //                transactionTypeCodeResult = (new List<usp_GetByPkId_TransactionTypeCode_Result>(ctx.usp_GetByPkId_TransactionTypeCode(ediReceiverResult.TransactionTypeCodeID, true))).FirstOrDefault();
    //                if (transactionTypeCodeResult == null)
    //                {
    //                    transactionTypeCodeResult = new usp_GetByPkId_TransactionTypeCode_Result();
    //                }

    //                usageIndicatorResult = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(ediReceiverResult.UsageIndicatorID, true))).FirstOrDefault();
    //                if (usageIndicatorResult == null)
    //                {
    //                    usageIndicatorResult = new usp_GetByPkId_InterchangeUsageIndicator_Result();
    //                }

    //                claimMediaResult = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(ediReceiverResult.ClaimMediaID, true))).FirstOrDefault();
    //                if (claimMediaResult == null)
    //                {
    //                    claimMediaResult = new usp_GetByPkId_ClaimMedia_Result();
    //                }

    //                ansi837ConstResult = (new List<usp_GetAnsi837Const_ClaimProcess_Result>(ctx.usp_GetAnsi837Const_ClaimProcess())).FirstOrDefault();
    //                if (ansi837ConstResult == null)
    //                {
    //                    ansi837ConstResult = new usp_GetAnsi837Const_ClaimProcess_Result();
    //                }

    //                clinicResult = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(ClinicID, true))).FirstOrDefault();
    //                if (clinicResult == null)
    //                {
    //                    clinicResult = new usp_GetByPkId_Clinic_Result();
    //                }

    //                clinicEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(clinicResult.EntityTypeQualifierID, true))).FirstOrDefault();
    //                if (clinicEntityTypeQualifierResult == null)
    //                {
    //                    clinicEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                clinicCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(clinicResult.CityID, true))).FirstOrDefault();
    //                if (clinicCityResult == null)
    //                {
    //                    clinicCityResult = new usp_GetByPkId_City_Result();
    //                }

    //                clinicStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(clinicResult.StateID, true))).FirstOrDefault();
    //                if (clinicStateResult == null)
    //                {
    //                    clinicStateResult = new usp_GetByPkId_State_Result();
    //                }

    //                clinicCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(clinicResult.CountryID, true))).FirstOrDefault();
    //                if (clinicCountryResult == null)
    //                {
    //                    clinicCountryResult = new usp_GetByPkId_Country_Result();
    //                }

    //                ansi837VisitResults = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID, ediReceiverResult.EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));

    //                # endregion

    //                # region Declaration & Initilization

    //                ANSIService client = new ANSIService();
    //                MedDetails objData = new MedDetails();
    //                ANSIDataBinder objANSIData = new ANSIDataBinder();
    //                List<ANSIWrapper> aryWrapper = new List<ANSIWrapper>();
    //                List<StringBuilder> strDataPro = new List<StringBuilder>();

    //                # endregion

    //                # region Visit Loop

    //                foreach (usp_GetAnsi837Visit_ClaimProcess_Result ansi837VisitResult in ansi837VisitResults)
    //                {
    //                    # region Data Visit Based

    //                    # region Declaration Visit Based

    //                    ANSIWrapper objWrap = new ANSIWrapper();
    //                    ANSI837FieldBinder obj837FieldBinder = new ANSI837FieldBinder();
    //                    List<ANSI837FieldBinder> objFieldBinder = new List<ANSI837FieldBinder>();

    //                    usp_GetByPkId_City_Result patientCityResult;
    //                    usp_GetByPkId_State_Result patientStateResult;
    //                    usp_GetByPkId_Country_Result patientCountryResult;
    //                    //
    //                    usp_GetByPkId_City_Result insuranceCityResult;
    //                    usp_GetByPkId_State_Result insuranceStateResult;
    //                    usp_GetByPkId_Country_Result insuranceCountryResult;
    //                    //
    //                    usp_GetByPkId_PatientHospitalization_Result hospitalizationResult;
    //                    usp_GetByPkId_PrintSign_Result patientPrintSignResult;
    //                    List<usp_GetAnsi837_ClaimDiagnosis_Result> claimDiagnosisResults;
    //                    List<long> claimNos;
    //                    List<usp_GetAnsi837_ClaimDiagnosisCPT_Result> cptResults;
    //                    List<usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result> modifierResults;

    //                    # endregion

    //                    # region Fetch From DB Visit Based

    //                    patientCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.PATIENT_CITY_ID, true))).First();
    //                    patientStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.PATIENT_STATE_ID, true))).First();
    //                    patientCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.PATIENT_COUNTRY_ID, true))).First();
    //                    //
    //                    insuranceCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.INSURANCE_CITY_ID, true))).First();
    //                    insuranceStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.INSURANCE_STATE_ID, true))).First();
    //                    insuranceCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.INSURANCE_COUNTRY_ID, true))).First();
    //                    //
    //                    if (ansi837VisitResult.PatientHospitalizationID.HasValue)
    //                    {
    //                        hospitalizationResult = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(ansi837VisitResult.PatientHospitalizationID.Value, true))).First();
    //                    }
    //                    else
    //                    {
    //                        hospitalizationResult = null;
    //                    }
    //                    patientPrintSignResult = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(ansi837VisitResult.PatientPrintSignID, true))).First();
    //                    claimDiagnosisResults = new List<usp_GetAnsi837_ClaimDiagnosis_Result>(ctx.usp_GetAnsi837_ClaimDiagnosis(ansi837VisitResult.PatientVisitID));
    //                    claimNos = new List<long>((from o in claimDiagnosisResults where o.CLAIM_NUMBER > 0 select o.CLAIM_NUMBER).Distinct());

    //                    # endregion

    //                    foreach (long claimNo in claimNos)
    //                    {
    //                        #region ISA Header

    //                        objANSIData.gatewayIDField = ediReceiverResult.ReceiverCarrier;
    //                        objANSIData.insurance_TypeField = ansi837ConstResult.PRIMARY_INSURANCE;
    //                        objANSIData.iSA01_Authorization_Info_QualifierField = authorizationQualifierResult.AuthorizationQualifierCode;
    //                        objANSIData.iSA02_Authorization_InformationField = ediReceiverResult.AuthorizationInfo;
    //                        objANSIData.iSA03_Security_Info_QualifierField = ediReceiverResult.SecurityInfo;
    //                        objANSIData.iSA04_Security_InformationField = securityQualifierResult.SecurityQualifierCode;
    //                        objANSIData.iSA05_Interchange_Sender_QualifierField = ansi837ConstResult.SENDER_QUALIFIER;
    //                        objANSIData.iSA06_Interchange_Sender_IDField = ediReceiverResult.InterReceiverID;
    //                        objANSIData.iSA07_Interchange_Receiver_QualifierField = ansi837ConstResult.RECEIVER_QUALIFIER;
    //                        objANSIData.iSA08_Interchange_Receiver_IDField = ediReceiverResult.InterReceiverID;
    //                        objANSIData.iSA09_Interchange_DateField = ansi837ConstResult.CURR_DT_TM.ToShortDateString();
    //                        objANSIData.iSA10_Interchange_TimeField = ansi837ConstResult.CURR_DT_TM.ToShortTimeString();
    //                        objANSIData.iSA13_Interchange_Control_NoField = eDIFileID.ToString();
    //                        objANSIData.iSA14_Acknowledgement_RequestedField = ansi837ConstResult.ACK_REQUEST.ToString();
    //                        objANSIData.iSA15_Usage_IndicatorField = usageIndicatorResult.UsageIndicatorCode;
    //                        objANSIData.gS02_Application_Sender_CodeField = ediReceiverResult.ApplnSenderCode;
    //                        objANSIData.gS03_Application_Receiver_CodeField = ediReceiverResult.ApplnReceiverCode;
    //                        objANSIData.gS06_Version_ID_CodeField = claimMediaResult.ClaimMediaCode;
    //                        objANSIData.bHT02_Tran_Set_Purpose_CodeField = TransactionSetPurposeCodeResult.TransactionSetPurposeCodeCode;
    //                        objANSIData.bHT06_Claim_Or_Encounter_IDField = transactionTypeCodeResult.TransactionTypeCodeCode;
    //                        objANSIData.rEF02_Tran_Type_CodeField = claimMediaResult.ClaimMediaCode;

    //                        #endregion

    //                        #region Submitter Details

    //                        objANSIData.nM102_Entity_Type_QualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                        objANSIData.nM103_Submitter_LastNameField = clinicResult.ClinicName;
    //                        objANSIData.nM104_Submitter_FirstNameField = clinicResult.ClinicName;
    //                        objANSIData.nM105_Submitter_MiddleNameField = clinicResult.ClinicName;
    //                        objANSIData.nM109_Submitter_IDField = clinicResult.NPI;

    //                        objANSIData.pER02_Submitter_Contact_NameField = string.Concat(clinicResult.ContactPersonLastName, " ", clinicResult.ContactPersonFirstName, " ", clinicResult.ContactPersonMiddleName).Trim();
    //                        objANSIData.pER04_Communication_No_1Field = clinicResult.ContactPersonPhoneNumber;
    //                        objANSIData.pER06_Communication_No_2Field = clinicResult.ContactPersonSecondaryPhoneNumber;
    //                        objANSIData.pER08_Communication_No_3Field = clinicResult.Fax;

    //                        objANSIData.nM103_Receiver_NameField = ediReceiverResult.EDIReceiverName;
    //                        objANSIData.nM109_Receiver_Primary_IdentifierField = ediReceiverResult.EDIReceiverID.ToString();

    //                        #endregion

    //                        #region Billing Provider

    //                        objANSIData.nM102_Billing_Provider_Entity_TypeQualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                        objANSIData.nM103_Billing_Provider_LastNameField = clinicResult.ClinicName;
    //                        objANSIData.nM104_Billing_Provider_FirstNameField = clinicResult.ClinicName;
    //                        objANSIData.nM105_Billing_Provider_MiddleNameField = clinicResult.ClinicName;
    //                        objANSIData.nM108_Billing_Provider_IDQualifierField = clinicResult.TaxID;
    //                        objANSIData.nM109_Billing_Provider_IdentifierField = clinicResult.NPI;
    //                        objANSIData.n301_Billing_Provider_Address1Field = clinicResult.StreetName;
    //                        objANSIData.n302_Billing_Provider_Address2Field = clinicResult.Suite;
    //                        objANSIData.n401_Billing_Provider_CityNameField = clinicCityResult.CityCode;
    //                        objANSIData.n402_Billing_Provider_StateCodeField = clinicStateResult.StateCode;
    //                        objANSIData.n403_Billing_Provider_PinCodeField = clinicCityResult.ZipCode;
    //                        objANSIData.n404_Billing_Provider_CountryCodeField = clinicCountryResult.CountryCode;
    //                        objANSIData.rEF01_Billing_Provider_IDQualifierField = clinicResult.NPI;
    //                        objANSIData.rEF02_Billing_Provider_AdditionalIDField = clinicResult.NPI;

    //                        #endregion

    //                        ////////////////////////////////////////////////////////////////////////////////////////////////////////

    //                        #region Pay To Provider

    //                        objANSIData.isBillerAndPayerSameField = ansi837ConstResult.IS_BILLER_PAYER_SAME;

    //                        if (!(objANSIData.isBillerAndPayerSameField))
    //                        {
    //                            objANSIData.nM102_Pay_Provider_Entity_TypeQualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                            objANSIData.nM103_Pay_Provider_LastNameField = clinicResult.ClinicName;
    //                            objANSIData.nM104_Pay_Provider_FirstNameField = clinicResult.ClinicName;
    //                            objANSIData.nM105_Pay_Provider_MiddleNameField = clinicResult.ClinicName;
    //                            objANSIData.nM109_Pay_Provider_IdentifierField = clinicResult.NPI;
    //                            objANSIData.n301_Pay_Provider_Address1Field = clinicResult.StreetName;
    //                            objANSIData.n302_Pay_Provider_Address2Field = clinicResult.Suite;
    //                            objANSIData.n401_Pay_Provider_CityNameField = clinicCityResult.CityCode;
    //                            objANSIData.n402_Pay_Provider_StateCodeField = clinicStateResult.StateCode;
    //                            objANSIData.n403_Pay_Provider_PinCodeField = clinicCityResult.ZipCode;
    //                            objANSIData.n404_Pay_Provider_CountryCodeField = clinicCountryResult.CountryCode;
    //                        }

    //                        obj837FieldBinder.primaryInsuranceIDField = ansi837VisitResult.InsuranceCode;
    //                        obj837FieldBinder.secondaryInsuranceIDField = ansi837VisitResult.InsuranceCode;

    //                        #endregion

    //                        // Subscribers Loop
    //                        obj837FieldBinder.isSecondaryCrossOverField = ansi837ConstResult.IS_SECONDARY_CROSS_OVER;
    //                        obj837FieldBinder.sBR03_SubscriberInfo_GroupNoField = ansi837VisitResult.GroupNumber;
    //                        obj837FieldBinder.sBR04_SubscriberInfo_GroupNameField = ansi837VisitResult.InsuranceCode;
    //                        obj837FieldBinder.sBR09_SubscriberInfo_ClaimFillIndicatorCodeField = ansi837VisitResult.InsuranceTypeCode;

    //                        obj837FieldBinder.nM103_SubscriberInfo_LastNameField = ansi837VisitResult.PATIENT_LAST_NAME; // Patient 
    //                        obj837FieldBinder.nM104_SubscriberInfo_FirstNameField = ansi837VisitResult.PATIENT_FIRST_NAME;   // Patient 
    //                        obj837FieldBinder.nM105_SubscriberInfo_MiddleNameField = ansi837VisitResult.PATIENT_MIDDLE_NAME; // Patient 
    //                        obj837FieldBinder.nM108_SubscriberInfo_IDCodeQualifierField = ansi837VisitResult.InsuranceTypeCode;
    //                        obj837FieldBinder.nM109_SubscriberInfo_PrimaryIdentifierField = ansi837VisitResult.PolicyNumber;

    //                        obj837FieldBinder.n301_SubscriberInfo_Address1Field = ansi837VisitResult.PATIENT_STREET_NAME; // Patient
    //                        obj837FieldBinder.n302_SubscriberInfo_Address2Field = ansi837VisitResult.PATIENT_SUITE; // Patient
    //                        obj837FieldBinder.n401_SubscriberInfo_CityNameField = patientCityResult.CityCode;
    //                        obj837FieldBinder.n402_SubscriberInfo_StateCodeField = patientStateResult.StateCode;
    //                        obj837FieldBinder.n403_SubscriberInfo_ZipCodeField = patientCityResult.ZipCode;
    //                        obj837FieldBinder.n404_SubscriberInfo_CountryCodeField = patientCountryResult.CountryCode;

    //                        obj837FieldBinder.dMG02_SubscriberDemographicInfo_BirthDateField = ansi837ConstResult.SUBSCRIBER_BIRTH_DATE;
    //                        obj837FieldBinder.dMG03_SubscriberDemographicInfo_GenderCodeField = ansi837ConstResult.SUBSCRIBER_GENDER_CODE;

    //                        obj837FieldBinder.rEF01_SubscriberSecondaryInfo_IDQualifierField = ansi837ConstResult.SUBSCRIBER_ID_QUALIFIER;
    //                        obj837FieldBinder.rEF02_SubscriberSecondaryInfo_IDField = ansi837ConstResult.SUBSCRIBER_ID;

    //                        // Payer Details
    //                        obj837FieldBinder.nM103_Payer_NameField = ansi837VisitResult.InsuranceCode;
    //                        obj837FieldBinder.nM108_Payer_IDCodeQualifierField = ansi837VisitResult.PayerID;
    //                        obj837FieldBinder.nM109_Payer_PayerIdentifierField = ansi837VisitResult.PayerID;

    //                        obj837FieldBinder.n301_Payer_Address1Field = ansi837VisitResult.INSURANCE_STREET_NAME;    // Insurance
    //                        obj837FieldBinder.n302_Payer_Address2Field = ansi837VisitResult.INSURANCE_SUITE;     // Insurance
    //                        obj837FieldBinder.n401_Payer_CityNameField = insuranceCityResult.CityCode;
    //                        obj837FieldBinder.n402_Payer_StateCodeField = insuranceStateResult.StateCode;
    //                        obj837FieldBinder.n403_Payer_ZipCodeField = insuranceCityResult.ZipCode;
    //                        obj837FieldBinder.n404_Payer_CountryCodeField = insuranceCountryResult.CountryCode;

    //                        obj837FieldBinder.rEF01_Payer_IDQualifierField = ansi837VisitResult.PayerID;
    //                        obj837FieldBinder.rEF02_Payer_IDField = ansi837VisitResult.PayerID;

    //                        obj837FieldBinder.pAT01_Patient_IndRelationshipCodeField = ansi837VisitResult.RelationshipCode;

    //                        // Checking whether patient status is dead or not
    //                        // Here no more death case
    //                        //if (dtData.Rows[iCurRow]["fvDeathStatus"].ToString().Equals("Death") && !(dtData.Rows[iCurRow]["fvPreEstDt"].ToString().Equals("-1") || dtData.Rows[iCurRow]["fvPreEstDt"].ToString().Equals("")))
    //                        //{
    //                        //    obj837FieldBinder.pAT05_Patient_IllDateTimeQualifierField = "D8";
    //                        //    obj837FieldBinder.pAT06_Patient_DeathDateField = dtData.Rows[iCurRow]["fvPreEstDt"].ToString();
    //                        //}

    //                        obj837FieldBinder.pAT07_UnitorBasicMesurementCodeField = ansi837ConstResult.UNITOR_CODE;
    //                        obj837FieldBinder.pAT08_WeightField = ansi837ConstResult.UNITOR_WEIGHT;

    //                        // Applied only to female patient is Pregnant
    //                        obj837FieldBinder.pAT09_Patient_PregnancyIndicatorField = ansi837ConstResult.IS_PREGNANCY;

    //                        // Patient Details
    //                        obj837FieldBinder.nM103_Patient_LastNameField = ansi837VisitResult.PATIENT_LAST_NAME;
    //                        obj837FieldBinder.nM104_Patient_FirstNameField = ansi837VisitResult.PATIENT_FIRST_NAME;
    //                        obj837FieldBinder.nM105_Patient_MiddleNameField = ansi837VisitResult.PATIENT_MIDDLE_NAME;
    //                        obj837FieldBinder.nM107_Patient_SuffixNameField = ansi837ConstResult.PATIENT_SUFFIX;
    //                        obj837FieldBinder.nM108_Patient_IDCodeQualifierField = ansi837ConstResult.PATIENT_ID_CODE;
    //                        obj837FieldBinder.nM109_Patient_PrimaryIdentifierField = ansi837ConstResult.PATIENT_PRIMARY_ID;

    //                        obj837FieldBinder.n301_Patient_Address1Field = ansi837VisitResult.PATIENT_STREET_NAME;
    //                        obj837FieldBinder.n302_Patient_Address2Field = ansi837VisitResult.PATIENT_SUITE;
    //                        obj837FieldBinder.n401_Patient_CityNameField = patientCityResult.CityCode;
    //                        obj837FieldBinder.n402_Patient_StateCodeField = patientStateResult.StateCode;
    //                        obj837FieldBinder.n403_Patient_ZIPCodeField = patientCityResult.ZipCode;
    //                        obj837FieldBinder.n404_Patient_CountryCodeField = patientCountryResult.CountryCode;

    //                        obj837FieldBinder.dMG02_Patient_BirthDateField = ansi837VisitResult.DOB.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.dMG03_Patient_GenderCodeField = ansi837VisitResult.Sex;

    //                        obj837FieldBinder.dMG02_Patient_RefIDQualifierField = ansi837ConstResult.PATIENT_REF_ID1;
    //                        obj837FieldBinder.dMG03_Patient_SecondaryIDField = ansi837ConstResult.PATIENT_REF_ID2;

    //                        // Date Loop
    //                        obj837FieldBinder.dTP03_Date_InitialTreatmentField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.dTP03_Date_OnsetCurrentIllness_SymptomField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.dTP03_Date_SimilarIllness_SymptomOnsetField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.dTP03_Date_AccidentField = ansi837ConstResult.DATE_ACCIDENT;
    //                        obj837FieldBinder.dTP03_Date_LastMenstrualPeriodField = ansi837ConstResult.DATE_LMP;
    //                        obj837FieldBinder.dTP03_Date_LastXRayField = ansi837ConstResult.DATE_XRAY;
    //                        obj837FieldBinder.dTP03_Date_EstimatedDateofBirthField = ansi837ConstResult.DATE_DELIVERY;
    //                        obj837FieldBinder.dTP03_Date_DisabilityBeginField = ansi837ConstResult.DATE_DISABILITY;
    //                        obj837FieldBinder.dTP03_Date_DisabilityEndField = ansi837ConstResult.DATE_DISABILITY;
    //                        obj837FieldBinder.dTP03_Date_LastWorkedField = ansi837ConstResult.DATE_WORKED;
    //                        obj837FieldBinder.dTP03_Date_AuthorizedReturnToWorkField = ansi837ConstResult.DATE_WORKED;
    //                        obj837FieldBinder.dTP03_Date_AdmissionField = (hospitalizationResult == null) ? ansi837ConstResult.DATE_HOSPITAL : hospitalizationResult.AdmittedOn.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.dTP03_Date_DischargeField = (hospitalizationResult == null) ? ansi837ConstResult.DATE_HOSPITAL : (hospitalizationResult.DischargedOn.HasValue) ? hospitalizationResult.DischargedOn.Value.ToString("MM/dd/yyyy") : ansi837ConstResult.DATE_HOSPITAL;
    //                        obj837FieldBinder.dTP03_Date_AssumedAndRelinquishedCareDatesField = ansi837ConstResult.DATE_CARE;
    //                        obj837FieldBinder.dTP03_Date_PropertyAndCasualtyDateOfFirstContactField = ansi837ConstResult.DATE_CONTACT;
    //                        obj837FieldBinder.rEF02_PriorAuthorizationOrReferalNumberField = ansi837ConstResult.PRIOR_AUTH_NUM;

    //                        // Claim Information
    //                        obj837FieldBinder.cLM01_ClaimInfo_PatientAccountNoField = ansi837VisitResult.ChartNumber;
    //                        obj837FieldBinder.cLM053_ClaimInfo_FrequencyCodeField = ansi837ConstResult.CLAIM_FREQUENCY;

    //                        // Provider Signature
    //                        obj837FieldBinder.cLM06_ClaimInfo_ProviderSupplier_SignatureField = ansi837VisitResult.PrintPinCode;
    //                        obj837FieldBinder.cLM08_ClaimInfo_BenefitsAssignCertificateIndicatorField = ansi837VisitResult.PrintPinCode;
    //                        obj837FieldBinder.cLM09_ClaimInfo_ReleaseInformationCodeField = patientPrintSignResult.PrintSignCode;
    //                        obj837FieldBinder.cLM010_ClaimInfo_PatientSignatureSourceCodeField = patientPrintSignResult.PrintSignCode;
    //                        obj837FieldBinder.cLM07_ClaimInfo_MedicareAssignmentCodeField = ansi837VisitResult.MedicareID;

    //                        // Yet to implement with accident related
    //                        obj837FieldBinder.cLM0111_ClaimInfo_RelatedCauseCode1Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_1;
    //                        obj837FieldBinder.cLM0112_ClaimInfo_RelatedCauseCode2Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_2;
    //                        obj837FieldBinder.cLM0113_ClaimInfo_RelatedCauseCode3Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_3;
    //                        obj837FieldBinder.cLM0114_ClaimInfo_AutoAccidentStateProvinceCodeField = ansi837ConstResult.ACCIDENT_PROVINCE_CODE;
    //                        obj837FieldBinder.cLM0115_ClaimInfo_CountryCodeField = ansi837ConstResult.ACCIDENT_COUNTRY_CODE;
    //                        obj837FieldBinder.cLM012_ClaimInfo_SpProgramIndicatorField = ansi837ConstResult.ACCIDENT_PROVINCE_CODE;
    //                        obj837FieldBinder.cLM020_ClaimInfo_DelayReasonCodeField = ansi837ConstResult.ACCIDENT_DELAY_CODE;

    //                        // Filling Refering Providers
    //                        obj837FieldBinder.nM101_ReferProvider_EntityIdentifierCodeField = ansi837ConstResult.REF_PROV_ENTITY_CODE;
    //                        obj837FieldBinder.nM102_ReferProvider_EntityTypeQualifierField = ansi837ConstResult.REF_PROV_ENTITY_TYPE;
    //                        obj837FieldBinder.nM103_ReferProvider_LastNameField = ansi837VisitResult.PROVIDER_LAST_NAME;
    //                        obj837FieldBinder.nM104_ReferProvider_FirstNameField = ansi837VisitResult.PROVIDER_FIRST_NAME;
    //                        obj837FieldBinder.nM105_ReferProvider_MiddleNameField = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
    //                        obj837FieldBinder.nM107_ReferProvider_SuffixNameField = ansi837VisitResult.CredentialCode;
    //                        obj837FieldBinder.nM108_ReferProvider_IDCodeQualifierField = ansi837ConstResult.REF_PROV_QUALI_CODE;
    //                        obj837FieldBinder.nM109_ReferProvider_IdentifierField = ansi837VisitResult.NPI;

    //                        obj837FieldBinder.rEF01_ReferProvider_IDQualifierField = ansi837VisitResult.TaxID;
    //                        obj837FieldBinder.rEF02_ReferProvider_SecondaryIDField = ansi837VisitResult.TaxID;

    //                        // Filling RenderingProviders
    //                        obj837FieldBinder.nM101_RenderProvider_EntityIdentifierCodeField = ansi837ConstResult.REN_PROV_ENTITY_CODE;
    //                        obj837FieldBinder.nM102_RenderProvider_EntityTypeQualifierField = ansi837ConstResult.REN_PROV_ENTITY_TYPE;
    //                        obj837FieldBinder.nM103_RenderProvider_LastNameField = ansi837VisitResult.PROVIDER_LAST_NAME;
    //                        obj837FieldBinder.nM104_RenderProvider_FirstNameField = ansi837VisitResult.PROVIDER_FIRST_NAME;
    //                        obj837FieldBinder.nM105_RenderProvider_MiddleNameField = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
    //                        obj837FieldBinder.nM107_RenderProvider_SuffixNameField = ansi837VisitResult.CredentialCode;
    //                        obj837FieldBinder.nM108_RenderProvider_IDCodeQualifierField = ansi837ConstResult.REN_PROV_QUALI_CODE;
    //                        obj837FieldBinder.nM109_RenderProvider_IdentifierField = ansi837VisitResult.NPI;

    //                        obj837FieldBinder.pRV02_RenderProvider_IDQualifierField = ansi837ConstResult.REN_PROV_QUALI_ID;
    //                        obj837FieldBinder.pRV02_RenderProvider_TaxonomyCodeField = ansi837VisitResult.SpecialtyCode;

    //                        obj837FieldBinder.rEF01_RenderProvider_IDQualifierField = ansi837VisitResult.TaxID;
    //                        obj837FieldBinder.rEF02_RenderProvider_SecondaryIDField = ansi837VisitResult.TaxID;

    //                        // Service Facility

    //                        obj837FieldBinder.nM103_ServiceFacility_FacilityNameField = clinicResult.ClinicName;
    //                        obj837FieldBinder.nM108_ServiceFacility_IDCodeQualifierField = clinicResult.TaxID;
    //                        obj837FieldBinder.nM109_ServiceFacility_PrimaryIdentifierField = clinicResult.NPI;

    //                        obj837FieldBinder.n301_ServiceFacility_Address1Field = clinicResult.StreetName;
    //                        obj837FieldBinder.n302_ServiceFacility_Address2Field = clinicResult.Suite;

    //                        obj837FieldBinder.n401_ServiceFacility_CityNameField = clinicCityResult.CityCode;
    //                        obj837FieldBinder.n402_ServiceFacility_StateCodeField = clinicStateResult.StateCode;
    //                        obj837FieldBinder.n403_ServiceFacility_ZipCodeField = clinicCityResult.ZipCode;
    //                        obj837FieldBinder.n404_ServiceFacility_CountryCodeField = clinicCountryResult.CountryCode;

    //                        obj837FieldBinder.rEF01_ServiceFacility_IDQualifierField = clinicResult.NPI;
    //                        obj837FieldBinder.rEF02_ServiceFacility_FacilitySecondaryIDField = clinicResult.TaxID;

    //                        // Secondary Insurance Details

    //                        obj837FieldBinder.sBR01_Secondary_PayerResponsibleSequenceNoCodeField = ansi837ConstResult.PRIMARY_INSURANCE;
    //                        obj837FieldBinder.sBR02_Secondary_IndividualResponseCodeField = ansi837VisitResult.RelationshipCode;
    //                        obj837FieldBinder.sBR04_Secondary_GroupNameField = ansi837VisitResult.GroupNumber;
    //                        obj837FieldBinder.sBR05_Secondary_InsuranceTypeCodeField = ansi837VisitResult.InsuranceTypeCode;
    //                        obj837FieldBinder.sBR09_Secondary_ClaimFillingIndicatorCodeField = ansi837VisitResult.PolicyNumber;
    //                        obj837FieldBinder.sDMG02_Secondary_BirthDateField = ansi837VisitResult.DOB.ToString("MM/dd/yyyy");
    //                        obj837FieldBinder.sDMG03_Secondary_GenderCodeField = ansi837VisitResult.Sex;


    //                        /////////////////////////////////////////////////////////////////////////////////////////////////

    //                        objProcedure = new List<ANSI837Procedures>();
    //                        claimNoDiagnosisResults = new List<usp_GetAnsi837_ClaimDiagnosis_Result>(from o in claimDiagnosisResults where o.CLAIM_NUMBER == claimNo select o);
    //                        loop = 0;
    //                        foreach (usp_GetAnsi837_ClaimDiagnosis_Result claimNoDiagnosisResult in claimNoDiagnosisResults)
    //                        {
    //                            loop++;

    //                            // Filling Diagnosis Informations
    //                            switch (loop)
    //                            {
    //                                case 1:
    //                                    obj837FieldBinder.hI101_2_Diagnosis_Code1Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 2:
    //                                    obj837FieldBinder.hI102_2_Diagnosis_Code2Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 3:
    //                                    obj837FieldBinder.hI103_2_Diagnosis_Code3Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 4:
    //                                    obj837FieldBinder.hI104_2_Diagnosis_Code4Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 5:
    //                                    obj837FieldBinder.hI105_2_Diagnosis_Code5Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 6:
    //                                    obj837FieldBinder.hI106_2_Diagnosis_Code6Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 7:
    //                                    obj837FieldBinder.hI107_2_Diagnosis_Code7Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 8:
    //                                    obj837FieldBinder.hI108_2_Diagnosis_Code8Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 9:
    //                                    obj837FieldBinder.hI109_2_Diagnosis_Code9Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 10:
    //                                    obj837FieldBinder.hI110_2_Diagnosis_Code10Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 11:
    //                                    obj837FieldBinder.hI111_2_Diagnosis_Code11Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                case 12:
    //                                    obj837FieldBinder.hI112_2_Diagnosis_Code12Field = claimNoDiagnosisResult.CODE;
    //                                    break;
    //                                default:
    //                                    throw new Exception("Sorry! More than 12 Dx in a same claim number is not allowed");
    //                            }

    //                            cptResults = new List<usp_GetAnsi837_ClaimDiagnosisCPT_Result>(ctx.usp_GetAnsi837_ClaimDiagnosisCPT(claimNoDiagnosisResult.CLAIM_DIAGNOSIS_ID));

    //                            foreach (usp_GetAnsi837_ClaimDiagnosisCPT_Result cptResult in cptResults)
    //                            {
    //                                ANSI837Procedures obj837Procedures = new ANSI837Procedures();
    //                                // Filling Procedures Informations
    //                                obj837Procedures.dTP103_ServiceLine_DOSField = cptResult.CPTDOS.ToString("MM/dd/yyyy");
    //                                obj837Procedures.sV1012_ServiceLine_ProcedureCodeField = cptResult.CPTCode;
    //                                obj837Procedures.sV102_ServiceLine_ChargeAmtField = (cptResult.ChargePerUnit * cptResult.Unit).ToString();
    //                                obj837Procedures.sV104_ServiceLine_UnitCountField = cptResult.Unit.ToString();
    //                                obj837Procedures.sV105_ServiceLine_POSField = cptResult.FacilityTypeCode;
    //                                obj837Procedures.sV1071_ServiceLine_DiagnosisCodePtr1Field = cptResult.FacilityTypeCode;
    //                                obj837FieldBinder.cLM02_ClaimInfo_TotalClaimAmountField = (cptResult.ChargePerUnit * cptResult.Unit).ToString();
    //                                obj837FieldBinder.cLM051_ClaimInfo_FacilityTypeCodeField = cptResult.FacilityTypeCode;

    //                                obj837Procedures.sV109_ServiceLine_EmergencyIndicatorField = ansi837ConstResult.EMERGENCY_INDICATOR;
    //                                obj837Procedures.sV111_ServiceLine_EPSDTIndicator_MedicaidOnlyField = ansi837ConstResult.EMERGENCY_EPSD;
    //                                obj837Procedures.sV112_ServiceLine_FamilyPlanIndicator_MedicaidOnlyField = ansi837ConstResult.EMERGENCY_FAMILY;

    //                                modifierResults = new List<usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result>(ctx.usp_GetAnsi837_ClaimDiagnosisCPTModifier(cptResult.ClaimDiagnosisCPTID));

    //                                foreach (usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result modifierResult in modifierResults)
    //                                {
    //                                    switch (modifierResult.ModifierLevel)
    //                                    {
    //                                        case 1:
    //                                            obj837Procedures.sV1013_ServiceLine_Modifier1Field = modifierResult.ModifierCode;
    //                                            break;
    //                                        case 2:
    //                                            obj837Procedures.sV1014_ServiceLine_Modifier2Field = modifierResult.ModifierCode;
    //                                            break;
    //                                        case 3:
    //                                            obj837Procedures.sV1015_ServiceLine_Modifier3Field = modifierResult.ModifierCode;
    //                                            break;
    //                                        case 4:
    //                                            obj837Procedures.sV1016_ServiceLine_Modifier4Field = modifierResult.ModifierCode;
    //                                            break;
    //                                        case 5:
    //                                            obj837Procedures.sV1017_ServiceLine_Modifier5Field = modifierResult.ModifierCode;
    //                                            break;
    //                                        default:
    //                                            throw new Exception("Sorry! More than 5 Modifier levels in a same CPT is not allowed");
    //                                    }
    //                                }                                   

    //                                objProcedure.Add(obj837Procedures);
    //                            }
    //                        }

    //                        objFieldBinder.Add(obj837FieldBinder);


    //                        objWrap.caseNumberField = ansi837VisitResult.PatientVisitID; // Storing the case no
    //                        objWrap.aNSI837ProceduresField = objProcedure.ToArray();
    //                        objWrap.aNSI837FieldBinderField = objFieldBinder.ToArray();

    //                        aryWrapper.Add(objWrap);

    //                    #endregion
    //                    }
    //                }

    //                # endregion

    //                objData.aNSI837DataBinderField = objANSIData;
    //                objData.aNSI837WrapperField = aryWrapper.ToArray();

    //                strDataPro = client.CreateASCI837(objData).ToList();

    //                # endregion

    //                # region Save

    //                FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", eDIFileID);
    //                if (!(Directory.Exists(FileSvrEDIX12FilePath)))
    //                {
    //                    DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIX12FilePath);
    //                    dirInfo = null;
    //                }
    //                FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "X12_5010_", eDIFileID, ".txt");

    //                FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", eDIFileID);
    //                if (!(Directory.Exists(FileSvrEDIRefFilePath)))
    //                {
    //                    DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIRefFilePath);
    //                    dirInfo = null;
    //                }
    //                FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "Ref_5010_", eDIFileID, ".txt");

    //                EDIX12FileRelPath = FileSvrEDIX12FilePath.Replace(FileSvrRootPath, string.Empty);
    //                EDIRefFileRelPath = FileSvrEDIRefFilePath.Replace(FileSvrRootPath, string.Empty);

    //                //http://social.msdn.microsoft.com/Forums/en-US/csharpgeneral/thread/7f42a0cb-2113-4749-bfd9-8e5228345c68

    //                using (TextWriter tw = new StreamWriter(FileSvrEDIX12FilePath, false, Encoding.GetEncoding(1252)))
    //                {
    //                    tw.WriteLine(strDataPro[1]);
    //                }

    //                using (TextWriter tw = new StreamWriter(FileSvrEDIRefFilePath, false, Encoding.GetEncoding(1252)))
    //                {
    //                    tw.WriteLine(strDataPro[0]);
    //                }

    //                # endregion

    //                CommitDbTrans(ctx);
    //            }
    //            catch (Exception ex)
    //            {
    //                RollbackDbTrans(ctx);
    //                throw ex;
    //            }
    //        }

    //        return true;
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveUpdate(int pUserID)
    //    {
    //        throw new NotImplementedException();
    //    }

    //    # endregion
    //}

    # endregion

    # region OLD Save SRS

    ///// <summary>
    ///// 
    ///// </summary>
    //public class Ansi8375010SaveModel : BaseSaveModel
    //{
    //    # region Private Variables

    //    private global::System.String _EDIX12FileRelPath;
    //    private global::System.String _EDIRefFileRelPath;

    //    # endregion

    //    # region Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String ANSI5010XmlPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrRootPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIX12FilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIRefFilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int32 ClinicID
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.DateTime EDIFileDate
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int32 EDIFileID
    //    {
    //        get;
    //        set;
    //    }

    //    # endregion

    //    # region Abstract Methods

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveInsert(int pUserID)
    //    {
    //        Static5010.LoadXml(ANSI5010XmlPath);

    //        using (EFContext ctx = new EFContext())
    //        {
    //            BeginDbTrans(ctx);

    //            try
    //            {
    //                # region Declaration

    //                ANSI5010Main objANSI5010Main;
    //                List<ANSI5010Loop> ansi5010Loops;
    //                usp_GetByPkId_EDIReceiver_Result ediReceiverResult;
    //                usp_GetByPkId_AuthorizationInformationQualifier_Result authorizationInformationQualifierResult;
    //                usp_GetByPkId_SecurityInformationQualifier_Result securityInformationQualifierrResult;
    //                usp_GetByPkId_InterchangeIDQualifier_Result senderInterchangeIDQualifierResult;
    //                usp_GetByPkId_InterchangeIDQualifier_Result receiverInterchangeIDQualifierResult;
    //                usp_GetByPkId_TransactionSetPurposeCode_Result transactionSetPurposeCodeResult;
    //                usp_GetByPkId_TransactionTypeCode_Result transactionTypeCodeResult;
    //                usp_GetByPkId_ClaimMedia_Result claimMediaResult;
    //                usp_GetByPkId_InterchangeUsageIndicator_Result interchangeUsageIndicatorResult;
    //                usp_GetByPkId_EntityIdentifierCode_Result submitterEntityIdentifierCodeResult;
    //                usp_GetByPkId_EntityIdentifierCode_Result receiverEntityIdentifierCodeResult;
    //                usp_GetByPkId_EntityIdentifierCode_Result billingProviderEntityIdentifierCodeResult;
    //                usp_GetByPkId_EntityIdentifierCode_Result subscriberEntityIdentifierCodeResult;
    //                usp_GetByPkId_EntityIdentifierCode_Result payerEntityIdentifierCodeResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result ediReceiverEntityTypeQualifierResult;
    //                usp_GetByPkId_CurrencyCode_Result currencyCodeResult;
    //                usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result payerResponsibilitySequenceNumberCodeResult;
    //                usp_GetByPkId_CommunicationNumberQualifier_Result emailCommunicationNumberQualifierResult;
    //                usp_GetByPkId_CommunicationNumberQualifier_Result faxCommunicationNumberQualifierResult;
    //                usp_GetByPkId_CommunicationNumberQualifier_Result phoneCommunicationNumberQualifierResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result patientEntityTypeQualifierResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result providerEntityTypeQualifierResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result insuranceEntityTypeQualifierResult;

    //                usp_GetByPkId_Clinic_Result clinicResult;
    //                usp_GetByPkId_IPA_Result ipaResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result clinicEntityTypeQualifierResult;
    //                usp_GetByPkId_City_Result clinicCityResult;
    //                usp_GetByPkId_State_Result clinicStateResult;
    //                usp_GetByPkId_Country_Result clinicCountryResult;
    //                usp_GetByPkId_Specialty_Result clinicSpecialtyResult;
    //                usp_GetByPkId_EntityTypeQualifier_Result ipaEntityTypeQualifierResult;
    //                usp_GetByPkId_City_Result ipaCityResult;
    //                usp_GetByPkId_State_Result ipaStateResult;
    //                usp_GetByPkId_Country_Result ipaCountryResult;
    //                List<usp_GetAnsi837Visit_ClaimProcess_Result> ansi837VisitResults;
    //                List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result> visitCPTResults;
    //                List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result> claimCPTResults;
    //                usp_GetByPkId_City_Result patientCityResult;
    //                usp_GetByPkId_State_Result patientStateResult;
    //                usp_GetByPkId_Country_Result patientCountryResult;
    //                usp_GetByPkId_City_Result insuranceCityResult;
    //                usp_GetByPkId_State_Result insuranceStateResult;
    //                usp_GetByPkId_Country_Result insuranceCountryResult;
    //                usp_GetByPkId_PatientHospitalization_Result hospitalizationResult;
    //                usp_GetByPkId_PrintSign_Result patientPrintSignResult;

    //                ObjectParameter objParam;
    //                int hierarchicalIDNumber;
    //                List<long> claimNos;
    //                decimal? claimTotCharge;
    //                UInt16 claimCPTCount;
    //                string prevDxCode;

    //                # endregion

    //                # region Data

    //                # region Fetch From DB

    //                EDIFileID = Convert.ToInt32((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("EDI", "EDIFile"))).FirstOrDefault().NEXT_INDENTITY);

    //                ediReceiverResult = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(Convert.ToInt32(EDIReceiver.EMDEON5010), true))).FirstOrDefault();
    //                if (ediReceiverResult == null)
    //                {
    //                    ediReceiverResult = new usp_GetByPkId_EDIReceiver_Result();
    //                }

    //                authorizationInformationQualifierResult = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(ediReceiverResult.AuthorizationInformationQualifierID, true))).FirstOrDefault();
    //                if (authorizationInformationQualifierResult == null)
    //                {
    //                    authorizationInformationQualifierResult = new usp_GetByPkId_AuthorizationInformationQualifier_Result();
    //                }

    //                securityInformationQualifierrResult = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(ediReceiverResult.SecurityInformationQualifierID, true))).FirstOrDefault();
    //                if (securityInformationQualifierrResult == null)
    //                {
    //                    securityInformationQualifierrResult = new usp_GetByPkId_SecurityInformationQualifier_Result();
    //                }

    //                senderInterchangeIDQualifierResult = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(ediReceiverResult.SenderInterchangeIDQualifierID, true))).FirstOrDefault();
    //                if (senderInterchangeIDQualifierResult == null)
    //                {
    //                    senderInterchangeIDQualifierResult = new usp_GetByPkId_InterchangeIDQualifier_Result();
    //                }

    //                receiverInterchangeIDQualifierResult = (new List<usp_GetByPkId_InterchangeIDQualifier_Result>(ctx.usp_GetByPkId_InterchangeIDQualifier(ediReceiverResult.ReceiverInterchangeIDQualifierID, true))).FirstOrDefault();
    //                if (receiverInterchangeIDQualifierResult == null)
    //                {
    //                    receiverInterchangeIDQualifierResult = new usp_GetByPkId_InterchangeIDQualifier_Result();
    //                }

    //                transactionSetPurposeCodeResult = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(ediReceiverResult.TransactionSetPurposeCodeID, true))).FirstOrDefault();
    //                if (transactionSetPurposeCodeResult == null)
    //                {
    //                    transactionSetPurposeCodeResult = new usp_GetByPkId_TransactionSetPurposeCode_Result();
    //                }

    //                transactionTypeCodeResult = (new List<usp_GetByPkId_TransactionTypeCode_Result>(ctx.usp_GetByPkId_TransactionTypeCode(ediReceiverResult.TransactionTypeCodeID, true))).FirstOrDefault();
    //                if (transactionTypeCodeResult == null)
    //                {
    //                    transactionTypeCodeResult = new usp_GetByPkId_TransactionTypeCode_Result();
    //                }

    //                claimMediaResult = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(ediReceiverResult.ClaimMediaID, true))).FirstOrDefault();
    //                if (claimMediaResult == null)
    //                {
    //                    claimMediaResult = new usp_GetByPkId_ClaimMedia_Result();
    //                }

    //                interchangeUsageIndicatorResult = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(ediReceiverResult.InterchangeUsageIndicatorID, true))).FirstOrDefault();
    //                if (interchangeUsageIndicatorResult == null)
    //                {
    //                    interchangeUsageIndicatorResult = new usp_GetByPkId_InterchangeUsageIndicator_Result();
    //                }

    //                submitterEntityIdentifierCodeResult = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(ediReceiverResult.SubmitterEntityIdentifierCodeID, true))).FirstOrDefault();
    //                if (submitterEntityIdentifierCodeResult == null)
    //                {
    //                    submitterEntityIdentifierCodeResult = new usp_GetByPkId_EntityIdentifierCode_Result();
    //                }

    //                receiverEntityIdentifierCodeResult = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(ediReceiverResult.ReceiverEntityIdentifierCodeID, true))).FirstOrDefault();
    //                if (receiverEntityIdentifierCodeResult == null)
    //                {
    //                    receiverEntityIdentifierCodeResult = new usp_GetByPkId_EntityIdentifierCode_Result();
    //                }

    //                billingProviderEntityIdentifierCodeResult = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(ediReceiverResult.BillingProviderEntityIdentifierCodeID, true))).FirstOrDefault();
    //                if (billingProviderEntityIdentifierCodeResult == null)
    //                {
    //                    billingProviderEntityIdentifierCodeResult = new usp_GetByPkId_EntityIdentifierCode_Result();
    //                }

    //                subscriberEntityIdentifierCodeResult = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(ediReceiverResult.SubscriberEntityIdentifierCodeID, true))).FirstOrDefault();
    //                if (subscriberEntityIdentifierCodeResult == null)
    //                {
    //                    subscriberEntityIdentifierCodeResult = new usp_GetByPkId_EntityIdentifierCode_Result();
    //                }

    //                payerEntityIdentifierCodeResult = (new List<usp_GetByPkId_EntityIdentifierCode_Result>(ctx.usp_GetByPkId_EntityIdentifierCode(ediReceiverResult.PayerEntityIdentifierCodeID, true))).FirstOrDefault();
    //                if (payerEntityIdentifierCodeResult == null)
    //                {
    //                    payerEntityIdentifierCodeResult = new usp_GetByPkId_EntityIdentifierCode_Result();
    //                }

    //                ediReceiverEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ediReceiverResult.EntityTypeQualifierID, true))).FirstOrDefault();
    //                if (ediReceiverEntityTypeQualifierResult == null)
    //                {
    //                    ediReceiverEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                currencyCodeResult = (new List<usp_GetByPkId_CurrencyCode_Result>(ctx.usp_GetByPkId_CurrencyCode(ediReceiverResult.CurrencyCodeID, true))).FirstOrDefault();
    //                if (currencyCodeResult == null)
    //                {
    //                    currencyCodeResult = new usp_GetByPkId_CurrencyCode_Result();
    //                }

    //                payerResponsibilitySequenceNumberCodeResult = (new List<usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetByPkId_PayerResponsibilitySequenceNumberCode(ediReceiverResult.PayerResponsibilitySequenceNumberCodeID, true))).FirstOrDefault();
    //                if (payerResponsibilitySequenceNumberCodeResult == null)
    //                {
    //                    payerResponsibilitySequenceNumberCodeResult = new usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result();
    //                }

    //                emailCommunicationNumberQualifierResult = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(ediReceiverResult.EmailCommunicationNumberQualifierID, true))).FirstOrDefault();
    //                if (emailCommunicationNumberQualifierResult == null)
    //                {
    //                    emailCommunicationNumberQualifierResult = new usp_GetByPkId_CommunicationNumberQualifier_Result();
    //                }

    //                faxCommunicationNumberQualifierResult = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(ediReceiverResult.FaxCommunicationNumberQualifierID, true))).FirstOrDefault();
    //                if (faxCommunicationNumberQualifierResult == null)
    //                {
    //                    faxCommunicationNumberQualifierResult = new usp_GetByPkId_CommunicationNumberQualifier_Result();
    //                }

    //                phoneCommunicationNumberQualifierResult = (new List<usp_GetByPkId_CommunicationNumberQualifier_Result>(ctx.usp_GetByPkId_CommunicationNumberQualifier(ediReceiverResult.PhoneCommunicationNumberQualifierID, true))).FirstOrDefault();
    //                if (phoneCommunicationNumberQualifierResult == null)
    //                {
    //                    phoneCommunicationNumberQualifierResult = new usp_GetByPkId_CommunicationNumberQualifier_Result();
    //                }

    //                patientEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ediReceiverResult.PatientEntityTypeQualifierID, true))).FirstOrDefault();
    //                if (patientEntityTypeQualifierResult == null)
    //                {
    //                    patientEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                providerEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ediReceiverResult.ProviderEntityTypeQualifierID, true))).FirstOrDefault();
    //                if (providerEntityTypeQualifierResult == null)
    //                {
    //                    providerEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                insuranceEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ediReceiverResult.InsuranceEntityTypeQualifierID, true))).FirstOrDefault();
    //                if (insuranceEntityTypeQualifierResult == null)
    //                {
    //                    insuranceEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                clinicResult = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(ClinicID, true))).FirstOrDefault();
    //                if (clinicResult == null)
    //                {
    //                    clinicResult = new usp_GetByPkId_Clinic_Result();
    //                }

    //                ipaResult = (new List<usp_GetByPkId_IPA_Result>(ctx.usp_GetByPkId_IPA(clinicResult.IPAID, true))).FirstOrDefault();
    //                if (ipaResult == null)
    //                {
    //                    ipaResult = new usp_GetByPkId_IPA_Result();
    //                }

    //                clinicEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(clinicResult.EntityTypeQualifierID, true))).FirstOrDefault();
    //                if (clinicEntityTypeQualifierResult == null)
    //                {
    //                    clinicEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                clinicCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(clinicResult.CityID, true))).FirstOrDefault();
    //                if (clinicCityResult == null)
    //                {
    //                    clinicCityResult = new usp_GetByPkId_City_Result();
    //                }

    //                clinicStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(clinicResult.StateID, true))).FirstOrDefault();
    //                if (clinicStateResult == null)
    //                {
    //                    clinicStateResult = new usp_GetByPkId_State_Result();
    //                }

    //                clinicCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(clinicResult.CountryID, true))).FirstOrDefault();
    //                if (clinicCountryResult == null)
    //                {
    //                    clinicCountryResult = new usp_GetByPkId_Country_Result();
    //                }

    //                clinicSpecialtyResult = (new List<usp_GetByPkId_Specialty_Result>(ctx.usp_GetByPkId_Specialty(clinicResult.SpecialtyID, true))).FirstOrDefault();
    //                if (clinicSpecialtyResult == null)
    //                {
    //                    clinicSpecialtyResult = new usp_GetByPkId_Specialty_Result();
    //                }

    //                ipaEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ipaResult.EntityTypeQualifierID, true))).FirstOrDefault();
    //                if (ipaEntityTypeQualifierResult == null)
    //                {
    //                    ipaEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //                }

    //                ipaCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ipaResult.CityID, true))).FirstOrDefault();
    //                if (ipaCityResult == null)
    //                {
    //                    ipaCityResult = new usp_GetByPkId_City_Result();
    //                }

    //                ipaStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ipaResult.StateID, true))).FirstOrDefault();
    //                if (ipaStateResult == null)
    //                {
    //                    ipaStateResult = new usp_GetByPkId_State_Result();
    //                }

    //                ipaCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ipaResult.CountryID, true))).FirstOrDefault();
    //                if (ipaCountryResult == null)
    //                {
    //                    ipaCountryResult = new usp_GetByPkId_Country_Result();
    //                }

    //                ansi837VisitResults = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID, ediReceiverResult.EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));

    //                hierarchicalIDNumber = 1;

    //                # endregion

    //                # region Initilization

    //                objANSI5010Main = new ANSI5010Main();

    //                # endregion

    //                # region Header

    //                objANSI5010Main.ISA.AuthorizationInformationQualifier = authorizationInformationQualifierResult.AuthorizationInformationQualifierCode;
    //                objANSI5010Main.ISA.AuthorizationInformation = ediReceiverResult.AuthorizationInformation;
    //                objANSI5010Main.ISA.SecurityInformationQualifier = securityInformationQualifierrResult.SecurityInformationQualifierCode;
    //                objANSI5010Main.ISA.SecurityInformation = ediReceiverResult.SecurityInformation;
    //                objANSI5010Main.ISA.InterchangeIDQualifierSender = senderInterchangeIDQualifierResult.InterchangeIDQualifierCode;
    //                objANSI5010Main.ISA.InterchangeSenderID = ediReceiverResult.InterchangeSenderID;
    //                objANSI5010Main.ISA.InterchangeIDQualifierReceiver = receiverInterchangeIDQualifierResult.InterchangeIDQualifierCode;
    //                objANSI5010Main.ISA.InterchangeReceiverID = ediReceiverResult.InterchangeReceiverID;
    //                objANSI5010Main.ISA.InterchangeDate = string.Compare(Static5010.ReadXml("InterchangeDateFormat"), "YYMMDD", false) == 0 ? EDIFileDate.ToString("yyMMdd") : Static5010.ReadXml("InterchangeDateFormat");
    //                objANSI5010Main.ISA.InterchangeTime = string.Compare(Static5010.ReadXml("InterchangeTimeFormat"), "HHMM", false) == 0 ? EDIFileDate.ToString("HHmm") : Static5010.ReadXml("InterchangeTimeFormat");
    //                objANSI5010Main.ISA.RepetitionSeparator = Static5010.ReadXml("CharIsRepeat");
    //                objANSI5010Main.ISA.InterchangeControlVersionNumber = Static5010.ReadXml("InterchangeControlVersionNumberCode");
    //                objANSI5010Main.ISA.InterchangeControlNumber = EDIFileID.ToString();
    //                objANSI5010Main.ISA.AcknowledgmentRequested = Static5010.ReadXml("AcknowledgmentRequestedCode");
    //                objANSI5010Main.ISA.InterchangeUsageIndicator = interchangeUsageIndicatorResult.InterchangeUsageIndicatorCode;
    //                objANSI5010Main.ISA.ComponentElementSeparator = Static5010.ReadXml("CharIsNotField");

    //                objANSI5010Main.GS.FunctionalIdentifierCode = ediReceiverResult.FunctionalIdentifierCode;
    //                objANSI5010Main.GS.ApplicationSenderCode = ediReceiverResult.ApplicationSenderCode;
    //                objANSI5010Main.GS.ApplicationReceiverCode = ediReceiverResult.ApplicationReceiverCode;
    //                objANSI5010Main.GS.Date = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? EDIFileDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
    //                objANSI5010Main.GS.Time = string.Compare(Static5010.ReadXml("FunctionalGroupTimeFormat"), "HHMMSS", false) == 0 ? EDIFileDate.ToString("HHmmss") : Static5010.ReadXml("FunctionalGroupTimeFormat");
    //                objANSI5010Main.GS.GroupControlNumber = EDIFileID.ToString();
    //                objANSI5010Main.GS.ResponsibleAgencyCode = Static5010.ReadXml("ResponsibleAgencyCodeCode");
    //                objANSI5010Main.GS.IndustryIdentifierCode = claimMediaResult.ClaimMediaCode;

    //                objANSI5010Main.ST.TransactionSetIdentifierCode = Static5010.ReadXml("TransactionSetIdentifierCode");
    //                objANSI5010Main.ST.TransactionSetControlNumber = EDIFileID.ToString();
    //                objANSI5010Main.ST.ImplementationConventionReference = claimMediaResult.ClaimMediaCode;

    //                objANSI5010Main.BHT.HierarchicalStructureCode = Static5010.ReadXml("HierarchicalStructureCode");
    //                objANSI5010Main.BHT.TransactionSetPurposeCode = transactionSetPurposeCodeResult.TransactionSetPurposeCodeCode;
    //                objANSI5010Main.BHT.ReferenceIdentification = EDIFileID.ToString();
    //                objANSI5010Main.BHT.Date = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? EDIFileDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
    //                objANSI5010Main.BHT.Time = string.Compare(Static5010.ReadXml("FunctionalGroupTimeFormat"), "HHMMSS", false) == 0 ? EDIFileDate.ToString("HHmmss") : Static5010.ReadXml("FunctionalGroupTimeFormat");
    //                objANSI5010Main.BHT.TransactionTypeCode = transactionTypeCodeResult.TransactionTypeCodeCode;

    //                objANSI5010Main.NM1L1000A.EntityIdentifierCode = submitterEntityIdentifierCodeResult.EntityIdentifierCodeCode;
    //                objANSI5010Main.NM1L1000A.EntityTypeQualifier = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                objANSI5010Main.NM1L1000A.NameLastOrOrganizationName = clinicResult.ClinicName;
    //                objANSI5010Main.NM1L1000A.IdentificationCodeQualifier = Static5010.ReadXml("SubmitterIdentificationCodeQualifier");
    //                objANSI5010Main.NM1L1000A.IdentificationCode = clinicResult.NPI;

    //                objANSI5010Main.PERL1000A.ContactFunctionCode = Static5010.ReadXml("ContactFunctionCode");
    //                objANSI5010Main.PERL1000A.Name = string.Concat(clinicResult.ContactPersonLastName, " ", clinicResult.ContactPersonFirstName, " ", clinicResult.ContactPersonMiddleName).Trim();
    //                objANSI5010Main.PERL1000A.CommunicationNumberQualifier = emailCommunicationNumberQualifierResult.CommunicationNumberQualifierCode;
    //                objANSI5010Main.PERL1000A.CommunicationNumber = clinicResult.ContactPersonEmail;
    //                objANSI5010Main.PERL1000A.CommunicationNumberQualifier2 = phoneCommunicationNumberQualifierResult.CommunicationNumberQualifierCode;
    //                objANSI5010Main.PERL1000A.CommunicationNumber2 = clinicResult.ContactPersonPhoneNumber.Replace("(", string.Empty).Replace(")", string.Empty).Replace("-", string.Empty);

    //                if (!(string.IsNullOrWhiteSpace(clinicResult.ContactPersonFax)))
    //                {
    //                    objANSI5010Main.PERL1000A.CommunicationNumberQualifier1 = faxCommunicationNumberQualifierResult.CommunicationNumberQualifierCode;
    //                    objANSI5010Main.PERL1000A.CommunicationNumber1 = clinicResult.ContactPersonFax.Replace("(", string.Empty).Replace(")", string.Empty).Replace("-", string.Empty);
    //                }

    //                objANSI5010Main.NM1L1000B.EntityIdentifierCode = receiverEntityIdentifierCodeResult.EntityIdentifierCodeCode;
    //                objANSI5010Main.NM1L1000B.EntityTypeQualifier = ediReceiverEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                objANSI5010Main.NM1L1000B.NameLastOrOrganizationName = ediReceiverResult.EDIReceiverName;
    //                objANSI5010Main.NM1L1000B.IdentificationCodeQualifier = Static5010.ReadXml("ReceiverIdentificationCodeQualifier");
    //                objANSI5010Main.NM1L1000B.IdentificationCode = clinicResult.NPI;

    //                objANSI5010Main.HLL2000A.HierarchicalIDNumber = hierarchicalIDNumber.ToString();
    //                objANSI5010Main.HLL2000A.HierarchicalLevelCode = Static5010.ReadXml("HierarchicalLevelCode");
    //                objANSI5010Main.HLL2000A.HierarchicalChildCode = Static5010.ReadXml("HierarchicalChildCode");

    //                objANSI5010Main.NM1L2010AA.EntityIdentifierCode = billingProviderEntityIdentifierCodeResult.EntityIdentifierCodeCode;
    //                objANSI5010Main.NM1L2010AA.EntityTypeQualifier = ipaEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                objANSI5010Main.NM1L2010AA.NameLastOrOrganizationName = ipaResult.IPAName;
    //                objANSI5010Main.NM1L2010AA.IdentificationCodeQualifier = Static5010.ReadXml("SubmitterIdentificationCodeQualifier");
    //                objANSI5010Main.NM1L2010AA.IdentificationCode = ipaResult.NPI;

    //                objANSI5010Main.N3L2010AA.AddressInformation = ipaResult.StreetName;

    //                objANSI5010Main.N4L2010AA.CityName = ipaCityResult.CityName;
    //                objANSI5010Main.N4L2010AA.StateorProvinceCode = ipaStateResult.StateCode;
    //                objANSI5010Main.N4L2010AA.PostalCode = ipaCityResult.ZipCode.Replace("-0000", string.Empty);
    //                objANSI5010Main.N4L2010AA.CountryCode = ipaCountryResult.CountryCode;

    //                objANSI5010Main.REFL2010AA.ReferenceIdentificationQualifier = Static5010.ReadXml("ReferenceIdentificationQualifier");
    //                objANSI5010Main.REFL2010AA.ReferenceIdentification = ipaResult.TaxID;

    //                # endregion

    //                # region Visit Loop

    //                foreach (usp_GetAnsi837Visit_ClaimProcess_Result ansi837VisitResult in ansi837VisitResults)
    //                {
    //                    # region Fetch From DB Visit Based

    //                    patientCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.PATIENT_CITY_ID, true))).First();
    //                    patientStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.PATIENT_STATE_ID, true))).First();
    //                    patientCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.PATIENT_COUNTRY_ID, true))).First();
    //                    //
    //                    insuranceCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.INSURANCE_CITY_ID, true))).First();
    //                    insuranceStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.INSURANCE_STATE_ID, true))).First();
    //                    insuranceCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.INSURANCE_COUNTRY_ID, true))).First();
    //                    //
    //                    if (ansi837VisitResult.PatientHospitalizationID.HasValue)
    //                    {
    //                        hospitalizationResult = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(ansi837VisitResult.PatientHospitalizationID.Value, true))).First();
    //                    }
    //                    else
    //                    {
    //                        hospitalizationResult = null;
    //                    }
    //                    patientPrintSignResult = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(ansi837VisitResult.PatientPrintSignID, true))).First();
    //                    visitCPTResults = new List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result>(ctx.usp_GetAnsi837Visit_ClaimDiagnosisCPT(ansi837VisitResult.PatientVisitID));
    //                    claimNos = new List<long>((from o in visitCPTResults where o.CLAIM_NUMBER > 0 select o.CLAIM_NUMBER).Distinct());

    //                    # endregion

    //                    foreach (long claimNo in claimNos)
    //                    {
    //                        # region Fetch From DB Claim Based

    //                        claimTotCharge = (new List<decimal?>(ctx.usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT(ansi837VisitResult.PatientVisitID, claimNo))).FirstOrDefault();

    //                        # endregion

    //                        hierarchicalIDNumber++;

    //                        SubPatDetail objSubPatDetail = new SubPatDetail(ansi837VisitResult.ChartNumber);

    //                        objSubPatDetail.HLL2000B.HierarchicalIDNumber = hierarchicalIDNumber.ToString();
    //                        objSubPatDetail.HLL2000B.HierarchicalParentIDNumber = Static5010.ReadXml("HierarchicalParentIDNumber");
    //                        objSubPatDetail.HLL2000B.HierarchicalLevelCode = Static5010.ReadXml("HierarchicalLevelCode");
    //                        objSubPatDetail.HLL2000B.HierarchicalChildCode = Static5010.ReadXml("HierarchicalChildCode");

    //                        objSubPatDetail.SBR.PayerResponsibilitySequenceNumberCode = payerResponsibilitySequenceNumberCodeResult.PayerResponsibilitySequenceNumberCodeCode;
    //                        objSubPatDetail.SBR.IndividualRelationshipCode = ansi837VisitResult.RelationshipCode;
    //                        objSubPatDetail.SBR.ReferenceIdentification = ansi837VisitResult.GroupNumber;
    //                        objSubPatDetail.SBR.ClaimFilingIndicatorCode = ansi837VisitResult.InsuranceTypeCode;

    //                        objSubPatDetail.NM1L2010BA.EntityIdentifierCode = subscriberEntityIdentifierCodeResult.EntityIdentifierCodeCode;
    //                        objSubPatDetail.NM1L2010BA.EntityTypeQualifier = patientEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                        objSubPatDetail.NM1L2010BA.NameLastOrOrganizationName = ansi837VisitResult.PATIENT_LAST_NAME;
    //                        objSubPatDetail.NM1L2010BA.NameFirst = ansi837VisitResult.PATIENT_FIRST_NAME;
    //                        objSubPatDetail.NM1L2010BA.NameMiddle = ansi837VisitResult.PATIENT_MIDDLE_NAME;
    //                        objSubPatDetail.NM1L2010BA.IdentificationCodeQualifier = Static5010.ReadXml("SubscriberIdentificationCodeQualifier");
    //                        objSubPatDetail.NM1L2010BA.IdentificationCode = ansi837VisitResult.PolicyNumber;

    //                        objSubPatDetail.N3L2010BA.AddressInformation = ansi837VisitResult.PATIENT_STREET_NAME;

    //                        objSubPatDetail.N4L2010BA.CityName = patientCityResult.CityName;
    //                        objSubPatDetail.N4L2010BA.StateorProvinceCode = patientStateResult.StateCode;
    //                        objSubPatDetail.N4L2010BA.PostalCode = patientCityResult.ZipCode.Replace("-0000", string.Empty);
    //                        objSubPatDetail.N4L2010BA.CountryCode = patientCountryResult.CountryCode;

    //                        objSubPatDetail.DMG.DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
    //                        objSubPatDetail.DMG.DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? ansi837VisitResult.DOB.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
    //                        objSubPatDetail.DMG.GenderCode = ansi837VisitResult.Sex;

    //                        objSubPatDetail.NM1L2010BB.EntityIdentifierCode = payerEntityIdentifierCodeResult.EntityIdentifierCodeCode;
    //                        objSubPatDetail.NM1L2010BB.EntityTypeQualifier = insuranceEntityTypeQualifierResult.EntityTypeQualifierCode;
    //                        objSubPatDetail.NM1L2010BB.NameLastOrOrganizationName = ansi837VisitResult.InsuranceName;
    //                        objSubPatDetail.NM1L2010BB.IdentificationCodeQualifier = Static5010.ReadXml("PayerIdentificationCodeQualifier");
    //                        objSubPatDetail.NM1L2010BB.IdentificationCode = ansi837VisitResult.PayerID;

    //                        objSubPatDetail.N3L2010BB.AddressInformation = ansi837VisitResult.INSURANCE_STREET_NAME;

    //                        objSubPatDetail.N4L2010BB.CityName = insuranceCityResult.CityName;
    //                        objSubPatDetail.N4L2010BB.StateorProvinceCode = insuranceStateResult.StateCode;
    //                        objSubPatDetail.N4L2010BB.PostalCode = insuranceCityResult.ZipCode.Replace("-0000", string.Empty);
    //                        objSubPatDetail.N4L2010BB.CountryCode = insuranceCountryResult.CountryCode;

    //                        objSubPatDetail.CLM.ClaimSubmittersIdentifier = ansi837VisitResult.ChartNumber;
    //                        objSubPatDetail.CLM.MonetaryAmount = claimTotCharge.HasValue ? claimTotCharge.Value.ToString() : "0";
    //                        objSubPatDetail.CLM.FacilityCodeValue = ansi837VisitResult.FacilityTypeCode;
    //                        objSubPatDetail.CLM.FacilityCodeQualifier = Static5010.ReadXml("FacilityCodeQualifier");
    //                        objSubPatDetail.CLM.ClaimFrequencyTypeCode = Static5010.ReadXml("ClaimFrequencyTypeCode");
    //                        objSubPatDetail.CLM.YesNoConditionOrResponseCode = Static5010.ReadXml("YesNoConditionOrResponseCode");
    //                        objSubPatDetail.CLM.ProviderAcceptAssignmentCode = Static5010.ReadXml("ProviderAcceptAssignmentCode");
    //                        objSubPatDetail.CLM.YesNoConditionOrResponseCode1 = Static5010.ReadXml("YesNoConditionOrResponseCode");
    //                        objSubPatDetail.CLM.ReleaseOfInformationCode = Static5010.ReadXml("ReleaseOfInformationCode");

    //                        objSubPatDetail.DTPL2300.IllDateTimeQualifier = Static5010.ReadXml("IllDateTimeQualifier");
    //                        objSubPatDetail.DTPL2300.DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
    //                        objSubPatDetail.DTPL2300.DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? ansi837VisitResult.IllnessIndicatorDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");

    //                        # region Dx CPT Modifiers

    //                        claimCPTResults = new List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result>(from o in visitCPTResults where (o.CLAIM_NUMBER == claimNo) select o);
    //                        claimCPTCount = 0;
    //                        prevDxCode = string.Empty;

    //                        for (int i = 0; i < claimCPTResults.Count; i++)
    //                        {
    //                            if (string.Compare(prevDxCode, claimCPTResults[i].DX_CODE, true) == 0)
    //                            {
    //                                // CPT

    //                                CptService objCptService = new CptService(ansi837VisitResult.ChartNumber);

    //                                objCptService.LX.AssignedNumber = claimCPTCount.ToString();

    //                                objCptService.SV1.ProductServiceIDQualifier = (claimCPTResults[i].IS_HCPCS_CODE) ? Static5010.ReadXml("ServiceIDQualifierHCPCS") : Static5010.ReadXml("ServiceIDQualifier");
    //                                objCptService.SV1.ProductServiceID = claimCPTResults[i].CPT_CODE;
    //                                objCptService.SV1.ProcedureModifier = claimCPTResults[i].MODI1_CODE;
    //                                objCptService.SV1.ProcedureModifier1 = claimCPTResults[i].MODI2_CODE;
    //                                objCptService.SV1.ProcedureModifier2 = claimCPTResults[i].MODI3_CODE;
    //                                objCptService.SV1.ProcedureModifier3 = claimCPTResults[i].MODI4_CODE;
    //                                objCptService.SV1.MonetaryAmount = (claimCPTResults[i].UNIT * claimCPTResults[i].CHARGE_PER_UNIT).ToString();
    //                                objCptService.SV1.UnitOrBasisforMeasurementCode = Static5010.ReadXml("UnitOrBasisForMeasurementCode");
    //                                objCptService.SV1.Quantity = claimCPTResults[i].UNIT.ToString();
    //                                objCptService.SV1.FacilityCodeValue = claimCPTResults[i].FACILITY_TYPE_CODE;
    //                                objCptService.SV1.DiagnosisCodePointer = claimCPTCount.ToString();

    //                                objSubPatDetail.CptServices.Add(objCptService);
    //                            }
    //                            else
    //                            {
    //                                // Dx

    //                                if (claimCPTCount == 0)
    //                                {
    //                                    // Primary Dx

    //                                    objSubPatDetail.HIL2300.CodeListQualifierCode = (claimCPTResults[i].ICD_FORMAT == 10) ? Static5010.ReadXml("CodeListQualifierCode10Pri") : Static5010.ReadXml("CodeListQualifierCodePri");
    //                                    objSubPatDetail.HIL2300.IndustryCode = claimCPTResults[i].DX_CODE;
    //                                }
    //                                else
    //                                {
    //                                    // Other Dx

    //                                    objSubPatDetail.HIL2300.GetType().GetProperty(string.Concat("CodeListQualifierCode", claimCPTCount)).SetValue(objSubPatDetail.HIL2300, ((claimCPTResults[i].ICD_FORMAT == 10) ? Static5010.ReadXml("CodeListQualifierCode10") : Static5010.ReadXml("CodeListQualifierCode")));
    //                                    objSubPatDetail.HIL2300.GetType().GetProperty(string.Concat("IndustryCode", claimCPTCount)).SetValue(objSubPatDetail.HIL2300, claimCPTResults[i].DX_CODE);
    //                                }

    //                                prevDxCode = claimCPTResults[i].DX_CODE;
    //                                claimCPTCount++;
    //                                i--;
    //                            }
    //                        }

    //                        # endregion

    //                        objANSI5010Main.SubPatDetails.Add(objSubPatDetail);
    //                    }
    //                }

    //                # endregion

    //                # region Footer

    //                objANSI5010Main.SE.TransactionSetControlNumber = EDIFileID.ToString();

    //                objANSI5010Main.GE.NumberofTransactionSetsIncluded = "1";
    //                objANSI5010Main.GE.GroupControlNumber = EDIFileID.ToString();

    //                objANSI5010Main.IEA.NumberofIncludedFunctionalGroups = "1";
    //                objANSI5010Main.IEA.InterchangeControlNumber = EDIFileID.ToString();

    //                # endregion

    //                # endregion

    //                # region Save

    //                FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\P_", EDIFileID);
    //                if (!(Directory.Exists(FileSvrEDIX12FilePath)))
    //                {
    //                    DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIX12FilePath);
    //                    dirInfo = null;
    //                }
    //                FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "X12_5010_", EDIFileID, ".edi");

    //                FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\P_", EDIFileID);
    //                if (!(Directory.Exists(FileSvrEDIRefFilePath)))
    //                {
    //                    DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIRefFilePath);
    //                    dirInfo = null;
    //                }
    //                FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "Ref_5010_", EDIFileID, ".txt");

    //                _EDIX12FileRelPath = FileSvrEDIX12FilePath.Replace(FileSvrRootPath, string.Empty);
    //                _EDIRefFileRelPath = FileSvrEDIRefFilePath.Replace(FileSvrRootPath, string.Empty);

    //                _EDIX12FileRelPath = _EDIX12FileRelPath.Substring(1);
    //                _EDIRefFileRelPath = _EDIRefFileRelPath.Substring(1);

    //                //http://social.msdn.microsoft.com/Forums/en-US/csharpgeneral/thread/7f42a0cb-2113-4749-bfd9-8e5228345c68

    //                ansi5010Loops = Base5010.GetANSI5010Loops(objANSI5010Main);

    //                if (File.Exists(FileSvrEDIX12FilePath))
    //                {
    //                    File.Delete(FileSvrEDIX12FilePath);
    //                }

    //                if (File.Exists(FileSvrEDIRefFilePath))
    //                {
    //                    File.Delete(FileSvrEDIRefFilePath);
    //                }

    //                string prevChart = string.Empty;

    //                foreach (var ansi5010Loop in ansi5010Loops)
    //                {
    //                    using (TextWriter tw = new StreamWriter(FileSvrEDIX12FilePath, true, Encoding.GetEncoding(1252)))
    //                    {
    //                        tw.Write(ansi5010Loop.LoopValue);
    //                        tw.Write("~");
    //                    }

    //                    using (TextWriter tw = new StreamWriter(FileSvrEDIRefFilePath, true, Encoding.GetEncoding(1252)))
    //                    {
    //                        if (string.Compare(prevChart, ansi5010Loop.LoopChart, true) != 0)
    //                        {
    //                            prevChart = ansi5010Loop.LoopChart;
    //                            tw.WriteLine(string.Empty);
    //                        }

    //                        tw.WriteLine(string.Concat(ansi5010Loop.LoopName, ansi5010Loop.LoopChart, ansi5010Loop.LoopValue));
    //                    }
    //                }

    //                # endregion

    //                CommitDbTrans(ctx);
    //            }
    //            catch (Exception ex)
    //            {
    //                RollbackDbTrans(ctx);
    //                throw ex;
    //            }
    //        }

    //        return true;
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveUpdate(int pUserID)
    //    {
    //        throw new NotImplementedException();
    //    }

    //    # endregion
    //}

    # endregion

    #region Class old Create EDI

    //# region Search

    ///// <summary>
    ///// 
    ///// </summary>
    //public class EDICreateSearchModel : BaseSearchModel
    //{
    //    #region Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public List<usp_GetAnsi837Visit_ClaimProcess_Result> PatientVisit
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public Int32 ClinicID { get; set; }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public int EDIReceiverID { get; set; }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public Nullable<int> AssignedTo { get; set; }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String ErrorMsg
    //    {
    //        get;
    //        set;
    //    }

    //    #endregion

    //    # region constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public EDICreateSearchModel()
    //    {
    //    }

    //    # endregion

    //    #region Abstract Methods


    //    protected override void FillByAZ(bool? pIsActive)
    //    {

    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCurrPageNumber"></param>
    //    /// <param name="pIsActive"></param>
    //    /// <param name="pRecordsPerPage"></param>
    //    protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            PatientVisit = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID,EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));
    //        }
    //    }

    //    #endregion


    //}

    //#endregion

    //#region Save

    //public class EDICreateSaveModel : BaseSaveModel
    //{
    //    # region Private Variables

    //    //private global::System.String _EDIX12FileRelPath;
    //    //private global::System.String _EDIRefFileRelPath;
    //    //private global::System.String _StatusIds;

    //    # endregion

    //    # region Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int32 EDIFileID
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrRootPath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIX12FilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String FileSvrEDIRefFilePath
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int32 ClinicID
    //    {
    //        get;
    //        set;
    //    }

    //    # endregion

    //    # region constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public EDICreateSaveModel()
    //    {
    //    }

    //    # endregion

    //    #region Abstract

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveInsert(int pUserID)
    //    {
    //        //using (EFContext ctx = new EFContext())
    //        //{
    //        //    BeginDbTrans(ctx);

    //        //    try
    //        //    {
    //        //        # region Data

    //        //        # region Declaration

    //        //        usp_GetByPkId_EDIReceiver_Result ediReceiverResult;
    //        //        usp_GetByPkId_AuthorizationInformationQualifier_Result authorizationQualifierResult;
    //        //        usp_GetByPkId_SecurityInformationQualifier_Result securityQualifierResult;
    //        //        usp_GetByPkId_TransactionSetPurposeCode_Result TransactionSetPurposeCodeResult;
    //        //        usp_GetByPkId_TransactionTypeCode_Result transactionTypeCodeResult;
    //        //        usp_GetByPkId_InterchangeUsageIndicator_Result usageIndicatorResult;
    //        //        usp_GetByPkId_ClaimMedia_Result claimMediaResult;
    //        //        usp_GetByPkId_Clinic_Result clinicResult;
    //        //        usp_GetByPkId_EntityTypeQualifier_Result clinicEntityTypeQualifierResult;
    //        //        usp_GetByPkId_City_Result clinicCityResult;
    //        //        usp_GetByPkId_State_Result clinicStateResult;
    //        //        usp_GetByPkId_Country_Result clinicCountryResult;
    //        //        usp_GetAnsi837Const_ClaimProcess_Result ansi837ConstResult;
    //        //        List<usp_GetAnsi837Visit_ClaimProcess_Result> ansi837VisitResults;
    //        //        List<ANSI837Procedures> objProcedure;
    //        //        List<usp_GetAnsi837_ClaimDiagnosis_Result> claimNoDiagnosisResults;
    //        //        int loop;
    //        //        List<long> claimProcessIDs;
    //        //        ObjectParameter objParam;
    //        //        # endregion

    //        //        # region Fetch From DB

    //        //        EDIFileID = Convert.ToInt32((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("EDI", "EDIFile"))).FirstOrDefault().NEXT_INDENTITY);

    //        //        ediReceiverResult = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(Convert.ToInt32(EDIReceiver.EMDEON5010), true))).FirstOrDefault();
    //        //        if (ediReceiverResult == null)
    //        //        {
    //        //            ediReceiverResult = new usp_GetByPkId_EDIReceiver_Result();
    //        //        }

    //        //        authorizationQualifierResult = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(ediReceiverResult.AuthorizationInformationQualifierID, true))).FirstOrDefault();
    //        //        if (authorizationQualifierResult == null)
    //        //        {
    //        //            authorizationQualifierResult = new usp_GetByPkId_AuthorizationInformationQualifier_Result();
    //        //        }

    //        //        securityQualifierResult = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(ediReceiverResult.SecurityInformationQualifierID, true))).FirstOrDefault();
    //        //        if (securityQualifierResult == null)
    //        //        {
    //        //            securityQualifierResult = new usp_GetByPkId_SecurityInformationQualifier_Result();
    //        //        }

    //        //        TransactionSetPurposeCodeResult = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(ediReceiverResult.TransactionSetPurposeCodeID, true))).FirstOrDefault();
    //        //        if (TransactionSetPurposeCodeResult == null)
    //        //        {
    //        //            TransactionSetPurposeCodeResult = new usp_GetByPkId_TransactionSetPurposeCode_Result();
    //        //        }

    //        //        transactionTypeCodeResult = (new List<usp_GetByPkId_TransactionTypeCode_Result>(ctx.usp_GetByPkId_TransactionTypeCode(ediReceiverResult.TransactionTypeCodeID, true))).FirstOrDefault();
    //        //        if (transactionTypeCodeResult == null)
    //        //        {
    //        //            transactionTypeCodeResult = new usp_GetByPkId_TransactionTypeCode_Result();
    //        //        }

    //        //        usageIndicatorResult = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(ediReceiverResult.InterchangeUsageIndicatorID, true))).FirstOrDefault();
    //        //        if (usageIndicatorResult == null)
    //        //        {
    //        //            usageIndicatorResult = new usp_GetByPkId_InterchangeUsageIndicator_Result();
    //        //        }

    //        //        claimMediaResult = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(ediReceiverResult.ClaimMediaID, true))).FirstOrDefault();
    //        //        if (claimMediaResult == null)
    //        //        {
    //        //            claimMediaResult = new usp_GetByPkId_ClaimMedia_Result();
    //        //        }

    //        //        ansi837ConstResult = (new List<usp_GetAnsi837Const_ClaimProcess_Result>(ctx.usp_GetAnsi837Const_ClaimProcess())).FirstOrDefault();
    //        //        if (ansi837ConstResult == null)
    //        //        {
    //        //            ansi837ConstResult = new usp_GetAnsi837Const_ClaimProcess_Result();
    //        //        }

    //        //        clinicResult = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(ClinicID, true))).FirstOrDefault();
    //        //        if (clinicResult == null)
    //        //        {
    //        //            clinicResult = new usp_GetByPkId_Clinic_Result();
    //        //        }

    //        //        clinicEntityTypeQualifierResult = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(clinicResult.EntityTypeQualifierID, true))).FirstOrDefault();
    //        //        if (clinicEntityTypeQualifierResult == null)
    //        //        {
    //        //            clinicEntityTypeQualifierResult = new usp_GetByPkId_EntityTypeQualifier_Result();
    //        //        }

    //        //        clinicCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(clinicResult.CityID, true))).FirstOrDefault();
    //        //        if (clinicCityResult == null)
    //        //        {
    //        //            clinicCityResult = new usp_GetByPkId_City_Result();
    //        //        }

    //        //        clinicStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(clinicResult.StateID, true))).FirstOrDefault();
    //        //        if (clinicStateResult == null)
    //        //        {
    //        //            clinicStateResult = new usp_GetByPkId_State_Result();
    //        //        }

    //        //        clinicCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(clinicResult.CountryID, true))).FirstOrDefault();
    //        //        if (clinicCountryResult == null)
    //        //        {
    //        //            clinicCountryResult = new usp_GetByPkId_Country_Result();
    //        //        }

    //        //        ansi837VisitResults = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID, ediReceiverResult.EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));

    //        //        # endregion

    //        //        # region Declaration & Initilization

    //        //        claimProcessIDs = new List<long>();
    //        //        objParam = null;
    //        //        ANSIService client = new ANSIService();
    //        //        MedDetails objData = new MedDetails();
    //        //        ANSIDataBinder objANSIData = new ANSIDataBinder();
    //        //        List<ANSIWrapper> aryWrapper = new List<ANSIWrapper>();
    //        //        List<StringBuilder> strDataPro = new List<StringBuilder>();

    //        //        # endregion

    //        //        # region Visit Loop

    //        //        foreach (usp_GetAnsi837Visit_ClaimProcess_Result ansi837VisitResult in ansi837VisitResults)
    //        //        {
    //        //            # region Data Visit Based

    //        //            # region Declaration Visit Based

    //        //            ANSIWrapper objWrap = new ANSIWrapper();
    //        //            ANSI837FieldBinder obj837FieldBinder = new ANSI837FieldBinder();
    //        //            List<ANSI837FieldBinder> objFieldBinder = new List<ANSI837FieldBinder>();

    //        //            usp_GetByPkId_City_Result patientCityResult;
    //        //            usp_GetByPkId_State_Result patientStateResult;
    //        //            usp_GetByPkId_Country_Result patientCountryResult;
    //        //            //
    //        //            usp_GetByPkId_City_Result insuranceCityResult;
    //        //            usp_GetByPkId_State_Result insuranceStateResult;
    //        //            usp_GetByPkId_Country_Result insuranceCountryResult;
    //        //            //
    //        //            usp_GetByPkId_PatientHospitalization_Result hospitalizationResult;
    //        //            usp_GetByPkId_PrintSign_Result patientPrintSignResult;
    //        //            List<usp_GetAnsi837_ClaimDiagnosis_Result> claimDiagnosisResults;
    //        //            List<long> claimNos;
    //        //            //List<usp_GetAnsi837_ClaimDiagnosisCPT_Result> cptResults;
    //        //            //  List<usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result> modifierResults;

    //        //            # endregion

    //        //            # region Fetch From DB Visit Based

    //        //            patientCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.PATIENT_CITY_ID, true))).First();
    //        //            patientStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.PATIENT_STATE_ID, true))).First();
    //        //            patientCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.PATIENT_COUNTRY_ID, true))).First();
    //        //            //
    //        //            insuranceCityResult = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(ansi837VisitResult.INSURANCE_CITY_ID, true))).First();
    //        //            insuranceStateResult = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(ansi837VisitResult.INSURANCE_STATE_ID, true))).First();
    //        //            insuranceCountryResult = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(ansi837VisitResult.INSURANCE_COUNTRY_ID, true))).First();
    //        //            //
    //        //            if (ansi837VisitResult.PatientHospitalizationID.HasValue)
    //        //            {
    //        //                hospitalizationResult = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(ansi837VisitResult.PatientHospitalizationID.Value, true))).First();
    //        //            }
    //        //            else
    //        //            {
    //        //                hospitalizationResult = null;
    //        //            }
    //        //            patientPrintSignResult = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(ansi837VisitResult.PatientPrintSignID, true))).First();
    //        //            claimDiagnosisResults = new List<usp_GetAnsi837_ClaimDiagnosis_Result>(ctx.usp_GetAnsi837_ClaimDiagnosis(ansi837VisitResult.PatientVisitID));
    //        //            claimNos = new List<long>((from o in claimDiagnosisResults where o.CLAIM_NUMBER > 0 select o.CLAIM_NUMBER).Distinct());

    //        //            # endregion

    //        //            foreach (long claimNo in claimNos)
    //        //            {
    //        //                #region ISA Header

    //        //                //objANSIData.gatewayIDField = ediReceiverResult.ReceiverCarrier;
    //        //                objANSIData.insurance_TypeField = ansi837ConstResult.PRIMARY_INSURANCE;
    //        //                objANSIData.iSA01_Authorization_Info_QualifierField = authorizationQualifierResult.AuthorizationInformationQualifierCode;
    //        //                objANSIData.iSA02_Authorization_InformationField = ediReceiverResult.AuthorizationInformation;
    //        //                objANSIData.iSA03_Security_Info_QualifierField = ediReceiverResult.SecurityInformation;
    //        //                objANSIData.iSA04_Security_InformationField = securityQualifierResult.SecurityInformationQualifierCode;
    //        //                objANSIData.iSA05_Interchange_Sender_QualifierField = ansi837ConstResult.SENDER_QUALIFIER;
    //        //                objANSIData.iSA06_Interchange_Sender_IDField = ediReceiverResult.InterchangeReceiverID;
    //        //                objANSIData.iSA07_Interchange_Receiver_QualifierField = ansi837ConstResult.RECEIVER_QUALIFIER;
    //        //                objANSIData.iSA08_Interchange_Receiver_IDField = ediReceiverResult.InterchangeReceiverID;
    //        //                objANSIData.iSA09_Interchange_DateField = ansi837ConstResult.CURR_DT_TM.ToShortDateString();
    //        //                objANSIData.iSA10_Interchange_TimeField = ansi837ConstResult.CURR_DT_TM.ToShortTimeString();
    //        //                objANSIData.iSA13_Interchange_Control_NoField = EDIFileID.ToString();
    //        //                objANSIData.iSA14_Acknowledgement_RequestedField = ansi837ConstResult.ACK_REQUEST.ToString();
    //        //                objANSIData.iSA15_Usage_IndicatorField = usageIndicatorResult.InterchangeUsageIndicatorCode;
    //        //                objANSIData.gS02_Application_Sender_CodeField = ediReceiverResult.ApplicationSenderCode;
    //        //                objANSIData.gS03_Application_Receiver_CodeField = ediReceiverResult.ApplicationReceiverCode;
    //        //                objANSIData.gS06_Version_ID_CodeField = claimMediaResult.ClaimMediaCode;
    //        //                objANSIData.bHT02_Tran_Set_Purpose_CodeField = TransactionSetPurposeCodeResult.TransactionSetPurposeCodeCode;
    //        //                objANSIData.bHT06_Claim_Or_Encounter_IDField = transactionTypeCodeResult.TransactionTypeCodeCode;
    //        //                objANSIData.rEF02_Tran_Type_CodeField = claimMediaResult.ClaimMediaCode;

    //        //                #endregion

    //        //                #region Submitter Details

    //        //                objANSIData.nM102_Entity_Type_QualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //        //                objANSIData.nM103_Submitter_LastNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM104_Submitter_FirstNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM105_Submitter_MiddleNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM109_Submitter_IDField = clinicResult.NPI;

    //        //                objANSIData.pER02_Submitter_Contact_NameField = string.Concat(clinicResult.ContactPersonLastName, " ", clinicResult.ContactPersonFirstName, " ", clinicResult.ContactPersonMiddleName).Trim();
    //        //                objANSIData.pER04_Communication_No_1Field = clinicResult.ContactPersonPhoneNumber;
    //        //                objANSIData.pER06_Communication_No_2Field = clinicResult.ContactPersonSecondaryPhoneNumber;
    //        //                objANSIData.pER08_Communication_No_3Field = clinicResult.Fax;

    //        //                objANSIData.nM103_Receiver_NameField = ediReceiverResult.EDIReceiverName;
    //        //                objANSIData.nM109_Receiver_Primary_IdentifierField = ediReceiverResult.EDIReceiverID.ToString();

    //        //                #endregion

    //        //                #region Billing Provider

    //        //                objANSIData.nM102_Billing_Provider_Entity_TypeQualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //        //                objANSIData.nM103_Billing_Provider_LastNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM104_Billing_Provider_FirstNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM105_Billing_Provider_MiddleNameField = clinicResult.ClinicName;
    //        //                objANSIData.nM108_Billing_Provider_IDQualifierField = clinicResult.TaxID;
    //        //                objANSIData.nM109_Billing_Provider_IdentifierField = clinicResult.NPI;
    //        //                objANSIData.n301_Billing_Provider_Address1Field = clinicResult.StreetName;
    //        //                objANSIData.n302_Billing_Provider_Address2Field = clinicResult.Suite;
    //        //                objANSIData.n401_Billing_Provider_CityNameField = clinicCityResult.CityCode;
    //        //                objANSIData.n402_Billing_Provider_StateCodeField = clinicStateResult.StateCode;
    //        //                objANSIData.n403_Billing_Provider_PinCodeField = clinicCityResult.ZipCode;
    //        //                objANSIData.n404_Billing_Provider_CountryCodeField = clinicCountryResult.CountryCode;
    //        //                objANSIData.rEF01_Billing_Provider_IDQualifierField = clinicResult.NPI;
    //        //                objANSIData.rEF02_Billing_Provider_AdditionalIDField = clinicResult.NPI;

    //        //                #endregion

    //        //                ////////////////////////////////////////////////////////////////////////////////////////////////////////

    //        //                #region Pay To Provider

    //        //                objANSIData.isBillerAndPayerSameField = ansi837ConstResult.IS_BILLER_PAYER_SAME;

    //        //                if (!(objANSIData.isBillerAndPayerSameField))
    //        //                {
    //        //                    objANSIData.nM102_Pay_Provider_Entity_TypeQualifierField = clinicEntityTypeQualifierResult.EntityTypeQualifierCode;
    //        //                    objANSIData.nM103_Pay_Provider_LastNameField = clinicResult.ClinicName;
    //        //                    objANSIData.nM104_Pay_Provider_FirstNameField = clinicResult.ClinicName;
    //        //                    objANSIData.nM105_Pay_Provider_MiddleNameField = clinicResult.ClinicName;
    //        //                    objANSIData.nM109_Pay_Provider_IdentifierField = clinicResult.NPI;
    //        //                    objANSIData.n301_Pay_Provider_Address1Field = clinicResult.StreetName;
    //        //                    objANSIData.n302_Pay_Provider_Address2Field = clinicResult.Suite;
    //        //                    objANSIData.n401_Pay_Provider_CityNameField = clinicCityResult.CityCode;
    //        //                    objANSIData.n402_Pay_Provider_StateCodeField = clinicStateResult.StateCode;
    //        //                    objANSIData.n403_Pay_Provider_PinCodeField = clinicCityResult.ZipCode;
    //        //                    objANSIData.n404_Pay_Provider_CountryCodeField = clinicCountryResult.CountryCode;
    //        //                }

    //        //                obj837FieldBinder.primaryInsuranceIDField = ansi837VisitResult.InsuranceName;
    //        //                obj837FieldBinder.secondaryInsuranceIDField = ansi837VisitResult.InsuranceName;

    //        //                #endregion

    //        //                // Subscribers Loop
    //        //                obj837FieldBinder.isSecondaryCrossOverField = ansi837ConstResult.IS_SECONDARY_CROSS_OVER;
    //        //                obj837FieldBinder.sBR03_SubscriberInfo_GroupNoField = ansi837VisitResult.GroupNumber;
    //        //                obj837FieldBinder.sBR04_SubscriberInfo_GroupNameField = ansi837VisitResult.InsuranceName;
    //        //                obj837FieldBinder.sBR09_SubscriberInfo_ClaimFillIndicatorCodeField = ansi837VisitResult.InsuranceTypeCode;

    //        //                obj837FieldBinder.nM103_SubscriberInfo_LastNameField = ansi837VisitResult.PATIENT_LAST_NAME; // Patient 
    //        //                obj837FieldBinder.nM104_SubscriberInfo_FirstNameField = ansi837VisitResult.PATIENT_FIRST_NAME;   // Patient 
    //        //                obj837FieldBinder.nM105_SubscriberInfo_MiddleNameField = ansi837VisitResult.PATIENT_MIDDLE_NAME; // Patient 
    //        //                obj837FieldBinder.nM108_SubscriberInfo_IDCodeQualifierField = ansi837VisitResult.InsuranceTypeCode;
    //        //                obj837FieldBinder.nM109_SubscriberInfo_PrimaryIdentifierField = ansi837VisitResult.PolicyNumber;

    //        //                obj837FieldBinder.n301_SubscriberInfo_Address1Field = ansi837VisitResult.PATIENT_STREET_NAME; // Patient
    //        //                obj837FieldBinder.n302_SubscriberInfo_Address2Field = ansi837VisitResult.PATIENT_SUITE; // Patient
    //        //                obj837FieldBinder.n401_SubscriberInfo_CityNameField = patientCityResult.CityCode;
    //        //                obj837FieldBinder.n402_SubscriberInfo_StateCodeField = patientStateResult.StateCode;
    //        //                obj837FieldBinder.n403_SubscriberInfo_ZipCodeField = patientCityResult.ZipCode;
    //        //                obj837FieldBinder.n404_SubscriberInfo_CountryCodeField = patientCountryResult.CountryCode;

    //        //                obj837FieldBinder.dMG02_SubscriberDemographicInfo_BirthDateField = ansi837ConstResult.SUBSCRIBER_BIRTH_DATE;
    //        //                obj837FieldBinder.dMG03_SubscriberDemographicInfo_GenderCodeField = ansi837ConstResult.SUBSCRIBER_GENDER_CODE;

    //        //                obj837FieldBinder.rEF01_SubscriberSecondaryInfo_IDQualifierField = ansi837ConstResult.SUBSCRIBER_ID_QUALIFIER;
    //        //                obj837FieldBinder.rEF02_SubscriberSecondaryInfo_IDField = ansi837ConstResult.SUBSCRIBER_ID;

    //        //                // Payer Details
    //        //                obj837FieldBinder.nM103_Payer_NameField = ansi837VisitResult.InsuranceName;
    //        //                obj837FieldBinder.nM108_Payer_IDCodeQualifierField = ansi837VisitResult.PayerID;
    //        //                obj837FieldBinder.nM109_Payer_PayerIdentifierField = ansi837VisitResult.PayerID;

    //        //                obj837FieldBinder.n301_Payer_Address1Field = ansi837VisitResult.INSURANCE_STREET_NAME;    // Insurance
    //        //                obj837FieldBinder.n302_Payer_Address2Field = ansi837VisitResult.INSURANCE_SUITE;     // Insurance
    //        //                obj837FieldBinder.n401_Payer_CityNameField = insuranceCityResult.CityCode;
    //        //                obj837FieldBinder.n402_Payer_StateCodeField = insuranceStateResult.StateCode;
    //        //                obj837FieldBinder.n403_Payer_ZipCodeField = insuranceCityResult.ZipCode;
    //        //                obj837FieldBinder.n404_Payer_CountryCodeField = insuranceCountryResult.CountryCode;

    //        //                obj837FieldBinder.rEF01_Payer_IDQualifierField = ansi837VisitResult.PayerID;
    //        //                obj837FieldBinder.rEF02_Payer_IDField = ansi837VisitResult.PayerID;

    //        //                obj837FieldBinder.pAT01_Patient_IndRelationshipCodeField = ansi837VisitResult.RelationshipCode;

    //        //                // Checking whether patient status is dead or not
    //        //                // Here no more death case
    //        //                //if (dtData.Rows[iCurRow]["fvDeathStatus"].ToString().Equals("Death") && !(dtData.Rows[iCurRow]["fvPreEstDt"].ToString().Equals("-1") || dtData.Rows[iCurRow]["fvPreEstDt"].ToString().Equals("")))
    //        //                //{
    //        //                //    obj837FieldBinder.pAT05_Patient_IllDateTimeQualifierField = "D8";
    //        //                //    obj837FieldBinder.pAT06_Patient_DeathDateField = dtData.Rows[iCurRow]["fvPreEstDt"].ToString();
    //        //                //}

    //        //                obj837FieldBinder.pAT07_UnitorBasicMesurementCodeField = ansi837ConstResult.UNITOR_CODE;
    //        //                obj837FieldBinder.pAT08_WeightField = ansi837ConstResult.UNITOR_WEIGHT;

    //        //                // Applied only to female patient is Pregnant
    //        //                obj837FieldBinder.pAT09_Patient_PregnancyIndicatorField = ansi837ConstResult.IS_PREGNANCY;

    //        //                // Patient Details
    //        //                obj837FieldBinder.nM103_Patient_LastNameField = ansi837VisitResult.PATIENT_LAST_NAME;
    //        //                obj837FieldBinder.nM104_Patient_FirstNameField = ansi837VisitResult.PATIENT_FIRST_NAME;
    //        //                obj837FieldBinder.nM105_Patient_MiddleNameField = ansi837VisitResult.PATIENT_MIDDLE_NAME;
    //        //                obj837FieldBinder.nM107_Patient_SuffixNameField = ansi837ConstResult.PATIENT_SUFFIX;
    //        //                obj837FieldBinder.nM108_Patient_IDCodeQualifierField = ansi837ConstResult.PATIENT_ID_CODE;
    //        //                obj837FieldBinder.nM109_Patient_PrimaryIdentifierField = ansi837ConstResult.PATIENT_PRIMARY_ID;

    //        //                obj837FieldBinder.n301_Patient_Address1Field = ansi837VisitResult.PATIENT_STREET_NAME;
    //        //                obj837FieldBinder.n302_Patient_Address2Field = ansi837VisitResult.PATIENT_SUITE;
    //        //                obj837FieldBinder.n401_Patient_CityNameField = patientCityResult.CityCode;
    //        //                obj837FieldBinder.n402_Patient_StateCodeField = patientStateResult.StateCode;
    //        //                obj837FieldBinder.n403_Patient_ZIPCodeField = patientCityResult.ZipCode;
    //        //                obj837FieldBinder.n404_Patient_CountryCodeField = patientCountryResult.CountryCode;

    //        //                obj837FieldBinder.dMG02_Patient_BirthDateField = ansi837VisitResult.DOB.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.dMG03_Patient_GenderCodeField = ansi837VisitResult.Sex;

    //        //                obj837FieldBinder.dMG02_Patient_RefIDQualifierField = ansi837ConstResult.PATIENT_REF_ID1;
    //        //                obj837FieldBinder.dMG03_Patient_SecondaryIDField = ansi837ConstResult.PATIENT_REF_ID2;

    //        //                // Date Loop
    //        //                obj837FieldBinder.dTP03_Date_InitialTreatmentField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.dTP03_Date_OnsetCurrentIllness_SymptomField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.dTP03_Date_SimilarIllness_SymptomOnsetField = ansi837VisitResult.IllnessIndicatorDate.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.dTP03_Date_AccidentField = ansi837ConstResult.DATE_ACCIDENT;
    //        //                obj837FieldBinder.dTP03_Date_LastMenstrualPeriodField = ansi837ConstResult.DATE_LMP;
    //        //                obj837FieldBinder.dTP03_Date_LastXRayField = ansi837ConstResult.DATE_XRAY;
    //        //                obj837FieldBinder.dTP03_Date_EstimatedDateofBirthField = ansi837ConstResult.DATE_DELIVERY;
    //        //                obj837FieldBinder.dTP03_Date_DisabilityBeginField = ansi837ConstResult.DATE_DISABILITY;
    //        //                obj837FieldBinder.dTP03_Date_DisabilityEndField = ansi837ConstResult.DATE_DISABILITY;
    //        //                obj837FieldBinder.dTP03_Date_LastWorkedField = ansi837ConstResult.DATE_WORKED;
    //        //                obj837FieldBinder.dTP03_Date_AuthorizedReturnToWorkField = ansi837ConstResult.DATE_WORKED;
    //        //                obj837FieldBinder.dTP03_Date_AdmissionField = (hospitalizationResult == null) ? ansi837ConstResult.DATE_HOSPITAL : hospitalizationResult.AdmittedOn.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.dTP03_Date_DischargeField = (hospitalizationResult == null) ? ansi837ConstResult.DATE_HOSPITAL : (hospitalizationResult.DischargedOn.HasValue) ? hospitalizationResult.DischargedOn.Value.ToString("MM/dd/yyyy") : ansi837ConstResult.DATE_HOSPITAL;
    //        //                obj837FieldBinder.dTP03_Date_AssumedAndRelinquishedCareDatesField = ansi837ConstResult.DATE_CARE;
    //        //                obj837FieldBinder.dTP03_Date_PropertyAndCasualtyDateOfFirstContactField = ansi837ConstResult.DATE_CONTACT;
    //        //                obj837FieldBinder.rEF02_PriorAuthorizationOrReferalNumberField = ansi837ConstResult.PRIOR_AUTH_NUM;

    //        //                // Claim Information
    //        //                obj837FieldBinder.cLM01_ClaimInfo_PatientAccountNoField = ansi837VisitResult.ChartNumber;
    //        //                obj837FieldBinder.cLM053_ClaimInfo_FrequencyCodeField = ansi837ConstResult.CLAIM_FREQUENCY;

    //        //                // Provider Signature
    //        //                obj837FieldBinder.cLM06_ClaimInfo_ProviderSupplier_SignatureField = ansi837VisitResult.PrintPinCode;
    //        //                obj837FieldBinder.cLM08_ClaimInfo_BenefitsAssignCertificateIndicatorField = ansi837VisitResult.PrintPinCode;
    //        //                obj837FieldBinder.cLM09_ClaimInfo_ReleaseInformationCodeField = patientPrintSignResult.PrintSignCode;
    //        //                obj837FieldBinder.cLM010_ClaimInfo_PatientSignatureSourceCodeField = patientPrintSignResult.PrintSignCode;
    //        //                obj837FieldBinder.cLM07_ClaimInfo_MedicareAssignmentCodeField = ansi837VisitResult.MedicareID;

    //        //                // Yet to implement with accident related
    //        //                obj837FieldBinder.cLM0111_ClaimInfo_RelatedCauseCode1Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_1;
    //        //                obj837FieldBinder.cLM0112_ClaimInfo_RelatedCauseCode2Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_2;
    //        //                obj837FieldBinder.cLM0113_ClaimInfo_RelatedCauseCode3Field = ansi837ConstResult.ACCIDENT_CAUSE_CODE_3;
    //        //                obj837FieldBinder.cLM0114_ClaimInfo_AutoAccidentStateProvinceCodeField = ansi837ConstResult.ACCIDENT_PROVINCE_CODE;
    //        //                obj837FieldBinder.cLM0115_ClaimInfo_CountryCodeField = ansi837ConstResult.ACCIDENT_COUNTRY_CODE;
    //        //                obj837FieldBinder.cLM012_ClaimInfo_SpProgramIndicatorField = ansi837ConstResult.ACCIDENT_PROVINCE_CODE;
    //        //                obj837FieldBinder.cLM020_ClaimInfo_DelayReasonCodeField = ansi837ConstResult.ACCIDENT_DELAY_CODE;

    //        //                // Filling Refering Providers
    //        //                obj837FieldBinder.nM101_ReferProvider_EntityIdentifierCodeField = ansi837ConstResult.REF_PROV_ENTITY_CODE;
    //        //                obj837FieldBinder.nM102_ReferProvider_EntityTypeQualifierField = ansi837ConstResult.REF_PROV_ENTITY_TYPE;
    //        //                obj837FieldBinder.nM103_ReferProvider_LastNameField = ansi837VisitResult.PROVIDER_LAST_NAME;
    //        //                obj837FieldBinder.nM104_ReferProvider_FirstNameField = ansi837VisitResult.PROVIDER_FIRST_NAME;
    //        //                obj837FieldBinder.nM105_ReferProvider_MiddleNameField = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
    //        //                obj837FieldBinder.nM107_ReferProvider_SuffixNameField = ansi837VisitResult.CredentialCode;
    //        //                obj837FieldBinder.nM108_ReferProvider_IDCodeQualifierField = ansi837ConstResult.REF_PROV_QUALI_CODE;
    //        //                obj837FieldBinder.nM109_ReferProvider_IdentifierField = ansi837VisitResult.NPI;

    //        //                obj837FieldBinder.rEF01_ReferProvider_IDQualifierField = ansi837VisitResult.TaxID;
    //        //                obj837FieldBinder.rEF02_ReferProvider_SecondaryIDField = ansi837VisitResult.TaxID;

    //        //                // Filling RenderingProviders
    //        //                obj837FieldBinder.nM101_RenderProvider_EntityIdentifierCodeField = ansi837ConstResult.REN_PROV_ENTITY_CODE;
    //        //                obj837FieldBinder.nM102_RenderProvider_EntityTypeQualifierField = ansi837ConstResult.REN_PROV_ENTITY_TYPE;
    //        //                obj837FieldBinder.nM103_RenderProvider_LastNameField = ansi837VisitResult.PROVIDER_LAST_NAME;
    //        //                obj837FieldBinder.nM104_RenderProvider_FirstNameField = ansi837VisitResult.PROVIDER_FIRST_NAME;
    //        //                obj837FieldBinder.nM105_RenderProvider_MiddleNameField = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
    //        //                obj837FieldBinder.nM107_RenderProvider_SuffixNameField = ansi837VisitResult.CredentialCode;
    //        //                obj837FieldBinder.nM108_RenderProvider_IDCodeQualifierField = ansi837ConstResult.REN_PROV_QUALI_CODE;
    //        //                obj837FieldBinder.nM109_RenderProvider_IdentifierField = ansi837VisitResult.NPI;

    //        //                obj837FieldBinder.pRV02_RenderProvider_IDQualifierField = ansi837ConstResult.REN_PROV_QUALI_ID;
    //        //                obj837FieldBinder.pRV02_RenderProvider_TaxonomyCodeField = ansi837VisitResult.SpecialtyCode;

    //        //                obj837FieldBinder.rEF01_RenderProvider_IDQualifierField = ansi837VisitResult.TaxID;
    //        //                obj837FieldBinder.rEF02_RenderProvider_SecondaryIDField = ansi837VisitResult.TaxID;

    //        //                // Service Facility

    //        //                obj837FieldBinder.nM103_ServiceFacility_FacilityNameField = clinicResult.ClinicName;
    //        //                obj837FieldBinder.nM108_ServiceFacility_IDCodeQualifierField = clinicResult.TaxID;
    //        //                obj837FieldBinder.nM109_ServiceFacility_PrimaryIdentifierField = clinicResult.NPI;

    //        //                obj837FieldBinder.n301_ServiceFacility_Address1Field = clinicResult.StreetName;
    //        //                obj837FieldBinder.n302_ServiceFacility_Address2Field = clinicResult.Suite;

    //        //                obj837FieldBinder.n401_ServiceFacility_CityNameField = clinicCityResult.CityCode;
    //        //                obj837FieldBinder.n402_ServiceFacility_StateCodeField = clinicStateResult.StateCode;
    //        //                obj837FieldBinder.n403_ServiceFacility_ZipCodeField = clinicCityResult.ZipCode;
    //        //                obj837FieldBinder.n404_ServiceFacility_CountryCodeField = clinicCountryResult.CountryCode;

    //        //                obj837FieldBinder.rEF01_ServiceFacility_IDQualifierField = clinicResult.NPI;
    //        //                obj837FieldBinder.rEF02_ServiceFacility_FacilitySecondaryIDField = clinicResult.TaxID;

    //        //                // Secondary Insurance Details

    //        //                obj837FieldBinder.sBR01_Secondary_PayerResponsibleSequenceNoCodeField = ansi837ConstResult.PRIMARY_INSURANCE;
    //        //                obj837FieldBinder.sBR02_Secondary_IndividualResponseCodeField = ansi837VisitResult.RelationshipCode;
    //        //                obj837FieldBinder.sBR04_Secondary_GroupNameField = ansi837VisitResult.GroupNumber;
    //        //                obj837FieldBinder.sBR05_Secondary_InsuranceTypeCodeField = ansi837VisitResult.InsuranceTypeCode;
    //        //                obj837FieldBinder.sBR09_Secondary_ClaimFillingIndicatorCodeField = ansi837VisitResult.PolicyNumber;
    //        //                obj837FieldBinder.sDMG02_Secondary_BirthDateField = ansi837VisitResult.DOB.ToString("MM/dd/yyyy");
    //        //                obj837FieldBinder.sDMG03_Secondary_GenderCodeField = ansi837VisitResult.Sex;


    //        //                /////////////////////////////////////////////////////////////////////////////////////////////////

    //        //                objProcedure = new List<ANSI837Procedures>();
    //        //                claimNoDiagnosisResults = new List<usp_GetAnsi837_ClaimDiagnosis_Result>(from o in claimDiagnosisResults where o.CLAIM_NUMBER == claimNo select o);
    //        //                loop = 0;
    //        //                foreach (usp_GetAnsi837_ClaimDiagnosis_Result claimNoDiagnosisResult in claimNoDiagnosisResults)
    //        //                {
    //        //                    loop++;

    //        //                    // Filling Diagnosis Informations
    //        //                    switch (loop)
    //        //                    {
    //        //                        case 1:
    //        //                            obj837FieldBinder.hI101_2_Diagnosis_Code1Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 2:
    //        //                            obj837FieldBinder.hI102_2_Diagnosis_Code2Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 3:
    //        //                            obj837FieldBinder.hI103_2_Diagnosis_Code3Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 4:
    //        //                            obj837FieldBinder.hI104_2_Diagnosis_Code4Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 5:
    //        //                            obj837FieldBinder.hI105_2_Diagnosis_Code5Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 6:
    //        //                            obj837FieldBinder.hI106_2_Diagnosis_Code6Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 7:
    //        //                            obj837FieldBinder.hI107_2_Diagnosis_Code7Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 8:
    //        //                            obj837FieldBinder.hI108_2_Diagnosis_Code8Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 9:
    //        //                            obj837FieldBinder.hI109_2_Diagnosis_Code9Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 10:
    //        //                            obj837FieldBinder.hI110_2_Diagnosis_Code10Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 11:
    //        //                            obj837FieldBinder.hI111_2_Diagnosis_Code11Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        case 12:
    //        //                            obj837FieldBinder.hI112_2_Diagnosis_Code12Field = claimNoDiagnosisResult.CODE;
    //        //                            break;
    //        //                        default:
    //        //                            throw new Exception("Sorry! More than 12 Dx in a same claim number is not allowed");
    //        //                    }

    //        //                    //cptResults = new List<usp_GetAnsi837_ClaimDiagnosisCPT_Result>(ctx.usp_GetAnsi837_ClaimDiagnosisCPT(claimNoDiagnosisResult.CLAIM_DIAGNOSIS_ID));

    //        //                    //foreach (usp_GetAnsi837_ClaimDiagnosisCPT_Result cptResult in cptResults)
    //        //                    //{
    //        //                    //    ANSI837Procedures obj837Procedures = new ANSI837Procedures();
    //        //                    //    // Filling Procedures Informations
    //        //                    //    obj837Procedures.dTP103_ServiceLine_DOSField = cptResult.CPTDOS.ToString("MM/dd/yyyy");
    //        //                    //    obj837Procedures.sV1012_ServiceLine_ProcedureCodeField = cptResult.CPTCode;
    //        //                    //    obj837Procedures.sV102_ServiceLine_ChargeAmtField = (cptResult.ChargePerUnit * cptResult.Unit).ToString();
    //        //                    //    obj837Procedures.sV104_ServiceLine_UnitCountField = cptResult.Unit.ToString();
    //        //                    //    obj837Procedures.sV105_ServiceLine_POSField = cptResult.FacilityTypeCode;
    //        //                    //    obj837Procedures.sV1071_ServiceLine_DiagnosisCodePtr1Field = cptResult.FacilityTypeCode;
    //        //                    //    obj837FieldBinder.cLM02_ClaimInfo_TotalClaimAmountField = (cptResult.ChargePerUnit * cptResult.Unit).ToString();
    //        //                    //    obj837FieldBinder.cLM051_ClaimInfo_FacilityTypeCodeField = cptResult.FacilityTypeCode;

    //        //                    //    obj837Procedures.sV109_ServiceLine_EmergencyIndicatorField = ansi837ConstResult.EMERGENCY_INDICATOR;
    //        //                    //    obj837Procedures.sV111_ServiceLine_EPSDTIndicator_MedicaidOnlyField = ansi837ConstResult.EMERGENCY_EPSD;
    //        //                    //    obj837Procedures.sV112_ServiceLine_FamilyPlanIndicator_MedicaidOnlyField = ansi837ConstResult.EMERGENCY_FAMILY;

    //        //                    //    modifierResults = new List<usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result>(ctx.usp_GetAnsi837_ClaimDiagnosisCPTModifier(cptResult.ClaimDiagnosisCPTID));

    //        //                    //    foreach (usp_GetAnsi837_ClaimDiagnosisCPTModifier_Result modifierResult in modifierResults)
    //        //                    //    {
    //        //                    //        switch (modifierResult.ModifierLevel)
    //        //                    //        {
    //        //                    //            case 1:
    //        //                    //                obj837Procedures.sV1013_ServiceLine_Modifier1Field = modifierResult.ModifierCode;
    //        //                    //                break;
    //        //                    //            case 2:
    //        //                    //                obj837Procedures.sV1014_ServiceLine_Modifier2Field = modifierResult.ModifierCode;
    //        //                    //                break;
    //        //                    //            case 3:
    //        //                    //                obj837Procedures.sV1015_ServiceLine_Modifier3Field = modifierResult.ModifierCode;
    //        //                    //                break;
    //        //                    //            case 4:
    //        //                    //                obj837Procedures.sV1016_ServiceLine_Modifier4Field = modifierResult.ModifierCode;
    //        //                    //                break;
    //        //                    //            case 5:
    //        //                    //                obj837Procedures.sV1017_ServiceLine_Modifier5Field = modifierResult.ModifierCode;
    //        //                    //                break;
    //        //                    //            default:
    //        //                    //                throw new Exception("Sorry! More than 5 Modifier levels in a same CPT is not allowed");
    //        //                    //        }
    //        //                    //    }

    //        //                    //    objProcedure.Add(obj837Procedures);
    //        //                    //}
    //        //                }

    //        //                objFieldBinder.Add(obj837FieldBinder);


    //        //                objWrap.caseNumberField = ansi837VisitResult.PatientVisitID; // Storing the case no
    //        //                objWrap.aNSI837ProceduresField = objProcedure.ToArray();
    //        //                objWrap.aNSI837FieldBinderField = objFieldBinder.ToArray();

    //        //                aryWrapper.Add(objWrap);
    //        //            }

    //        //            # endregion

    //        //            # region Update Visit Status

    //        //            ansi837VisitResult.AssignedTo = pUserID;
    //        //            ansi837VisitResult.TargetEAUserID = pUserID;

    //        //            if ((ansi837VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE)) || (ansi837VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK)))
    //        //            {
    //        //                _StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.SENT_CLAIM));
    //        //            }
    //        //            else
    //        //            {
    //        //                _StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.SENT_CLAIM));
    //        //            }

    //        //            objParam = ObjParam("PatientVisitID", typeof(System.Int64), ansi837VisitResult.PatientVisitID);

    //        //            ctx.usp_Update_PatientVisit(ansi837VisitResult.PatientID, ansi837VisitResult.PatientHospitalizationID, ansi837VisitResult.DOS
    //        //            , ansi837VisitResult.IllnessIndicatorID, ansi837VisitResult.IllnessIndicatorDate, ansi837VisitResult.FacilityTypeID
    //        //            , ansi837VisitResult.FacilityDoneID, ansi837VisitResult.PrimaryClaimDiagnosisID, ansi837VisitResult.DoctorNoteRelPath
    //        //            , ansi837VisitResult.SuperBillRelPath, ansi837VisitResult.PatientVisitDesc, _StatusIds
    //        //            , ansi837VisitResult.AssignedTo, ansi837VisitResult.TargetBAUserID, ansi837VisitResult.TargetQAUserID
    //        //            , ansi837VisitResult.TargetEAUserID, ansi837VisitResult.PatientVisitComplexity, ansi837VisitResult.Comment
    //        //            , ansi837VisitResult.IsActive, ansi837VisitResult.LastModifiedBy, ansi837VisitResult.LastModifiedOn, pUserID, objParam);

    //        //            if (HasErr(objParam, ctx))
    //        //            {
    //        //                throw new Exception(this.ErrorMsg);
    //        //            }

    //        //            claimProcessIDs.Add((new List<long?>(ctx.usp_GetMaxID_ClaimProcess(ansi837VisitResult.PatientVisitID, Convert.ToByte(ClaimStatus.EDI_FILE_CREATED))).First()).Value);

    //        //            # endregion
    //        //        }

    //        //        # endregion

    //        //        objData.aNSI837DataBinderField = objANSIData;
    //        //        objData.aNSI837WrapperField = aryWrapper.ToArray();

    //        //        strDataPro = client.CreateASCI837(objData).ToList();

    //        //        # endregion

    //        //        # region Save

    //        //        FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\P_", EDIFileID);
    //        //        if (!(Directory.Exists(FileSvrEDIX12FilePath)))
    //        //        {
    //        //            DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIX12FilePath);
    //        //            dirInfo = null;
    //        //        }
    //        //        FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "X12_5010_", EDIFileID, ".txt");

    //        //        FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\P_", EDIFileID);
    //        //        if (!(Directory.Exists(FileSvrEDIRefFilePath)))
    //        //        {
    //        //            DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIRefFilePath);
    //        //            dirInfo = null;
    //        //        }
    //        //        FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "Ref_5010_", EDIFileID, ".txt");

    //        //        _EDIX12FileRelPath = FileSvrEDIX12FilePath.Replace(FileSvrRootPath, string.Empty);
    //        //        _EDIRefFileRelPath = FileSvrEDIRefFilePath.Replace(FileSvrRootPath, string.Empty);

    //        //        _EDIX12FileRelPath = _EDIX12FileRelPath.Substring(1);
    //        //        _EDIRefFileRelPath = _EDIRefFileRelPath.Substring(1);

    //        //        //http://social.msdn.microsoft.com/Forums/en-US/csharpgeneral/thread/7f42a0cb-2113-4749-bfd9-8e5228345c68

    //        //        using (TextWriter tw = new StreamWriter(FileSvrEDIX12FilePath, false, Encoding.GetEncoding(1252)))
    //        //        {
    //        //            tw.WriteLine(strDataPro[1]);
    //        //        }

    //        //        using (TextWriter tw = new StreamWriter(FileSvrEDIRefFilePath, false, Encoding.GetEncoding(1252)))
    //        //        {
    //        //            tw.WriteLine(strDataPro[0]);
    //        //        }

    //        //        # endregion

    //        //        # region Save EDIFile

    //        //        objParam = ObjParam("EDIFile");

    //        //        ctx.usp_Insert_EDIFile(Convert.ToInt32(EDIReceiver.EMDEON5010), _EDIX12FileRelPath, _EDIRefFileRelPath, null, pUserID, objParam);

    //        //        if (HasErr(objParam, ctx))
    //        //        {
    //        //            throw new Exception(this.ErrorMsg);
    //        //        }

    //        //        # endregion

    //        //        # region Save ClaimProcessEDIFile

    //        //        objParam = ObjParam("ClaimProcessEDIFile");

    //        //        foreach (long claimProcessID in claimProcessIDs)
    //        //        {
    //        //            ctx.usp_Insert_ClaimProcessEDIFile(claimProcessID, EDIFileID, null, pUserID, objParam);

    //        //            if (HasErr(objParam, ctx))
    //        //            {
    //        //                throw new Exception(this.ErrorMsg);
    //        //            }
    //        //        }

    //        //        # endregion

    //        //        CommitDbTrans(ctx);
    //        //    }
    //        //    catch (Exception ex)
    //        //    {
    //        //        RollbackDbTrans(ctx);
    //        //        throw ex;
    //        //    }
    //        //}

    //        return true;
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pUserID"></param>
    //    /// <returns></returns>
    //    protected override bool SaveUpdate(int pUserID)
    //    {
    //        throw new NotImplementedException();
    //    }

    //    #endregion
    //}

    //#endregion

    //# region EDI Success Model

    ///// <summary>
    ///// 
    ///// </summary>
    //public class EDICreateSuccessModel : BaseModel
    //{
    //    #region Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public string X12 { get; set; }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public List<string> Refs { get; set; }

    //    #endregion

    //    # region constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public EDICreateSuccessModel()
    //    {
    //    }

    //    # endregion

    //    #region Abstract Methods


    //    #endregion
    //}

    //#endregion

    #endregion

    # endregion

    #region Class Respond EDI

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class EDIRespondSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetSentFile_EDIFile_Result> EDIFileResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<EDIFileSearchSubModel> EDIFileSearchSubModels { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int UserID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DOSFrom
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DOSTo
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIRespondSearchModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            throw new NotImplementedException();
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                EDIFileResult = new List<usp_GetSentFile_EDIFile_Result>(ctx.usp_GetSentFile_EDIFile(ClinicID
                    , string.Concat(Convert.ToByte(ClaimStatus.SENT_CLAIM), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK))
                    , UserID, SearchName, DateFrom, DateTo, DOSFrom, DOSTo, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));

                if (EDIFileResult == null)
                {
                    EDIFileResult = new List<usp_GetSentFile_EDIFile_Result>();
                }
            }

            EDIFileSearchSubModels = new List<EDIFileSearchSubModel>();
        }

        #endregion

    }

    #endregion

    #endregion

    #region Class Respond EDIPatientVisit

    #region Search
    /// <summary>
    /// 
    /// </summary>
    public class EDIRespondVisitSearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetByID_ClaimProcessEDIFile_Result> EDIPatientVisit { get; set; }


        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> AssignedTo { get; set; }

        public string _CommentForEdiResponsed { get; set; }

        public string _CommentForAccepted { get; set; }

        public string _CommentForDone { get; set; }

        public string _CommentForQAPerQ { get; set; }

        public string _CommentForRejectReasgn { get; set; }

        public string _CommentForRejected { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIRespondVisitSearchModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByAZ(bool? pIsActive)
        {

        }

        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {

        }

        #endregion

        # region Public Methods

        public void Search(int EDIFileID, int ClinicID, int UserID)
        {
            using (EFContext ctx = new EFContext())
            {

                EDIPatientVisit = new List<usp_GetByID_ClaimProcessEDIFile_Result>(ctx.usp_GetByID_ClaimProcessEDIFile(EDIFileID, ClinicID, UserID));
            }
        }
        /// <summary>
        /// //
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            EDIRespondVisitSaveModel objSaveModel = new EDIRespondVisitSaveModel();
            objSaveModel.CommentForAccepted = _CommentForAccepted;
            objSaveModel.CommentForDone = _CommentForDone;
            objSaveModel.CommentForEdiResponsed = _CommentForEdiResponsed;
            objSaveModel.CommentForQAPerQ = _CommentForQAPerQ;
            objSaveModel.CommentForRejected = _CommentForRejected;
            objSaveModel.CommentForRejectReasgn = _CommentForRejectReasgn;

            if (!(objSaveModel.Save(EDIPatientVisit, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion

    }

    #endregion

    # region Save
    public class EDIRespondVisitSaveModel : BaseSaveModel
    {

        #region Properties

        public Int32 ClinicID { get; set; }

        public string CommentForEdiResponsed { get; set; }

        public string CommentForAccepted { get; set; }

        public string CommentForDone { get; set; }

        public string CommentForQAPerQ { get; set; }

        public string CommentForRejectReasgn { get; set; }

        public string CommentForRejected { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIRespondVisitSaveModel()
        { }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(List<usp_GetByID_ClaimProcessEDIFile_Result> pEDIPatientVisit, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                //string StatusIds;

                foreach (usp_GetByID_ClaimProcessEDIFile_Result item in pEDIPatientVisit)
                {
                    StringBuilder sb = new StringBuilder();

                    if (item.AssignToMe)
                    {
                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.EDI_FILE_RESPONSED));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForEdiResponsed);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForAccepted);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.DONE));

                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForDone);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        //StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_RESPONSED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.DONE));
                    }
                    else
                    {
                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.EDI_FILE_RESPONSED));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForEdiResponsed);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.REJECTED_CLAIM));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForRejected);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForRejectReasgn);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForQAPerQ);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        //StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_RESPONSED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.REJECTED_CLAIM) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE)));
                    }

                    usp_GetByPkId_PatientVisit_Result visitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(item.PatientVisitID, pIsActive))).FirstOrDefault();

                    if (visitResult == null)
                    {
                        visitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                    }

                    EncryptAudit(visitResult.PatientVisitID, visitResult.LastModifiedBy, visitResult.LastModifiedOn);

                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    ctx.usp_Update_PatientVisit(visitResult.PatientID, visitResult.DOS, visitResult.IllnessIndicatorID, visitResult.IllnessIndicatorDate
                    , visitResult.FacilityTypeID, visitResult.FacilityDoneID, visitResult.PrimaryClaimDiagnosisID, visitResult.DoctorNoteRelPath, visitResult.SuperBillRelPath, visitResult.PatientVisitDesc
                    , sb.ToString(), pUserID, visitResult.TargetBAUserID, visitResult.TargetQAUserID, visitResult.TargetEAUserID, visitResult.PatientVisitComplexity
                    , visitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                    if (HasErr(patientVisitID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }

                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion
    }

    #endregion

    #endregion

    #region Create Ansi 837 5010

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class Ansi8375010SearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetAnsi837Visit_ClaimProcess_Result> PatientVisit
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int EDIReceiverID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_EDIReceiver_Result EDIReceiverNameCode { get; set; }

        #endregion

        protected override void FillByAZ(bool? pIsActive)
        {

        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID, EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));
                EDIReceiverNameCode = new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(EDIReceiverID, true)).FirstOrDefault();
            }
        }
    }

    # endregion

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class Ansi8375010SaveModel : BaseSaveModel
    {
        # region Private Variables

        private global::System.String _EDIX12FileRelPath;
        private global::System.String _EDIRefFileRelPath;

        public string CommentForEAPerQ { get; set; }

        public string CommentForEdiCreated { get; set; }

        public string CommentForSentClaim { get; set; }
        //private global::System.String _StatusIds;
        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public int EDIReceiverID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ANSI5010XmlPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrRootPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrEDIX12FilePath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrEDIRefFilePath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int32 ClinicID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.DateTime EDIFileDate
        {
            get;
            set;
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            Static5010.LoadXml(ANSI5010XmlPath);

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                try
                {
                    # region Declaration

                    ANSI5010Main objANSI5010Main;
                    GSDetail objGSDetail;
                    List<ANSI5010Loop> ansi5010Loops;

                    usp_GetAnsi837EDIReceiver_ClaimProcess_Result ediReceiverResult;
                    usp_GetAnsi837Clinic_ClaimProcess_Result clinicResult;

                    usp_GetAnsi837FacilityDone_ClaimProcess_Result facilitiyDoneResult;

                    List<usp_GetAnsi837Visit_ClaimProcess_Result> ansi837VisitResults;
                    List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result> visitCPTResults;
                    List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result> claimCPTResults;
                    usp_GetAnsi837Hosp_ClaimProcess_Result hospResult;

                    ObjectParameter objParam;
                    int hierarchicalIDNumber;
                    List<long> claimNos;
                    decimal? claimTotCharge;
                    UInt16 claimDxCount;
                    UInt16 claimCptCount;
                    string prevDxCode;
                    List<long> claimProcessIDs;
                    int ediFileID;
                    long interCtrlNo;
                    string interCtrlNoStr;
                    string prevInsName;
                    string prevProvName;
                    int gsCount;
                    int stCount;
                    int bhtCount;

                    # endregion

                    # region Data

                    # region Fetch From DB

                    ediFileID = Convert.ToInt32((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("EDI", "EDIFile"))).FirstOrDefault().NEXT_INDENTITY);

                    ediReceiverResult = (new List<usp_GetAnsi837EDIReceiver_ClaimProcess_Result>(ctx.usp_GetAnsi837EDIReceiver_ClaimProcess(EDIReceiverID))).FirstOrDefault();
                    if (ediReceiverResult == null)
                    {
                        ediReceiverResult = new usp_GetAnsi837EDIReceiver_ClaimProcess_Result();
                    }

                    interCtrlNo = ediReceiverResult.LastInterchangeControlNumber;
                    interCtrlNo++;
                    interCtrlNoStr = interCtrlNo.ToString();
                    while (interCtrlNoStr.Length < 9)
                    {
                        interCtrlNoStr = string.Concat("0", interCtrlNoStr);
                    }

                    clinicResult = (new List<usp_GetAnsi837Clinic_ClaimProcess_Result>(ctx.usp_GetAnsi837Clinic_ClaimProcess(ClinicID))).FirstOrDefault();
                    if (clinicResult == null)
                    {
                        clinicResult = new usp_GetAnsi837Clinic_ClaimProcess_Result();
                    }

                    ansi837VisitResults = new List<usp_GetAnsi837Visit_ClaimProcess_Result>(ctx.usp_GetAnsi837Visit_ClaimProcess(ClinicID, ediReceiverResult.EDIReceiverID, string.Concat(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK))));

                    # endregion

                    # region Initilization

                    objANSI5010Main = new ANSI5010Main();
                    objGSDetail = null;
                    claimProcessIDs = new List<long>();
                    prevInsName = string.Empty;
                    prevProvName = string.Empty;
                    gsCount = 0;
                    stCount = 0;
                    bhtCount = 0;
                    hierarchicalIDNumber = 0;

                    # endregion

                    # region Header

                    objANSI5010Main.P001_ISA.P001_AuthorizationInformationQualifier = ediReceiverResult.AuthorizationInformationQualifierCode;
                    objANSI5010Main.P001_ISA.P002_AuthorizationInformation = ediReceiverResult.AuthorizationInformation;
                    objANSI5010Main.P001_ISA.P003_SecurityInformationQualifier = ediReceiverResult.AuthorizationInformationQualifierCode;
                    objANSI5010Main.P001_ISA.P004_SecurityInformation = ediReceiverResult.SecurityInformation;
                    objANSI5010Main.P001_ISA.P005_InterchangeIDQualifierSender = ediReceiverResult.SenderInterchangeIDQualifierCode;
                    objANSI5010Main.P001_ISA.P006_InterchangeSenderID = ediReceiverResult.SenderInterchangeID;
                    objANSI5010Main.P001_ISA.P007_InterchangeIDQualifierReceiver = ediReceiverResult.ReceiverInterchangeIDQualifierCode;
                    objANSI5010Main.P001_ISA.P008_InterchangeReceiverID = ediReceiverResult.ReceiverInterchangeID;
                    objANSI5010Main.P001_ISA.P009_InterchangeDate = string.Compare(Static5010.ReadXml("InterchangeDateFormat"), "YYMMDD", false) == 0 ? EDIFileDate.ToString("yyMMdd") : Static5010.ReadXml("InterchangeDateFormat");
                    objANSI5010Main.P001_ISA.P010_InterchangeTime = string.Compare(Static5010.ReadXml("InterchangeTimeFormat"), "HHMM", false) == 0 ? EDIFileDate.ToString("HHmm") : Static5010.ReadXml("InterchangeTimeFormat");
                    objANSI5010Main.P001_ISA.P011_RepetitionSeparator = Static5010.ReadXml("CharIsRepeat");
                    objANSI5010Main.P001_ISA.P012_InterchangeControlVersionNumber = Static5010.ReadXml("InterchangeControlVersionNumberCode");
                    objANSI5010Main.P001_ISA.P013_InterchangeControlNumber = interCtrlNoStr;
                    objANSI5010Main.P001_ISA.P014_AcknowledgmentRequested = Static5010.ReadXml("AcknowledgmentRequestedCode");
                    objANSI5010Main.P001_ISA.P015_InterchangeUsageIndicator = ediReceiverResult.InterchangeUsageIndicatorCode;
                    objANSI5010Main.P001_ISA.P016_ComponentElementSeparator = Static5010.ReadXml("CharIsNotField");

                    # endregion

                    # region Visit Loop

                    foreach (usp_GetAnsi837Visit_ClaimProcess_Result ansi837VisitResult in ansi837VisitResults)
                    {
                        if ((string.Compare(prevInsName, ansi837VisitResult.InsuranceName, true) != 0) || (string.Compare(prevProvName, ansi837VisitResult.PROVIDER_NAME, true) != 0))
                        {
                            prevInsName = ansi837VisitResult.InsuranceName;
                            prevProvName = ansi837VisitResult.PROVIDER_NAME;

                            if (objGSDetail != null)
                            {
                                # region Footer Sub

                                bhtCount++;
                                objGSDetail.P017_SE.P001_NumberOfIncludedSegments = bhtCount.ToString();
                                objGSDetail.P017_SE.P002_TransactionSetControlNumber = string.Concat(interCtrlNo, gsCount, stCount);

                                objGSDetail.P018_GE.P001_NumberofTransactionSetsIncluded = stCount.ToString();
                                objGSDetail.P018_GE.P002_GroupControlNumber = string.Concat(interCtrlNo, gsCount);

                                # endregion

                                objANSI5010Main.P002_GSDetails.Add(objGSDetail);
                            }

                            objGSDetail = new GSDetail();

                            # region Header Sub

                            gsCount++;
                            stCount = 0;
                            bhtCount = 0;
                            hierarchicalIDNumber = 1;
                            objGSDetail.P001_GS.P001_FunctionalIdentifierCode = ediReceiverResult.FunctionalIdentifierCode;
                            objGSDetail.P001_GS.P002_ApplicationSenderCode = ediReceiverResult.ApplicationSenderCode;
                            objGSDetail.P001_GS.P003_ApplicationReceiverCode = ediReceiverResult.ApplicationReceiverCode;
                            objGSDetail.P001_GS.P004_Date = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? EDIFileDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
                            objGSDetail.P001_GS.P005_Time = string.Compare(Static5010.ReadXml("FunctionalGroupTimeFormat"), "HHMMSS", false) == 0 ? EDIFileDate.ToString("HHmmss") : Static5010.ReadXml("FunctionalGroupTimeFormat");
                            objGSDetail.P001_GS.P006_GroupControlNumber = string.Concat(interCtrlNo, gsCount);
                            objGSDetail.P001_GS.P007_ResponsibleAgencyCode = Static5010.ReadXml("ResponsibleAgencyCodeCode");
                            objGSDetail.P001_GS.P008_IndustryIdentifierCode = ediReceiverResult.ClaimMediaCode;

                            stCount++;
                            bhtCount++;
                            objGSDetail.P002_ST.P001_TransactionSetIdentifierCode = Static5010.ReadXml("TransactionSetIdentifierCode");
                            objGSDetail.P002_ST.P002_TransactionSetControlNumber = string.Concat(interCtrlNo, gsCount, stCount);
                            objGSDetail.P002_ST.P003_ImplementationConventionReference = ediReceiverResult.ClaimMediaCode;

                            bhtCount++;
                            objGSDetail.P003_BHT.P001_HierarchicalStructureCode = Static5010.ReadXml("HierarchicalStructureCode");
                            objGSDetail.P003_BHT.P002_TransactionSetPurposeCode = ediReceiverResult.TransactionSetPurposeCodeCode;
                            objGSDetail.P003_BHT.P003_ReferenceIdentification = string.Concat(interCtrlNo, gsCount, stCount, stCount);
                            objGSDetail.P003_BHT.P004_Date = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? EDIFileDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
                            objGSDetail.P003_BHT.P005_Time = string.Compare(Static5010.ReadXml("FunctionalGroupTimeFormat"), "HHMMSS", false) == 0 ? EDIFileDate.ToString("HHmmss") : Static5010.ReadXml("FunctionalGroupTimeFormat");
                            objGSDetail.P003_BHT.P006_TransactionTypeCode = ediReceiverResult.TransactionTypeCodeCode;

                            bhtCount++;
                            objGSDetail.P004_NM1L1000A.P001_EntityIdentifierCode = ediReceiverResult.SubmitterEntityIdentifierCodeCode;
                            objGSDetail.P004_NM1L1000A.P002_EntityTypeQualifier = clinicResult.ClinicEntityTypeQualifierCode;
                            objGSDetail.P004_NM1L1000A.P003_NameLastOrOrganizationName = clinicResult.ClinicName;
                            objGSDetail.P004_NM1L1000A.P008_IdentificationCodeQualifier = Static5010.ReadXml("SubmitterIdentificationCodeQualifier");
                            if (ediReceiverResult.SecurityInformationQualifierID == 1)
                            {
                                objGSDetail.P004_NM1L1000A.P009_IdentificationCode = ediReceiverResult.SenderInterchangeID;
                            }
                            else
                            {
                                objGSDetail.P004_NM1L1000A.P009_IdentificationCode = ediReceiverResult.SecurityInformationQualifierPassword;
                            }

                            bhtCount++;
                            objGSDetail.P005_PERL1000A.P001_ContactFunctionCode = Static5010.ReadXml("ContactFunctionCode");
                            objGSDetail.P005_PERL1000A.P002_Name = string.Concat(clinicResult.ContactPersonLastName, " ", clinicResult.ContactPersonFirstName, " ", clinicResult.ContactPersonMiddleName).Trim();
                            objGSDetail.P005_PERL1000A.P003_CommunicationNumberQualifier = ediReceiverResult.EmailCommunicationNumberQualifierCode;
                            objGSDetail.P005_PERL1000A.P004_CommunicationNumber = clinicResult.ContactPersonEmail;
                            objGSDetail.P005_PERL1000A.P007_CommunicationNumberQualifier2 = ediReceiverResult.PhoneCommunicationNumberQualifierCode;
                            objGSDetail.P005_PERL1000A.P008_CommunicationNumber2 = clinicResult.ContactPersonPhoneNumber.Replace("(", string.Empty).Replace(")", string.Empty).Replace("-", string.Empty);
                            if (!(string.IsNullOrWhiteSpace(clinicResult.ContactPersonFax)))
                            {
                                objGSDetail.P005_PERL1000A.P005_CommunicationNumberQualifier1 = ediReceiverResult.FaxCommunicationNumberQualifierCode;
                                objGSDetail.P005_PERL1000A.P006_CommunicationNumber1 = clinicResult.ContactPersonFax.Replace("(", string.Empty).Replace(")", string.Empty).Replace("-", string.Empty);
                            }

                            bhtCount++;
                            objGSDetail.P006_NM1L1000B.P001_EntityIdentifierCode = ediReceiverResult.ReceiverEntityIdentifierCodeCode;
                            objGSDetail.P006_NM1L1000B.P002_EntityTypeQualifier = ediReceiverResult.EntityTypeQualifierCode;
                            objGSDetail.P006_NM1L1000B.P003_NameLastOrOrganizationName = ediReceiverResult.EDIReceiverName;
                            objGSDetail.P006_NM1L1000B.P008_IdentificationCodeQualifier = Static5010.ReadXml("ReceiverIdentificationCodeQualifier");
                            if (ediReceiverResult.SecurityInformationQualifierID == 1)
                            {
                                objGSDetail.P006_NM1L1000B.P009_IdentificationCode = ediReceiverResult.ReceiverInterchangeID;
                            }
                            else
                            {
                                objGSDetail.P006_NM1L1000B.P009_IdentificationCode = ediReceiverResult.SecurityInformationQualifierUserName;
                            }

                            bhtCount++;
                            objGSDetail.P007_HLL2000A.P001_HierarchicalIDNumber = hierarchicalIDNumber.ToString();
                            objGSDetail.P007_HLL2000A.P003_HierarchicalLevelCode = Static5010.ReadXml("IpaHierarchicalLevelCode");
                            objGSDetail.P007_HLL2000A.P004_HierarchicalChildCode = Static5010.ReadXml("IpaHierarchicalChildCode");

                            bhtCount++;
                            objGSDetail.P010_NM1L2010AA.P001_EntityIdentifierCode = ediReceiverResult.BillingProviderEntityIdentifierCodeCode;
                            objGSDetail.P010_NM1L2010AA.P002_EntityTypeQualifier = clinicResult.IPAEntityTypeQualifierCode;
                            objGSDetail.P010_NM1L2010AA.P003_NameLastOrOrganizationName = clinicResult.IPAName;
                            objGSDetail.P010_NM1L2010AA.P008_IdentificationCodeQualifier = Static5010.ReadXml("IpaIdentificationCodeQualifier");
                            objGSDetail.P010_NM1L2010AA.P009_IdentificationCode = clinicResult.IPA_NPI;

                            bhtCount++;
                            objGSDetail.P011_N3L2010AA.P001_AddressInformation = clinicResult.IPA_STREET_NAME;

                            bhtCount++;
                            objGSDetail.P012_N4L2010AA.P001_CityName = clinicResult.IPACityName;
                            objGSDetail.P012_N4L2010AA.P002_StateorProvinceCode = clinicResult.IPAStateCode;
                            objGSDetail.P012_N4L2010AA.P003_PostalCode = clinicResult.IPAZipCode.Replace("-0000", string.Empty).Replace("-", string.Empty);
                            objGSDetail.P012_N4L2010AA.P004_CountryCode = (string.Compare("USA", clinicResult.IPACountryCode, true) == 0) ? string.Empty : clinicResult.IPACountryCode;

                            bhtCount++;
                            objGSDetail.P013_REFL2010AA.P001_ReferenceIdentificationQualifier = Static5010.ReadXml("IpaReferenceIdentificationQualifier");
                            objGSDetail.P013_REFL2010AA.P002_ReferenceIdentification = clinicResult.IPA_TAX_ID;

                            # endregion
                        }

                        # region Fetch From DB Visit Based


                        if (ansi837VisitResult.FacilityDoneID.HasValue)
                        {
                            facilitiyDoneResult = (new List<usp_GetAnsi837FacilityDone_ClaimProcess_Result>(ctx.usp_GetAnsi837FacilityDone_ClaimProcess(ansi837VisitResult.FacilityDoneID.Value))).FirstOrDefault();

                            if (facilitiyDoneResult == null)
                            {
                                facilitiyDoneResult = new usp_GetAnsi837FacilityDone_ClaimProcess_Result();
                            }
                        }
                        else
                        {
                            facilitiyDoneResult = new usp_GetAnsi837FacilityDone_ClaimProcess_Result();
                        }

                        visitCPTResults = new List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result>(ctx.usp_GetAnsi837Visit_ClaimDiagnosisCPT(ansi837VisitResult.PatientVisitID));
                        claimNos = new List<long>(new List<long>((from o in visitCPTResults where o.CLAIM_NUMBER > 0 select o.CLAIM_NUMBER)).Distinct());

                        # endregion

                        foreach (long claimNo in claimNos)
                        {
                            # region Fetch From DB Claim Based

                            claimTotCharge = (new List<decimal?>(ctx.usp_GetAnsi837TotalCharge_ClaimDiagnosisCPT(ansi837VisitResult.PatientVisitID, claimNo))).FirstOrDefault();

                            # endregion

                            hierarchicalIDNumber++;

                            SubPatDetail objSubPatDetail = new SubPatDetail(ansi837VisitResult.ChartNumber);

                            bhtCount++;
                            objSubPatDetail.P001_HLL2000B.P001_HierarchicalIDNumber = hierarchicalIDNumber.ToString();
                            objSubPatDetail.P001_HLL2000B.P002_HierarchicalParentIDNumber = Static5010.ReadXml("HierarchicalParentIDNumber");
                            objSubPatDetail.P001_HLL2000B.P003_HierarchicalLevelCode = Static5010.ReadXml("PatHierarchicalLevelCode");
                            objSubPatDetail.P001_HLL2000B.P004_HierarchicalChildCode = Static5010.ReadXml("PatHierarchicalChildCode");

                            bhtCount++;
                            objSubPatDetail.P002_SBRL2000B.P001_PayerResponsibilitySequenceNumberCode = ediReceiverResult.PayerResponsibilitySequenceNumberCodeCode;
                            objSubPatDetail.P002_SBRL2000B.P002_IndividualRelationshipCode = ansi837VisitResult.RelationshipCode;
                            objSubPatDetail.P002_SBRL2000B.P003_ReferenceIdentification = ansi837VisitResult.GroupNumber;
                            objSubPatDetail.P002_SBRL2000B.P004_Name = ansi837VisitResult.InsuranceName;
                            objSubPatDetail.P002_SBRL2000B.P009_ClaimFilingIndicatorCode = ansi837VisitResult.InsuranceTypeCode;

                            bhtCount++;
                            objSubPatDetail.P004_NM1L2010BA.P001_EntityIdentifierCode = ediReceiverResult.SubscriberEntityIdentifierCodeCode;
                            objSubPatDetail.P004_NM1L2010BA.P002_EntityTypeQualifier = ediReceiverResult.PatientEntityTypeQualifierCode;
                            objSubPatDetail.P004_NM1L2010BA.P003_NameLastOrOrganizationName = ansi837VisitResult.PATIENT_LAST_NAME;
                            objSubPatDetail.P004_NM1L2010BA.P004_NameFirst = ansi837VisitResult.PATIENT_FIRST_NAME;
                            objSubPatDetail.P004_NM1L2010BA.P005_NameMiddle = ansi837VisitResult.PATIENT_MIDDLE_NAME;
                            objSubPatDetail.P004_NM1L2010BA.P008_IdentificationCodeQualifier = Static5010.ReadXml("SubscriberIdentificationCodeQualifier");
                            objSubPatDetail.P004_NM1L2010BA.P009_IdentificationCode = ansi837VisitResult.PolicyNumber;

                            bhtCount++;
                            objSubPatDetail.P005_N3L2010BA.P001_AddressInformation = ansi837VisitResult.PATIENT_STREET_NAME;

                            bhtCount++;
                            objSubPatDetail.P006_N4L2010BA.P001_CityName = ansi837VisitResult.PATIENT_CITY_NAME;
                            objSubPatDetail.P006_N4L2010BA.P002_StateorProvinceCode = ansi837VisitResult.PATIENT_STATE_CODE;
                            objSubPatDetail.P006_N4L2010BA.P003_PostalCode = ansi837VisitResult.PATIENT_CITY_ZIP_CODE.Replace("-0000", string.Empty).Replace("-", string.Empty);
                            objSubPatDetail.P006_N4L2010BA.P004_CountryCode = (string.Compare("USA", ansi837VisitResult.PATIENT_COUNTRY_CODE, true) == 0) ? string.Empty : ansi837VisitResult.PATIENT_COUNTRY_CODE;

                            bhtCount++;
                            objSubPatDetail.P007_DMGL2010BA.P001_DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
                            objSubPatDetail.P007_DMGL2010BA.P002_DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? ansi837VisitResult.DOB.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
                            objSubPatDetail.P007_DMGL2010BA.P003_GenderCode = ansi837VisitResult.Sex;

                            bhtCount++;
                            objSubPatDetail.P010_NM1L2010BB.P001_EntityIdentifierCode = ediReceiverResult.PayerEntityIdentifierCodeCode;
                            objSubPatDetail.P010_NM1L2010BB.P002_EntityTypeQualifier = ediReceiverResult.InsuranceEntityTypeQualifierCode;
                            objSubPatDetail.P010_NM1L2010BB.P003_NameLastOrOrganizationName = ansi837VisitResult.InsuranceName;
                            objSubPatDetail.P010_NM1L2010BB.P008_IdentificationCodeQualifier = Static5010.ReadXml("PayerIdentificationCodeQualifier");
                            objSubPatDetail.P010_NM1L2010BB.P009_IdentificationCode = ansi837VisitResult.PayerID;

                            bhtCount++;
                            objSubPatDetail.P011_N3L2010BB.P001_AddressInformation = ansi837VisitResult.INSURANCE_STREET_NAME;

                            bhtCount++;
                            objSubPatDetail.P012_N4L2010BB.P001_CityName = ansi837VisitResult.INSURANCE_CITY_NAME;
                            objSubPatDetail.P012_N4L2010BB.P002_StateorProvinceCode = ansi837VisitResult.INSURANCE_STATE_CODE;
                            objSubPatDetail.P012_N4L2010BB.P003_PostalCode = ansi837VisitResult.INSURANCE_CITY_ZIP_CODE.Replace("-0000", string.Empty).Replace("-", string.Empty);
                            objSubPatDetail.P012_N4L2010BB.P004_CountryCode = (string.Compare("USA", ansi837VisitResult.INSURANCE_COUNTRY_CODE, true) == 0) ? string.Empty : ansi837VisitResult.INSURANCE_COUNTRY_CODE;

                            bhtCount++;
                            objSubPatDetail.P023_CLML2300.P001_ClaimSubmittersIdentifier = ansi837VisitResult.ChartNumber;
                            objSubPatDetail.P023_CLML2300.P002_MonetaryAmount = claimTotCharge.HasValue ? claimTotCharge.Value.ToString() : "0";
                            objSubPatDetail.P023_CLML2300.P006_FacilityCodeValue = ansi837VisitResult.FacilityTypeCode;
                            objSubPatDetail.P023_CLML2300.P007_FacilityCodeQualifier = Static5010.ReadXml("FacilityCodeQualifier");
                            objSubPatDetail.P023_CLML2300.P008_ClaimFrequencyTypeCode = Static5010.ReadXml("ClaimFrequencyTypeCode");
                            objSubPatDetail.P023_CLML2300.P009_YesNoConditionOrResponseCode = Static5010.ReadXml("YesNoConditionOrResponseCode");
                            objSubPatDetail.P023_CLML2300.P010_ProviderAcceptAssignmentCode = Static5010.ReadXml("ProviderAcceptAssignmentCode");
                            objSubPatDetail.P023_CLML2300.P011_YesNoConditionOrResponseCode1 = Static5010.ReadXml("YesNoConditionOrResponseCode");
                            objSubPatDetail.P023_CLML2300.P012_ReleaseOfInformationCode = Static5010.ReadXml("ReleaseOfInformationCode");

                            if (DateAndTime.GetDateDiff(DateIntervals.DAY, ansi837VisitResult.IllnessIndicatorDate, ansi837VisitResult.DOS) != 0)
                            {
                                bhtCount++;
                                objSubPatDetail.P024_DTP1L2300.P001_DateTimeQualifier = Static5010.ReadXml("IllDateTimeQualifier");
                                objSubPatDetail.P024_DTP1L2300.P002_DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
                                objSubPatDetail.P024_DTP1L2300.P003_DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? ansi837VisitResult.IllnessIndicatorDate.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
                            }

                            if (ansi837VisitResult.PatientHospitalizationID.HasValue)
                            {
                                hospResult = (new List<usp_GetAnsi837Hosp_ClaimProcess_Result>(ctx.usp_GetAnsi837Hosp_ClaimProcess(ansi837VisitResult.PatientHospitalizationID.Value))).FirstOrDefault();

                                if (hospResult != null)
                                {
                                    bhtCount++;
                                    objSubPatDetail.P024_DTP1L2300.P001_DateTimeQualifier = Static5010.ReadXml("AdmitDateTimeQualifier");
                                    objSubPatDetail.P024_DTP1L2300.P002_DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
                                    objSubPatDetail.P024_DTP1L2300.P003_DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? hospResult.AdmittedOn.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");

                                    if (hospResult.DischargedOn.HasValue)
                                    {
                                        bhtCount++;
                                        objSubPatDetail.P024_DTP1L2300.P001_DateTimeQualifier = Static5010.ReadXml("DisgDateTimeQualifier");
                                        objSubPatDetail.P024_DTP1L2300.P002_DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
                                        objSubPatDetail.P024_DTP1L2300.P003_DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? hospResult.DischargedOn.Value.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");
                                    }
                                }
                            }

                            bhtCount++;
                            objSubPatDetail.P028_NM1L2310A.P001_EntityIdentifierCode = Static5010.ReadXml("ReferringProvider");
                            objSubPatDetail.P028_NM1L2310A.P002_EntityTypeQualifier = ediReceiverResult.ProviderEntityTypeQualifierCode;
                            objSubPatDetail.P028_NM1L2310A.P003_NameLastOrOrganizationName = ansi837VisitResult.PROVIDER_LAST_NAME;
                            objSubPatDetail.P028_NM1L2310A.P004_NameFirst = ansi837VisitResult.PROVIDER_FIRST_NAME;
                            objSubPatDetail.P028_NM1L2310A.P005_NameMiddle = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
                            objSubPatDetail.P028_NM1L2310A.P008_IdentificationCodeQualifier = Static5010.ReadXml("ProviderIdentificationCodeQualifier");
                            objSubPatDetail.P028_NM1L2310A.P009_IdentificationCode = ansi837VisitResult.PROVIDER_TAX_NPI;

                            bhtCount++;
                            objSubPatDetail.P030_NM1L2310B.P001_EntityIdentifierCode = Static5010.ReadXml("RenderingProvider");
                            objSubPatDetail.P030_NM1L2310B.P002_EntityTypeQualifier = ediReceiverResult.ProviderEntityTypeQualifierCode;
                            objSubPatDetail.P030_NM1L2310B.P003_NameLastOrOrganizationName = ansi837VisitResult.PROVIDER_LAST_NAME;
                            objSubPatDetail.P030_NM1L2310B.P004_NameFirst = ansi837VisitResult.PROVIDER_FIRST_NAME;
                            objSubPatDetail.P030_NM1L2310B.P005_NameMiddle = ansi837VisitResult.PROVIDER_MIDDLE_NAME;
                            objSubPatDetail.P030_NM1L2310B.P008_IdentificationCodeQualifier = Static5010.ReadXml("ProviderIdentificationCodeQualifier");
                            objSubPatDetail.P030_NM1L2310B.P009_IdentificationCode = ansi837VisitResult.PROVIDER_TAX_NPI;

                            bhtCount++;
                            objSubPatDetail.P033_NM1L2310C.P001_EntityIdentifierCode = Static5010.ReadXml("EntityIdentifierCode");
                            objSubPatDetail.P033_NM1L2310C.P002_EntityTypeQualifier = clinicResult.ClinicEntityTypeQualifierCode;
                            objSubPatDetail.P033_NM1L2310C.P008_IdentificationCodeQualifier = Static5010.ReadXml("ProviderIdentificationCodeQualifier");
                            if (ansi837VisitResult.FacilityTypeID == Convert.ToByte(FacilityType.OFFICE))
                            {
                                objSubPatDetail.P033_NM1L2310C.P003_NameLastOrOrganizationName = clinicResult.ClinicName;
                                objSubPatDetail.P033_NM1L2310C.P009_IdentificationCode = string.IsNullOrWhiteSpace(clinicResult.CLINIC_NPI) ? clinicResult.CLINIC_TAX_ID : clinicResult.CLINIC_NPI;
                            }
                            else
                            {
                                objSubPatDetail.P033_NM1L2310C.P003_NameLastOrOrganizationName = facilitiyDoneResult.FacilityDoneName;
                                objSubPatDetail.P033_NM1L2310C.P009_IdentificationCode = string.IsNullOrWhiteSpace(facilitiyDoneResult.NPI) ? facilitiyDoneResult.TaxID : facilitiyDoneResult.NPI;
                            }

                            if (ansi837VisitResult.FacilityTypeID == Convert.ToByte(FacilityType.OFFICE))
                            {
                                bhtCount++;
                                objSubPatDetail.P034_N3L2310C.P001_AddressInformation = clinicResult.ClinicStreetName;

                                bhtCount++;
                                objSubPatDetail.P035_N4L2310C.P001_CityName = clinicResult.ClinicCityName;
                                objSubPatDetail.P035_N4L2310C.P002_StateorProvinceCode = clinicResult.ClinicStateCode;
                                objSubPatDetail.P035_N4L2310C.P003_PostalCode = clinicResult.ClinicZipCode.Replace("-0000", string.Empty).Replace("-", string.Empty);
                                objSubPatDetail.P035_N4L2310C.P004_CountryCode = (string.Compare("USA", clinicResult.ClinicCountryCode, true) == 0) ? string.Empty : clinicResult.ClinicCountryCode;
                            }
                            else
                            {
                                bhtCount++;
                                objSubPatDetail.P034_N3L2310C.P001_AddressInformation = facilitiyDoneResult.StreetName;

                                bhtCount++;
                                objSubPatDetail.P035_N4L2310C.P001_CityName = facilitiyDoneResult.CityName;
                                objSubPatDetail.P035_N4L2310C.P002_StateorProvinceCode = facilitiyDoneResult.StateCode;
                                objSubPatDetail.P035_N4L2310C.P003_PostalCode = facilitiyDoneResult.ZipCode.Replace("-0000", string.Empty).Replace("-", string.Empty);
                                objSubPatDetail.P035_N4L2310C.P004_CountryCode = (string.Compare("USA", facilitiyDoneResult.CountryCode, true) == 0) ? string.Empty : facilitiyDoneResult.CountryCode;
                            }

                            # region Dx CPT Modifiers

                            claimCPTResults = new List<usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result>(from o in visitCPTResults where (o.CLAIM_NUMBER == claimNo) select o);

                            claimDxCount = 0;
                            claimCptCount = 0;
                            prevDxCode = string.Empty;

                            for (int i = 0; i < claimCPTResults.Count; i++)
                            {
                                if (string.Compare(prevDxCode, claimCPTResults[i].DX_CODE, true) == 0)
                                {
                                    // CPT

                                    if (!(string.IsNullOrWhiteSpace(claimCPTResults[i].CPT_CODE)))
                                    {
                                        claimCptCount++;

                                        CptService objCptService = new CptService(ansi837VisitResult.ChartNumber);

                                        bhtCount++;
                                        objCptService.P001_LXL2400.P001_AssignedNumber = claimCptCount.ToString();

                                        bhtCount++;
                                        objCptService.P002_SV1L2400.P002_ProductServiceIDQualifier = Static5010.ReadXml("ServiceIDQualifier");
                                        objCptService.P002_SV1L2400.P003_ProductServiceID = claimCPTResults[i].CPT_CODE;
                                        objCptService.P002_SV1L2400.P004_ProcedureModifier = claimCPTResults[i].MODI1_CODE;
                                        objCptService.P002_SV1L2400.P005_ProcedureModifier1 = claimCPTResults[i].MODI2_CODE;
                                        objCptService.P002_SV1L2400.P006_ProcedureModifier2 = claimCPTResults[i].MODI3_CODE;
                                        objCptService.P002_SV1L2400.P007_ProcedureModifier3 = claimCPTResults[i].MODI4_CODE;
                                        objCptService.P002_SV1L2400.P010_MonetaryAmount = (claimCPTResults[i].UNIT * claimCPTResults[i].CHARGE_PER_UNIT).ToString();
                                        objCptService.P002_SV1L2400.P011_UnitOrBasisforMeasurementCode = Static5010.ReadXml("UnitOrBasisForMeasurementCode");
                                        objCptService.P002_SV1L2400.P012_Quantity = claimCPTResults[i].UNIT.ToString();
                                        objCptService.P002_SV1L2400.P013_FacilityCodeValue = claimCPTResults[i].FACILITY_TYPE_CODE;
                                        objCptService.P002_SV1L2400.P016_DiagnosisCodePointer = claimDxCount.ToString();

                                        bhtCount++;
                                        objCptService.P003_DTPL2400.P001_DateTimeQualifier = Static5010.ReadXml("VisitDateTimeQualifier");
                                        objCptService.P003_DTPL2400.P002_DateTimePeriodFormatQualifier = string.Concat("D", Static5010.ReadXml("FunctionalGroupDateFormat").Length);
                                        objCptService.P003_DTPL2400.P003_DateTimePeriod = string.Compare(Static5010.ReadXml("FunctionalGroupDateFormat"), "CCYYMMDD", false) == 0 ? ansi837VisitResult.DOS.ToString("yyyyMMdd") : Static5010.ReadXml("FunctionalGroupDateFormat");

                                        bhtCount++;
                                        objCptService.P005_REFL2400.P001_ReferenceIdentificationQualifier = Static5010.ReadXml("CptReferenceIdentificationQualifier");
                                        objCptService.P005_REFL2400.P002_ReferenceIdentification = string.Concat(interCtrlNo, gsCount, stCount, stCount, bhtCount);

                                        objSubPatDetail.P038_CptServices.Add(objCptService);
                                    }
                                }
                                else
                                {
                                    // Dx

                                    if (claimDxCount == 0)
                                    {
                                        // Primary Dx

                                        bhtCount++;
                                        objSubPatDetail.P027_HIL2300.P002_CodeListQualifierCode = (claimCPTResults[i].ICD_FORMAT == 10) ? Static5010.ReadXml("CodeListQualifierCode10Pri") : Static5010.ReadXml("CodeListQualifierCodePri");
                                        objSubPatDetail.P027_HIL2300.P003_IndustryCode = claimCPTResults[i].DX_CODE.Replace(".", string.Empty);
                                    }
                                    else
                                    {
                                        // Other Dx
                                        //bhtCount++;       Not valid for other than primary dx

                                        if (claimDxCount >= ediReceiverResult.MaxDiagnosis)
                                        {
                                            throw new Exception("Sorry! Dx Count should not be greater than MaxDiagnosis. Please check the Claim Number allocation");
                                        }

                                        objSubPatDetail.P027_HIL2300.GetType().GetProperty(string.Concat(((claimDxCount < 10) ? "P0" : "P"), claimDxCount, "2_CodeListQualifierCode", claimDxCount)).SetValue(objSubPatDetail.P027_HIL2300, ((claimCPTResults[i].ICD_FORMAT == 10) ? Static5010.ReadXml("CodeListQualifierCode10") : Static5010.ReadXml("CodeListQualifierCode")));
                                        objSubPatDetail.P027_HIL2300.GetType().GetProperty(string.Concat(((claimDxCount < 10) ? "P0" : "P"), claimDxCount, "3_IndustryCode", claimDxCount)).SetValue(objSubPatDetail.P027_HIL2300, claimCPTResults[i].DX_CODE.Replace(".", string.Empty));
                                    }

                                    prevDxCode = claimCPTResults[i].DX_CODE;
                                    claimDxCount++;
                                    i--;
                                }
                            }

                            # endregion

                            objGSDetail.P016_SubPatDetails.Add(objSubPatDetail);
                        }

                        # region Update Visit Status

                        ansi837VisitResult.AssignedTo = pUserID;
                        ansi837VisitResult.TargetEAUserID = pUserID;
                        StringBuilder sb = new StringBuilder();

                        if ((ansi837VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE)) || (ansi837VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK)))
                        {

                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForEAPerQ);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForEdiCreated);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.SENT_CLAIM));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForSentClaim);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");
                            //_StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.SENT_CLAIM));
                        }
                        else
                        {
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForEdiCreated);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.SENT_CLAIM));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForSentClaim);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            //_StatusIds = Convert.ToString(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED)) + ", " + Convert.ToString(Convert.ToByte(ClaimStatus.SENT_CLAIM));
                        }

                        objParam = ObjParam("PatientVisitID", typeof(System.Int64), ansi837VisitResult.PatientVisitID);

                        ctx.usp_Update_PatientVisit(ansi837VisitResult.PatientID, ansi837VisitResult.DOS
                        , ansi837VisitResult.IllnessIndicatorID, ansi837VisitResult.IllnessIndicatorDate, ansi837VisitResult.FacilityTypeID
                        , ansi837VisitResult.FacilityDoneID, ansi837VisitResult.PrimaryClaimDiagnosisID, ansi837VisitResult.DoctorNoteRelPath
                        , ansi837VisitResult.SuperBillRelPath, ansi837VisitResult.PatientVisitDesc, sb.ToString()
                        , ansi837VisitResult.AssignedTo, ansi837VisitResult.TargetBAUserID, ansi837VisitResult.TargetQAUserID
                        , ansi837VisitResult.TargetEAUserID, ansi837VisitResult.PatientVisitComplexity
                        , ansi837VisitResult.IsActive, ansi837VisitResult.LastModifiedBy, ansi837VisitResult.LastModifiedOn, pUserID, objParam);

                        if (HasErr(objParam, ctx))
                        {
                            throw new Exception(this.ErrorMsg);
                        }

                        claimProcessIDs.Add((new List<long?>(ctx.usp_GetMaxID_ClaimProcess(ansi837VisitResult.PatientVisitID, Convert.ToByte(ClaimStatus.EDI_FILE_CREATED))).First()).Value);

                        # endregion
                    }

                    if (objGSDetail != null)
                    {
                        # region Footer Sub

                        bhtCount++;
                        objGSDetail.P017_SE.P001_NumberOfIncludedSegments = bhtCount.ToString();
                        objGSDetail.P017_SE.P002_TransactionSetControlNumber = string.Concat(interCtrlNo, gsCount, stCount);

                        objGSDetail.P018_GE.P001_NumberofTransactionSetsIncluded = stCount.ToString();
                        objGSDetail.P018_GE.P002_GroupControlNumber = string.Concat(interCtrlNo, gsCount);

                        # endregion

                        objANSI5010Main.P002_GSDetails.Add(objGSDetail);
                    }

                    # endregion

                    # region Footer

                    objANSI5010Main.P003_IEA.P001_NumberofIncludedFunctionalGroups = gsCount.ToString();
                    objANSI5010Main.P003_IEA.P002_InterchangeControlNumber = interCtrlNoStr;

                    # endregion

                    # endregion

                    # region Save Files

                    FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\P_", ediFileID);
                    if (!(Directory.Exists(FileSvrEDIX12FilePath)))
                    {
                        DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIX12FilePath);
                        dirInfo = null;
                    }
                    FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "X12_", clinicResult.ClinicCode, "_", ediReceiverResult.EDIReceiverCode.Replace(" ", string.Empty).ToUpper(), "_", interCtrlNo, ".edi");

                    FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\P_", ediFileID);
                    if (!(Directory.Exists(FileSvrEDIRefFilePath)))
                    {
                        DirectoryInfo dirInfo = Directory.CreateDirectory(FileSvrEDIRefFilePath);
                        dirInfo = null;
                    }
                    FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "REF_", clinicResult.ClinicCode, "_", ediReceiverResult.EDIReceiverCode.Replace(" ", string.Empty).ToUpper(), "_", interCtrlNo, ".txt");

                    _EDIX12FileRelPath = FileSvrEDIX12FilePath.Replace(FileSvrRootPath, string.Empty);
                    _EDIRefFileRelPath = FileSvrEDIRefFilePath.Replace(FileSvrRootPath, string.Empty);

                    _EDIX12FileRelPath = _EDIX12FileRelPath.Substring(1);
                    _EDIRefFileRelPath = _EDIRefFileRelPath.Substring(1);

                    //http://social.msdn.microsoft.com/Forums/en-US/csharpgeneral/thread/7f42a0cb-2113-4749-bfd9-8e5228345c68

                    ansi5010Loops = Base5010.GetANSI5010Loops(objANSI5010Main);

                    if (File.Exists(FileSvrEDIX12FilePath))
                    {
                        File.Delete(FileSvrEDIX12FilePath);
                    }

                    if (File.Exists(FileSvrEDIRefFilePath))
                    {
                        File.Delete(FileSvrEDIRefFilePath);
                    }

                    string prevChart = string.Empty;
                    bool isRef = false;

                    foreach (var ansi5010Loop in ansi5010Loops)
                    {
                        using (TextWriter tw = new StreamWriter(FileSvrEDIX12FilePath, true, Encoding.GetEncoding(1252)))
                        {
                            tw.Write(ansi5010Loop.LoopValue);
                            tw.Write("~");
                        }

                        using (TextWriter tw = new StreamWriter(FileSvrEDIRefFilePath, true, Encoding.GetEncoding(1252)))
                        {
                            if (string.Compare(prevChart, ansi5010Loop.LoopChart, true) != 0)
                            {
                                prevChart = ansi5010Loop.LoopChart;

                                if (isRef)
                                {
                                    tw.WriteLine(string.Empty);
                                }
                                else
                                {
                                    isRef = true;
                                }
                            }

                            tw.WriteLine(string.Concat(ansi5010Loop.LoopName, ansi5010Loop.LoopChart, ansi5010Loop.LoopValue));
                        }
                    }

                    # endregion

                    #region Update EDI Receiver(Last Interchange Control No - interCtrlNo)

                    objParam = ObjParam("EDIReceiverID", typeof(System.Int32), ediReceiverResult.EDIReceiverID);

                    ctx.usp_Update_EDIReceiver(ediReceiverResult.EDIReceiverCode, ediReceiverResult.EDIReceiverName, ediReceiverResult.AuthorizationInformationQualifierID
                    , ediReceiverResult.AuthorizationInformation, ediReceiverResult.SecurityInformationQualifierID, ediReceiverResult.SecurityInformation
                    , ediReceiverResult.SecurityInformationQualifierUserName, ediReceiverResult.SecurityInformationQualifierPassword, interCtrlNo
                    , ediReceiverResult.SenderInterchangeIDQualifierID, ediReceiverResult.SenderInterchangeID, ediReceiverResult.ReceiverInterchangeIDQualifierID
                    , ediReceiverResult.ReceiverInterchangeID, ediReceiverResult.TransactionSetPurposeCodeID, ediReceiverResult.TransactionTypeCodeID, ediReceiverResult.IsGroupPractice
                    , ediReceiverResult.ClaimMediaID, ediReceiverResult.ApplicationSenderCode, ediReceiverResult.ApplicationReceiverCode, ediReceiverResult.InterchangeUsageIndicatorID
                    , ediReceiverResult.FunctionalIdentifierCode, ediReceiverResult.SubmitterEntityIdentifierCodeID, ediReceiverResult.ReceiverEntityIdentifierCodeID
                    , ediReceiverResult.BillingProviderEntityIdentifierCodeID, ediReceiverResult.SubscriberEntityIdentifierCodeID, ediReceiverResult.PayerEntityIdentifierCodeID
                    , ediReceiverResult.EntityTypeQualifierID, ediReceiverResult.CurrencyCodeID, ediReceiverResult.PayerResponsibilitySequenceNumberCodeID
                    , ediReceiverResult.EmailCommunicationNumberQualifierID, ediReceiverResult.FaxCommunicationNumberQualifierID, ediReceiverResult.PhoneCommunicationNumberQualifierID
                    , ediReceiverResult.PatientEntityTypeQualifierID, ediReceiverResult.ProviderEntityTypeQualifierID, ediReceiverResult.InsuranceEntityTypeQualifierID
                    , ediReceiverResult.Comment, ediReceiverResult.IsActive, ediReceiverResult.LastModifiedBy, ediReceiverResult.LastModifiedOn, pUserID, objParam);

                    if (HasErr(objParam, ctx))
                    {
                        throw new Exception(this.ErrorMsg);
                    }

                    #endregion

                    # region Save EDIFile

                    objParam = ObjParam("EDIFile");

                    ctx.usp_Insert_EDIFile(EDIReceiverID, _EDIX12FileRelPath, _EDIRefFileRelPath, null, pUserID, objParam);

                    if (HasErr(objParam, ctx))
                    {
                        throw new Exception(this.ErrorMsg);
                    }

                    # endregion

                    # region Save ClaimProcessEDIFile

                    objParam = ObjParam("ClaimProcessEDIFile");

                    foreach (long claimProcessID in claimProcessIDs)
                    {
                        ctx.usp_Insert_ClaimProcessEDIFile(claimProcessID, ediFileID, null, pUserID, objParam);

                        if (HasErr(objParam, ctx))
                        {
                            throw new Exception(this.ErrorMsg);
                        }
                    }

                    # endregion

                    CommitDbTrans(ctx);
                }
                catch (Exception ex)
                {
                    RollbackDbTrans(ctx);
                    throw ex;
                }
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        # endregion
    }

    # endregion

    # region EDI Success Model

    /// <summary>
    /// 
    /// </summary>
    public class EDICreateSuccessModel : BaseModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public string X12 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<string> Refs { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public EDICreateSuccessModel()
        {
        }

        # endregion

        #region Abstract Methods


        #endregion
    }

    #endregion

    # endregion
}
