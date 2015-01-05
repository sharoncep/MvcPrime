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
using System.IO;

namespace ClaimatePrimeControllers.Controllers
{
    public class EDICreateSuccess_RController : BaseController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            EDICreateSuccessModel objSuccModel = new EDICreateSuccessModel() { X12 = System.IO.File.ReadAllText(ArivaSession.Sessions().FilePathsDotValue("EDIFileID_X12"), Encoding.GetEncoding(1252)), Refs = new List<string>() };

            string line;
            using (StreamReader file = new StreamReader(ArivaSession.Sessions().FilePathsDotValue("EDIFileID_Ref"), Encoding.GetEncoding(1252)))
            {
                while ((line = file.ReadLine()) != null)
                {
                    objSuccModel.Refs.Add(line);
                }

                file.Close();
            }

            return ResponseDotRedirect(objSuccModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SuccessX12()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue("EDIFileID_X12"));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SuccessRef()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue("EDIFileID_Ref"));
        }
    }
}
