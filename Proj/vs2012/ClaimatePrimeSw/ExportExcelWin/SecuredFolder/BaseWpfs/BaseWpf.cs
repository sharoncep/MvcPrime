using ArivaEmail;
using ClaimatePrimeConstants;
using ExportExcelWin.Classes;
using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows;

namespace ExportExcelWin.SecuredFolder.BaseWpfs
{
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
        public string FileSvrRptRootPath { get; private set; }

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
        protected DayStatus CurrImpoOn { get; private set; }

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

            FileSvrRptRootPath = string.Concat(FileSvrRootPath, @"\", "Reports");       // This Reports hard coded  in Web Site also
            if (!(Directory.Exists(FileSvrRptRootPath)))
            {
                Directory.CreateDirectory(FileSvrRptRootPath);
            }

            if (RunMode.IsDebug)
            {
                WebRootPath = Microsoft.VisualBasic.Interaction.InputBox("Templates path: ", Title, @"D:\working folder\ClaimatePrime\Proj\vs2012\ClaimatePrimeSw\ClaimatePrimeWeb\Templates");
                App.UserID = Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("User ID", Title, "1"));
                App.ReportTypeID = Converts.AsByte(Microsoft.VisualBasic.Interaction.InputBox("Report Type ID", Title, "1"));
                App.ReportObjectID = Converts.AsInt64(Microsoft.VisualBasic.Interaction.InputBox("Report Object ID", Title, "1"));
                App.DateFrom = new DateTime(Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Year From", Title, DateTime.Now.Year.ToString())), Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Month From", Title, DateTime.Now.Month.ToString())), Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Day From", Title, DateTime.Now.Day.ToString())));
                App.DateTo = new DateTime(Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Year To", Title, DateTime.Now.Year.ToString())), Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Month To", Title, DateTime.Now.Month.ToString())), Converts.AsInt(Microsoft.VisualBasic.Interaction.InputBox("Day To", Title, DateTime.Now.AddDays(-1).Day.ToString())));
            }
            else
            {
                WebRootPath = AppRootPath;
            }

            WebRootPath = WebRootPath.Substring(0, (WebRootPath.LastIndexOf(@"\")));

            # region Read DateTime

            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString))
            {
                DBSvrName = cn.DataSource;
                DBName = cn.Database;
                SqlTransaction trans = null;

                try
                {
                    # region DAY_STS

                    cn.Open();
                    CurrImpoOn = new DayStatus();
                    CurrImpoOn.Select("DAY_STS", cn);
                    cn.Close();

                    if (CurrImpoOn.DAY_STS)
                    {
                        App.UserID = 0;
                    }
                    else
                    {
                        if (App.UserID > 0)
                        {
                            CurrImpoOn.DAY_STS = true;
                        }
                    }

                    # endregion
                }
                catch (Exception ex)
                {
                    if (trans != null)
                    {
                        trans.Rollback();
                        cn.Close();
                    }

                    App.ErrMsg = ex.ToString();
                }
                finally
                {
                    if (cn.State != ConnectionState.Closed)
                    {
                        cn.Close();
                    }
                }
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

            if (App.UserID == 0)
            {
                App.ReportTypeID = 0;
                App.ReportObjectID = 0;
                App.DateFrom = new DateTime(1900, 1, 2);
                App.DateTo = new DateTime(1900, 1, 1);
            }
            else if (App.ReportTypeID == 0)
            {
                App.ReportObjectID = 0;
                App.DateFrom = new DateTime(1900, 1, 2);
                App.DateTo = new DateTime(1900, 1, 1);
            }
            else
            {
            }
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

            MessageBox.Show(pSuccessMsg, Title, MessageBoxButton.OK, MessageBoxImage.Information, MessageBoxResult.OK);
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

            MessageBox.Show(errorMsg, Title, MessageBoxButton.OK, MessageBoxImage.Error, MessageBoxResult.OK);
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
}
