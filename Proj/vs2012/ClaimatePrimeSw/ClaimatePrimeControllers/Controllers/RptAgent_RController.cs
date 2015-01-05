using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;


namespace ClaimatePrimeControllers.Controllers
{
    public class RptAgent_RController : BaseController
    {
        # region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            return ResponseDotRedirect();

        }

        # endregion

        # region AgentNameList

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]

        public ActionResult AgentNameList()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);

            ArivaSession.Sessions().SetAgent(0, string.Empty);

            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            AgentReportSearchModel objSearchModel = new AgentReportSearchModel() { StartBy = stby, UserID = ArivaSession.Sessions().UserID };
            objSearchModel.Fill(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }
        # endregion       
    }
}
