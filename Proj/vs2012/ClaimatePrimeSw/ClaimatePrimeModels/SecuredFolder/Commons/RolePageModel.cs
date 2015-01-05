using System;
using System.Collections.Generic;
using System.Linq;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.SecuredFolder.Commons
{
    /// <summary>
    /// 
    /// </summary>
    public class RolePageModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 PageID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String ControllerName { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SessionName { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String Permission { get; private set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RolePageModel()
        {

        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="roleID"></param>
        /// <param name="ctrlName"></param>
        /// <returns></returns>
        public static RolePageModel GetRolePage(byte roleID, string ctrlName)
        {
            RolePageModel retAns = new RolePageModel();

            if ((roleID > 0) && (!(string.IsNullOrWhiteSpace(ctrlName))))
            {
                usp_GetByPage_PageRole_Result spRes;

                using (EFContext ctx = new EFContext())
                {
                    spRes = (new List<usp_GetByPage_PageRole_Result>(ctx.usp_GetByPage_PageRole(roleID, ctrlName))).FirstOrDefault();

                    if (spRes == null)
                    {
                        retAns.Permission = string.Concat("Controller Name: ", ctrlName, " ___xNOPERMISSIONx___ ", "Role Name: ", Converts.AsEnum<Role>(roleID));
                        throw new Exception(retAns.Permission);
                    }
                    else
                    {
                        retAns.PageID = spRes.PageID;
                        retAns.ControllerName = spRes.ControllerName;
                        retAns.SessionName = spRes.SessionName;
                        retAns.Permission = string.Concat((spRes.CreatePermission ? "C" : string.Empty), (spRes.UpdatePermission ? "U" : string.Empty), (spRes.ReadPermission ? "R" : string.Empty), (spRes.DeletePermission ? "D" : string.Empty));

                        if (string.IsNullOrWhiteSpace(retAns.Permission))
                        {
                            retAns.Permission = string.Concat("Controller Name: ", ctrlName, " ___xNOPERMISSIONx___ ", "Role Name: ", Converts.AsEnum<Role>(roleID));
                            throw new Exception(retAns.Permission);
                        }
                    }
                }
            }

            return retAns;
        }

        #endregion
    }
}
