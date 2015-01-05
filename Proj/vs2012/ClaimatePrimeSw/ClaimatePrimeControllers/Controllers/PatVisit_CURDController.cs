using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
    public class PatVisit_CURDController : Visit_CRController
    {
        # region Protected Variables

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PatVisit_CURDController()
        {
            IsPatSessReq = true;
        }

        # endregion
    }
}
