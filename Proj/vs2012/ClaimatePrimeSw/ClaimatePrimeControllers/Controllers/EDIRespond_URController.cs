using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class EDIRespond_URController : BaseController
    {
        #region Search
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {

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

            EDIRespondSearchModel objSearchModel = new EDIRespondSearchModel();

            return ResponseDotRedirect(objSearchModel);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        public ActionResult Search(EDIRespondSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("EDIRespond", "Save");
            }

            return ResponseDotRedirect(objSearchModel);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ShowRefEDIFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("RefEDIFileID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ShowX12EDIFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("X12EDIFileID_", Request.QueryString["ky"])));
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
            EDIRespondVisitSearchModel objSearchModel = new EDIRespondVisitSearchModel();
            objSearchModel.Search(Convert.ToInt32(ArivaSession.Sessions().PageEditID<Int64>()), ArivaSession.Sessions().SelClinicID, ArivaSession.Sessions().UserID);
            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// //
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(EDIRespondVisitSearchModel objSearchModel)
        {
            objSearchModel._CommentForAccepted = "Sys Gen : ACCEPTED_CLAIM";
            objSearchModel._CommentForDone = "Sys Gen : DONE";
            objSearchModel._CommentForEdiResponsed = "Sys Gen : EDI_FILE_RESPONSED";
            objSearchModel._CommentForQAPerQ = "Sys Gen : QA_PERSONAL_QUEUE";
            objSearchModel._CommentForRejected = "Sys Gen : REJECTED_CLAIM";
            objSearchModel._CommentForRejectReasgn = "Sys Gen : REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA";

            if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive(true)))
            {
                return ResponseDotRedirect("EDIRespond", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

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
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pDOSFrom, string pDOSTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            EDIRespondSearchModel objSearchModel = new EDIRespondSearchModel()
            {
                SearchName = pSearchName
                ,
                DateFrom = Converts.AsDateTimeNullable(pDateFrom)
                ,
                DateTo = Converts.AsDateTimeNullable(pDateTo)
                ,
                DOSFrom = Converts.AsDateTimeNullable(pDOSFrom)
                ,
                DOSTo = Converts.AsDateTimeNullable(pDOSTo)
                ,
                StartBy = pStartBy
                ,
                OrderByDirection = pOrderByDirection
                ,
                OrderByField = pOrderByField
                ,
                ClinicID = ArivaSession.Sessions().SelClinicID
                ,
                UserID = ArivaSession.Sessions().UserID
            };


            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), true, StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            foreach (usp_GetSentFile_EDIFile_Result item in objSearchModel.EDIFileResult)
            {
                EDIRespondSearchSubModel objSubModel = new EDIRespondSearchSubModel() { EDIFileID = item.EDIFileID, FileDate = StaticClass.GetDateTimeStr(item.CreatedOn), RefFileSvrPath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.RefFileRelPath), X12FileSvrPath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.X12FileRelPath) };

                if (!(System.IO.File.Exists(objSubModel.RefFileSvrPath)))
                {
                    objSubModel.RefFileSvrPath = string.Concat(StaticClass.FileSvrRootPath, @"\", ClaimatePrimeConstants.Constants.XMLSchema.NO_FILE_ICON);
                }

                if (!(System.IO.File.Exists(objSubModel.X12FileSvrPath)))
                {
                    objSubModel.X12FileSvrPath = string.Concat(StaticClass.FileSvrRootPath, @"\", ClaimatePrimeConstants.Constants.XMLSchema.NO_FILE_ICON);
                }

                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("RefEDIFileID_", objSubModel.EDIFileID), objSubModel.RefFileSvrPath);
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("X12EDIFileID_", objSubModel.EDIFileID), objSubModel.X12FileSvrPath);
                objSearchModel.EDIFileSearchSubModels.Add(objSubModel);
            }

            List<SearchResult> retAns = new List<SearchResult>();

            foreach (EDIRespondSearchSubModel item in objSearchModel.EDIFileSearchSubModels)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };

        }

        #endregion
    }
}
