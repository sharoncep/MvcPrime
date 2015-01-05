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
    /// By Sai:Manager Role - Case Agent - For assigning agents to a particular case(only for the cases that are not closed)
    /// of the clinics assigned to those managers
    /// </summary>
    public class CaseAgentM_URController : BaseController
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

            ClaimsAgentModel objSearchModel = new ClaimsAgentModel() { ClinicID = ArivaSession.Sessions().SelClinicID };
            //objSearchModel.FillDates();
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
        public ActionResult Search(ClaimsAgentModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                return ResponseDotRedirect(objSearchModel);
            }

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
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
        public ActionResult Save(ClaimsAgentModel objSearchModel)
        {
            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSearchModel.Comments = string.Concat("Sys Gen : ", StaticClass.CsResources("VisitNewCmts"));

            if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive()))
            {
                return ResponseDotRedirect("ClinicSetUpM", "Search", 0, 1);
            }
            else
            {
                if (objSearchModel.ErrorMsg == "BA EMPTY")
                {
                    ViewBagDotErrMsg = 2;
                }
                else if (objSearchModel.ErrorMsg == "BA & QA EMPTY")
                {
                    ViewBagDotErrMsg = 3;
                }
                else if (objSearchModel.ErrorMsg == "BA & QA & EA EMPTY")
                {
                    ViewBagDotErrMsg = 4;
                }
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSearchModel);
        }

        #endregion
    }
}
