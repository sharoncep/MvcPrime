using System;
using System.Reflection;
using System.Web.Mvc;

namespace ClaimatePrimeControllers.SecuredFolder.Extensions
{
    /// <summary>
    /// 
    /// </summary>
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false, Inherited = false)]
    public class AcceptParameterAttribute : ActionMethodSelectorAttribute
    {
        // http://stackoverflow.com/questions/5702549/asp-net-mvc3-razor-with-multiple-submit-buttons

        public global::System.String ButtonName { get; set; }

        public override bool IsValidForRequest(ControllerContext controllerContext, MethodInfo methodInfo)
        {
            var req = controllerContext.RequestContext.HttpContext.Request;

            var tmp = req.Form;

            foreach (var item in tmp)
            {
                var tmp1 = item;
            }

            return !string.IsNullOrEmpty(req.Form[this.ButtonName]);
        }
    }
}
