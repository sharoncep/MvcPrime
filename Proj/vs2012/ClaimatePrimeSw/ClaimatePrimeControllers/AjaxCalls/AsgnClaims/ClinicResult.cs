using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
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
    public class ClinicResult
    {
        #region Primitive Properties


        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int CLINIC_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IPA_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLINIC_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLINIC_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string NPI { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TAX_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ENTITY_TYPE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SPECIALTY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte ICD_FORMAT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MANAGER_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string LOGO_REL_PATH { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_PATIENT_DEMOGRAPHICS_PULL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_PAT_VISIT_DOC_MANADATORY { get; private set; }

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
        public string CITY_NAME { get; private set; }

        /// Get
        /// </summary>
        [DataMember]
        public string STATE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COUNTY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COUNTRY_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PHONE_NUMBER_EXTN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECONDARY_PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECONDARY_PHONE_NUMBER_EXTN { get; private set; }

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
        public string CONTACT_PERSON_LAST_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_MIDDLE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_FIRST_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_PHONE_NUMBER_EXTN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_SECONDARY_PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_SECONDARY_PHONE_NUMBER_EXTN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_EMAIL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_SECONDARY_EMAIL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CONTACT_PERSON_FAX { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte PATIENT_VISIT_COMPLEXITY { get; private set; }

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
        public static explicit operator ClinicResult(BillingClinicViewModel pResult)
        {
            return (new ClinicResult()
            {
                CLINIC_ID = pResult.ClinicResult.ClinicID
                 ,
                IPA_NAME = pResult.IpaName
                 ,
                CLINIC_CODE = pResult.ClinicResult.ClinicCode
                 ,
                CLINIC_NAME = pResult.ClinicResult.ClinicName
                 ,
                NPI = pResult.ClinicResult.NPI
                 ,
                TAX_ID = string.IsNullOrWhiteSpace(pResult.ClinicResult.TaxID) ? string.Empty : (pResult.ClinicResult.TaxID)
                 ,
                ENTITY_TYPE_NAME = string.IsNullOrWhiteSpace(pResult.EntityTypeQualifierName) ? string.Empty : (pResult.EntityTypeQualifierName)
                 ,
                SPECIALTY_NAME = pResult.SpecialtyName
                 ,
                ICD_FORMAT = pResult.ClinicResult.ICDFormat
                 ,
                MANAGER_NAME = pResult.ManagerName
                 ,
                LOGO_REL_PATH = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveClinicLogo"))
                 ,
                IS_PATIENT_DEMOGRAPHICS_PULL = pResult.ClinicResult.IsPatientDemographicsPull
                 ,
                IS_PAT_VISIT_DOC_MANADATORY = pResult.ClinicResult.IsPatVisitDocManadatory
                 ,
                STREET_NAME = pResult.ClinicResult.StreetName
                 ,
                SUITE = string.IsNullOrWhiteSpace(pResult.ClinicResult.Suite) ? string.Empty : (pResult.ClinicResult.Suite)
                 ,
                CITY_NAME = pResult.CityName
                 ,
                STATE_NAME = pResult.StateName
                 ,
                COUNTY_NAME = string.IsNullOrWhiteSpace(pResult.CountyName) ? string.Empty : (pResult.CountyName)
                 ,
                COUNTRY_NAME = pResult.CountryName
                 ,
                PHONE_NUMBER = pResult.ClinicResult.PhoneNumber
                 ,
                PHONE_NUMBER_EXTN = pResult.ClinicResult.PhoneNumberExtn.HasValue ? pResult.ClinicResult.PhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.ClinicResult.SecondaryPhoneNumber) ? string.Empty : (pResult.ClinicResult.SecondaryPhoneNumber)
                 ,
                SECONDARY_PHONE_NUMBER_EXTN = pResult.ClinicResult.SecondaryPhoneNumberExtn.HasValue ? pResult.ClinicResult.SecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                EMAIL = pResult.ClinicResult.Email
                 ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.ClinicResult.SecondaryEmail) ? string.Empty : (pResult.ClinicResult.SecondaryEmail)
                 ,
                FAX = string.IsNullOrWhiteSpace(pResult.ClinicResult.Fax) ? string.Empty : (pResult.ClinicResult.Fax)
                 ,
                CONTACT_PERSON_LAST_NAME = pResult.ClinicResult.ContactPersonLastName
                 ,
                CONTACT_PERSON_MIDDLE_NAME = string.IsNullOrWhiteSpace(pResult.ClinicResult.ContactPersonMiddleName) ? string.Empty : (pResult.ClinicResult.ContactPersonMiddleName)
                 ,
                CONTACT_PERSON_FIRST_NAME = pResult.ClinicResult.ContactPersonFirstName
                 ,
                CONTACT_PERSON_PHONE_NUMBER = pResult.ClinicResult.ContactPersonPhoneNumber
                 ,
                CONTACT_PERSON_PHONE_NUMBER_EXTN = pResult.ClinicResult.ContactPersonPhoneNumberExtn.HasValue ? pResult.ClinicResult.ContactPersonPhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.ClinicResult.ContactPersonSecondaryPhoneNumber) ? string.Empty : (pResult.ClinicResult.ContactPersonSecondaryPhoneNumber)
                 ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER_EXTN = pResult.ClinicResult.ContactPersonSecondaryPhoneNumberExtn.HasValue ? pResult.ClinicResult.ContactPersonSecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                CONTACT_PERSON_EMAIL = string.IsNullOrWhiteSpace(pResult.ClinicResult.ContactPersonEmail) ? string.Empty : (pResult.ClinicResult.ContactPersonEmail)
                 ,
                CONTACT_PERSON_SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.ClinicResult.ContactPersonSecondaryEmail) ? string.Empty : (pResult.ClinicResult.ContactPersonSecondaryEmail)
                 ,
                CONTACT_PERSON_FAX = string.IsNullOrWhiteSpace(pResult.ClinicResult.ContactPersonFax) ? string.Empty : (pResult.ClinicResult.ContactPersonFax)
                 ,
                PATIENT_VISIT_COMPLEXITY = pResult.ClinicResult.PatientVisitComplexity
                ,
                IS_ACTIVE = pResult.ClinicResult.IsActive

            });
        }

        # endregion
    }
}
