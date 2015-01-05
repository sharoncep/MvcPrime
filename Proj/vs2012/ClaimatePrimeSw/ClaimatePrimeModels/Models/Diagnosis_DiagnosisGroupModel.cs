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

    #region DiagnosisGroupAutoComplete

    public class DiagnosisGroupModel : BaseModel
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteDiagnosisGroup(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_DiagnosisGroup_Result> spRes = new List<usp_GetAutoComplete_DiagnosisGroup_Result>(ctx.usp_GetAutoComplete_DiagnosisGroup(stats));

                foreach (usp_GetAutoComplete_DiagnosisGroup_Result item in spRes)
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
        public List<string> GetAutoCompleteDiagnosisGroupID(string selText)
        {

            List<string> retRes = new List<string>();

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
                List<usp_GetIDAutoComplete_DiagnosisGroup_Result> spRes = new List<usp_GetIDAutoComplete_DiagnosisGroup_Result>(ctx.usp_GetIDAutoComplete_DiagnosisGroup(selCode));

                foreach (usp_GetIDAutoComplete_DiagnosisGroup_Result item in spRes)
                {
                    retRes.Add(item.DiagnosisGroupID.ToString());
                }
            }

            return retRes;
        }
    }

    #endregion
    

    # region DiagnosisGroupSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class DiagnosisGroupSaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_DiagnosisGroup_Result DiagnosisGroup
        {
            get;
            set;
        }

      

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DiagnosisGroupSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                DiagnosisGroup = (new List<usp_GetByPkId_DiagnosisGroup_Result>(ctx.usp_GetByPkId_DiagnosisGroup(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (DiagnosisGroup == null)
            {
                DiagnosisGroup = new usp_GetByPkId_DiagnosisGroup_Result() { IsActive = true };
            }

            EncryptAudit(DiagnosisGroup.DiagnosisGroupID, DiagnosisGroup.LastModifiedBy, DiagnosisGroup.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter DiagnosisGroupID = ObjParam("DiagnosisGroup");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_DiagnosisGroup(DiagnosisGroup.DiagnosisGroupCode,DiagnosisGroup.DiagnosisGroupDescription,DiagnosisGroup.Amount,string.Empty,pUserID,DiagnosisGroupID);

                if (HasErr(DiagnosisGroupID, ctx))
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
            ObjectParameter DiagnosisGroupID = ObjParam("DiagnosisGroup");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_DiagnosisGroup(DiagnosisGroup.DiagnosisGroupCode, DiagnosisGroup.DiagnosisGroupDescription, DiagnosisGroup.Amount, DiagnosisGroup.Comment, DiagnosisGroup.IsActive, LastModifiedBy, LastModifiedOn, pUserID, DiagnosisGroupID);
                if (HasErr(DiagnosisGroupID, ctx))
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

    #region DiagnosisGroupSearch
    /// <summary>
    /// 
    /// </summary>
    public class DiagnosisGroupSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_DiagnosisGroup_Result> Counties { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DiagnosisGroupSearchModel()
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
                List<usp_GetByAZ_DiagnosisGroup_Result> lst = new List<usp_GetByAZ_DiagnosisGroup_Result>(ctx.usp_GetByAZ_DiagnosisGroup(SearchName, pIsActive));

                foreach (usp_GetByAZ_DiagnosisGroup_Result item in lst)
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
                Counties = new List<usp_GetBySearch_DiagnosisGroup_Result>(ctx.usp_GetBySearch_DiagnosisGroup(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion


}
