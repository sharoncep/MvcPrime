using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
/// <summary>
///                                             
/// </summary>  
    public class TeamMembers_RController: BaseController
    {
        #region TeamMembers

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            TeamMembersSearchModel objSearchModel = new TeamMembersSearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID };
            objSearchModel.Fill(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

        #endregion
    }
}
