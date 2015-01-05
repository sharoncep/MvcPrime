using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;


namespace ClaimatePrimeModels.Models
{
    #region CPTSearchModel
    public class CPTSearchModel : BaseSaveModel
    {
        #region Property
        /// <summary>
        /// Get or Set
        /// </summary>
        public decimal chargePerUnit { get; set; }

        #endregion

        #region Abstract

        
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Public

        public void GetCharge(int pCPTID)
        {
            if (pCPTID > 0)
            {
                usp_GetByPkId_CPT_Result CPTResult = null;
                using (EFContext ctx = new EFContext())
                {
                    CPTResult = (new List<usp_GetByPkId_CPT_Result>(ctx.usp_GetByPkId_CPT(pCPTID, true))).FirstOrDefault();
                }

                if (CPTResult != null)
                {
                    chargePerUnit = CPTResult.ChargePerUnit;
                }
            }
        }

        #endregion
    }
    #endregion

    # region CPTSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class CPTSaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_CPT_Result CPT
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CPTSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                CPT = (new List<usp_GetByPkId_CPT_Result>(ctx.usp_GetByPkId_CPT(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (CPT == null)
            {
                CPT = new usp_GetByPkId_CPT_Result() { IsActive = true };
            }

            EncryptAudit(CPT.CPTID, CPT.LastModifiedBy, CPT.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter CPTID = ObjParam("CPT");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_CPT(CPT.CPTCode,CPT.ShortDesc, CPT.MediumDesc, CPT.LongDesc, CPT.CustomDesc,CPT.ChargePerUnit,CPT.IsHCPCSCode, string.Empty, pUserID, CPTID);

                if (HasErr(CPTID, ctx))
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
            ObjectParameter CPTID = ObjParam("CPT");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_CPT(CPT.CPTCode, CPT.ShortDesc, CPT.MediumDesc, CPT.LongDesc, CPT.CustomDesc, CPT.ChargePerUnit, CPT.IsHCPCSCode, CPT.Comment, CPT.IsActive, LastModifiedBy, LastModifiedOn, pUserID, CPTID);
                if (HasErr(CPTID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                else
                {
                    CommitDbTrans(ctx);
                }
            }

            return true;
        }

        #endregion
    }

    # endregion

    #region CPTNewSearchModel
    /// <summary>
    /// 
    /// </summary>
    public class CPTNewSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_CPT_Result> CPT { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CPTNewSearchModel()
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
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_CPT_Result> lst = new List<usp_GetByAZ_CPT_Result>(ctx.usp_GetByAZ_CPT(SearchName, pIsActive));

                foreach (usp_GetByAZ_CPT_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                CPT = new List<usp_GetBySearch_CPT_Result>(ctx.usp_GetBySearch_CPT(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion
}
