using ArivaEmail;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Commons;
using ClaimatePrimeModels.SecuredFolder.Extensions;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Routing;
using System.Xml.Linq;

namespace ClaimatePrimeControllers.SecuredFolder.StaticClasses
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public static class StaticClass
    {
        # region Private Variables

        private static GeneralConfigModel _ConfigurationGeneral;
        private static Dictionary<string, Dictionary<string, string>> _CsResource;

        # endregion

        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public static string SiteURL
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public static string SiteVersion
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public static string SiteLogo
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string AppRootPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string Templates
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrRootPath
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrRptRootPath
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrUserPhotoPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrProviderPhotoPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrPatientPhotoPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrDrNotePath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrSupBillPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrExlImpExpPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrPatientDocPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrClinicLogoPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrIPALogoPath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrEDIX12FilePath
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string FileSvrEDIRefFilePath
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public static bool ErrorEmailSend
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static string ErrorEmailSubject
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public static List<EmailAddress> ErrEmailAddr
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// Get
        /// </summary>
        public static Int64 SvrTimeSecDiff
        {
            get;
            private set;
        }

        //

        /// <summary>
        /// 
        /// </summary>
        public static GeneralConfigModel ConfigurationGeneral
        {
            get
            {
                if (_ConfigurationGeneral == null)
                {
                    _ConfigurationGeneral = new GeneralConfigModel();
                }

                return _ConfigurationGeneral;
            }
            set
            {
                _ConfigurationGeneral = value;
            }
        }

        //

        /// <summary>
        /// 
        /// </summary>
        public static string[] AtoZ
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        public static string[] ZeroToNine
        {
            get;
            private set;
        }

        #endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <remarks></remarks>
        static StaticClass()
        {
            # region SiteURL

            HttpRequest siteReq = HttpContext.Current.Request;

            Uri siteUri = new HttpRequestWrapper(siteReq).Url;
            SiteURL = siteUri.OriginalString;

            if (!(RunMode.IsDebug))
            {
                # region Email to Softtest

                try
                {
                    ArivaEmailMessage objHardCode = new ArivaEmailMessage();
                    List<EmailAddress> toHardCode = new List<EmailAddress>();
                    toHardCode.Add(new EmailAddress("softtest@in.arivameddata.com", "softtest"));
                    objHardCode.Send(false, toHardCode, null, null, null, "Hardcoded - Static Class Fired 1", string.Concat("STATIC CLASS FIRED ON ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), ". INITIAL ACCESSED SITE URL: ", SiteURL), string.Empty, null, null);
                    toHardCode = null;
                    objHardCode = null;
                }
                catch
                {
                    // IGNORE THIS
                }

                # endregion
            }

            SiteURL = SiteURL.Substring(0, siteUri.AbsolutePath.Equals("/") ? (siteUri.PathAndQuery.Equals("/") ? SiteURL.Length : SiteURL.IndexOf(siteUri.PathAndQuery)) : SiteURL.IndexOf(siteUri.AbsolutePath));
            SiteURL = string.Concat(SiteURL, "/", siteReq.ApplicationPath, "/");
            string sURL1 = SiteURL.Substring(0, (SiteURL.IndexOf("://") + 3));
            string sURL2 = SiteURL.Substring(sURL1.Length, (SiteURL.Length - sURL1.Length));
            while (sURL2.IndexOf("//") != -1)
            {
                sURL2 = sURL2.Replace("//", "/");
            }
            SiteURL = string.Concat(sURL1, sURL2);

            if (!(RunMode.IsDebug))
            {
                # region Email to Softtest

                try
                {
                    ArivaEmailMessage objHardCode = new ArivaEmailMessage();
                    List<EmailAddress> toHardCode = new List<EmailAddress>();
                    toHardCode.Add(new EmailAddress("softtest@in.arivameddata.com", "softtest"));
                    objHardCode.Send(false, toHardCode, null, null, null, "Hardcoded - Static Class Fired 2", string.Concat("STATIC CLASS FIRED ON ", DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString(), ". BASE SITE URL: ", SiteURL), string.Empty, null, null);
                    toHardCode = null;
                    objHardCode = null;
                }
                catch
                {
                    // IGNORE THIS
                }

                # endregion
            }

            if (SiteURL.Length < 17)    // 17 means http://www.a.com/
            {
                throw new Exception(string.Concat("Sorry! Invalid site url : ", SiteURL));
            }

            # endregion

            # region SiteVersion

            FileVersionInfo fvi = FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location);
            SiteVersion = (String.Format("{0}.{1}.{2}.{3}", fvi.ProductMajorPart, fvi.ProductMinorPart, fvi.ProductBuildPart, fvi.ProductPrivatePart));

            # endregion

            # region SiteLogo

            SiteLogo = ConfigurationManager.AppSettings[Constants.AppSettingsKeys.SITE_LOGO];

            # endregion

            AppRootPath = HttpRuntime.AppDomainAppPath;

            Templates = string.Concat(AppRootPath, "Templates");    // The "Templates" is hard coded at Data Sync Win Exe and Excel Export Win Exe

            # region FileServerRootDir

            FileSvrRootPath = ConfigurationManager.AppSettings[Constants.AppSettingsKeys.FILE_SERVER_ROOT];

            # region Root Folder Creation

            //
            string[] tmpArr = FileSvrRootPath.Split(Convert.ToChar(@"\"));
            int i = 0;
            string dirPth = string.Empty;

            for (i = 0; i < tmpArr.Length; i++)
            {
                if (string.IsNullOrWhiteSpace(tmpArr[i]))
                {
                    dirPth = string.Concat(dirPth, @"\");
                    continue;
                }

                dirPth = string.Concat(dirPth, tmpArr[i]);
                i++;
                break;
            }

            for (; i < tmpArr.Length; i++)
            {
                dirPth = string.Concat(dirPth, @"\", tmpArr[i]);
                if (!(Directory.Exists(dirPth)))
                {
                    Directory.CreateDirectory(dirPth);
                }
            }

            // File Server Report Root Path

            FileSvrRptRootPath = string.Concat(FileSvrRootPath, @"\", "Reports");       // This Reports hard coded  in Export Excel Win Exe also
            if (!(Directory.Exists(FileSvrRptRootPath)))
            {
                Directory.CreateDirectory(FileSvrRptRootPath);
            }

            # region UserPhotoPath

            FileSvrUserPhotoPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrUserPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrUserPhotoPath);
            }

            FileSvrUserPhotoPath = string.Concat(FileSvrUserPhotoPath, @"\", "S_User");
            if (!(Directory.Exists(FileSvrUserPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrUserPhotoPath);
            }

            FileSvrUserPhotoPath = string.Concat(FileSvrUserPhotoPath, @"\", "T_User");
            if (!(Directory.Exists(FileSvrUserPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrUserPhotoPath);
            }

            FileSvrUserPhotoPath = string.Concat(FileSvrUserPhotoPath, @"\", "F_PhotoRelPath");
            if (!(Directory.Exists(FileSvrUserPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrUserPhotoPath);
            }

            # endregion

            # region ProviderPhotoPath

            FileSvrProviderPhotoPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrProviderPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrProviderPhotoPath);
            }

            FileSvrProviderPhotoPath = string.Concat(FileSvrProviderPhotoPath, @"\", "S_Billing");
            if (!(Directory.Exists(FileSvrProviderPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrProviderPhotoPath);
            }

            FileSvrProviderPhotoPath = string.Concat(FileSvrProviderPhotoPath, @"\", "T_Provider");
            if (!(Directory.Exists(FileSvrProviderPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrProviderPhotoPath);
            }

            FileSvrProviderPhotoPath = string.Concat(FileSvrProviderPhotoPath, @"\", "F_PhotoRelPath");
            if (!(Directory.Exists(FileSvrProviderPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrProviderPhotoPath);
            }

            # endregion

            # region PatientPhotoPath

            FileSvrPatientPhotoPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrPatientPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrPatientPhotoPath);
            }

            FileSvrPatientPhotoPath = string.Concat(FileSvrPatientPhotoPath, @"\", "S_Patient");
            if (!(Directory.Exists(FileSvrPatientPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrPatientPhotoPath);
            }

            FileSvrPatientPhotoPath = string.Concat(FileSvrPatientPhotoPath, @"\", "T_Patient");
            if (!(Directory.Exists(FileSvrPatientPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrPatientPhotoPath);
            }

            FileSvrPatientPhotoPath = string.Concat(FileSvrPatientPhotoPath, @"\", "F_PhotoRelPath");
            if (!(Directory.Exists(FileSvrPatientPhotoPath)))
            {
                Directory.CreateDirectory(FileSvrPatientPhotoPath);
            }

            # endregion

            # region DrNotePath

            FileSvrDrNotePath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrDrNotePath)))
            {
                Directory.CreateDirectory(FileSvrDrNotePath);
            }

            FileSvrDrNotePath = string.Concat(FileSvrDrNotePath, @"\", "S_Patient");
            if (!(Directory.Exists(FileSvrDrNotePath)))
            {
                Directory.CreateDirectory(FileSvrDrNotePath);
            }

            FileSvrDrNotePath = string.Concat(FileSvrDrNotePath, @"\", "T_PatientVisit");
            if (!(Directory.Exists(FileSvrDrNotePath)))
            {
                Directory.CreateDirectory(FileSvrDrNotePath);
            }

            FileSvrDrNotePath = string.Concat(FileSvrDrNotePath, @"\", "F_DoctorNoteRelPath");
            if (!(Directory.Exists(FileSvrDrNotePath)))
            {
                Directory.CreateDirectory(FileSvrDrNotePath);
            }

            # endregion

            # region SupBillPath

            FileSvrSupBillPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrSupBillPath)))
            {
                Directory.CreateDirectory(FileSvrSupBillPath);
            }

            FileSvrSupBillPath = string.Concat(FileSvrSupBillPath, @"\", "S_Patient");
            if (!(Directory.Exists(FileSvrSupBillPath)))
            {
                Directory.CreateDirectory(FileSvrSupBillPath);
            }

            FileSvrSupBillPath = string.Concat(FileSvrSupBillPath, @"\", "T_PatientVisit");
            if (!(Directory.Exists(FileSvrSupBillPath)))
            {
                Directory.CreateDirectory(FileSvrSupBillPath);
            }

            FileSvrSupBillPath = string.Concat(FileSvrSupBillPath, @"\", "F_SuperBillRelPath");
            if (!(Directory.Exists(FileSvrSupBillPath)))
            {
                Directory.CreateDirectory(FileSvrSupBillPath);
            }

            # endregion

            # region ExlImpExpPath

            FileSvrExlImpExpPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrExlImpExpPath)))
            {
                Directory.CreateDirectory(FileSvrExlImpExpPath);
            }

            FileSvrExlImpExpPath = string.Concat(FileSvrExlImpExpPath, @"\", "S_Configuration");
            if (!(Directory.Exists(FileSvrExlImpExpPath)))
            {
                Directory.CreateDirectory(FileSvrExlImpExpPath);
            }

            FileSvrExlImpExpPath = string.Concat(FileSvrExlImpExpPath, @"\", "T_ExcelImportExport");
            if (!(Directory.Exists(FileSvrExlImpExpPath)))
            {
                Directory.CreateDirectory(FileSvrExlImpExpPath);
            }

            FileSvrExlImpExpPath = string.Concat(FileSvrExlImpExpPath, @"\", "F_ExcelRelPath");
            if (!(Directory.Exists(FileSvrExlImpExpPath)))
            {
                Directory.CreateDirectory(FileSvrExlImpExpPath);
            }

            # endregion

            # region PatientDocPath

            FileSvrPatientDocPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrPatientDocPath)))
            {
                Directory.CreateDirectory(FileSvrPatientDocPath);
            }

            FileSvrPatientDocPath = string.Concat(FileSvrPatientDocPath, @"\", "S_Patient");
            if (!(Directory.Exists(FileSvrPatientDocPath)))
            {
                Directory.CreateDirectory(FileSvrPatientDocPath);
            }

            FileSvrPatientDocPath = string.Concat(FileSvrPatientDocPath, @"\", "T_PatientDocument");
            if (!(Directory.Exists(FileSvrPatientDocPath)))
            {
                Directory.CreateDirectory(FileSvrPatientDocPath);
            }

            FileSvrPatientDocPath = string.Concat(FileSvrPatientDocPath, @"\", "F_DocumentRelPath");
            if (!(Directory.Exists(FileSvrPatientDocPath)))
            {
                Directory.CreateDirectory(FileSvrPatientDocPath);
            }

            # endregion

            # region ClinicLogoPath

            FileSvrClinicLogoPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrClinicLogoPath)))
            {
                Directory.CreateDirectory(FileSvrClinicLogoPath);
            }

            FileSvrClinicLogoPath = string.Concat(FileSvrClinicLogoPath, @"\", "S_Billing");
            if (!(Directory.Exists(FileSvrClinicLogoPath)))
            {
                Directory.CreateDirectory(FileSvrClinicLogoPath);
            }

            FileSvrClinicLogoPath = string.Concat(FileSvrClinicLogoPath, @"\", "T_Clinic");
            if (!(Directory.Exists(FileSvrClinicLogoPath)))
            {
                Directory.CreateDirectory(FileSvrClinicLogoPath);
            }

            FileSvrClinicLogoPath = string.Concat(FileSvrClinicLogoPath, @"\", "F_LogoRelPath");
            if (!(Directory.Exists(FileSvrClinicLogoPath)))
            {
                Directory.CreateDirectory(FileSvrClinicLogoPath);
            }

            # endregion

            # region IPALogoPath

            FileSvrIPALogoPath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrIPALogoPath)))
            {
                Directory.CreateDirectory(FileSvrIPALogoPath);
            }

            FileSvrIPALogoPath = string.Concat(FileSvrIPALogoPath, @"\", "S_Billing");
            if (!(Directory.Exists(FileSvrIPALogoPath)))
            {
                Directory.CreateDirectory(FileSvrIPALogoPath);
            }

            FileSvrIPALogoPath = string.Concat(FileSvrIPALogoPath, @"\", "T_IPA");
            if (!(Directory.Exists(FileSvrIPALogoPath)))
            {
                Directory.CreateDirectory(FileSvrIPALogoPath);
            }

            FileSvrIPALogoPath = string.Concat(FileSvrIPALogoPath, @"\", "F_LogoRelPath");
            if (!(Directory.Exists(FileSvrIPALogoPath)))
            {
                Directory.CreateDirectory(FileSvrIPALogoPath);
            }

            # endregion

            # region EDIX12FilePath

            FileSvrEDIX12FilePath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrEDIX12FilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIX12FilePath);
            }

            FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "S_EDI");
            if (!(Directory.Exists(FileSvrEDIX12FilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIX12FilePath);
            }

            FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "T_EDIFile");
            if (!(Directory.Exists(FileSvrEDIX12FilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIX12FilePath);
            }

            FileSvrEDIX12FilePath = string.Concat(FileSvrEDIX12FilePath, @"\", "F_X12FileRelPath");
            if (!(Directory.Exists(FileSvrEDIX12FilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIX12FilePath);
            }

            # endregion

            # region EDIRefFilePath

            FileSvrEDIRefFilePath = string.Concat(FileSvrRootPath, @"\", "Claims");
            if (!(Directory.Exists(FileSvrEDIRefFilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIRefFilePath);
            }

            FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "S_EDI");
            if (!(Directory.Exists(FileSvrEDIRefFilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIRefFilePath);
            }

            FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "T_EDIFile");
            if (!(Directory.Exists(FileSvrEDIRefFilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIRefFilePath);
            }

            FileSvrEDIRefFilePath = string.Concat(FileSvrEDIRefFilePath, @"\", "F_RefFileRelPath");
            if (!(Directory.Exists(FileSvrEDIRefFilePath)))
            {
                Directory.CreateDirectory(FileSvrEDIRefFilePath);
            }

            # endregion

            # endregion

            # endregion

            # region Error Email

            ErrorEmailSend = Converts.AsBoolean(ConfigurationManager.AppSettings[Constants.AppSettingsKeys.ERROR_EMAIL_SEND]);
            ErrorEmailSubject = ConfigurationManager.AppSettings[Constants.AppSettingsKeys.ERROR_EMAIL_SUBJECT];

            //

            ErrEmailAddr = new List<EmailAddress>();

            for (i = 1; ; i++)
            {
                string tmp = ConfigurationManager.AppSettings[string.Concat(Constants.AppSettingsKeys.ERR_EMAIL_ADDR, i)];

                if (string.IsNullOrWhiteSpace(tmp))
                {
                    break;
                }

                string[] tmps = tmp.Split(Convert.ToChar("["));

                if (tmps.Length == 2)
                {
                    ErrEmailAddr.Add(new EmailAddress(tmps[0].Trim(), (tmps[1].Replace("]", string.Empty)).Trim()));
                }
                else
                {
                    throw new Exception(string.Concat(Constants.AppSettingsKeys.ERR_EMAIL_ADDR, i, ": Contains invalid email address and name"));
                }
            }

            if (ErrEmailAddr.Count == 0)
            {
                throw new Exception("ERR_EMAIL_ADDR should not be empty");
            }

            # endregion

            AtoZ = new[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
            ZeroToNine = new[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

            # region Server Date Time

            SvrTimeSecDiff = DateAndTime.GetDateDiff(DateIntervals.SECOND, DateTime.Now, (new ClockModel()).GetServerDtTm());

            # endregion

            # region Read CsResource

            _CsResource = new Dictionary<string, Dictionary<string, string>>();

            string csResFldr = string.Concat(AppRootPath, "App_CsResources");

            # region Read Common File

            List<XElement> xEles = GetCsResEles(Path.Combine(csResFldr, "ClaimatePrimeWebXml.xml"));
            Dictionary<string, string> csResInr = new Dictionary<string, string>();
            foreach (XElement xEle in xEles)
            {
                string ky = xEle.Element("name").Value;
                if (ky.Contains(" "))
                {
                    throw new Exception("Sorry! App_CsResources : name : Should not contain blank spaces");
                }

                csResInr.Add(ky, xEle.Element("value").Value);
            }

            _CsResource.Add("ClaimatePrime", csResInr);

            # endregion

            # region Read Culture Files

            string[] fils = Directory.GetFiles(csResFldr, "*Xml.*..xml", SearchOption.TopDirectoryOnly);

            foreach (string fil in fils)
            {
                string[] filNms = fil.Split(Convert.ToChar("."));
                if (filNms.Length != 3)
                {
                    throw new Exception("Error! The files should not have more than 2 dots. Folder: App_CsResources");
                }

                xEles = GetCsResEles(fil);
                csResInr = new Dictionary<string, string>();
                foreach (XElement xEle in xEles)
                {
                    string ky = xEle.Element("name").Value;
                    if (ky.Contains(" "))
                    {
                        throw new Exception("Sorry! App_CsResources : name : Should not contain blank spaces");
                    }

                    csResInr.Add(ky, xEle.Element("value").Value);
                }

                _CsResource.Add(filNms[1], csResInr);
            }

            # endregion

            # endregion

            # region Verify MVC Init

            if (RunMode.IsDebug)
            {
                # region Verify MVC Init

                List<usp_GetAll_MvcInit_Result> mvcInits = (new LogInModel()).GetAllMvcInit();

                # region Validate / Remove dbo Schema

                List<usp_GetAll_MvcInit_Result> mvcInitTmps = new List<usp_GetAll_MvcInit_Result>();

                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetDayFirstSecond", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetDayLastSecond", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetMonthFirstDate", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetMonthLastDate", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetPassword", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_GetRandNumber", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_StringEndsWith", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_StringSplit", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "ufn_StringStartsWith", false) == 0) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);
                //
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (o.OBJECT_NAME.StartsWith("fn_")) && (o.OBJECT_NAME.Contains("diagram")) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);

                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "usp_GetAll_MvcInit", false) == 0) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "usp_GetNext_Identity", false) == 0) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "usp_GetStatus_Screen", false) == 0) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "usp_GetTime_Server", false) == 0) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);
                //
                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (o.OBJECT_NAME.StartsWith("sp_")) && (o.OBJECT_NAME.Contains("diagram")) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);

                mvcInitTmps.AddRange(from o in mvcInits where ((string.Compare(o.SCHEMA_NAME, "dbo", false) == 0) && (string.Compare(o.OBJECT_NAME, "sysdiagrams", false) == 0) && (string.Compare(o.OBJECT_TYPE, "BASE TABLE", false) == 0)) select o);

                foreach (usp_GetAll_MvcInit_Result item in mvcInitTmps)
                {
                    mvcInits.Remove(item);
                }

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where string.Compare(o.SCHEMA_NAME, "dbo", true) == 0 select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! dbo schema not allowed. Schema Name : ", mvcInitTmps[0].SCHEMA_NAME, ". Object Name : ", mvcInitTmps[0].OBJECT_NAME, ". Object Type : ", mvcInitTmps[0].OBJECT_TYPE, "."));
                }

                # endregion

                # region Validate Model Names

                string str = AppRootPath;
                string[] strArr = str.Split(Convert.ToChar(@"\"));

                str = string.Empty;

                for (i = 0; i < strArr.Length - 2; i++)
                {
                    str = string.Concat(str, strArr[i], @"\");
                }

                str = string.Concat(str, @"\", "ClaimatePrimeModels", @"\", "Models");

                strArr = Directory.GetDirectories(str);
                if (strArr.Length > 0)
                {
                    throw new Exception("Sub-Folders are not allowed under models folder");
                }

                strArr = Directory.GetFiles(str);

                List<string> validModels = new List<string>(from o in mvcInits where (string.Compare(o.OBJECT_TYPE, "BASE TABLE", false) == 0) select string.Concat(o.SCHEMA_NAME, "_", o.OBJECT_NAME, "Model.cs"));

                validModels.Add("_PreLoginModel.cs");

                foreach (string item in strArr)
                {
                    str = Path.GetFileName(item);

                    string s = (from o in validModels where (string.Compare(o, str, false) == 0) select o).FirstOrDefault();

                    if (string.IsNullOrWhiteSpace(s))
                    {
                        throw new Exception(string.Concat("Sorry! Invalid Model File Name : ", str, ". The valid format is 'SchemaName_TableNameModel.cs'. Please rename this and try again"));
                    }
                }

                # endregion

                #region Validate ufn Names

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where ((o.OBJECT_NAME.Count(f => f == '_') != 2) && (string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0)) select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid Function Name. ", mvcInitTmps[0].SCHEMA_NAME, ".", mvcInitTmps[0].OBJECT_NAME, ". The valid format is 'ufn_Usage_TableName'. Please rename this and try again"));
                }

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where ((string.Compare(o.OBJECT_TYPE, "FUNCTION", false) == 0) && (!(o.OBJECT_NAME.StartsWith("ufn_IsExists_")))) select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid Function Name. ", mvcInitTmps[0].SCHEMA_NAME, ".", mvcInitTmps[0].OBJECT_NAME, ". The valid format is 'ufn_IsExists_TableName'. Please rename this and try again"));
                }

                # endregion

                #region Validate usp Names

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where ((o.OBJECT_NAME.Count(f => f == '_') != 2) && (string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0)) select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid Function Name. ", mvcInitTmps[0].SCHEMA_NAME, ".", mvcInitTmps[0].OBJECT_NAME, ". The valid format is 'usp_Usage_TableName'. Please rename this and try again"));
                }

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where ((string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0) && (!((o.OBJECT_NAME.StartsWith("usp_Get")) || (o.OBJECT_NAME.StartsWith("usp_Insert_")) || (o.OBJECT_NAME.StartsWith("usp_IsExists_")) || (o.OBJECT_NAME.StartsWith("usp_Update_"))))) select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid Stored Procedure Name. ", mvcInitTmps[0].SCHEMA_NAME, ".", mvcInitTmps[0].OBJECT_NAME, ". The valid format is 'usp_GetUsage_TableName / usp_Insert_TableName / usp_IsExists_TableName / usp_Update_TableName'. Please rename this and try again"));
                }

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where ((string.Compare(o.OBJECT_TYPE, "PROCEDURE", false) == 0) && (o.OBJECT_NAME.StartsWith("usp_GetAll")) && (string.Compare(o.OBJECT_NAME, "usp_GetAll_WebCulture", false) != 0) && (string.Compare(o.OBJECT_NAME, "usp_GetAll_User", false) != 0)) select o);

                if (mvcInitTmps.Count > 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid Stored Procedure Name. ", mvcInitTmps[0].SCHEMA_NAME, ".", mvcInitTmps[0].OBJECT_NAME, ". The stored procedure name should not starts with usp_GetAll. Please rename this and try again"));
                }

                # endregion

                # region Validate ufn / usp Schemas

                mvcInitTmps = new List<usp_GetAll_MvcInit_Result>(from o in mvcInits where (string.Compare(o.OBJECT_TYPE, "BASE TABLE", false) != 0) select o);

                foreach (usp_GetAll_MvcInit_Result item in mvcInitTmps)
                {
                    str = item.OBJECT_NAME.Split('_')[2];

                    if ((from o in mvcInits where ((string.Compare(o.OBJECT_TYPE, "BASE TABLE", false) == 0) && (string.Compare(o.OBJECT_NAME, str, false) == 0) && (string.Compare(o.SCHEMA_NAME, item.SCHEMA_NAME, false) == 0)) select o).Count() == 0)
                    {
                        throw new Exception(string.Concat("Sorry! invalid object. Schema Name : ", item.SCHEMA_NAME, ". Object Name : ", item.OBJECT_NAME, ". Object Type : ", item.OBJECT_TYPE, ". Valid format is SchemaName.ufn/usp_Usage_TableName"));
                    }
                }

                # endregion

                # endregion

                # region Verify Js

                validModels = Directory.GetDirectories(string.Concat(AppRootPath, @"\Views"), "*.*", SearchOption.TopDirectoryOnly).ToList();

                foreach (string item in validModels)
                {
                    str = item.Split(Convert.ToChar(@"\")).LastOrDefault();

                    if (string.Compare(str, "Shared", true) == 0)
                    {
                        continue;
                    }

                    if (Directory.GetDirectories(item, "*", SearchOption.AllDirectories).Count() > 0)
                    {
                        throw new Exception(string.Concat("Sorry! Sub folders are not allowed inside the controller ", str));
                    }

                    List<string> jss = Directory.GetDirectories(string.Concat(AppRootPath, @"\JavaScripts"), str, SearchOption.TopDirectoryOnly).ToList();

                    if (jss.Count != 1)
                    {
                        throw new Exception(string.Concat("Sorry! JavaScript folder not found for the controller ", str));
                    }

                    List<string> vewFls = Directory.GetFiles(item, "*.*", SearchOption.TopDirectoryOnly).ToList();

                    foreach (string itm in vewFls)
                    {
                        string st = itm.Split(Convert.ToChar(@"\")).LastOrDefault();

                        if (!(st.EndsWith(".cshtml")))
                        {
                            throw new Exception(string.Concat("Sorry! cshtml files only allowed inside the controller ", str));
                        }

                        st = st.Replace(".cshtml", ".js");

                        if (!(File.Exists(string.Concat(jss[0], @"\", st))))
                        {
                            throw new Exception(string.Concat("Sorry! java script file ", st, " not found for the controller ", str));
                        }
                    }
                }

                # endregion

                # region App_JsResources

                string[] jsFiles = Directory.GetFiles(string.Concat(AppRootPath, @"\App_JsResources"));

                foreach (string jsFile in jsFiles)
                {
                    Dictionary<string, string> tmpDict = new Dictionary<string, string>();
                    string line;
                    bool lineSt = false;
                    bool lineEd = false;
                    int lineNo = 0;
                    int lineNo1 = 0;
                    using (StreamReader file = new StreamReader(jsFile))
                    {
                        while ((line = file.ReadLine()) != null)
                        {
                            line = line.Trim();
                            lineNo++;

                            if (lineSt)
                            {
                                if (lineEd)
                                {
                                    lineNo1++;

                                    if ((lineNo1 == 1) && (!(string.IsNullOrWhiteSpace(line))))
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " should be blank. File Name: ", jsFile));
                                    }

                                    if ((lineNo1 == 2) && (string.Compare(line, "return {", false) != 0))
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " should be 'return {'. File Name: ", jsFile));
                                    }

                                    if ((lineNo1 == 3) && (string.Compare(line, "get: function (name) { return private[name]; }", false) != 0))
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " should be 'get: function (name) { return private[name]; }'. File Name: ", jsFile));
                                    }

                                    if ((lineNo1 == 4) && (string.Compare(line, "};", false) != 0))
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " should be '};'. File Name: ", jsFile));
                                    }

                                    if ((lineNo1 == 5) && (string.Compare(line, "})();", false) != 0))
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " should be '})();'. File Name: ", jsFile));
                                    }

                                    if (lineNo1 > 5)
                                    {
                                        throw new Exception(string.Concat("Sorry! line ", lineNo, " not. File Name: ", jsFile));
                                    }
                                }
                                else
                                {
                                    if (string.Compare(line, "};", false) == 0)
                                    {
                                        lineEd = true;
                                    }
                                    else
                                    {
                                        if ((line.StartsWith(",")) && (!(line.StartsWith(", \""))))
                                        {
                                            throw new Exception(string.Concat("Sorry! line ", lineNo, " should be starts with ', \"'. File Name: ", jsFile));
                                        }

                                        if (!(line.Contains("\": \"")))
                                        {
                                            throw new Exception(string.Concat("Sorry! line ", lineNo, " should contains '\": \"'. File Name: ", jsFile));
                                        }

                                        str = line.Split(Convert.ToChar(":"))[0];
                                        str = str.Replace("\"", string.Empty);

                                        if (string.Compare(str, str.ToUpper(), false) != 0)
                                        {
                                            throw new Exception(string.Concat("Sorry! line ", lineNo, " key should be uppercase. File Name: ", jsFile));
                                        }

                                        if (tmpDict.ContainsKey(str))
                                        {
                                            throw new Exception(string.Concat("Sorry! line ", lineNo, " contains duplicate key. File Name: ", jsFile));
                                        }

                                        tmpDict.Add(str, str);
                                    }
                                }
                            }
                            else
                            {
                                if ((lineNo == 1) && (!(string.IsNullOrWhiteSpace(line))))
                                {
                                    throw new Exception(string.Concat("Sorry! line ", lineNo, " should be blank. File Name: ", jsFile));
                                }

                                if ((lineNo == 2) && (string.Compare(line, "// http://stackoverflow.com/questions/130396/are-there-constants-in-javascript", false) != 0))
                                {
                                    throw new Exception(string.Concat("Sorry! line ", lineNo, " should be '// http://stackoverflow.com/questions/130396/are-there-constants-in-javascript'. File Name: ", jsFile));
                                }

                                if ((lineNo == 3) && (!(string.IsNullOrWhiteSpace(line))))
                                {
                                    throw new Exception(string.Concat("Sorry! line ", lineNo, " should be blank. File Name: ", jsFile));
                                }

                                if ((lineNo == 4) && (string.Compare(line, "var AlertMsgs = (function () {", false) != 0))
                                {
                                    throw new Exception(string.Concat("Sorry! line ", lineNo, " should be 'var AlertMsgs = (function () {'. File Name: ", jsFile));
                                }

                                if ((lineNo == 5) && (string.Compare(line, "var private = {", false) != 0))
                                {
                                    throw new Exception(string.Concat("Sorry! line ", lineNo, " should be 'var private = {'. File Name: ", jsFile));
                                }

                                if (lineNo == 5)
                                {
                                    lineSt = true;
                                }
                            }
                        }

                        file.Close();
                    }

                    if (!(lineSt))
                    {
                        throw new Exception(string.Concat("Sorry! Starting line key is missing. File Name: ", jsFile));
                    }

                    if (!(lineEd))
                    {
                        throw new Exception(string.Concat("Sorry! Ending line key is missing. File Name: ", jsFile));
                    }
                }

                # endregion
            }

            # endregion
        }

        #endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pMsg"></param>
        public static void SendErrorEmail(Exception pEx)
        {
            if (!(ErrorEmailSend))
            {
                return;
            }

            // http://stackoverflow.com/questions/14629304/httpcontext-current-request-isajaxrequest-error-in-mvc-4
            HttpContextBase hc = new HttpRequestWrapper(HttpContext.Current.Request).RequestContext.HttpContext;

            if ((pEx.Message.StartsWith("thread was being aborted", StringComparison.CurrentCultureIgnoreCase)) ||
                    (pEx.Message.StartsWith("unable to evaluate expression because the code is optimized or a native frame is on top of the call stack", StringComparison.CurrentCultureIgnoreCase)) ||
                    (pEx.Message.StartsWith("cannot redirect after http headers have been sent", StringComparison.CurrentCultureIgnoreCase)) ||
                    (pEx.Message.StartsWith("a public action method 'clockajaxcall' was not found on controller", StringComparison.CurrentCultureIgnoreCase)))
            {
                return;
            }

            # region Query Strings

            string tmplQryStr = string.Empty;

            NameValueCollection qryStrCol = hc.Request.QueryString;

            for (int i = 0; i < qryStrCol.Keys.Count; i++)
            {
                string tmplQryStrSub = File.ReadAllText(string.Concat(Templates, @"\QryStrError.htm"));
                string[] valArr = qryStrCol.GetValues(i);
                string val = string.Empty;

                if ((valArr != null) && (valArr.Length > 0))
                {
                    foreach (string str in valArr)
                    {
                        val = string.Concat(val, hc.Server.HtmlEncode(str), ", ");
                    }

                    val = val.Substring(0, val.Length - 2);
                }

                tmplQryStrSub = tmplQryStrSub.Replace("[a Key a]", hc.Server.HtmlEncode(qryStrCol.GetKey(i))).
                    Replace("[b Value b]", val);

                tmplQryStr = string.Concat(tmplQryStr, tmplQryStrSub);
            }

            # endregion

            # region Email Sending

            string tmplText = File.ReadAllText(string.Concat(Templates, @"\HttpError.htm"));

            tmplText = tmplText.Replace("[01 URL 01]", Convert.ToString(hc.Request.Url))
                .Replace("[02 Message 02]", pEx.ToString())
                .Replace("[03 Source 03]", pEx.Source)
                .Replace("[04 Stack Trace 04]", pEx.StackTrace)
                .Replace("[05 Agent 05]", hc.Request.UserAgent)
                .Replace("[06 Query String 06]", tmplQryStr)
                .Replace("[07 Client Host IP Address 07]", hc.Request.UserHostAddress)
                .Replace("[08 Client Host Name 08]", hc.Request.UserHostName)
                .Replace("[09 Client Host Username 09]", hc.Request.ServerVariables["REMOTE_USER"])
                .Replace("[10 Request Method Name 10]", hc.Request.ServerVariables["REQUEST_METHOD"])
                .Replace("[11 Server Host IP Address 11]", hc.Request.ServerVariables["LOCAL_ADDR"])
                .Replace("[12 Server Name 12]", hc.Request.ServerVariables["SERVER_NAME"])
                .Replace("[13 Server Port 13]", hc.Request.ServerVariables["SERVER_PORT"])
                .Replace("[14 Is Server Port Secured 14]", hc.Request.ServerVariables["SERVER_PORT_SECURE"])
                .Replace("[15 Server Protocol 15]", hc.Request.ServerVariables["SERVER_PROTOCOL"])
                .Replace("[16 Server Software 16]", hc.Request.ServerVariables["SERVER_SOFTWARE"])
                .Replace("[17 DB Server 17]", string.Empty)
                .Replace("[18 DB Name 18]", string.Empty)
                .Replace("[19 Site Version 19]", SiteVersion)
                .Replace("[u UserName u]", HttpContext.Current.Session == null ? "No Session" : string.Concat(ArivaSession.Sessions().UserDispName, " [", ArivaSession.Sessions().UserID, "]"))
                .Replace("[r Role r]", HttpContext.Current.Session == null ? "No Session" : string.Concat(ArivaSession.Sessions().SelRoleName, " [", ArivaSession.Sessions().SelRoleID, "]"))
                .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()))
                .Replace("[u SiteHomeURL u]", SiteURL)
                .Replace("[v SiteVersion v]", SiteVersion);

            ArivaEmailMessage objMailMessage = new ArivaEmailMessage();
            objMailMessage.Send(true, ErrEmailAddr, null, null, null, ErrorEmailSubject, tmplText, string.Empty, null, null);

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strImgFormat"></param>
        /// <returns></returns>
        public static bool IsImg(string strImgFormat)
        {
            // http://en.wikipedia.org/wiki/Image_file_formats
            string[] validImgFormats = new[] {".TIFF", ".TIF", ".ANI", ".ANIM", ".APNG", ".ART", ".BEF", ".BMF", ".BMP", ".BSAVE", ".CAL", ".CGM", ".CIN", ".CPC", ".DPX", 
                ".ECW", ".EXR", ".FITS", ".FLIC", ".FPX", ".GIF", ".HDRi", ".ICER", ".ICNS", ".ICO", ".CUR", ".ICS", ".IGES",  ".ILBM", ".JBIG", ".JBIG2",
                ".JNG", ".JPEG", ".JPEG 2000", ".JPEG-LS" , ".JPEG-HDR", ".JPEG XR",  ".MNG", ".MIFF", ".PBM", ".PCX", ".PGF", ".PGM", ".PICtor", ".Pixel",
                ".PNG", ".PPM", ".PSP", ".QTVR", ".RAD", ".RGBE", ".SGI", ".TGA", ".EP", ".IT", ".Logluv TIFF", ".Logluv", 
                ".WBMP", ".WebP", ".XAR", ".XBM", ".XCF", ".XPM", ".CIFF", ".DNG", ".ORF", ".AI", ".CDR", ".DXF", ".EVA", ".EMF",  ".Gerber",
                ".HVIF", ".PGML" , ".SVG", ".VML", ".WMF", ".DjVu" , ".EPS", ".PICT", ".PostScript", ".PSD", ".SWF", ".XAML", ".Exif", ".XMP", ".JPG" };

            string imgFormat = (new List<string>(from oImgFormat in validImgFormats where string.Compare(oImgFormat, strImgFormat, true) == 0 select oImgFormat)).FirstOrDefault();

            if (string.IsNullOrWhiteSpace(imgFormat))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strImgFormat"></param>
        /// <returns></returns>
        public static bool CanImg(string strImgFormat)
        {
            if (IsImg(strImgFormat))
            {
                if ((string.Compare(strImgFormat, ".TIFF", true) == 0) || (string.Compare(strImgFormat, ".TIF", true) == 0))
                {
                    return false;
                }

                return true;
            }

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pFileExtension"></param>
        /// <returns></returns>
        public static string GetFileContentType(string pFileExtension)
        {
            // http://forums.asp.net/t/1159236.aspx

            //set the default content-type 
            const string DEFAULT_CONTENT_TYPE = "application/unknown";

            RegistryKey regkey, fileextkey;
            string filecontenttype;

            //the file extension to lookup 
            //fileextension = ".zip"; 

            try
            {
                //look in HKCR 
                regkey = Registry.ClassesRoot;

                //look for extension 
                fileextkey = regkey.OpenSubKey(pFileExtension);

                //retrieve Content Type value 
                filecontenttype = fileextkey.GetValue("Content Type", DEFAULT_CONTENT_TYPE).ToString();

                //cleanup 
                fileextkey = null;
                regkey = null;
            }
            catch
            {
                filecontenttype = DEFAULT_CONTENT_TYPE;
            }

            //print the content type 
            return filecontenttype;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static RouteValueDictionary RouteValues(string pController)
        {
            return RouteValues(pController, "Search");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static RouteValueDictionary RouteValues(string pController, string pAction)
        {
            return RouteValues(pController, pAction, 0, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static RouteValueDictionary RouteValues(string pController, UInt32 pVal1, UInt32 pVal2)
        {
            return RouteValues(pController, "Search", pVal1, pVal2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static RouteValueDictionary RouteValues(string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        {
            if (!((string.Compare(pController, "PreLogIn", true) == 0) ||
                (string.Compare(pController, "Home", true) == 0)))
            {
                pController = string.Concat(pController, "_", RolePageModel.GetRolePage(ArivaSession.Sessions().SelRoleID, pController).Permission);

                if (!(Directory.Exists(string.Concat(AppRootPath, @"\Views\", pController))))
                {
                    pController = "PreLogIn";
                    //pVal1 = Converts.AsUInt32((new Random()).Next(1, 2147483646));
                }
            }

            return new RouteValueDictionary(new { controller = pController, action = pAction, idtype = RouteEncrypt(pVal1), id = RouteEncrypt(pVal2) });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static RouteData RouteDatas(string pController)
        {
            return RouteDatas(pController, "Search");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        public static RouteData RouteDatas(string pController, string pAction)
        {
            return RouteDatas(pController, pAction, 0, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static RouteData RouteDatas(string pController, UInt32 pVal1, UInt32 pVal2)
        {
            return RouteDatas(pController, "Search", pVal1, pVal2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static RouteData RouteDatas(string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        {
            RouteData retAns = new RouteData();
            retAns.Values["controller"] = pController;
            retAns.Values["action"] = pAction;
            retAns.Values["idtype"] = RouteEncrypt(pVal1);
            retAns.Values["id"] = RouteEncrypt(pVal2);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pRouteData"></param>
        /// <param name="val1"></param>
        /// <param name="val2"></param>
        public static void RouteDatas(RouteData pRouteData, out UInt32 val1, out UInt32 val2)
        {
            val1 = RouteDecrypt(pRouteData.Values["idtype"]);
            val2 = RouteDecrypt(pRouteData.Values["id"]);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKeyValue"></param>
        /// <returns></returns>
        public static Dictionary<string, object> HtmlAttributes(List<KeyValueModel<string, string>> pKeyValue)
        {
            Dictionary<string, object> retAns = new Dictionary<string, object>();

            foreach (KeyValueModel<string, string> item in pKeyValue)
            {
                if (string.IsNullOrWhiteSpace(item.Key))
                {
                    throw new Exception("Sorry! Html attribute name should not empty.");
                }

                retAns.Add(item.Key, item.Value);
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKeyValue"></param>
        /// <returns></returns>
        public static Dictionary<string, object> HtmlAttributes(KeyValueModel<string, string> pKeyValue)
        {
            return HtmlAttributes(new List<KeyValueModel<string, string>> { pKeyValue });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKey"></param>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static Dictionary<string, object> HtmlAttributes(string pKey, string pValue)
        {
            return HtmlAttributes(new KeyValueModel<string, string>(pKey, pValue));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCssClass"></param>
        /// <returns></returns>
        public static Dictionary<string, object> HtmlAttributes(string pCssClass)
        {
            return HtmlAttributes("class", pCssClass);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static string RoutePath(string pController, UInt32 pVal1, UInt32 pVal2)
        {
            return string.Concat("/", pController, "/Search/", RouteEncrypt(pVal1), "/", RouteEncrypt(pVal2), "/");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pVal1"></param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        public static string RoutePath(string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        {
            return string.Concat("/", pController, "/", pAction, "/", RouteEncrypt(pVal1), "/", RouteEncrypt(pVal2), "/");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool IsNoSqlCache()
        {
            //Dictionary<string, List<dynamic>> dictSqlCache = HttpRuntime.Cache[Constants.CacheKeys.DEFAULT_SQL_CACHE] as Dictionary<string, List<dynamic>>;

            //if ((dictSqlCache == null) || (dictSqlCache.Count == 0))
            //{
            //    return true;
            //}

            //WebCultures = dictSqlCache[Constants.CacheKeys.DEFAULT_WEB_CULTURE].ConvertAll<usp_GetAll_WebCulture_Result>(delegate(dynamic i) { return (i as usp_GetAll_WebCulture_Result); });

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        public static bool IsNoFileCache()
        {
            //string chaSts = HttpRuntime.Cache[Constants.CacheKeys.DEFAULT_ICON] as string;

            //if (string.IsNullOrEmpty(chaSts))
            //{
            //    return true;
            //}

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetDateSep()
        {
            return System.Threading.Thread.CurrentThread.CurrentUICulture.DateTimeFormat.DateSeparator;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetTimeSep()
        {
            return System.Threading.Thread.CurrentThread.CurrentUICulture.DateTimeFormat.TimeSeparator;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetDateStr()
        {
            string dtSep = GetDateSep();

            return string.Concat("MM", dtSep, "dd", dtSep, "yyyy");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetTimeStr()
        {
            string tmSep = GetTimeSep();

            return string.Concat("HH", tmSep, "mm", tmSep, "ss");
        }

        /// <summary>
        /// 
        /// </summary>
        public static string GetDateTimeStr()
        {
            return string.Concat(GetDateStr(), " ", GetTimeStr());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDate"></param>
        /// <returns></returns>
        public static string GetDateStr(DateTime? pDate)
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
        public static string GetTimeStr(DateTime? pDate)
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
        public static string GetDateTimeStr(DateTime? pDate)
        {
            return string.Concat(GetDateStr(pDate), " ", GetTimeStr(pDate));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pMins"></param>
        /// <returns></returns>
        public static string GetHourStr(Int64? pMins)
        {
            Int64 mns = pMins.HasValue ? pMins.Value : 0;
            string retAns = string.Empty;

            //mns = mns < 10 ? (mns * -1) : mns;

            Int64 hrs = (mns - (mns % 60)) / 60;
            mns -= (hrs * 60);

            if (hrs < 10)
            {
                retAns = string.Concat(retAns, 0);
            }
            retAns = string.Concat(retAns, hrs);
            retAns = string.Concat(retAns, ":");

            if (mns < 10)
            {
                retAns = string.Concat(retAns, 0);
            }
            retAns = string.Concat(retAns, mns);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetUniqueStr()
        {
            string retAns = DateTime.Now.Year.ToString();
            string tmp = DateTime.Now.Month.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            tmp = DateTime.Now.Day.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            tmp = DateTime.Now.Hour.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            tmp = DateTime.Now.Minute.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            tmp = DateTime.Now.Second.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            tmp = DateTime.Now.Millisecond.ToString();
            while (tmp.Length < 2)
            {
                tmp = string.Concat("0", tmp);
            }
            retAns = string.Concat(retAns, tmp);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pName"></param>
        /// <returns></returns>
        public static string CsResources(global::System.String pName)
        {
            Dictionary<string, string> csResInr;

            try
            {
                csResInr = _CsResource[System.Threading.Thread.CurrentThread.CurrentUICulture.Name];
            }
            catch
            {
                csResInr = _CsResource["ClaimatePrime"];
            }

            try
            {
                return csResInr[pName];
            }
            catch
            {
                return string.Empty;
            }
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pVal"></param>
        /// <returns></returns>
        private static string RouteEncrypt(UInt32 pVal)
        {
            if (pVal == 0)
            {
                return "0";
            }

            string val = pVal.ToString();

            if (val.Length > 10)
            {
                throw new Exception("Sorry! pVal length should not greater than 10");
            }

            string jnk = "XABCDEFGHIJKLMNOPQRSTUVWXYZX";
            string blnk = "XACDGIKLNOPRSUWXYX";
            string vals = "TBVFHEQMJZ";
            string nums = "0123456789";
            string retAns = string.Empty;
            Int32 mx = 0;
            List<Int32> ranNum;

            # region Add Leading Junk

            mx = jnk.Length - 1;
            ranNum = new List<Int32>();

            while (ranNum.Count < 5)
            {
                Random objRandom = new Random();
                Int32 tmp = objRandom.Next(1, mx);

                if (ranNum.Contains(tmp))
                {
                    continue;
                }

                ranNum.Add(tmp);
            }

            foreach (Int32 item in ranNum)
            {
                retAns = string.Concat(retAns, jnk.Substring(item, 1));
            }

            # endregion

            # region Add Value

            char[] valArr = val.ToCharArray();

            foreach (char item in valArr)
            {
                retAns = string.Concat(retAns, vals.Substring(nums.IndexOf(item), 1));
            }

            # endregion

            # region Add Blank

            mx = blnk.Length - 1;
            ranNum = new List<Int32>();

            while ((retAns.Length + ranNum.Count) < 15)
            {
                Random objRandom = new Random();
                Int32 tmp = objRandom.Next(1, mx);

                if (ranNum.Contains(tmp))
                {
                    continue;
                }

                ranNum.Add(tmp);
            }

            foreach (Int32 item in ranNum)
            {
                retAns = string.Concat(retAns, blnk.Substring(item, 1));
            }

            # endregion

            # region Add Post Junk

            mx = jnk.Length - 1;
            ranNum = new List<Int32>();

            while (ranNum.Count < 5)
            {
                Random objRandom = new Random();
                Int32 tmp = objRandom.Next(1, mx);

                if (ranNum.Contains(tmp))
                {
                    continue;
                }

                ranNum.Add(tmp);
            }

            foreach (Int32 item in ranNum)
            {
                retAns = string.Concat(retAns, jnk.Substring(item, 1));
            }

            # endregion

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pVal"></param>
        /// <returns></returns>
        private static UInt32 RouteDecrypt(object pVal)
        {
            string blnk = "XACDGIKLNOPRSUWXYX";
            string vals = "TBVFHEQMJZ";
            string nums = "0123456789";
            string retAns = string.Empty;
            string val = Convert.ToString(pVal);
            if ((string.IsNullOrWhiteSpace(val)) || (string.Compare(val, "0", true) == 0))
            {
                return 0;
            }

            val = val.Substring(5, 10);
            char[] valArr = val.ToCharArray();
            Int32 mx = 0;
            foreach (char item in valArr)
            {
                if (blnk.IndexOf(item) != -1)
                {
                    break;
                }

                mx++;
            }

            for (int i = 0; i < mx; i++)
            {
                retAns = string.Concat(retAns, nums.Substring(vals.IndexOf(valArr[i]), 1));
            }

            return Convert.ToUInt32(retAns);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXml"></param>
        /// <returns></returns>
        private static List<XElement> GetCsResEles(global::System.String pXml)
        {
            return (new List<XElement>(((XDocument.Load(pXml)).Element("ClaimatePrime")).Elements("data")));
        }

        # endregion
    }
}
