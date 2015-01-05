using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using ArivaEmail;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Extensions;
using System.IO;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class PreLogInController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PreLogInController()
        {
        }

        # endregion

        # region ChangePwdSuccess

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ChangePwdSuccess()
        {
            ArivaSession.Initialize("RR=SRS_PL_CPS");   // PreLogIn Change Password Success
            return ResponseDotRedirect();
        }

        # endregion

        # region Error404

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Error404()
        {
            ArivaSession.Initialize("RR=SRS_PL_E404");   // PreLogIn ERROR 404
            return ResponseDotRedirect();
        }

        # endregion

        # region ErrorUnExp

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ErrorUnExp()
        {
            ArivaSession.Initialize("RR=SRS_PL_EUEX");   // PreLogIn ERROR UN EXPECTED
            return ResponseDotRedirect();
        }

        # endregion

        # region FAQ

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult FAQ()
        {
            return ResponseDotRedirect();
        }

        # endregion

        #region ForgotPassword

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ForgotPassword()
        {
            return ResponseDotRedirect(new ForgotPasswordModel());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("ForgotPassword")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult ForgotPassword(ForgotPasswordModel objModel)
        {
            if (!string.IsNullOrWhiteSpace(objModel.Email))
            {
                objModel.FillByForgotUser();

                if (objModel.UserResult.UserID > 0)
                {
                    if (objModel.UserResult.IsActive)
                    {
                        if (objModel.UserResult.IsBlocked)
                        {
                            ViewBagDotErrMsg = 4; // User on long leave
                        }
                        else
                        {
                            string nwPwdPlain = objModel.GetPasswordUser();

                            if (objModel.SaveForgotPwd(EncodePassword.PasswordSHA1(nwPwdPlain), EncodePassword.PasswordSHA1(nwPwdPlain.ToUpper()), HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName, ArivaSession.Sessions().ID))
                            {
                                # region Email Send
                                ArivaEmailMessage msg = new ArivaEmailMessage();
                                List<EmailAddress> lstTo = new List<EmailAddress>();
                                lstTo.Add(new EmailAddress(objModel.UserResult.Email, string.Concat(objModel.UserResult.LastName, " ", objModel.UserResult.FirstName, " ", objModel.UserResult.MiddleName)));

                                string tmplText = System.IO.File.ReadAllText(string.Concat(StaticClass.Templates, @"\ForgotPassword.htm"));
                                // HttpContext pHc;
                                tmplText = tmplText.Replace("[01 Username 01]", objModel.UserResult.UserName)
                                                    .Replace("[02 LastName 02]", objModel.UserResult.LastName)
                                                    .Replace("[03 FirstName 03]", objModel.UserResult.FirstName)
                                                    .Replace("[04 MiddleName 04]", objModel.UserResult.MiddleName)
                                                    .Replace("[05 Phone 05]", objModel.UserResult.PhoneNumber)
                                                    .Replace("[06 Email 06]", objModel.UserResult.Email)
                                                    .Replace("[07 Password 07]", nwPwdPlain)
                                                    .Replace("[u SiteHomeURL u]", StaticClass.SiteURL)
                                                    .Replace("[v SiteVersion v]", StaticClass.SiteVersion)
                                                    .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()));

                                objModel.EmailErr = (new ArivaEmailMessage()).Send(false, lstTo, null, null, null, StaticClass.ConfigurationGeneral.mUserAccEmailSubject, tmplText, string.Empty, null, null);

                                if (string.IsNullOrWhiteSpace(objModel.EmailErr))
                                {
                                    return ResponseDotRedirect("PreLogIn", "LogIn", 0, 2); // Success
                                }
                                else
                                {
                                    ViewBagDotErrMsg = 3; // Email Error
                                }

                                # endregion
                            }
                            else
                            {
                                ViewBagDotErrMsg = 2; // DB Error
                            }
                        }
                    }
                    else
                    {
                        ViewBagDotErrMsg = 5; // User blocked
                    }
                }
                else
                {
                    ViewBagDotErrMsg = 1; // User Not Found
                }
            }
            else
            {
                ViewBagDotErrMsg = 1; // User Not Found
            }

            return ResponseDotRedirect(objModel);
        }

        #endregion

        #region Contactus

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Contactus()
        {
            ContactUsModel objModel = new ContactUsModel();
            objModel.GetByPkIdUserWebAdmin(IsActive());

            return ResponseDotRedirect(objModel);
        }

        #endregion

        # region LogIn

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult LogIn()
        {
            # region Delete ReportTmp (300 Mins)

            // Same Code is available at 3 Places (1) WebSite PreLogin Controller, (2) Data Sync Exe and (3) Excel Export Exe

            DateTime currUtc = DateTime.UtcNow;

            string[] filePaths = Directory.GetFiles(string.Concat(StaticClass.AppRootPath, @"\ReportTmp"), "*.*", SearchOption.AllDirectories);

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

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            string RR = Request.QueryString["RR"];  // Redirect Reason
            if (!(string.IsNullOrWhiteSpace(RR)))
            {
                if (string.Compare(RR, "E404", true) == 0)  // Error 404
                {
                    return ResponseDotRedirect("PreLogIn", "Error404");
                }

                if (string.Compare(RR, "EUEX", true) == 0)  // Error Un Expected
                {
                    return ResponseDotRedirect("PreLogIn", "ErrorUnExp");
                }

                if (string.Compare(RR, "NAC", true) == 0)   // No access permission
                {
                    val2 = 101;  // No access permission
                }
                else if (string.Compare(RR, "SEC", true) == 0)   // Session has been expired due to improper cache
                {
                    val2 = 102;  // Session has been expired due to improper cache
                }
                else if (string.Compare(RR, "MPS", true) == 0)   // Exceeds Maximum Page Size. Refer, ArivaErros
                {
                    val2 = 103;  // Exceeds Maximum Page Size. Refer, ArivaErros
                }
                else if (string.Compare(RR, "IVS", true) == 0)   // In-valid session
                {
                    val2 = 104;  // In-valid session
                }
                else if (string.Compare(RR, "RNA", true) == 0)   // Role Not Assigned
                {
                    val2 = 105;  // Role Not Assigned
                }
                else if (string.Compare(RR, "NCS", true) == 0)   // No Clinic Session
                {
                    val2 = 106;  // No Clinic Session
                }
                else if (string.Compare(RR, "NPS", true) == 0)   // No Patient Session
                {
                    val2 = 107;  // No Patient Session
                }
                else if (string.Compare(RR, "UES", true) == 0)   // Un-Expected Session
                {
                    val2 = 108;  // Un-Expected Session
                }
                else if (string.Compare(RR, "MFM", true) == 0)   // More than one form is not allowed
                {
                    val2 = 109;  // More than one form is not allowed
                }
                else if (string.Compare(RR, "NAD", true) == 0)   // Form not used ariva id
                {
                    val2 = 110;  // Form not used ariva id
                }
                else if (string.Compare(RR, "SID", true) == 0)   // Don't use the id
                {
                    val2 = 111;  // Don't use the id
                }
                else if (string.Compare(RR, "SNM", true) == 0)   // Don't use the name
                {
                    val2 = 112;  // Don't use the name
                }
                else if (string.Compare(RR, "NBT", true) == 0)   // No balance trail
                {
                    val2 = 117;  // Don't use the name
                }
                else if (string.Compare(RR, "NDS", true) == 0)   // No Provider Session
                {
                    val2 = 120;  // No Provider Session
                }
                else if (string.Compare(RR, "NAS", true) == 0)   // No Agent Session
                {
                    val2 = 121;  // No Agent Session
                }
                else
                {
                    val2 = 113;  // Invalid Login 
                }
            }

            if (val2 == 1)
            {
                ViewBagDotSuccMsg = 1;  // Change Password Success
            }
            else if (val2 == 2)
            {
                ViewBagDotSuccMsg = 2;  // Forgot Password Success
            }
            else if (val2 == 101)
            {
                ViewBagDotErrMsg = 1;  // No access permission
            }
            else if (val2 == 102)
            {
                ViewBagDotErrMsg = 2;   // Session has been expired due to improper cache
            }
            else if (val2 == 103)
            {
                ViewBagDotErrMsg = 3;   // Exceeds Maximum Page Size. Refer, ArivaErros
            }
            else if (val2 == 104)
            {
                ViewBagDotErrMsg = 4;   // In-valid session
            }
            else if (val2 == 105)
            {
                ViewBagDotErrMsg = 5;   // Role Not Assigned
            }
            else if (val2 == 106)
            {
                ViewBagDotErrMsg = 6;   // No Clinic Session
            }
            else if (val2 == 107)
            {
                ViewBagDotErrMsg = 7;   // No Patient Session
            }
            else if (val2 == 108)
            {
                ViewBagDotErrMsg = 8;   // Un-Expected Session
            }
            else if (val2 == 109)
            {
                ViewBagDotErrMsg = 9;   // More than one form is not allowed
            }
            else if (val2 == 110)
            {
                ViewBagDotErrMsg = 10;   // Form not used ariva id
            }
            else if (val2 == 111)
            {
                ViewBagDotErrMsg = 11;   // Don't use the id
            }
            else if (val2 == 112)
            {
                ViewBagDotErrMsg = 12;   // Don't use the name
            }
            else if (val2 == 113)
            {
                ViewBagDotErrMsg = 13;   // Invalid Login - No User Name
            }
            else if (val2 == 114)
            {
                ViewBagDotErrMsg = 14;   // error in insert (after password check)
            }
            else if (val2 == 115)
            {
                ViewBagDotErrMsg = 15;   //  Invalid Login - Invalid Password
            }
            else if (val2 == 116)
            {
                ViewBagDotErrMsg = 16;   //  Invalid Login - Invalid User Name
            }
            else if (val2 == 117)
            {
                ViewBagDotErrMsg = 17;   //  No Balance 
            }
            else if (val2 == 118)
            {
                ViewBagDotErrMsg = 18;   //No role assigned error
            }
            else if (val2 == 119)
            {
                ViewBagDotErrMsg = 19;   //No Clinic assigned error
            }
            else if (val2 == 120)
            {
                ViewBagDotErrMsg = 20;   //No Provider Session
            }
            else if (val2 == 121)
            {
                ViewBagDotErrMsg = 21;   //No Agent Session
            }
            else
            {
                ViewBagDotReset();
            }

            # endregion

            ArivaSession.Initialize("RR=SRS_PL_LN");

            LogInModel objModel = new LogInModel() { UserCulture = ArivaSession.Sessions().UserCulture };

            //objModel.SenthilSR();

            # region Load Statics

            # region WebCultures

            objModel.FillWebCultures();

            # endregion

            # region Configuration General

            StaticClass.ConfigurationGeneral = GeneralConfigModel.GetGeneralConfig();

            # endregion

            # endregion

            return ResponseDotRedirect(objModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objLogInModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("LogIn")]
        [AcceptParameter(ButtonName = "btnLogIn")]
        public ActionResult LogIn(LogInModel objLogInModel)
        {
            if (!(string.IsNullOrWhiteSpace(objLogInModel.UserLogin.UserName)))
            {
                bool isEmail = false;

                try
                {
                    isEmail = string.IsNullOrWhiteSpace(new MailAddress(objLogInModel.UserLogin.UserName).Address) ? false : true;
                }
                catch
                {
                    isEmail = false;
                }

                usp_GetByUserName_User_Result oLogIn = objLogInModel.GetByUserNameUser(objLogInModel.UserLogin.UserName, isEmail);

                if (oLogIn.UserID == 0)
                {
                    if (objLogInModel.SaveLogInTrial(objLogInModel.UserLogin.UserName, false, HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName))
                    {
                        return ResponseDotRedirect("PreLogIn", "LogIn", 0, 116);
                    }
                }

                //check trial balance
                usp_GetByPkId_Password_Result objPassword = objLogInModel.FillPassword();

                if (objLogInModel.GetTrialBalanceLogInTrial(oLogIn.Email, objPassword.TrialMaxCount))
                {
                    string dbPwd = EncodePassword.PasswordSHA1(ArivaSession.Sessions().Seed, oLogIn.Password);

                    if (string.Compare(objLogInModel.UserLogin.Password, dbPwd, true) == 0)
                    {
                        usp_GetRole_UserRole_Result highRole = objLogInModel.GetRoleUserRole(oLogIn.UserID);

                        if (highRole.RoleID != 0) //has role?
                        {
                            //has clinic?
                            if (objLogInModel.HasClinic(oLogIn.UserID))
                            {
                                if (objLogInModel.SaveLogInTrial(oLogIn.Email, true, HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName))
                                {
                                    ArivaSession.Initialize("RR=SRS_PL_LNS");

                                    ArivaSession.Sessions().LogInSuccess(oLogIn.UserID, oLogIn.LastName, oLogIn.FirstName, oLogIn.MiddleName, oLogIn.Email, oLogIn.PhoneNumber, highRole.RoleID, highRole.RoleName);

                                    FormsAuthentication.SetAuthCookie(oLogIn.UserName, false);

                                    //check pwd age

                                    if (objLogInModel.IsPasswordAged(oLogIn.Email, objPassword.ExpiryDayMaxCount))
                                    {
                                        //set flag on alerconfig in user table
                                        objLogInModel.Fill(ArivaSession.Sessions().UserID, IsActive(true));
                                        objLogInModel.UpdateAlertConfig(ArivaSession.Sessions().UserID);

                                    }

                                    // Check for alert flag
                                    if (objLogInModel.IsAlert(oLogIn.UserID))
                                    {
                                        //show change pwd alert
                                        return ResponseDotRedirect("Home", "Search", 1, 0);
                                    }
                                    else
                                    {
                                        return ResponseDotRedirect("Home", "Search", 0, 0);
                                    }

                                }
                                else
                                {
                                    //error in insert (after password check)
                                    return ResponseDotRedirect("PreLogIn", "LogIn", 0, 114);
                                }
                            }
                            else
                            {
                                //No Clinic assigned error
                                return ResponseDotRedirect("PreLogIn", "LogIn", 0, 119);
                            }
                        }
                        else
                        {
                            //No role assigned error
                            return ResponseDotRedirect("PreLogIn", "LogIn", 0, 118);
                        }
                    }
                    else
                    {
                        if (!(objLogInModel.SaveLogInTrial(oLogIn.Email, false, HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName)))
                        {
                            //error in insert (invalid pwd )
                            return ResponseDotRedirect("PreLogIn", "LogIn", 0, 115);
                        }
                    }
                }
                else
                {
                    // no balance
                    return ResponseDotRedirect("PreLogIn", "LogIn", 0, 117);
                }
            }

            return ResponseDotRedirect("PreLogIn", "LogIn", 0, 113);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objLogInModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("LogIn")]
        [AcceptParameter(ButtonName = "btnUserCulture")]
        public ActionResult UserCulture(LogInModel objLogInModel)
        {
            ArivaSession.Sessions().UserCulture = objLogInModel.UserCulture;
            return ResponseDotRedirect("PreLogIn", "LogIn");
        }

        # endregion

        # region Fav Icons

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult FavIco()
        {
            return ResponseDotFile(string.Concat(StaticClass.AppRootPath, @"Images\", Constants.XMLSchema.FAV_ICO));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult FavPng()
        {
            return ResponseDotFile(string.Concat(StaticClass.AppRootPath, @"Images\", Constants.XMLSchema.FAV_PNG));
        }

        # endregion

        # region Clock

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult ClockAjaxCall()
        {
            List<CurrDtTm> retAns = new List<CurrDtTm>();
            retAns.Add(CurrDtTm.Get());

            return new JsonResultExtension { Data = retAns };
        }

        # endregion

        # region Supporting Actions / Adjustment Instead of LogOut

        // All distinct actions which are using in our entire project need to come here

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            return ResponseDotRedirect("PreLogIn", "LogIn");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            return ResponseDotRedirect("PreLogIn", "LogIn");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Display()
        {
            return ResponseDotRedirect("PreLogIn", "LogIn");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult UnBlock()
        {
            return ResponseDotRedirect("PreLogIn", "LogIn");
        }

        # endregion
    }
}
