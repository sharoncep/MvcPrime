using System;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ClinicAllRpt_RController : BaseController
    {
        # region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            return ResponseDotRedirect();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ReImport()
        {
            return ResponseDotRedirect("ClinicAllRpt");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult DownloadExcel()
        {
            return ResponseDotFile("");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "subSessionTimeOutRefresh")]
        public ActionResult RefreshSearch()
        {
            return Search();
        }

        # endregion
    }
}
