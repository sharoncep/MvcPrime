using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.BaseControllers;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using System.Web;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using System.IO;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.AjaxCalls;
using ClaimatePrimeControllers.AjaxCalls.AsgnClaims;

namespace ClaimatePrimeControllers.Controllers
{
    public class AssgnClaimsNITB_URController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AssgnClaimsNITB_URController()
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
            ArivaSession.Sessions().SetPatient(0, string.Empty);
            ArivaSession.Sessions().PageEditID<long>(0);

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

            AssignedClaimSearchModel objSearchModel = new AssignedClaimSearchModel() { ClinicID = ArivaSession.Sessions().SelClinicID, AssignedTo = ArivaSession.Sessions().UserID, StatusIDs = string.Concat(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK)) };
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
        public ActionResult Search(AssignedClaimSearchModel objSearchModel)
        {
            if (objSearchModel.CurrNumber > 0)
            {
                ArivaSession.Sessions().PageEditID<global::System.Int64>(objSearchModel.CurrNumber);

                return ResponseDotRedirect("AssgnClaimsNITB", "Save");
            }

            objSearchModel.ClinicID = ArivaSession.Sessions().SelClinicID;
            objSearchModel.AssignedTo = ArivaSession.Sessions().UserID;
            objSearchModel.StatusIDs = string.Concat(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK));
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
            usp_GetNameByPatientVisitID_Patient_Result spRes = (new PatientVisitSearchModel() { CurrNumber = ArivaSession.Sessions().PageEditID<long>() }).GetChartByID(IsActive());
            ArivaSession.Sessions().SetPatient(spRes.PatientID, spRes.NAME_CODE);

            AssignedClaimSaveModel objSaveModel = new AssignedClaimSaveModel();
            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());

            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <param name="filUploadDocNote"></param>
        /// <param name="filUploadSuperBill"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnSave")]
        public ActionResult Save(AssignedClaimSaveModel objSaveModel, HttpPostedFileBase filUploadDocNote, HttpPostedFileBase filUploadSuperBill)
        {
            objSaveModel.PatientVisit.PatientVisitResult.PatientID = ArivaSession.Sessions().SelPatientID;
            objSaveModel.PatientVisit.PatientVisitResult.AssignedTo = objSaveModel.PatientVisit.PatientVisitResult.TargetQAUserID;
            objSaveModel.PatientVisit.PatientVisitResult.PatientVisitID = ArivaSession.Sessions().PageEditID<long>();

            objSaveModel.CommentForCreated = "Sys Gen : CREATED_CLAIM";
            objSaveModel.CommentForQAGenQ = "Sys Gen : QA_GENERAL_QUEUE";

            if (!(objSaveModel.HasProcedure()))
            {
                objSaveModel.SaveTemp(ArivaSession.Sessions().UserID);
                ViewBagDotErrMsg = 4;
                return ResponseDotRedirect(objSaveModel);
            }

            if (
                ((filUploadDocNote == null) && (filUploadSuperBill == null)) &&
                (objSaveModel.PatientVisit.IsAttachmentMandatory(ArivaSession.Sessions().SelClinicID)) &&
                ((string.Compare(ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())), string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_DOCTOR_NOTE), true) == 0)
                    && (string.Compare(ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())), string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_SUPER_BILL), true) == 0))
                )
            {
                //objSaveModel.PatientVisit.PatientVisitResult.PatientVisitID = ArivaSession.Sessions().PageEditID<long>();

                objSaveModel.SaveTemp(ArivaSession.Sessions().UserID);

                ViewBagDotErrMsg = 3;
                return ResponseDotRedirect(objSaveModel);
            }

            #region DoctorNote save

            if (filUploadDocNote == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadDocNote.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrDoctorNotePath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrDoctorNotePath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrDoctorNotePath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "U_", filsCnt, Path.GetExtension(filUploadDocNote.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.FileSvrDoctorNotePath;
                filUploadDocNote.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;
            }

            #endregion

            #region SuperBill save

            if (filUploadSuperBill == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadSuperBill.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;

                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrSuperBillPath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrSuperBillPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrSuperBillPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "U_", filsCnt, Path.GetExtension(filUploadSuperBill.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.FileSvrSuperBillPath;
                filUploadSuperBill.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;
            }

            #endregion

            if (objSaveModel.Save(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("UnassgnClaimsNITB", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <param name="filUploadDocNote"></param>
        /// <param name="filUploadSuperBill"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnHold")]
        public ActionResult SaveHold(AssignedClaimSaveModel objSaveModel, HttpPostedFileBase filUploadDocNote, HttpPostedFileBase filUploadSuperBill)
        {

            //objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());
            objSaveModel.PatientVisit.PatientVisitResult.PatientID = ArivaSession.Sessions().SelPatientID;
            objSaveModel.PatientVisit.PatientVisitResult.AssignedTo = ArivaSession.Sessions().UserID;
            objSaveModel.PatientVisit.PatientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.HOLD_CLAIM);
            objSaveModel.PatientVisit.PatientVisitResult.PatientVisitID = ArivaSession.Sessions().PageEditID<long>();

            objSaveModel.CommentForHolded = "Sys Gen : BA_HOLDED";
            objSaveModel.CommentForUnhold = "Sys Gen : UNHOLD_CLAIM";

            #region DoctorNote save

            if (filUploadDocNote == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadDocNote.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrDoctorNotePath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrDoctorNotePath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrDoctorNotePath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "U_", filsCnt, Path.GetExtension(filUploadDocNote.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.FileSvrDoctorNotePath;
                filUploadDocNote.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;
            }

            #endregion

            #region SuperBill save

            if (filUploadSuperBill == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadSuperBill.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;

                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrSuperBillPath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrSuperBillPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrSuperBillPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "U_", filsCnt, Path.GetExtension(filUploadSuperBill.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.FileSvrSuperBillPath;
                filUploadSuperBill.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;
            }

            #endregion

            if (objSaveModel.SaveHoldUnHold(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("AssgnClaimsNITB", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <param name="filUploadDocNote"></param>
        /// <param name="filUploadSuperBill"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnUnhold")]
        public ActionResult SaveUnHold(AssignedClaimSaveModel objSaveModel, HttpPostedFileBase filUploadDocNote, HttpPostedFileBase filUploadSuperBill)
        {
            //objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());
            objSaveModel.PatientVisit.PatientVisitResult.PatientID = ArivaSession.Sessions().SelPatientID;
            objSaveModel.PatientVisit.PatientVisitResult.AssignedTo = ArivaSession.Sessions().UserID;
            objSaveModel.PatientVisit.PatientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.UNHOLD_CLAIM);
            objSaveModel.PatientVisit.PatientVisitResult.PatientVisitID = ArivaSession.Sessions().PageEditID<long>();

            objSaveModel.CommentForHolded = "Sys Gen : BA_HOLDED";
            objSaveModel.CommentForUnhold = "Sys Gen : UNHOLD_CLAIM";

            #region DoctorNote save

            if (filUploadDocNote == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadDocNote.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrDoctorNotePath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrDoctorNotePath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrDoctorNotePath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "U_", filsCnt, Path.GetExtension(filUploadDocNote.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.FileSvrDoctorNotePath;
                filUploadDocNote.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;
            }

            #endregion

            #region SuperBill save

            if (filUploadSuperBill == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadSuperBill.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;

                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrSuperBillPath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrSuperBillPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrSuperBillPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "U_", filsCnt, Path.GetExtension(filUploadSuperBill.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.FileSvrSuperBillPath;
                filUploadSuperBill.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;
            }

            #endregion

            if (objSaveModel.SaveHoldUnHold(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("AssgnClaimsNITB", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="objSaveModel"></param>
        /// <param name="filUploadDocNote"></param>
        /// <param name="filUploadSuperBill"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        [ActionName("Save")]
        [AcceptParameter(ButtonName = "btnBlock")]
        public ActionResult SaveBlock(AssignedClaimSaveModel objSaveModel, HttpPostedFileBase filUploadDocNote, HttpPostedFileBase filUploadSuperBill)
        {
            //objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive());
            objSaveModel.PatientVisit.PatientVisitResult.PatientID = ArivaSession.Sessions().SelPatientID;
            //objSaveModel.PatientVisit.PatientVisitResult.AssignedTo = ArivaSession.Sessions().UserID;
            //objSaveModel.PatientVisit.PatientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.UNHOLD_CLAIM);
            objSaveModel.PatientVisit.PatientVisitResult.PatientVisitID = ArivaSession.Sessions().PageEditID<long>();
            //objSaveModel.UserComment = StaticClass.CsResources("VisitUnholdCmts");

            #region DoctorNote save

            if (filUploadDocNote == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("DocNoteID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadDocNote.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrDoctorNotePath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrDoctorNotePath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrDoctorNotePath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrDoctorNotePath = string.Concat(objSaveModel.PatientVisit.FileSvrDoctorNotePath, @"\", "U_", filsCnt, Path.GetExtension(filUploadDocNote.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.FileSvrDoctorNotePath;
                filUploadDocNote.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath = objSaveModel.PatientVisit.PatientVisitResult.DoctorNoteRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrDoctorNotePath = StaticClass.FileSvrDrNotePath;
            }

            #endregion

            #region SuperBill save

            if (filUploadSuperBill == null)
            {
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = ArivaSession.Sessions().FilePathsDotValue(string.Concat("SupBillID_", ArivaSession.Sessions().PageEditID<global::System.Int64>())).Replace(string.Concat(StaticClass.FileSvrRootPath, @"\"), string.Empty);
            }
            else
            {
                if ((StaticClass.ConfigurationGeneral.mUploadMaxSizeInMBID * 1024 * 1024) < filUploadSuperBill.ContentLength)
                {
                    ViewBagDotErrMsg = 2;
                    return ResponseDotRedirect(objSaveModel);
                }

                objSaveModel.PatientVisit.FileSvrRootPath = StaticClass.FileSvrRootPath;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;

                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "P_", objSaveModel.PatientVisit.ObjParam("PatientVisit").Value);
                if (!(Directory.Exists(objSaveModel.PatientVisit.FileSvrSuperBillPath)))
                {
                    Directory.CreateDirectory(objSaveModel.PatientVisit.FileSvrSuperBillPath);
                }

                int filsCnt = (new List<string>(Directory.GetFiles(objSaveModel.PatientVisit.FileSvrSuperBillPath, "*.*", SearchOption.TopDirectoryOnly))).Count;
                filsCnt++;
                objSaveModel.PatientVisit.FileSvrSuperBillPath = string.Concat(objSaveModel.PatientVisit.FileSvrSuperBillPath, @"\", "U_", filsCnt, Path.GetExtension(filUploadSuperBill.FileName));
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.FileSvrSuperBillPath;
                filUploadSuperBill.SaveAs(objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Replace(objSaveModel.PatientVisit.FileSvrRootPath, string.Empty);
                objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath = objSaveModel.PatientVisit.PatientVisitResult.SuperBillRelPath.Substring(1);

                objSaveModel.PatientVisit.FileSvrSuperBillPath = StaticClass.FileSvrSupBillPath;
            }

            #endregion

            if (objSaveModel.SaveBlock(ArivaSession.Sessions().UserID))
            {
                return ResponseDotRedirect("UnassgnClaimsNITB", "Search", 0, 1);
            }

            ViewBagDotErrMsg = 1;
            return ResponseDotRedirect(objSaveModel);
        }
        #endregion

        #region UnBlockVisit
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult UnBlockVisit()
        {
            return ResponseDotRedirect();
        }


        #endregion

        #region ViewVisit

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult ViewVisit()
        {
            return ResponseDotRedirect();
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
            AssignedClaimSearchModel objSearchModel = new AssignedClaimSearchModel() { SearchName = pSearchName, DateFrom = Converts.AsDateTimeNullable(pDateFrom), DateTo = Converts.AsDateTimeNullable(pDateTo), StartBy = pStartBy, OrderByDirection = pOrderByDirection, OrderByField = pOrderByField, ClinicID = ArivaSession.Sessions().SelClinicID, AssignedTo = ArivaSession.Sessions().UserID, StatusIDs = string.Concat(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK)) };
            objSearchModel.FillJs(Converts.AsInt64(pCurrPageNumber), IsActive(), StaticClass.ConfigurationGeneral.mSearchRecordPerPageID);

            List<SearchResult> retAns = new List<SearchResult>();
            foreach (usp_GetBySearch_ClaimProcess_Result item in objSearchModel.Claims)
            {
                retAns.Add((SearchResult)item);
            }

            return new JsonResultExtension { Data = retAns };

        }


        # endregion

        # region SaveAjaxCall

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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveAjaxCallDxprimary(string pKy)
        {
            PrimeClaimDiagnosisSaveModel objSaveModel = new PrimeClaimDiagnosisSaveModel();
            objSaveModel.pDescType = pKy;
            List<SearchResult> retDx = new List<SearchResult>();

            objSaveModel.Fill(ArivaSession.Sessions().PageEditID<long>(), IsActive(true));

            foreach (usp_GetPrimeDxByID_PatientVisit_Result item in objSaveModel.PrimeDx)
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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveDxAjaxCall(string pDiagnosisID)
        {
            List<string> retAns = new List<string>();

            ClaimDiagnosisSaveModel objSaveModel = new ClaimDiagnosisSaveModel() { PatientVisitID = ArivaSession.Sessions().PageEditID<long>(), DiagnosisID = Converts.AsInt32(pDiagnosisID) };

            if (objSaveModel.InsertClaimDiagnosis(ArivaSession.Sessions().UserID))
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
        /// <param name="pKy"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RemoveDxAjaxCall(string pClaimDiagnosisID)
        {
            List<string> retAns = new List<string>();

            ClaimDiagnosisSaveModel objSaveModel = new ClaimDiagnosisSaveModel();
            objSaveModel.Fill(Converts.AsInt64(pClaimDiagnosisID), IsActive(true));
            objSaveModel.ClaimDiagnosisResult.IsActive = false;
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
        /// <param name="pClaimCPTID"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RemoveCptAjaxCall(string pClaimCPTID)
        {
            List<string> retAns = new List<string>();

            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel();
            objSaveModel.Fill(Converts.AsInt64(pClaimCPTID), IsActive(true));
            objSaveModel.pkClaimCPTResult.IsActive = false;
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
        /// <param name="pCPTID"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult GetCharge(string pCPTID)
        {
            CPTSearchModel objSearchModel = new CPTSearchModel();
            objSearchModel.GetCharge(Converts.AsInt32(pCPTID));

            List<CPTResult> retCPT = new List<CPTResult>();

            usp_GetByPkId_CPT_Result objCPT = new usp_GetByPkId_CPT_Result() { ChargePerUnit = objSearchModel.chargePerUnit };

            retCPT.Add((CPTResult)objCPT);


            return new JsonResultExtension { Data = retCPT };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDiagnosisID"></param>
        /// <param name="pCPTID"></param>
        /// <param name="pFacilityTypeID"></param>
        /// <param name="pUnit"></param>
        /// <param name="pChargePerUnit"></param>
        /// <param name="pModifier1"></param>
        /// <param name="pModifier2"></param>
        /// <param name="pModifier3"></param>
        /// <param name="pModifier4"></param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SaveCPTAjaxCall(string pDiagnosisID, string pCPTID, string pFacilityTypeID, string pDOS, string pUnit, string pChargePerUnit, string pModifier1, string pModifier2, string pModifier3, string pModifier4)
        {
            List<string> retAns = new List<string>();
            ClaimCPTSaveModel objSaveModel = new ClaimCPTSaveModel() { PatientVisitID = ArivaSession.Sessions().PageEditID<long>(), ClaimDiagnosisID = Converts.AsInt32(pDiagnosisID), CPTID = Converts.AsInt32(pCPTID), FacilityTypeNameID = Converts.AsByte(pFacilityTypeID), Units = Converts.AsInt32(pUnit), ChargePerUnit = Converts.AsDecimal(pChargePerUnit), ModifierName1ID = Converts.AsInt32(pModifier1), ModifierName2ID = Converts.AsInt32(pModifier2), ModifierName3ID = Converts.AsInt32(pModifier3), ModifierName4ID = Converts.AsInt32(pModifier4), cPTDOS = Converts.AsDateTime(pDOS.Trim()) };

            if (objSaveModel.InsertClaimDiagnosisCPT(ArivaSession.Sessions().UserID))
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

        # endregion
    }
}
