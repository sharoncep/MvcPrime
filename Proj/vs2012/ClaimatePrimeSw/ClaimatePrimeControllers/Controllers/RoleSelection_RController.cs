using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class RoleSelection_RController : BaseHighRoleController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RoleSelection_RController()
        {
        }

        # endregion

        # region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);

            RoleModel objRoleSelection = new RoleModel();
            objRoleSelection.FillRolesUserRole(ArivaSession.Sessions().UserID);

            if (objRoleSelection.Roles.Count == 1)
            {
                if (val1 == 1)
                {
                    return ResponseDotRedirect("DashBoard");
                }

                return ResponseDotRedirect("Home", "SetRoleSession", 0, objRoleSelection.Roles[0].RoleID);
            }

            return ResponseDotRedirect(objRoleSelection);
        }

        # endregion
    }
}
