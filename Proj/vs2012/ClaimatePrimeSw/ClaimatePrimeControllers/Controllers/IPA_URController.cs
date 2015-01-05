using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeConstants;
using System.IO;
using System.Web;
using System.Collections.Generic;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using System;
using ClaimatePrimeModels.SecuredFolder.Extensions;

namespace ClaimatePrimeControllers.Controllers
{
    public class IPA_URController : BaseController
    {
        #region Search

        /// <summary>
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

            IPASearchModel objSearchModel = new IPASearchModel();

            if (val1 < 26)
            {
                objSearchModel.StartBy = StaticClass.AtoZ[val1];
            }
            objSearchModel.Fill(IsActive());

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
        public ActionResult Search(IPASearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                if (ArivaSession.Sessions().SelRoleID == 2)
                {
                    return ResponseDotRedirect("IPAM", "SearchView");
                }
                else if (ArivaSession.Sessions().SelRoleID == 1)
                {
                    return ResponseDotRedirect("IPA", "Save");
                }
            }

            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

        #region SearchView

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SearchView()
        {
       
            IPASearchModel objSearchModel = new IPASearchModel();
            objSearchModel.fillByID(ArivaSession.Sessions().PageEditID<global::System.Byte>(), IsActive());

            return ResponseDotRedirect(objSearchModel);
        }

      

        #endregion

        # region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            IPASaveModel objSaveModel = new IPASaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            
            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objSaveModel.IPA.LogoRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath); ;

            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <param name="filUpload"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(IPASaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            if (filUpload == null)
            {
                objSaveModel.IPA.LogoRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.FileSvrIPALogoPath = StaticClass.FileSvrIPALogoPath;

                objSaveModel.FileSvrIPALogoPath = string.Concat(objSaveModel.FileSvrIPALogoPath, @"\", "P_", objSaveModel.ObjParam("Patient").Value);
                if (!(Directory.Exists(objSaveModel.FileSvrIPALogoPath)))
                {
                    Directory.CreateDirectory(objSaveModel.FileSvrIPALogoPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrIPALogoPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.FileSvrIPALogoPath = string.Concat(objSaveModel.FileSvrIPALogoPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                objSaveModel.IPA.LogoRelPath = objSaveModel.FileSvrIPALogoPath;
                filUpload.SaveAs(objSaveModel.IPA.LogoRelPath);
                objSaveModel.IPA.LogoRelPath = objSaveModel.IPA.LogoRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                objSaveModel.IPA.LogoRelPath = objSaveModel.IPA.LogoRelPath.Substring(1);

                objSaveModel.FileSvrIPALogoPath = StaticClass.FileSvrIPALogoPath;
            }

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("IPA", "Search", objSaveModel.IPA.IPAName.Substring(0, 1), 1);
            }

            ViewBagDotErrMsg = 1;

            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ShowPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        # endregion
    }
}
