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
    public class ICDFormatResult
    {
        #region Primitive Properties
        
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ICD_FORMAT { get; private set; }

        #endregion

        # region Public Operators


        public static explicit operator ICDFormatResult(usp_GetICDFormat_Clinic_Result pResult)
        {
            return (new ICDFormatResult()
            {
                ICD_FORMAT = pResult.ICDFormat.ToString()
            });
        }
        # endregion
    }
}
