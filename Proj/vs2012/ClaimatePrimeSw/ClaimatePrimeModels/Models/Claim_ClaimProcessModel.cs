using System;
using System.Collections.Generic;
using System.Linq;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{
    #region NotesAModel-Assigend Claims
    public class ClaimProcessNoteModel : BaseSaveModel
    {
        # region Properties

        public List<usp_GetCommentByID_ClaimProcess_Result> Comments { get; set; }

        #endregion

        #region Abstract

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID == 0)
            {
                Comments = new List<usp_GetCommentByID_ClaimProcess_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    Comments = new List<usp_GetCommentByID_ClaimProcess_Result>(ctx.usp_GetCommentByID_ClaimProcess(pID, pIsActive));
                }
            }
        }


        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
    #endregion

    #region Claim Status Model - Assg Claims

    public class ClaimProcessStatusModel : BaseSaveModel
    {
        # region Properties

        public List<usp_GetByPatientVisitID_ClaimProcess_Result> pClaimProcess { get; set; }

        //public string SysGenKy { get; set; }

        #endregion

        #region Abstract

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID == 0)
            {
                pClaimProcess = new List<usp_GetByPatientVisitID_ClaimProcess_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    pClaimProcess = new List<usp_GetByPatientVisitID_ClaimProcess_Result>(ctx.usp_GetByPatientVisitID_ClaimProcess(pID, "Sys Gen :"));
                }

            }
        }


        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Public

        //need to merge this to override function (have to check !!!!)
        /// <summary>
        /// 
        /// </summary>
        /// <param name="patID"></param>
        public void GetPrevStatus(long patID)
        {
            if (patID == 0)
            {
                pClaimProcess = new List<usp_GetByPatientVisitID_ClaimProcess_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    pClaimProcess = new List<usp_GetByPatientVisitID_ClaimProcess_Result>(ctx.usp_GetByPatientVisitID_ClaimProcess(patID, "Sys Gen :"));
                }

            }
        }
        #endregion
    }

    #endregion

    # region Dashboard

    /// <summary>
    /// 
    /// </summary>
    public class DashBoardModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetDashboardSummary_PatientVisit_Result> DashboardCount { get; set; }

        public usp_GetDashboardSummaryNIT_PatientVisit_Result DashboardCountNIT { get; set; }

        public List<usp_GetDashboardVisit_PatientVisit_Result> DashboardVisit { get; set; }

        public usp_GetLastStatus_SyncStatus_Result LastSync { get; set; }

        public List<usp_GetDashboardVisitPdf_PatientVisit_Result> DashboardPdfVisit { get; set; }

        public usp_GetNotificationCountRole_UserRole_Result UsersWithoutRoleCount { get; set; }

        public usp_GetNotificationCountClinic_UserClinic_Result UsersWithOutClinicCount { get; set; }

        public usp_GetNotificationCountAgent_User_Result ManagerWithoutAgentCount { get; set; }

        public usp_GetNotificationCountManager_UserClinic_Result ClinicsWithoutManagerCount { get; set; }

        public usp_GetNotificationCountMultiManager_UserClinic_Result ClinicsWithMultiManagerCount { get; set; }

        public usp_GetNotificationCountAgentClinic_UserClinic_Result AgentClinicCount { get; set; }

        public List<usp_GetNotificationAgentClinic_UserClinic_Result> AgentClinic { get; set; }

        public List<usp_GetNotificationRole_UserRole_Result> UsersWithoutRole { get; set; }

        public List<usp_GetNotificationClinic_UserClinic_Result> UsersWithOutClinic { get; set; }

        public List<usp_GetNotificationAgent_User_Result> ManagerWithoutAgent { get; set; }

        public List<usp_GetNotificationManager_UserClinic_Result> ClinicsWithoutManager { get; set; }

        public List<usp_GetNotificationMultiManager_UserClinic_Result> ClinicsWithMultiManager { get; set; }

        public List<usp_GetNotificationRolePdf_UserRole_Result> UsersWithoutRolePdf { get; set; }

        public List<usp_GetNotificationClinicPdf_UserClinic_Result> UsersWithoutClinicPdf { get; set; }

        public List<usp_GetNotificationAgentPdf_User_Result> ManagerWithoutAgentPdf { get; set; }

        public List<usp_GetNotificationAgentClinicPdf_UserClinic_Result> AgentClinicPdf { get; set; }

        public List<usp_GetNotificationManagerPdf_UserClinic_Result> ClinicsWithoutManagerPdf { get; set; }

        public List<usp_GetNotificationMultiManagerPdf_UserClinic_Result> ClinicsWithMultiManagerPdf { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DashBoardModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {

        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                LastSync = (new List<usp_GetLastStatus_SyncStatus_Result>(ctx.usp_GetLastStatus_SyncStatus())).FirstOrDefault();
            }
            if (LastSync == null)
            {
                LastSync = new usp_GetLastStatus_SyncStatus_Result();
            }
        }

        #endregion

        #region Public

        public void FillDashboardCount(int pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                DashboardCount = (new List<usp_GetDashboardSummary_PatientVisit_Result>(ctx.usp_GetDashboardSummary_PatientVisit(pID)));
            }
        }

        public void getDashboardVisit(int userID, string desc, string dayCount, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                DashboardVisit = (new List<usp_GetDashboardVisit_PatientVisit_Result>(ctx.usp_GetDashboardVisit_PatientVisit(userID, desc, dayCount, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (DashboardVisit == null)
                {
                    DashboardVisit = new List<usp_GetDashboardVisit_PatientVisit_Result>();
                }
            }
        }

        public void GetTotalDashCount(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                DashboardCountNIT = (new List<usp_GetDashboardSummaryNIT_PatientVisit_Result>(ctx.usp_GetDashboardSummaryNIT_PatientVisit(userID, string.Concat(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK))))).FirstOrDefault();

                if (DashboardCountNIT == null)
                {
                    DashboardCountNIT = new usp_GetDashboardSummaryNIT_PatientVisit_Result();
                }
            }
        }

        public void GetCountUsersWithoutRole(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithoutRoleCount = (new List<usp_GetNotificationCountRole_UserRole_Result>(ctx.usp_GetNotificationCountRole_UserRole())).FirstOrDefault();

                if (UsersWithoutRoleCount == null)
                {
                    UsersWithoutRoleCount = new usp_GetNotificationCountRole_UserRole_Result();
                }
            }
        }

        public void GetUsersWithoutRole(Int32 userID, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithoutRole = (new List<usp_GetNotificationRole_UserRole_Result>(ctx.usp_GetNotificationRole_UserRole(pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (UsersWithoutRole == null)
                {
                    UsersWithoutRole = new List<usp_GetNotificationRole_UserRole_Result>();
                }
            }
        }

        public void GetCountUsersWithOutClinic(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithOutClinicCount = (new List<usp_GetNotificationCountClinic_UserClinic_Result>(ctx.usp_GetNotificationCountClinic_UserClinic())).FirstOrDefault();

                if (UsersWithOutClinicCount == null)
                {
                    UsersWithOutClinicCount = new usp_GetNotificationCountClinic_UserClinic_Result();
                }
            }
        }

        public void GetUsersWithOutClinic(Int32 userID, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithOutClinic = (new List<usp_GetNotificationClinic_UserClinic_Result>(ctx.usp_GetNotificationClinic_UserClinic(pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (UsersWithOutClinic == null)
                {
                    UsersWithOutClinic = new List<usp_GetNotificationClinic_UserClinic_Result>();
                }
            }
        }

        public void GetCountManagerWithoutAgent(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                ManagerWithoutAgentCount = (new List<usp_GetNotificationCountAgent_User_Result>(ctx.usp_GetNotificationCountAgent_User(Convert.ToByte(Role.MANAGER_ROLE_ID)))).FirstOrDefault();

                if (ManagerWithoutAgentCount == null)
                {
                    ManagerWithoutAgentCount = new usp_GetNotificationCountAgent_User_Result();
                }
            }
        }

        public void GetManagerWithoutAgent(Int32 userID, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ManagerWithoutAgent = (new List<usp_GetNotificationAgent_User_Result>(ctx.usp_GetNotificationAgent_User(Convert.ToByte(Role.MANAGER_ROLE_ID), pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (ManagerWithoutAgent == null)
                {
                    ManagerWithoutAgent = new List<usp_GetNotificationAgent_User_Result>();
                }
            }
        }

        public void GetCountClinicsWithoutManager(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithoutManagerCount = (new List<usp_GetNotificationCountManager_UserClinic_Result>(ctx.usp_GetNotificationCountManager_UserClinic(Convert.ToByte(Role.MANAGER_ROLE_ID)))).FirstOrDefault();

                if (ClinicsWithoutManagerCount == null)
                {
                    ClinicsWithoutManagerCount = new usp_GetNotificationCountManager_UserClinic_Result();
                }
            }
        }

        public void GetCountClinicsWithMultiManager()
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithMultiManagerCount = (new List<usp_GetNotificationCountMultiManager_UserClinic_Result>(ctx.usp_GetNotificationCountMultiManager_UserClinic(Convert.ToByte(Role.MANAGER_ROLE_ID)))).FirstOrDefault();

                if (ClinicsWithMultiManagerCount == null)
                {
                    ClinicsWithMultiManagerCount = new usp_GetNotificationCountMultiManager_UserClinic_Result();
                }
            }

        }

        public void GetClinicsWithoutManager(Int32 userID, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithoutManager = (new List<usp_GetNotificationManager_UserClinic_Result>(ctx.usp_GetNotificationManager_UserClinic(Convert.ToByte(Role.MANAGER_ROLE_ID), pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (ClinicsWithoutManager == null)
                {
                    ClinicsWithoutManager = new List<usp_GetNotificationManager_UserClinic_Result>();
                }
            }
        }

        public void GetClinicsWithMultiManager(long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithMultiManager = (new List<usp_GetNotificationMultiManager_UserClinic_Result>(ctx.usp_GetNotificationMultiManager_UserClinic(Convert.ToByte(Role.MANAGER_ROLE_ID), pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (ClinicsWithMultiManager == null)
                {
                    ClinicsWithMultiManager = new List<usp_GetNotificationMultiManager_UserClinic_Result>();
                }
            }
        }

        public void GetCountAgentClinic(Int32 userID)
        {
            using (EFContext ctx = new EFContext())
            {
                AgentClinicCount = (new List<usp_GetNotificationCountAgentClinic_UserClinic_Result>(ctx.usp_GetNotificationCountAgentClinic_UserClinic(userID))).FirstOrDefault();

                if (AgentClinicCount == null)
                {
                    AgentClinicCount = new usp_GetNotificationCountAgentClinic_UserClinic_Result();
                }
            }
        }

        public void GetAgentClinic(Int32 userID, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                AgentClinic = (new List<usp_GetNotificationAgentClinic_UserClinic_Result>(ctx.usp_GetNotificationAgentClinic_UserClinic(userID, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (AgentClinic == null)
                {
                    AgentClinic = new List<usp_GetNotificationAgentClinic_UserClinic_Result>();
                }
            }
        }

        public void getDashboardPdfVisit(int userID, string desc, string dayCount)
        {
            using (EFContext ctx = new EFContext())
            {
                DashboardPdfVisit = (new List<usp_GetDashboardVisitPdf_PatientVisit_Result>(ctx.usp_GetDashboardVisitPdf_PatientVisit(userID, desc, dayCount)));

                if (DashboardPdfVisit == null)
                {
                    DashboardPdfVisit = new List<usp_GetDashboardVisitPdf_PatientVisit_Result>();
                }
            }
        }

        public void getUsersWithoutRolePdf()
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithoutRolePdf = (new List<usp_GetNotificationRolePdf_UserRole_Result>(ctx.usp_GetNotificationRolePdf_UserRole()));

                if (UsersWithoutRolePdf == null)
                {
                    UsersWithoutRolePdf = new List<usp_GetNotificationRolePdf_UserRole_Result>();
                }
            }
        }

        public void getUsersWithoutClinicPdf()
        {
            using (EFContext ctx = new EFContext())
            {
                UsersWithoutClinicPdf = (new List<usp_GetNotificationClinicPdf_UserClinic_Result>(ctx.usp_GetNotificationClinicPdf_UserClinic()));

                if (UsersWithoutClinicPdf == null)
                {
                    UsersWithoutClinicPdf = new List<usp_GetNotificationClinicPdf_UserClinic_Result>();
                }
            }
        }

        public void getManagerWithoutAgentPdf(byte roleID)
        {
            using (EFContext ctx = new EFContext())
            {
                ManagerWithoutAgentPdf = (new List<usp_GetNotificationAgentPdf_User_Result>(ctx.usp_GetNotificationAgentPdf_User(roleID)));

                if (ManagerWithoutAgentPdf == null)
                {
                    ManagerWithoutAgentPdf = new List<usp_GetNotificationAgentPdf_User_Result>();
                }
            }
        }

        public void getClinicsWithoutManagerPdf(byte roleID)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithoutManagerPdf = (new List<usp_GetNotificationManagerPdf_UserClinic_Result>(ctx.usp_GetNotificationManagerPdf_UserClinic(roleID)));

                if (ClinicsWithoutManagerPdf == null)
                {
                    ClinicsWithoutManagerPdf = new List<usp_GetNotificationManagerPdf_UserClinic_Result>();
                }
            }
        }

        public void getClinicsWithMultiManagerPdf(byte roleID)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicsWithMultiManagerPdf = (new List<usp_GetNotificationMultiManagerPdf_UserClinic_Result>(ctx.usp_GetNotificationMultiManagerPdf_UserClinic(roleID)));

                if (ClinicsWithMultiManagerPdf == null)
                {
                    ClinicsWithMultiManagerPdf = new List<usp_GetNotificationMultiManagerPdf_UserClinic_Result>();
                }
            }
        }

        public void GetAgentClinicPdf(int roleID)
        {
            using (EFContext ctx = new EFContext())
            {
                AgentClinicPdf = (new List<usp_GetNotificationAgentClinicPdf_UserClinic_Result>(ctx.usp_GetNotificationAgentClinicPdf_UserClinic(roleID)));

                if (AgentClinicPdf == null)
                {
                    AgentClinicPdf = new List<usp_GetNotificationAgentClinicPdf_UserClinic_Result>();
                }
            }
        }

        #endregion


    }

    # endregion

    #region Dashboard Excel Model OLD

    //public class DashboardExcelModel : ReportSubBaseModelOLD
    //{
    //    # region Constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public DashboardExcelModel()
    //    {
    //    }

    //    #region ReImport

    //    public void ReImport(global::System.String pExlPath, global::System.String pXmlPath, ExcelSheetColsOLD pCols, List<ExcelSheetDataNotification> pData, int flag)
    //    {
    //        # region Excel

    //        if (System.IO.File.Exists(pExlPath))
    //        {
    //            System.IO.File.Delete(pExlPath);
    //        }

    //        # region Excel File Name

    //        ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPath));

    //        #region Excel Sheet Name

    //        ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCols.Sheet1Name);
    //        ws1.View.ShowGridLines = true;

    //        # endregion

    //        Int64 rowIndx1 = 0;

    //        System.Drawing.Color colorCode1;
    //        System.Drawing.Color colorCode2 = System.Drawing.Color.LightCyan;
    //        System.Drawing.Color colorCode3 = System.Drawing.Color.LightCyan;

    //        # endregion

    //        # region Excel Data

    //        # region Sheet1

    //        # region Main Header Row

    //        rowIndx1++;  // Row 1 Blank

    //        rowIndx1++; // Row number 2

    //        string cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
    //        ws1.Cells[cellAddr].Merge = true;
    //        ws1.Cells[cellAddr].Value = pCols.ExcelSubject;
    //        ws1.Cells[cellAddr].Style.Font.Bold = true;
    //        ws1.Cells[cellAddr].Style.Font.Size = 14;
    //        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

    //        rowIndx1++;  // Row 3 Blank

    //        # endregion

    //        # region Creator Details

    //        rowIndx1++; // Row number 4

    //        cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
    //        ws1.Cells[cellAddr].Merge = true;
    //        ws1.Cells[cellAddr].Value = pCols.ExcelCreator;
    //        ws1.Cells[cellAddr].Style.Font.Size = 12;
    //        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
    //        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

    //        rowIndx1++;  // Row 5 Blank

    //        # endregion

    //        # region Column Header Row

    //        rowIndx1++;  // Row 6 Coloumn Header

    //        for (int i = 0; i < pCols.Sheet1Cols.Length; i++)
    //        {
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Value = pCols.Sheet1Hdrs[i];
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.Font.Bold = true;
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //        }

    //        # endregion

    //        # region Column Data

    //        colorCode1 = System.Drawing.Color.LightCyan;

    //        foreach (ExcelSheetDataNotification data1 in pData)
    //        {
    //            # region Row Changing

    //            if (colorCode1 == System.Drawing.Color.LightCyan)
    //            {
    //                colorCode1 = System.Drawing.Color.White;
    //            }
    //            else
    //            {
    //                colorCode1 = System.Drawing.Color.LightCyan;
    //            }

    //            # endregion

    //            rowIndx1++;

    //            Int32 colIndx1 = 0;  // First column blank
    //            if (flag == 1)
    //            {
    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.EMAIL;
    //                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.LAST_NAME;

    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.FIRST_NAME;

    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.MIDDLE_NAME;
    //                ws1.Cells[cellAddr].Style.Numberformat.Format = pCols.ExcelDtFormat;
    //                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //                for (colIndx1 = 1; colIndx1 < pCols.Sheet1Cols.Length - 1; colIndx1++)
    //                {
    //                    cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                    ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
    //                    ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
    //                    ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //                }
    //            }
    //            else
    //            {
    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.CLINIC_NAME;
    //                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.NPI;

    //                colIndx1++;
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Value = data1.ICD_FORMAT;

    //                for (colIndx1 = 1; colIndx1 < pCols.Sheet1Cols.Length - 1; colIndx1++)
    //                {
    //                    cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                    ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
    //                    ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
    //                    ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //                }
    //            }

    //        }

    //        # endregion

    //        # region Save Sheet1

    //        for (Int64 curRow1 = 2; curRow1 <= rowIndx1; curRow1++)
    //        {
    //            for (int curCol1 = 1; curCol1 < pCols.Sheet1Cols.Length - 1; curCol1++)
    //            {
    //                cellAddr = string.Concat(pCols.Sheet1Cols[curCol1], curRow1);

    //                if ((curCol1 == 1) && (curRow1 == 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if ((curCol1 == (pCols.Sheet1Cols.Length - 2)) && (curRow1 == 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if ((curRow1 == rowIndx1) && (curCol1 == 1))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else if ((curRow1 == rowIndx1) && (curCol1 == (pCols.Sheet1Cols.Length - 2)))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else if (curCol1 == 1)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curCol1 == (pCols.Sheet1Cols.Length - 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curRow1 == 2)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curRow1 == rowIndx1)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //            }
    //        }

    //        # endregion

    //        # endregion

    //        # endregion

    //        # region Save Excel

    //        ws1.Cells[string.Concat(pCols.Sheet1Cols[0], 1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 1], rowIndx1)].AutoFitColumns();

    //        pck.Save();
    //        pck.Dispose();

    //        # endregion

    //        # endregion

    //        # region Description

    //        if (System.IO.File.Exists(pXmlPath))
    //        {
    //            System.IO.File.Delete(pXmlPath);
    //        }

    //        CryptorEngine objCryptor = new CryptorEngine();

    //        ExlDesc = new ExcelSheetDescOLD() { DateRange = objCryptor.Encrypt(pCols.XmlDateRange), ImportedOn = objCryptor.Encrypt(pCols.ExcelDtTm.ToString(pCols.ExcelDtTmFormat)) };

    //        XDocument xDoc = new XDocument(
    //            new XElement(Constants.XMLFileOLD.EXCEL_SHEET_OLD,
    //                new XElement(Constants.XMLFileOLD.DESC_OLD,
    //                    new XElement(Constants.XMLFileOLD.DATE_RANGE_OLD, ExlDesc.DateRange),
    //                    new XElement(Constants.XMLFileOLD.IMPORTED_ON_OLD, ExlDesc.ImportedOn)
    //                )
    //            )
    //        );

    //        xDoc.Save(pXmlPath, SaveOptions.None);

    //        xDoc = null;

    //        # endregion
    //    }

    //    public void ReImport(global::System.String pExlPath, global::System.String pXmlPath, ExcelSheetColsOLD pCols, List<ExcelSheetDataDash> pData)
    //    {
    //        # region Excel

    //        if (System.IO.File.Exists(pExlPath))
    //        {
    //            System.IO.File.Delete(pExlPath);
    //        }

    //        # region Excel File Name

    //        ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPath));

    //        #region Excel Sheet Name

    //        ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCols.Sheet1Name);
    //        ws1.View.ShowGridLines = true;

    //        # endregion

    //        Int64 rowIndx1 = 0;

    //        System.Drawing.Color colorCode1;
    //        System.Drawing.Color colorCode2 = System.Drawing.Color.LightCyan;
    //        System.Drawing.Color colorCode3 = System.Drawing.Color.LightCyan;

    //        # endregion

    //        # region Excel Data

    //        # region Sheet1

    //        # region Main Header Row

    //        rowIndx1++;  // Row 1 Blank

    //        rowIndx1++; // Row number 2

    //        string cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
    //        ws1.Cells[cellAddr].Merge = true;
    //        ws1.Cells[cellAddr].Value = pCols.ExcelSubject;
    //        ws1.Cells[cellAddr].Style.Font.Bold = true;
    //        ws1.Cells[cellAddr].Style.Font.Size = 14;
    //        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

    //        rowIndx1++;  // Row 3 Blank

    //        # endregion

    //        # region Creator Details

    //        rowIndx1++; // Row number 4

    //        cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
    //        ws1.Cells[cellAddr].Merge = true;
    //        ws1.Cells[cellAddr].Value = pCols.ExcelCreator;
    //        ws1.Cells[cellAddr].Style.Font.Size = 12;
    //        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
    //        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

    //        rowIndx1++;  // Row 5 Blank

    //        # endregion

    //        # region Column Header Row

    //        rowIndx1++;  // Row 6 Coloumn Header

    //        for (int i = 0; i < pCols.Sheet1Cols.Length; i++)
    //        {
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Value = pCols.Sheet1Hdrs[i];
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.Font.Bold = true;
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //            ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //        }

    //        # endregion

    //        # region Column Data

    //        colorCode1 = System.Drawing.Color.LightCyan;

    //        foreach (ExcelSheetDataDash data1 in pData)
    //        {
    //            # region Row Changing

    //            if (colorCode1 == System.Drawing.Color.LightCyan)
    //            {
    //                colorCode1 = System.Drawing.Color.White;
    //            }
    //            else
    //            {
    //                colorCode1 = System.Drawing.Color.LightCyan;
    //            }

    //            # endregion

    //            rowIndx1++;

    //            Int32 colIndx1 = 0;  // First column blank

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.SN;
    //            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.CLINIC_NAME;

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.PATIENT_NAME;

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.CHART_NO;

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.DOS;
    //            ws1.Cells[cellAddr].Style.Numberformat.Format = pCols.ExcelDtFormat;
    //            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //            colIndx1++;
    //            cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //            ws1.Cells[cellAddr].Value = data1.CASE_NO;
    //            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //            for (colIndx1 = 1; colIndx1 < pCols.Sheet1Cols.Length - 1; colIndx1++)
    //            {
    //                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
    //                ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
    //                ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
    //                ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //            }

    //        }

    //        # endregion

    //        # region Save Sheet1

    //        for (Int64 curRow1 = 2; curRow1 <= rowIndx1; curRow1++)
    //        {
    //            for (int curCol1 = 1; curCol1 < pCols.Sheet1Cols.Length - 1; curCol1++)
    //            {
    //                cellAddr = string.Concat(pCols.Sheet1Cols[curCol1], curRow1);

    //                if ((curCol1 == 1) && (curRow1 == 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if ((curCol1 == (pCols.Sheet1Cols.Length - 2)) && (curRow1 == 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if ((curRow1 == rowIndx1) && (curCol1 == 1))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else if ((curRow1 == rowIndx1) && (curCol1 == (pCols.Sheet1Cols.Length - 2)))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else if (curCol1 == 1)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curCol1 == (pCols.Sheet1Cols.Length - 2))
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curRow1 == 2)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //                else if (curRow1 == rowIndx1)
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                }
    //                else
    //                {
    //                    ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                    ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                }
    //            }
    //        }

    //        # endregion

    //        # endregion

    //        # endregion

    //        # region Save Excel

    //        ws1.Cells[string.Concat(pCols.Sheet1Cols[0], 1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 1], rowIndx1)].AutoFitColumns();

    //        pck.Save();
    //        pck.Dispose();

    //        # endregion

    //        # endregion

    //        # region Description

    //        if (System.IO.File.Exists(pXmlPath))
    //        {
    //            System.IO.File.Delete(pXmlPath);
    //        }

    //        CryptorEngine objCryptor = new CryptorEngine();

    //        ExlDesc = new ExcelSheetDescOLD() { DateRange = objCryptor.Encrypt(pCols.XmlDateRange), ImportedOn = objCryptor.Encrypt(pCols.ExcelDtTm.ToString(pCols.ExcelDtTmFormat)) };

    //        XDocument xDoc = new XDocument(
    //            new XElement(Constants.XMLFileOLD.EXCEL_SHEET_OLD,
    //                new XElement(Constants.XMLFileOLD.DESC_OLD,
    //                    new XElement(Constants.XMLFileOLD.DATE_RANGE_OLD, ExlDesc.DateRange),
    //                    new XElement(Constants.XMLFileOLD.IMPORTED_ON_OLD, ExlDesc.ImportedOn)
    //                )
    //            )
    //        );

    //        xDoc.Save(pXmlPath, SaveOptions.None);

    //        xDoc = null;

    //        # endregion
    //    }

    //    #endregion

    //    # endregion
    //}
    #endregion

    # region ExcelSheetDataNotification//sharon

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetDataNotification
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String EMAIL
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String LAST_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FIRST_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String MIDDLE_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CLINIC_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String NPI
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ICD_FORMAT
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ExcelSheetDataNotification()
        {
        }

        # endregion
    }

    # endregion

    # region ExcelSheetDataDash//sharon

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetDataDash
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 SN
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CLINIC_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.DateTime DOS
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<long> CASE_NO
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PATIENT_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CHART_NO
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public byte PATIENT_VISIT_COMPLEXITY { get; set; }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ExcelSheetDataDash()
        {
        }

        # endregion
    }

    # endregion

    # region DashBoardPdfModel

    /// <summary>
    /// 
    /// </summary>
    public class DashBoardPdfModel : BaseModel
    {
        public string TestProperty { get; set; }

        public List<usp_GetDashboardVisit_PatientVisit_Result> DashboardVisit { get; set; }
    }

    # endregion

    #region DashboardSummary

    public class DashBoardSummaryModel : BaseSearchModel
    {
        # region Properties

        public Nullable<int> userID { get; set; }
        string desc { get; set; }
        public string dayCount { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DashBoardSummaryModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZDashVisits_PatientVisit_Result> lst = new List<usp_GetByAZDashVisits_PatientVisit_Result>(ctx.usp_GetByAZDashVisits_PatientVisit(userID, desc, dayCount));

                foreach (usp_GetByAZDashVisits_PatientVisit_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {

        }

        #endregion
    }
    #endregion

    #region ClinicWiseSummary

    public class ClinicWiseSummaryModel : BaseSearchModel
    {

        # region Properties

        public List<usp_GetBySearch_Clinic_Result> ClinicResult { get; set; }

        public List<usp_GetClinicWiseSummary_PatientVisit_Result> ClinicDash { get; set; }

        public usp_GetClinicWiseSummaryNIT_PatientVisit_Result TotalCount { get; set; }

        public List<usp_GetClinicWiseVisit_PatientVisit_Result> ClinicWiseVisit { get; set; }

        public int UserID { get; set; }

        public List<usp_GetClinicWiseVisitpDF_PatientVisit_Result> PdfVisit { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClinicWiseSummaryModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Clinic_Result> lst = new List<usp_GetByAZ_Clinic_Result>(ctx.usp_GetByAZ_Clinic(UserID, true));

                foreach (usp_GetByAZ_Clinic_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicResult = new List<usp_GetBySearch_Clinic_Result>(ctx.usp_GetBySearch_Clinic(UserID, StartBy, true));
            }
        }

        #endregion

        #region Public

        public void GetResultClinic(int clinicID)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicDash = (new List<usp_GetClinicWiseSummary_PatientVisit_Result>(ctx.usp_GetClinicWiseSummary_PatientVisit(clinicID)));
            }
        }

        public void GetTotalCount(int clinicID)
        {
            using (EFContext ctx = new EFContext())
            {

                TotalCount = (new List<usp_GetClinicWiseSummaryNIT_PatientVisit_Result>(ctx.usp_GetClinicWiseSummaryNIT_PatientVisit(clinicID))).FirstOrDefault();

                if (TotalCount == null)
                {
                    TotalCount = new usp_GetClinicWiseSummaryNIT_PatientVisit_Result();
                }
            }
        }

        public void getClinicVisit(string clinicID, string desc, string dayCount, long pCurrPageNumber, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicWiseVisit = (new List<usp_GetClinicWiseVisit_PatientVisit_Result>(ctx.usp_GetClinicWiseVisit_PatientVisit(Convert.ToInt32(clinicID), desc, dayCount, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection)));

                if (ClinicWiseVisit == null)
                {
                    new usp_GetClinicWiseVisit_PatientVisit_Result();
                }
            }
        }

        public void FillPdfVisit(int clinicID, string dayCount, string desc)
        {
            using (EFContext ctx = new EFContext())
            {
                PdfVisit = (new List<usp_GetClinicWiseVisitpDF_PatientVisit_Result>(ctx.usp_GetClinicWiseVisitpDF_PatientVisit(clinicID, desc, dayCount)));

                if (PdfVisit == null)
                {
                    PdfVisit = new List<usp_GetClinicWiseVisitpDF_PatientVisit_Result>();
                }
            }
        }

        #endregion



    }

    #endregion

    #region AgentWiseSummary

    public class AgentWiseSummaryModel : BaseSearchModel
    {

        # region Properties

        public List<usp_GetDashboardAgent_User_Result> AgentList { get; set; }

        public List<usp_GetAgentWiseSummary_PatientVisit_Result> TableCount { get; set; }

        public usp_GetAgentWiseSummaryNIT_PatientVisit_Result TotalCount { get; set; }

        public int UserID { get; set; }

        public byte UserHighRole { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AgentWiseSummaryModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZDashboardAgent_User_Result> lst = new List<usp_GetByAZDashboardAgent_User_Result>(ctx.usp_GetByAZDashboardAgent_User(UserID, (UserHighRole == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID)) ? true : false));

                foreach (usp_GetByAZDashboardAgent_User_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                AgentList = new List<usp_GetDashboardAgent_User_Result>(ctx.usp_GetDashboardAgent_User(StartBy, UserID, (UserHighRole == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID)) ? true : false));
            }
        }

        #endregion

        #region Public

        public void GetAgentTableCount(int userID)
        {
            using (EFContext ctx = new EFContext())
            {
                TableCount = (new List<usp_GetAgentWiseSummary_PatientVisit_Result>(ctx.usp_GetAgentWiseSummary_PatientVisit(userID, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.BA_HOLDED), Convert.ToByte(ClaimStatus.CREATED_CLAIM), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.REJECTED_CLAIM), Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM))));
            }
        }

        public void GetTotalCount(Nullable<int> userID)
        {
            using (EFContext ctx = new EFContext())
            {

                TotalCount = (new List<usp_GetAgentWiseSummaryNIT_PatientVisit_Result>(ctx.usp_GetAgentWiseSummaryNIT_PatientVisit(userID, string.Concat(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK))))).FirstOrDefault();

                if (TotalCount == null)
                {
                    TotalCount = new usp_GetAgentWiseSummaryNIT_PatientVisit_Result();
                }
            }
        }



        #endregion


    }

    #endregion

    #region AgentWiseSummaryView

    public class AgentWiseSummaryViewModel : BaseSearchModel
    {

        # region Properties

        public List<usp_GetAgentWiseVisit_PatientVisit_Result> AgentWiseVisit { get; set; }

        public int UserID { get; set; }

        public string Desc { get; set; }

        public string DayCount { get; set; }

        public List<usp_GetAgentWiseVisitPdf_PatientVisit_Result> PdfVisit { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AgentWiseSummaryViewModel()
        {
        }

        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            //throw new NotImplementedException();
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                AgentWiseVisit =
                    (
                    new List<usp_GetAgentWiseVisit_PatientVisit_Result>(ctx.usp_GetAgentWiseVisit_PatientVisit(UserID, Desc, DayCount
                    , Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.BA_HOLDED), Convert.ToByte(ClaimStatus.CREATED_CLAIM), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.REJECTED_CLAIM), Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM)
                    , string.Concat(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK))
                    , pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection))
                    );

                if (AgentWiseVisit == null)
                {
                    AgentWiseVisit = new List<usp_GetAgentWiseVisit_PatientVisit_Result>();
                }
            }
        }

        #endregion

        #region Public

        public void FillPdfVisit(int userID, string dayCount, string desc)
        {
            using (EFContext ctx = new EFContext())
            {
                PdfVisit = (new List<usp_GetAgentWiseVisitPdf_PatientVisit_Result>(ctx.usp_GetAgentWiseVisitPdf_PatientVisit(userID, desc, dayCount, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.BA_HOLDED), Convert.ToByte(ClaimStatus.CREATED_CLAIM), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.REJECTED_CLAIM), Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM)
                    , string.Concat(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK)))));

                if (PdfVisit == null)
                {
                    PdfVisit = new List<usp_GetAgentWiseVisitPdf_PatientVisit_Result>();
                }
            }
        }

        #endregion

    }

    #endregion
}
