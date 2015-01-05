using System;
using System.Collections.Generic;
using System.Web.Mvc;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeConstants;

namespace ClaimatePrimeControllers.Controllers
{
    public class RptSumFCAgentWise_RController : BaseController
    {

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RptSumFCAgentWise_RController()
        {
        }

        # endregion

        # region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().SetProvider(0, string.Empty);
            ArivaSession.Sessions().SetPatient(0, string.Empty);

            UserReportSearchModel objSearch = new UserReportSearchModel() { DateFrom = DateTime.Now.AddMonths(-1), DateTo = DateTime.Now };
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.AGENT_REPORT), true, ArivaSession.Sessions().SelAgentID, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }

        # endregion

        # region Ajax Calls

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDtFrm"></param>
        /// <param name="pDtTo"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pDtFrm, string pDtTo)
        {
            List<FusionChart> retAns = new List<FusionChart>();

            SummaryReportAgentWiseModel objModel = new SummaryReportAgentWiseModel();
            objModel.FillJs(ArivaSession.Sessions().SelAgentID, new DateTime(Convert.ToInt32(pDtFrm.Substring(0, 4)), Convert.ToInt32(pDtFrm.Substring(4, 2)), Convert.ToInt32(pDtFrm.Substring(6, 2))), new DateTime(Convert.ToInt32(pDtTo.Substring(0, 4)), Convert.ToInt32(pDtTo.Substring(4, 2)), Convert.ToInt32(pDtTo.Substring(6, 2))));
            foreach (usp_GetReportSumAgentWise_PatientVisit_Result item in objModel.ReportSumAgentWiseResults)
            {
                retAns.Add((FusionChart)item);
            }


            return new JsonResultExtension { Data = retAns };
        }
        # endregion

    }
}
