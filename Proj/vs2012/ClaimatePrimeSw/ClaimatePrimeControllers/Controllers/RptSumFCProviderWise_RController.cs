
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
    public class RptSumFCProviderWise_RController : BaseController
    {

         # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RptSumFCProviderWise_RController()
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
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().SetAgent(0, string.Empty);
            return ResponseDotRedirect();
        }


        # endregion

        # region SearchAjaxCall

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSUMMARY_TYPE"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pSUMMARY_TYPE)
        {
            List<FusionChart> retAns = new List<FusionChart>();
            SummaryReportProviderModel objSearchModel = new SummaryReportProviderModel();
            if (string.IsNullOrWhiteSpace(pSUMMARY_TYPE))
            {

                objSearchModel.FillJs(Convert.ToInt32(ArivaSession.Sessions().SelProviderID));

                foreach (usp_GetReportSumProvider_PatientVisit_Result item in objSearchModel.ReportSumProviderResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("MONTHLY_"))
            {

                objSearchModel.FillJs(Convert.ToInt32(ArivaSession.Sessions().SelProviderID), Convert.ToInt32(pSUMMARY_TYPE.Replace("MONTHLY_", string.Empty)));

                foreach (usp_GetReportSumYrProvider_PatientVisit_Result item in objSearchModel.ReportSumYrProviderResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("DAILY_"))
            {
                string[] tmps = pSUMMARY_TYPE.Split(Convert.ToChar("_"));

                objSearchModel.FillJs(Convert.ToInt32(ArivaSession.Sessions().SelProviderID), Convert.ToInt32(tmps[1]), Convert.ToByte(tmps[2]));

                foreach (usp_GetReportSumMnProvider_PatientVisit_Result item in objSearchModel.ReportSumMnProviderResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else
            {
            }

            return new JsonResultExtension { Data = retAns };
        }

        # endregion






    }
}
