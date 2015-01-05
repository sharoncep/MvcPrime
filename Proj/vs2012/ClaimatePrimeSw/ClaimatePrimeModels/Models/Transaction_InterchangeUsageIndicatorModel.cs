
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

    #region UsageIndicatorAutoComplete

    public class UsageIndicatorModel : BaseModel
    {
        #region UsageIndicator
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteUsageIndicator(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_InterchangeUsageIndicator_Result> spRes = new List<usp_GetAutoComplete_InterchangeUsageIndicator_Result>(ctx.usp_GetAutoComplete_InterchangeUsageIndicator(stats));

                foreach (usp_GetAutoComplete_InterchangeUsageIndicator_Result item in spRes)
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
        public List<string> GetAutoCompleteUsageIndicatorID(string selText)
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
                List<usp_GetIDAutoComplete_InterchangeUsageIndicator_Result> spRes = new List<usp_GetIDAutoComplete_InterchangeUsageIndicator_Result>(ctx.usp_GetIDAutoComplete_InterchangeUsageIndicator(selCode));

                foreach (usp_GetIDAutoComplete_InterchangeUsageIndicator_Result item in spRes)
                {
                    retRes.Add(item.InterchangeUsageIndicator_ID.ToString());
                }
            }

            return retRes;
        }

        #endregion
    }

    #endregion
    

    # region UsageIndicatorSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class UsageIndicatorSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public usp_GetByPkId_InterchangeUsageIndicator_Result UsageIndicator
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UsageIndicatorSaveModel()
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
                UsageIndicator = (new List<usp_GetByPkId_InterchangeUsageIndicator_Result>(ctx.usp_GetByPkId_InterchangeUsageIndicator(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (UsageIndicator == null)
            {
                UsageIndicator = new usp_GetByPkId_InterchangeUsageIndicator_Result() { IsActive = true };
            }

            EncryptAudit(UsageIndicator.InterchangeUsageIndicatorID, UsageIndicator.LastModifiedBy, UsageIndicator.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter UsageIndicatorID = ObjParam("InterchangeUsageIndicator");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               // string selCode = UsageIndicator.UsageIndicatorCode.Substring(0, 5);
                ctx.usp_Insert_InterchangeUsageIndicator(UsageIndicator.InterchangeUsageIndicatorCode, UsageIndicator.InterchangeUsageIndicatorName, UsageIndicator.Comment, pUserID, UsageIndicatorID);

                if (HasErr(UsageIndicatorID, ctx))
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
            ObjectParameter UsageIndicatorID = ObjParam("InterchangeUsageIndicator");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

             //   string selCode = UsageIndicator.UsageIndicatorCode.Substring(0, 5);

               ctx.usp_Update_InterchangeUsageIndicator(UsageIndicator.InterchangeUsageIndicatorCode, UsageIndicator.InterchangeUsageIndicatorName, UsageIndicator.Comment, UsageIndicator.IsActive, LastModifiedBy, LastModifiedOn, pUserID, UsageIndicatorID);

                if (HasErr(UsageIndicatorID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

        #region Public Methods

        # endregion
    }

    # endregion

    # region UsageIndicatorSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class UsageIndicatorSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_InterchangeUsageIndicator_Result> UsageIndicator { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UsageIndicatorSearchModel()
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
                UsageIndicator = new List<usp_GetBySearch_InterchangeUsageIndicator_Result>(ctx.usp_GetBySearch_InterchangeUsageIndicator(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
