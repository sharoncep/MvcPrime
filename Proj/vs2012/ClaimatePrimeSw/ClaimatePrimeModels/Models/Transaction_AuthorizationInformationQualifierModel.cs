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
    #region AuthorizationQualifier

    #region AuthorizationQualifierAutoComplete

    public class AuthorizationQualifierModel : BaseModel
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteAuthorizationQualifier(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_AuthorizationInformationQualifier_Result> spRes = new List<usp_GetAutoComplete_AuthorizationInformationQualifier_Result>(ctx.usp_GetAutoComplete_AuthorizationInformationQualifier(stats));

                foreach (usp_GetAutoComplete_AuthorizationInformationQualifier_Result item in spRes)
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
        public List<string> GetAutoCompleteAuthorizationQualifierID(string selText)
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
                List<usp_GetIDAutoComplete_AuthorizationInformationQualifier_Result> spRes = new List<usp_GetIDAutoComplete_AuthorizationInformationQualifier_Result>(ctx.usp_GetIDAutoComplete_AuthorizationInformationQualifier(selCode));

                foreach (usp_GetIDAutoComplete_AuthorizationInformationQualifier_Result item in spRes)
                {
                    retRes.Add(item.AuthorizationInformationQualifier_ID.ToString());
                }
            }

            return retRes;
        }
    }

        #endregion

    #region Save

    /// <summary>
    ///By Sai: Manager Role - Author Info Qualifier Save
    /// </summary>
    public class AuthorizationQualifierSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_AuthorizationInformationQualifier_Result AuthorizationQualifier
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
            ObjectParameter AuthorizationQualifierID = ObjParam("AuthorizationInformationQualifier");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_AuthorizationInformationQualifier(AuthorizationQualifier.AuthorizationInformationQualifierCode, AuthorizationQualifier.AuthorizationInformationQualifierName, AuthorizationQualifier.Comment, pUserID, AuthorizationQualifierID);

                    if (HasErr(AuthorizationQualifierID, ctx))
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
                    AuthorizationQualifier = (new List<usp_GetByPkId_AuthorizationInformationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationInformationQualifier(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (AuthorizationQualifier == null)
            {
                AuthorizationQualifier = new usp_GetByPkId_AuthorizationInformationQualifier_Result() { IsActive = true };
            }

            EncryptAudit(AuthorizationQualifier.AuthorizationInformationQualifierID, AuthorizationQualifier.LastModifiedBy, AuthorizationQualifier.LastModifiedOn);
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
        //            AuthorizationQualifier = (new List<usp_GetByPkId_AuthorizationQualifier_Result>(ctx.usp_GetByPkId_AuthorizationQualifier(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (AuthorizationQualifier == null)
        //    {
        //        AuthorizationQualifier = new usp_GetByPkId_AuthorizationQualifier_Result();
        //    }

        //    EncryptAudit(AuthorizationQualifier.AuthorizationQualifierID, AuthorizationQualifier.LastModifiedBy, AuthorizationQualifier.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter AuthorizationQualifierID = ObjParam("AuthorizationInformationQualifier");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_AuthorizationInformationQualifier(AuthorizationQualifier.AuthorizationInformationQualifierCode, AuthorizationQualifier.AuthorizationInformationQualifierName, AuthorizationQualifier.Comment, AuthorizationQualifier.IsActive, LastModifiedBy, LastModifiedOn, pUserID, AuthorizationQualifierID);

                if (HasErr(AuthorizationQualifierID, ctx))
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
    ///By Sai Manager Role - Author Info Qualifier Search
    /// </summary>
    public class AuthorizationQualifierSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_AuthorizationInformationQualifier_Result> AuthorizationQualifierResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AuthorizationQualifierSearchModel()
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
                AuthorizationQualifierResults = new List<usp_GetBySearch_AuthorizationInformationQualifier_Result>(ctx.usp_GetBySearch_AuthorizationInformationQualifier(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
