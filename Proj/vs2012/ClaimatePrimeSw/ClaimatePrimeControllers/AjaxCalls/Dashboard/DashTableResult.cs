using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeConstants;
using System.Collections.Generic;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class DashTableResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DESC { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long COUNT1 { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long COUNT7 { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long COUNT30 { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long COUNT31PLUS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long COUNTTOTAL { get; private set; }

        ///// <summary>
        ///// Get
        ///// </summary>
        //[DataMember]
        //public long TOTRECS { get { return CalcTot(); } private set { } }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator DashTableResult(usp_GetDashboardSummary_PatientVisit_Result pResult)
        {
            return (new DashTableResult()
            {
                ID = pResult.ID
                ,
                DESC = pResult.DESC.Trim()
                ,
                COUNT1 = pResult.COUNT1
                ,
                COUNT7 = pResult.COUNT7
                ,
                COUNT30 = pResult.COUNT30
                ,
                COUNT31PLUS = pResult.COUNT31PLUS
                ,
                COUNTTOTAL = pResult.COUNTTOTAL
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator DashTableResult(usp_GetClinicWiseSummary_PatientVisit_Result pResult)
        {
            return (new DashTableResult()
            {
                ID = pResult.ID
                ,
                DESC = pResult.DESC.Trim()
                ,
                COUNT1 = pResult.COUNT1
                ,
                COUNT7 = pResult.COUNT7
                ,
                COUNT30 = pResult.COUNT30
                ,
                COUNT31PLUS = pResult.COUNT31PLUS
                ,
                COUNTTOTAL = pResult.COUNTTOTAL
            });
        }
        # endregion

        # region Private Methods

        ///// <summary>
        ///// 
        ///// </summary>
        //private long CalcTot()
        //{
        //    return (COUNT1 + COUNT7 + COUNT30 + COUNT31PLUS);
        //}

        # endregion
    }
}
