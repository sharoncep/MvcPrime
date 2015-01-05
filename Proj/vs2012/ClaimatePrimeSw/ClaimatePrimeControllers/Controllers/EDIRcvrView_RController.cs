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
    public class EDIRcvrView_RController : BaseController
    {

        #region EDI Rcvr

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().PageEditID<global::System.Int32>(0);

            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            EDIReceiverDisplayModel objSearchModel = new EDIReceiverDisplayModel() { ClinicID = ArivaSession.Sessions().SelClinicID, StatusIDs = string.Concat(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK)) };
            objSearchModel.Fill(IsActive());

            if (objSearchModel.EDIReceiverResult.Count == 1)
            {
                if (val1 == 1)
                {
                    return ResponseDotRedirect("MenuEDIE", "Search", 1, 0);
                }

                return ResponseDotRedirect("EDICreate", "Search", Convert.ToUInt32(objSearchModel.EDIReceiverResult[0].EDIReceiverID), 0);
            }



            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

    }
}
