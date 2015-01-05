using System;
using System.Collections.Generic;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.AjaxCalls.AsgnClaims;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public class SummaryAgent_RController : BaseController
    {
        static string DESC;
        static string DAY_COUNT;
        static string USER_ID;


        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryAgent_RController()
        {
        }

        # endregion

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

            if (val1 == 1)
            {
                // Change Pwd Alert Verification Function required here

                ViewBagDotErrMsg = 1;
            }

            # endregion

            AgentWiseSummaryModel objSearchModel = new AgentWiseSummaryModel() { UserID = ArivaSession.Sessions().UserID, UserHighRole = ArivaSession.Sessions().HighRoleID };
            objSearchModel.FillCs(IsActive());

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
        public ActionResult Search(AgentWiseSummaryModel objSearchModel)
        {
            objSearchModel.UserID = ArivaSession.Sessions().UserID;
            objSearchModel.UserHighRole = ArivaSession.Sessions().HighRoleID;
            objSearchModel.FillCs(IsActive());
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
            ArivaSession.Sessions().SetClinic(0, string.Empty);
            ArivaSession.Sessions().PageEditID<global::System.Byte>(0);

            DESC = Request.QueryString["desc"];
            DAY_COUNT = Request.QueryString["dayCount"];
            USER_ID = Request.QueryString["pUserID"];

            AgentWiseSummaryViewModel objSearchModel = new AgentWiseSummaryViewModel();
            //objSearchModel.Fill(IsActive());
            return ResponseDotRedirect(objSearchModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSearchModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSearch")]
        public ActionResult Save(AgentWiseSummaryViewModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().SetClinic(0, string.Empty);

                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("SummaryAgent", "Display");
            }
            return ResponseDotRedirect(objSearchModel);
        }
        #endregion

        #region Display

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Display()
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());

            PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
            objVisit.SelClinicDispName = spRes.CLINIC_NAME_CODE;

            AssignedClaimSaveModel objSaveModel = new AssignedClaimSaveModel();
            objSaveModel.Fill(IsActive());

            return ResponseDotRedirect(objSaveModel);
        }

        #endregion

        #region SaveAjaxCall
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCall(string pKy)
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());
            string filePath = string.Empty;
            PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
            objVisit.SelClinicDispName = spRes.CLINIC_NAME_CODE;

            #region Visit

            if (string.Compare(pKy, "Visit", true) == 0)
            {
                objVisit.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                # region Doc Note

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objVisit.PatientVisitResult.DoctorNoteRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_DOCTOR_NOTE);
                }
                System.IO.File.Copy(filePath, string.Concat(StaticClass.AppRootPath, @"\ReportTmp\DN", ArivaSession.Sessions().UserID, ".pdf"), true);
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                # region Super Bill

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objVisit.PatientVisitResult.SuperBillRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_SUPER_BILL);
                }
                System.IO.File.Copy(filePath, string.Concat(StaticClass.AppRootPath, @"\ReportTmp\SB", ArivaSession.Sessions().UserID, ".pdf"), true);
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<VisitResult> retVisit = new List<VisitResult>();
                retVisit.Add((VisitResult)objVisit);

                return new JsonResultExtension { Data = retVisit };
            }

            #endregion

            #region PrimaryDx

            if (string.Compare(pKy, "Dxprimary", true) == 0)
            {

                objVisit.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                List<VisitResult> retVisit = new List<VisitResult>();
                retVisit.Add((VisitResult)objVisit);

                return new JsonResultExtension { Data = retVisit };
            }

            #endregion

            #region CPT

            if (string.Compare(pKy, "CPT", true) == 0)
            {
                ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { };

                List<ProcedureResult> retPro = new List<ProcedureResult>();

                objSaveModel.fillCPTBA(ArivaSession.Sessions().PageEditID<long>());

                foreach (usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResultBA)
                {
                    retPro.Add((ProcedureResult)item);
                }

                return new JsonResultExtension { Data = retPro };
            }

            #endregion

            #region Notes

            if (string.Compare(pKy, "Notes", true) == 0)
            {
                ClaimProcessNoteModel objNoteModel = new ClaimProcessNoteModel();
                List<NoteResult> retNotes = new List<NoteResult>();
                objNoteModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                foreach (usp_GetCommentByID_ClaimProcess_Result item in objNoteModel.Comments)
                {
                    retNotes.Add((NoteResult)item);
                }
                return new JsonResultExtension { Data = retNotes };

            }

            #endregion

            #region Pat Docs

            if (string.Compare(pKy, "PatientDoc", true) == 0)
            {
                PatientDocumentViewModel objPatDocModel = new PatientDocumentViewModel();
                List<PatDocResult> retPatDoc = new List<PatDocResult>();
                objPatDocModel.Fill(spRes.PatientID, IsActive());

                foreach (usp_GetByPatientID_PatientDocument_Result item in objPatDocModel.PatDocumentResult)
                {
                    # region Photo

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.DocumentRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientDocumentID_", item.PatientDocumentID), filePath);

                    # endregion

                    retPatDoc.Add((PatDocResult)item);
                }
                return new JsonResultExtension { Data = retPatDoc };

            }

            #endregion

            #region Patient

            if (string.Compare(pKy, "Patient", true) == 0)
            {
                PatientDemographySaveModel objPatient = new PatientDemographySaveModel();
                objPatient.Fill(spRes.PatientID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objPatient.PatientResult.PhotoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<PatientResult> retPatient = new List<PatientResult>();
                retPatient.Add((PatientResult)objPatient);

                return new JsonResultExtension { Data = retPatient };
            }

            #endregion

            #region Claim Status

            if (string.Compare(pKy, "Claim", true) == 0)
            {
                ClaimProcessStatusModel objStatusModel = new ClaimProcessStatusModel();
                List<StatusResult> retStatus = new List<StatusResult>();
                objStatusModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

                foreach (usp_GetByPatientVisitID_ClaimProcess_Result item in objStatusModel.pClaimProcess)
                {
                    # region RefFile

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.RefFileRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("RefFileID_", item.ClaimProcessEDIFileID), filePath);

                    # endregion

                    # region X12File

                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.X12FileRelPath);
                    if (!(System.IO.File.Exists(filePath)))
                    {
                        filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                    }
                    ArivaSession.Sessions().FilePathsDotAdd(string.Concat("X12FileID_", item.ClaimProcessEDIFileID), filePath);

                    # endregion

                    retStatus.Add((StatusResult)item);
                }
                return new JsonResultExtension { Data = retStatus };

            }

            #endregion

            #region EDI SETTINGS

            if (string.Compare(pKy, "Settings", true) == 0)
            {
                EDISettingsModel objEDI = new EDISettingsModel();
                objEDI.Fill(spRes.PatientID, IsActive());

                List<EDISettingsResult> retEDI = new List<EDISettingsResult>();
                retEDI.Add((EDISettingsResult)objEDI);

                return new JsonResultExtension { Data = retEDI };
            }

            #endregion

            #region Ipa

            if (string.Compare(pKy, "Ipa", true) == 0)
            {
                BillingIPAModel objIpa = new BillingIPAModel();
                objIpa.Fill(spRes.CLINIC_ID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objIpa.IPA_Result.LogoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<IpaResult> retIpa = new List<IpaResult>();
                retIpa.Add((IpaResult)objIpa);

                return new JsonResultExtension { Data = retIpa };
            }

            #endregion

            #region Practice/Clinic

            if (string.Compare(pKy, "Clinic", true) == 0)
            {
                BillingClinicViewModel objClinic = new BillingClinicViewModel();
                objClinic.Fill(spRes.CLINIC_ID, IsActive());

                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objClinic.ClinicResult.LogoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<ClinicResult> retClinic = new List<ClinicResult>();
                retClinic.Add((ClinicResult)objClinic);

                return new JsonResultExtension { Data = retClinic };
            }

            #endregion

            #region Provider
            if (string.Compare(pKy, "Provider", true) == 0)
            {
                ClaimProviderModel objProvider = new ClaimProviderModel();
                objProvider.Fill(spRes.PatientID, IsActive());
                # region Photo

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", objProvider.Provider_Result.PhotoRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_PHOTO_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>()), filePath);

                # endregion

                List<ProviderResult> retProvider = new List<ProviderResult>();
                retProvider.Add((ProviderResult)objProvider);

                return new JsonResultExtension { Data = retProvider };
            }
            #endregion

            #region Insurance
            if (string.Compare(pKy, "Insurance", true) == 0)
            {
                ClaimInsuranceModel objInsurance = new ClaimInsuranceModel();
                objInsurance.Fill(spRes.PatientID, IsActive());

                List<InsuranceResult> retInsurance = new List<InsuranceResult>();
                retInsurance.Add((InsuranceResult)objInsurance);

                return new JsonResultExtension { Data = retInsurance };
            }
            #endregion

            List<string> retAns = new List<string>();
            retAns.Add(string.Concat("Ajax Call Done: SaveAjaxCall: ", pKy));



            return new JsonResultExtension { Data = retAns };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallCpt(string pKy)
        {
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { pDescType = pKy };

            List<ProcedureResult> retPro = new List<ProcedureResult>();

            objSaveModel.fillCPTBA(ArivaSession.Sessions().PageEditID<long>());

            foreach (usp_GetByPatVisitDx_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResultBA)
            {
                retPro.Add((ProcedureResult)item);
            }

            return new JsonResultExtension { Data = retPro };
        }


        #region DX
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallDx(string pKy)
        {
            ClaimDiagnosisSaveModel objSaveModel = new ClaimDiagnosisSaveModel();

            List<DxResult> retDx = new List<DxResult>();

            objSaveModel.FillClaimDiagnosis(ArivaSession.Sessions().PageEditID<long>(), pKy);

            foreach (usp_GetByPatientVisit_ClaimDiagnosis_Result item in objSaveModel.ClaimDiagnosisResults)
            {
                retDx.Add((DxResult)item);
            }

            return new JsonResultExtension { Data = retDx };
        }
        #endregion
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallFacilityDone(string pKy)
        {
            FacilityDoneViewModel objSaveModel = new FacilityDoneViewModel();


            objSaveModel.Fill(Converts.AsInt32(pKy), IsActive(true));
            List<FacilityDoneResult> retFacility = new List<FacilityDoneResult>();

            retFacility.Add((FacilityDoneResult)objSaveModel);

            return new JsonResultExtension { Data = retFacility };

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallPrevVisits(string pKy)
        {
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());

            PreviousVisitViewModel objSaveModel = new PreviousVisitViewModel() { CurrDOS = Converts.AsDateTime(pKy), PatientVisitID = ArivaSession.Sessions().PageEditID<long>() };

            List<PrevVisitResult> retPrevVisit = new List<PrevVisitResult>();


            objSaveModel.Fill(spRes.PatientID, IsActive());

            foreach (usp_GetPrevVisit_PatientVisit_Result item in objSaveModel.AllDOSResult)
            {
                retPrevVisit.Add((PrevVisitResult)item);
            }

            return new JsonResultExtension { Data = retPrevVisit };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult GetPrevVisitsDetails(string pKy)
        {
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel();

            List<ProcedureResult> retPro = new List<ProcedureResult>();


            objSaveModel.fillCPT(Converts.AsInt64(pKy));

            foreach (usp_GetByPatientVisit_ClaimDiagnosisCPT_Result item in objSaveModel.ClaimCPTResult)
            {
                retPro.Add((ProcedureResult)item);
            }

            return new JsonResultExtension { Data = retPro };
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallPrevStatus(string pKy)
        {
            string filePath = string.Empty;

            ClaimProcessStatusModel objStatusModel = new ClaimProcessStatusModel();
            List<StatusResult> retPrevStatus = new List<StatusResult>();
            objStatusModel.GetPrevStatus(Converts.AsInt64(pKy));

            foreach (usp_GetByPatientVisitID_ClaimProcess_Result item in objStatusModel.pClaimProcess)
            {
                # region RefFile

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.RefFileRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    item.RefFileRelPath = string.Empty;
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("RefFileID_", item.ClaimProcessEDIFileID), filePath);

                # endregion

                # region X12File

                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", item.X12FileRelPath);
                if (!(System.IO.File.Exists(filePath)))
                {
                    item.X12FileRelPath = string.Empty;
                    filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
                }
                ArivaSession.Sessions().FilePathsDotAdd(string.Concat("X12FileID_", item.ClaimProcessEDIFileID), filePath);

                # endregion

                retPrevStatus.Add((StatusResult)item);
            }
            return new JsonResultExtension { Data = retPrevStatus };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveDrNote()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveDrNotePreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveSupBill()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveSupBillPreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveX12File()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("X12FileID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveRefFile()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("RefFileID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveIPALogo()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("IPAID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveClinicLogo()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ClinicID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveProviderPhoto()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("ProviderID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatDoc()
        {
            return ResponseDotFile(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatDocPreview()
        {
            return ResponseDotFilePreview(ArivaSession.Sessions().FilePathsDotValue(string.Concat("PatientDocumentID_", Request.QueryString["ky"])));
        }

        #endregion

        #region SearchAjaxCalls

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pStartBy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pStartBy)
        {
            long pageNo = 0;
            short rec = 0;

            List<AgentWiseResult> retAns = new List<AgentWiseResult>();
            AgentWiseSummaryModel objSearchModel = new AgentWiseSummaryModel() { StartBy = pStartBy, UserID = ArivaSession.Sessions().UserID, UserHighRole = ArivaSession.Sessions().HighRoleID };
            objSearchModel.FillJs(pageNo, IsActive(true), rec);

            foreach (usp_GetDashboardAgent_User_Result item in objSearchModel.AgentList)
            {
                retAns.Add((AgentWiseResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallTableCount(string pUserID)
        {
            AgentWiseSummaryModel objDash = new AgentWiseSummaryModel();

            List<AgentWiseResult> retDash = new List<AgentWiseResult>();

            objDash.GetAgentTableCount(Converts.AsInt32(pUserID));

            foreach (usp_GetAgentWiseSummary_PatientVisit_Result item in objDash.TableCount)
            {
                retDash.Add((AgentWiseResult)item);
            }

            return new JsonResultExtension { Data = retDash };

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallTotTableCount(string pUserID)
        {
            AgentWiseSummaryModel objDash = new AgentWiseSummaryModel();
            List<SearchResult> retDash = new List<SearchResult>();

            objDash.GetTotalCount(Converts.AsInt32(pUserID));

            retDash.Add((SearchResult)objDash.TotalCount);

            return new JsonResultExtension { Data = retDash };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pDateFrom"></param>
        /// <param name="pDateTo"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchListAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            AgentWiseSummaryViewModel objSearchModel = new AgentWiseSummaryViewModel()
            {
                UserID = Converts.AsInt32(USER_ID)
                ,
                DayCount = DAY_COUNT
                ,
                Desc = DESC
                ,
                SearchName = pSearchName
                ,
                DateFrom = Converts.AsDateTimeNullable(pDateFrom)
                ,
                DateTo = Converts.AsDateTimeNullable(pDateTo)
                ,
                StartBy = pStartBy
                ,
                OrderByDirection = pOrderByDirection
                ,
                OrderByField = pOrderByField
            };

            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), true, StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetAgentWiseVisit_PatientVisit_Result item in objSearchModel.AgentWiseVisit)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };

        }

        #endregion

        # region SavePdf

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePdf()
        {

            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];
            string userID = Request.QueryString["pUserID"];

            AgentWiseSummaryViewModel objSearchModel = new AgentWiseSummaryViewModel();
            objSearchModel.FillPdfVisit(Converts.AsInt32(userID), dayCount, desc);
            return ResponseDotBinary("pdf", desc + " - " + dayCount, "SavePdf", objSearchModel);
        }

        # endregion

        # region SaveExcel

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SaveExcel()
        {

            string desc = Request.QueryString["desc"];
            string dayCount = Request.QueryString["dayCount"];
            string userID = Request.QueryString["pUserID"];
            ExcelSheetColDash objEx = new ExcelSheetColDash();

            string xlsxPath = objEx.GetXlsxPath(ArivaSession.Sessions().UserID, StaticClass.FileSvrRptRootPath);

            objEx.FillDashboard((DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff)), StaticClass.CsResources("RptExlSubjAgentWise").Replace("[X]", desc.ToUpper()), StaticClass.GetDateStr(), StaticClass.GetTimeStr(), StaticClass.GetDateTimeStr(), ArivaSession.Sessions().UserDispName);
            ExcelFileDash.Create(xlsxPath, objEx, ExcelReportModel.GetDataAgentWise(Converts.AsInt32(userID), desc, dayCount));

            return ResponseDotFile(xlsxPath);
        }

        # endregion
    }
}
