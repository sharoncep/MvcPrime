using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
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
using ClaimatePrimeModels.SecuredFolder.Extensions;

namespace ClaimatePrimeControllers.Controllers
{
    public class Visit_CRController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Visit_CRController()
        {
        }

        # endregion

        #region Search

        /// <summary>
        /// 
        /// </summary>
        ///<returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Search()
        {
            if (!(IsPatSessReq))
            {
                ArivaSession.Sessions().SetPatient(0, string.Empty);
            }
           

            ArivaSession.Sessions().PageEditID<global::System.Int64>(0);

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

            PatientVisitSearchModel objSearchModel = new PatientVisitSearchModel() { PatientID = ArivaSession.Sessions().SelPatientID };
            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSearchModel.userID = ArivaSession.Sessions().UserID;

            if (IsPatSessReq)
            {
                objSearchModel.FillIsActive();
            }

            if (val1 < 26)
            {
                objSearchModel.StartBy = StaticClass.AtoZ[val1];
            }

            objSearchModel.Fill(IsActive(true));
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
        public ActionResult Search(PatientVisitSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                if (ArivaSession.Sessions().SelPatientID == 0)
                {
                    return ResponseDotRedirect("Visit", "Display");
                }
                else
                {
                    return ResponseDotRedirect("PatVisit", "Display");
                }
            }

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSearchModel.FillCs(IsActive(true));

            return ResponseDotRedirect(objSearchModel);
        }

        #endregion

        # region Save

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult Save()
        {
            if (!(IsPatSessReq))
            {
                ArivaSession.Sessions().SetPatient(0, string.Empty);
            }

            if (ArivaSession.Sessions().SelPatientID > 0)
            {
                VisitChartModel objChartModel = new VisitChartModel();
                objChartModel.PatientID = ArivaSession.Sessions().SelPatientID;
                objChartModel.Patient = ArivaSession.Sessions().SelPatientDispName;
                objChartModel.Fill(IsActive());
                return ResponseDotRedirect(objChartModel);
            }

            VisitsChartModel objChartsModel = new VisitsChartModel();
            objChartsModel.Fill(IsActive());

            return ResponseDotRedirect(objChartsModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objChartsModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(VisitsChartModel objChartsModel)
        {
            string startBy;
            objChartsModel.GetPatVisitComplexity(ArivaSession.Sessions().SelClinicID);
            objChartsModel.CommentForNew = string.Concat("Sys Gen : ", StaticClass.CsResources("VisitNewCmts"));
            objChartsModel.CommentForBAGenQ = "Sys Gen : BA_GENERAL_QUEUE";

            objChartsModel.ClinicID = ArivaSession.Sessions().SelClinicID;

            if (objChartsModel.Save(ArivaSession.Sessions().UserID, out startBy))
            {
                return ResponseDotRedirect("Visit", "Search", startBy, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objChartsModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objChartModel"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnPatNext")]
        public ActionResult Save(VisitChartModel objChartModel)
        {
            objChartModel.GetPatVisitComplexity(ArivaSession.Sessions().SelClinicID);
            objChartModel.CommentForNew = string.Concat("Sys Gen : ", StaticClass.CsResources("VisitNewCmts"));
            objChartModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objChartModel.CommentForBAGenQ = "Sys Gen : BA_GENERAL_QUEUE";

            if (objChartModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("PatVisit", "Search", ArivaSession.Sessions().SelPatientDispName.Substring(0, 1), 1);
            }

            ViewBagDotErrMsg = 1;
            if (ArivaSession.Sessions().SelPatientID > 0)
            {
                objChartModel.PatientID = ArivaSession.Sessions().SelPatientID;
                objChartModel.Patient = ArivaSession.Sessions().SelPatientDispName;
                objChartModel.Fill(IsActive());
                return ResponseDotRedirect(objChartModel);
            }
            return ResponseDotRedirect(objChartModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult SavePatVisit()
        {
            PatientVisitSaveModel objSaveModel = new PatientVisitSaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

            return ResponseDotRedirect(objSaveModel);
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
            ArivaSession.Sessions().SetPatient(spRes.PatientID, spRes.NAME_CODE);

            AssignedClaimSaveModel objSaveModel = new AssignedClaimSaveModel();
            objSaveModel.Fill(IsActive());

            return ResponseDotRedirect(objSaveModel);
        }

        #endregion

        # region SearchAjaxCall

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSearchName"></param>
        /// <param name="pStartBy"></param>
        /// <param name="pOrderByField"></param>
        /// <param name="pOrderByDirection"></param>
        /// <param name="pCurrPageNumber"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCall(string pSearchName, string pDateFrom, string pDateTo, string pStartBy, string pOrderByField, string pOrderByDirection, string pCurrPageNumber)
        {
            PatientVisitSearchModel objSearchModel = new PatientVisitSearchModel() { SearchName = pSearchName, DateFrom = Converts.AsDateTimeNullable(pDateFrom), DateTo = Converts.AsDateTimeNullable(pDateTo), StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField, ClinicID = ArivaSession.Sessions().SelClinicID };

            if (ArivaSession.Sessions().SelPatientID > 0)
            {
                objSearchModel.PatientID = ArivaSession.Sessions().SelPatientID;
            }

            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_PatientVisit_Result item in objSearchModel.PatientVisit)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallVisit()
        {
            PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
            objVisit.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

            List<VisitResult> retVisit = new List<VisitResult>();
            retVisit.Add((VisitResult)objVisit);

            return new JsonResultExtension { Data = retVisit };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallDx(string pKy)
        {
            PrimeClaimDiagnosisSaveModel objSaveModel = new PrimeClaimDiagnosisSaveModel();
            objSaveModel.pDescType = pKy;
            List<SearchResult> retDx = new List<SearchResult>();

            objSaveModel.fillBlockedDx(ArivaSession.Sessions().PageEditID<long>(), IsActive(false));

            foreach (usp_GetNameByID_ClaimDiagnosis_Result item in objSaveModel.BlockedDx)
            {
                retDx.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retDx };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchAjaxCallCpt(string pKy)
        {
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { pDescType = pKy };

            List<ProcedureResult> retPro = new List<ProcedureResult>();

            objSaveModel.fillBlockedCPT(ArivaSession.Sessions().PageEditID<long>(), IsActive(false));

            foreach (usp_GetBlockedCpt_ClaimDiagnosisCPT_Result item in objSaveModel.BlockedCPTResult)
            {
                retPro.Add((ProcedureResult)item);
            }

            return new JsonResultExtension { Data = retPro };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pClaimDiagnosisID"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UnblockDxAjaxCall(string pClaimDiagnosisID)
        {
            List<string> retAns = new List<string>();

            ClaimDiagnosisSaveModel objSaveModel = new ClaimDiagnosisSaveModel();
            objSaveModel.Fill(Converts.AsInt64(pClaimDiagnosisID), IsActive(false));

            if (objSaveModel.UnBlockDx(ArivaSession.Sessions().UserID))
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
        /// <param name="pClaimDiagnosisID"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UnblockCptAjaxCall(string pClaimCPTID)
        {
            List<string> retAns = new List<string>();

            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel();
            objSaveModel.Fill(Converts.AsInt64(pClaimCPTID), IsActive(false));

            if (objSaveModel.UnBlockCpt(ArivaSession.Sessions().UserID))
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
        /// <param name="pClaimDiagnosisID"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UnblockVisitAjaxCall(string pID)
        {
            List<string> retAns = new List<string>();

            PatientVisitSaveModel objSaveModel = new PatientVisitSaveModel();
            objSaveModel.Fill(Converts.AsInt64(pID), IsActive(false));
            objSaveModel.CommentForUnblock = "Sys Gen : Unblocked";

            if (objSaveModel.UnBlockVisit(ArivaSession.Sessions().UserID))
            {
                retAns.Add(string.Empty);
            }
            else
            {
                retAns.Add(objSaveModel.ErrorMsg);
            }

            return new JsonResultExtension { Data = retAns };
        }

        # endregion

        #region SaveAjaxCall
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCall(string pKy)
        {
            string filePath = string.Empty;

            #region Visit

            if (string.Compare(pKy, "Visit", true) == 0)
            {
                PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
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
                PatientVisitSaveModel objVisit = new PatientVisitSaveModel();
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
                objPatDocModel.Fill(ArivaSession.Sessions().SelPatientID, IsActive());

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
                objPatient.Fill(ArivaSession.Sessions().SelPatientID, IsActive());

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
                objEDI.Fill(ArivaSession.Sessions().SelPatientID, IsActive());

                List<EDISettingsResult> retEDI = new List<EDISettingsResult>();
                retEDI.Add((EDISettingsResult)objEDI);

                return new JsonResultExtension { Data = retEDI };
            }

            #endregion

            #region Ipa

            if (string.Compare(pKy, "Ipa", true) == 0)
            {
                BillingIPAModel objIpa = new BillingIPAModel();
                objIpa.Fill(ArivaSession.Sessions().SelClinicID, IsActive());

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
                objClinic.Fill(ArivaSession.Sessions().SelClinicID, IsActive());

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
                objProvider.Fill(ArivaSession.Sessions().SelPatientID, IsActive());
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
                objInsurance.Fill(ArivaSession.Sessions().SelPatientID, IsActive());

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
            PreviousVisitViewModel objSaveModel = new PreviousVisitViewModel() { CurrDOS = Converts.AsDateTime(pKy), PatientVisitID = ArivaSession.Sessions().PageEditID<long>() };

            List<PrevVisitResult> retPrevVisit = new List<PrevVisitResult>();


            objSaveModel.Fill(ArivaSession.Sessions().SelPatientID, IsActive());

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


        #endregion

        #region UnBlock

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult UnBlock()
        {
            return ResponseDotRedirect();
        }

        # endregion

    }
}
