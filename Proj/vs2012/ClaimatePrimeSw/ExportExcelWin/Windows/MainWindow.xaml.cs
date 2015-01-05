using ExportExcelWin.Classes;
using ExportExcelWin.Classes.ExcelClasses;
using ExportExcelWin.SecuredFolder.BaseWpfs;
using System;
using System.Configuration;
using System.Data;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Windows;
using System.Windows.Threading;
using ExportExcelWin.SecuredFolder.BaseClasses;
using ClaimatePrimeConstants;
using System.Collections;
using System.Linq;
using ArivaEmail;

namespace ExportExcelWin.Windows
{
    # region MainWindow

    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : BaseWpf
    {
        # region Private Variables

        private DispatcherTimer _timer;

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(MainWindow_Loaded);
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            _timer = new DispatcherTimer();
            _timer.Interval = TimeSpan.FromSeconds(1);
            _timer.Tick += new EventHandler(_timer_Tick);
            _timer.Start();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void _timer_Tick(object sender, EventArgs e)
        {
            _timer.Stop();

            if (CurrImpoOn.DAY_STS)
            {
                using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString))
                {
                    SqlTransaction trans = null;
                    UserReport oCurrRpt = null;
                    User appUser = new User() { Name = "Auto Service" };

                    try
                    {
                        if (!(string.IsNullOrWhiteSpace(App.ErrMsg)))
                        {
                            throw new Exception(App.ErrMsg);
                        }

                        # region Delete Old Files (Only One Time in the For loop)

                        cn.Open();
                        trans = cn.BeginTransaction();

                        IBaseList oDels = (new UserReport()).SelectList("SP_UR_DELETE", cn, trans);

                        foreach (UserReport oDel in oDels.IBaseClasses)
                        {
                            string delPth = String.Concat(FileSvrRptRootPath, @"\", oDel.ExcelFileName);

                            if (File.Exists(delPth))
                            {
                                File.Delete(delPth);
                            }
                        }

                        trans.Commit();
                        cn.Close();
                        trans = null;

                        # endregion

                        # region Forming Generic Lists / Forming SP & Params

                        # region Fetch Users

                        IBaseList oUsers = null;
                        SpNameParamList oSpNameParamList = null;

                        // Users
                        if (App.UserID == 0)
                        {
                            cn.Open();
                            oUsers = appUser.SelectList("SP_GET_USERS", cn);
                            cn.Close();
                        }
                        else
                        {
                            appUser.ID = App.UserID;
                            cn.Open();
                            appUser.Select("SP_GET_UN", cn, (new SqlParameter() { ParameterName = "UserID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = appUser.ID }));
                            cn.Close();
                            EmailAddrs.Add(new EmailAddress(appUser.Email, appUser.Name));
                            oUsers = new BaseList();
                            oUsers.IBaseClasses.Add(appUser);
                        }

                        # endregion

                        # region SPs

                        // SP Name Key & Parameters
                        oSpNameParamList = new SpNameParamList();
                        SpNameParam oSpNameParam = null;
                        SpParam oSpParam = null;
                        if (App.ReportTypeID == 0)
                        {
                            # region All Users & All Reports

                            // All Users & All Reports

                            App.DateFrom = DateTime.Now.AddMonths(-1);
                            App.DateTo = DateTime.Now;

                            foreach (IBaseClass iUser in oUsers.IBaseClasses)
                            {
                                # region 1 SP

                                // 1 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.CLINIC_REPORT));

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);
                                //
                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);
                                //
                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);
                                //   
                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);
                                //
                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                //
                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " ");
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);
                                //
                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 2 SP

                                // 2 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.CLINIC_REPORT), "_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 5 SP

                                // 5 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PROVIDER_REPORT));

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 6 SP

                                // 6 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PROVIDER_REPORT), "_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 9 SP

                                // 9 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PATIENT_REPORT));

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 10 SP

                                // 10 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PATIENT_REPORT), "_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 13 SP

                                // 13 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.AGENT_REPORT));

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 14 SP

                                // 14 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.AGENT_REPORT), "_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);


                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region Fetching Clinics

                                // This person -- allocated clinic ids -- for loop

                                cn.Open();
                                UserClinic userClinic = new UserClinic();
                                IBaseList userClinicList = userClinic.SelectList("SP_GET_UC", cn, (new SqlParameter() { ParameterName = "ID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.UserID }));
                                cn.Close();

                                foreach (UserClinic uc in userClinicList.IBaseClasses)
                                {
                                    # region 3 SP
                                    // 3 SP
                                    oSpNameParam = new SpNameParam();
                                    oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.CLINIC_REPORT), "_ROID");

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "USER_ID";
                                    oSpParam.Val = iUser.ID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "ROID";
                                    oSpParam.Val = uc.ID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "ID";
                                    oSpParam.Val = uc.ID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "DATE_FROM";
                                    oSpParam.Val = null;
                                    oSpParam.Typ = SqlDbType.Date;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "DATE_TO";
                                    oSpParam.Val = null;
                                    oSpParam.Typ = SqlDbType.Date;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "SUBJECT";
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "), " - CLINIC NAME ", uc.Name);
                                    oSpParam.Typ = SqlDbType.VarChar;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                    # endregion

                                    # region 4 SP

                                    // 4 SP
                                    oSpNameParam = new SpNameParam();
                                    oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.CLINIC_REPORT), "_ROID_FTDT");

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "USER_ID";
                                    oSpParam.Val = iUser.ID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "ROID";
                                    oSpParam.Val = App.ReportObjectID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "ID";
                                    oSpParam.Val = uc.ID;
                                    oSpParam.Typ = SqlDbType.Int;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "DATE_FROM";
                                    oSpParam.Val = App.DateFrom;
                                    oSpParam.Typ = SqlDbType.Date;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "DATE_TO";
                                    oSpParam.Val = App.DateTo;
                                    oSpParam.Typ = SqlDbType.Date;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpParam = new SpParam();
                                    oSpParam.Nam = "SUBJECT";
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - CLINIC NAME ", uc.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                    oSpParam.Typ = SqlDbType.VarChar;
                                    oSpNameParam.SpParams.Add(oSpParam);

                                    oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                    # endregion

                                    # region Fetching Providers

                                    cn.Open();
                                    Provider provider = new Provider();
                                    IBaseList providerList = userClinic.SelectList("SP_GET_PR", cn, (new SqlParameter() { ParameterName = "ID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = uc.ID }));
                                    cn.Close();

                                    foreach (Provider pr in providerList.IBaseClasses)
                                    {
                                        # region 7 SP

                                        // 7 SP
                                        oSpNameParam = new SpNameParam();
                                        oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PROVIDER_REPORT), "_ROID");

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "USER_ID";
                                        oSpParam.Val = iUser.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ROID";
                                        oSpParam.Val = App.ReportObjectID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ID";
                                        oSpParam.Val = pr.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_FROM";
                                        oSpParam.Val = null;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_TO";
                                        oSpParam.Val = null;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "SUBJECT";
                                        oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - PROVIDER NAME ", uc.Name);
                                        oSpParam.Typ = SqlDbType.VarChar;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                        # endregion

                                        # region 8 SP

                                        // 8 SP
                                        oSpNameParam = new SpNameParam();
                                        oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PROVIDER_REPORT), "_ROID_FTDT");

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "USER_ID";
                                        oSpParam.Val = iUser.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ROID";
                                        oSpParam.Val = App.ReportObjectID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ID";
                                        oSpParam.Val = pr.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_FROM";
                                        oSpParam.Val = App.DateFrom;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_TO";
                                        oSpParam.Val = App.DateTo;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "SUBJECT";
                                        oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - PROVIDER NAME ", uc.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                        oSpParam.Typ = SqlDbType.VarChar;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                        # endregion
                                    }

                                    # endregion

                                    # region Fetching Patients

                                    cn.Open();
                                    Patient patient = new Patient();
                                    IBaseList patientList = userClinic.SelectList("SP_GET_PA", cn, (new SqlParameter() { ParameterName = "ID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = uc.ID }));
                                    cn.Close();
                                    foreach (Patient pa in patientList.IBaseClasses)
                                    {
                                        # region 11 SP

                                        // 11 SP
                                        oSpNameParam = new SpNameParam();
                                        oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PATIENT_REPORT), "_ROID");

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "USER_ID";
                                        oSpParam.Val = iUser.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ROID";
                                        oSpParam.Val = App.ReportObjectID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ID";
                                        oSpParam.Val = pa.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_FROM";
                                        oSpParam.Val = null;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_TO";
                                        oSpParam.Val = null;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "SUBJECT";
                                        oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - CLINIC NAME ", uc.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                        oSpParam.Typ = SqlDbType.VarChar;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                        # endregion

                                        # region 12 SP

                                        // 12 SP
                                        oSpNameParam = new SpNameParam();
                                        oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.PATIENT_REPORT), "_ROID_FTDT");

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "USER_ID";
                                        oSpParam.Val = iUser.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ROID";
                                        oSpParam.Val = App.ReportObjectID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "ID";
                                        oSpParam.Val = pa.ID;
                                        oSpParam.Typ = SqlDbType.Int;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_FROM";
                                        oSpParam.Val = App.DateFrom;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "DATE_TO";
                                        oSpParam.Val = App.DateTo;
                                        oSpParam.Typ = SqlDbType.Date;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpParam = new SpParam();
                                        oSpParam.Nam = "SUBJECT";
                                        oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "), " - PATIENT NAME ", uc.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                        oSpParam.Typ = SqlDbType.VarChar;
                                        oSpNameParam.SpParams.Add(oSpParam);

                                        oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                        # endregion
                                    }

                                    # endregion
                                }

                                # endregion

                                # region Agent Reports

                                # region 15 SP

                                // 15 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.AGENT_REPORT), "_ROID");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # region 16 SP

                                // 16 SP
                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = iUser.ID;oSpNameParam.SpKy = string.Concat("SP_RTID_", Convert.ToByte(ExcelReportType.AGENT_REPORT), "_ROID_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = iUser.ID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion

                                # endregion
                            }

                            # endregion
                        }
                        else
                        {
                            if ((App.ReportObjectID > 0) && (DateAndTime.GetDateDiff(DateIntervals.DAY, App.DateFrom, App.DateTo) >= 0))
                            {
                                # region Has Both ID & Dates

                                // Has Both ID & Dates

                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = App.UserID;oSpNameParam.SpKy = string.Concat("SP_RTID_", App.ReportTypeID, "_ROID_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";

                                if (App.ReportTypeID == Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                {
                                    UserClinic oUC2 = new UserClinic();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_UC", cn, (new SqlParameter() { ParameterName = "ClinicID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "), " - CLINIC NAME: ", oUC2.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                {
                                    Provider oUC2 = new Provider();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_PR", cn, (new SqlParameter() { ParameterName = "ProviderID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - PROVIDER NAME: ", oUC2.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PATIENT_REPORT))
                                {
                                    Patient oUC2 = new Patient();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_PA", cn, (new SqlParameter() { ParameterName = "PatientID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "), " - PATIENT NAME: ", oUC2.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else
                                {
                                    User oUC2 = new User();
                                    cn.Open();
                                    oUC2.Select("SP_GET_UN", cn, (new SqlParameter() { ParameterName = "UserID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - AGENT NAME: ", oUC2.Name, " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }

                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion
                            }
                            else if ((App.ReportObjectID == 0) && (DateAndTime.GetDateDiff(DateIntervals.DAY, App.DateFrom, App.DateTo) >= 0))
                            {
                                # region Date Only

                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = App.UserID;oSpNameParam.SpKy = string.Concat("SP_RTID_", App.ReportTypeID, "_FTDT");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = App.DateFrom;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = App.DateTo;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";

                                if (App.ReportTypeID == Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PATIENT_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }
                                else
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - DATE FROM ", GetDateStr(App.DateFrom), " TO ", GetDateStr(App.DateTo));
                                }

                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion
                            }
                            else if ((App.ReportObjectID > 0) && (DateAndTime.GetDateDiff(DateIntervals.DAY, App.DateFrom, App.DateTo) <= 0))
                            {
                                # region Has ID Only

                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = App.UserID;oSpNameParam.SpKy = string.Concat("SP_RTID_", App.ReportTypeID, "_ROID");

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = App.ReportObjectID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";

                                if (App.ReportTypeID == Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                {
                                    UserClinic oUC2 = new UserClinic();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_UC", cn, (new SqlParameter() { ParameterName = "ClinicID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "), " - CLINIC NAME: ", oUC2.Name);
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                {
                                    Provider oUC2 = new Provider();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_PR", cn, (new SqlParameter() { ParameterName = "ProviderID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "), " - PROVIDER NAME: ", oUC2.Name);
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PATIENT_REPORT))
                                {
                                    Patient oUC2 = new Patient();
                                    cn.Open();
                                    oUC2.Select("SP_GET_ID_PA", cn, (new SqlParameter() { ParameterName = "PatientID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "), " - PATIENT NAME: ", oUC2.Name);
                                }
                                else
                                {
                                    User oUC2 = new User();
                                    cn.Open();
                                    oUC2.Select("SP_GET_UN", cn, (new SqlParameter() { ParameterName = "UserID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = App.ReportObjectID }));
                                    cn.Close();
                                    oSpParam.Val = string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "), " - AGENT NAME: ",oUC2.Name);
                                }

                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);

                                # endregion
                            }
                            else
                            {
                                # region Has not Both ID & Dates

                                oSpNameParam = new SpNameParam();
                                oSpNameParam.UserID = App.UserID; oSpNameParam.SpKy = string.Concat("SP_RTID_", App.ReportTypeID);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "USER_ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ROID";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "ID";
                                oSpParam.Val = App.UserID;
                                oSpParam.Typ = SqlDbType.Int;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_FROM";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "DATE_TO";
                                oSpParam.Val = null;
                                oSpParam.Typ = SqlDbType.Date;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpParam = new SpParam();
                                oSpParam.Nam = "SUBJECT";
                                if (App.ReportTypeID == Convert.ToByte(ExcelReportType.CLINIC_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.CLINIC_REPORT).Replace("_", " "));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PROVIDER_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.PROVIDER_REPORT).Replace("_", " "));
                                }
                                else if (App.ReportTypeID == Convert.ToByte(ExcelReportType.PATIENT_REPORT))
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.PATIENT_REPORT).Replace("_", " "));
                                }
                                else
                                {
                                    string.Concat(Convert.ToString(ExcelReportType.AGENT_REPORT).Replace("_", " "));
                                }
                                oSpParam.Typ = SqlDbType.VarChar;
                                oSpNameParam.SpParams.Add(oSpParam);

                                oSpNameParamList.SpNameParams.Add(oSpNameParam);
                               

                                # endregion
                            }
                        }

                        # endregion

                        # endregion

                        # region Create Excel

                        foreach (SpNameParam item in oSpNameParamList.SpNameParams)
                        {
                            # region Insert Current Report

                            cn.Open();
                            trans = cn.BeginTransaction();

                            oCurrRpt = new UserReport() { UserID = item["USER_ID"].Val, DateFrom = item["DATE_FROM"].Val, DateTo = item["DATE_TO"].Val, ReportObjectID = item["ROID"].Val, ReportTypeID = Convert.ToByte(item.SpKy.Substring(8, 1)) };
                            oCurrRpt.Save(cn, trans);

                            trans.Commit();
                            cn.Close();
                            trans = null;

                            # endregion

                            #region Create Excel

                            if (oCurrRpt.ID > 0)
                            {
                                User oU = new User();
                                cn.Open();
                                oU.Select("SP_GET_UN", cn, (new SqlParameter() { ParameterName = "UserID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = item.UserID }));
                                cn.Close();

                                cn.Open();

                                ExcelFile.Create(String.Concat(FileSvrRptRootPath, @"\", oCurrRpt.ExcelFileNameTmp), String.Concat(FileSvrRptRootPath, @"\", oCurrRpt.ExcelFileName),
                                    ExcelSheetCol.Get(CurrImpoOn.CURR_DT_TM, item["SUBJECT"].Val, GetDateStr(), GetTimeStr(), GetDateTimeStr(), appUser.Name),
                                    ((new Claim()).SelectList(item.SpKy, cn,
                                    (new SqlParameter() { ParameterName = "ID", SqlDbType = System.Data.SqlDbType.Int, Direction = ParameterDirection.Input, Value = item["ID"].Val })
                                    , (new SqlParameter() { ParameterName = "DATE_FROM", SqlDbType = System.Data.SqlDbType.Date, Direction = ParameterDirection.Input, Value = item["DATE_FROM"].Val }), (new SqlParameter() { ParameterName = "DATE_TO", SqlDbType = System.Data.SqlDbType.Date, Direction = ParameterDirection.Input, Value = item["DATE_TO"].Val }))));

                                cn.Close();

                                # region Update Current Report

                                cn.Open();
                                trans = cn.BeginTransaction();
                                oCurrRpt.IsSuccess = true;
                                oCurrRpt.Save(cn, trans);

                                trans.Commit();
                                cn.Close();
                                trans = null;

                                oCurrRpt = null;

                                # endregion
                            }
                            else if (oCurrRpt.ID < 0)
                            {
                                throw new Exception(string.Concat("Error! User Report Insert SP Error. Refer Error Log ID: ", oCurrRpt.ID));
                            }
                            else
                            {
                                // Already Exe In-Progress
                            }

                            #endregion
                        }

                        # endregion

                        # region Success

                        SendEmail
                            (
                                File.ReadAllText(string.Concat(WebRootPath, @"\Templates\ExcelExportSvc.htm"))
                                        .Replace("[01 StartedOn 01]", string.Concat(CurrImpoOn.CURR_DT_TM.ToLongDateString(), " ", CurrImpoOn.CURR_DT_TM.ToLongTimeString()))
                                        .Replace("[02 EndedOn 02]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                                        .Replace("[03 Status 03]", "Success")
                                        .Replace("[04 DB Server 04]", DBSvrName)
                                        .Replace("[05 DB Name 05]", DBName)
                                        .Replace("[06 DispName 06]", appUser.Name)
                                        .Replace("[07 Form Title 07]", Title)
                                        .Replace("[v ExeVersion v]", ExeVersion)
                                        .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                            );

                        # endregion
                    }
                    catch (Exception ex)
                    {
                        if (trans != null)
                        {
                            trans.Rollback();
                            cn.Close();
                        }

                        if (oCurrRpt != null)
                        {
                            # region Update Current Report

                            if (cn.State == ConnectionState.Closed)
                            {
                                cn.Open();
                            }

                            trans = cn.BeginTransaction();
                            oCurrRpt.IsSuccess = false;
                            oCurrRpt.Save(cn, trans);

                            trans.Commit();
                            cn.Close();
                            trans = null;

                            oCurrRpt = null;

                            # endregion
                        }

                        SendEmail
                            (
                                File.ReadAllText(string.Concat(WebRootPath, @"\Templates\ExcelExportSvc.htm"))
                                        .Replace("[01 StartedOn 01]", string.Concat(CurrImpoOn.CURR_DT_TM.ToLongDateString(), " ", CurrImpoOn.CURR_DT_TM.ToLongTimeString()))
                                        .Replace("[02 EndedOn 02]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                                        .Replace("[03 Status 03]", string.Concat("ERROR - REASON: ", ex.ToString()))
                                        .Replace("[04 DB Server 04]", DBSvrName)
                                        .Replace("[05 DB Name 05]", DBName)
                                        .Replace("[06 DispName 06]", appUser.Name)
                                        .Replace("[07 Form Title 07]", Title)
                                        .Replace("[v ExeVersion v]", ExeVersion)
                                        .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                            );
                    }
                    finally
                    {
                        if (cn.State != ConnectionState.Closed)
                        {
                            cn.Close();
                        }
                    }
                }
            }

            this.Close();
        }

        # endregion
    }

    # endregion

    # region SpNameParams

    /// <summary>
    /// 
    /// </summary>
    internal class SpNameParamList
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        internal List<SpNameParam> SpNameParams { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        /// <param name="i"></param>
        /// <returns></returns>
        public SpNameParam this[byte i]
        {
            get
            {
                return SpNameParams[i];
            }
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <param name="spKy"></param>
        /// <returns></returns>
        public SpNameParam this[string spKy]
        {
            get
            {
                return (from o in SpNameParams where string.Compare(o.SpKy, spKy, true) == 0 select o).FirstOrDefault();
            }
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        internal SpNameParamList()
        {
            SpNameParams = new List<SpNameParam>();
        }

        # endregion
    }

    # endregion

    # region SpNameParam

    /// <summary>
    /// 
    /// </summary>
    internal class SpNameParam
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        internal string SpKy { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        internal int UserID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        internal List<SpParam> SpParams { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        /// <param name="i"></param>
        /// <returns></returns>
        public SpParam this[byte i]
        {
            get
            {
                return SpParams[i];
            }
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <param name="nam"></param>
        /// <returns></returns>
        public SpParam this[string nam]
        {
            get
            {
                return (from o in SpParams where string.Compare(o.Nam, nam, true) == 0 select o).FirstOrDefault();
            }
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        internal SpNameParam()
        {
            SpParams = new List<SpParam>();
        }

        # endregion
    }

    # endregion

    # region SpParam

    /// <summary>
    /// 
    /// </summary>
    internal class SpParam
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        internal string Nam { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        internal dynamic Val { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        internal SqlDbType Typ { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        internal SpParam()
        {
        }

        # endregion
    }

    # endregion
}
