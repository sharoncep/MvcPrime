using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeModels.SecuredFolder.Extensions;


namespace ClaimatePrimeControllers.Controllers
{
    public class ProviderM_CURDController : BaseController
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

            ProviderSearchModel objSearchModel = new ProviderSearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID };
            if (val1 < 26)
            {
                objSearchModel.StartBy = StaticClass.AtoZ[val1];
            }
            objSearchModel.Fill(IsActive());

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
            ProviderSearchModel objSearchModel = new ProviderSearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID,  SearchName = pSearchName, StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_Provider_Result item in objSearchModel.Provider)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }

       

        # endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Search(ProviderSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("ProviderM", "Save");
            }
            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
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
            ProviderSaveModel objSaveModel = new ProviderSaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

           
            
            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objSaveModel.Provider.PhotoRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objmodel"></param>
        /// <param name="filPhoto"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(ProviderSaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            objSaveModel.Provider.ClinicID = ArivaSession.Sessions().SelClinicID;

            if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
            {
                if (filUpload == null)
                {
                    objSaveModel.Provider.PhotoRelPath = string.Empty;
                }
                else
                {
                    if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                    {
                        ViewBagDotErrMsg = 2;
                        return ResponseDotRedirect(objSaveModel);
                    }

                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrProviderPhotoPath = StaticClass.FileSvrPatientDocPath;

                    objSaveModel.FileSvrProviderPhotoPath = string.Concat(objSaveModel.FileSvrProviderPhotoPath, @"\", "P_0");

                    if (!(Directory.Exists(objSaveModel.FileSvrProviderPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrProviderPhotoPath);
                    }

                    objSaveModel.Provider.PhotoRelPath = string.Concat(objSaveModel.FileSvrProviderPhotoPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                    filUpload.SaveAs(objSaveModel.Provider.PhotoRelPath);

                    objSaveModel.FileSvrProviderPhotoPath = StaticClass.FileSvrPatientDocPath;
                }
            }
            else
            {

                if (filUpload == null)
                {
                    objSaveModel.Provider.PhotoRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
                }
                else
                {
                    if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                    {
                        ViewBagDotErrMsg = 2;
                        return ResponseDotRedirect(objSaveModel);
                    }

                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrProviderPhotoPath = StaticClass.FileSvrPatientDocPath;

                    objSaveModel.FileSvrProviderPhotoPath = string.Concat(objSaveModel.FileSvrProviderPhotoPath, @"\", "P_", objSaveModel.ObjParam("Patient").Value);
                    if (!(Directory.Exists(objSaveModel.FileSvrProviderPhotoPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrProviderPhotoPath);
                    }

                    int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrProviderPhotoPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                    filsCnt++;
                    objSaveModel.FileSvrProviderPhotoPath = string.Concat(objSaveModel.FileSvrProviderPhotoPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                    objSaveModel.Provider.PhotoRelPath = objSaveModel.FileSvrProviderPhotoPath;
                    filUpload.SaveAs(objSaveModel.Provider.PhotoRelPath);
                    objSaveModel.Provider.PhotoRelPath = objSaveModel.Provider.PhotoRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                    objSaveModel.Provider.PhotoRelPath = objSaveModel.Provider.PhotoRelPath.Substring(1);

                    objSaveModel.FileSvrProviderPhotoPath = StaticClass.FileSvrPatientDocPath;
                }

            }

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("ProviderM", "Search", objSaveModel.Provider.LastName.Substring(0, 1), 1);
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
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ShowPhotoPreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ProviderID_", Request.QueryString["ky"])));

        }

        

        #endregion
    }
}
