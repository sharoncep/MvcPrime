using System;
using System.Web.Mvc;
using System.Collections.Generic;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
namespace ClaimatePrimeControllers.Controllers
{
    public class UserClinicM_URController : BaseController
    {
        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Int64>(0);
            UserClinicSearchModel objModel = new UserClinicSearchModel() { SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID), ManagerNameID = ArivaSession.Sessions().UserID };
            objModel.FillCs(IsActive());

            return ResponseDotRedirect(objModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(UserClinicSearchModel objSearchModel)
        {
            if (objSearchModel.Save(ArivaSession.Sessions().UserID, IsActive()))
            {
                if (objSearchModel.ManagerNameID != 0)
                {
                    return ResponseDotRedirect("MenuUserA", "Search", 0, 1);
                }
                else
                {
                    return ResponseDotRedirect("MenuUserM", "Search", 0, 1);
                }
            }

            ViewBagDotErrMsg = 1;
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
        public ActionResult Search(UserClinicSearchModel objSearchModel)
        {

            objSearchModel.SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID);
            objSearchModel.ManagerNameID = ArivaSession.Sessions().UserID;
            objSearchModel.FillCs(IsActive());
            return ResponseDotRedirect(objSearchModel);
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
        public ActionResult SearchAjaxCall(string pSearchName, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            UserClinicSearchModel objSearchModel = new UserClinicSearchModel() { SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID),ManagerNameID = ArivaSession.Sessions().UserID, SearchName = pSearchName, StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            List<string> retRes = new List<string>();
            Session["pCurrPageNumber"] = pCurrPageNumber;
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_User_Result item in objSearchModel.Users)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallClinicResult(string puserID, string pmanagerID)
        {
            UserClinicSearchModel objSearchModel = new UserClinicSearchModel();
            List<string> retRes = new List<string>();

            objSearchModel.ManagerNameID = Convert.ToInt32(pmanagerID);
            Session["ManagerID"] = pmanagerID;

            objSearchModel.UserID = Converts.AsInt32(puserID);
            objSearchModel.FillJs(Converts.AsInt64(Session["pCurrPageNumber"]), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetByManagerID_Clinic_Result item in objSearchModel.ClinicNames)
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
        public ActionResult BlockUnBlockAjaxCall(string pID, string pKy, string cId, string uid)
        {
            List<string> retAns = new List<string>();
            UserClinicSaveModel objSaveModel = new UserClinicSaveModel();
            UserClinicSearchModel objSearchModel = new UserClinicSearchModel();
            if (Converts.AsInt32(pID) != 0)
            {

                objSaveModel.Fill(Converts.AsInt32(pID), IsActive());
            }

            if (Converts.AsInt32(pID) == 0)
            {
                objSaveModel.IsActive = (string.Compare(pKy, "U", true) == 0) ? true : false;
                objSaveModel.Comment = string.Concat("BlockUnBlockAjaxCall Operation: ", (string.Compare(pKy, "U", true) == 0) ? "UNBLOCKED" : "BLOCKED");
                objSaveModel.ClinicID = Converts.AsInt32(cId);
                objSaveModel.UserID = Converts.AsInt32(uid);
                objSaveModel.UserClinicID = Converts.AsInt32(pID);
                if (objSaveModel.Insert(ArivaSession.Sessions().UserID, Converts.AsInt32(objSaveModel.UserClinicID)))
                {

                    retAns.Add(string.Empty);
                }
                else
                {
                    retAns.Add(objSaveModel.ErrorMsg);
                }


            }
            else
            {
                objSaveModel.UserClinicResult.IsActive = (string.Compare(pKy, "U", true) == 0) ? true : false;
                objSaveModel.UserClinicResult.Comment = string.Concat("BlockUnBlockAjaxCall Operation: ", (string.Compare(pKy, "U", true) == 0) ? "UNBLOCKED" : "BLOCKED");
                objSaveModel.UserClinicResult.ClinicID = Converts.AsInt32(cId);
                objSaveModel.UserClinicResult.UserID = Converts.AsInt32(uid);
                objSaveModel.UserClinicResult.UserClinicID = Converts.AsInt32(pID);
                objSaveModel.UserClinicID = Converts.AsInt32(pID);
                if (objSaveModel.Update(ArivaSession.Sessions().UserID, Converts.AsInt32(objSaveModel.UserClinicID)))
                {
                    retAns.Add(string.Empty);
                }
                else
                {
                    retAns.Add(objSaveModel.ErrorMsg);
                }

            }



            return new JsonResultExtension { Data = retAns };
        }

        #endregion
    }
}
