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
    public class AgentWiseResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int USER_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string NAME { get; private set; }

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

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator AgentWiseResult(usp_GetDashboardAgent_User_Result pResult)
        {
            return (new AgentWiseResult()
            {
                NAME = pResult.Name
                 ,
                USER_ID = pResult.UserID

            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator AgentWiseResult(usp_GetAgentWiseSummary_PatientVisit_Result pResult)
        {
            return (new AgentWiseResult()
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
    }
}
