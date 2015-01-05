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
    public class DxResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long CLAIM_DIAGNOSIS_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long CLAIM_NUMBER { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator DxResult(usp_GetByPatientVisit_ClaimDiagnosis_Result pResult)
        {
            return (new DxResult()
            {
                ID = pResult.ID
                ,
                CLAIM_DIAGNOSIS_ID = pResult.CLAIM_DIAGNOSIS_ID
                ,
                CLAIM_NUMBER = pResult.CLAIM_NUMBER
                ,
                NAME_CODE = pResult.NAME_CODE
            });
        }

        # endregion

        
    }
}
