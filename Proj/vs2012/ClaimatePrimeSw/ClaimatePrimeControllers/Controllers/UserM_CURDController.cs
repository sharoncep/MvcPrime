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
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace ClaimatePrimeControllers.Controllers
{
    public class UserM_CURDController : BaseController
    {
        #region Search

        /// <summary>
        /// 
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            if (val2 == 1)
            {
                ViewBagDotSuccMsg = 1;
            }
            else if (val2 == 101)
            {
                // 1 to 100 Success
                // 101+ Errors
            }
            else
            {
                ViewBagDotReset();
            }

            # endregion



            UserSearchModel objSearchModel = new UserSearchModel() { SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID) , SelManagerID = ArivaSession.Sessions().UserID };

            if (val1 < 26)
            {
                objSearchModel.StartBy = StaticClass.AtoZ[val1];
            }
            objSearchModel.FillCs(IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Search(UserSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("UserM", "Save");
            }
            objSearchModel.SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID);
            objSearchModel.SelManagerID = ArivaSession.Sessions().UserID;
            objSearchModel.FillCs(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }



        # region SearchAjaxCall

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pSearchName, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            UserSearchModel objSearchModel = new UserSearchModel() { SelManagerID = ArivaSession.Sessions().UserID, SearchName = pSearchName, StartBy = pStartBy, SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID), OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_User_Result item in objSearchModel.Users)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult BlockUnBlockAjaxCall(string pID, string pKy)
        {
            List<string> retAns = new List<string>();

            UserSaveModel objSaveModel = new UserSaveModel();
            objSaveModel.Fill(Converts.AsInt32(pID), IsActive());
            objSaveModel.User.IsActive = (string.Compare(pKy, "U", true) == 0) ? true : false;
            objSaveModel.User.Comment = string.Concat("BlockUnBlockAjaxCall Operation: ", (string.Compare(pKy, "U", true) == 0) ? "UNBLOCKED" : "BLOCKED");
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                retAns.Add(string.Empty);
            }
            else
            {
                retAns.Add(objSaveModel.ErrorMsg);
            }

            return new JsonResultExtension { Data = retAns };
        }

        # endregion

        #endregion

        #region Save


        /// <summary>
        /// 
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            UserSaveModel objSaveModel = new UserSaveModel();

           // objSaveModel.User.ManagerID = ArivaSession.Sessions().UserID;

            objSaveModel.User_Manager = ArivaSession.Sessions().UserDispName;
            
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            
            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objSaveModel.User.PhotoRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("UserID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

            return ResponseDotRedirect(objSaveModel);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(UserSaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            if (filUpload == null)
            {
                if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
                {
                    objSaveModel.User.PhotoRelPath = string.Empty;
                }
                else
                {
                    objSaveModel.User.PhotoRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("UserID_", objSaveModel.User.UserID)).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
                }
               

            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }
               

                if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
                {
                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrUserPhotoPath = StaticClass.FileSvrUserPhotoPath;

                    objSaveModel.FileSvrUserPhotoPath = string.Concat(objSaveModel.FileSvrUserPhotoPath, @"\", "P_0");

                    if (!(Directory.Exists(objSaveModel.FileSvrUserPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrUserPhotoPath);
                    }

                    objSaveModel.User.PhotoRelPath = string.Concat(objSaveModel.FileSvrUserPhotoPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                    filUpload.SaveAs(objSaveModel.User.PhotoRelPath);

                    objSaveModel.FileSvrUserPhotoPath = StaticClass.FileSvrUserPhotoPath;
                }
                else
                {
                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrUserPhotoPath = StaticClass.FileSvrUserPhotoPath;

                    objSaveModel.FileSvrUserPhotoPath = string.Concat(objSaveModel.FileSvrUserPhotoPath, @"\", "US_", objSaveModel.ObjParam("User").Value);
                    if (!(Directory.Exists(objSaveModel.FileSvrUserPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrUserPhotoPath);
                    }

                    int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrUserPhotoPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                    filsCnt++;
                    objSaveModel.FileSvrUserPhotoPath = string.Concat(objSaveModel.FileSvrUserPhotoPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                    objSaveModel.User.PhotoRelPath = objSaveModel.FileSvrUserPhotoPath;
                    filUpload.SaveAs(objSaveModel.User.PhotoRelPath);
                    objSaveModel.User.PhotoRelPath = objSaveModel.User.PhotoRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                    objSaveModel.User.PhotoRelPath = objSaveModel.User.PhotoRelPath.Substring(1);

                    objSaveModel.FileSvrUserPhotoPath = StaticClass.FileSvrUserPhotoPath; 
                }
            }

            objSaveModel.Password = EncodePassword.PasswordSHA1(objSaveModel.GetPasswordUser());
            objSaveModel.PageID = 3;
            objSaveModel.UserID = ArivaSession.Sessions().UserID;
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
                {
                    # region Email Send


                    ArivaEmailMessage msg = new ArivaEmailMessage();
                    List<EmailAddress> lstTo = new List<EmailAddress>();
                    lstTo.Add(new EmailAddress(objSaveModel.User.Email, string.Concat(objSaveModel.User.LastName, " ", objSaveModel.User.FirstName, " ", objSaveModel.User.MiddleName)));

                    string tmplText = System.IO.File.ReadAllText(string.Concat(StaticClass.Templates, @"\ForgotPassword.htm"));
                    // HttpContext pHc;
                    tmplText = tmplText.Replace("[01 Username 01]", objSaveModel.User.UserName)
                                        .Replace("[02 LastName 02]", objSaveModel.User.LastName)
                                        .Replace("[03 FirstName 03]", objSaveModel.User.FirstName)
                                        .Replace("[04 MiddleName 04]", objSaveModel.User.MiddleName)
                                        .Replace("[05 Phone 05]", objSaveModel.User.PhoneNumber)
                                        .Replace("[06 Email 06]", objSaveModel.User.Email)
                                        .Replace("[07 Password 07]", objSaveModel.Password)
                                        .Replace("[u SiteHomeURL u]", StaticClass.SiteURL)
                                        .Replace("[v SiteVersion v]", StaticClass.SiteVersion)
                                        .Replace("[d Date d]", string.Concat(DateTime.Now.ToLongDateString(), " ", DateTime.Now.ToLongTimeString()));

                    objSaveModel.EmailErr = (new ArivaEmailMessage()).Send(false, lstTo, null, null, null, StaticClass.ConfigurationGeneral.mUserAccEmailSubject, tmplText, string.Empty, null, null);

                    if (string.IsNullOrWhiteSpace(objSaveModel.EmailErr))
                    {
                        ViewBagDotErrMsg = 3; // Email Error
                    }
                    else
                    {
                        return ResponseDotRedirect("UserM");
                       
                    }

                    # endregion
                }
                return ResponseDotRedirect("UserM", "Search", objSaveModel.User.LastName.Substring(0, 1), 1);
            }


            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ShowPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("UserID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

       

        #endregion
    }
}
