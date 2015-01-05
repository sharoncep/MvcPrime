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
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeModels.Models
{
    #region PrintSign

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class PrintSignSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_PrintSign_Result PrintSign
        {
            get;
            set;
        }


        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter PrintSignID = ObjParam("PrintSign");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_PrintSign(PrintSign.PrintSignCode, PrintSign.PrintSignName, PrintSign.Comment, pUserID, PrintSignID);

                    if (HasErr(PrintSignID, ctx))
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
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(byte pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PrintSign = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PrintSign == null)
            {
                PrintSign = new usp_GetByPkId_PrintSign_Result() { IsActive = true };
            }

            EncryptAudit(PrintSign.PrintSignID, PrintSign.LastModifiedBy, PrintSign.LastModifiedOn);
        }

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="pUserID"></param>
        ///// <returns></returns>
        ///// 
        //public void fillByID(byte pID, bool? pIsActive)
        //{
        //    # region Patient

        //    if (pID > 0)
        //    {
        //        using (EFContext ctx = new EFContext())
        //        {
        //            PrintSign = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (PrintSign == null)
        //    {
        //        PrintSign = new usp_GetByPkId_PrintSign_Result();
        //    }

        //    EncryptAudit(PrintSign.PrintSignID, PrintSign.LastModifiedBy, PrintSign.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter PrintSignID = ObjParam("PrintSign");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_PrintSign(PrintSign.PrintSignCode, PrintSign.PrintSignName, PrintSign.Comment, PrintSign.IsActive, LastModifiedBy, LastModifiedOn, pUserID, PrintSignID);

                if (HasErr(PrintSignID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

    }

    #endregion

    #region Search

    /// <summary>
    /// 
    /// </summary>
    public class PrintSignSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_PrintSign_Result> PrintSignResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PrintSignSearchModel()
        {
        }

        #endregion

        #region Public Methods
        
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
                PrintSignResults = new List<usp_GetBySearch_PrintSign_Result>(ctx.usp_GetBySearch_PrintSign(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
