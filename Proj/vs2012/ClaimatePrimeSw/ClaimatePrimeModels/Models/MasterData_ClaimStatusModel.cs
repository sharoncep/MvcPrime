using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using System.Data.Objects;

namespace ClaimatePrimeModels.Models
{
    /// <summary>
    /// 
    /// </summary>
    /// 

    

    #region ClaimStatusSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class ClaimStatusSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_ClaimStatus_Result ClaimStatus
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
       
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    ClaimStatus = (new List<usp_GetByPkId_ClaimStatus_Result>(ctx.usp_GetByPkId_ClaimStatus(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (ClaimStatus == null)
            {
                ClaimStatus = new usp_GetByPkId_ClaimStatus_Result() { IsActive = true };
            }

            EncryptAudit(ClaimStatus.ClaimStatusID, ClaimStatus.LastModifiedBy, ClaimStatus.LastModifiedOn);
        }

        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter ClaimStatusID = ObjParam("ClaimStatus");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_ClaimStatus(ClaimStatus.ClaimStatusCode, ClaimStatus.ClaimStatusName, ClaimStatus.Comment, ClaimStatus.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ClaimStatusID);

                if (HasErr(ClaimStatusID, ctx))
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

    #region ClaimStatusSearchModel

    /// <summary>
    /// By Sai : Manager Role - Claim Status - Read only mode
    /// </summary>
    public class ClaimStatusSearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_ClaimStatus_Result> ClaimStatuss { get; set; }
       
        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClaimStatusSearchModel()
        {
        }

        #endregion

        #region  public methods

       

        #endregion


        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            return;
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
                ClaimStatuss = new List<usp_GetBySearch_ClaimStatus_Result>(ctx.usp_GetBySearch_ClaimStatus(SearchName, null, 1, 200, OrderByField, OrderByDirection, true));
                //Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(StartBy, ClinicID));
            }
        }

        

        #endregion

        # region Private Method

        # endregion
    }


    #endregion


}
