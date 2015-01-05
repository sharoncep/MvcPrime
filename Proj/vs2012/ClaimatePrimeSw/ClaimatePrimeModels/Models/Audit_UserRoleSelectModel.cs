using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class UserRoleSelectSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Byte RoleID
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserRoleSelectSaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter userRoleSelectID = ObjParam("UserRoleSelect");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                byte prevRole = (new List<usp_GetRecent_UserRoleSelect_Result>(ctx.usp_GetRecent_UserRoleSelect(pUserID))).FirstOrDefault().ROLE_ID;

                if (prevRole != RoleID)
                {
                    ctx.usp_Insert_UserRoleSelect (pUserID, RoleID, userRoleSelectID);
                    if (HasErr(userRoleSelectID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
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
            throw new NotImplementedException();
        }

        #endregion

        #region Public Methods

        #endregion
    }
}
