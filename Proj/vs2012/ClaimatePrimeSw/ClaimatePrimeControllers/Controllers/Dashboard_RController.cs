using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.AjaxCalls.AsgnClaims;
using ClaimatePrimeControllers.AjaxCalls.Dashboard;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using System.Threading;

namespace ClaimatePrimeControllers.Controllers
{
    public class Dashboard_RController : BaseHighRoleController
    {
        static string DESC;
        static string DAY_COUNT;

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Dashboard_RController()
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

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            if (val1 == 1)
            {
                // Change Pwd Alert Verification Function required here

                ViewBagDotErrMsg = 1;
            }

            # endregion

            DashBoardModel objSearchModel = new DashBoardModel();
            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

        # endregion

        # region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            DESC = Request.QueryString["desc"];
            DAY_COUNT = Request.QueryString["dayCount"];

            DashBoardModel objSearchModel = new DashBoardModel();

            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("DashBoard", "Display");
            }
            //objSearchModel.getDashboardVisit(ArivaSession.Sessions().UserID, desc, dayCount);

            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Save(DashBoardModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                //ArivaSession.Sessions().SetClinic(0, string.Empty);

                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("DashBoard", "Display");
            }
            return ResponseDotRedirect(objSearchModel);
        }

        # endregion

        #region Display

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Display()
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());

            PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
            objVisit.SelClinicDispName = spRes.CLINIC_NAME_CODE;

            AssignedClaimSaveModel objSaveModel = new AssignedClaimSaveModel();
            objSaveModel.Fill(IsActive());

            return ResponseDotRedirect(objSaveModel);
        }

        #endregion

        #region Notification

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Notification()
        {
            DESC = Request.QueryString["desc"];
            DAY_COUNT = Request.QueryString["dayCount"];

            DashBoardModel objSearchModel = new DashBoardModel();
            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Notification")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Notification(DashBoardModel objSearchModel)
        {
            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

        #region NotificationClinic

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NotificationClinic()
        {
            DESC = Request.QueryString["desc"];
            DAY_COUNT = Request.QueryString["dayCount"];

            DashBoardModel objSearchModel = new DashBoardModel();
            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("NotificationClinic")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult NotificationClinic(DashBoardModel objSearchModel)
        {
            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

        # region SaveExcel

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveExcel()
        {
            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];

            ExcelSheetColDash objEx = new ExcelSheetColDash();
            string xlsxPath = objEx.GetXlsxPath(ArivaSession.Sessions().UserID, StaticClass.FileSvrRptRootPath);
            objEx.FillDashboard((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("RptExlSubjDash").Replace("[X]", desc.ToUpper()), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName);
            ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.GetDataDashboard(ArivaSession.Sessions().UserID, desc, dayCount));

            return ResponseDotFile(xlsxPath);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveExcelNotification()
        {

            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];

            ExcelSheetColDash objEx = new ExcelSheetColDash();

            string xlsxPath = objEx.GetXlsxPath(ArivaSession.Sessions().UserID, StaticClass.FileSvrRptRootPath);

            if (desc == "ROLE")
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("UsersWithoutRole"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 1);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.getUsersWithoutRole(), 1);
            }
            else if (desc == "CLINIC")
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("UsersWithoutClinic"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 1);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.getUsersWithoutClinic(), 1);
            }
            else if (desc == "AGENT")
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("ManagerWithoutAgent"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 1);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.getManagerWithoutAgent(Convert.ToByte(Role.MANAGER_ROLE_ID)), 1);
            }
            else if (desc == "MANAGER")
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("ClinicsWithoutManager"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 0);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.getClinicsWithoutManager(Convert.ToByte(Role.MANAGER_ROLE_ID)), 0);
            }
            else if (desc == "MULTI_MANAGER")
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("ClinicsWithMultiManager"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 0);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.getClinicsWithMultiManager(Convert.ToByte(Role.MANAGER_ROLE_ID)), 0);
            }
            else
            {
                objEx.FillNotification((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("AssignedClinics"), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName, 0);
                ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.GetAgentClinic(ArivaSession.Sessions().UserID), 0);
            }

            return ResponseDotFile(xlsxPath);
        }

        # endregion

        # region SavePdf

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePdf()
        {
            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];
            DashBoardModel objSearchModel = new DashBoardModel();
            objSearchModel.getDashboardPdfVisit(ArivaSession.Sessions().UserID, desc, dayCount);

            return ResponseDotBinary("pdf", desc + " - " + dayCount, "SavePdf", objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePdfNotification()
        {
            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];
            DashBoardModel objSearchModel = new DashBoardModel();

            if (desc == "ROLE")
            {
                objSearchModel.getUsersWithoutRolePdf();
                return ResponseDotBinary("pdf", desc, "SavePdfUsersWithoutRole", objSearchModel);
            }
            else if (desc == "CLINIC")
            {
                objSearchModel.getUsersWithoutClinicPdf();
                return ResponseDotBinary("pdf", desc, "SavePdfUsersWithoutClinic", objSearchModel);
            }
            else if (desc == "AGENT")
            {
                objSearchModel.getManagerWithoutAgentPdf(Convert.ToByte(Role.MANAGER_ROLE_ID));
                return ResponseDotBinary("pdf", desc, "SavePdfManagerWithoutAgent", objSearchModel);
            }
            else if (desc == "MANAGER")
            {
                objSearchModel.getClinicsWithoutManagerPdf(Convert.ToByte(Role.MANAGER_ROLE_ID));
                return ResponseDotBinary("pdf", desc, "SavePdfClinicsWithoutManager", objSearchModel);
            }
            else if (desc == "MULTI_MANAGER")
            {
                objSearchModel.getClinicsWithMultiManagerPdf(Convert.ToByte(Role.MANAGER_ROLE_ID));
                return ResponseDotBinary("pdf", desc, "SavePdfClinicsWithMultiManager", objSearchModel);
            }
            else
            {
                objSearchModel.GetAgentClinicPdf(ArivaSession.Sessions().UserID);
                return ResponseDotBinary("pdf", desc, "SavePdfAgentClinic", objSearchModel);
            }
        }

        # endregion

        #region SearchAjaxCalls

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallDash()
        {
            DashBoardModel objDash = new DashBoardModel();
            List<DashTableResult> retDash = new List<DashTableResult>();

            objDash.FillDashboardCount(ArivaSession.Sessions().UserID, IsActive(false));

            foreach (usp_GetDashboardSummary_PatientVisit_Result item in objDash.DashboardCount)
            {
                retDash.Add((DashTableResult)item);
            }

            return new JsonResultExtension { Data = retDash };

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallTotalDash()
        {
            DashBoardModel objDash = new DashBoardModel();
            List<SearchResult> retDash = new List<SearchResult>();

            objDash.GetTotalDashCount(ArivaSession.Sessions().UserID);

            retDash.Add((SearchResult)objDash.DashboardCountNIT);

            return new JsonResultExtension { Data = retDash };

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallNotificationCount()
        {
            DashBoardModel objDash = new DashBoardModel();

            List<SearchResult> retDash = new List<SearchResult>();
            if (ArivaSession.Sessions().HighRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID))
            {
                objDash.GetCountUsersWithoutRole(ArivaSession.Sessions().UserID);
                objDash.GetCountUsersWithOutClinic(ArivaSession.Sessions().UserID);
                objDash.ManagerWithoutAgentCount = new usp_GetNotificationCountAgent_User_Result() { ID = 0, MANAGER_COUNT = -1 };
                objDash.ClinicsWithoutManagerCount = new usp_GetNotificationCountManager_UserClinic_Result() { CLINIC_COUNT = -1, ID = 0 };
                objDash.ClinicsWithMultiManagerCount = new usp_GetNotificationCountMultiManager_UserClinic_Result() { CLINIC_COUNT = -1, SN = 0 };
                objDash.AgentClinicCount = new usp_GetNotificationCountAgentClinic_UserClinic_Result() { ID = 0, CLINIC_COUNT = -1 };
            }
            else if (ArivaSession.Sessions().HighRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID))
            {
                objDash.GetCountUsersWithoutRole(ArivaSession.Sessions().UserID);
                objDash.GetCountUsersWithOutClinic(ArivaSession.Sessions().UserID);
                objDash.GetCountManagerWithoutAgent(ArivaSession.Sessions().UserID);
                objDash.GetCountClinicsWithoutManager(ArivaSession.Sessions().UserID);
                objDash.GetCountClinicsWithMultiManager();
                objDash.AgentClinicCount = new usp_GetNotificationCountAgentClinic_UserClinic_Result() { ID = 0, CLINIC_COUNT = -1 };
            }
            else
            {
                objDash.UsersWithoutRoleCount = new usp_GetNotificationCountRole_UserRole_Result() { ID = 0, USER_ROLE_COUNT = -1 };
                objDash.UsersWithOutClinicCount = new usp_GetNotificationCountClinic_UserClinic_Result() { ID = 0, USER_COUNT = -1 };
                objDash.ManagerWithoutAgentCount = new usp_GetNotificationCountAgent_User_Result() { ID = 0, MANAGER_COUNT = -1 };
                objDash.ClinicsWithoutManagerCount = new usp_GetNotificationCountManager_UserClinic_Result() { CLINIC_COUNT = -1, ID = 0 };
                objDash.ClinicsWithMultiManagerCount = new usp_GetNotificationCountMultiManager_UserClinic_Result() { CLINIC_COUNT = -1, SN = 0 };
                objDash.GetCountAgentClinic(ArivaSession.Sessions().UserID);
            }

            retDash.Add((SearchResult)objDash);

            return new JsonResultExtension { Data = retDash };

        }

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
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            DashBoardModel objSearchModel = new DashBoardModel()
            {
                SearchName = pSearchName
                ,
                DateFrom = Converts.AsDateTimeNullable(pDateFrom)
                ,
                DateTo = Converts.AsDateTimeNullable(pDateTo)
                ,
                StartBy = pStartBy
                ,
                OrderByDirection = pOrderByDirection
                ,
                OrderByField = pOrderByField
            };

            objSearchModel.getDashboardVisit(ArivaSession.Sessions().UserID, DESC, DAY_COUNT, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetDashboardVisit_PatientVisit_Result item in objSearchModel.DashboardVisit)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pDateFrom"></param>
        /// <param name="pDateTo"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallNotification(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            DashBoardModel objSearchModel = new DashBoardModel()
            {
                SearchName = pSearchName
                ,
                DateFrom = Converts.AsDateTimeNullable(pDateFrom)
                ,
                DateTo = Converts.AsDateTimeNullable(pDateTo)
                ,
                StartBy = pStartBy
                ,
                OrderByDirection = pOrderByDirection
                ,
                OrderByField = pOrderByField
            };

            List<SearchResult> retAns = new List<SearchResult>();

            if (DESC == "ROLE")
            {
                objSearchModel.GetUsersWithoutRole(ArivaSession.Sessions().UserID, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationRole_UserRole_Result item in objSearchModel.UsersWithoutRole)
                {
                    retAns.Add((SearchResult)item);
                }
            }
            else if (DESC == "CLINIC")
            {
                objSearchModel.GetUsersWithOutClinic(ArivaSession.Sessions().UserID, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationClinic_UserClinic_Result item in objSearchModel.UsersWithOutClinic)
                {
                    retAns.Add((SearchResult)item);
                }
            }
            else if (DESC == "AGENT")
            {
                objSearchModel.GetManagerWithoutAgent(ArivaSession.Sessions().UserID, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationAgent_User_Result item in objSearchModel.ManagerWithoutAgent)
                {
                    retAns.Add((SearchResult)item);
                }
            }
            else if (DESC == "MANAGER")
            {
                objSearchModel.GetClinicsWithoutManager(ArivaSession.Sessions().UserID, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationManager_UserClinic_Result item in objSearchModel.ClinicsWithoutManager)
                {
                    retAns.Add((SearchResult)item);
                }
            }
            else if (DESC == "MULTI_MANAGER")
            {
                objSearchModel.GetClinicsWithMultiManager(Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationMultiManager_UserClinic_Result item in objSearchModel.ClinicsWithMultiManager)
                {
                    retAns.Add((SearchResult)item);
                }
            }
            else if (DESC == "AGENT_CLINIC")
            {
                objSearchModel.GetAgentClinic(ArivaSession.Sessions().UserID, Converts.AsInt64(pCurrPageNumber), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

                foreach (usp_GetNotificationAgentClinic_UserClinic_Result item in objSearchModel.AgentClinic)
                {
                    retAns.Add((SearchResult)item);
                }
            }

            return new JsonResultExtension { Data = retAns };
        }

        #endregion

        #region SaveAjaxCall
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCall(string pKy)
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());
            string filePath = string.Empty;
            PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
            objVisit.SelClinicDispName = spRes.CLINIC_NAME_CODE;

            #region Visit

            if (string.Compare(pKy, "Visit", true) == 0)
            {
                objVisit.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                # region Doc Note

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objVisit.PatientVisitResult.DoctorNoteRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_DOCTOR_NOTE);
                }
                System.IO.File.Copy(filePath, string.Concat(StaticClass.AppRootPath, @"\ReportTmp\DN", ArivaSession.Sessions().UserID, ".pdf"), true);
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                # region Super Bill

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objVisit.PatientVisitResult.SuperBillRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_SUPER_BILL);
                }
                System.IO.File.Copy(filePath, string.Concat(StaticClass.AppRootPath, @"\ReportTmp\SB", ArivaSession.Sessions().UserID, ".pdf"), true);
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<VisitResult> retVisit = new List<VisitResult>();
                retVisit.Add((VisitResult)objVisit);

                return new JsonResultExtension { Data = retVisit };
            }

            #endregion

            #region PrimaryDx

            if (string.Compare(pKy, "Dxprimary", true) == 0)
            {

                objVisit.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                List<VisitResult> retVisit = new List<VisitResult>();
                retVisit.Add((VisitResult)objVisit);

                return new JsonResultExtension { Data = retVisit };
            }

            #endregion

            #region CPT

            if (string.Compare(pKy, "CPT", true) == 0)
            {
                ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { };

                List<ProcedureResult> retPro = new List<ProcedureResult>();

                objSaveModel.fillCPTBA(ArivaSession.Sessions().PageEditID<long>());

                foreach (usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResultBA)
                {
                    retPro.Add((ProcedureResult)item);
                }

                return new JsonResultExtension { Data = retPro };
            }

            #endregion

            #region Notes

            if (string.Compare(pKy, "Notes", true) == 0)
            {
                ClaimProcessNoteModel objNoteModel = new ClaimProcessNoteModel();
                List<NoteResult> retNotes = new List<NoteResult>();
                objNoteModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                foreach (usp_GetCommentByID_ClaimProcess_Result item in objNoteModel.Comments)
                {
                    retNotes.Add((NoteResult)item);
                }
                return new JsonResultExtension { Data = retNotes };

            }

            #endregion

            #region Pat Docs

            if (string.Compare(pKy, "PatientDoc", true) == 0)
            {
                PatientDocumentViewModel objPatDocModel = new PatientDocumentViewModel();
                List<PatDocResult> retPatDoc = new List<PatDocResult>();
                objPatDocModel.Fill(spRes.PatientID, IsActive());

                foreach (usp_GetByPatientID_PatientDocument_Result item in objPatDocModel.PatDocumentResult)
                {
                    # region Photo

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.DocumentRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientDocumentID_", item.PatientDocumentID), filePath);

                    # endregion

                    retPatDoc.Add((PatDocResult)item);
                }
                return new JsonResultExtension { Data = retPatDoc };

            }

            #endregion

            #region Patient

            if (string.Compare(pKy, "Patient", true) == 0)
            {
                PatientDemographySaveModel objPatient = new PatientDemographySaveModel();
                objPatient.Fill(spRes.PatientID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objPatient.PatientResult.PhotoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<PatientResult> retPatient = new List<PatientResult>();
                retPatient.Add((PatientResult)objPatient);

                return new JsonResultExtension { Data = retPatient };
            }

            #endregion

            #region Claim Status

            if (string.Compare(pKy, "Claim", true) == 0)
            {
                ClaimProcessStatusModel objStatusModel = new ClaimProcessStatusModel();
                List<StatusResult> retStatus = new List<StatusResult>();
                objStatusModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                foreach (usp_GetByPatientVisitID_ClaimProcess_Result item in objStatusModel.pClaimProcess)
                {
                    # region RefFile

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.RefFileRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("RefFileID_", item.ClaimProcessEDIFileID), filePath);

                    # endregion

                    # region X12File

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.X12FileRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("X12FileID_", item.ClaimProcessEDIFileID), filePath);

                    # endregion

                    retStatus.Add((StatusResult)item);
                }
                return new JsonResultExtension { Data = retStatus };

            }

            #endregion

            #region EDI SETTINGS

            if (string.Compare(pKy, "Settings", true) == 0)
            {
                EDISettingsModel objEDI = new EDISettingsModel();
                objEDI.Fill(spRes.PatientID, IsActive());

                List<EDISettingsResult> retEDI = new List<EDISettingsResult>();
                retEDI.Add((EDISettingsResult)objEDI);

                return new JsonResultExtension { Data = retEDI };
            }

            #endregion

            #region Ipa

            if (string.Compare(pKy, "Ipa", true) == 0)
            {
                BillingIPAModel objIpa = new BillingIPAModel();
                objIpa.Fill(spRes.CLINIC_ID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objIpa.IPA_Result.LogoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<IpaResult> retIpa = new List<IpaResult>();
                retIpa.Add((IpaResult)objIpa);

                return new JsonResultExtension { Data = retIpa };
            }

            #endregion

            #region Practice/Clinic

            if (string.Compare(pKy, "Clinic", true) == 0)
            {
                BillingClinicViewModel objClinic = new BillingClinicViewModel();
                objClinic.Fill(spRes.CLINIC_ID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objClinic.ClinicResult.LogoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<ClinicResult> retClinic = new List<ClinicResult>();
                retClinic.Add((ClinicResult)objClinic);

                return new JsonResultExtension { Data = retClinic };
            }

            #endregion

            #region Provider
            if (string.Compare(pKy, "Provider", true) == 0)
            {
                ClaimProviderModel objProvider = new ClaimProviderModel();
                objProvider.Fill(spRes.PatientID, IsActive());
                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objProvider.Provider_Result.PhotoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<ProviderResult> retProvider = new List<ProviderResult>();
                retProvider.Add((ProviderResult)objProvider);

                return new JsonResultExtension { Data = retProvider };
            }
            #endregion

            #region Insurance
            if (string.Compare(pKy, "Insurance", true) == 0)
            {
                ClaimInsuranceModel objInsurance = new ClaimInsuranceModel();
                objInsurance.Fill(spRes.PatientID, IsActive());

                List<InsuranceResult> retInsurance = new List<InsuranceResult>();
                retInsurance.Add((InsuranceResult)objInsurance);

                return new JsonResultExtension { Data = retInsurance };
            }
            #endregion

            List<string> retAns = new List<string>();
            retAns.Add(string.Concat("Ajax Call Done: SaveAjaxCall: ", pKy));



            return new JsonResultExtension { Data = retAns };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallCpt(string pKy)
        {
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { pDescType = pKy };

            List<ProcedureResult> retPro = new List<ProcedureResult>();

            objSaveModel.fillCPTBA(ArivaSession.Sessions().PageEditID<long>());

            foreach (usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResultBA)
            {
                retPro.Add((ProcedureResult)item);
            }

            return new JsonResultExtension { Data = retPro };
        }


        #region DX
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallDx(string pKy)
        {
            ClaimDiagnosisSaveModel objSaveModel = new ClaimDiagnosisSaveModel();

            List<DxResult> retDx = new List<DxResult>();

            objSaveModel.FillClaimDiagnosis(ArivaSession.Sessions().PageEditID<long>(), pKy);

            foreach (usp_GetByPatientVisit_ClaimDiagnosis_Result item in objSaveModel.ClaimDiagnosisResults)
            {
                retDx.Add((DxResult)item);
            }

            return new JsonResultExtension { Data = retDx };
        }
        #endregion
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallFacilityDone(string pKy)
        {
            FacilityDoneViewModel objSaveModel = new FacilityDoneViewModel();


            objSaveModel.Fill(Converts.AsInt32(pKy), IsActive(true));
            List<FacilityDoneResult> retFacility = new List<FacilityDoneResult>();

            retFacility.Add((FacilityDoneResult)objSaveModel);

            return new JsonResultExtension { Data = retFacility };

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallPrevVisits(string pKy)
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());

            PreviousVisitViewModel objSaveModel = new PreviousVisitViewModel() { CurrDOS = Converts.AsDateTime(pKy), PatientVisitID = ArivaSession.Sessions().PageEditID<long>() };

            List<PrevVisitResult> retPrevVisit = new List<PrevVisitResult>();


            objSaveModel.Fill(spRes.PatientID, IsActive());

            foreach (usp_GetPrevVisit_PatientVisit_Result item in objSaveModel.AllDOSResult)
            {
                retPrevVisit.Add((PrevVisitResult)item);
            }

            return new JsonResultExtension { Data = retPrevVisit };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult GetPrevVisitsDetails(string pKy)
        {
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel();

            List<ProcedureResult> retPro = new List<ProcedureResult>();


            objSaveModel.fillCPT(Converts.AsInt64(pKy));

            foreach (usp_GetByPatientVisit_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResult)
            {
                retPro.Add((ProcedureResult)item);
            }

            return new JsonResultExtension { Data = retPro };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallPrevStatus(string pKy)
        {
            string filePath = string.Empty;

            ClaimProcessStatusModel objStatusModel = new ClaimProcessStatusModel();
            List<StatusResult> retPrevStatus = new List<StatusResult>();
            objStatusModel.GetPrevStatus(Converts.AsInt64(pKy));

            foreach (usp_GetByPatientVisitID_ClaimProcess_Result item in objStatusModel.pClaimProcess)
            {
                # region RefFile

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.RefFileRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    item.RefFileRelPath = string.Empty;
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("RefFileID_", item.ClaimProcessEDIFileID), filePath);

                # endregion

                # region X12File

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.X12FileRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    item.X12FileRelPath = string.Empty;
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("X12FileID_", item.ClaimProcessEDIFileID), filePath);

                # endregion

                retPrevStatus.Add((StatusResult)item);
            }
            return new JsonResultExtension { Data = retPrevStatus };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveDrNote()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveDrNotePreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveSupBill()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveSupBillPreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveX12File()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("X12FileID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveRefFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("RefFileID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveIPALogo()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveClinicLogo()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveProviderPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatDoc()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatDocPreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));
        }

        #endregion

        # region Sync

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Sync()
        {
            List<string> retAns = new List<string>();

            try
            {
                // http://www.dotnetperls.com/process-start
                // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net
                Process.Start(string.Concat(StaticClass.AppRootPath, @"\DataSync\ClaimatePrimeWin.exe"), Convert.ToString(ArivaSession.Sessions().UserID));
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
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SyncStatus()
        {
            DashBoardModel objDash = new DashBoardModel();
            List<SyncResult> retDash = new List<SyncResult>();

            objDash.Fill(IsActive());

            retDash.Add((SyncResult)objDash.LastSync);

            return new JsonResultExtension { Data = retDash };
        }

        # endregion
    }
}
