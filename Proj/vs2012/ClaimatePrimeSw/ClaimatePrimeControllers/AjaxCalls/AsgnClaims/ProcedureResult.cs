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
    public class ProcedureResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long CLAIM_DIAGNOSIS_CPT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long CLAIM_NUMBER { get; private set; }
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DX_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CPT_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string POS_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int UNIT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CPTDOS { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public decimal CHARGE_PER_UNIT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI1_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI2_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI3_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI4_NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DX_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CPT_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string POS_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI1_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI2_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI3_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string MODI4_CODE { get; private set; }


        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator ProcedureResult(usp_GetByPatientVisit_ClaimDiagnosisCPT_Result pResult)
        {
            return (new ProcedureResult()
            {
                CLAIM_DIAGNOSIS_CPT_ID = pResult.CLAIM_DIAGNOSIS_CPT_ID.HasValue ? pResult.CLAIM_DIAGNOSIS_CPT_ID.Value : 0
                ,
                CLAIM_NUMBER = pResult.CLAIM_NUMBER
                 ,
                DX_NAME_CODE = pResult.DX_NAME_CODE
                ,
                DX_CODE = pResult.DX_CODE
                 ,
                CPTDOS = pResult.CPT_DOS.HasValue ? StaticClass.GetDateStr(pResult.CPT_DOS.Value) : string.Empty
                ,
                CPT_NAME_CODE = string.IsNullOrWhiteSpace(pResult.CPT_NAME_CODE) ? string.Empty : (pResult.CPT_NAME_CODE)
                ,
                CPT_CODE = string.IsNullOrWhiteSpace(pResult.CPT_CODE) ? string.Empty : (pResult.CPT_CODE)
                ,
                POS_NAME_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_NAME_CODE) ? string.Empty : (pResult.FACILITY_TYPE_NAME_CODE)
                ,
                POS_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_CODE) ? string.Empty : (pResult.FACILITY_TYPE_CODE)
                ,
                MODI1_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_NAME_CODE) ? string.Empty : (pResult.MODI1_NAME_CODE)
                ,
                MODI1_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_CODE) ? string.Empty : (pResult.MODI1_CODE)
                ,
                MODI2_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_NAME_CODE) ? string.Empty : (pResult.MODI2_NAME_CODE)
                ,
                MODI2_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_CODE) ? string.Empty : (pResult.MODI2_CODE)
                ,
                MODI3_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_NAME_CODE) ? string.Empty : (pResult.MODI3_NAME_CODE)
                ,
                MODI3_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_CODE) ? string.Empty : (pResult.MODI3_CODE)
                ,
                MODI4_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_NAME_CODE) ? string.Empty : (pResult.MODI4_NAME_CODE)
                ,
                MODI4_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_CODE) ? string.Empty : (pResult.MODI4_CODE)
                ,
                UNIT = pResult.UNIT.HasValue ? pResult.UNIT.Value : 0
                ,
                CHARGE_PER_UNIT = pResult.CHARGE_PER_UNIT.HasValue ? pResult.CHARGE_PER_UNIT.Value : 0
            });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator ProcedureResult(usp_GetBlockedCpt_ClaimDiagnosisCPT_Result pResult)
        {
            return (new ProcedureResult()
            {
                CLAIM_DIAGNOSIS_CPT_ID = pResult.CLAIM_DIAGNOSIS_CPT_ID.HasValue ? pResult.CLAIM_DIAGNOSIS_CPT_ID.Value : 0
                ,
                DX_NAME_CODE = pResult.DX_NAME_CODE
                ,
                DX_CODE = pResult.DX_CODE
                 ,
                CPTDOS = pResult.CPT_DOS.HasValue ? StaticClass.GetDateStr(pResult.CPT_DOS.Value) : string.Empty
                ,
                CPT_NAME_CODE = string.IsNullOrWhiteSpace(pResult.CPT_NAME_CODE) ? string.Empty : (pResult.CPT_NAME_CODE)
                ,
                CPT_CODE = string.IsNullOrWhiteSpace(pResult.CPT_CODE) ? string.Empty : (pResult.CPT_CODE)
                ,
                POS_NAME_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_NAME_CODE) ? string.Empty : (pResult.FACILITY_TYPE_NAME_CODE)
                ,
                POS_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_CODE) ? string.Empty : (pResult.FACILITY_TYPE_CODE)
                ,
                MODI1_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_NAME_CODE) ? string.Empty : (pResult.MODI1_NAME_CODE)
                ,
                MODI1_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_CODE) ? string.Empty : (pResult.MODI1_CODE)
                ,
                MODI2_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_NAME_CODE) ? string.Empty : (pResult.MODI2_NAME_CODE)
                ,
                MODI2_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_CODE) ? string.Empty : (pResult.MODI2_CODE)
                ,
                MODI3_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_NAME_CODE) ? string.Empty : (pResult.MODI3_NAME_CODE)
                ,
                MODI3_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_CODE) ? string.Empty : (pResult.MODI3_CODE)
                ,
                MODI4_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_NAME_CODE) ? string.Empty : (pResult.MODI4_NAME_CODE)
                ,
                MODI4_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_CODE) ? string.Empty : (pResult.MODI4_CODE)
                ,
                UNIT = pResult.UNIT.HasValue ? pResult.UNIT.Value : 0
                ,
                CHARGE_PER_UNIT = pResult.CHARGE_PER_UNIT.HasValue ? pResult.CHARGE_PER_UNIT.Value : 0
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator ProcedureResult(usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result pResult)
        {
            return (new ProcedureResult()
            {
                CLAIM_DIAGNOSIS_CPT_ID = pResult.CLAIM_DIAGNOSIS_CPT_ID
                ,
                CLAIM_NUMBER = pResult.CLAIM_NUMBER
                 ,
                DX_NAME_CODE = pResult.DX_NAME_CODE
                ,
                DX_CODE = pResult.DX_CODE
                 ,
                CPTDOS = StaticClass.GetDateStr(pResult.CPT_DOS)
                ,
                CPT_NAME_CODE = string.IsNullOrWhiteSpace(pResult.CPT_NAME_CODE) ? string.Empty : (pResult.CPT_NAME_CODE)
                ,
                CPT_CODE = string.IsNullOrWhiteSpace(pResult.CPT_CODE) ? string.Empty : (pResult.CPT_CODE)
                ,
                POS_NAME_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_NAME_CODE) ? string.Empty : (pResult.FACILITY_TYPE_NAME_CODE)
                ,
                POS_CODE = string.IsNullOrWhiteSpace(pResult.FACILITY_TYPE_CODE) ? string.Empty : (pResult.FACILITY_TYPE_CODE)
                ,
                MODI1_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_NAME_CODE) ? string.Empty : (pResult.MODI1_NAME_CODE)
                ,
                MODI1_CODE = string.IsNullOrWhiteSpace(pResult.MODI1_CODE) ? string.Empty : (pResult.MODI1_CODE)
                ,
                MODI2_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_NAME_CODE) ? string.Empty : (pResult.MODI2_NAME_CODE)
                ,
                MODI2_CODE = string.IsNullOrWhiteSpace(pResult.MODI2_CODE) ? string.Empty : (pResult.MODI2_CODE)
                ,
                MODI3_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_NAME_CODE) ? string.Empty : (pResult.MODI3_NAME_CODE)
                ,
                MODI3_CODE = string.IsNullOrWhiteSpace(pResult.MODI3_CODE) ? string.Empty : (pResult.MODI3_CODE)
                ,
                MODI4_NAME_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_NAME_CODE) ? string.Empty : (pResult.MODI4_NAME_CODE)
                ,
                MODI4_CODE = string.IsNullOrWhiteSpace(pResult.MODI4_CODE) ? string.Empty : (pResult.MODI4_CODE)
                ,
                UNIT = pResult.UNIT//.HasValue ? pResult.UNIT.Value : 0
                ,
                CHARGE_PER_UNIT = pResult.CHARGE_PER_UNIT//.HasValue ? pResult.CHARGE_PER_UNIT.Value : 0
            });
        }

        # endregion


    }
}
