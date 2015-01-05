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
    public class RptSumFCClinicWise_RController : BaseController
    {

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RptSumFCClinicWise_RController()
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
           
            ArivaSession.Sessions().SetProvider(0, string.Empty);
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().SetAgent(0, string.Empty);

            return ResponseDotRedirect();
        }


        # endregion

        # region SearchAjaxCall

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pSUMMARY_TYPE)
        {
            List<FusionChart> retAns = new List<FusionChart>();

            if (string.IsNullOrWhiteSpace(pSUMMARY_TYPE))
            {
                SummaryReportClinicModel objSearchModel = new SummaryReportClinicModel();
                objSearchModel.FillJs(ArivaSession.Sessions().SelClinicID);

                foreach (usp_GetReportSumClinic_PatientVisit_Result item in objSearchModel.ReportSumClinicResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("MONTHLY_"))
            {
                SummaryReportClinicModel objSearchModel = new SummaryReportClinicModel();
                objSearchModel.FillJs(ArivaSession.Sessions().SelClinicID, Convert.ToInt32(pSUMMARY_TYPE.Replace("MONTHLY_", string.Empty)));

                foreach (usp_GetReportSumYrClinic_PatientVisit_Result item in objSearchModel.ReportSumYrClinicResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("DAILY_"))
            {
                string[] tmps = pSUMMARY_TYPE.Split(Convert.ToChar("_"));
                SummaryReportClinicModel objSearchModel = new SummaryReportClinicModel();
                objSearchModel.FillJs(ArivaSession.Sessions().SelClinicID, Convert.ToInt32(tmps[1]), Convert.ToByte(tmps[2]));

                foreach (usp_GetReportSumMnClinic_PatientVisit_Result item in objSearchModel.ReportSumMnClinicResults)
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
