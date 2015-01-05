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
    #region InsuranceTypeModel

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class InsuranceTypeSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_InsuranceType_Result InsuranceType
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
            ObjectParameter InsuranceTypeID = ObjParam("InsuranceType");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_InsuranceType(InsuranceType.InsuranceTypeCode, InsuranceType.InsuranceTypeName, InsuranceType.Comment, pUserID, InsuranceTypeID);

                    if (HasErr(InsuranceTypeID, ctx))
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
                    InsuranceType = (new List<usp_GetByPkId_InsuranceType_Result>(ctx.usp_GetByPkId_InsuranceType(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (InsuranceType == null)
            {
                InsuranceType = new usp_GetByPkId_InsuranceType_Result() { IsActive = true };
            }

            EncryptAudit(InsuranceType.InsuranceTypeID, InsuranceType.LastModifiedBy, InsuranceType.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        /// 
        public void fillByID(byte pID, bool? pIsActive)
        {
            # region Patient

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    InsuranceType = (new List<usp_GetByPkId_InsuranceType_Result>(ctx.usp_GetByPkId_InsuranceType(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (InsuranceType == null)
            {
                InsuranceType = new usp_GetByPkId_InsuranceType_Result();
            }

            EncryptAudit(InsuranceType.InsuranceTypeID, InsuranceType.LastModifiedBy, InsuranceType.LastModifiedOn);

            # endregion

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter InsuranceTypeID = ObjParam("InsuranceType");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_InsuranceType(InsuranceType.InsuranceTypeCode, InsuranceType.InsuranceTypeName, InsuranceType.Comment, InsuranceType.IsActive, LastModifiedBy, LastModifiedOn, pUserID, InsuranceTypeID);

                if (HasErr(InsuranceTypeID, ctx))
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
    public class InsuranceTypeSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_InsuranceType_Result> InsuranceTypeResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public InsuranceTypeSearchModel()
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
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                InsuranceTypeResults = new List<usp_GetBySearch_InsuranceType_Result>(ctx.usp_GetBySearch_InsuranceType(OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
