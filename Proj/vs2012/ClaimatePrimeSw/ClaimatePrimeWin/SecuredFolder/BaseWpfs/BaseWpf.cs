using ArivaEmail;
using ClaimatePrimeConstants;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Windows;

namespace ClaimatePrimeWin.SecuredFolder.BaseWpfs
{
    # region BaseWpf

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class BaseWpf : Window
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public string ExeVersion { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected string AppRootPath { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected string WebRootPath { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected string FileSvrRootPath { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected DateTime CurrSyncOn { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected LastSync LastSync { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected string DBSvrName { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected string DBName { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected List<string> UpdateSPs { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        protected List<EmailAddress> EmailAddrs { get; private set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseWpf()
        {
            Title = ConfigurationManager.AppSettings["FORM_TITLE"];

            # region SiteVersion

            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location);
            ExeVersion = (String.Format("{0}.{1}.{2}.{3}", fvi.ProductMajorPart, fvi.ProductMinorPart, fvi.ProductBuildPart, fvi.ProductPrivatePart));

            # endregion

            AppRootPath = System.IO.Path.GetDirectoryName(Process.GetCurrentProcess().MainModule.FileName);
            FileSvrRootPath = ConfigurationManager.AppSettings["FILE_SERVER_ROOT_DIR"];

            if (RunMode.IsDebug)
            {
                WebRootPath = Microsoft.VisualBasic.Interaction.InputBox("Templates path: ", Title, @"D:\working folder\ClaimatePrime\Proj\vs2012\ClaimatePrimeSw\ClaimatePrimeWeb\Templates");
            }
            else
            {
                WebRootPath = AppRootPath;
            }

            WebRootPath = WebRootPath.Substring(0, (WebRootPath.LastIndexOf(@"\")));

            # region Read DateTime

            try
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString))
                {
                    DBSvrName = con.DataSource;
                    DBName = con.Database;

                    CurrSyncOn = DateTime.Now;

                    con.Open();

                    using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["DT_TM_SP"], con))
                    {
                        cmd.CommandTimeout = con.ConnectionTimeout;
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                CurrSyncOn = Convert.ToDateTime(dr["CURR_DT_TM"]);
                            }

                            dr.Close();
                        }
                    }

                    con.Close();

                    LastSync = new LastSync(0, new DateTime(1900, 1, 1), DateTime.Now, false, 0, string.Empty);

                    con.Open();

                    using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["LAST_SYNC"], con))
                    {
                        cmd.CommandTimeout = con.ConnectionTimeout;
                        cmd.CommandType = CommandType.StoredProcedure;

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                LastSync = new LastSync(Convert.ToInt64(dr["SyncStatusID"]), Convert.ToDateTime(dr["StartOn"]), Converts.AsDateTimeNullable(dr["EndOn"]), Converts.AsBooleanNullable(dr["IsSuccess"]), Converts.AsInt32Nullable(dr["UserID"]), Convert.ToString(dr["DISP_NAME"]));
                            }

                            dr.Close();
                        }
                    }

                    con.Close();
                }
            }
            catch (Exception ex)
            {
                Alert(ex);
                this.Close();
            }

            # endregion

            # region Read Update SP

            UpdateSPs = new List<string>();

            for (int i = 1; ; i++)
            {
                string tmp = ConfigurationManager.AppSettings[string.Concat("UPDATE_SPNAME", i)];

                if (string.IsNullOrWhiteSpace(tmp))
                {
                    break;
                }

                UpdateSPs.Add(tmp);
            }

            # endregion

            # region Read EMail Address

            EmailAddrs = new List<EmailAddress>();

            for (int i = 1; ; i++)
            {
                string tmp = ConfigurationManager.AppSettings[string.Concat("EMAIL_ADDR", i)];

                if (string.IsNullOrWhiteSpace(tmp))
                {
                    break;
                }

                string[] tmps = tmp.Split(Convert.ToChar("["));

                if (tmps.Length == 2)
                {
                    EmailAddrs.Add(new EmailAddress(tmps[0].Trim(), (tmps[1].Replace("]", string.Empty)).Trim()));
                }
                else
                {
                    Alert(new Exception(string.Concat("EMAIL_ADDR", i, ": Contains invalid email address and name")));
                    break;
                }
            }

            # endregion
        }

        # endregion

        # region Protected Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetDateSep()
        {
            return System.Threading.Thread.CurrentThread.CurrentUICulture.DateTimeFormat.DateSeparator;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetTimeSep()
        {
            return System.Threading.Thread.CurrentThread.CurrentUICulture.DateTimeFormat.TimeSeparator;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetDateStr()
        {
            string dtSep = GetDateSep();

            return string.Concat("MM", dtSep, "dd", dtSep, "yyyy");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetTimeStr()
        {
            string tmSep = GetTimeSep();

            return string.Concat("HH", tmSep, "mm", tmSep, "ss");
        }

        /// <summary>
        /// 
        /// </summary>
        public string GetDateTimeStr()
        {
            return string.Concat(GetDateStr(), " ", GetTimeStr());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDate"></param>
        /// <returns></returns>
        public string GetDateStr(DateTime? pDate)
        {
            if (pDate.HasValue)
            {
                return pDate.Value.ToString(GetDateStr());
            }

            return GetDateStr();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDate"></param>
        /// <returns></returns>
        public string GetTimeStr(DateTime? pDate)
        {
            if (pDate.HasValue)
            {
                return pDate.Value.ToString(GetTimeStr());
            }

            return GetTimeStr();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDate"></param>
        /// <returns></returns>
        public string GetDateTimeStr(DateTime? pDate)
        {
            return string.Concat(GetDateStr(pDate), " ", GetTimeStr(pDate));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSuccessMsg"></param>
        protected void Alert(string pSuccessMsg)
        {
            while (pSuccessMsg.Length < 75)
            {
                pSuccessMsg = string.Concat(pSuccessMsg, " ");
            }

            MessageBox.Show(pSuccessMsg, string.Concat(Title, " : ", GetDateTimeStr(CurrSyncOn)), MessageBoxButton.OK, MessageBoxImage.Information, MessageBoxResult.OK);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ex"></param>
        protected void Alert(Exception ex)
        {
            string errorMsg = ex.ToString();

            while (errorMsg.Length < 75)
            {
                errorMsg = string.Concat(errorMsg, " ");
            }

            MessageBox.Show(errorMsg, string.Concat(Title, " : ", GetDateTimeStr(CurrSyncOn)), MessageBoxButton.OK, MessageBoxImage.Error, MessageBoxResult.OK);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        protected bool IsProcNotOpened()
        {
            try
            {
                string currentProcessName = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
                string currentProcessPath = System.Diagnostics.Process.GetCurrentProcess().Modules[0].FileName;
                System.Diagnostics.Process[] openedProcesses = System.Diagnostics.Process.GetProcessesByName(currentProcessName);

                if (openedProcesses.Length > 1)
                {
                    Int32 openedProcessCount = (from oOpenedProcess in openedProcesses
                                                where string.Compare(oOpenedProcess.Modules[0].FileName, currentProcessPath, true) == 0
                                                select oOpenedProcess).Count();

                    if (openedProcessCount > 1)
                    {
                        return false;
                    }
                }

                if (!(LastSync.EndOn.HasValue))
                {
                    if ((DateAndTime.GetDateDiff(DateIntervals.DAY, LastSync.StartOn, CurrSyncOn) < 1) && (DateAndTime.GetDateDiff(DateIntervals.HOUR, LastSync.StartOn, CurrSyncOn) < 5) && (DateAndTime.GetDateDiff(DateIntervals.MINUTE, LastSync.StartOn, CurrSyncOn) < 300))
                    {
                        return false;
                    }
                }
            }
            catch (Exception)
            {
                // Ignore this.
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pBody"></param>
        protected void SendEmail(string pBody)
        {
            ArivaEmailMessage objEmail = new ArivaEmailMessage();
            objEmail.Send(true, EmailAddrs, null, null, null, ConfigurationManager.AppSettings[string.Concat("EMAIL_SUBJ")], pBody, null, null, null);
        }

        # endregion
    }

    # endregion

    # region LastSync

    /// <summary>
    /// 
    /// </summary>
    public class LastSync
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public long SyncStatusID { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DateTime StartOn { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DateTime? EndOn { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public bool? IsSuccess { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int? UserID { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string UserName { get; private set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSyncStatusID"></param>
        /// <param name="pStartOn"></param>
        /// <param name="pEndOn"></param>
        /// <param name="pIsSuccess"></param>
        /// <param name="pUserID"></param>
        /// <param name="pUserName"></param>
        public LastSync(long pSyncStatusID, DateTime pStartOn, DateTime? pEndOn, bool? pIsSuccess, int? pUserID, string pUserName)
        {
            this.SyncStatusID = pSyncStatusID;
            this.StartOn = pStartOn;
            this.EndOn = pEndOn;
            this.IsSuccess = pIsSuccess;
            this.UserID = pUserID;
            this.UserName = pUserName;
        }

        # endregion
    }

    # endregion
}
