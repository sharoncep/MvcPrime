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
    public class NoteResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COMMENTS { get; private set; }

        

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
        public static explicit operator NoteResult(usp_GetCommentByID_ClaimProcess_Result pResult)
        {
            return (new NoteResult()
            {
                NAME_CODE = pResult.USER_NAME_CODE
                ,
                COMMENTS = pResult.USER_COMMENTS
            });
        }

        # endregion
    }
}
