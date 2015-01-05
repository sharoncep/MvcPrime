using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Extensions;


namespace ClaimatePrimeControllers.Controllers
{
    /// <summary>
    ///  By Sai : Admin Role - Practice Clinic - Edit/Save/Delete
    /// </summary>
    public class ClinicA_CURDController : BaseController
    {
        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
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

            ClinicSearchAdModel objSearchModel = new ClinicSearchAdModel() { UserID = ArivaSession.Sessions().UserID };
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
        public ActionResult Search(ClinicSearchAdModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {

                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);
                string ctrl = string.Empty;

                if (ArivaSession.Sessions().SelRoleID == 1)
                {
                    ctrl = "ClinicA";
                }
                else
                {
                    ctrl = "ClinicSetUpM";
                }

                return ResponseDotRedirect(ctrl, "Save");


            }
            objSearchModel.UserID = ArivaSession.Sessions().UserID;
            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }


        #endregion

        #region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            if (ArivaSession.Sessions().SelClinicID != 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(ArivaSession.Sessions().SelClinicID);
            }

            ClinicSaveModel objSaveModel = new ClinicSaveModel();



            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());


            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objSaveModel.ClinicResult.LogoRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

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

            if (filUpload == null)
            {
                if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
                {
                    objSaveModel.ClinicResult.LogoRelPath = string.Empty;
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
                    objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrUserPhotoPath;

                    objSaveModel.FileSvrClinicPhotoPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", "P_0");

                    if (!(Directory.Exists(objSaveModel.FileSvrClinicPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrClinicPhotoPath);
                    }

                    objSaveModel.ClinicResult.LogoRelPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                    filUpload.SaveAs(objSaveModel.ClinicResult.LogoRelPath);

                    objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrUserPhotoPath;
                }
                else
                {
                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrUserPhotoPath;

                    objSaveModel.FileSvrClinicPhotoPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", "P_", objSaveModel.ObjParam("Patient").Value);
                    if (!(Directory.Exists(objSaveModel.FileSvrClinicPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrClinicPhotoPath);
                    }

                    int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrClinicPhotoPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                    filsCnt++;
                    objSaveModel.FileSvrClinicPhotoPath = string.Concat(objSaveModel.FileSvrClinicPhotoPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                    objSaveModel.ClinicResult.LogoRelPath = objSaveModel.FileSvrClinicPhotoPath;
                    filUpload.SaveAs(objSaveModel.ClinicResult.LogoRelPath);
                    objSaveModel.ClinicResult.LogoRelPath = objSaveModel.ClinicResult.LogoRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                    objSaveModel.ClinicResult.LogoRelPath = objSaveModel.ClinicResult.LogoRelPath.Substring(1);

                    objSaveModel.FileSvrClinicPhotoPath = StaticClass.FileSvrUserPhotoPath;
                }
            }

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                if (ArivaSession.Sessions().SelRoleID == 2)
                {
                    return ResponseDotRedirect("ClinicSetUpM", "Search", objSaveModel.ClinicResult.ClinicName.Substring(0, 1), 1);
                }
                else if (ArivaSession.Sessions().SelRoleID == 1)
                {
                    return ResponseDotRedirect("ClinicA", "Search", objSaveModel.ClinicResult.ClinicName.Substring(0, 1), 1);
                }
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



        #endregion
    }
}
