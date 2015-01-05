using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;
using System;
using System.Web.Mvc;

namespace ClaimatePrimeControllers.Controllers
{
    public class RelationshipM_CURDController : BaseController
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

            RelationshipSearchModel objSearchModel = new RelationshipSearchModel();
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
        public ActionResult Search(RelationshipSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Byte>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("RelationshipM", "Save");
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
            RelationshipSaveModel objModel = new RelationshipSaveModel();
            objModel.Fill(ArivaSession.Sessions().PageEditID<global::System.Byte>(), IsActive());

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
        public ActionResult Save(RelationshipSaveModel objmodel)
        {
            bool saveRelationship = objmodel.Save(ArivaSession.Sessions().UserID);
            if (saveRelationship)
            {
                return ResponseDotRedirect("RelationshipM", "Search", 0, 1);
            }
            else
            {


                ViewBagDotErrMsg = 1;

                if (objmodel.ErrorMsg.Contains("Violation of UNIQUE KEY constraint"))
                {
                    ViewBagDotErrMsg = 2;
                }
                else if (objmodel.ErrorMsg.Contains("CHECK constraint"))
                {
                    ViewBagDotErrMsg = 3;
                }

                return ResponseDotRedirect(objmodel);
            }

           
        }

        #endregion
    }
}
