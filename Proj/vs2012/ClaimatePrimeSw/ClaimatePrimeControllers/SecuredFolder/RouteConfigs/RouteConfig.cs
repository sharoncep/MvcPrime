using System.Web.Mvc;
using System.Web.Routing;

namespace ClaimatePrimeControllers.SecuredFolder.RouteConfigs
{
    /// <summary>
    /// 
    /// </summary>
    public class RouteConfig
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="routes"></param>
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{*favicon}", new { favicon = @"(.*/)?favicon.ico(/.*)?" }); // http://stackoverflow.com/questions/3228328/asp-net-routing-ignore-routes-for-files-with-specific-extension-regardless-of
            //routes.IgnoreRoute("favicon.ico");
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{idtype}/{id}/", // URL with parameters
                new { controller = "Home", action = "Search", idtype = UrlParameter.Optional, id = UrlParameter.Optional } // Parameter defaults
            );

            routes.MapRoute(
                "Root",
                "",
                new { controller = "Home", action = "Search", idtype = "", id = "" });
        }
    }
}
