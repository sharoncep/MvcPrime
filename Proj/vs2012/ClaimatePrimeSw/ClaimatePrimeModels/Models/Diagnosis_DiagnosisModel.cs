using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{
    

    # region DiagnosisSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class DiagnosisSaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_Diagnosis_Result Diagnosis
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public string Diagnosis_DiagnosisGroup
        {
            get;
            set;
        }
        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DiagnosisSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    Diagnosis = (new List<usp_GetByPkId_Diagnosis_Result>(ctx.usp_GetByPkId_Diagnosis(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (Diagnosis == null)
            {
                Diagnosis = new usp_GetByPkId_Diagnosis_Result() { IsActive = true };
            }

            # region Auto Complete Fill

            # region AuthorizationQualifier

            if (Diagnosis.DiagnosisGroupID > 0)
            {
                usp_GetByPkId_DiagnosisGroup_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_DiagnosisGroup_Result>(ctx.usp_GetByPkId_DiagnosisGroup(Diagnosis.DiagnosisGroupID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Diagnosis_DiagnosisGroup = string.Concat(stateRes.DiagnosisGroupDescription, " [", stateRes.DiagnosisGroupCode, "]");
                }
            }

            # endregion


            #endregion


            EncryptAudit(Diagnosis.DiagnosisID, Diagnosis.LastModifiedBy, Diagnosis.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter DiagnosisID = ObjParam("Diagnosis");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_Diagnosis(Diagnosis.DiagnosisCode,Diagnosis.ICDFormat,Diagnosis.DiagnosisGroupID,Diagnosis.ShortDesc,Diagnosis.MediumDesc,Diagnosis.LongDesc,Diagnosis.CustomDesc, string.Empty, pUserID, DiagnosisID);

                if (HasErr(DiagnosisID, ctx))
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
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter DiagnosisID = ObjParam("Diagnosis");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_Diagnosis(Diagnosis.DiagnosisCode, Diagnosis.ICDFormat, Diagnosis.DiagnosisGroupID, Diagnosis.ShortDesc, Diagnosis.MediumDesc, Diagnosis.LongDesc, Diagnosis.CustomDesc, Diagnosis.Comment, Diagnosis.IsActive, LastModifiedBy, LastModifiedOn, pUserID, DiagnosisID);
                if (HasErr(DiagnosisID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                else
                {
                    CommitDbTrans(ctx);
                }
            }

            return true;
        }

        #endregion
    }

    # endregion

    #region DiagnosisSearch
    /// <summary>
    /// 
    /// </summary>
    public class DiagnosisSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Diagnosis_Result> Counties { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DiagnosisSearchModel()
        {
        }

        #endregion

        # region Public Methods

        # endregion

        #region Override Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Diagnosis_Result> lst = new List<usp_GetByAZ_Diagnosis_Result>(ctx.usp_GetByAZ_Diagnosis(SearchName, pIsActive));

                foreach (usp_GetByAZ_Diagnosis_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                Counties = new List<usp_GetBySearch_Diagnosis_Result>(ctx.usp_GetBySearch_Diagnosis(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion


}
