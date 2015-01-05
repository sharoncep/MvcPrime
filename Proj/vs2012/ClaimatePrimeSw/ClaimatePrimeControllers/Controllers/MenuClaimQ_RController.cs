using System;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;


namespace ClaimatePrimeControllers.Controllers
{
    public class MenuClaimQ_RController : BaseController
    {
        #region Search

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            ArivaSession.Sessions().SetPatient(0, string.Empty);
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

            MenuClaimSearchModel objMenuClaim = new MenuClaimSearchModel()
            {
                assignedTo = ArivaSession.Sessions().UserID
                 ,
                UnassigneClaimStatus = string.Concat(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK))
                ,
                UnassigneClaimNITStatus = Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK).ToString()
                ,
                AssigneClaimStatus = string.Concat(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK))
                ,
                AssigneClaimNITStatus = Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK).ToString()
                ,
                CreatedClaimStatus = string.Concat
                    (
                    Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE)
                    , ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK)
                    , ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE)
                    , ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK)
                    , ", ", Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA)
                    , ", ", Convert.ToByte(ClaimStatus.EDI_FILE_CREATED)
                    , ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM)
                    , ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK)
                    , ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM)
                    , ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK)
                    , ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA)
                    , ", ", Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM)
                    , ", ", Convert.ToByte(ClaimStatus.DONE)
                    )
            };

            objMenuClaim.GetCountPatientVisit(ArivaSession.Sessions().SelClinicID);

            return ResponseDotRedirect(objMenuClaim);
        }

        #endregion
    }
}
