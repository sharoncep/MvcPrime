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
    #region PayerResponsibilitySequenceNumberCode

    #region PayerResponsibilitySequenceNumberCodeAutoComplete

    public class PayerResponsibilitySequenceNumberCodeModel : BaseModel
    {
        #region PayerResponsibilitySequenceNumberCode
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompletePayerResponsibilitySequenceNumberCode(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_PayerResponsibilitySequenceNumberCode_Result> spRes = new List<usp_GetAutoComplete_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetAutoComplete_PayerResponsibilitySequenceNumberCode(stats));

                foreach (usp_GetAutoComplete_PayerResponsibilitySequenceNumberCode_Result item in spRes)
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
        public List<string> GetAutoCompletePayerResponsibilitySequenceNumberCodeID(string selText)
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
                List<usp_GetIDAutoComplete_PayerResponsibilitySequenceNumberCode_Result> spRes = new List<usp_GetIDAutoComplete_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetIDAutoComplete_PayerResponsibilitySequenceNumberCode(selCode));

                foreach (usp_GetIDAutoComplete_PayerResponsibilitySequenceNumberCode_Result item in spRes)
                {
                    retRes.Add(item.PayerResponsibilitySequenceNumberCode_ID.ToString());
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
    public class PayerResponsibilitySequenceNumberCodeSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result PayerResponsibilitySequenceNumberCode
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
            ObjectParameter PayerResponsibilitySequenceNumberCodeID = ObjParam("PayerResponsibilitySequenceNumberCode");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_PayerResponsibilitySequenceNumberCode(PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeCode, PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeName, PayerResponsibilitySequenceNumberCode.Comment, pUserID, PayerResponsibilitySequenceNumberCodeID);

                    if (HasErr(PayerResponsibilitySequenceNumberCodeID, ctx))
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
                    PayerResponsibilitySequenceNumberCode = (new List<usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetByPkId_PayerResponsibilitySequenceNumberCode(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PayerResponsibilitySequenceNumberCode == null)
            {
                PayerResponsibilitySequenceNumberCode = new usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result() { IsActive = true };
            }

            EncryptAudit(PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeID, PayerResponsibilitySequenceNumberCode.LastModifiedBy, PayerResponsibilitySequenceNumberCode.LastModifiedOn);
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
        //            PayerResponsibilitySequenceNumberCode = (new List<usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetByPkId_PayerResponsibilitySequenceNumberCode(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (PayerResponsibilitySequenceNumberCode == null)
        //    {
        //        PayerResponsibilitySequenceNumberCode = new usp_GetByPkId_PayerResponsibilitySequenceNumberCode_Result();
        //    }

        //    EncryptAudit(PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeID, PayerResponsibilitySequenceNumberCode.LastModifiedBy, PayerResponsibilitySequenceNumberCode.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter PayerResponsibilitySequenceNumberCodeID = ObjParam("PayerResponsibilitySequenceNumberCode");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_PayerResponsibilitySequenceNumberCode(PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeCode, PayerResponsibilitySequenceNumberCode.PayerResponsibilitySequenceNumberCodeName, PayerResponsibilitySequenceNumberCode.Comment, PayerResponsibilitySequenceNumberCode.IsActive, LastModifiedBy, LastModifiedOn, pUserID, PayerResponsibilitySequenceNumberCodeID);

                if (HasErr(PayerResponsibilitySequenceNumberCodeID, ctx))
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
    public class PayerResponsibilitySequenceNumberCodeSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_PayerResponsibilitySequenceNumberCode_Result> PayerResponsibilitySequenceNumberCodeResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PayerResponsibilitySequenceNumberCodeSearchModel()
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
               PayerResponsibilitySequenceNumberCodeResults = new List<usp_GetBySearch_PayerResponsibilitySequenceNumberCode_Result>(ctx.usp_GetBySearch_PayerResponsibilitySequenceNumberCode(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
