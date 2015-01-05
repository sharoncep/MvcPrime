using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;

namespace ClaimatePrimeControllers.AjaxCalls.Reports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class ReportResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public bool IS_REIMPORT_DONE { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator ReportResult(usp_GetExcel_UserReport_Result pResult)
        {
            return (new ReportResult()
            {
                IS_REIMPORT_DONE = pResult.CurrImportEndOn.HasValue ? true : false
            });
        }

        # endregion
    }
}
