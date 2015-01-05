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
    public class UserRoleA_URController : BaseController
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

            UserRoleSearchModel objSearchModel = new UserRoleSearchModel() { SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID) };

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
        public ActionResult Search(UserRoleSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("UserA", "Save");
            }

            objSearchModel.SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID);

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
            UserRoleSearchModel objSearchModel = new UserRoleSearchModel() { SearchName = pSearchName, StartBy = pStartBy, SelHighRoleID = Convert.ToByte(Role.EA_ROLE_ID), OrderByDirection = pOrderByDirection, OrderByField = pOrderByField };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);
            Session["pCurrPageNumber"] = pCurrPageNumber;
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
        public ActionResult SearchAjaxCallRoleResult(string puserID)
        {
            UserRoleSearchModel objSearchModel = new UserRoleSearchModel();
            List<string> retRes = new List<string>();
            objSearchModel.UserID = Converts.AsInt32(puserID);
            objSearchModel.FillJs(Converts.AsInt64(Session["pCurrPageNumber"]), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetAgent_Role_Result item in objSearchModel.Roles)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }
       /// <summary>
       /// 
       /// </summary>
       /// <param name="pID"></param>
       /// <param name="pKy"></param>
       /// <param name="cId"></param>
       /// <param name="uid"></param>
       /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult BlockUnBlockAjaxCall(string pID, string pKy, string rId, string uid)
        {
            List<string> retAns = new List<string>();
            UserRoleSaveModel objSaveModel = new UserRoleSaveModel();
            UserRoleSearchModel objSearchModel = new UserRoleSearchModel();
            if (Converts.AsInt32(pID) != 0)
            {

                objSaveModel.Fill(Converts.AsInt32(pID), IsActive());
            }

            if (Converts.AsInt32(pID) == 0)
            {
                objSaveModel.IsActive = (string.Compare(pKy, "U", true) == 0) ? true : false;
                objSaveModel.Comment = string.Concat("BlockUnBlockAjaxCall Operation: ", (string.Compare(pKy, "U", true) == 0) ? "UNBLOCKED" : "BLOCKED");
                objSaveModel.RoleID = Converts.AsByte(rId);
                objSaveModel.UserID = Converts.AsInt32(uid);
                objSaveModel.UserRoleID = Converts.AsInt32(pID);
                if (objSaveModel.Insert(ArivaSession.Sessions().UserID, Converts.AsInt32(objSaveModel.UserRoleID)))
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
                objSaveModel.UserRoleResult.IsActive = (string.Compare(pKy, "U", true) == 0) ? true : false;
                objSaveModel.UserRoleResult.Comment = string.Concat("BlockUnBlockAjaxCall Operation: ", (string.Compare(pKy, "U", true) == 0) ? "UNBLOCKED" : "BLOCKED");
                objSaveModel.UserRoleResult.RoleID = Converts.AsByte(rId);
                objSaveModel.UserRoleResult.UserID = Converts.AsInt32(uid);
                objSaveModel.UserRoleResult.UserRoleID = Converts.AsInt32(pID);
                objSaveModel.UserRoleID = Converts.AsInt32(pID);
                if (objSaveModel.Update(ArivaSession.Sessions().UserID, Converts.AsInt32(objSaveModel.UserRoleID)))
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

        # endregion

        #endregion
    }
}
