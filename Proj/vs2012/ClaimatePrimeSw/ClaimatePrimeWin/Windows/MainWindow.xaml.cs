using ArivaEmail;
using ClaimatePrimeConstants;
using ClaimatePrimeWin.SecuredFolder.BaseWpfs;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Threading;

namespace ClaimatePrimeWin.Windows
{
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

            if (IsProcNotOpened())
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString))
                {
                    SqlTransaction trans = null;
                    string userDispName = "Auto Sync";

                    try
                    {
                        # region Web Site

                        # region Default Files

                        // http://www.codeproject.com/KB/web-cache/CachingDependencies.aspx
                        // http://www.dotnetcurry.com/ShowArticle.aspx?ID=263
                        // http://forums.asp.net/t/1249281.aspx/1

                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.NO_FILE_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.NO_FILE_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.NO_PHOTO_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.PDF_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.PDF_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.WORD_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.WORD_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.EXCEL_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.EXCEL_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.ATTACHMENT_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.ATTACHMENT_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.POWER_POINT_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.POWER_POINT_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.ZIP_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.ZIP_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.NOTE_PAD_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.NOTE_PAD_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.TIFF_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.TIFF_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.RTF_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.EDI_ICON), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.EDI_ICON), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.NO_DOCTOR_NOTE), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.NO_DOCTOR_NOTE), true);
                        File.Copy(string.Concat(WebRootPath, @"\Images\", Constants.XMLSchema.NO_SUPER_BILL), string.Concat(FileSvrRootPath, @"\", Constants.XMLSchema.NO_SUPER_BILL), true);

                        # endregion

                        # region Delete ReportTmp (300 Mins)

                        // Same Code is available at 3 Places (1) WebSite PreLogin Controller, (2) Data Sync Exe and (3) Excel Export Exe

                        DateTime currUtc = DateTime.UtcNow;

                        string[] filePaths = Directory.GetFiles(string.Concat(WebRootPath, @"\ReportTmp"), "*.*", SearchOption.AllDirectories);

                        foreach (string item in filePaths)
                        {
                            FileInfo fi = new FileInfo(item);
                            DateTime fiUtc = fi.LastWriteTimeUtc;
                            Int64 utcDiff = DateAndTime.GetDateDiff(DateIntervals.MINUTE, fiUtc, currUtc);

                            if (utcDiff > 300)
                            {
                                try
                                {
                                    fi.Delete();
                                }
                                catch (Exception)
                                {
                                    // Ignore this. Because now file not deleted that means the file is using by others or opened by others
                                }
                            }

                            fi = null;
                        }

                        # endregion

                        # endregion

                        # region Sync Started

                        if (App.UserID.HasValue)
                        {
                            con.Open();

                            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SYNC_START"], con))
                            {
                                cmd.CommandTimeout = con.ConnectionTimeout;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add(new SqlParameter() { ParameterName = "UserID", DbType = DbType.Int32, Direction = ParameterDirection.Input, Value = App.UserID.Value });
                                cmd.ExecuteNonQuery();
                            }

                            con.Close();

                            con.Open();

                            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SYNC_BY"], con))
                            {
                                cmd.CommandTimeout = con.ConnectionTimeout;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add(new SqlParameter() { ParameterName = "UserID", DbType = DbType.Int32, Direction = ParameterDirection.Input, Value = App.UserID.Value });

                                using (SqlDataReader dr = cmd.ExecuteReader())
                                {
                                    while (dr.Read())
                                    {
                                        string nm = Convert.ToString(dr["NAME"]);
                                        userDispName = string.Concat(nm, " [", dr["CODE"], "]");
                                        EmailAddrs.Add(new EmailAddress(Convert.ToString(dr["EMAIL"]), nm));
                                    }

                                    dr.Close();
                                }
                            }

                            con.Close();
                        }
                        else
                        {
                            con.Open();

                            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SYNC_START"], con))
                            {
                                cmd.CommandTimeout = con.ConnectionTimeout;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Add(new SqlParameter() { ParameterName = "UserID", DbType = DbType.Int32, Direction = ParameterDirection.Input, Value = DBNull.Value });
                                cmd.ExecuteNonQuery();
                            }

                            con.Close();
                        }

                        # endregion

                        # region Synchronizing

                        foreach (string updateSp in UpdateSPs)
                        {
                            con.Open();
                            trans = con.BeginTransaction();

                            using (SqlCommand cmd = new SqlCommand(updateSp, con))
                            {
                                cmd.CommandTimeout = con.ConnectionTimeout;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Transaction = trans;
                                cmd.ExecuteNonQuery();
                            }

                            trans.Commit();
                            con.Close();
                            trans = null;
                        }

                        # endregion

                        # region Excel Export

                        // http://www.dotnetperls.com/process-start
                        // http://stackoverflow.com/questions/3464289/how-to-pass-multiple-arguments-to-a-newly-created-process-in-c-sharp-net

                        string[] args = { Convert.ToString(App.UserID.HasValue), "0", "0", "1900", "1", "2", "1900", "1", "1" };
                        Process.Start(string.Concat(WebRootPath, @"\ExcelExport\ExportExcelWin.exe"), String.Join(" ", args));

                        # endregion

                        # region Sync Completed - Success

                        con.Open();

                        using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SYNC_END"], con))
                        {
                            cmd.CommandTimeout = con.ConnectionTimeout;
                            cmd.CommandType = CommandType.Text;
                            cmd.Transaction = trans;
                            cmd.ExecuteNonQuery();
                        }

                        con.Close();

                        SendEmail
                            (
                                File.ReadAllText(string.Concat(WebRootPath, @"\Templates\SyncSummary.htm"))
                                    .Replace("[01 StartedOn 01]", string.Concat(CurrSyncOn.ToLongDateString(), " ", CurrSyncOn.ToLongTimeString()))
                                    .Replace("[02 EndedOn 02]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                                    .Replace("[03 Status 03]", "Success")
                                    .Replace("[04 DB Server 04]", DBSvrName)
                                    .Replace("[05 DB Name 05]", DBName)
                                    .Replace("[06 DispName 06]", userDispName)
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
                        }

                        # region Sync Completed - Error

                        con.Open();

                        using (SqlCommand cmd = new SqlCommand("UPDATE [Audit].[SyncStatus] SET [EndOn] = GETDATE(), [IsSuccess] = 0 WHERE [EndOn] IS NULL;", con))
                        {
                            cmd.CommandTimeout = con.ConnectionTimeout;
                            cmd.CommandType = CommandType.Text;
                            cmd.ExecuteNonQuery();
                        }

                        con.Close();

                        SendEmail
                            (
                                File.ReadAllText(string.Concat(WebRootPath, @"\Templates\SyncSummary.htm"))
                                    .Replace("[01 StartedOn 01]", string.Concat(CurrSyncOn.ToLongDateString(), " ", CurrSyncOn.ToLongTimeString()))
                                    .Replace("[02 EndedOn 02]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                                    .Replace("[03 Status 03]", string.Concat("ERROR - REASON: ", ex.ToString()))
                                    .Replace("[04 DB Server 04]", DBSvrName)
                                    .Replace("[05 DB Name 05]", DBName)
                                    .Replace("[06 DispName 06]", userDispName)
                                    .Replace("[07 Form Title 07]", Title)
                                    .Replace("[v ExeVersion v]", ExeVersion)
                                    .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                            );

                        # endregion
                    }
                    finally
                    {
                        if (con.State != ConnectionState.Closed)
                        {
                            con.Close();
                        }
                    }
                }
            }

            this.Close();
        }

        # endregion
    }
}
