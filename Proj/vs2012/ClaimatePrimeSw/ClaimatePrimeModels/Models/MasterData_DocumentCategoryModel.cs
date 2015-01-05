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
    #region DocumentCategoryModel

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class DocumentCategorySaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_DocumentCategory_Result DocumentCategory
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
            ObjectParameter documentCategoryID = ObjParam("DocumentCategory");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_DocumentCategory(DocumentCategory.DocumentCategoryCode, DocumentCategory.DocumentCategoryName, DocumentCategory.IsInPatientRelated, DocumentCategory.Comment, pUserID, documentCategoryID);

                    if (HasErr(documentCategoryID, ctx))
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
                    DocumentCategory = (new List<usp_GetByPkId_DocumentCategory_Result>(ctx.usp_GetByPkId_DocumentCategory(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (DocumentCategory == null)
            {
                DocumentCategory = new usp_GetByPkId_DocumentCategory_Result() { IsActive = true };
            }

            EncryptAudit(DocumentCategory.DocumentCategoryID, DocumentCategory.LastModifiedBy, DocumentCategory.LastModifiedOn);
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
        //            DocumentCategory = (new List<usp_GetByPkId_DocumentCategory_Result>(ctx.usp_GetByPkId_DocumentCategory(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (DocumentCategory == null)
        //    {
        //        DocumentCategory = new usp_GetByPkId_DocumentCategory_Result();
        //    }

        //    EncryptAudit(DocumentCategory.DocumentCategoryID, DocumentCategory.LastModifiedBy, DocumentCategory.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter documentCategoryID = ObjParam("DocumentCategory");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_DocumentCategory(DocumentCategory.DocumentCategoryCode, DocumentCategory.DocumentCategoryName, DocumentCategory.IsInPatientRelated, DocumentCategory.Comment, DocumentCategory.IsActive, LastModifiedBy, LastModifiedOn, pUserID, documentCategoryID);

                if (HasErr(documentCategoryID, ctx))
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
    public class DocumentCategorySearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_DocumentCategory_Result> DocumentCategoryResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DocumentCategorySearchModel()
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
                DocumentCategoryResults = new List<usp_GetBySearch_DocumentCategory_Result>(ctx.usp_GetBySearch_DocumentCategory(OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
