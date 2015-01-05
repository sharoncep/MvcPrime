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
    public class ClinicViewM_RController : BaseController
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

            # endregion

            ClinicSearchManagerModel objSearchModel = new ClinicSearchManagerModel() { UserID = ArivaSession.Sessions().UserID };
            objSearchModel.FillClinicCount();

            if (objSearchModel.ClinicCount.CLINIC_COUNT == 1)
            {
                if (val1 == 1)
                {
                    return ResponseDotRedirect("MenuBillingInfo", "Search", 1, 0);
                }

                objSearchModel.Fill(IsActive());
                return ResponseDotRedirect("Home", "SetManagerClinicSession", 0, Convert.ToUInt32(objSearchModel.Clinic[0].ClinicID));
            }

            string stby = Request.QueryString["qsby"];
            if ((string.IsNullOrWhiteSpace(stby)) || (stby.Length != 1))
            {
                stby = "A";
            }

            objSearchModel = new ClinicSearchManagerModel() { StartBy = stby, UserID = ArivaSession.Sessions().UserID };
            objSearchModel.Fill(IsActive());

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
            ClinicSaveModel objSaveModel = new ClinicSaveModel();

            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON));
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
        public ActionResult Save(ClinicSaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            objSaveModel.ClinicResult.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSaveModel.UserResult.UserID = ArivaSession.Sessions().UserID;
            objSaveModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            if (filUpload == null)
            {
                objSaveModel.ClinicResult.LogoRelPath = string.Empty;
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrClinicLogoPath;

                objSaveModel.FileSvrClinicPhotoPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", "P_0");

                if (!(Directory.Exists(objSaveModel.FileSvrClinicPhotoPath)))
                {
                    Directory.CreateDirectory(objSaveModel.FileSvrClinicPhotoPath);
                }

                objSaveModel.ClinicResult.LogoRelPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                filUpload.SaveAs(objSaveModel.ClinicResult.LogoRelPath);

                objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrPatientPhotoPath;
            }
            objSaveModel.UserResult.UserID = ArivaSession.Sessions().UserID;
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("ClinicViewM", "Search", objSaveModel.ClinicResult.ClinicName.Substring(0, 1), 1);
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
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }
        # endregion

    }
}
