using System;
using System.Collections.Generic;
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
    public class HomeController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public HomeController()
        {
        }

        # endregion

        # region Search

        /// <summary>
        /// http://stackoverflow.com/questions/938764/clear-request-isauthenticated-value-after-signout-without-redirecttoaction
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

            # endregion

            return ResponseDotRedirect("Dashboard", "Search", val1, val2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetRoleSession()
        {
            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            usp_GetByPkId_Role_Result role = (new RoleModel()).GetByPkIdRole(Convert.ToByte(val2));
            ArivaSession.Sessions().SetRole(role.RoleID, role.RoleName);

            if (role.RoleID == 1)
            {
                return ResponseDotRedirect("MenuA");
            }

            if (role.RoleID == 2)
            {
                return ResponseDotRedirect("MenuM");
            }

            if (role.RoleID == 3)
            {
                return ResponseDotRedirect("ClinicView");
            }

            if (role.RoleID == 4)
            {
                return ResponseDotRedirect("ClinicView");
            }

            if (role.RoleID == 5)
            {
                return ResponseDotRedirect("ClinicView");
            }

            return ResponseDotRedirect();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetClinicSession()
        {
            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            usp_GetByPkId_Clinic_Result clinic = (new ClinicSearchModel()).GetByPkIdClinic(Convert.ToInt32(val2), IsActive());
            ArivaSession.Sessions().SetClinic(clinic.ClinicID, string.Concat(clinic.ClinicName, " [", clinic.ClinicCode, "]"));


            if (ArivaSession.Sessions().SelRoleID == 5)
            {
                return ResponseDotRedirect("MenuB");
            }

            if (ArivaSession.Sessions().SelRoleID == 4)
            {
                return ResponseDotRedirect("MenuClaimQ");
            }

            if (ArivaSession.Sessions().SelRoleID == 3)
            {
                return ResponseDotRedirect("MenuClaimE");
            }

            return ResponseDotRedirect();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetRptClinicSession()
        {
            usp_GetByPkId_Clinic_Result clinic = (new ClinicSearchModel()).GetByPkIdClinic(Converts.AsInt32(Request.QueryString["qsky"]), IsActive());
            ArivaSession.Sessions().SetClinic(clinic.ClinicID, string.Concat(clinic.ClinicName, " [", clinic.ClinicCode, "]"));
            return ResponseDotRedirect("RptClinicWise");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetRptAgentSession()
        {
            usp_GetByPkId_User_Result user = (new User_UserModel()).GetByPkIdUser(Converts.AsInt32(Request.QueryString["qsky"]), IsActive());
            ArivaSession.Sessions().SetAgent(user.UserID, string.Concat(user.LastName, " ", user.FirstName, " [", user.UserName, "]"));
            return ResponseDotRedirect("RptAgentWise", "AgentWise");

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetRptProviderSession()
        {
            usp_GetByPkId_Provider_Result provider = (new ProviderSearchModel()).GetByPkIdProvider(Converts.AsInt32(Request.QueryString["qsky"]), IsActive());
            ArivaSession.Sessions().SetProvider(provider.ProviderID, string.Concat(provider.LastName, " ", provider.FirstName, " [", provider.ProviderCode, "]"));
            return ResponseDotRedirect("RptProviderWise");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetRptPatientSession()
        {
            usp_GetByPkId_Patient_Result patient = (new PatientDemographySearchModel()).GetByPkIdPatient(Converts.AsInt32(Request.QueryString["qsky"]), IsActive());
            ArivaSession.Sessions().SetPatient(patient.PatientID, string.Concat(patient.LastName, " ", patient.FirstName, " [", patient.ChartNumber, "]"));
            return ResponseDotRedirect("RptPatientWise", "PatientDash");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SetManagerClinicSession()
        {
            # region Message Capturing

            UInt32 val1;
            UInt32 val2;
            ResponseDotMessage(out val1, out val2);

            # endregion

            usp_GetByPkId_Clinic_Result clinic = (new ClinicSearchModel()).GetByPkIdClinic(Converts.AsInt32(val2), IsActive());
            ArivaSession.Sessions().SetClinic(clinic.ClinicID, string.Concat(clinic.ClinicName, " [", clinic.ClinicCode, "]"));

            return ResponseDotRedirect("ClinicSetUpM");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult LockAjaxCall()
        {
            List<string> retAns = new List<string>();

            LockUnLockSaveModel objSaveModel = new LockUnLockSaveModel();
            objSaveModel.Fill(IsActive());
            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                retAns.Add(string.Empty);
            }
            else
            {
                retAns.Add(objSaveModel.ErrorMsg);
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPwd"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UnLockAjaxCall(string pPwd)
        {
            List<string> retAns = new List<string>();

            User_UserModel objUser = new User_UserModel();
            usp_GetByPkId_User_Result oUser = objUser.GetByPkIdUser(ArivaSession.Sessions().UserID, true);

            if ((new LogInModel()).GetTrialBalanceLogInTrial(oUser.Email, (new LogInModel()).FillPassword().TrialMaxCount))
            {
                if (string.Compare(pPwd, oUser.Password, true) == 0)
                {
                    (new LogInModel()).SaveLogInTrial(oUser.Email, true, HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName);

                    LockUnLockSaveModel objSaveModel = new LockUnLockSaveModel();
                    objSaveModel.Fill(((byte)1), IsActive());
                    if (objSaveModel.Save(ArivaSession.Sessions().UserID))
                    {
                        retAns.Add(string.Empty);
                    }
                    else
                    {
                        retAns.Add(objSaveModel.ErrorMsg);
                    }
                }
                else
                {
                    (new LogInModel()).SaveLogInTrial(oUser.Email, false, HttpContext.Request.UserHostAddress, HttpContext.Request.UserHostName);
                    retAns.Add(StaticClass.CsResources("InvalidLogIn"));
                }
            }
            else
            {
                retAns.Add("NBT");
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NoPhoto()
        {
            return ResponseDotFile(string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult NoFile()
        {
            return ResponseDotFile(string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_FILE_ICON));
        }

        # endregion
    }
}
