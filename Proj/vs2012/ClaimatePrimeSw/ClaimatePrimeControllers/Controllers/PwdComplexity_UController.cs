using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using ClaimatePrimeConstants;
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
    public class PwdComplexity_UController : BaseController
    {
        #region PwdComplexity

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
                // 1 to 100 Success
                // 101+ Errors

                ViewBagDotSuccMsg = 1;
            }
            else
            {
                ViewBagDotReset();
            }

            # endregion

            PasswordConfigModel objPwdComplex = new PasswordConfigModel();
            objPwdComplex.Fill(IsActive());           

            return ResponseDotRedirect(objPwdComplex);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objPwdComplex"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Search(PasswordConfigModel objPwdComplex)
        {
            if (objPwdComplex.Save (ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("MenuConfig", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;

            return ResponseDotRedirect(objPwdComplex);
        }
        #endregion
    }
}
