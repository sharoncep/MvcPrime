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

    #region RoleModel
    public class RoleModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetRoles_UserRole_Result> Roles { get; set; }

        # endregion

        #region constructors

        /// <summary>
        /// 
        /// </summary>
        public RoleModel()
        {
        }

        #endregion

        #region publicmethods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="roleID"></param>
        public usp_GetByPkId_Role_Result GetByPkIdRole(Nullable<global::System.Byte> roleID)
        {
            usp_GetByPkId_Role_Result retAns = null;

            if (roleID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_Role_Result>(ctx.usp_GetByPkId_Role(roleID, true))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Role_Result();
            }

            return retAns;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        public void FillRolesUserRole(Nullable<global::System.Int64> userID)
        {
            using (EFContext ctx = new EFContext())
            {
                Roles = new List<usp_GetRoles_UserRole_Result>(ctx.usp_GetRoles_UserRole(userID));
                return;
            }
        }

        #endregion
    }
    #endregion

    #region RoleSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class RoleSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Role_Result Role
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
                    Role = (new List<usp_GetByPkId_Role_Result>(ctx.usp_GetByPkId_Role(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (Role == null)
            {
                Role = new usp_GetByPkId_Role_Result();
            }

            EncryptAudit(Role.RoleID, Role.LastModifiedBy, Role.LastModifiedOn);
        }

        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter RoleID = ObjParam("Role");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_Role(Role.RoleCode, Role.RoleName, Role.Comment, Role.IsActive, LastModifiedBy, LastModifiedOn, pUserID, RoleID);

                if (HasErr(RoleID, ctx))
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

    #region RoleSearchModel

    public class RoleSearchModel : BaseSearchModel
    {
          # region Properties


       
        public List<usp_GetBySearch_Role_Result> Roles { get; set; }
       
    

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RoleSearchModel()
        {
        }

        #endregion

        #region  public methods

       

        #endregion


        #region Abstract Methods


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
                Roles = new List<usp_GetBySearch_Role_Result>(ctx.usp_GetBySearch_Role());
                //Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(StartBy, ClinicID));
            }
        }

        

        #endregion

        # region Private Method

        # endregion
    }


    #endregion


}
