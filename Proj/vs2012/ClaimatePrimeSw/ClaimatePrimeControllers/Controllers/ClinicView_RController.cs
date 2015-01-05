using System;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class ClinicView_RController : BaseController
    {
        #region ClinicView

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            // validate clinic count

            ClinicSearchModel objSearchModel = new ClinicSearchModel() { UserID = ArivaSession.Sessions().UserID };
            objSearchModel.FillClinicCount();

            if (objSearchModel.ClinicCount.CLINIC_COUNT == 1)
            {
                if (val1 == 1)
                {
                    return ResponseDotRedirect("RoleSelection", "Search", 1, 0);
                }

                objSearchModel.Fill(IsActive());
                return ResponseDotRedirect("Home", "SetClinicSession", 0, Convert.ToUInt32(objSearchModel.Clinic[0].ClinicID));
            }

            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            objSearchModel = new ClinicSearchModel() { StartBy = stby, UserID = ArivaSession.Sessions().UserID };
            objSearchModel.Fill(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

        #endregion
    }
}
