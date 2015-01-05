using System;
using System.Diagnostics;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.Controllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;

namespace ClaimatePrimeControllers.SecuredFolder.CustomErrors
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ArivaErrors : IHttpModule
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ArivaErrors()
        {
        }

        # endregion

        #region Implementation of IHttpModule

        /// <summary>
        /// 
        /// </summary>
        /// <param name="app"></param>
        public void Init(HttpApplication app)
        {
            app.Error += new System.EventHandler(app_Error);
            app.BeginRequest += new EventHandler(app_BeginRequest);
        }

        /// <summary>
        /// 
        /// </summary>
        public void Dispose()
        {
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void app_BeginRequest(object sender, EventArgs e)
        {
            if (HttpContext.Current.Request.ContentLength > (49 * 1034 * 1034))    // 50 MB - 1 MB   <httpRuntime maxRequestLength="51200" /> <!--50 MB-->
            {
                StaticClass.SendErrorEmail(new Exception("Page size exceeds : 49 MB"));
                ArivaSession.Initialize("RR=MPS");
                return;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="obj"></param>
        /// <param name="args"></param>
        private void app_Error(object obj, EventArgs args)
        {
            if (!(RunMode.IsDebug))
            {
                // At this point we have information about the error
                // http://stackoverflow.com/questions/14629304/httpcontext-current-request-isajaxrequest-error-in-mvc-4
                Exception ex = (new HttpRequestWrapper(HttpContext.Current.Request)).RequestContext.HttpContext.Server.GetLastError();
                StaticClass.SendErrorEmail(ex);

                // --------------------------------------------------
                // To let the page finish running we clear the error
                // --------------------------------------------------
                HttpContext.Current.Server.ClearError();

                //
                if ((new HttpContextWrapper(HttpContext.Current)).Request.IsAjaxRequest())
                {
                    ArivaSession.Initialize("RR=SRS_EA_DEA");
                }
                else
                {
                    string exMsg = ex.ToString();

                    if (((exMsg.StartsWith("The controller for path", StringComparison.CurrentCultureIgnoreCase)) && (exMsg.EndsWith("was not found or does not implement IController.", StringComparison.CurrentCultureIgnoreCase))) ||
                        ((exMsg.StartsWith("A public action method", StringComparison.CurrentCultureIgnoreCase)) && (exMsg.Contains("was not found on controller")) && (exMsg.EndsWith("Controller'.", StringComparison.CurrentCultureIgnoreCase))))
                    {
                        ArivaSession.Initialize("RR=E404");
                    }
                    else
                    {
                        ArivaSession.Initialize("RR=EUEX");
                    }
                }
            }
        }

        # endregion
    }
}