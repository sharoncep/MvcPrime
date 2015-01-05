
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
    

    # region ModifierSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class ModifierSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Modifier_Result Modifier
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ModifierSaveModel()
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
                Modifier = (new List<usp_GetByPkId_Modifier_Result>(ctx.usp_GetByPkId_Modifier(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (Modifier == null)
            {
                Modifier = new usp_GetByPkId_Modifier_Result() { IsActive = true };
            }

            EncryptAudit(Modifier.ModifierID, Modifier.LastModifiedBy, Modifier.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter ModifierID = ObjParam("Modifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               // string selCode = Modifier.ModifierCode.Substring(0, 5);
                ctx.usp_Insert_Modifier(Modifier.ModifierCode, Modifier.ModifierName, Modifier.Comment, pUserID, ModifierID);

                if (HasErr(ModifierID, ctx))
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
            ObjectParameter ModifierID = ObjParam("Modifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

             //   string selCode = Modifier.ModifierCode.Substring(0, 5);

               ctx.usp_Update_Modifier(Modifier.ModifierCode, Modifier.ModifierName, Modifier.Comment, Modifier.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ModifierID);

                if (HasErr(ModifierID, ctx))
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

    # region ModifierSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class ModifierSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Modifier_Result> Modifier { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ModifierSearchModel()
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
                List<usp_GetByAZ_Modifier_Result> lst = new List<usp_GetByAZ_Modifier_Result>(ctx.usp_GetByAZ_Modifier(SearchName, pIsActive));

                foreach (usp_GetByAZ_Modifier_Result item in lst)
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
                Modifier = new List<usp_GetBySearch_Modifier_Result>(ctx.usp_GetBySearch_Modifier(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
