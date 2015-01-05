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
    public class DxResultView
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

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator DxResultView(DiagnosisSaveModel pResult)
        {
            return (new DxResultView()
            {
                NAME_CODE = pResult.Diagnosis.DiagnosisCode
                ,
                ID = pResult.Diagnosis.DiagnosisID
            });
        }

        

        # endregion
    }
}
