using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls.Reports;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class RptProviderWise_RController : BaseController
    {
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
            UserReportSearchModel objSearch = new UserReportSearchModel();
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.PROVIDER_REPORT), false, ArivaSession.Sessions().SelProviderID, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReImport()
        {
            List<string> retAns = new List<string>();

            try
            {
                // http://www.dotnetperls.com/process-start
                // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
                string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                    , Convert.ToString(ArivaSession.Sessions().SelProviderID)
                                    , "1900", "1", "2"
                                    , "1900", "1", "1" };
                Process.Start(string.Concat(StaticClass.AppRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));
                Thread.Sleep(2100);

                retAns.Add(string.Empty);
            }
            catch (Exception ex)
            {
                retAns.Add(ex.ToString());
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult DownloadExcel()
        {

            UserReportSearchModel objU = new UserReportSearchModel();
            objU.Fill(ArivaSession.Sessions().UserID, Converts.AsInt16(Request.QueryString["ky"]));

            string xlPth = string.Concat(StaticClass.FileSvrRptRootPath, @"\", objU.ExcelResult.ExcelFileName);
            if (System.IO.File.Exists(xlPth))
            {
                return ResponseDotFile(xlPth);
            }

            return ResponseDotFile(string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.EXCEL_ICON));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>

        [AcceptVerbs(HttpVerbs.Post)]
        [ValidateInput(false)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "subSessionTimeOutRefresh")]
        public ActionResult RefreshSearch()
        {
            return Search();
        }

        # endregion

        # region DateWise

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult DateWise()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            UserReportSearchModel objSearch = new UserReportSearchModel() { DateFrom = DateTime.Now.AddMonths(-1), DateTo = DateTime.Now };
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.PROVIDER_REPORT), true, ArivaSession.Sessions().SelProviderID, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("DateWise")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult DateWise(UserReportSearchModel objModel)
        {
            // http://www.dotnetperls.com/process-start
            // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
            string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                    , Convert.ToString(ArivaSession.Sessions().SelProviderID)
                                    , objModel.DateFrom.Year.ToString(), objModel.DateFrom.Month.ToString(), objModel.DateFrom.Day.ToString()
                                    , objModel.DateTo.Year.ToString(), objModel.DateTo.Month.ToString(), objModel.DateTo.Day.ToString() };
            Process.Start(string.Concat(StaticClass.AppRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));
            Thread.Sleep(2100);

            return ResponseDotRedirect("RptProviderWise", "DateWise");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DateWiseAjax(string pKy)
        {
            List<string> retAns = new List<string>();
            UserReportSearchModel objModel = new UserReportSearchModel();
            try
            {
                // Ky & Session User Id ==> Sp ==> From To Date
                objModel.Fill(ArivaSession.Sessions().UserID, Converts.AsInt16(pKy));

                if ((objModel.ExcelResult.DateFrom.HasValue) && (objModel.ExcelResult.DateTo.HasValue))
                {
                    // http://www.dotnetperls.com/process-start
                    // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
                    string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                    , Convert.ToString(ArivaSession.Sessions().SelProviderID)
                                    , objModel.ExcelResult.DateFrom.Value.Year.ToString(), objModel.ExcelResult.DateFrom.Value.Month.ToString(), objModel.ExcelResult.DateFrom.Value.Day.ToString()
                                    , objModel.ExcelResult.DateTo.Value.Year.ToString(), objModel.ExcelResult.DateTo.Value.Month.ToString(), objModel.ExcelResult.DateTo.Value.Day.ToString() };
                    Process.Start(string.Concat(StaticClass.AppRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));
                    Thread.Sleep(2100);
                }
                else
                {
                    // http://www.dotnetperls.com/process-start
                    // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
                    string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                    , Convert.ToString(ArivaSession.Sessions().SelProviderID)
                                    , "1900", "1", "1"
                                    , "1900", "1", "31" };
                    Process.Start(string.Concat(StaticClass.AppRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));
                    Thread.Sleep(2100);
                }

                retAns.Add(string.Empty);
            }
            catch (Exception ex)
            {
                retAns.Add(ex.ToString());
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult DownloadDateExcel()
        {

            UserReportSearchModel objU = new UserReportSearchModel();
            objU.Fill(ArivaSession.Sessions().UserID, Converts.AsInt16(Request.QueryString["ky"]));

            string xlPth = string.Concat(StaticClass.FileSvrRptRootPath, @"\", objU.ExcelResult.ExcelFileName);
            if (System.IO.File.Exists(xlPth))
            {
                return ResponseDotFile(xlPth);
            }

            return ResponseDotFile(string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.EXCEL_ICON));
        }

        # endregion

        #region Reimport-Status

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReImportStatus(string pky)
        {
            UserReportSearchModel objDash = new UserReportSearchModel();
            List<ReportResult> retDash = new List<ReportResult>();

            objDash.Fill(ArivaSession.Sessions().UserID, Converts.AsInt16(pky));

            retDash.Add((ReportResult)objDash.ExcelResult);

            return new JsonResultExtension { Data = retDash };
        }
        #endregion
    }
}
