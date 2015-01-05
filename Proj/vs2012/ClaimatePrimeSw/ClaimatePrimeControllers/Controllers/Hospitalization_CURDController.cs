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
    public class Hospitalization_CURDController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Hospitalization_CURDController()
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


            PatientHospitalizationSearchModel objModel = new PatientHospitalizationSearchModel() { PatientID = ArivaSession.Sessions().SelPatientID , ClinicID = ArivaSession.Sessions().SelClinicID };
            if (IsPatSessReq)
            {
                objModel.FillIsActive();
            }
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
        public ActionResult Search(PatientHospitalizationSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {

                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);
                string ctrl = string.Empty;

                if (ArivaSession.Sessions().SelPatientID == 0)
                {
                    ctrl = "Hospitalization";                   
                }
                else
                {
                    ctrl = "PatHospitalization";
                }

                return ResponseDotRedirect(ctrl, "Save");

                
            }
            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSearchModel.PatientID = ArivaSession.Sessions().SelPatientID;
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
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pPatientID, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            PatientHospitalizationSearchModel objSearchModel = new PatientHospitalizationSearchModel() {ClinicID = ArivaSession.Sessions().SelClinicID, SearchName = pSearchName,DateFrom = Converts.AsDateTimeNullable(pDateFrom), DateTo = Converts.AsDateTimeNullable(pDateTo), StartBy = pStartBy, PatientID = ArivaSession.Sessions().SelPatientID, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_PatientHospitalization_Result item in objSearchModel.PatientHospitalization)
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
            if (!(IsPatSessReq))
            {
                ArivaSession.Sessions().SetPatient(0, string.Empty);
            }

            PatientHospitalizationSaveModel objmodel = new PatientHospitalizationSaveModel();
            objmodel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int64>(), IsActive());

            if (ArivaSession.Sessions().SelPatientID > 0)
            {
                if ((objmodel.PatientHospitalizationResult.PatientID != ArivaSession.Sessions().SelPatientID) || (string.IsNullOrWhiteSpace(objmodel.PatientHospitalizationResult_Patient)))
                {
                    objmodel.PatientHospitalizationResult.PatientID = ArivaSession.Sessions().SelPatientID;
                    objmodel.GetChartNumber(IsActive());
                }
            }

            return ResponseDotRedirect(objmodel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(PatientHospitalizationSaveModel objSaveModel)
        {
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                string ctrl = string.Empty;

                if (ArivaSession.Sessions().SelPatientID == 0)
                {
                    ctrl = "Hospitalization";
                    ArivaSession.Sessions().SetPatient(objSaveModel.PatientHospitalizationResult.PatientID, objSaveModel.PatientHospitalizationResult_Patient);
                }
                else
                {
                    ctrl = "PatHospitalization";
                }

                return ResponseDotRedirect(ctrl, "Search", ArivaSession.Sessions().SelPatientDispName.Substring(0, 1), 1);
            }

            //if (objSaveModel.ErrorMessage == 1)
            //{
            //    ViewBagDotErrMsg = 2;
            //}
            //else if (objSaveModel.ErrorMessage == 2)
            //{
            //    ViewBagDotErrMsg = 3;
            //}
            //else if (objSaveModel.ErrorMessage == 3)
            //{
            //    ViewBagDotErrMsg = 4;
            //}
            //else if (objSaveModel.ErrorMessage == 4)
            //{
            //    ViewBagDotErrMsg = 5;
            //}
            //else if (objSaveModel.ErrorMessage == 5)
            //{
            //    ViewBagDotErrMsg = 6;
            //}
           
            //else if (objSaveModel.ErrorMessage == 6)
            //{
            //    ViewBagDotErrMsg = 7;
            //}
            //else if (objSaveModel.ErrorMessage == 7)
            //{
            //    ViewBagDotErrMsg = 8;
            //}
            //else if (objSaveModel.ErrorMessage == 8)
            //{
            //    ViewBagDotErrMsg = 9;
            //}
            //else if (objSaveModel.ErrorMessage == 9)
            //{
            //    ViewBagDotErrMsg = 10;
            //}
            //else if (objSaveModel.ErrorMessage == 10)
            //{
            //    ViewBagDotErrMsg = 11;
            //}
            //else if (objSaveModel.ErrorMsg.Contains("CK_PatientHospitalization_AdmittedOn"))
            //{
            //    ViewBagDotErrMsg = 12;
            //}
            //else if (objSaveModel.ErrorMsg.Contains("CK_PatientHospitalization_DischargedOn"))
            //{
            //    ViewBagDotErrMsg = 13;
            //} 

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }

        #endregion
    }
}
