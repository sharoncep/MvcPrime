
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
    #region EntityTypeAutoComplete

    public class EntityTypeQualifierModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteEntityType(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_EntityTypeQualifier_Result> spRes = new List<usp_GetAutoComplete_EntityTypeQualifier_Result>(ctx.usp_GetAutoComplete_EntityTypeQualifier(stats));

                foreach (usp_GetAutoComplete_EntityTypeQualifier_Result item in spRes)
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
        public List<string> GetAutoCompleteEntityTypeID(string selText)
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
                List<usp_GetIDAutoComplete_EntityTypeQualifier_Result> spRes = new List<usp_GetIDAutoComplete_EntityTypeQualifier_Result>(ctx.usp_GetIDAutoComplete_EntityTypeQualifier(selCode));

                foreach (usp_GetIDAutoComplete_EntityTypeQualifier_Result item in spRes)
                {
                    retRes.Add(item.EntityTypeQualifierID.ToString());
                }
            }

            return retRes;
        }

        #endregion
    }

    #endregion

    # region EntityTypeSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class EntityTypeSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_EntityTypeQualifier_Result EntityType
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EntityTypeSaveModel()
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
                EntityType = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (EntityType == null)
            {
                EntityType = new usp_GetByPkId_EntityTypeQualifier_Result() { IsActive = true };
            }

            EncryptAudit(EntityType.EntityTypeQualifierID, EntityType.LastModifiedBy, EntityType.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter EntityTypeID = ObjParam("EntityTypeQualifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               // string selCode = EntityType.EntityTypeCode.Substring(0, 5);
                ctx.usp_Insert_EntityTypeQualifier(EntityType.EntityTypeQualifierCode, EntityType.EntityTypeQualifierName, EntityType.Comment, pUserID, EntityTypeID);

                if (HasErr(EntityTypeID, ctx))
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
            ObjectParameter EntityTypeID = ObjParam("EntityTypeQualifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

             //   string selCode = EntityType.EntityTypeCode.Substring(0, 5);

               ctx.usp_Update_EntityTypeQualifier(EntityType.EntityTypeQualifierCode, EntityType.EntityTypeQualifierName, EntityType.Comment, EntityType.IsActive, LastModifiedBy, LastModifiedOn, pUserID, EntityTypeID);

                if (HasErr(EntityTypeID, ctx))
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

    # region EntityTypeSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class EntityTypeSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_EntityTypeQualifier_Result> EntityType { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EntityTypeSearchModel()
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
                EntityType = new List<usp_GetBySearch_EntityTypeQualifier_Result>(ctx.usp_GetBySearch_EntityTypeQualifier(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
