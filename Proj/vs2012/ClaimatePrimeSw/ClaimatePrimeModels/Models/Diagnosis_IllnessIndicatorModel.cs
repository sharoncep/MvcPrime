
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
    

    # region IllnessIndicatorSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class IllnessIndicatorSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_IllnessIndicator_Result IllnessIndicator
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public IllnessIndicatorSaveModel()
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
                IllnessIndicator = (new List<usp_GetByPkId_IllnessIndicator_Result>(ctx.usp_GetByPkId_IllnessIndicator(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (IllnessIndicator == null)
            {
                IllnessIndicator = new usp_GetByPkId_IllnessIndicator_Result() { IsActive = true };
            }

            EncryptAudit(IllnessIndicator.IllnessIndicatorID, IllnessIndicator.LastModifiedBy, IllnessIndicator.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter IllnessIndicatorID = ObjParam("IllnessIndicator");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               // string selCode = IllnessIndicator.IllnessIndicatorCode.Substring(0, 5);
                ctx.usp_Insert_IllnessIndicator(IllnessIndicator.IllnessIndicatorCode, IllnessIndicator.IllnessIndicatorName, IllnessIndicator.Comment, pUserID, IllnessIndicatorID);

                if (HasErr(IllnessIndicatorID, ctx))
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
            ObjectParameter IllnessIndicatorID = ObjParam("IllnessIndicator");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

             //   string selCode = IllnessIndicator.IllnessIndicatorCode.Substring(0, 5);

               ctx.usp_Update_IllnessIndicator(IllnessIndicator.IllnessIndicatorCode, IllnessIndicator.IllnessIndicatorName, IllnessIndicator.Comment, IllnessIndicator.IsActive, LastModifiedBy, LastModifiedOn, pUserID, IllnessIndicatorID);

                if (HasErr(IllnessIndicatorID, ctx))
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

    # region IllnessIndicatorSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class IllnessIndicatorSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_IllnessIndicator_Result> IllnessIndicator { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public IllnessIndicatorSearchModel()
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
                List<usp_GetByAZ_IllnessIndicator_Result> lst = new List<usp_GetByAZ_IllnessIndicator_Result>(ctx.usp_GetByAZ_IllnessIndicator(SearchName, pIsActive));

                foreach (usp_GetByAZ_IllnessIndicator_Result item in lst)
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
                IllnessIndicator = new List<usp_GetBySearch_IllnessIndicator_Result>(ctx.usp_GetBySearch_IllnessIndicator(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
