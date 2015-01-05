using ClaimatePrimeConstants;
using System;
using System.Globalization;
using System.Threading;
using System.Windows;

namespace ExportExcelWin
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static int UserID;
        public static byte ReportTypeID;
        public static long ReportObjectID;
        public static DateTime DateFrom;
        public static DateTime DateTo;
        public static string ErrMsg;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en");
            Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;

            // ID Zero means ALL REPORT / OBJECT
            // FromDate is LESS than ToDate means NOT DATE RELATED REPORT / OBJECT

            if ((e.Args == null) || (e.Args.Length == 0))
            {
                UserID = 0;
                ReportTypeID = 0;
                ReportObjectID = 0;
                DateFrom = DateTime.Now.AddMonths(-1);
                DateTo = DateTime.Now;
                ErrMsg = string.Empty;
            }
            else if (e.Args.Length < 10)
            {
                UserID = Converts.AsInt(e.Args[0]);
                ReportTypeID = Converts.AsByte(e.Args[1]);
                ReportObjectID = Converts.AsInt64(e.Args[2]);
                DateFrom = new DateTime(Converts.AsInt(e.Args[3]), Converts.AsInt(e.Args[4]), Converts.AsInt(e.Args[5]));
                DateTo = new DateTime(Converts.AsInt(e.Args[6]), Converts.AsInt(e.Args[7]), Converts.AsInt(e.Args[8]));
            }
            else
            {
                ErrMsg = "Argument length should be less than 10";
            }
        }
    }
}
