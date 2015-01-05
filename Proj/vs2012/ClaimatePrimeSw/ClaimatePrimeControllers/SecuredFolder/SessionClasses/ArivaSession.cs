using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.CustomErrors;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.SecuredFolder.SessionClasses
{
    /// <summary>
    /// Don't use StaticClass here
    /// </summary>
    [Serializable]
    public class ArivaSession
    {
        // Don't use StaticClass here

        # region Private Variables

        private global::System.String _UserCulture;
        private global::System.String _HighRoleName;
        private dynamic _PageEditID;
        private Dictionary<string, string> _FilePaths;

        # endregion

        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String ID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String Seed
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 Timeout
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 UserID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String UserDispName
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String UserEmail
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String UserPhone
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Byte HighRoleID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Byte SelRoleID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SelRoleName
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 SelClinicID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SelClinicDispName
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int64 SelPatientID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SelPatientDispName
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 SelProviderID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SelProviderDispName
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 SelAgentID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String SelAgentDispName
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int64 LogInLogOutID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string UserCulture
        {
            // http://windows7themes.net/how-to-enabledisable-cookies-in-internet-explorer-9.html
            // http://msdn.microsoft.com/en-us/library/ms178194(v=VS.90).aspx

            get
            {
                return _UserCulture;
            }
            set
            {
                _UserCulture = value;

                try
                {
                    if (HttpContext.Current.Request.Cookies[Constants.Others.ARIVA_COOKIE] != null)
                    {
                        HttpContext.Current.Response.Cookies.Remove(Constants.Others.ARIVA_COOKIE);
                    }

                    HttpCookie objHttpCookie = new HttpCookie(Constants.Others.ARIVA_COOKIE);
                    objHttpCookie.Value = _UserCulture;
                    objHttpCookie.Expires = DateTime.Now.AddDays(30);
                    HttpContext.Current.Response.Cookies.Add(objHttpCookie);
                }
                catch (Exception)
                {
                }
            }
        }

        /// <summary>
        /// Get
        /// </summary>
        public bool IsNoCulture
        {
            get
            {
                if (string.Compare(Thread.CurrentThread.CurrentUICulture.Name, _UserCulture, true) == 0)
                {
                    return false;
                }

                return true;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool IsNewRec
        {
            get
            {
                return (this._PageEditID == 0) ? true : false;
            }
        }

        # endregion

        # region Constructors

        /// <summary>
        /// aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// Run the above comment in the Visual Studio Command Prompt
        /// C:\Program Files\Microsoft Visual Studio 9.0\VC>aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// </summary>
        /// <param name="pTimeout"></param>
        private ArivaSession()
        {
            FormsAuthentication.Initialize();
            this.ID = HttpContext.Current.Session.SessionID;
            this.Seed = ((new Random()).Next().ToString());
            this.Timeout = HttpContext.Current.Session.Timeout;

            //

            this.UserID = 0;
            this.UserDispName = string.Empty;
            this.UserEmail = string.Empty;
            this.UserPhone = string.Empty;
            this.HighRoleID = 0;
            this.SelRoleName = string.Empty;
            this._PageEditID = 0;

            this._HighRoleName = string.Empty;

            this.LogInLogOutID = 0;

            # region Culture Code

            // http://windows7themes.net/how-to-enabledisable-cookies-in-internet-explorer-9.html
            // http://msdn.microsoft.com/en-us/library/ms178194(v=VS.90).aspx

            try
            {
                if ((HttpContext.Current.Request.Cookies[Constants.Others.ARIVA_COOKIE] == null) ||
                    string.IsNullOrWhiteSpace(HttpContext.Current.Request.Cookies[Constants.Others.ARIVA_COOKIE].Value))
                {
                    _UserCulture = Thread.CurrentThread.CurrentUICulture.Name;
                }
                else
                {
                    _UserCulture = HttpContext.Current.Request.Cookies[Constants.Others.ARIVA_COOKIE].Value;
                }
            }
            catch (Exception)
            {
                _UserCulture = Thread.CurrentThread.CurrentUICulture.Name;
            }

            # endregion

            this._FilePaths = new Dictionary<string, string>();
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pUserLastName"></param>
        /// <param name="pUserFirstName"></param>
        /// <param name="pUserMiddleName"></param>
        /// <param name="pUserEmail"></param>
        /// <param name="pUserPhone"></param>
        /// <param name="pSelRoleID"></param>
        /// <param name="pSelRoleName"></param>
        public void LogInSuccess(global::System.Int32 pUserID, global::System.String pUserLastName, global::System.String pUserFirstName, global::System.String pUserMiddleName
                                    , global::System.String pUserEmail, global::System.String pUserPhone, global::System.Byte pSelRoleID, global::System.String pSelRoleName)
        {
            this.UserID = pUserID;
            this.UserDispName = string.Concat(pUserLastName, " ", pUserFirstName, " ", pUserMiddleName).Trim();
            this.UserEmail = pUserEmail;
            this.UserPhone = pUserPhone;
            this.HighRoleID = pSelRoleID;
            this._HighRoleName = pSelRoleName;

            this.SelRoleID = this.HighRoleID;
            this.SelRoleName = this._HighRoleName;

            this.SelClinicID = 0;
            this.SelClinicDispName = string.Empty;

            this.SelPatientID = 0;
            this.SelPatientDispName = string.Empty;

            this.SelProviderID = 0;
            this.SelProviderDispName = string.Empty;

            this.SelAgentID = 0;
            this.SelAgentDispName = string.Empty;

            this.Seed = null;

            Int64 logInLogOutID;

            (new LogInModel()).SaveLogInLogOut(this.UserID, HttpContext.Current.Request.UserHostAddress, HttpContext.Current.Request.UserHostName, this.ID, out logInLogOutID);

            if (logInLogOutID == 0)
            {
                throw new Exception("Sorry! LogInLogOutID should not be zero.");
            }

            this.LogInLogOutID = logInLogOutID;
        }

        /// <summary>
        /// 
        /// </summary>
        public void ReSetRole()
        {
            if (RunMode.IsDebug)
            {
                # region Validating Authorization

                MethodBase methodBase = (new System.Diagnostics.StackTrace()).GetFrame(1).GetMethod();  // http://www.vbforums.com/showthread.php?t=298664
                string calledBy = methodBase.ReflectedType.FullName;
                ParameterInfo[] parameterInfos = methodBase.GetParameters();

                if (!((string.Compare(calledBy, "ClaimatePrimeControllers.SecuredFolder.BaseControllers.BaseHighRoleController", true) == 0) &&
                    (string.Compare(methodBase.Name, ".ctor", true) == 0) &&
                    (parameterInfos.Length == 0)))
                {
                    throw new Exception(string.Concat("Sorry! Unauthorized call to ReSetRole from ", calledBy, " --", methodBase.Name));
                }

                # endregion
            }

            SetRole(this.HighRoleID, this._HighRoleName);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSelRoleID"></param>
        /// <param name="pSelRoleName"></param>
        public void SetRole(global::System.Byte pSelRoleID, global::System.String pSelRoleName)
        {
            this.SelRoleID = 0;
            this.SelRoleName = string.Empty;

            this.SelClinicID = 0;
            this.SelClinicDispName = string.Empty;

            this.SelPatientID = 0;
            this.SelPatientDispName = string.Empty;

            this.SelProviderID = 0;
            this.SelProviderDispName = string.Empty;

            this.SelAgentID = 0;
            this.SelAgentDispName = string.Empty;

            if (!((pSelRoleID == 0) || (string.IsNullOrWhiteSpace(pSelRoleName))))
            {
                this.SelRoleID = pSelRoleID;
                this.SelRoleName = pSelRoleName;

                UserRoleSelectSaveModel objSaveModel = new UserRoleSelectSaveModel() { RoleID = pSelRoleID };
                if (!(objSaveModel.Save(UserID)))
                {
                    throw new Exception(objSaveModel.ErrorMsg);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSelClinicID"></param>
        /// <param name="pSelClinicDispName"></param>
        public void SetClinic(global::System.Int32 pSelClinicID, global::System.String pSelClinicDispName)
        {
            this.SelClinicID = 0;
            this.SelClinicDispName = string.Empty;

            this.SelPatientID = 0;
            this.SelPatientDispName = string.Empty;

            if (!((pSelClinicID == 0) || (string.IsNullOrWhiteSpace(pSelClinicDispName))))
            {
                this.SelClinicID = pSelClinicID;
                this.SelClinicDispName = pSelClinicDispName;

                UserClinicSelectSaveModel objSaveModel = new UserClinicSelectSaveModel() { ClinicID = pSelClinicID };
                if (!(objSaveModel.Save(UserID)))
                {
                    throw new Exception(objSaveModel.ErrorMsg);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSelPatientID"></param>
        /// <param name="pSelPatientDispName"></param>
        public void SetPatient(global::System.Int64 pSelPatientID, global::System.String pSelPatientDispName)
        {
            this.SelPatientID = 0;
            this.SelPatientDispName = string.Empty;

            if (!((pSelPatientID == 0) || (string.IsNullOrWhiteSpace(pSelPatientDispName))))
            {
                this.SelPatientID = pSelPatientID;
                this.SelPatientDispName = pSelPatientDispName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSelProviderID"></param>
        /// <param name="pSelProviderDispName"></param>
        public void SetProvider(global::System.Int32 pSelProviderID, global::System.String pSelProviderDispName)
        {
            this.SelProviderID = 0;
            this.SelProviderDispName = string.Empty;

            if (!((pSelProviderID == 0) || (string.IsNullOrWhiteSpace(pSelProviderDispName))))
            {
                this.SelProviderID = pSelProviderID;
                this.SelProviderDispName = pSelProviderDispName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSelAgentID"></param>
        /// <param name="pSelAgentDispName"></param>
        public void SetAgent(global::System.Int32 pSelAgentID, global::System.String pSelAgentDispName)
        {
            this.SelAgentID = 0;
            this.SelAgentDispName = string.Empty;

            if (!((pSelAgentID == 0) || (string.IsNullOrWhiteSpace(pSelAgentDispName))))
            {
                this.SelAgentID = pSelAgentID;
                this.SelAgentDispName = pSelAgentDispName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="val"></param>
        public void PageEditID<T>(global::System.Int64 val)
        {
            string tp = typeof(T).Name;

            switch (tp)
            {
                case "Int32":
                    this._PageEditID = Convert.ToInt32(val);
                    break;
                case "Int16":
                    this._PageEditID = Convert.ToInt16(val);
                    break;
                case "Byte":
                    this._PageEditID = Convert.ToByte(val);
                    break;
                default:
                    this._PageEditID = val;
                    break;
            }

            this._FilePaths = new Dictionary<string, string>();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public T PageEditID<T>()
        {
            return this._PageEditID;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKey"></param>
        /// <param name="pValue"></param>
        public void FilePathsDotAdd(string pKey, string pValue)
        {
            if (this._FilePaths.ContainsKey(pKey))
            {
                this._FilePaths.Remove(pKey);
            }

            this._FilePaths.Add(pKey, pValue);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKey"></param>
        /// <returns></returns>
        public string FilePathsDotValue(string pKey)
        {
            if (this._FilePaths.ContainsKey(pKey))
            {
                return this._FilePaths[pKey];
            }

            return string.Empty;
        }

        # endregion

        # region Internal Static Methods

        /// <summary>
        /// This method initializes session
        /// aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// Run the above comment in the Visual Studio Command Prompt
        /// C:\Program Files\Microsoft Visual Studio 9.0\VC>aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// </summary>
        /// <param name="pQryStr">Empty string not allowed. If the values not starts with 'RR=SRS_', the page will be automatically redirected to login page with this query string</param>
        internal static void Initialize(string pQryStr)
        {
            if (string.IsNullOrWhiteSpace(pQryStr))
            {
                throw new Exception("Sorry! Initialize(string pQryStr) should not be empty");
            }

            Dispose(pQryStr);

            HttpContext.Current.Session[Constants.Others.ARIVA_SESSION] = new ArivaSession();
        }

        # endregion

        # region Public Static Methods

        /// <summary>
        /// This method reads the session values
        /// aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// Run the above comment in the Visual Studio Command Prompt
        /// C:\Program Files\Microsoft Visual Studio 9.0\VC>aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// </summary>
        /// <returns></returns>
        public static ArivaSession Sessions()
        {
            // http://arturito.net/2011/09/19/installsqlstate-sql-errors-aspstate_job_deleteexpiredsessions-does-not-exist-and-the-specified-name-uncategorized-local-already-exists/
            // http://support.microsoft.com/kb/317604
            // http://support.microsoft.com/kb/311209/EN-US

            // aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
            // Run the above comment in the Visual Studio Command Prompt
            // C:\Program Files\Microsoft Visual Studio 9.0\VC>aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros

            if ((HttpContext.Current.Session == null) ||
                    (HttpContext.Current.Session[Constants.Others.ARIVA_SESSION] == null))
            {
                Initialize("RR=SRS_SESS");
            }

            return (ArivaSession)HttpContext.Current.Session[Constants.Others.ARIVA_SESSION];
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// This method disposes the session
        /// aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// Run the above comment in the Visual Studio Command Prompt
        /// C:\Program Files\Microsoft Visual Studio 9.0\VC>aspnet_regsql.exe -ssadd -sstype p -U sa -P Arivadb123 -S eros
        /// </summary>
        /// <param name="pQryStr">If any set value here, the page will be automatically redirected to login page with this query string</param>
        private static void Dispose(string pQryStr)
        {
            try
            {
                if ((HttpContext.Current.Session != null) &&
                    (HttpContext.Current.Session[Constants.Others.ARIVA_SESSION] != null))
                {
                    if (ArivaSession.Sessions().LogInLogOutID > 0)
                    {
                        (new LogInModel()).SaveLogInLogOut(ArivaSession.Sessions().LogInLogOutID);
                    }

                    //HttpContext.Current.Session.Remove(Constants.Others.ARIVA_SESSION);
                }
            }
            catch (Exception)
            {
                // Igore this exception. Otherwise round trip will happen
            }

            try
            {
                FormsAuthentication.SignOut();

                pQryStr = pQryStr.StartsWith("RR=SRS_", StringComparison.CurrentCultureIgnoreCase) ? string.Empty : pQryStr;

                if (!(string.IsNullOrWhiteSpace(pQryStr)))
                {
                    FormsAuthentication.RedirectToLoginPage(pQryStr);
                }
            }
            catch (Exception)
            {
                // Igore this exception. Otherwise round trip will happen
            }
        }

        # endregion
    }
}