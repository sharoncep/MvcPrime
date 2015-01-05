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
    public class InsuranceResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_CODE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_NAME { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PAYER_ID { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURANCE_TYPE { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string EDI_RECEIVER { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PRINT_PIN { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PATIENT_PRINT_SIGN { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string INSURED_PRINT_SIGN { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PHYSICIAN_PRINT_SIGN { get; private set; }
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
        public bool IS_ACTIVE { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator InsuranceResult(ClaimInsuranceModel pResult)
        {

            return (new InsuranceResult()
            {
                INSURANCE_CODE = pResult.InsuranceResult.InsuranceCode
                 ,
                INSURANCE_NAME = pResult.InsuranceResult.InsuranceName
                ,
                PAYER_ID = pResult.InsuranceResult.PayerID
                ,
                INSURANCE_TYPE = pResult.InsuranceResult_InsType
                ,
                EDI_RECEIVER = pResult.InsuranceResult_EDIRecvr
                ,
                PRINT_PIN = pResult.InsuranceResult_PrintPin
                ,
                PATIENT_PRINT_SIGN = pResult.InsuranceResult_PatPrintSign
                ,
                INSURED_PRINT_SIGN = pResult.InsuranceResult_InsuPrintSign
                ,
                PHYSICIAN_PRINT_SIGN = pResult.InsuranceResult_PhysPrintSign
                ,
                STREET_NAME = pResult.InsuranceResult.StreetName
                ,
                SUITE = string.IsNullOrWhiteSpace(pResult.InsuranceResult.Suite) ? string.Empty : (pResult.InsuranceResult.Suite)
                ,
                CITY = pResult.CityName
                ,
                STATE = pResult.StateName
                ,
                COUNTY = string.IsNullOrWhiteSpace(pResult.CountyName) ? string.Empty : (pResult.CountyName)
                ,
                COUNTRY = pResult.CountryName
                ,
                PHONE_NUMBER = pResult.InsuranceResult.PhoneNumber
                ,
                PHONE_NUMBER_EXTN = pResult.InsuranceResult.PhoneNumberExtn.HasValue ? pResult.InsuranceResult.PhoneNumberExtn.Value.ToString() : string.Empty
                ,
                SECONDARY_PHONE_NUMBER = string.IsNullOrWhiteSpace(pResult.InsuranceResult.SecondaryPhoneNumber) ? string.Empty : (pResult.InsuranceResult.SecondaryPhoneNumber)
                ,
                SECONDARY_PHONE_NUMBER_EXTN = pResult.InsuranceResult.SecondaryPhoneNumberExtn.HasValue ? pResult.InsuranceResult.SecondaryPhoneNumberExtn.Value.ToString() : string.Empty
                ,
                EMAIL = string.IsNullOrWhiteSpace(pResult.InsuranceResult.Email) ? string.Empty : (pResult.InsuranceResult.Email)
                ,
                SECONDARY_EMAIL = string.IsNullOrWhiteSpace(pResult.InsuranceResult.SecondaryEmail) ? string.Empty : (pResult.InsuranceResult.SecondaryEmail)
                ,
                FAX = string.IsNullOrWhiteSpace(pResult.InsuranceResult.Fax) ? string.Empty : (pResult.InsuranceResult.Fax)
                ,
                IS_ACTIVE=pResult.InsuranceResult.IsActive

            });
        }

        # endregion
    }
}
