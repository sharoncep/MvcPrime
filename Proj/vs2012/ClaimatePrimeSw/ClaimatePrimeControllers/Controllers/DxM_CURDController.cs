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
    public class DxM_CURDController : BaseController
    {
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

            DiagnosisSearchModel objSearchModel = new DiagnosisSearchModel();

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
        public ActionResult Search(DiagnosisSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("DxM", "Save");
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
            DiagnosisSearchModel objSearchModel = new DiagnosisSearchModel() { SearchName = pSearchName, StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_Diagnosis_Result item in objSearchModel.Counties)
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
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
           

            DiagnosisSaveModel objSaveModel = new DiagnosisSaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            return ResponseDotRedirect(objSaveModel);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(DiagnosisSaveModel objSaveModel)
        {
            //objSaveModel.Fill(ArivaSession.Sessions().UserID, IsActive());
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                if (objSaveModel.Diagnosis.ShortDesc != null)
                {
                    return ResponseDotRedirect("DxM", "Search", objSaveModel.Diagnosis.ShortDesc.Substring(0, 1), 1);
                }
                else if (objSaveModel.Diagnosis.LongDesc != null && objSaveModel.Diagnosis.ShortDesc == null)
                {
                    return ResponseDotRedirect("DxM", "Search", objSaveModel.Diagnosis.LongDesc.Substring(0, 1), 1);
                }

                else if (objSaveModel.Diagnosis.CustomDesc != null && objSaveModel.Diagnosis.ShortDesc == null)
                {
                    return ResponseDotRedirect("DxM", "Search", objSaveModel.Diagnosis.LongDesc.Substring(0, 1), 1);
                }

                return ResponseDotRedirect("DxM", "Search", 0, 1);
                
            }
            else
            {
                ViewBagDotErrMsg = 1;

                return ResponseDotRedirect(objSaveModel);
            }

         
           
        }


        #endregion
    }
}
