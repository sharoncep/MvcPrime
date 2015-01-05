using System;
using System.Collections.Generic;
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
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class InsuranceM_CURDController : BaseController
    {
        #region Insurance

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

            InsuranceSearchModel objSearchModel = new InsuranceSearchModel();

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
        public ActionResult Search(InsuranceSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("InsuranceM", "Save");
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
        public ActionResult SearchAjaxCall(string pSearchName, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            InsuranceSearchModel objSearchModel = new InsuranceSearchModel() { SearchName = pSearchName, StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_Insurance_Result item in objSearchModel.Insurance)
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
            InsuranceSaveModel objModel = new InsuranceSaveModel();
            objModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

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
        public ActionResult Save(InsuranceSaveModel objmodel)
        {
            bool saveEDI = objmodel.Save(ArivaSession.Sessions().UserID);
            if (saveEDI)
            {
                return ResponseDotRedirect("InsuranceM", "Search", objmodel.Insurance.InsuranceName.Substring(0, 1), 1);
            }
            else
            {
                ViewBagDotErrMsg = 1;

                return ResponseDotRedirect(objmodel);
            }


        }

        #endregion

        #endregion
    }
}
