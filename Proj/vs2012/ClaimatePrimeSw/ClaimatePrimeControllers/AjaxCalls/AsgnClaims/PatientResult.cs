using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeConstants;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class PatientResult
    {
        #region Primitive Properties


        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ANTI_FORG_TOKN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int CLINIC_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CHART_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MEDICARE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string LAST_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MIDDLE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string FIRST_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SEX { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DOB { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SSN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int PROVIDER_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String PROVIDER_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int INSURANCE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String INSURANCE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string POLICY_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string GROUP_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string POLICY_HOLDER_CHART_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte RELATIONSHIP_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String RELATIONSHIP_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_INSURANCE_BENEFIT_ACCEPTED { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_CAPITATED { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_EFFECT_FROM { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_EFFECT_TO { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_SRC { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_SIGNED_FILE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SIGNED_DATE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string STREET_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SUITE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int CITY_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String CITY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int STATE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String STATE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> COUNTY_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String COUNTY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int COUNTRY_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String COUNTRY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECONDARY_PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string EMAIL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECONDARY_EMAIL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string FAX { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COMMENT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_ACTIVE { get; set; }

        #endregion

        # region Constructors

        # endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator PatientResult(PatientDemographySaveModel pResult)
        {
            return (new PatientResult()
            {
                ANTI_FORG_TOKN = pResult.AntiForgTokn
                ,
                PATIENT_ID = pResult.PatientResult.PatientID
                ,
                CLINIC_ID = pResult.PatientResult.ClinicID
                ,
                CHART_NUMBER = pResult.PatientResult.ChartNumber
                ,
                MEDICARE_ID = string.IsNullOrWhiteSpace(pResult.PatientResult.MedicareID) ? string.Empty : (pResult.PatientResult.MedicareID)
                ,
                LAST_NAME = pResult.PatientResult.LastName
                ,
                MIDDLE_NAME = string.IsNullOrWhiteSpace(pResult.PatientResult.MiddleName) ? string.Empty : (pResult.PatientResult.MiddleName)
                ,
                FIRST_NAME = pResult.PatientResult.FirstName
                ,
                SEX = pResult.PatientResult.Sex
                ,
                DOB = StaticClass.GetDateStr(pResult.PatientResult.DOB)
                ,
                SSN = string.IsNullOrWhiteSpace(pResult.PatientResult.SSN) ? string.Empty : (pResult.PatientResult.SSN)
                ,
                PROVIDER_ID = pResult.PatientResult.ProviderID
                ,
                PROVIDER_NAME = pResult.PatientResult_Provider
                ,
                INSURANCE_ID = pResult.PatientResult.InsuranceID
                ,
                INSURANCE_NAME = pResult.PatientResult_Insurance
                ,
                POLICY_NUMBER = pResult.PatientResult.PolicyNumber
                ,
                GROUP_NUMBER = string.IsNullOrWhiteSpace(pResult.PatientResult.GroupNumber) ? string.Empty : (pResult.PatientResult.GroupNumber)
                ,
                POLICY_HOLDER_CHART_NUMBER = pResult.PatientResult.PolicyHolderChartNumber
                ,
                RELATIONSHIP_ID = pResult.PatientResult.RelationshipID
                ,
                RELATIONSHIP_NAME = pResult.PatientResult_Relationship
                ,
                INSURANCE_EFFECT_FROM = StaticClass.GetDateStr(pResult.PatientResult.InsuranceEffectFrom)
                ,
                INSURANCE_EFFECT_TO = pResult.PatientResult.InsuranceEffectTo.HasValue ? StaticClass.GetDateStr(pResult.PatientResult.InsuranceEffectTo) : string.Empty
                ,
                IMG_SRC = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SavePatPhoto"))
                ,
                SIGNED_DATE = pResult.PatientResult.SignedDate.HasValue ? StaticClass.GetDateStr(pResult.PatientResult.SignedDate) : string.Empty
                ,
                STREET_NAME = pResult.PatientResult.StreetName
                ,
                SUITE = string.IsNullOrWhiteSpace(pResult.PatientResult.Suite) ? string.Empty : (pResult.PatientResult.Suite)
                ,
                CITY_ID = pResult.PatientResult.CityID
                ,
                CITY_NAME = pResult.PatientResult_City
                ,
                STATE_ID = pResult.PatientResult.StateID
                ,
                STATE_NAME = pResult.PatientResult_State
                ,
                COUNTY_ID = pResult.PatientResult.CountyID
                ,
                COUNTY_NAME = string.IsNullOrWhiteSpace(pResult.PatientResult_County) ? string.Empty : (pResult.PatientResult_County)
                ,
                COUNTRY_ID = pResult.PatientResult.CountryID
                ,
                COUNTRY_NAME = pResult.PatientResult_Country
                ,
                PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.PatientResult.PhoneNumber) ? string.Empty : (pResult.PatientResult.PhoneNumber)
                ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.PatientResult.SecondaryPhoneNumber) ? string.Empty : (pResult.PatientResult.SecondaryPhoneNumber)
                ,
                EMAIL = string.IsNullOrWhiteSpace(pResult.PatientResult.Email) ? string.Empty : (pResult.PatientResult.Email)
                ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.PatientResult.SecondaryEmail) ? string.Empty : (pResult.PatientResult.SecondaryEmail)
                ,
                FAX = string.IsNullOrWhiteSpace(pResult.PatientResult.Fax) ? string.Empty : (pResult.PatientResult.Fax)
                ,
                COMMENT = string.IsNullOrWhiteSpace(pResult.PatientResult.Comment) ? string.Empty : (pResult.PatientResult.Comment)
                ,
                IS_ACTIVE = pResult.PatientResult.IsActive
                ,
                IS_CAPITATED = pResult.PatientResult.IsCapitated
                ,
                IS_INSURANCE_BENEFIT_ACCEPTED = pResult.PatientResult.IsInsuranceBenefitAccepted
                ,
                IS_SIGNED_FILE = pResult.PatientResult.IsSignedFile

            });
        }

        # endregion
    }
}
