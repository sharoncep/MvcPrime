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
    public class IpaResult
    {
        #region Primitive Properties
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IPA_CODE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IPA_NAME { get; private set; }
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
        public string ENTITY_NAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string LOGO_SRC { get; private set; }
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
        public string CITY { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string STATE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COUNTY { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COUNTRY { get; private set; }
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
        public bool IS_ACTIVE { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator IpaResult(BillingIPAModel pResult)
        {

            return (new IpaResult()
            {
                IPA_CODE = pResult.IPA_Result.IPACode
                ,
                IPA_NAME = pResult.IPA_Result.IPAName
                ,
                NPI = pResult.IPA_Result.NPI
                ,
                TAX_ID = pResult.IPA_Result.TaxID
                ,
                ENTITY_NAME = pResult.EntityName
                ,
                LOGO_SRC = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveIPALogo"))
                ,
                STREET_NAME = pResult.IPA_Result.StreetName
                ,
                SUITE = string.IsNullOrWhiteSpace(pResult.IPA_Result.Suite) ? string.Empty : (pResult.IPA_Result.Suite)
                ,
                CITY = pResult.CityName
                ,
                STATE=pResult.StateName
                ,
                COUNTY = string.IsNullOrWhiteSpace(pResult.CountyName) ? string.Empty : (pResult.CountyName)
                ,
                COUNTRY=pResult.CountryName
                ,
                PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.IPA_Result.PhoneNumber) ? string.Empty : (pResult.IPA_Result.PhoneNumber)
                ,
                PHONE_NUMBER_EXTN = pResult.IPA_Result.PhoneNumberExtn.HasValue ? pResult.IPA_Result.PhoneNumberExtn.Value.ToString() : string.Empty
                ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.IPA_Result.SecondaryPhoneNumber) ? string.Empty : (pResult.IPA_Result.SecondaryPhoneNumber)
                ,
                SECONDARY_PHONE_NUMBER_EXTN = pResult.IPA_Result.SecondaryPhoneNumberExtn.HasValue ? pResult.IPA_Result.SecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                ,
                EMAIL = pResult.IPA_Result.Email
                ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.IPA_Result.SecondaryEmail) ? string.Empty : (pResult.IPA_Result.SecondaryEmail)
                ,
                FAX = string.IsNullOrWhiteSpace(pResult.IPA_Result.Fax) ? string.Empty : (pResult.IPA_Result.Fax)
                ,
                CONTACT_PERSON_LAST_NAME = pResult.IPA_Result.ContactPersonLastName
                ,
                CONTACT_PERSON_MIDDLE_NAME = string.IsNullOrWhiteSpace(pResult.IPA_Result.ContactPersonMiddleName) ? string.Empty : (pResult.IPA_Result.ContactPersonMiddleName)
                ,
                CONTACT_PERSON_FIRST_NAME = pResult.IPA_Result.ContactPersonFirstName
                ,
                CONTACT_PERSON_PHONE_NUMBER = pResult.IPA_Result.ContactPersonPhoneNumber
                ,
                CONTACT_PERSON_PHONE_NUMBER_EXTN = pResult.IPA_Result.ContactPersonPhoneNumberExtn.HasValue ? pResult.IPA_Result.ContactPersonPhoneNumberExtn.Value.ToString() : string.Empty
                ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.IPA_Result.ContactPersonMiddleName) ? string.Empty : (pResult.IPA_Result.ContactPersonSecondaryPhoneNumber)
                ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER_EXTN = pResult.IPA_Result.ContactPersonSecondaryPhoneNumberExtn.HasValue ? pResult.IPA_Result.ContactPersonSecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                ,
                CONTACT_PERSON_EMAIL = pResult.IPA_Result.ContactPersonEmail
                ,
                CONTACT_PERSON_SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.IPA_Result.ContactPersonMiddleName) ? string.Empty : (pResult.IPA_Result.ContactPersonSecondaryEmail)
                ,
                CONTACT_PERSON_FAX = string.IsNullOrWhiteSpace(pResult.IPA_Result.ContactPersonMiddleName) ? string.Empty : (pResult.IPA_Result.ContactPersonFax)
                ,
                IS_ACTIVE = pResult.IPA_Result.IsActive

            });
        }

        # endregion
    }
}
