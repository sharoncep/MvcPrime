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
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class EDIM_CURDController : BaseController
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

            EDISearchModel objSearchModel = new EDISearchModel();

            if (val1 < 26)
            {
                objSearchModel.StartBy = StaticClass.AtoZ[val1];
            }
            objSearchModel.Fill(IsActive());

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
        public ActionResult Search(EDISearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("EDIM", "Save");
            }

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
            EDISaveModel objModel = new EDISaveModel();
            objModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Int32>(), IsActive());

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
        public ActionResult Save(EDISaveModel objmodel)
        {
            bool saveEDI = objmodel.Save(ArivaSession.Sessions().UserID);
            if (saveEDI)
            {
                return ResponseDotRedirect("EDIM", "Search", 0, 1);
            }
            else
            {
                ViewBagDotErrMsg = 1;

                return ResponseDotRedirect(objmodel);
            }


        }

        #endregion
    }
}
