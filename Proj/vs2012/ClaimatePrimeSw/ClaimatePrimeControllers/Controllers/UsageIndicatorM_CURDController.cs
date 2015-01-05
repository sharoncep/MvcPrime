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
    public class UsageIndicatorM_CURDController : BaseController
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
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);

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

            UsageIndicatorSearchModel objSearchModel = new UsageIndicatorSearchModel();

           
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
        public ActionResult Search(UsageIndicatorSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("UsageIndicatorM", "Save");
            }

            objSearchModel.FillCs(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

      

        

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
            UsageIndicatorSaveModel objSaveModel = new UsageIndicatorSaveModel();
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
        public ActionResult Save(UsageIndicatorSaveModel objSaveModel)
        {
            //objSaveModel.Fill(ArivaSession.Sessions().UserID, IsActive());
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                ViewBagDotSuccMsg = 1;
                return ResponseDotRedirect("UsageIndicatorM","Search", objSaveModel.UsageIndicator.InterchangeUsageIndicatorName.Substring(0, 1), 1);
            }

            ViewBagDotErrMsg = 1;


            return ResponseDotRedirect(objSaveModel);
        }


        #endregion
    }
}
