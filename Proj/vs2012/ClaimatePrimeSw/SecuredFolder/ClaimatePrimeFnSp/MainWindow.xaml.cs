using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;
using System.ComponentModel;
using ClaimatePrimeFnSp.Classes;
using System.Configuration;
using System.IO;
using System.Globalization;

namespace ClaimatePrimeFnSp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        # region Global Variables

        private global::System.Boolean _IsPgBarFwd;
        private BackgroundWorker _Bwkr;

        private List<TableObject> _Tables;
        private List<string> _FnKeys;
        private List<string> _SpKeys;

        # endregion

        # region Constructors

        public MainWindow()
        {
            InitializeComponent();

            _IsPgBarFwd = true;

            _Bwkr = new BackgroundWorker();
            _Bwkr.DoWork += new DoWorkEventHandler(bwkr_DoWork);
            _Bwkr.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bwkr_RunWorkerCompleted);
        }

        # endregion

        # region Delegates

        private delegate void UpdateControlDelegate();

        # endregion

        # region Form Events

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SetWinData();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void FnSpWin_SizeChanged(object sender, SizeChangedEventArgs e)
        {
            this.FnSpWin.WindowState = System.Windows.WindowState.Maximized;
        }

        # endregion

        # region Private Events

        /// <summary>
        /// 
        /// </summary>
        private void SetWinData()
        {
            FnSpCreator.DbServer = ConfigurationManager.AppSettings["DBServerName"];
            FnSpCreator.DbName = ConfigurationManager.AppSettings["DBName"];
            FnSpCreator.DbUid = ConfigurationManager.AppSettings["DBUserName"];
            FnSpCreator.DbPwd = ConfigurationManager.AppSettings["DBPassword"];
            FnSpCreator.Templates = ConfigurationManager.AppSettings["Templates"];
            FnSpCreator.CreatedScripts = ConfigurationManager.AppSettings["CreatedScripts"];

            this.FnSpWin.Title = string.Concat(FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation");

            tvTables.MinWidth = System.Windows.SystemParameters.PrimaryScreenWidth;
            tvTables.MinHeight = System.Windows.SystemParameters.PrimaryScreenHeight - 50;
            tvTables.MaxWidth = tvTables.MinWidth;
            tvTables.MaxHeight = tvTables.MinHeight;

            pgBar1.Margin = new Thickness(tvTables.Margin.Left, (tvTables.Margin.Top + tvTables.MaxHeight), 0, 0);
            pgBar1.MinWidth = tvTables.MaxWidth;
            pgBar1.MinHeight = 30;

            pgBar1.MaxWidth = pgBar1.MinWidth;
            pgBar1.MaxHeight = pgBar1.MinHeight;

            _Bwkr.RunWorkerAsync();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void bwkr_DoWork(object sender, DoWorkEventArgs e)
        {
            GetTableNames();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void bwkr_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            pgBar1.Value = pgBar1.Maximum;
        }

        /// <summary>
        /// 
        /// </summary>
        private void UpdateProgBar()
        {
            UpdateControlDelegate objUpdateProgBarDelegate;

            if (_IsPgBarFwd)
            {
                objUpdateProgBarDelegate = new UpdateControlDelegate(UpdateProgBarFwd);
                pgBar1.Dispatcher.BeginInvoke(objUpdateProgBarDelegate, System.Windows.Threading.DispatcherPriority.Normal, null);
            }
            else
            {
                objUpdateProgBarDelegate = new UpdateControlDelegate(UpdateProgBarBwd);
            }

            pgBar1.Dispatcher.BeginInvoke(objUpdateProgBarDelegate, System.Windows.Threading.DispatcherPriority.Normal, null);
        }

        /// <summary>
        /// 
        /// </summary>
        private void UpdateProgBarFwd()
        {
            pgBar1.Value++;

            if (pgBar1.Value > (pgBar1.Maximum - 2))
            {
                _IsPgBarFwd = false;
                pgBar1.FlowDirection = System.Windows.FlowDirection.RightToLeft;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void UpdateProgBarBwd()
        {
            pgBar1.Value--;

            if (pgBar1.Value < 2)
            {
                _IsPgBarFwd = true;
                pgBar1.FlowDirection = System.Windows.FlowDirection.LeftToRight;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void GetTableNames()
        {
            UpdateProgBar();

            _Tables = FnSpCreator.GetTableNames("GetTableNames.txt");

            GetScalarFnUsageKeys();
        }

        /// <summary>
        /// 
        /// </summary>
        private void GetScalarFnUsageKeys()
        {
            UpdateProgBar();

            _FnKeys = FnSpCreator.GetScalarFnUsageKeys("ScalarFnUsageKeys.txt");

            GetSpUsageKeys();
        }

        /// <summary>
        /// 
        /// </summary>
        private void GetSpUsageKeys()
        {
            UpdateProgBar();

            _SpKeys = FnSpCreator.GetSpUsageKeys("SpUsageKeys.txt");

            InsCommnFns();
        }

        /// <summary>
        /// 
        /// </summary>
        private void InsCommnFns()
        {
            UpdateProgBar();

            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "WebCulture", FnNames = (new[] { "ufn_IsExists_WebCulture" }).ToList(), SpNames = (new[] { "usp_GetAll_WebCulture", "usp_GetByPkId_WebCulture", "usp_Insert_WebCulture", "usp_IsExists_WebCulture", "usp_Update_WebCulture" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "UserRoleSelect", FnNames = (new[] { "ufn_IsExists_UserRoleSelect" }).ToList(), SpNames = (new[] { "usp_GetByPkId_UserRoleSelect", "usp_Insert_UserRoleSelect", "usp_IsExists_UserRoleSelect", "usp_Update_UserRoleSelect" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "UserReport", SpNames = (new[] { "usp_Insert_UserReport" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "UserPassword", FnNames = (new[] { "ufn_IsExists_UserPassword" }).ToList(), SpNames = (new[] { "usp_GetByPkId_UserPassword", "usp_Insert_UserPassword", "usp_IsExists_UserPassword", "usp_Update_UserPassword" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "UserClinicSelect", FnNames = (new[] { "ufn_IsExists_UserClinicSelect" }).ToList(), SpNames = (new[] { "usp_GetByPkId_UserClinicSelect", "usp_Insert_UserClinicSelect", "usp_IsExists_UserClinicSelect", "usp_Update_UserClinicSelect" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "SyncStatus", SpNames = (new[] { "usp_Insert_SyncStatus", "usp_Update_SyncStatus" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "LogInTrial", FnNames = (new[] { "ufn_IsExists_LogInTrial" }).ToList(), SpNames = (new[] { "usp_GetByPkId_LogInTrial", "usp_Insert_LogInTrial", "usp_IsExists_LogInTrial", "usp_Update_LogInTrial" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "LogInLogOut", FnNames = (new[] { "ufn_IsExists_LogInLogOut" }).ToList(), SpNames = (new[] { "usp_GetByPkId_LogInLogOut", "usp_Insert_LogInLogOut", "usp_IsExists_LogInLogOut", "usp_Update_LogInLogOut" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "LockUnLock", FnNames = (new[] { "ufn_IsExists_LockUnLock" }).ToList(), SpNames = (new[] { "usp_GetByPkId_LockUnLock", "usp_Insert_LockUnLock", "usp_IsExists_LockUnLock", "usp_Update_LockUnLock" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "Audit", TABLE_NAME = "ErrorLog", FnNames = (new[] { "ufn_IsExists_ErrorLog" }).ToList(), SpNames = (new[] { "usp_GetByPkId_ErrorLog", "usp_Insert_ErrorLog", "usp_IsExists_ErrorLog", "usp_Update_ErrorLog" }).ToList() });
            _Tables.Insert(0, new TableObject() { TABLE_SCHEMA = "dbo", TABLE_NAME = "***** Common Functions *****", FnNames = (new[] { "ufn_GetDayFirstSecond", "ufn_GetDayLastSecond", "ufn_GetMonthFirstDate", "ufn_GetMonthLastDate", "ufn_GetPassword", "ufn_GetRandNumber", "ufn_StringEndsWith", "ufn_StringSplit", "ufn_StringStartsWith" }).ToList(), SpNames = (new[] { "usp_GetAll_MvcInit", "usp_GetNext_Identity", "usp_GetStatus_Screen", "usp_GetTime_Server" }).ToList() });

            AddFnSps();
        }

        /// <summary>
        /// 
        /// </summary>
        private void AddFnSps()
        {
            UpdateProgBar();

            for (int i = 11; i < _Tables.Count; i++)
            {
                foreach (string fn in _FnKeys)
                {
                    _Tables[i].FnNames.Add(string.Concat("ufn_", fn, "_", _Tables[i].TABLE_NAME));

                    UpdateProgBar();
                }

                foreach (string sp in _SpKeys)
                {
                    _Tables[i].SpNames.Add(string.Concat("usp_", sp, "_", _Tables[i].TABLE_NAME));

                    UpdateProgBar();
                }

                UpdateProgBar();
            }

            UpdateControlDelegate objUpdateProgBarDelegate = new UpdateControlDelegate(BuildTree);
            tvTables.Dispatcher.BeginInvoke(objUpdateProgBarDelegate, System.Windows.Threading.DispatcherPriority.Normal, null);
        }

        /// <summary>
        /// 
        /// </summary>
        private void BuildTree()
        {
            UpdateProgBar();

            foreach (TableObject objTbl in _Tables)
            {
                TreeViewItem itemTbl = new TreeViewItem() { Header = string.Concat(objTbl.TABLE_SCHEMA, ".", objTbl.TABLE_NAME) };

                TreeViewItem itemfn;

                foreach (string fn in objTbl.FnNames)
                {
                    itemfn = new TreeViewItem();
                    itemfn.Header = string.Concat(objTbl.TABLE_SCHEMA, ".", fn);
                    itemfn.IsExpanded = true;
                    itemTbl.Items.Add(itemfn);

                    UpdateProgBar();
                }

                foreach (string sp in objTbl.SpNames)
                {
                    itemfn = new TreeViewItem();
                    itemfn.Header = string.Concat(objTbl.TABLE_SCHEMA, ".", sp);
                    itemfn.IsExpanded = true;
                    itemTbl.Items.Add(itemfn);

                    UpdateProgBar();
                }

                itemTbl.IsExpanded = true;
                tvTables.Items.Add(itemTbl);

                UpdateProgBar();
            }

            ConfirmGenerate();
        }

        /// <summary>
        /// 
        /// </summary>
        private void ConfirmGenerate()
        {
            UpdateProgBar();

            Int32 itms = tvTables.Items.Count;

            if ((MessageBox.Show(string.Concat("Tables Found: ", (itms - 1), "\nScripts Count: ", ((itms * 5) + 3), "\n\nThis action will delete and re-create the folder '", FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, "'. The current existing contents of this folder will be lost. Are you sure want to continue?"), "Confirmation", MessageBoxButton.YesNo, MessageBoxImage.Warning, MessageBoxResult.No, MessageBoxOptions.DefaultDesktopOnly)) == MessageBoxResult.Yes)
            {
                CreateBlankScript();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void CreateBlankScript()
        {
            UpdateProgBar();

            # region DropUfn

            string filePath = string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "01_DropUfn.sql");

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            FileStream fs = File.Create(filePath);
            fs.Close();
            fs.Dispose();

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), " using ", FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation tool"));
                sw.WriteLine(string.Empty);
                sw.WriteLine("-- Note:- Before executing this script, please a take backup for all existing User Defined function and Stored procedures");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Concat("USE [", FnSpCreator.DbName, "]"));
                sw.WriteLine("GO");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Empty);

                sw.Close();
            }

            UpdateProgBar();

            # endregion

            # region DropUsp

            filePath = string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "02_DropUsp.sql");

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            fs = File.Create(filePath);
            fs.Close();
            fs.Dispose();

            using (StreamWriter sw = new StreamWriter(filePath, true))
            {
                sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), " using ", FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation tool"));
                sw.WriteLine(string.Empty);
                sw.WriteLine("-- Note:- Before executing this script, please a take backup for all existing User Defined function and Stored procedures");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Concat("USE [", FnSpCreator.DbName, "]"));
                sw.WriteLine("GO");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Empty);

                sw.Close();
            }

            UpdateProgBar();

            # endregion

            # region Create Ufn

            filePath = string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "03_CreateUfn.sql");

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            fs = File.Create(filePath);
            fs.Close();
            fs.Dispose();

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), " using ", FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation tool"));
                sw.WriteLine(string.Empty);
                sw.WriteLine("-- Note:- Before executing this script, please a take backup for all existing User Defined function and Stored procedures");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Concat("USE [", FnSpCreator.DbName, "]"));
                sw.WriteLine("GO");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Empty);

                sw.Close();
            }

            UpdateProgBar();

            # endregion

            # region Create Usp

            filePath = string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "04_CreateUsp.sql");

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }

            fs = File.Create(filePath);
            fs.Close();
            fs.Dispose();

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), " using ", FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation tool"));
                sw.WriteLine(string.Empty);
                sw.WriteLine("-- Note:- Before executing this script, please a take backup for all existing User Defined function and Stored procedures");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Concat("USE [", FnSpCreator.DbName, "]"));
                sw.WriteLine("GO");
                sw.WriteLine(string.Empty);
                sw.WriteLine(string.Empty);

                sw.Close();
            }

            # endregion

            CreateFullScript();
        }

        /// <summary>
        /// 
        /// </summary>
        private void CreateFullScript()
        {
            UpdateProgBar();

            string strTmpl;

            foreach (TableObject tbl in _Tables)
            {
                # region FN

                foreach (string fn in tbl.FnNames)
                {
                    # region Drop Script

                    using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", "DropFn.txt")))
                    {
                        strTmpl = sr.ReadToEnd();
                        sr.Close();
                    }

                    using (StreamWriter sw = new StreamWriter(string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "01_DropUfn.sql"), true))
                    {
                        strTmpl = strTmpl.Replace("[xTABLE_SCHEMAx]", tbl.TABLE_SCHEMA)
                                            .Replace("[xFN_SP_NAMEx]", fn);

                        sw.WriteLine(strTmpl);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", fn, " ************************* Completed."));
                        sw.WriteLine(string.Empty);

                        sw.Close();
                    }

                    # endregion

                    # region Create Script

                    if (tbl.IsAudit)
                    {
                        using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", fn.Replace("_", string.Empty), ".txt")))
                        {
                            strTmpl = sr.ReadToEnd();
                            sr.Close();
                        }
                    }
                    else
                    {
                        List<string> ufnUspNmArr = fn.Split(Convert.ToChar("_")).ToList();

                        using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", ufnUspNmArr[0], ufnUspNmArr[1], ".txt")))
                        {
                            strTmpl = sr.ReadToEnd();
                            sr.Close();
                        }

                        if (string.Compare(ufnUspNmArr[1], "IsExists", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region IsExists

                            string strParams = string.Empty;
                            string strConti = string.Empty;
                            string strContiCase = string.Empty;

                            foreach (FieldObject fldObj in tbl.FieldObjects)
                            {
                                if (fldObj.IsAudit)
                                {
                                    continue;
                                }

                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                if (fldObj.IS_NULLABLE)
                                {
                                    if ((string.Compare(fldObj.DATA_TYPE, "NCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NTEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NVARCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "TEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "VARCHAR", true) == 0))
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t("
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] COLLATE LATIN1_GENERAL_CS_AS = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t("
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");
                                    }
                                    else
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t("
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t("
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");
                                    }
                                }
                                else
                                {
                                    if ((string.Compare(fldObj.DATA_TYPE, "NCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NTEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NVARCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "TEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "VARCHAR", true) == 0))
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t"
                                             , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] COLLATE LATIN1_GENERAL_CS_AS = @", fldObj.COLUMN_NAME);

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t"
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                                    }
                                    else
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t"
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t"
                                            , "[", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                                    }
                                }
                            }

                            if (strParams.Length > 3)
                            {
                                strParams = strParams.Substring(4);
                            }

                            if (strConti.Length > 9)
                            {
                                strConti = strConti.Substring(10);
                            }

                            if (strContiCase.Length > 9)
                            {
                                strContiCase = strContiCase.Substring(10);
                            }

                            strTmpl = strTmpl.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xWHERE_CONDITIONSx]", strConti)
                                            .Replace("[xWHERE_CONDITIONS_CASEx]", strContiCase);

                            # endregion
                        }
                    }

                    strTmpl = strTmpl.Replace("[xTABLE_SCHEMAx]", tbl.TABLE_SCHEMA)
                                        .Replace("[xTABLE_NAMEx]", tbl.TABLE_NAME)
                                        .Replace("[xPK_DATA_TYPEx]", tbl.PkDataType);

                    using (StreamWriter sw = new StreamWriter(string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "03_CreateUfn.sql"), true))
                    {
                        sw.WriteLine(strTmpl);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", fn, " ************************* Completed."));
                        sw.WriteLine(string.Empty);
                    }

                    # endregion

                    UpdateProgBar();
                }

                # endregion

                # region SP

                foreach (string sp in tbl.SpNames)
                {
                    # region Drop Script

                    using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", "DropSp.txt")))
                    {
                        strTmpl = sr.ReadToEnd();
                        sr.Close();
                    }

                    using (StreamWriter sw = new StreamWriter(string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "02_DropUsp.sql"), true))
                    {
                        strTmpl = strTmpl.Replace("[xTABLE_SCHEMAx]", tbl.TABLE_SCHEMA)
                                            .Replace("[xFN_SP_NAMEx]", sp);

                        sw.WriteLine(strTmpl);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", sp, " ************************* Completed."));
                        sw.WriteLine(string.Empty);

                        sw.Close();
                    }

                    # endregion

                    # region Create Script

                    if (tbl.IsAudit)
                    {
                        using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", sp.Replace("_", string.Empty), ".txt")))
                        {
                            strTmpl = sr.ReadToEnd();
                            sr.Close();
                        }
                    }
                    else
                    {
                        List<string> ufnUspNmArr = sp.Split(Convert.ToChar("_")).ToList();

                        using (StreamReader sr = new StreamReader(string.Concat(FnSpCreator.Templates, @"\", ufnUspNmArr[0], ufnUspNmArr[1], ".txt")))
                        {
                            strTmpl = sr.ReadToEnd();
                            sr.Close();
                        }

                        if (string.Compare(ufnUspNmArr[1], "IsExists", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region IsExists

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;

                            foreach (FieldObject fldObj in tbl.FieldObjects)
                            {
                                if (fldObj.IsAudit)
                                {
                                    continue;
                                }

                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);
                            }

                            if (strParams.Length > 3)
                            {
                                strParams = strParams.Substring(4);
                            }

                            if (strFnArgs.Length > 1)
                            {
                                strFnArgs = strFnArgs.Substring(2);
                            }

                            strTmpl = strTmpl.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs);

                            # endregion
                        }
                        else if (string.Compare(ufnUspNmArr[1], "Insert", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region Insert

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;
                            string strInsFlds = string.Empty;
                            string strInsVars = string.Empty;

                            foreach (FieldObject fldObj in tbl.FieldObjects)
                            {
                                if (fldObj.IsAudit)
                                {
                                    continue;
                                }

                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);

                                strInsFlds = string.Concat(strInsFlds, "\n\t\t\t\t, [", fldObj.COLUMN_NAME, "]");
                                strInsVars = string.Concat(strInsVars, "\n\t\t\t\t, @", fldObj.COLUMN_NAME);
                            }

                            if (strParams.Length > 3)
                            {
                                strParams = strParams.Substring(4);
                            }

                            if (strFnArgs.Length > 1)
                            {
                                strFnArgs = strFnArgs.Substring(2);
                            }

                            if (strInsFlds.Length > 6)
                            {
                                strInsFlds = strInsFlds.Substring(7);
                            }

                            if (strInsVars.Length > 6)
                            {
                                strInsVars = strInsVars.Substring(7);
                            }

                            strTmpl = strTmpl.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs)
                                            .Replace("[xINSERT_FIELDSx]", strInsFlds)
                                            .Replace("[xINSERT_VARSx]", strInsVars);

                            # endregion
                        }
                        else if (string.Compare(ufnUspNmArr[1], "Update", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region Update

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;
                            string strInsFlds = string.Empty;
                            string strSelFlds = string.Empty;
                            string strUpdFlds = string.Empty;

                            foreach (FieldObject fldObj in tbl.FieldObjects)
                            {
                                if (fldObj.IsAudit)
                                {
                                    continue;
                                }

                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);

                                strInsFlds = string.Concat(strInsFlds, "\n\t\t\t\t\t\t, [", fldObj.COLUMN_NAME, "]");
                                strSelFlds = string.Concat(strSelFlds, "\n\t\t\t\t\t, [", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]");
                                strUpdFlds = string.Concat(strUpdFlds, "\n\t\t\t\t\t, [", tbl.TABLE_SCHEMA, "].[", tbl.TABLE_NAME, "].["
                                    , fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                            }

                            if (strParams.Length > 3)
                            {
                                strParams = strParams.Substring(4);
                            }

                            if (strFnArgs.Length > 1)
                            {
                                strFnArgs = strFnArgs.Substring(2);
                            }

                            if (strInsFlds.Length > 6)
                            {
                                strInsFlds = strInsFlds.Substring(7);
                            }

                            if (strSelFlds.Length > 5)
                            {
                                strSelFlds = strSelFlds.Substring(6);
                            }

                            if (strUpdFlds.Length > 7)
                            {
                                strUpdFlds = strUpdFlds.Substring(8);
                            }

                            strTmpl = strTmpl.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs)
                                            .Replace("[xINSERT_FIELDSx]", strInsFlds)
                                            .Replace("[xSELECT_FIELDSx]", strSelFlds)
                                            .Replace("[xUPDATE_FIELDSx]", strUpdFlds);

                            # endregion
                        }
                    }

                    strTmpl = strTmpl.Replace("[xTABLE_SCHEMAx]", tbl.TABLE_SCHEMA)
                                        .Replace("[xTABLE_NAMEx]", tbl.TABLE_NAME)
                                        .Replace("[xPK_DATA_TYPEx]", tbl.PkDataType);

                    using (StreamWriter sw = new StreamWriter(string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "04_CreateUsp.sql"), true))
                    {
                        sw.WriteLine(strTmpl);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", sp, " ************************* Completed."));
                        sw.WriteLine(string.Empty);
                    }

                    # endregion

                    UpdateProgBar();
                }

                # endregion

                UpdateProgBar();
            }

            TmpSRS();

            MessageBox.Show(string.Concat("The created scripts are available at: ", FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts));
        }

        /// <summary>
        /// 
        /// </summary>
        private void TmpSRS()
        {
            # region For WebCulture

            //UpdateProgBar();

            //# region Tmp_SRS

            //string filePath = string.Concat(FnSpCreator.Templates, @"\", FnSpCreator.CreatedScripts, @"\", "00_WebCulture_Tmp.sql");

            //if (File.Exists(filePath))
            //{
            //    File.Delete(filePath);
            //}

            //FileStream fs = File.Create(filePath);
            //fs.Close();
            //fs.Dispose();

            //using (StreamWriter sw = new StreamWriter(filePath))
            //{
            //    sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), " using ", FnSpCreator.DbName, " [", FnSpCreator.DbServer, "] : ", "Basic (Common) Scalar Function and Stored Procedure Script Creation tool"));
            //    sw.WriteLine(string.Empty);
            //    sw.WriteLine(string.Concat("USE [", FnSpCreator.DbName, "]"));
            //    sw.WriteLine("GO");
            //    sw.WriteLine(string.Empty);
            //    sw.WriteLine(string.Empty);

            //    //sw.WriteLine("IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[WebCulture]') AND type in (N'U'))");
            //    //sw.WriteLine("DROP TABLE [Audit].[WebCulture]");
            //    //sw.WriteLine("GO");
            //    //sw.WriteLine(string.Empty);
            //    //sw.WriteLine("SET ANSI_NULLS ON");
            //    //sw.WriteLine("GO");
            //    //sw.WriteLine(string.Empty);
            //    //sw.WriteLine("SET QUOTED_IDENTIFIER ON");
            //    //sw.WriteLine("GO");
            //    //sw.WriteLine("CREATE TABLE [Audit].[WebCulture](");
            //    //sw.WriteLine("      [KeyName] [nvarchar](12) NOT NULL,");
            //    //sw.WriteLine("      [EnglishName] [nvarchar](150) NOT NULL,");
            //    //sw.WriteLine("      [NativeName] [nvarchar](150) NOT NULL,");
            //    //sw.WriteLine("      [IsActive] [bit] NOT NULL,");
            //    //sw.WriteLine("  CONSTRAINT [PK_WebCulture] PRIMARY KEY CLUSTERED ");
            //    //sw.WriteLine("  (");
            //    //sw.WriteLine("      [KeyName] ASC");
            //    //sw.WriteLine("  )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]");
            //    //sw.WriteLine(") ON [PRIMARY]");
            //    //sw.WriteLine("GO");
            //    //sw.WriteLine(string.Empty);

            //    sw.WriteLine(string.Empty);

            //    List<CultureInfo> cultures = (CultureInfo.GetCultures(CultureTypes.AllCultures)).ToList();

            //    foreach (CultureInfo item in cultures)
            //    {
            //        sw.WriteLine(string.Concat("INSERT INTO [Audit].[WebCulture]([KeyName], [EnglishName], [NativeName], [IsActive]) VALUES (N'", item.Name, "', N'", item.EnglishName.Replace("'", "''"), "', N'", item.NativeName.Replace("'", "''"), "', '0')"));
            //    }

            //    sw.Close();
            //}

            //UpdateProgBar();

            //# endregion

            //UpdateProgBar();

            # endregion
        }

        # endregion
    }
}
