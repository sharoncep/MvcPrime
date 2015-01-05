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
    public class RptSumFCClinic_RController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RptSumFCClinic_RController()
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
            SummaryReportAllClinicModel objSearchModel = new SummaryReportAllClinicModel();

            if (string.IsNullOrWhiteSpace(pSUMMARY_TYPE))
            {
                
                objSearchModel.FillJs(ArivaSession.Sessions().UserID);

                foreach (usp_GetReportSum_PatientVisit_Result item in objSearchModel.ReportSumResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("MONTHLY_"))
            {
               
                objSearchModel.FillJs(ArivaSession.Sessions().UserID, Convert.ToInt32(pSUMMARY_TYPE.Replace("MONTHLY_", string.Empty)));

                foreach (usp_GetReportSumYr_PatientVisit_Result item in objSearchModel.ReportSumYrResults)
                {
                    retAns.Add((FusionChart)item);
                }
            }
            else if (pSUMMARY_TYPE.StartsWith("DAILY_"))
            {
                string[] tmps = pSUMMARY_TYPE.Split(Convert.ToChar("_"));
              
                objSearchModel.FillJs(ArivaSession.Sessions().UserID, Convert.ToInt32(tmps[1]), Convert.ToByte(tmps[2]));

                foreach (usp_GetReportSumMn_PatientVisit_Result item in objSearchModel.ReportSumMnResults)
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
