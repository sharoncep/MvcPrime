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
    public class FacilityDoneResult
    {
        #region Primitive Properties


        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int FACILITY_DONE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string FACILITY_DONE_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string FACILITY_DONE_NAME { get; private set; }

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
        public string FACILITY_TYPE_NAME { get; private set; }

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
        public Nullable<int> PHONE_NUMBER_EXTN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SECONDARY_PHONE_NUMBER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> SECONDARY_PHONE_NUMBER_EXTN { get; private set; }

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
        public static explicit operator FacilityDoneResult(FacilityDoneViewModel pResult)
        {
            return (new FacilityDoneResult()
            {
                FACILITY_DONE_CODE = pResult.FacilityDoneResult.FacilityDoneCode
                 ,
                FACILITY_DONE_NAME = pResult.FacilityDoneResult.FacilityDoneName
                 ,
                NPI = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.NPI) ? string.Empty : (pResult.FacilityDoneResult.NPI)
                 ,
                TAX_ID = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.TaxID) ? string.Empty : (pResult.FacilityDoneResult.TaxID)
                 ,
                FACILITY_TYPE_NAME = pResult.FacilityTypeName
                 ,
                STREET_NAME = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.StreetName) ? string.Empty : (pResult.FacilityDoneResult.StreetName)
                 ,
                SUITE = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.Suite) ? string.Empty : (pResult.FacilityDoneResult.Suite)
                 ,
                CITY_NAME = string.IsNullOrWhiteSpace(pResult.CityName) ? string.Empty : (pResult.CityName)
                 ,
                STATE_NAME = string.IsNullOrWhiteSpace(pResult.StateName) ? string.Empty : (pResult.StateName)
                 ,
                COUNTY_NAME = string.IsNullOrWhiteSpace(pResult.CountyName) ? string.Empty : (pResult.CountyName)
                 ,
                COUNTRY_NAME = string.IsNullOrWhiteSpace(pResult.CountryName) ? string.Empty : (pResult.CountryName)
                 ,
                PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.PhoneNumber) ? string.Empty : (pResult.FacilityDoneResult.PhoneNumber)
                 ,
                PHONE_NUMBER_EXTN = pResult.FacilityDoneResult.PhoneNumberExtn
                 ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.SecondaryPhoneNumber) ? string.Empty : (pResult.FacilityDoneResult.SecondaryPhoneNumber)
                 ,
                SECONDARY_PHONE_NUMBER_EXTN = pResult.FacilityDoneResult.SecondaryPhoneNumberExtn
                 ,
                EMAIL = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.Email) ? string.Empty : (pResult.FacilityDoneResult.Email)
                 ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.SecondaryEmail) ? string.Empty : (pResult.FacilityDoneResult.SecondaryEmail)
                 ,
                FAX = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.Fax) ? string.Empty : (pResult.FacilityDoneResult.Fax)
                 ,
                CONTACT_PERSON_LAST_NAME = pResult.FacilityDoneResult.ContactPersonLastName
                 ,
                CONTACT_PERSON_MIDDLE_NAME = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonMiddleName) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonMiddleName)
                 ,
                CONTACT_PERSON_FIRST_NAME = pResult.FacilityDoneResult.ContactPersonFirstName
                 ,
                CONTACT_PERSON_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonPhoneNumber) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonPhoneNumber)
                 ,
                CONTACT_PERSON_PHONE_NUMBER_EXTN = pResult.FacilityDoneResult.ContactPersonPhoneNumberExtn.HasValue ? pResult.FacilityDoneResult.ContactPersonPhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonSecondaryPhoneNumber) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonSecondaryPhoneNumber)
                 ,
                CONTACT_PERSON_SECONDARY_PHONE_NUMBER_EXTN = pResult.FacilityDoneResult.ContactPersonSecondaryPhoneNumberExtn.HasValue ? pResult.FacilityDoneResult.ContactPersonSecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                 ,
                CONTACT_PERSON_EMAIL = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonEmail) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonEmail)
                 ,
                CONTACT_PERSON_SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonSecondaryEmail) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonSecondaryEmail)
                 ,
                CONTACT_PERSON_FAX = string.IsNullOrWhiteSpace(pResult.FacilityDoneResult.ContactPersonFax) ? string.Empty : (pResult.FacilityDoneResult.ContactPersonFax)
                ,
                IS_ACTIVE = pResult.FacilityDoneResult.IsActive

            });
        }

        # endregion
    }
}
