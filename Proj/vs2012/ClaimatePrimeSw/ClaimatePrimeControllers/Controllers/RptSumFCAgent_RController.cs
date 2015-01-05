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
    public class RptSumFCAgent_RController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RptSumFCAgent_RController()
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

            return ResponseDotRedirect();
        }


        # endregion

        # region FullReport

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult FullReport()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);

            UserReportSearchModel objSearch = new UserReportSearchModel() { DateFrom = DateTime.Now.AddMonths(-1), DateTo = DateTime.Now };
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.AGENT_REPORT), true, ArivaSession.Sessions().SelAgentID, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }


        # endregion

        # region CompReport

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult CompReport()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);

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

            SummaryReportAgentModel objModel = new SummaryReportAgentModel();
            objModel.FillJs(ArivaSession.Sessions().UserID, new DateTime(Convert.ToInt32(pDtFrm.Substring(0, 4)), Convert.ToInt32(pDtFrm.Substring(4, 2)), Convert.ToInt32(pDtFrm.Substring(6, 2))), new DateTime(Convert.ToInt32(pDtTo.Substring(0, 4)), Convert.ToInt32(pDtTo.Substring(4, 2)), Convert.ToInt32(pDtTo.Substring(6, 2))));
            foreach (usp_GetReportSumAgent_PatientVisit_Result item in objModel.ReportSumAgentResults)
                {
                    retAns.Add((FusionChart)item);
                }
            

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDtFrm"></param>
        /// <param name="pDtTo"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallComp(string pDtFrm, string pDtTo)
        {
            List<FusionChart> retAns = new List<FusionChart>();

            SummaryReportAgentModel objModel = new SummaryReportAgentModel();
            objModel.FillJsComp(ArivaSession.Sessions().UserID, new DateTime(Convert.ToInt32(pDtFrm.Substring(0, 4)), Convert.ToInt32(pDtFrm.Substring(4, 2)), Convert.ToInt32(pDtFrm.Substring(6, 2))), new DateTime(Convert.ToInt32(pDtTo.Substring(0, 4)), Convert.ToInt32(pDtTo.Substring(4, 2)), Convert.ToInt32(pDtTo.Substring(6, 2))));
            foreach (usp_GetReportSumAgentComp_PatientVisit_Result item in objModel.ReportSumAgentCompResults)
            {
                retAns.Add((FusionChart)item);
            }


            return new JsonResultExtension { Data = retAns };
        }

        # endregion
    }
}
