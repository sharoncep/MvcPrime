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
    #region Credential

    #region CredentialAutoComplete

    public class CredentialModel : BaseModel
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteCredential(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Credential_Result> spRes = new List<usp_GetAutoComplete_Credential_Result>(ctx.usp_GetAutoComplete_Credential(stats));

                foreach (usp_GetAutoComplete_Credential_Result item in spRes)
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
        public List<string> GetAutoCompleteCredentialID(string selText)
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
                List<usp_GetIDAutoComplete_Credential_Result> spRes = new List<usp_GetIDAutoComplete_Credential_Result>(ctx.usp_GetIDAutoComplete_Credential(selCode));

                foreach (usp_GetIDAutoComplete_Credential_Result item in spRes)
                {
                    retRes.Add(item.CredentialID.ToString());
                }
            }

            return retRes;
        }
    }

        #endregion

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class CredentialSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Credential_Result Credential
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
            ObjectParameter CredentialID = ObjParam("Credential");
            
            using (EFContext ctx = new EFContext())
                {
                    BeginDbTrans(ctx);
                    ctx.usp_Insert_Credential(Credential.CredentialCode, Credential.CredentialName, Credential.Comment, pUserID, CredentialID);

                    if (HasErr(CredentialID, ctx))
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
                    Credential = (new List<usp_GetByPkId_Credential_Result>(ctx.usp_GetByPkId_Credential(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (Credential == null)
            {
                Credential = new usp_GetByPkId_Credential_Result() { IsActive = true };
            }

            EncryptAudit(Credential.CredentialID, Credential.LastModifiedBy, Credential.LastModifiedOn);
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
        //            Credential = (new List<usp_GetByPkId_Credential_Result>(ctx.usp_GetByPkId_Credential(pID, pIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (Credential == null)
        //    {
        //        Credential = new usp_GetByPkId_Credential_Result();
        //    }

        //    EncryptAudit(Credential.CredentialID, Credential.LastModifiedBy, Credential.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter CredentialID = ObjParam("Credential");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_Credential(Credential.CredentialCode, Credential.CredentialName, Credential.Comment, Credential.IsActive, LastModifiedBy, LastModifiedOn, pUserID, CredentialID);

                if (HasErr(CredentialID, ctx))
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
    public class CredentialSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Credential_Result> CredentialResults { get; set; }

   

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CredentialSearchModel()
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
                CredentialResults = new List<usp_GetBySearch_Credential_Result>(ctx.usp_GetBySearch_Credential(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion
}
