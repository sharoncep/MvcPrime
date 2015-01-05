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
    public class ProviderResult
    {
        #region Primitive Properties
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLINIC_NAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PROVIDER_CODE { get; private set; }
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
        public string CREDENTIAL { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SEX { get; private set; }
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
        public string SSN { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_TAX_ID_PRIMARY_OPTION { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SPECIALTY_NAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PHOTO_REL_PATH { get; private set; }
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
        public string LICENSE_NUMBER { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLIA_NUMBER { get; private set; }
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
        public bool IS_ACTIVE { get; private set; }

        #endregion


        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator ProviderResult(ClaimProviderModel pResult)
        {

            return (new ProviderResult()
            {
                CLINIC_NAME = pResult.ClinicName
                ,
                LAST_NAME = pResult.Provider_Result.LastName
                ,
                MIDDLE_NAME = string.IsNullOrWhiteSpace(pResult.Provider_Result.MiddleName) ? string.Empty : (pResult.Provider_Result.MiddleName)
                ,
                FIRST_NAME = pResult.Provider_Result.FirstName
                ,
                CREDENTIAL = pResult.CredentialName
                ,
                NPI = string.IsNullOrWhiteSpace(pResult.Provider_Result.NPI) ? string.Empty : (pResult.Provider_Result.NPI)
                ,
                TAX_ID = string.IsNullOrWhiteSpace(pResult.Provider_Result.TaxID) ? string.Empty : (pResult.Provider_Result.TaxID)
                ,
                SSN = string.IsNullOrWhiteSpace(pResult.Provider_Result.SSN) ? string.Empty : (pResult.Provider_Result.SSN)
                ,
                IS_TAX_ID_PRIMARY_OPTION = pResult.Provider_Result.IsTaxIDPrimaryOption
                ,
                SPECIALTY_NAME = pResult.ProviderName
                ,
                PHOTO_REL_PATH = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveProviderPhoto"))
                ,
                IS_SIGNED_FILE = pResult.Provider_Result.IsSignedFile
                ,
                SIGNED_DATE = pResult.Provider_Result.SignedDate.HasValue ? StaticClass.GetDateStr(pResult.Provider_Result.SignedDate) : string.Empty
                ,
                LICENSE_NUMBER = string.IsNullOrWhiteSpace(pResult.Provider_Result.LicenseNumber) ? string.Empty : (pResult.Provider_Result.LicenseNumber)
                ,
                CLIA_NUMBER = string.IsNullOrWhiteSpace(pResult.Provider_Result.CLIANumber) ? string.Empty : (pResult.Provider_Result.CLIANumber)
                ,
                STREET_NAME = pResult.Provider_Result.StreetName
                ,
                SUITE = string.IsNullOrWhiteSpace(pResult.Provider_Result.Suite) ? string.Empty : (pResult.Provider_Result.Suite)
                ,
                CITY = pResult.CityName
                ,
                STATE = pResult.StateName
                ,
                COUNTY = string.IsNullOrWhiteSpace(pResult.CountyName) ? string.Empty : (pResult.CountyName)
                ,
                COUNTRY = pResult.CountryName
                ,
                PHONE_NUMBER = pResult.Provider_Result.PhoneNumber
                ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.Provider_Result.SecondaryPhoneNumber) ? string.Empty : (pResult.Provider_Result.SecondaryPhoneNumber)
                ,
                EMAIL = pResult.Provider_Result.Email
                ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.Provider_Result.SecondaryEmail) ? string.Empty : (pResult.Provider_Result.SecondaryEmail)
                ,
                FAX = string.IsNullOrWhiteSpace(pResult.Provider_Result.Fax) ? string.Empty : (pResult.Provider_Result.Fax)
                ,
                IS_ACTIVE = pResult.Provider_Result.IsActive

            });
        }

        # endregion
    }
}
