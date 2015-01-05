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

namespace ClaimatePrimeControllers.Controllers
{
    public class Document_RController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Document_RController()
        {
        }

        # endregion

        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
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

            if (ArivaSession.Sessions().SelPatientID == 0)
            {
                PatientDocumentSearchModel objModel = new PatientDocumentSearchModel();

                if (val1 < 26)
                {
                    objModel.StartBy = StaticClass.AtoZ[val1];
                }

                objModel.FillCs(IsActive());

                return ResponseDotRedirect(objModel);
            }
            else
            {
                PatientDocumentSearchModel objModel = new PatientDocumentSearchModel();
                objModel.FillIsActive(ArivaSession.Sessions().SelPatientID);
                if (val1 < 26)
                {
                    objModel.StartBy = StaticClass.AtoZ[val1];
                }

                objModel.FillCategoryPatient(ArivaSession.Sessions().SelPatientID, IsActive());

                foreach (PatientDocumentSearchSubModel item in objModel.PatientDocumentSearchSubModels)
                {
                    foreach (usp_GetByPkId_PatientDocument_Result itemSub in item.PatientDocumentResults)
                    {
                        string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", itemSub.DocumentRelPath);
                        if (!(System.IO.File.Exists(filePath)))
                        {
                            filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_FILE_ICON);
                        }

                        ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientDocumentID_", itemSub.PatientDocumentID), filePath);
                    }
                }

                return ResponseDotRedirect(objModel);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Search(PatientDocumentSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);
                string ctrl = string.Empty;

                if (ArivaSession.Sessions().SelPatientID == 0)
                {
                    ctrl = "Document";
                }
                else
                {
                    ctrl = "PatDocument";
                }


                return ResponseDotRedirect(ctrl, "Save");
            }

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
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            PatientDocumentSearchModel objSearchModel = new PatientDocumentSearchModel() { SearchName = pSearchName, DateFrom = Converts.AsDateTimeNullable(pDateFrom), DateTo = Converts.AsDateTimeNullable(pDateTo), StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField, PatientID = ArivaSession.Sessions().SelPatientID };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_PatientDocument_Result item in objSearchModel.PatientDocumentSearch)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }

        # endregion

        #endregion

        #region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            PatientDocumentSaveModel objModel = new PatientDocumentSaveModel();

            objModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            if (ArivaSession.Sessions().SelPatientID > 0)
            {

                if ((objModel.PatientDocumentResult.PatientID != ArivaSession.Sessions().SelPatientID) || (string.IsNullOrWhiteSpace(objModel.PatientDocumentResult_Patient)))
                {
                    objModel.PatientDocumentResult.PatientID = ArivaSession.Sessions().SelPatientID;
                    objModel.GetChartNumber();
                }
            }

            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objModel.PatientDocumentResult.DocumentRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_FILE_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientDocumentID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

            return ResponseDotRedirect(objModel);

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
        public ActionResult Save(PatientDocumentSaveModel objSaveModel, HttpPostedFileBase filUpload)
        {
            PatientDocumentSearchModel objSearchModel = new PatientDocumentSearchModel();

            if (ArivaSession.Sessions().PageEditID<global::System.Int64>() == 0)
            {
                if (filUpload == null)
                {
                    ViewBagDotErrMsg = 3;
                    return ResponseDotRedirect(objSaveModel);
                }
                else
                {
                    if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                    {
                        ViewBagDotErrMsg = 2;
                        return ResponseDotRedirect(objSaveModel);
                    }

                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrPatientDocPath = StaticClass.FileSvrPatientDocPath;

                    objSaveModel.FileSvrPatientDocPath = string.Concat(objSaveModel.FileSvrPatientDocPath, @"\", "P_0");

                    if (!(Directory.Exists(objSaveModel.FileSvrPatientDocPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrPatientDocPath);
                    }

                    objSaveModel.PatientDocumentResult.DocumentRelPath = string.Concat(objSaveModel.FileSvrPatientDocPath, @"\", System.Guid.NewGuid().ToString().Replace("-", string.Empty), Path.GetExtension(filUpload.FileName));
                    filUpload.SaveAs(objSaveModel.PatientDocumentResult.DocumentRelPath);

                    objSaveModel.FileSvrPatientDocPath = StaticClass.FileSvrPatientDocPath;
                }
            }
            else
            {

                if (filUpload == null)
                {
                    objSaveModel.PatientDocumentResult.DocumentRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
                }
                else
                {
                    if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUpload.ContentLength)
                    {
                        ViewBagDotErrMsg = 2;
                        return ResponseDotRedirect(objSaveModel);
                    }

                    objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
                    objSaveModel.FileSvrPatientDocPath = StaticClass.FileSvrPatientDocPath;

                    objSaveModel.FileSvrPatientDocPath = string.Concat(objSaveModel.FileSvrPatientDocPath, @"\", "P_", objSaveModel.ObjParam("Patient").Value);
                    if (!(Directory.Exists(objSaveModel.FileSvrPatientDocPath)))
                    {
                        Directory.CreateDirectory(objSaveModel.FileSvrPatientDocPath);
                    }

                    int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.FileSvrPatientDocPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                    filsCnt++;
                    objSaveModel.FileSvrPatientDocPath = string.Concat(objSaveModel.FileSvrPatientDocPath, @"\", "U_", filsCnt, Path.GetExtension(filUpload.FileName));
                    objSaveModel.PatientDocumentResult.DocumentRelPath = objSaveModel.FileSvrPatientDocPath;
                    filUpload.SaveAs(objSaveModel.PatientDocumentResult.DocumentRelPath);
                    objSaveModel.PatientDocumentResult.DocumentRelPath = objSaveModel.PatientDocumentResult.DocumentRelPath.Replace(objSaveModel.FileSvrRootPath, string.Empty);
                    objSaveModel.PatientDocumentResult.DocumentRelPath = objSaveModel.PatientDocumentResult.DocumentRelPath.Substring(1);

                    objSaveModel.FileSvrPatientDocPath = StaticClass.FileSvrPatientDocPath;
                }

            }




            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                string ctrl = string.Empty;

                if (ArivaSession.Sessions().SelPatientID == 0)
                {
                    ctrl = "Document";

                    return ResponseDotRedirect(ctrl, "Search", objSaveModel.PatientDocumentResult_Patient.Substring(0, 1), 1);
                }
                else
                {
                    ctrl = "PatDocument";
                    return ResponseDotRedirect(ctrl, "Search", 0, 1);
                }
            }








            ViewBagDotErrMsg = 1;

            return ResponseDotRedirect(objSaveModel);
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
        public ActionResult IsInPatAjaxCall(string pDocumentCategoryID)
        {
            List<global::System.Boolean> retAns = new List<bool>();

            PatientDocumentSaveModel objModel = new PatientDocumentSaveModel();
            retAns.Add(objModel.GetIsInPatient(Converts.AsByte(pDocumentCategoryID)));

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SearchFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SearchFilePreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveFilePreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));

        }

        #endregion
    }
}
