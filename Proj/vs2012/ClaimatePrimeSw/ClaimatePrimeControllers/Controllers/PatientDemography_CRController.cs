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
    public class PatientDemography_CRController : BaseController
    {
        # region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            if (!(IsPatSessReq))
            {
                ArivaSession.Sessions().SetPatient(0, string.Empty);
            }

            ArivaSession.Sessions().PageEditID<global::System.Int64>(0);

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

            PatientDemographySearchModel objModel = new PatientDemographySearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID };

            if (val1 < 26)
            {
                objModel.StartBy = StaticClass.AtoZ[val1];
            }

            objModel.FillCs(IsActive());

            return ResponseDotRedirect(objModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Search(PatientDemographySearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().SetPatient(objSearchModel.CurrNumber, objSearchModel.GetChartByID(IsActive()));
                return ResponseDotRedirect("PatDemography");
            }

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
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
            PatientDemographySearchModel objSearchModel = new PatientDemographySearchModel() { SearchName = pSearchName, StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField, ClinicID = ArivaSession.Sessions().SelClinicID };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_Patient_Result item in objSearchModel.Patient)
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
            retAns.Add("xxxxxxxxx");

            return new JsonResultExtension { Data = retAns };
        }

        # endregion

        # endregion

        # region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            PatientDemographySaveModel objSaveModel = new PatientDemographySaveModel() { PatientResult = new usp_GetByPkId_Patient_Result() };
            objSaveModel.PatientResult.Sex = Convert.ToString(Sex.M);
            objSaveModel.PatientResult.IsActive = true;

            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON));

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
                objSaveModel.PatientResult.PhotoRelPath = string.Empty;
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

                objSaveModel.FileSvrPatientPhotoPath = string.Concat(objSaveModel.FileSvrPatientPhotoPath, @"\", "P_0");

                if (!(Directory.Exists(objSaveModel.FileSvrPatientPhotoPath)))
                {
                    Directory.CreateDirectory(objSaveModel.FileSvrPatientPhotoPath);
                }

                objSaveModel.PatientResult.PhotoRelPath = string.Concat(objSaveModel.FileSvrPatientPhotoPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                filUpload.SaveAs(objSaveModel.PatientResult.PhotoRelPath);

                objSaveModel.FileSvrPatientPhotoPath = StaticClass.FileSvrPatientPhotoPath;
            }

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("PatientDemography", "Search", objSaveModel.PatientResult.LastName.Substring(0, 1), 1);
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

        # endregion
    }
}
