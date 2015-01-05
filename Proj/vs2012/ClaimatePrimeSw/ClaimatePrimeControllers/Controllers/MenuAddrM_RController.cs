using System;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;

namespace ClaimatePrimeControllers.Controllers
{
    public class MenuAddrM_RController : BaseController
    {
        #region ManagerMenuAddress

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);
            return ResponseDotRedirect();
        }

        #endregion
    }
}
