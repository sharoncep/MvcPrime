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
    public class PatDemography_URDController : BaseController
    {
        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
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
            return ResponseDotRedirect();
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
            ArivaSession.Sessions().PageEditID<global::System.Int64>(ArivaSession.Sessions().SelPatientID);

            PatientDemographySaveModel objSaveModel = new PatientDemographySaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            if (!((string.Compare(objSaveModel.PatientResult.Sex, Convert.ToString(Sex.M), true) == 0) || (string.Compare(objSaveModel.PatientResult.Sex, Convert.ToString(Sex.F), true) == 0) || (string.Compare(objSaveModel.PatientResult.Sex, Convert.ToString(Sex.O), true) == 0)))
            {
                objSaveModel.PatientResult.Sex = Convert.ToString(Sex.M);
            }

            
            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objSaveModel.PatientResult.PhotoRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

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
        public ActionResult Save(PatientDemographySaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            objSaveModel.PatientResult.ClinicID = ArivaSession.Sessions().SelClinicID;

            if (filUpload == null)
            {
                objSaveModel.PatientResult.PhotoRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }

            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.FileSvrPatientPhotoPath = StaticClass.FileSvrPatientPhotoPath;

                objSaveModel.FileSvrPatientPhotoPath = string.Concat(objSaveModel.FileSvrPatientPhotoPath, @"\", "P_", objSaveModel.ObjParam("Patient").Value);
                if (!(Directory.Exists(objSaveModel.FileSvrPatientPhotoPath)))
                {
                    Directory.CreateDirectory(objSaveModel.FileSvrPatientPhotoPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrPatientPhotoPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.FileSvrPatientPhotoPath = string.Concat(objSaveModel.FileSvrPatientPhotoPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                objSaveModel.PatientResult.PhotoRelPath = objSaveModel.FileSvrPatientPhotoPath;
                filUpload.SaveAs(objSaveModel.PatientResult.PhotoRelPath);
                objSaveModel.PatientResult.PhotoRelPath = objSaveModel.PatientResult.PhotoRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                objSaveModel.PatientResult.PhotoRelPath = objSaveModel.PatientResult.PhotoRelPath.Substring(1);

                objSaveModel.FileSvrPatientPhotoPath = StaticClass.FileSvrPatientPhotoPath;                
            }

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("PatDemography", "Search", 0, 1);
            }
            else if (objSaveModel.ErrorMsg.Contains("Violation of UNIQUE KEY constraint"))
            {
                ViewBagDotErrMsg = 3;
            }
            else
            {
                ViewBagDotErrMsg = 1;
               
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
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        #endregion
    }
}
