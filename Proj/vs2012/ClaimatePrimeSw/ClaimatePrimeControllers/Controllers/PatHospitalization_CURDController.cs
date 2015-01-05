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
    public class PatHospitalization_CURDController : Hospitalization_CURDController
    {
        # region Protected Variables

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PatHospitalization_CURDController()
        {
            IsPatSessReq = true;
        }

        # endregion
    }
}
