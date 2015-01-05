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
    #region PrintPin

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class PrintPinSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_PrintPin_Result PrintPin
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
            ObjectParameter PrintPinID = ObjParam("PrintPin");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_PrintPin(PrintPin.PrintPinCode, PrintPin.PrintPinName, PrintPin.Comment, pUserID, PrintPinID);

                    if (HasErr(PrintPinID, ctx))
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
                    PrintPin = (new List<usp_GetByPkId_PrintPin_Result>(ctx.usp_GetByPkId_PrintPin(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PrintPin == null)
            {
                PrintPin = new usp_GetByPkId_PrintPin_Result() { IsActive = true };
            }

            EncryptAudit(PrintPin.PrintPinID, PrintPin.LastModifiedBy, PrintPin.LastModifiedOn);
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
        //            PrintPin = (new List<usp_GetByPkId_PrintPin_Result>(ctx.usp_GetByPkId_PrintPin(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (PrintPin == null)
        //    {
        //        PrintPin = new usp_GetByPkId_PrintPin_Result();
        //    }

        //    EncryptAudit(PrintPin.PrintPinID, PrintPin.LastModifiedBy, PrintPin.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter PrintPinID = ObjParam("PrintPin");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_PrintPin(PrintPin.PrintPinCode, PrintPin.PrintPinName, PrintPin.Comment, PrintPin.IsActive, LastModifiedBy, LastModifiedOn, pUserID, PrintPinID);

                if (HasErr(PrintPinID, ctx))
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
    public class PrintPinSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_PrintPin_Result> PrintPinResults { get; set; }



        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PrintPinSearchModel()
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
                PrintPinResults = new List<usp_GetBySearch_PrintPin_Result>(ctx.usp_GetBySearch_PrintPin(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
