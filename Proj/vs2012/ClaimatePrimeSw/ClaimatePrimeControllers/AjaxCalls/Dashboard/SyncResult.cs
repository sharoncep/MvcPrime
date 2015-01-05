using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;

namespace ClaimatePrimeControllers.AjaxCalls.Dashboard
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class SyncResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_SYNC_DONE { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SyncResult(usp_GetLastStatus_SyncStatus_Result pResult)
        {
            return (new SyncResult()
            {
                IS_SYNC_DONE = pResult.EndOn.HasValue ? true : false
            });
        }

        # endregion
    }
}
