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
    #region SecurityQualifier

    #region SecurityQualifierAutoComplete

    public class SecurityQualifierModel : BaseModel
    {
        #region SecurityQualifier
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteSecurityQualifier(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_SecurityInformationQualifier_Result> spRes = new List<usp_GetAutoComplete_SecurityInformationQualifier_Result>(ctx.usp_GetAutoComplete_SecurityInformationQualifier(stats));

                foreach (usp_GetAutoComplete_SecurityInformationQualifier_Result item in spRes)
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
        public List<string> GetAutoCompleteSecurityQualifierID(string selText)
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
                List<usp_GetIDAutoComplete_SecurityInformationQualifier_Result> spRes = new List<usp_GetIDAutoComplete_SecurityInformationQualifier_Result>(ctx.usp_GetIDAutoComplete_SecurityInformationQualifier(selCode));

                foreach (usp_GetIDAutoComplete_SecurityInformationQualifier_Result item in spRes)
                {
                    retRes.Add(item.SecurityInformationQualifier_ID.ToString());
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
    public class SecurityQualifierSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_SecurityInformationQualifier_Result SecurityQualifier
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
            ObjectParameter SecurityQualifierID = ObjParam("SecurityInformationQualifier");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_SecurityInformationQualifier(SecurityQualifier.SecurityInformationQualifierCode, SecurityQualifier.SecurityInformationQualifierName, SecurityQualifier.Comment, pUserID, SecurityQualifierID);

                    if (HasErr(SecurityQualifierID, ctx))
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
                    SecurityQualifier = (new List<usp_GetByPkId_SecurityInformationQualifier_Result>(ctx.usp_GetByPkId_SecurityInformationQualifier(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (SecurityQualifier == null)
            {
                SecurityQualifier = new usp_GetByPkId_SecurityInformationQualifier_Result() { IsActive = true };
            }

            EncryptAudit(SecurityQualifier.SecurityInformationQualifierID, SecurityQualifier.LastModifiedBy, SecurityQualifier.LastModifiedOn);
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
        //            SecurityQualifier = (new List<usp_GetByPkId_SecurityQualifier_Result>(ctx.usp_GetByPkId_SecurityQualifier(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (SecurityQualifier == null)
        //    {
        //        SecurityQualifier = new usp_GetByPkId_SecurityQualifier_Result();
        //    }

        //    EncryptAudit(SecurityQualifier.SecurityQualifierID, SecurityQualifier.LastModifiedBy, SecurityQualifier.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter SecurityQualifierID = ObjParam("SecurityInformationQualifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_SecurityInformationQualifier(SecurityQualifier.SecurityInformationQualifierCode, SecurityQualifier.SecurityInformationQualifierName, SecurityQualifier.Comment, SecurityQualifier.IsActive, LastModifiedBy, LastModifiedOn, pUserID, SecurityQualifierID);

                if (HasErr(SecurityQualifierID, ctx))
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
    public class SecurityQualifierSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_SecurityInformationQualifier_Result> SecurityQualifierResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SecurityQualifierSearchModel()
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
                SecurityQualifierResults = new List<usp_GetBySearch_SecurityInformationQualifier_Result>(ctx.usp_GetBySearch_SecurityInformationQualifier(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
