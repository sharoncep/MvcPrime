using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.AjaxCalls.Reports;

namespace ClaimatePrimeControllers.Controllers
{
    public class RptClinic_RController : BaseController
    {
        #region ClinicWise

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
            ArivaSession.Sessions().SetAgent(0, string.Empty);

            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            ClinicSearchModel objSearchModel = new ClinicSearchModel() { StartBy = stby, UserID = ArivaSession.Sessions().UserID };
            objSearchModel.Fill(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

        # region SearchAll

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SearchAll()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().SetProvider(0, string.Empty);
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().SetAgent(0, string.Empty);

            UserReportSearchModel objSearch = new UserReportSearchModel();
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.CLINIC_REPORT), false, null, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ReImportAll()
        {
            List<string> retAns = new List<string>();

            try
            {
                // http://www.dotnetperls.com/process-start
                // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
                string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                    , "0"
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
        public ActionResult DownloadExcelAll()
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

        # region DateWiseAll

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult DateWiseAll()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().SetProvider(0, string.Empty);
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().SetAgent(0, string.Empty);


            UserReportSearchModel objSearch = new UserReportSearchModel() { DateFrom = DateTime.Now.AddMonths(-1), DateTo = DateTime.Now };
            objSearch.Fill(ArivaSession.Sessions().UserID, Convert.ToByte(ExcelReportType.CLINIC_REPORT), true, null, DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff));

            return ResponseDotRedirect(objSearch);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("DateWiseAll")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult DateWiseAll(UserReportSearchModel objModel)
        {
            // http://www.dotnetperls.com/process-start
            // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
            string[] args = { Convert.ToString(ArivaSession.Sessions().UserID)
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                    , "0"
                                    , objModel.DateFrom.Year.ToString(), objModel.DateFrom.Month.ToString(), objModel.DateFrom.Day.ToString()
                                    , objModel.DateTo.Year.ToString(), objModel.DateTo.Month.ToString(), objModel.DateTo.Day.ToString() };
            Process.Start(string.Concat(StaticClass.AppRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));
            Thread.Sleep(2100);

            return ResponseDotRedirect("RptClinic", "DateWiseAll");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DateWiseAllAjax(string pKy)
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
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                    , "0"
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
                                    , Convert.ToString(Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                    , "0"
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
        public ActionResult DownloadDateExcelAll()
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
