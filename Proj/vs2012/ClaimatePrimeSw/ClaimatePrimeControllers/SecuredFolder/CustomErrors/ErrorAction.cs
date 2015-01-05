using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using ClaimatePrimeControllers.Controllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;

namespace ClaimatePrimeControllers.SecuredFolder.CustomErrors
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    internal class ErrorAction
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        internal ErrorAction()
        {
        }

        # endregion

        # region Internal Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pMsg"></param>
        internal void DoErrorAction(string pMsg)
        {
            HttpContextWrapper hcw = new HttpContextWrapper(HttpContext.Current);

            if (hcw.Request.IsAjaxRequest())
            {
                ArivaSession.Initialize("RR=SRS_EA_DEA");
            }
            else
            {
                HttpContext.Current.Response.Clear();

                // http://stackoverflow.com/questions/310580/how-can-i-make-a-catch-all-route-to-handle-404-page-not-found-queries-for-asp
                // http://richarddingwall.name/2008/08/17/strategies-for-resource-based-404-errors-in-aspnet-mvc/
                // http://stackoverflow.com/questions/717628/asp-net-mvc-404-error-handling
                // http://stackoverflow.com/questions/14629304/httpcontext-current-request-isajaxrequest-error-in-mvc-4

                if (((pMsg.StartsWith("The controller for path", StringComparison.CurrentCultureIgnoreCase)) && (pMsg.EndsWith("was not found or does not implement IController.", StringComparison.CurrentCultureIgnoreCase))) ||
                        ((pMsg.StartsWith("A public action method", StringComparison.CurrentCultureIgnoreCase)) && (pMsg.Contains("was not found on controller")) && (pMsg.EndsWith("Controller'.", StringComparison.CurrentCultureIgnoreCase))))
                {
                    ((IController)(new PreLogInController())).Execute(new RequestContext(hcw, StaticClass.RouteDatas("PreLogIn", "Error404")));
                }
                else
                {
                    ((IController)(new PreLogInController())).Execute(new RequestContext(hcw, StaticClass.RouteDatas("PreLogIn", "ErrorUnExp")));
                }
            }
        }

        # endregion
    }
}
