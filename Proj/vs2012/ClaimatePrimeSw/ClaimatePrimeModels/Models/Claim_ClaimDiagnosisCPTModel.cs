using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.Models
{
    public class ClaimCPTSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<long> PatientVisitID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> ClaimDiagnosisID { get; set; }

        public Nullable<int> CPTID { get; set; }

        public Nullable<byte> FacilityTypeNameID { get; set; }

        public Nullable<int> ModifierName1ID { get; set; }

        public Nullable<int> ModifierName2ID { get; set; }

        public Nullable<int> ModifierName3ID { get; set; }

        public Nullable<int> ModifierName4ID { get; set; }

        public Nullable<int> Units { get; set; }

        public Nullable<decimal> ChargePerUnit { get; set; }

        public Nullable<System.DateTime> cPTDOS { get; set; }

        public List<usp_GetByPatientVisit_ClaimDiagnosisCPT_Result> ClaimCPTResult { get; set; }

        public List<usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result> ClaimCPTResultBA { get; set; }

        public string pDescType { get; set; }

        public usp_GetByPkId_ClaimDiagnosisCPT_Result pkClaimCPTResult { get; set; }

        public List<usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier_Result> ClaimCPTModifierResult { get; set; }

        public List<usp_GetBlockedCpt_ClaimDiagnosisCPT_Result> BlockedCPTResult { get; set; }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            //get cpt
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    pkClaimCPTResult = (new List<usp_GetByPkId_ClaimDiagnosisCPT_Result>(ctx.usp_GetByPkId_ClaimDiagnosisCPT(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (pkClaimCPTResult == null)
            {
                pkClaimCPTResult = new usp_GetByPkId_ClaimDiagnosisCPT_Result() { IsActive = true };
            }

            EncryptAudit(pkClaimCPTResult.ClaimDiagnosisCPTID, pkClaimCPTResult.LastModifiedBy, pkClaimCPTResult.LastModifiedOn);

            //get cpt modi
            if (pkClaimCPTResult.ClaimDiagnosisCPTID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimCPTModifierResult = new List<usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier_Result>(ctx.usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier(pkClaimCPTResult.ClaimDiagnosisCPTID, pIsActive));
                }

                if (ClaimCPTModifierResult == null)
                {
                    ClaimCPTModifierResult = new List<usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier_Result>();
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter ClaimDiagnosisCPTID = ObjParam("ClaimDiagnosisCPT");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Insert_ClaimDiagnosisCPT(ClaimDiagnosisID, CPTID, FacilityTypeNameID, Units, ChargePerUnit, cPTDOS, null, pUserID, ClaimDiagnosisCPTID);

                if (HasErr(ClaimDiagnosisCPTID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                ObjectParameter ClaimDiagnosisCPTModifierID = ObjParam("ClaimDiagnosisCPTModifierID", typeof(System.Int64), 0);

                #region Insert Modifiers

                if (ModifierName1ID > 0)
                {
                    ctx.usp_Insert_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), ModifierName1ID, 1, null, pUserID, ClaimDiagnosisCPTModifierID);

                    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                if (ModifierName2ID > 0)
                {
                    ctx.usp_Insert_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), ModifierName2ID, 2, null, pUserID, ClaimDiagnosisCPTModifierID);

                    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                if (ModifierName3ID > 0)
                {
                    ctx.usp_Insert_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), ModifierName3ID, 3, null, pUserID, ClaimDiagnosisCPTModifierID);

                    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                if (ModifierName4ID > 0)
                {
                    ctx.usp_Insert_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), ModifierName4ID, 4, null, pUserID, ClaimDiagnosisCPTModifierID);

                    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                #endregion

                CommitDbTrans(ctx);
            }

            return true;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter ClaimDiagnosisCPTID = ObjParam("ClaimDiagnosisCPT");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_ClaimDiagnosisCPT(this.pkClaimCPTResult.ClaimDiagnosisID, this.pkClaimCPTResult.CPTID, this.pkClaimCPTResult.FacilityTypeID
                    , this.pkClaimCPTResult.Unit, this.pkClaimCPTResult.ChargePerUnit, this.pkClaimCPTResult.CPTDOS, null, this.pkClaimCPTResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ClaimDiagnosisCPTID);

                if (HasErr(ClaimDiagnosisCPTID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                //foreach (usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier_Result item in ClaimCPTModifierResult)
                //{
                //    ObjectParameter ClaimDiagnosisCPTModifierID = ObjParam("ClaimDiagnosisCPTModifierID", typeof(System.Int64), item.ClaimDiagnosisCPTModifierID);

                //    ctx.usp_Update_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), item.ModifierID, item.ModifierLevel, null, false, item.LastModifiedBy, item.LastModifiedOn, pUserID, ClaimDiagnosisCPTModifierID);

                //    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                //    {
                //        RollbackDbTrans(ctx);

                //        return false;
                //    }
                //}

                CommitDbTrans(ctx);
            }

            return true;
        }
        #endregion

        #region Autocomplete

        #region ProcCPT

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> ProcedureCPTName(string stats, string descType)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_CPT_Result> spRes = new List<usp_GetAutoComplete_CPT_Result>(ctx.usp_GetAutoComplete_CPT(descType, stats));

                foreach (usp_GetAutoComplete_CPT_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> ProcedureCPTNameID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_CPT_Result spRes = (new List<usp_GetIDAutoComplete_CPT_Result>(ctx.usp_GetIDAutoComplete_CPT(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.CPTID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        #endregion

        #region ProcFacilityType

        public List<string> FacilityType(string stats)
        {

            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_FacilityType_Result> spRes = new List<usp_GetAutoComplete_FacilityType_Result>(ctx.usp_GetAutoComplete_FacilityType(stats));

                foreach (usp_GetAutoComplete_FacilityType_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }

        public List<string> FacilityTypeID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_FacilityType_Result spRes = (new List<usp_GetIDAutoComplete_FacilityType_Result>(ctx.usp_GetIDAutoComplete_FacilityType(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.FacilityTypeID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        #endregion

        #region Modifiers

        public List<string> ModiName(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Modifier_Result> spRes = new List<usp_GetAutoComplete_Modifier_Result>(ctx.usp_GetAutoComplete_Modifier(stats));

                foreach (usp_GetAutoComplete_Modifier_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }


        public List<string> ModiNameID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_Modifier_Result spRes = (new List<usp_GetIDAutoComplete_Modifier_Result>(ctx.usp_GetIDAutoComplete_Modifier(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.ModifierID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        #endregion


        #endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool InsertClaimDiagnosisCPT(int pUserID)
        {
            // Here transaction is not a matter. Because the claims are single user usage

            Int64 cptId;
            ObjectParameter claimDiagnosisCPTID = ObjParam("ClaimDiagnosisCPT");

            using (EFContext ctx = new EFContext())
            {
                ctx.usp_IsExists_ClaimDiagnosisCPT(ClaimDiagnosisID, CPTID, FacilityTypeNameID, Units, ChargePerUnit, cPTDOS, null, claimDiagnosisCPTID);
                cptId = Convert.ToInt64(claimDiagnosisCPTID.Value);
            }

            if (cptId != 0)
            {
                this.Fill(cptId, false);
                if (pkClaimCPTResult != null)
                {
                    this.pkClaimCPTResult.IsActive = true;
                }
            }

            return this.Save(pUserID);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="patientVisitID"></param>
        public void fillCPT(Nullable<long> patientVisitID)
        {
            if (patientVisitID == 0)
            {
                ClaimCPTResult = new List<usp_GetByPatientVisit_ClaimDiagnosisCPT_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimCPTResult = new List<usp_GetByPatientVisit_ClaimDiagnosisCPT_Result>(ctx.usp_GetByPatientVisit_ClaimDiagnosisCPT(patientVisitID, pDescType));
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="patientVisitID"></param>
        public void fillCPTBA(Nullable<long> patientVisitID)
        {
            if (patientVisitID == 0)
            {
                ClaimCPTResultBA = new List<usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimCPTResultBA = new List<usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result>(ctx.usp_GetByPatVisitDx_ClaimDiagnosisCPT(patientVisitID, pDescType));
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="patientVisitID"></param>
        /// <param name="isActive"></param>
        public void fillBlockedCPT(Nullable<long> patientVisitID, Nullable<bool> isActive)
        {
            if (patientVisitID == 0)
            {
                BlockedCPTResult = new List<usp_GetBlockedCpt_ClaimDiagnosisCPT_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    BlockedCPTResult = new List<usp_GetBlockedCpt_ClaimDiagnosisCPT_Result>(ctx.usp_GetBlockedCpt_ClaimDiagnosisCPT(patientVisitID, isActive, pDescType));
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool UnBlockCpt(int pUserID)
        {
            ObjectParameter ClaimDiagnosisCPTID = ObjParam("ClaimDiagnosisCPT");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_ClaimDiagnosisCPT(this.pkClaimCPTResult.ClaimDiagnosisID, this.pkClaimCPTResult.CPTID, this.pkClaimCPTResult.FacilityTypeID
                    , this.pkClaimCPTResult.Unit, this.pkClaimCPTResult.ChargePerUnit, this.pkClaimCPTResult.CPTDOS, null, true, LastModifiedBy, LastModifiedOn, pUserID, ClaimDiagnosisCPTID);

                if (HasErr(ClaimDiagnosisCPTID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                foreach (usp_GetByClaimDxCPT_ClaimDiagnosisCPTModifier_Result item in ClaimCPTModifierResult)
                {
                    ObjectParameter ClaimDiagnosisCPTModifierID = ObjParam("ClaimDiagnosisCPTModifierID", typeof(System.Int64), item.ClaimDiagnosisCPTModifierID);

                    ctx.usp_Update_ClaimDiagnosisCPTModifier(Convert.ToInt64(ClaimDiagnosisCPTID.Value), item.ModifierID, item.ModifierLevel, null, true, item.LastModifiedBy, item.LastModifiedOn, pUserID, ClaimDiagnosisCPTModifierID);

                    if (HasErr(ClaimDiagnosisCPTModifierID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion
    }
}
