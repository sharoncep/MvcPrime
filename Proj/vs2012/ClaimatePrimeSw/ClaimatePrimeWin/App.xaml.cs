using ClaimatePrimeConstants;
using System.Globalization;
using System.Threading;
using System.Windows;

namespace ClaimatePrimeWin
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static int? UserID;

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en");
            Thread.CurrentThread.CurrentUICulture = Thread.CurrentThread.CurrentCulture;

            if ((e.Args != null) && (e.Args.Length == 1))
            {
                UserID = Converts.AsIntNullable(e.Args[0]);
            }
        }
    }
}
