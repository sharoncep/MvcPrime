using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.AjaxCalls.AsgnClaims;
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
    /// By Sai:Manager Role - Case Reclose - Reclosing the already reoopened case in Manager Case Reopen page
    /// </summary>
    public class CaseReclose_URController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseReclose_URController()
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
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int64>(0);

            CaseReCloseSearchModel objSearchModel = new CaseReCloseSearchModel()
            {
                ClinicID = ArivaSession.Sessions().SelClinicID
               
            };
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
        public ActionResult Search(CaseReCloseSearchModel objSearchModel)
        {
            //if (objSearchModel.CurrNumber > 0)
            //{
            //    ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

            //    if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive(true)))
            //    {
            //        ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

            //        return ResponseDotRedirect("ClinicSetUpM","Search",0,1);
            //    }
            //}

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
          
            objSearchModel.FillCs(IsActive());
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
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            CaseReCloseSearchModel objSearchModel = new CaseReCloseSearchModel()
            {
                SearchName = pSearchName,
                DateFrom = Converts.AsDateTimeNullable(pDateFrom),
                DateTo = Converts.AsDateTimeNullable(pDateTo),
                StartBy = pStartBy,
                OrderByDirection = pOrderByDirection,
                OrderByField = pOrderByField,
                ClinicID = ArivaSession.Sessions().SelClinicID,
               
            };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearchCaseReopen_ClaimProcess_Result item in objSearchModel.Claims)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };

        }


        # endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <returns></returns>
        public ActionResult BlockUnBlockAjaxCall(string pID)
        {
            List<string> retAns = new List<string>();
            CaseReCloseSearchModel objSearchModel = new CaseReCloseSearchModel();

            objSearchModel.CurrNumber = Convert.ToInt64(pID);

            if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive(true)))
            {

                retAns.Add(string.Empty);
            }


            return new JsonResultExtension { Data = retAns };
        }

        
    }
}
