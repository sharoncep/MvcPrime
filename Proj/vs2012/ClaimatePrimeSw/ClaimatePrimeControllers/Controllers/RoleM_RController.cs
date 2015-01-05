using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class RoleM_RController : BaseController
    {
        #region Role

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);
           
            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            RoleSearchModel objSearchModel = new RoleSearchModel();
            objSearchModel.Fill(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

        #endregion
    }
}
