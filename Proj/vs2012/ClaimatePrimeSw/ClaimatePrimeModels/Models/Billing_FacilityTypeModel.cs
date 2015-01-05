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
    

    #region FacilityTypeSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class FacilityTypeSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_FacilityType_Result FacilityType
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
            ObjectParameter FacilityTypeID = ObjParam("FacilityType");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_FacilityType(FacilityType.FacilityTypeCode, FacilityType.FacilityTypeName, FacilityType.Comment, pUserID, FacilityTypeID);

                if (HasErr(FacilityTypeID, ctx))
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
                    FacilityType = (new List<usp_GetByPkId_FacilityType_Result>(ctx.usp_GetByPkId_FacilityType(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (FacilityType == null)
            {
                FacilityType = new usp_GetByPkId_FacilityType_Result() { IsActive = true };
            }

            EncryptAudit(FacilityType.FacilityTypeID, FacilityType.LastModifiedBy, FacilityType.LastModifiedOn);
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
                    FacilityType = (new List<usp_GetByPkId_FacilityType_Result>(ctx.usp_GetByPkId_FacilityType(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (FacilityType == null)
            {
                FacilityType = new usp_GetByPkId_FacilityType_Result();
            }

            EncryptAudit(FacilityType.FacilityTypeID, FacilityType.LastModifiedBy, FacilityType.LastModifiedOn);

            # endregion

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter FacilityTypeID = ObjParam("FacilityType");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_FacilityType(FacilityType.FacilityTypeCode, FacilityType.FacilityTypeName, FacilityType.Comment, FacilityType.IsActive, LastModifiedBy, LastModifiedOn, pUserID, FacilityTypeID);

                if (HasErr(FacilityTypeID, ctx))
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

    #region FacilityTypeSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class FacilityTypeSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_FacilityType_Result> FacilityTypeResults { get; set; }



        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public FacilityTypeSearchModel()
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
                FacilityTypeResults = new List<usp_GetBySearch_FacilityType_Result>(ctx.usp_GetBySearch_FacilityType(null,null,1,200,OrderByField,OrderByDirection,pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

}
