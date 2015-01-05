
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{


    #region ClaimMediaAutoComplete

    public class ClaimMediaModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteClaimMedia(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_ClaimMedia_Result> spRes = new List<usp_GetAutoComplete_ClaimMedia_Result>(ctx.usp_GetAutoComplete_ClaimMedia(stats));

                foreach (usp_GetAutoComplete_ClaimMedia_Result item in spRes)
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
        public List<string> GetAutoCompleteClaimMediaID(string selText)
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
                List<usp_GetIDAutoComplete_ClaimMedia_Result> spRes = new List<usp_GetIDAutoComplete_ClaimMedia_Result>(ctx.usp_GetIDAutoComplete_ClaimMedia(selCode));

                foreach (usp_GetIDAutoComplete_ClaimMedia_Result item in spRes)
                {
                    retRes.Add(item.ClaimMediaID.ToString());
                }
            }

            return retRes;
        }

        #endregion
    }

    #endregion


    # region ClaimMediaSaveModel

    /// <summary>
    /// By Sai : Manager Role - Claim Media Edit/Save/Delete
    /// </summary>
    public class ClaimMediaSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_ClaimMedia_Result ClaimMedia
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClaimMediaSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                ClaimMedia = (new List<usp_GetByPkId_ClaimMedia_Result>(ctx.usp_GetByPkId_ClaimMedia(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (ClaimMedia == null)
            {
                ClaimMedia = new usp_GetByPkId_ClaimMedia_Result() { IsActive = true };
            }

            EncryptAudit(ClaimMedia.ClaimMediaID, ClaimMedia.LastModifiedBy, ClaimMedia.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter ClaimMediaID = ObjParam("ClaimMedia");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                // string selCode = ClaimMedia.ClaimMediaCode.Substring(0, 5);
                ctx.usp_Insert_ClaimMedia(ClaimMedia.ClaimMediaCode, ClaimMedia.ClaimMediaName, ClaimMedia.MaxDiagnosis, string.Empty, pUserID, ClaimMediaID);

                if (HasErr(ClaimMediaID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
           // throw new Exception("SaveInsert(int pUserID)");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter ClaimMediaID = ObjParam("ClaimMedia");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                //   string selCode = ClaimMedia.ClaimMediaCode.Substring(0, 5);

                ctx.usp_Update_ClaimMedia(ClaimMedia.ClaimMediaCode, ClaimMedia.ClaimMediaName, ClaimMedia.MaxDiagnosis, ClaimMedia.Comment, ClaimMedia.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ClaimMediaID);

                if (HasErr(ClaimMediaID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;

           // throw new Exception("protected override bool SaveUpdate(int pUserID)");
        }

        #endregion

        #region Public Methods

        # endregion
    }

    # endregion

    # region ClaimMediaSearchModel

    /// <summary>
    ///  By Sai : Manager Role - Claim Media Search
    /// </summary>
    public class ClaimMediaSearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_ClaimMedia_Result> ClaimMedia { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClaimMediaSearchModel()
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
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimMedia_Result> lst = new List<usp_GetByAZ_ClaimMedia_Result>(ctx.usp_GetByAZ_ClaimMedia(SearchName, pIsActive));

                foreach (usp_GetByAZ_ClaimMedia_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ClaimMedia = new List<usp_GetBySearch_ClaimMedia_Result>(ctx.usp_GetBySearch_ClaimMedia(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
