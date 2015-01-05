using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;

namespace ClaimatePrimeControllers.Controllers
{
    public class MenuB_RController : BaseController
    {
        #region MenuB

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);
            return ResponseDotRedirect();
        }

        #endregion
    }
}
