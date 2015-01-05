using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeConstants;
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
    public class PrevVisitResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_VISIT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DOS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLAIM_STATUS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte PATIENT_VISIT_COMPLEXITY { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ASSIGNED_TO { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TARGET_BA_USER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TARGET_QA_USER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TARGET_EA_USER { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator PrevVisitResult(usp_GetPrevVisit_PatientVisit_Result pResult)
        {
            return (new PrevVisitResult()
            {
                PATIENT_VISIT_ID = pResult.PatientVisitID
                ,
                DOS = StaticClass.GetDateStr(pResult.DOS)
                ,
                CLAIM_STATUS = Converts.AsEnum<ClaimStatus>(pResult.ClaimStatusID).ToString().Replace('_', ' ')
                 ,
                ASSIGNED_TO = string.IsNullOrWhiteSpace(pResult.AssignedTo) ? string.Empty : (pResult.AssignedTo)
                ,
                TARGET_BA_USER = string.IsNullOrWhiteSpace(pResult.TargetBAUserID) ? string.Empty : (pResult.TargetBAUserID)
                ,
                TARGET_EA_USER = string.IsNullOrWhiteSpace(pResult.TargetEAUserID) ? string.Empty : (pResult.TargetEAUserID)
                ,
                TARGET_QA_USER = string.IsNullOrWhiteSpace(pResult.TargetQAUserID) ? string.Empty : (pResult.TargetQAUserID)
                ,
                PATIENT_VISIT_COMPLEXITY = pResult.PatientVisitComplexity
            });
        }

        # endregion
    }
}
