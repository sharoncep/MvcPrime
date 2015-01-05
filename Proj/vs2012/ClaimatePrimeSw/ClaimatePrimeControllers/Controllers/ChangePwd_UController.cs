using System;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Extensions;

namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    /// By Sai : Change Password
    /// </summary>
    public class ChangePwd_UController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ChangePwd_UController()
        {
        }

        # endregion

        # region Save

        /// <summary>
        /// http://stackoverflow.com/questions/938764/clear-request-isauthenticated-value-after-signout-without-redirecttoaction
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            ChangePasswordSaveModel objSaveModel = new ChangePasswordSaveModel();
            objSaveModel.GetConfigPassword();

            return ResponseDotRedirect(new ChangePasswordSaveModel());

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(ChangePasswordSaveModel objSaveModel)
        {
            objSaveModel.UserID = ArivaSession.Sessions().UserID;
            objSaveModel.Fill(IsActive());

            string validNums = string.Join(string.Empty, StaticClass.ZeroToNine);
            string validAZs = string.Join(string.Empty, StaticClass.AtoZ);
            string validAzs = (string.Join(string.Empty, StaticClass.AtoZ)).ToLower();
            string validSpls = objSaveModel.GetSplChars().Replace(", ", string.Empty);
            char[] newPwdArr = objSaveModel.NewPwd.ToCharArray();
            int cnt = 0;

            # region InvalidCharsCount

            cnt = 0;

            foreach (char item in newPwdArr)
            {
                if ((validNums.IndexOf(item) == -1) && (validAZs.IndexOf(item) == -1) && (validAzs.IndexOf(item) == -1) && (validSpls.IndexOf(item) == -1))
                {
                    cnt++;
                }
            }

            if (cnt > 0)
            {
                ViewBagDotErrMsg = 1;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            # region No Min Length

            if (objSaveModel.NewPwd.Length < objSaveModel.PasswordResult.MinLength)
            {
                ViewBagDotErrMsg = 5;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            # region No Max Length

            if (objSaveModel.NewPwd.Length > objSaveModel.PasswordResult.MaxLength)
            {
                ViewBagDotErrMsg = 6;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            # region NumberCaseMinCount

            if (objSaveModel.PasswordResult.NumberMinCount > 0)
            {
                cnt = 0;

                foreach (char item in newPwdArr)
                {
                    if (validNums.IndexOf(item) != -1)
                    {
                        cnt++;
                    }
                }

                if (cnt < objSaveModel.PasswordResult.NumberMinCount)
                {
                    ViewBagDotErrMsg = 8;
                    objSaveModel.CurrPwdEnc = string.Empty;
                    objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                    return ResponseDotRedirect(objSaveModel);
                }
            }

            # endregion

            # region UpperCaseMinCount

            if (objSaveModel.PasswordResult.UpperCaseMinCount > 0)
            {
                cnt = 0;

                foreach (char item in newPwdArr)
                {
                    if (validAZs.IndexOf(item) != -1)
                    {
                        cnt++;
                    }
                }

                if (cnt < objSaveModel.PasswordResult.UpperCaseMinCount)
                {
                    ViewBagDotErrMsg = 7;
                    objSaveModel.CurrPwdEnc = string.Empty;
                    objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                    return ResponseDotRedirect(objSaveModel);
                }
            }

            # endregion

            # region SpecialCaseMinCount

            if (objSaveModel.PasswordResult.SplCharCount > 0)
            {
                cnt = 0;

                foreach (char item in newPwdArr)
                {
                    if (validSpls.IndexOf(item) != -1)
                    {
                        cnt++;
                    }
                }

                if (cnt < objSaveModel.PasswordResult.SplCharCount)
                {
                    ViewBagDotErrMsg = 9;
                    objSaveModel.CurrPwdEnc = string.Empty;
                    objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                    return ResponseDotRedirect(objSaveModel);
                }
            }

            # endregion

            //# region Curr Equals New

            //if (string.Compare(objSaveModel.CurrPwd, objSaveModel.NewPwd, true) == 0)
            //{
            //    ViewBagDotErrMsg = 2;
            //    objSaveModel.CurrPwdEnc = string.Empty;
            //    objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
            //    return ResponseDotRedirect(objSaveModel);
            //}

            //# endregion

            # region New Equals Curr

            if (string.Compare(objSaveModel.NewPwd, objSaveModel.ConfPwd, false) != 0)
            {
                ViewBagDotErrMsg = 3;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            objSaveModel.CurrPwdEnc = EncodePassword.PasswordSHA1(objSaveModel.CurrPwd);
            objSaveModel.NewPwdEnc = EncodePassword.PasswordSHA1(objSaveModel.NewPwd);
            objSaveModel.NewPwdEncUpr = EncodePassword.PasswordSHA1(objSaveModel.NewPwd.ToUpper());

            # region New Equals DB

            if (string.Compare(objSaveModel.NewPwdEnc, objSaveModel.UserResult.Password, true) == 0)
            {
                ViewBagDotErrMsg = 11;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }
            else if (string.Compare(objSaveModel.CurrPwdEnc, objSaveModel.UserResult.Password, true) != 0)
            {
                ViewBagDotErrMsg = 4;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            # region Curr Not Equals DB

            if (string.Compare(objSaveModel.CurrPwdEnc, objSaveModel.UserResult.Password, false) != 0)
            {
                ViewBagDotErrMsg = 11;
                objSaveModel.CurrPwdEnc = string.Empty;
                objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                return ResponseDotRedirect(objSaveModel);
            }

            # endregion

            # region HistoryReuseStatus

            foreach (usp_GetByUserID_UserPassword_Result item in objSaveModel.UserPasswordResults)
            {
                if (string.Compare(item.ALL_CAPS_PASSWORD, objSaveModel.NewPwdEncUpr, true) == 0)
                {
                    ViewBagDotErrMsg = 12;
                    objSaveModel.CurrPwdEnc = string.Empty;
                    objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
                    return ResponseDotRedirect(objSaveModel);
                }
            }

            # endregion

            if (objSaveModel.Save(objSaveModel.UserID))
            {
                return ResponseDotRedirect("PreLogIn", "LogIn", 0, 1);
            }

            ViewBagDotSuccMsg = 1;
            objSaveModel.CurrPwdEnc = string.Empty;
            objSaveModel.NewPwdEnc = string.Empty; objSaveModel.NewPwdEncUpr = string.Empty;
            return ResponseDotRedirect(objSaveModel);
        }

        # endregion
    }
}
