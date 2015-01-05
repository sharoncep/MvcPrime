using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class MenuEDIE_RController : BaseController
    {
        #region MenuEDI

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);
            MenuClaimSearchModel objMenuClaim = new MenuClaimSearchModel();

            objMenuClaim.GetCountEDI(ArivaSession.Sessions().SelClinicID, ArivaSession.Sessions().UserID);

            return ResponseDotRedirect(objMenuClaim);
        }

        #endregion
    }
}
