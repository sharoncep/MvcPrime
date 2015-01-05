using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class EDICreate_CRController : BaseController
    {


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
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

            Ansi8375010SearchModel objSearchModel = new Ansi8375010SearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID, EDIReceiverID = Convert.ToInt32(val1) };
            objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Search")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(Ansi8375010SearchModel objSearchModel)
        {
            Ansi8375010SaveModel objSaveModel = new Ansi8375010SaveModel();
            objSaveModel.EDIReceiverID = objSearchModel.EDIReceiverID;
            objSaveModel.FileSvrRootPath = StaticClass.FileSvrRootPath;
            objSaveModel.FileSvrEDIX12FilePath = StaticClass.FileSvrEDIX12FilePath;
            objSaveModel.FileSvrEDIRefFilePath = StaticClass.FileSvrEDIRefFilePath;
            objSaveModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSaveModel.ANSI5010XmlPath = string.Concat(StaticClass.AppRootPath, @"\App_ANSI5010\ANSI5010Xml.xml");
            objSaveModel.EDIFileDate = DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff);

            objSaveModel.CommentForEAPerQ = "Sys Gen : EA_PERSONAL_QUEUE";
            objSaveModel.CommentForEdiCreated = "Sys Gen : EDI_FILE_CREATED";
            objSaveModel.CommentForSentClaim = "Sys Gen : SENT_CLAIM";

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                ArivaSession.Sessions().FilePathsDotAdd("EDIFileID_X12", objSaveModel.FileSvrEDIX12FilePath);
                ArivaSession.Sessions().FilePathsDotAdd("EDIFileID_Ref", objSaveModel.FileSvrEDIRefFilePath);

                return ResponseDotRedirect("EDICreateSuccess");
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }

    }
}
