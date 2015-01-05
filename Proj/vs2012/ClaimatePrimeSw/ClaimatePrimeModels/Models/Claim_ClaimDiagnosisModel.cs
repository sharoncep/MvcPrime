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
    #region DX

    public class ClaimDiagnosisSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public long PatientVisitID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int DiagnosisID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetByPatientVisit_ClaimDiagnosis_Result> ClaimDiagnosisResults { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_ClaimDiagnosis_Result ClaimDiagnosisResult { get; set; }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimDiagnosisResult = (new List<usp_GetByPkId_ClaimDiagnosis_Result>(ctx.usp_GetByPkId_ClaimDiagnosis(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (ClaimDiagnosisResult == null)
            {
                ClaimDiagnosisResult = new usp_GetByPkId_ClaimDiagnosis_Result() { IsActive = true };
            }

            EncryptAudit(ClaimDiagnosisResult.ClaimDiagnosisID, ClaimDiagnosisResult.LastModifiedBy, ClaimDiagnosisResult.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter ClaimDiagnosisID = ObjParam("ClaimDiagnosis");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Insert_ClaimDiagnosis(PatientVisitID, DiagnosisID, 0, null, pUserID, ClaimDiagnosisID);

                if (HasErr(ClaimDiagnosisID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;

        }

        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter ClaimDiagnosisID = ObjParam("ClaimDiagnosis");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_ClaimDiagnosis(this.ClaimDiagnosisResult.PatientVisitID, this.ClaimDiagnosisResult.DiagnosisID, this.ClaimDiagnosisResult.ClaimNumber, this.ClaimDiagnosisResult.Comment, this.ClaimDiagnosisResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ClaimDiagnosisID);

                if (HasErr(ClaimDiagnosisID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;

        }

        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool InsertClaimDiagnosis(int pUserID)
        {
            // Here transaction is not a matter. Because the claims are single user usage

            usp_GetPkId_ClaimDiagnosis_Result claimDiagnosisPk;

            ObjectParameter ClaimDiagnosisID = ObjParam("ClaimDiagnosis");

            using (EFContext ctx = new EFContext())
            {
                claimDiagnosisPk = (new List<usp_GetPkId_ClaimDiagnosis_Result>(ctx.usp_GetPkId_ClaimDiagnosis(PatientVisitID, DiagnosisID))).FirstOrDefault();
            }

            if ((claimDiagnosisPk != null) && (claimDiagnosisPk.ClaimDiagnosisID.HasValue) && (claimDiagnosisPk.ClaimDiagnosisID.Value != 0))
            {
                this.Fill(claimDiagnosisPk.ClaimDiagnosisID.Value, false);
                this.ClaimDiagnosisResult.IsActive = true;
            }

            return this.Save(pUserID);
        }

        public bool UnBlockDx(int pUserID)
        {
            ObjectParameter ClaimDiagnosisID = ObjParam("ClaimDiagnosis");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_ClaimDiagnosis(this.ClaimDiagnosisResult.PatientVisitID, this.ClaimDiagnosisResult.DiagnosisID, this.ClaimDiagnosisResult.ClaimNumber, this.ClaimDiagnosisResult.Comment, true, LastModifiedBy, LastModifiedOn, pUserID, ClaimDiagnosisID);

                if (HasErr(ClaimDiagnosisID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPatientVisitID"></param>
        /// <param name="pDescType"></param>
        public void FillClaimDiagnosis(long pPatientVisitID, string pDescType)
        {
            if (pPatientVisitID == 0)
            {
                ClaimDiagnosisResults = new List<usp_GetByPatientVisit_ClaimDiagnosis_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimDiagnosisResults = new List<usp_GetByPatientVisit_ClaimDiagnosis_Result>(ctx.usp_GetByPatientVisit_ClaimDiagnosis(pPatientVisitID, pDescType));
                }
            }
        }

        #endregion

        #region Autocomplete

        #region Dx
        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> DiagnosisName(Nullable<int> clinicID, string descType, string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Diagnosis_Result> spRes = new List<usp_GetAutoComplete_Diagnosis_Result>(ctx.usp_GetAutoComplete_Diagnosis(clinicID, descType, stats));

                foreach (usp_GetAutoComplete_Diagnosis_Result item in spRes)
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
        public List<string> DiagnosisNameID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            return ((new[] { selCode }).ToList<string>());
        }

        #endregion

        #region Primary Dx

        public List<string> PrimDxName(Nullable<long> patientVisitID, string descType, string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_ClaimDiagnosis_Result> spRes = new List<usp_GetAutoComplete_ClaimDiagnosis_Result>(ctx.usp_GetAutoComplete_ClaimDiagnosis(patientVisitID, descType, stats));

                foreach (usp_GetAutoComplete_ClaimDiagnosis_Result item in spRes)
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
        public List<string> PrimDxNameID(string selText, Nullable<long> patientVisitID)
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
                usp_GetIDAutoComplete_ClaimDiagnosis_Result spRes = (new List<usp_GetIDAutoComplete_ClaimDiagnosis_Result>(ctx.usp_GetIDAutoComplete_ClaimDiagnosis(selCode, patientVisitID))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.ClaimDiagnosisID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        #endregion

        #region ProcDx

        /// <summary>
        /// 
        /// </summary>
        /// <param name="patientVisitID"></param>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> ProcedureDxName(Nullable<long> patientVisitID, string descType, string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_ClaimDiagnosis_Result> spRes = new List<usp_GetAutoComplete_ClaimDiagnosis_Result>(ctx.usp_GetAutoComplete_ClaimDiagnosis(patientVisitID, descType, stats));

                foreach (usp_GetAutoComplete_ClaimDiagnosis_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }


        //public List<string> ProcedureDxNameID(string selText)
        //{
        //    Int32 indx1 = selText.LastIndexOf("[");
        //    Int32 indx2 = selText.LastIndexOf("]");

        //    if ((indx1 == -1) || (indx2 == -1))
        //    {
        //        return ((new[] { "0" }).ToList<string>());
        //    }

        //    indx1++;
        //    string selCode = selText.Substring(indx1, (indx2 - indx1));

        //    return ((new[] { selCode }).ToList<string>());
        //}

        #endregion

        #endregion


    }
    #endregion

    #region Primary Dx

    public class PrimeClaimDiagnosisSaveModel : BaseSaveModel
    {
        #region Properties

        public List<usp_GetPrimeDxByID_PatientVisit_Result> PrimeDx { get; set; }

        public List<usp_GetNameByID_ClaimDiagnosis_Result> BlockedDx { get; set; }

        public string pDescType { get; set; }

        #endregion

        #region Abstract
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PrimeDx = new List<usp_GetPrimeDxByID_PatientVisit_Result>(ctx.usp_GetPrimeDxByID_PatientVisit(pID, pIsActive, pDescType));
                }
            }

            if (PrimeDx == null)
            {
                PrimeDx = new List<usp_GetPrimeDxByID_PatientVisit_Result>();
            }

        }

        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Public
        public void fillBlockedDx(Nullable<long> patientVisitID, Nullable<bool> isActive)
        {
            using (EFContext ctx = new EFContext())
            {
                BlockedDx = new List<usp_GetNameByID_ClaimDiagnosis_Result>(ctx.usp_GetNameByID_ClaimDiagnosis(patientVisitID, isActive, pDescType));
            }


            if (BlockedDx == null)
            {
                BlockedDx = new List<usp_GetNameByID_ClaimDiagnosis_Result>();
            }
        }
        #endregion

    }

    #endregion
}
