using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeControllers.SecuredFolder.Extensions
{
    /// <summary>
    /// http://www.codeproject.com/Articles/267694/Security-in-ASP-NET-MVC-by-using-Anti-Forgery-Toke
    /// </summary>
    [Serializable]
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = false, Inherited = false)]
    public class ArivaAuthorizeAttribute : AuthorizeAttribute
    {
        # region Private Variables

        private global::System.String _CtrlName;
        private global::System.Boolean _DoAuthorize;
        private global::System.Boolean _IsPost;
        private global::System.Boolean _NoHome;

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ArivaAuthorizeAttribute()
        {
            HttpRequestWrapper req = new HttpRequestWrapper(HttpContext.Current.Request);
            _CtrlName = req.RequestContext.RouteData.Values["controller"].ToString();
            _DoAuthorize = (!(string.Compare(_CtrlName, "PreLogIn", true) == 0));
            _IsPost = (string.Compare(req.HttpMethod, "Post", true) == 0);
            _NoHome = (!((string.Compare(_CtrlName, "Home", true) == 0) || (string.Compare(_CtrlName, "AutoComplete", true) == 0)));
        }

        # endregion

        # region Override Methods

        /// <summary>
        /// http://stackoverflow.com/questions/746998/override-authorize-attribute-in-asp-net-mvc
        /// </summary>
        /// <param name="httpContext"></param>
        /// <returns></returns>
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (!(_DoAuthorize))
            {
                return true;
            }

            return base.AuthorizeCore(httpContext);
        }

        /// <summary>
        /// http://stackoverflow.com/questions/6263927/role-management-in-mvc3
        /// 
        /// http://forums.asp.net/t/1686030.aspx/1
        /// </summary>
        /// <param name="filterContext"></param>
        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            // http://stackoverflow.com/questions/6263927/role-management-in-mvc3

            // http://forums.asp.net/t/1686030.aspx/1

            if (_DoAuthorize)
            {
                if (ArivaSession.Sessions().UserID == 0)
                {
                    ArivaSession.Initialize("RR=SRS_AUT_NSN"); // New Session
                }
                else
                {
                    if (_NoHome)
                    {
                        if (ArivaSession.Sessions().SelRoleID == 0)
                        {
                            ArivaSession.Initialize("RR=RNA");  // Role Not Assigned
                        }
                        else
                        {
                            string[] ctrlArr = _CtrlName.Split(Convert.ToChar("_"));
                            string ctrlName = string.Empty;
                            Int16 i;

                            for (i = 0; i < ctrlArr.Length - 1; i++)
                            {
                                ctrlName = string.Concat("_", ctrlName, ctrlArr[i]);
                            }

                            ctrlName = ctrlName.Substring(1);
                            string ctrlPerm = ctrlArr[i];

                            RolePageModel rolePage = RolePageModel.GetRolePage(ArivaSession.Sessions().SelRoleID, ctrlName);

                            if (string.Compare(rolePage.Permission, ctrlPerm, true) != 0)
                            {
                                ArivaSession.Initialize("RR=NAC");  // RR --> Redirect Reason, NAC --> No access permission
                            }
                            else
                            {
                                if (!(string.IsNullOrWhiteSpace(rolePage.SessionName)))
                                {
                                    if (string.Compare(rolePage.SessionName, "SelClinicID", true) == 0)
                                    {
                                        if (ArivaSession.Sessions().SelClinicID == 0)
                                        {
                                            ArivaSession.Initialize("RR=NCS");  // No Clinic Session
                                        }
                                    }
                                    else if (string.Compare(rolePage.SessionName, "SelPatientID", true) == 0)
                                    {
                                        if (ArivaSession.Sessions().SelPatientID == 0)
                                        {
                                            ArivaSession.Initialize("RR=NPS");  // No Patient Session
                                        }
                                    }
                                    else if (string.Compare(rolePage.SessionName, "SelProviderID", true) == 0)
                                    {
                                        if (ArivaSession.Sessions().SelProviderID == 0)
                                        {
                                            ArivaSession.Initialize("RR=NDS");  // No Provider Session
                                        }
                                    }
                                    else if (string.Compare(rolePage.SessionName, "SelAgentID", true) == 0)
                                    {
                                        if (ArivaSession.Sessions().SelAgentID == 0)
                                        {
                                            ArivaSession.Initialize("RR=NAS");  // No Agent Session
                                        }
                                    }
                                    else
                                    {
                                        ArivaSession.Initialize("RR=UES");  // Un-Expected Session
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }

                base.OnAuthorization(filterContext);
            }

            if (_IsPost)
            {
                filterContext.Controller.ValidateRequest = false;
            }
        }

        # endregion
    }
}
