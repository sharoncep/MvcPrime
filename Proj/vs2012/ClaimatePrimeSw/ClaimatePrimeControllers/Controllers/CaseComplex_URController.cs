using System;
using System.Collections.Generic;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// By Sai : Manager Role : Case Complexity
    /// </summary>
    public class CaseComplex_URController : BaseController
    {
       
        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int64>(0);

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            if (val2 == 1)
            {
                ViewBagDotSuccMsg = 1;
            }
            else if (val2 == 101)
            {
                // 1 to 100 Success
                // 101+ Errors
            }
            else
            {
                ViewBagDotReset();
            }

            # endregion

            CaseComplexitySearchModel objSearchModel = new CaseComplexitySearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID  };
            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Search(CaseComplexitySearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                return ResponseDotRedirect(objSearchModel);
            }

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
          //  objSearchModel.OrderByField = "DOS";

            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(CaseComplexitySearchModel objSearchModel)
        {
            if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive()))
            {
                return ResponseDotRedirect("ClinicSetUpM", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSearchModel);
        }
        #endregion
    }
}
