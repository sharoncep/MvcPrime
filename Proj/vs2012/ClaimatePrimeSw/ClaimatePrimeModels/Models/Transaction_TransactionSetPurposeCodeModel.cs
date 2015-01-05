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
    #region TransactionPurposeCode

    #region TransactionPurposeCodeAutoComplete

    public class TransactionPurposeCodeModel : BaseModel
    {
        #region TransactionPurposeCode
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteTransactionPurposeCode(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_TransactionSetPurposeCode_Result> spRes = new List<usp_GetAutoComplete_TransactionSetPurposeCode_Result>(ctx.usp_GetAutoComplete_TransactionSetPurposeCode(stats));

                foreach (usp_GetAutoComplete_TransactionSetPurposeCode_Result item in spRes)
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
        public List<string> GetAutoCompleteTransactionPurposeCodeID(string selText)
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
                List<usp_GetIDAutoComplete_TransactionSetPurposeCode_Result> spRes = new List<usp_GetIDAutoComplete_TransactionSetPurposeCode_Result>(ctx.usp_GetIDAutoComplete_TransactionSetPurposeCode(selCode));

                foreach (usp_GetIDAutoComplete_TransactionSetPurposeCode_Result item in spRes)
                {
                    retRes.Add(item.TransactionSetPurposeCode_ID.ToString());
                }
            }

            return retRes;
        }

        #endregion
    }

    #endregion

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class TransactionPurposeCodeSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_TransactionSetPurposeCode_Result TransactionPurposeCode
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
            ObjectParameter TransactionPurposeCodeID = ObjParam("TransactionSetPurposeCode");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_TransactionSetPurposeCode(TransactionPurposeCode.TransactionSetPurposeCodeCode, TransactionPurposeCode.TransactionSetPurposeCodeName, TransactionPurposeCode.Comment, pUserID, TransactionPurposeCodeID);

                    if (HasErr(TransactionPurposeCodeID, ctx))
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
                    TransactionPurposeCode = (new List<usp_GetByPkId_TransactionSetPurposeCode_Result>(ctx.usp_GetByPkId_TransactionSetPurposeCode(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (TransactionPurposeCode == null)
            {
                TransactionPurposeCode = new usp_GetByPkId_TransactionSetPurposeCode_Result() { IsActive = true };
            }

            EncryptAudit(TransactionPurposeCode.TransactionSetPurposeCodeID, TransactionPurposeCode.LastModifiedBy, TransactionPurposeCode.LastModifiedOn);
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
        //            TransactionPurposeCode = (new List<usp_GetByPkId_TransactionPurposeCode_Result>(ctx.usp_GetByPkId_TransactionPurposeCode(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (TransactionPurposeCode == null)
        //    {
        //        TransactionPurposeCode = new usp_GetByPkId_TransactionPurposeCode_Result();
        //    }

        //    EncryptAudit(TransactionPurposeCode.TransactionPurposeCodeID, TransactionPurposeCode.LastModifiedBy, TransactionPurposeCode.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter TransactionPurposeCodeID = ObjParam("TransactionSetPurposeCode");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_TransactionSetPurposeCode(TransactionPurposeCode.TransactionSetPurposeCodeCode, TransactionPurposeCode.TransactionSetPurposeCodeName, TransactionPurposeCode.Comment, TransactionPurposeCode.IsActive, LastModifiedBy, LastModifiedOn, pUserID, TransactionPurposeCodeID);

                if (HasErr(TransactionPurposeCodeID, ctx))
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
    public class TransactionPurposeCodeSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_TransactionSetPurposeCode_Result> TransactionPurposeCodeResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public TransactionPurposeCodeSearchModel()
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
                TransactionPurposeCodeResults = new List<usp_GetBySearch_TransactionSetPurposeCode_Result>(ctx.usp_GetBySearch_TransactionSetPurposeCode(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
