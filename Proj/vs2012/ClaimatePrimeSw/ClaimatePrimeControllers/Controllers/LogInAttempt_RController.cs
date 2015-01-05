using System;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class LogInAttempt_RController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public LogInAttempt_RController()
        {
        }

        # endregion

        # region Search

        /// <summary>
        /// http://stackoverflow.com/questions/938764/clear-request-isauthenticated-value-after-signout-without-redirecttoaction
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);

            LoginAttemptsModel objLoginAttempts = new LoginAttemptsModel();
            objLoginAttempts.GetRecentLogInTrial(ArivaSession.Sessions().UserEmail);


            objLoginAttempts.GetRecentLogInLogOut(ArivaSession.Sessions().UserID);

            objLoginAttempts.GetRecentLockUnLock(ArivaSession.Sessions().UserID);

            return ResponseDotRedirect(objLoginAttempts);
        }

        # endregion
    }
}
