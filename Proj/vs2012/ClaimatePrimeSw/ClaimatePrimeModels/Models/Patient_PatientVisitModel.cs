using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;
using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using System.Text;

namespace ClaimatePrimeModels.Models
{

    # region Class PatientVisit

    # region Save

    public class PatientVisitSaveModel : BaseSaveModel
    {
        #region Properties


        /// <summary>
        /// Get or Set
        /// </summary>
        public string CommentForUnblock { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_PatientVisit_Result PatientVisitResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetIsPatVisitDoc_Clinic_Result IsPatVisitDoc
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientVisitResult_PatientHospitalization
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int HospitalID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientVisitResult_IllnessIndicator
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientVisitResult_FacilityType
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientVisitResult_FacilityDone
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientVisitResult_PrimaryClaimDiagnosis
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrRootPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrDoctorNotePath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrSuperBillPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String AssignedToName
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ClaimStatusName
        {
            get;
            set;
        }

        public global::System.String PrimaryDxName { get; set; }

        public global::System.String Target_BA_User { get; set; }
        public global::System.String Target_QA_User { get; set; }
        public global::System.String Target_EA_User { get; set; }
        public global::System.String SelClinicDispName { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientVisitSaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PatientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PatientVisitResult == null)
            {
                PatientVisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
            }
            else
            {
                PatientVisitResult.Comment = null;

                # region Auto Complete Fill

                # region Hospitalization

                if (PatientVisitResult.PatientHospitalizationID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetHospitalization_PatientVisit_Result spRes = (new List<usp_GetHospitalization_PatientVisit_Result>(ctx.usp_GetHospitalization_PatientVisit(PatientVisitResult.PatientHospitalizationID))).FirstOrDefault();

                        if (spRes != null)
                        {
                            PatientVisitResult_PatientHospitalization = spRes.NAME_CODE;
                            HospitalID = spRes.FacilityDoneID;
                        }
                    }
                }

                # endregion

                # region IllnessIndicatorName

                if (PatientVisitResult.IllnessIndicatorID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_IllnessIndicator_Result spRes = (new List<usp_GetNameByID_IllnessIndicator_Result>(ctx.usp_GetNameByID_IllnessIndicator(PatientVisitResult.IllnessIndicatorID, pIsActive))).FirstOrDefault();

                        if (spRes != null)
                        {
                            PatientVisitResult_IllnessIndicator = spRes.NAME_CODE;
                        }
                    }
                }

                # endregion

                # region Facility

                //others
                if (PatientVisitResult.FacilityTypeID > Convert.ToByte(ClaimatePrimeConstants.FacilityType.OFFICE))
                {
                    # region FacilityTypeName

                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_FacilityType_Result spRes = (new List<usp_GetNameByID_FacilityType_Result>(ctx.usp_GetNameByID_FacilityType(PatientVisitResult.FacilityTypeID, pIsActive))).FirstOrDefault();

                        if (spRes != null)
                        {
                            PatientVisitResult_FacilityType = spRes.NAME_CODE;
                        }
                    }

                    # endregion

                    # region FacilityDoneName

                    if (PatientVisitResult.FacilityDoneID > 0)
                    {
                        using (EFContext ctx = new EFContext())
                        {
                            usp_GetNameByID_FacilityDone_Result spRes = (new List<usp_GetNameByID_FacilityDone_Result>(ctx.usp_GetNameByID_FacilityDone(PatientVisitResult.FacilityDoneID, pIsActive))).FirstOrDefault();

                            if (spRes != null)
                            {
                                PatientVisitResult_FacilityDone = spRes.NAME_CODE;
                            }
                        }
                    }

                    # endregion
                }
                else
                {
                    //own clinic
                    PatientVisitResult.FacilityTypeID = Convert.ToByte(ClaimatePrimeConstants.FacilityType.OFFICE);

                    # region FacilityTypeName

                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_FacilityType_Result spRes = (new List<usp_GetNameByID_FacilityType_Result>(ctx.usp_GetNameByID_FacilityType(PatientVisitResult.FacilityTypeID, pIsActive))).FirstOrDefault();

                        if (spRes != null)
                        {
                            PatientVisitResult_FacilityType = spRes.NAME_CODE;
                        }
                    }

                    # endregion

                    # region FacilityDoneName

                    PatientVisitResult_FacilityDone = string.Empty;

                    # endregion
                }

                # endregion

                #region Primary Dx Name

                if (PatientVisitResult.PrimaryClaimDiagnosisID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetPrimeDxByID_PatientVisit_Result spRes = (new List<usp_GetPrimeDxByID_PatientVisit_Result>(ctx.usp_GetPrimeDxByID_PatientVisit(PatientVisitResult.PatientVisitID, true, null))).FirstOrDefault();

                        if (spRes != null)
                        {
                            PrimaryDxName = spRes.NAME_CODE;
                        }
                    }
                }

                #endregion

                #region Target_BA_User

                if (PatientVisitResult.TargetBAUserID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_User_Result spRes = (new List<usp_GetNameByID_User_Result>(ctx.usp_GetNameByID_User(PatientVisitResult.TargetBAUserID))).FirstOrDefault();

                        if (spRes != null)
                        {
                            Target_BA_User = spRes.NAME_CODE;
                        }
                    }
                }

                #endregion

                #region Target_QA_User

                if (PatientVisitResult.TargetQAUserID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_User_Result spRes = (new List<usp_GetNameByID_User_Result>(ctx.usp_GetNameByID_User(PatientVisitResult.TargetQAUserID))).FirstOrDefault();

                        if (spRes != null)
                        {
                            Target_QA_User = spRes.NAME_CODE;
                        }
                    }
                }

                #endregion

                #region Target_EA_User

                if (PatientVisitResult.TargetEAUserID > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_User_Result spRes = (new List<usp_GetNameByID_User_Result>(ctx.usp_GetNameByID_User(PatientVisitResult.TargetEAUserID))).FirstOrDefault();

                        if (spRes != null)
                        {
                            Target_EA_User = spRes.NAME_CODE;
                        }
                    }
                }

                #endregion

                #region AssignedToName

                if (PatientVisitResult.AssignedTo > 0)
                {
                    using (EFContext ctx = new EFContext())
                    {
                        usp_GetNameByID_User_Result spRes = (new List<usp_GetNameByID_User_Result>(ctx.usp_GetNameByID_User(PatientVisitResult.AssignedTo))).FirstOrDefault();

                        if (spRes != null)
                        {
                            AssignedToName = spRes.NAME_CODE;
                        }
                    }
                }

                #endregion

                # endregion
            }

            EncryptAudit(PatientVisitResult.PatientVisitID, PatientVisitResult.LastModifiedBy, PatientVisitResult.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {

            ObjectParameter patientVisitID = ObjParam("PatientVisit");
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                #region Doc Note

                if (!(string.IsNullOrWhiteSpace(PatientVisitResult.DoctorNoteRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Patient", "PatientVisit"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrDoctorNotePath = string.Concat(FileSvrDoctorNotePath, @"\P_", ID);
                    if (Directory.Exists(FileSvrDoctorNotePath))
                    {
                        Directory.Delete(FileSvrDoctorNotePath, true);
                    }
                    Directory.CreateDirectory(FileSvrDoctorNotePath);

                    FileSvrDoctorNotePath = string.Concat(FileSvrDoctorNotePath, @"\", "U_1", Path.GetExtension(PatientVisitResult.DoctorNoteRelPath));   // File Uploading
                    if (File.Exists(FileSvrDoctorNotePath))
                    {
                        File.Delete(FileSvrDoctorNotePath);
                    }
                    File.Move(PatientVisitResult.DoctorNoteRelPath, FileSvrDoctorNotePath);
                    FileSvrDoctorNotePath = FileSvrDoctorNotePath.Replace(FileSvrRootPath, string.Empty);
                    PatientVisitResult.DoctorNoteRelPath = FileSvrDoctorNotePath.Substring(1);
                }

                #endregion

                #region Super Bill

                if (!(string.IsNullOrWhiteSpace(PatientVisitResult.SuperBillRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Patient", "PatientVisit"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrSuperBillPath = string.Concat(FileSvrSuperBillPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrSuperBillPath))
                    {
                        Directory.Delete(FileSvrSuperBillPath, true);
                    }
                    Directory.CreateDirectory(FileSvrSuperBillPath);

                    FileSvrSuperBillPath = string.Concat(FileSvrSuperBillPath, @"\", "U_1", Path.GetExtension(PatientVisitResult.SuperBillRelPath));   // File Uploading
                    if (File.Exists(FileSvrSuperBillPath))
                    {
                        File.Delete(FileSvrSuperBillPath);
                    }
                    File.Move(PatientVisitResult.SuperBillRelPath, FileSvrSuperBillPath);
                    FileSvrSuperBillPath = FileSvrSuperBillPath.Replace(FileSvrRootPath, string.Empty);
                    PatientVisitResult.SuperBillRelPath = FileSvrSuperBillPath.Substring(1);
                }

                #endregion

                StringBuilder sb = new StringBuilder();
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(PatientVisitResult.ClaimStatusID);
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), PatientVisitResult.AssignedTo, PatientVisitResult.TargetBAUserID
                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                if (HasErr(patientVisitID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }


            return true;
        }

        #endregion

        # region Public Methods

        public bool IsAttachmentMandatory(Nullable<int> clinicID)
        {
            if (clinicID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    IsPatVisitDoc = (new List<usp_GetIsPatVisitDoc_Clinic_Result>(ctx.usp_GetIsPatVisitDoc_Clinic(clinicID))).FirstOrDefault();
                }
            }

            if (PatientVisitResult == null)
            {
                IsPatVisitDoc = new usp_GetIsPatVisitDoc_Clinic_Result();
            }

            return IsPatVisitDoc.IsAttachmentMandatory;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPatientVisit"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(List<usp_GetBySearch_PatientVisit_Result> pPatientVisit, global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                foreach (usp_GetBySearch_PatientVisit_Result item in pPatientVisit)
                {
                    PatientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(item.PatientVisitID, pIsActive))).FirstOrDefault();

                    if (PatientVisitResult == null)
                    {
                        PatientVisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                    }

                    PatientVisitResult.PatientVisitComplexity = item.PatientVisitComplexity;



                    EncryptAudit(PatientVisitResult.PatientVisitID, PatientVisitResult.LastModifiedBy, PatientVisitResult.LastModifiedOn);

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(PatientVisitResult.ClaimStatusID);
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(PatientVisitResult.Comment);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");

                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), PatientVisitResult.AssignedTo, PatientVisitResult.TargetBAUserID
                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                    if (HasErr(patientVisitID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        # region AutoComplete

        public List<string> IllnessIndicator(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_IllnessIndicator_Result> spRes = new List<usp_GetAutoComplete_IllnessIndicator_Result>(ctx.usp_GetAutoComplete_IllnessIndicator(stats));

                foreach (usp_GetAutoComplete_IllnessIndicator_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;


        }

        public List<string> FacilityType(string stats)
        {

            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_FacilityType_Result> spRes = new List<usp_GetAutoComplete_FacilityType_Result>(ctx.usp_GetAutoComplete_FacilityType(stats));

                foreach (usp_GetAutoComplete_FacilityType_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }

        public List<string> FacilityDone(string stats, string conti)
        {
            List<string> retRes = new List<string>();
            if (!(string.IsNullOrWhiteSpace(conti)))
            {
                using (EFContext ctx = new EFContext())
                {
                    List<usp_GetAutoComplete_FacilityDone_Result> spRes = new List<usp_GetAutoComplete_FacilityDone_Result>(ctx.usp_GetAutoComplete_FacilityDone(stats, Convert.ToByte(conti)));

                    foreach (usp_GetAutoComplete_FacilityDone_Result item in spRes)
                    {
                        retRes.Add(item.NAME_CODE);
                    }
                }
            }

            return retRes;
        }


        // / / / / / 



        public List<string> IllnessIndicatorID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_IllnessIndicator_Result spRes = (new List<usp_GetIDAutoComplete_IllnessIndicator_Result>(ctx.usp_GetIDAutoComplete_IllnessIndicator(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.IllnessIndicatorID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());

        }



        public List<string> FacilityTypeID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_FacilityType_Result spRes = (new List<usp_GetIDAutoComplete_FacilityType_Result>(ctx.usp_GetIDAutoComplete_FacilityType(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.FacilityTypeID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        public List<string> FacilityDoneNameID(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_FacilityDone_Result spRes = (new List<usp_GetIDAutoComplete_FacilityDone_Result>(ctx.usp_GetIDAutoComplete_FacilityDone(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.FACILITY_DONE_ID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool UnBlockVisit(int pUserID)
        {
            string statsIDs = string.Empty;
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ObjectParameter patientVisitID = ObjParam("PatientVisit");

                //statsIDs = Convert.ToString(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                PatientVisitResult.IsActive = true;
                PatientVisitResult.AssignedTo = pUserID;
                PatientVisitResult.TargetBAUserID = pUserID;

                StringBuilder sb = new StringBuilder();
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForUnblock);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                //PatientVisitResult.Comment = "Unblocked";

                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), PatientVisitResult.AssignedTo, PatientVisitResult.TargetBAUserID
                , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                if (HasErr(patientVisitID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }
            return true;
        }


    }
        # endregion

    #endregion

    # region Search
    public class PatientVisitSearchModel : BaseSearchModel
    {
        private Nullable<Int64> _PatientID;

        #region Properties

        public Int32 ClinicID { get; set; }
        public Int32 userID { get; set; }

        public string ErrorMsg { get; set; }

        public Nullable<Int64> PatientID
        {
            get
            {
                return _PatientID;
            }
            set
            {
                if (value == 0)
                {
                    _PatientID = null;
                }
                else
                {
                    _PatientID = value;
                }
            }
        }

        public List<usp_GetBySearch_PatientVisit_Result> PatientVisit { get; set; }

        public usp_GetByPkId_Patient_Result PatientResult { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientVisitSearchModel()
        {
        }

        # endregion

        #region Abstract
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_PatientVisit_Result> lst = new List<usp_GetByAZ_PatientVisit_Result>(ctx.usp_GetByAZ_PatientVisit(ClinicID, SearchName, DateFrom, DateTo, PatientID));

                foreach (usp_GetByAZ_PatientVisit_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetBySearch_PatientVisit_Result>(ctx.usp_GetBySearch_PatientVisit(Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.DONE), ClinicID, PatientID, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }

        #endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            PatientVisitSaveModel objSaveModel = new PatientVisitSaveModel();
            if (!(objSaveModel.Save(PatientVisit, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public usp_GetNameByPatientVisitID_Patient_Result GetChartByID(Nullable<bool> isActive)
        {
            usp_GetNameByPatientVisitID_Patient_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetNameByPatientVisitID_Patient_Result>(ctx.usp_GetNameByPatientVisitID_Patient(CurrNumber, isActive))).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetNameByPatientVisitID_Patient_Result();
            }

            return retAns;
        }

        public void FillIsActive()
        {
            using (EFContext ctx = new EFContext())
            {
                PatientResult = new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(PatientID, null)).FirstOrDefault();
            }
        }

        #endregion


    }
    #endregion

    #endregion

    #region Class Visit chart model

    /// <summary>
    /// 
    /// </summary>
    public class VisitChartModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 PatientVisitID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 PatientID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Patient
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.DateTime DateOfService
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<Nullable<DateTime>> DOSs
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetPatientVisitComplexity_Clinic_Result VisitComplexity
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string CommentForNew
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string CommentForBAGenQ
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Nullable<int> ClinicID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetIsDischarged_PatientHospitalization_Result> IsDischarged { get; set; }


        #endregion

        #region Auto Complete
        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> ChartNumber(Nullable<int> clinicID, string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Patient_Result> spRes = new List<usp_GetAutoComplete_Patient_Result>(ctx.usp_GetAutoComplete_Patient(clinicID, stats));

                foreach (usp_GetAutoComplete_Patient_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> ChartNumberID(Nullable<int> clinicID, string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_Patient_Result spRes = (new List<usp_GetIDAutoComplete_Patient_Result>(ctx.usp_GetIDAutoComplete_Patient(selCode, clinicID, true))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.PatientID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }
        #endregion

        # region Protected

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter patientVisitID = ObjParam("PatientVisit");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                foreach (Nullable<DateTime> item in DOSs)
                {
                    if (item.HasValue)
                    {
                        ctx.usp_Insert_PatientVisit(ClinicID, PatientID, item, CommentForNew, pUserID, patientVisitID, Convert.ToByte(FacilityType.OFFICE), Convert.ToByte(FacilityType.INPATIENT_HOSPITAL));

                        if (HasErr(patientVisitID, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }

                        #region BA GENERAL QUEUE status save

                        usp_GetByPkId_PatientVisit_Result patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(Convert.ToInt64(patientVisitID.Value), true))).First();

                        //patientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE);

                        StringBuilder sb = new StringBuilder();
                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForBAGenQ);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        ObjectParameter objParam = null;

                        objParam = ObjParam("PatientVisitID", typeof(System.Int64), patientVisitResult.PatientVisitID);

                        ctx.usp_Update_PatientVisit(patientVisitResult.PatientID, patientVisitResult.DOS
                            , patientVisitResult.IllnessIndicatorID, patientVisitResult.IllnessIndicatorDate, patientVisitResult.FacilityTypeID
                            , patientVisitResult.FacilityDoneID, patientVisitResult.PrimaryClaimDiagnosisID, patientVisitResult.DoctorNoteRelPath
                            , patientVisitResult.SuperBillRelPath, patientVisitResult.PatientVisitDesc, sb.ToString()
                            , patientVisitResult.AssignedTo, patientVisitResult.TargetBAUserID, patientVisitResult.TargetQAUserID
                            , patientVisitResult.TargetEAUserID, patientVisitResult.PatientVisitComplexity
                            , patientVisitResult.IsActive, patientVisitResult.LastModifiedBy, patientVisitResult.LastModifiedOn, pUserID, objParam);

                        if (HasErr(objParam, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }

                        #endregion

                        this.PatientVisitID = Convert.ToInt64(objParam.Value);
                    }
                }
                CommitDbTrans(ctx);
            }

            return true;
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region public

        public void GetPatVisitComplexity(int ClinicId)
        {
            if (ClinicId > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    VisitComplexity = (new List<usp_GetPatientVisitComplexity_Clinic_Result>(ctx.usp_GetPatientVisitComplexity_Clinic(ClinicId))).FirstOrDefault();
                }
            }

            if (VisitComplexity == null)
            {
                VisitComplexity = new usp_GetPatientVisitComplexity_Clinic_Result();
            }
        }

        #endregion
    }

    #endregion

    #region Class Visits chart model

    /// <summary>
    /// 
    /// </summary>
    public class VisitsChartModel : BaseSaveModel
    {
        /// <summary>
        /// Get or Set
        /// </summary>
        public List<VisitChartModel> VisitCharts { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetPatientVisitComplexity_Clinic_Result VisitComplexity
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string CommentForNew
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string CommentForBAGenQ
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Nullable<int> ClinicID { get; set; }

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            VisitCharts = new List<VisitChartModel>();

            for (int i = 0; i < 50; i++)
            {
                VisitCharts.Add(new VisitChartModel());
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="startBy"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, out string startBy)
        {
            startBy = string.Empty;
            ObjectParameter patientVisitID = null;

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                foreach (VisitChartModel item in VisitCharts)
                {
                    if (item.PatientID > 0)
                    {

                        startBy = item.Patient.Substring(0, 1);
                        patientVisitID = ObjParam("PatientVisit");

                        ctx.usp_Insert_PatientVisit(ClinicID, item.PatientID, item.DateOfService
                            , CommentForNew, pUserID, patientVisitID, Convert.ToByte(FacilityType.OFFICE), Convert.ToByte(FacilityType.INPATIENT_HOSPITAL));

                        if (HasErr(patientVisitID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }

                        #region BA GENERAL QUEUE status save

                        usp_GetByPkId_PatientVisit_Result patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(Convert.ToInt64(patientVisitID.Value), true))).First();

                        //patientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE);

                        StringBuilder sb = new StringBuilder();
                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForBAGenQ);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        ObjectParameter objParam = null;

                        objParam = ObjParam("PatientVisitID", typeof(System.Int64), patientVisitResult.PatientVisitID);

                        ctx.usp_Update_PatientVisit(patientVisitResult.PatientID, patientVisitResult.DOS
                            , patientVisitResult.IllnessIndicatorID, patientVisitResult.IllnessIndicatorDate, patientVisitResult.FacilityTypeID
                            , patientVisitResult.FacilityDoneID, patientVisitResult.PrimaryClaimDiagnosisID, patientVisitResult.DoctorNoteRelPath
                            , patientVisitResult.SuperBillRelPath, patientVisitResult.PatientVisitDesc, sb.ToString()
                            , patientVisitResult.AssignedTo, patientVisitResult.TargetBAUserID, patientVisitResult.TargetQAUserID
                            , patientVisitResult.TargetEAUserID, patientVisitResult.PatientVisitComplexity
                            , patientVisitResult.IsActive, patientVisitResult.LastModifiedBy, patientVisitResult.LastModifiedOn, pUserID, objParam);

                        if (HasErr(objParam, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }

                        #endregion
                    }
                }
                CommitDbTrans(ctx);
            }

            return true;
        }


        public void GetPatVisitComplexity(int ClinicId)
        {
            if (ClinicId > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    VisitComplexity = (new List<usp_GetPatientVisitComplexity_Clinic_Result>(ctx.usp_GetPatientVisitComplexity_Clinic(ClinicId))).FirstOrDefault();
                }
            }

            if (VisitComplexity == null)
            {
                VisitComplexity = new usp_GetPatientVisitComplexity_Clinic_Result();
            }

        }


        # endregion

    }

    #endregion

    # region Class MenuClaim

    public class MenuClaimSearchModel : BaseSearchModel
    {
        #region Properties

        public Nullable<int> UnassigneClaimCount { get; set; }

        public Nullable<int> UnassigneClaimNITCount { get; set; }

        public Nullable<int> AssignedClaimCount { get; set; }

        public Nullable<int> AssignedClaimNITCount { get; set; }

        public Nullable<int> CreatedClaimCount { get; set; }

        public Int32 ClinicID { get; set; }

        public Nullable<int> assignedTo { get; set; }

        public string UnassigneClaimStatus { get; set; }

        public string UnassigneClaimNITStatus { get; set; }

        public string AssigneClaimStatus { get; set; }

        public string AssigneClaimNITStatus { get; set; }

        public string CreatedClaimStatus { get; set; }

        public int ClaimCount837 { get; set; }

        public Nullable<int> ClaimCount835 { get; set; }

        public Nullable<int> ClaimCountHistory { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public MenuClaimSearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        protected override void FillByAZ(bool? pIsActive)
        {
            throw new NotImplementedException();
        }
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {

            throw new NotImplementedException();
        }
        #endregion

        #region publicmethods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        public void GetCountPatientVisit(Nullable<int> clinicID)
        {
            usp_GetCount_PatientVisit_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetCount_PatientVisit_Result>(ctx.usp_GetCount_PatientVisit(clinicID, UnassigneClaimStatus, null))).FirstOrDefault();
            }

            UnassigneClaimCount = retAns.CLAIM_COUNT;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetCount_PatientVisit_Result>(ctx.usp_GetCount_PatientVisit(clinicID, UnassigneClaimNITStatus, null))).FirstOrDefault();
            }

            UnassigneClaimNITCount = retAns.CLAIM_COUNT;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetCount_PatientVisit_Result>(ctx.usp_GetCount_PatientVisit(clinicID, AssigneClaimStatus, assignedTo))).FirstOrDefault();
            }
            AssignedClaimCount = retAns.CLAIM_COUNT;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetCount_PatientVisit_Result>(ctx.usp_GetCount_PatientVisit(clinicID, AssigneClaimNITStatus, assignedTo))).FirstOrDefault();
            }
            AssignedClaimNITCount = retAns.CLAIM_COUNT;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetCount_PatientVisit_Result>(ctx.usp_GetCount_PatientVisit(clinicID, CreatedClaimStatus, null))).FirstOrDefault();
            }
            CreatedClaimCount = retAns.CLAIM_COUNT;
        }
        /// <summary>
        /// Changed by sai if needed as a temporary soln
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="userID"></param>
        public void GetCountEDI(Nullable<int> clinicID, Nullable<int> userID)
        {
            using (EFContext ctx = new EFContext())
            {
                ClaimCount837 = (new List<usp_GetCount837_PatientVisit_Result>(ctx.usp_GetCount837_PatientVisit(clinicID, string.Concat(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK)), null))).FirstOrDefault().CLAIM_COUNT;
            }

            using (EFContext ctx = new EFContext())
            {
                ClaimCount835 = (new List<usp_GetCount835_EDIFile_Result>(ctx.usp_GetCount835_EDIFile(clinicID
                    , string.Concat(Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK))
                    , userID))).FirstOrDefault().CLAIM_COUNT;
            }

            using (EFContext ctx = new EFContext())
            {
                ClaimCountHistory = (new List<usp_GetCountEDIHistory_EDIFile_Result>(ctx.usp_GetCountEDIHistory_EDIFile(clinicID
                    , string.Concat(Convert.ToByte(ClaimStatus.SENT_CLAIM), ", "
                    , Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", "
                    , Convert.ToByte(ClaimStatus.EDI_FILE_RESPONSED), ", "
                    , Convert.ToByte(ClaimStatus.REJECTED_CLAIM), ", "
                    , Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK), ", "
                    , Convert.ToByte(ClaimStatus.REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA), ", "
                    , Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), ", "
                    , Convert.ToByte(ClaimStatus.DONE))))).FirstOrDefault().CLAIM_COUNT;
            }
        }
        #endregion
    }
    #endregion

    # region Class Unassigned Claims

    # region Search

    public class UnassignedClaimSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetUnAssigned_PatientVisit_Result> PatientVisit
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> AssignedTo { get; set; }

        public string statusIDs { get; set; }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get;
            set;
        }

        public string _CommentForBAPerQ { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimSearchModel()
        { }

        # endregion

        #region Abstract Methods


        protected override void FillByAZ(bool? pIsActive)
        {

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}

            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetUnAssigned_PatientVisit_Result>(ctx.usp_GetUnAssigned_PatientVisit(ClinicID, statusIDs, SearchName, DateFrom, DateTo, AssignedTo, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }


        #endregion

        #region Private Methods

        //public void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_PatientVisit_Result spRes = (new List<usp_GetDate_PatientVisit_Result>(ctx.usp_GetDate_PatientVisit(ClinicID, statusIDs, null))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        # endregion

        # region Public Methods

        /// <summary>
        /// //
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            UnassignedClaimSaveModel objSaveModel = new UnassignedClaimSaveModel();
            objSaveModel.CommentForBAPerQ = _CommentForBAPerQ;
            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion

    }
    # endregion

    # region Save

    public class UnassignedClaimSaveModel : BaseSaveModel
    {

        #region Properties

        public Int32 ClinicID { get; set; }
        public usp_GetByPkId_PatientVisit_Result VisitResult { get; set; }
        public string CommentForBAPerQ { get; set; }

        //public usp_GetByPkId_PatientVisit_Result pClaimResult
        //{
        //    get;
        //    set;
        //}

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimSaveModel()
        { }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Private Methods


        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(Int64 patVisitID, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                VisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(patVisitID, pIsActive))).FirstOrDefault();

                if (VisitResult == null)
                {
                    VisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                }

                EncryptAudit(VisitResult.PatientVisitID, VisitResult.LastModifiedBy, VisitResult.LastModifiedOn);

                if (VisitResult.AssignedTo == null && (VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE) || VisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK)))
                {
                    BeginDbTrans(ctx);

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(CommentForBAPerQ);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");
                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    ctx.usp_Update_PatientVisit(VisitResult.PatientID, VisitResult.DOS, VisitResult.IllnessIndicatorID, VisitResult.IllnessIndicatorDate
                    , VisitResult.FacilityTypeID, VisitResult.FacilityDoneID, VisitResult.PrimaryClaimDiagnosisID, VisitResult.DoctorNoteRelPath, VisitResult.SuperBillRelPath, VisitResult.PatientVisitDesc
                    , sb.ToString(), pUserID, pUserID, VisitResult.TargetQAUserID, VisitResult.TargetEAUserID, VisitResult.PatientVisitComplexity
                    , VisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                    if (HasErr(patientVisitID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }

                    CommitDbTrans(ctx);
                }
                else
                {
                    return false;
                }
            }

            return true;
        }

        #endregion
    }

    #endregion

    # endregion

    # region Class Assigned Claims

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetBySearch_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 ClinicID { get; set; }
        public Nullable<int> AssignedTo { get; set; }

        public string StatusIDs { get; set; }
        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimSearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimProcess_Result> lst = new List<usp_GetByAZ_ClaimProcess_Result>(ctx.usp_GetByAZ_ClaimProcess(ClinicID, StatusIDs, AssignedTo, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZ_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearch_ClaimProcess_Result>(ctx.usp_GetBySearch_ClaimProcess(ClinicID, StatusIDs, AssignedTo, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion
    }

    #endregion

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public PatientVisitSaveModel PatientVisit { get; set; }

        public string CommentForCreated { get; set; }

        public string CommentForQAGenQ { get; set; }

        public string CommentForQAPerQ { get; set; }

        public string CommentForHolded { get; set; }

        public string CommentForUnhold { get; set; }

        public usp_GetByPkId_PatientVisit_Result TempPatientVisitResult { get; set; }

        public int PatID { get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimSaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            PatientVisit = new PatientVisitSaveModel();
            PatientVisit.Fill(pID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter objParam = null;

            string statsIDs = string.Empty;

            StringBuilder sb = new StringBuilder();

            if (PatientVisit.PatientVisitResult.TargetQAUserID.HasValue)
            {
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.CREATED_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForCreated);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForQAGenQ);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisit.PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                PatientVisit.PatientVisitResult.AssignedTo = PatientVisit.PatientVisitResult.TargetQAUserID;
                // statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.CREATED_CLAIM)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE)));
            }
            else
            {
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.CREATED_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForCreated);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisit.PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");
                //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.CREATED_CLAIM)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE)));
                PatientVisit.PatientVisitResult.AssignedTo = null;
            }

            PatientVisit.PatientVisitResult.IsActive = true;

            objParam = PatientVisit.ObjParam("PatientVisit");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                #region CREATED CLAIM status Save + QA General Queue Save

                ctx.usp_Update_PatientVisit(
                      PatientVisit.PatientVisitResult.PatientID, PatientVisit.PatientVisitResult.DOS
                    , PatientVisit.PatientVisitResult.IllnessIndicatorID, PatientVisit.PatientVisitResult.IllnessIndicatorDate, PatientVisit.PatientVisitResult.FacilityTypeID
                    , PatientVisit.PatientVisitResult.FacilityDoneID, PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisit.PatientVisitResult.DoctorNoteRelPath
                    , PatientVisit.PatientVisitResult.SuperBillRelPath, PatientVisit.PatientVisitResult.PatientVisitDesc, sb.ToString()
                    , PatientVisit.PatientVisitResult.AssignedTo, PatientVisit.PatientVisitResult.TargetBAUserID, PatientVisit.PatientVisitResult.TargetQAUserID
                    , PatientVisit.PatientVisitResult.TargetEAUserID, PatientVisit.PatientVisitResult.PatientVisitComplexity
                    , PatientVisit.PatientVisitResult.IsActive, PatientVisit.LastModifiedBy, PatientVisit.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                #endregion

                # region Claim Number

                // Get Primary Dx
                usp_GetByPkId_ClaimDiagnosis_Result claimDiag = (new List<usp_GetByPkId_ClaimDiagnosis_Result>(ctx.usp_GetByPkId_ClaimDiagnosis(PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, true))).First();
                EncryptAudit(claimDiag.ClaimDiagnosisID, claimDiag.LastModifiedBy, claimDiag.LastModifiedOn);

                // Set -1 for Primary Dx
                claimDiag.ClaimNumber = -1;
                ObjectParameter claimDiagnosis = ObjParam("ClaimDiagnosis");
                ctx.usp_Update_ClaimDiagnosis(claimDiag.PatientVisitID, claimDiag.DiagnosisID, claimDiag.ClaimNumber, claimDiag.Comment, claimDiag.IsActive, LastModifiedBy, LastModifiedOn, pUserID, claimDiagnosis);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                // Get DeActive Dxs
                List<usp_GetDiagnosis_ClaimDiagnosis_Result> delDxResults = new List<usp_GetDiagnosis_ClaimDiagnosis_Result>(ctx.usp_GetDiagnosis_ClaimDiagnosis(PatientVisit.PatientVisitResult.PatientVisitID, false));

                // Set 0 for DeActive Dxs
                foreach (usp_GetDiagnosis_ClaimDiagnosis_Result item in delDxResults)
                {
                    claimDiag = (new List<usp_GetByPkId_ClaimDiagnosis_Result>(ctx.usp_GetByPkId_ClaimDiagnosis(item.ClaimDiagnosisID, false))).First();

                    claimDiag.ClaimNumber = 0;
                    claimDiagnosis = ObjParam("ClaimDiagnosis");
                    ctx.usp_Update_ClaimDiagnosis(claimDiag.PatientVisitID, claimDiag.DiagnosisID, claimDiag.ClaimNumber, claimDiag.Comment, claimDiag.IsActive, LastModifiedBy, LastModifiedOn, pUserID, claimDiagnosis);

                    if (HasErr(objParam, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }
                }

                // Get Max Cla. Number (with out where condition)
                long maxClaimNumber = (new List<usp_GetMaxClaimNumber_ClaimDiagnosis_Result>(ctx.usp_GetMaxClaimNumber_ClaimDiagnosis())).First().MAX_CLAIM_NO;
                maxClaimNumber++;

                // Get Max Allowed Dx Count
                byte maxDxCount = (new List<usp_GetMaxDiagnosis_ClaimMedia_Result>(ctx.usp_GetMaxDiagnosis_ClaimMedia(PatientVisit.PatientVisitResult.PatientVisitID))).First().MAX_DIAGNOSIS;
                maxDxCount--;

                // Get Active Dx expcet primary
                List<usp_GetDiagnosis_ClaimDiagnosis_Result> actDxResults = new List<usp_GetDiagnosis_ClaimDiagnosis_Result>(ctx.usp_GetDiagnosis_ClaimDiagnosis(PatientVisit.PatientVisitResult.PatientVisitID, true));

                if (actDxResults.Count() == 0)
                {
                    // Only Primary Dx exists

                    // Get Primary Dx
                    claimDiag = (new List<usp_GetByPkId_ClaimDiagnosis_Result>(ctx.usp_GetByPkId_ClaimDiagnosis(PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, true))).First();
                    EncryptAudit(claimDiag.ClaimDiagnosisID, claimDiag.LastModifiedBy, claimDiag.LastModifiedOn);

                    // Set NON -1 for Primary Dx
                    claimDiag.ClaimNumber = maxClaimNumber;
                    claimDiagnosis = ObjParam("ClaimDiagnosis");
                    ctx.usp_Update_ClaimDiagnosis(claimDiag.PatientVisitID, claimDiag.DiagnosisID, claimDiag.ClaimNumber, claimDiag.Comment, claimDiag.IsActive, LastModifiedBy, LastModifiedOn, pUserID, claimDiagnosis);
                }
                else
                {
                    byte currDxCount = 1;

                    foreach (usp_GetDiagnosis_ClaimDiagnosis_Result item in actDxResults)
                    {
                        claimDiag = (new List<usp_GetByPkId_ClaimDiagnosis_Result>(ctx.usp_GetByPkId_ClaimDiagnosis(item.ClaimDiagnosisID, true))).First();
                        EncryptAudit(claimDiag.ClaimDiagnosisID, claimDiag.LastModifiedBy, claimDiag.LastModifiedOn);

                        claimDiag.ClaimNumber = maxClaimNumber;
                        claimDiagnosis = ObjParam("ClaimDiagnosis");
                        ctx.usp_Update_ClaimDiagnosis(claimDiag.PatientVisitID, claimDiag.DiagnosisID, claimDiag.ClaimNumber, claimDiag.Comment, claimDiag.IsActive, LastModifiedBy, LastModifiedOn, pUserID, claimDiagnosis);

                        if (HasErr(objParam, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }

                        currDxCount++;

                        if (currDxCount > maxDxCount)
                        {
                            currDxCount = 1;
                            maxClaimNumber++;
                        }
                    }
                }

                # endregion

                CommitDbTrans(ctx);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool SaveHoldUnHold(int pUserID)
        {
            ObjectParameter objParam = null;

            string statsIDs = string.Empty;

            StringBuilder sb = new StringBuilder();

            if (PatientVisit.PatientVisitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.HOLD_CLAIM)) // Hold
            {
                #region BA HOLDED status Save + HOLD CLAIM status Save

                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.BA_HOLDED));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForHolded);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.HOLD_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisit.PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");
                //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.BA_HOLDED)), ",", Convert.ToString(Convert.ToByte(ClaimStatus.HOLD_CLAIM)));

                #endregion
            }
            else // Un Hold
            {
                #region UNHOLD CLAIM status Save

                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.UNHOLD_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForUnhold);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisit.PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.UNHOLD_CLAIM)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE)));

                #endregion
            }

            PatientVisit.PatientVisitResult.IsActive = true;
            objParam = PatientVisit.ObjParam("PatientVisit");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_PatientVisit(PatientVisit.PatientVisitResult.PatientID, PatientVisit.PatientVisitResult.DOS
                    , PatientVisit.PatientVisitResult.IllnessIndicatorID, PatientVisit.PatientVisitResult.IllnessIndicatorDate, PatientVisit.PatientVisitResult.FacilityTypeID
                    , PatientVisit.PatientVisitResult.FacilityDoneID, PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisit.PatientVisitResult.DoctorNoteRelPath
                    , PatientVisit.PatientVisitResult.SuperBillRelPath, PatientVisit.PatientVisitResult.PatientVisitDesc, sb.ToString()
                    , PatientVisit.PatientVisitResult.AssignedTo, PatientVisit.PatientVisitResult.TargetBAUserID, PatientVisit.PatientVisitResult.TargetQAUserID
                    , PatientVisit.PatientVisitResult.TargetEAUserID, PatientVisit.PatientVisitResult.PatientVisitComplexity
                    , PatientVisit.PatientVisitResult.IsActive, PatientVisit.LastModifiedBy, PatientVisit.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }
            return true;
        }

        public bool SaveBlock(int pUserID)
        {
            ObjectParameter objParam = null;

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                #region Block

                StringBuilder sb = new StringBuilder();

                //usp_GetByPkId_PatientVisit_Result patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(PatientVisit.PatientVisitResult.PatientVisitID, true))).First();
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(PatientVisit.PatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                //PatientVisit.PatientVisitResult.ClaimStatusID = Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE);
                PatientVisit.PatientVisitResult.IsActive = false;

                objParam = ObjParam("PatientVisitID", typeof(System.Int64), PatientVisit.PatientVisitResult.PatientVisitID);

                ctx.usp_Update_PatientVisit(PatientVisit.PatientVisitResult.PatientID, PatientVisit.PatientVisitResult.DOS
                    , PatientVisit.PatientVisitResult.IllnessIndicatorID, PatientVisit.PatientVisitResult.IllnessIndicatorDate, PatientVisit.PatientVisitResult.FacilityTypeID
                    , PatientVisit.PatientVisitResult.FacilityDoneID, PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisit.PatientVisitResult.DoctorNoteRelPath
                    , PatientVisit.PatientVisitResult.SuperBillRelPath, PatientVisit.PatientVisitResult.PatientVisitDesc, sb.ToString()
                    , null, null, null, null, PatientVisit.PatientVisitResult.PatientVisitComplexity
                    , PatientVisit.PatientVisitResult.IsActive, PatientVisit.LastModifiedBy, PatientVisit.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                #endregion

                CommitDbTrans(ctx);
            }
            return true;
        }

        public bool SaveTemp(int pUserID)
        {
            ObjectParameter objParam = null;

            using (EFContext ctx = new EFContext())
            {
                TempPatientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(PatientVisit.PatientVisitResult.PatientVisitID, true))).First();

                StringBuilder sb = new StringBuilder();

                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(TempPatientVisitResult.ClaimStatusID);
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(TempPatientVisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                BeginDbTrans(ctx);

                objParam = ObjParam("PatientVisitID", typeof(System.Int64), PatientVisit.PatientVisitResult.PatientVisitID);


                ctx.usp_Update_PatientVisit(TempPatientVisitResult.PatientID, TempPatientVisitResult.DOS
                    , PatientVisit.PatientVisitResult.IllnessIndicatorID, PatientVisit.PatientVisitResult.IllnessIndicatorDate, PatientVisit.PatientVisitResult.FacilityTypeID
                    , PatientVisit.PatientVisitResult.FacilityDoneID, PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisit.PatientVisitResult.DoctorNoteRelPath
                    , PatientVisit.PatientVisitResult.SuperBillRelPath, PatientVisit.PatientVisitResult.PatientVisitDesc, sb.ToString()
                    , TempPatientVisitResult.AssignedTo, TempPatientVisitResult.TargetBAUserID, TempPatientVisitResult.TargetQAUserID
                    , TempPatientVisitResult.TargetEAUserID, TempPatientVisitResult.PatientVisitComplexity
                    , TempPatientVisitResult.IsActive, PatientVisit.LastModifiedBy, PatientVisit.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool HasProcedure()
        {
            usp_GetPrimeDxProc_ClaimDiagnosisCPT_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetPrimeDxProc_ClaimDiagnosisCPT_Result>(ctx.usp_GetPrimeDxProc_ClaimDiagnosisCPT(PatientVisit.PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisit.PatientVisitResult.PatientVisitID)).FirstOrDefault());
            }

            if (retAns == null)
            {
                retAns = new usp_GetPrimeDxProc_ClaimDiagnosisCPT_Result();
            }

            return retAns.HAS_PROCEDURE;
        }

        #endregion


    }

    #endregion

    #endregion

    #region Class ClaimsAgentModel

    /// <summary>
    /// By Sai:Manager Role - Case Agent front page display - For assigning agents to a particular case(only for the cases that are not closed)
    /// of the clinics assigned to those managers
    /// </summary>
    public class ClaimsAgentModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ErrorMsg { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Comments { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<ClaimAgentModel> ClaimAgentModels { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetClaimAgent_PatientVisit_Result> ClaimAgentResults
        {
            get;
            set;
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected void FillByID(long pID, bool? pIsActive)
        {
            ClaimAgentModels = new List<ClaimAgentModel>();

            for (int i = 0; i < ClaimAgentResults.Count; i++)
            {
                ClaimAgentModels.Add(new ClaimAgentModel());
            }
            //  throw new Exception("FillByID(long pID, bool? pIsActive)");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            ClaimAgentModel objSaveModel = new ClaimAgentModel();
            objSaveModel.ClinicID = ClinicID;
            objSaveModel.Comments = Comments;

            if (!(objSaveModel.Save(ClaimAgentResults, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                if (objSaveModel.ErrorMessage == "BA EMPTY")
                {
                    ErrorMsg = "BA EMPTY";
                }
                else if (objSaveModel.ErrorMessage == "BA & QA EMPTY")
                {
                    ErrorMsg = "BA & QA EMPTY";
                }
                else if (objSaveModel.ErrorMessage == "BA & QA & EA EMPTY")
                {
                    ErrorMsg = "BA & QA & EA EMPTY";
                }
                return false;
            }

            return true;

            //throw new Exception("Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)");
        }


        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_PatientVisit_Result> lst = new List<usp_GetByAZ_PatientVisit_Result>(ctx.usp_GetByAZ_PatientVisit(ClinicID, SearchName, DateFrom, DateTo, null));

                foreach (usp_GetByAZ_PatientVisit_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}
            using (EFContext ctx = new EFContext())
            {
                ClaimAgentResults = new List<usp_GetClaimAgent_PatientVisit_Result>(ctx.usp_GetClaimAgent_PatientVisit(ClinicID, SearchName, DateFrom, DateTo, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
            //throw new Exception("FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)");
        }

        #region Private Methods

        //public void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_Patient_Result spRes = (new List<usp_GetDate_Patient_Result>(ctx.usp_GetDate_Patient(ClinicID, "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28"))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        # endregion

        #endregion


    }

    #endregion

    #region Class ClaimAgentModel

    /// <summary>
    /// By Sai:Manager Role - Case Agent saving selected agents - For assigning agents to a particular case(only for the cases that are not closed)
    /// of the clinics assigned to those managers
    /// </summary>
    public class ClaimAgentModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Case number(Primary Key of Patient.PatientVisit table)
        /// </summary>
        public global::System.Int64 PatientVisitID
        {
            get;
            set;
        }

        /// <summary>
        /// Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Nullable<int> ClinicID { get; set; }

        /// <summary>
        /// Comments to be inserted while assigning or reassigning an agent
        /// </summary>
        public string Comments { get; set; }

        /// <summary>
        /// Primary Key of Patient.Patient table - For inserting into the Patient.PatientVisit table
        /// </summary>
        public global::System.Int64 PatientID
        {
            get;
            set;
        }

        /// <summary>
        /// For inserting into the Patient.PatientVisit table
        /// </summary>
        public global::System.DateTime DateOfService
        {
            get;
            set;
        }

        /// <summary>
        ///For inserting into the Patient.PatientVisit table
        /// </summary>
        public string TargetBAUserName { get; set; }

        /// <summary>
        /// For inserting into the Patient.PatientVisit table
        /// </summary>
        public string TargetQAUserName { get; set; }

        /// <summary>
        /// For inserting into the Patient.PatientVisit table
        /// </summary>
        public string TargetEAUserName { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string ErrorMessage { get; set; }

        #endregion

        # region Protected

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter patientVisitID = ObjParam("PatientVisit");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Insert_PatientVisit(ClinicID, PatientID, DateOfService, "New Visit Created", pUserID, patientVisitID, Convert.ToByte(FacilityType.OFFICE), Convert.ToByte(FacilityType.INPATIENT_HOSPITAL));


                if (HasErr(patientVisitID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                this.PatientVisitID = Convert.ToInt64(patientVisitID.Value);
                CommitDbTrans(ctx);
            }

            return true;
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPatientVisit"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(List<usp_GetClaimAgent_PatientVisit_Result> pClaimAgentResult, global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                foreach (usp_GetClaimAgent_PatientVisit_Result item in pClaimAgentResult)
                {
                    usp_GetByPkId_PatientVisit_Result PatientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(item.PATIENT_VISIT_ID, pIsActive))).FirstOrDefault();

                    if (PatientVisitResult == null)
                    {
                        PatientVisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                    }

                    PatientVisitResult.TargetBAUserID = item.TARGET_BA_USERID;
                    PatientVisitResult.TargetQAUserID = item.TARGET_QA_USERID;
                    PatientVisitResult.TargetEAUserID = item.TARGET_EA_USERID;



                    EncryptAudit(PatientVisitResult.PatientVisitID, PatientVisitResult.LastModifiedBy, PatientVisitResult.LastModifiedOn);

                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    if (PatientVisitResult.AssignedTo != null)
                    {

                        #region BARange

                        if (PatientVisitResult.ClaimStatusID == 2 || PatientVisitResult.ClaimStatusID == 3 || PatientVisitResult.ClaimStatusID == 4 || PatientVisitResult.ClaimStatusID == 5 || PatientVisitResult.ClaimStatusID == 6 || PatientVisitResult.ClaimStatusID == 7 || PatientVisitResult.ClaimStatusID == 8 || PatientVisitResult.ClaimStatusID == 9 || PatientVisitResult.ClaimStatusID == 10)
                        {

                            StringBuilder sb = new StringBuilder();
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(PatientVisitResult.Comment);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_BA_USERID, PatientVisitResult.TargetBAUserID
                                , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                            if (HasErr(patientVisitID, ctx))
                            {
                                RollbackDbTrans(ctx);

                                return false;
                            }


                        }

                        #endregion

                        #region QARange


                        if (PatientVisitResult.ClaimStatusID == 11 || PatientVisitResult.ClaimStatusID == 12 || PatientVisitResult.ClaimStatusID == 13 || PatientVisitResult.ClaimStatusID == 14 || PatientVisitResult.ClaimStatusID == 15 || PatientVisitResult.ClaimStatusID == 16)
                        {
                            if (item.TARGET_BA_USER == null)
                            {
                                ErrorMessage = "BA EMPTY";
                                RollbackDbTrans(ctx);
                                return false;
                            }
                            StringBuilder sb = new StringBuilder();
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(PatientVisitResult.Comment);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_QA_USERID, PatientVisitResult.TargetBAUserID
                                , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                            if (HasErr(patientVisitID, ctx))
                            {
                                RollbackDbTrans(ctx);

                                return false;
                            }


                        }

                        #endregion

                        #region EARange



                        if (PatientVisitResult.ClaimStatusID == 17 || PatientVisitResult.ClaimStatusID == 18 || PatientVisitResult.ClaimStatusID == 19 || PatientVisitResult.ClaimStatusID == 20 || PatientVisitResult.ClaimStatusID == 21 || PatientVisitResult.ClaimStatusID == 22 || PatientVisitResult.ClaimStatusID == 23 || PatientVisitResult.ClaimStatusID == 24 || PatientVisitResult.ClaimStatusID == 25 || PatientVisitResult.ClaimStatusID == 26 || PatientVisitResult.ClaimStatusID == 27 || PatientVisitResult.ClaimStatusID == 28)
                        {
                            if (item.TARGET_BA_USER == null && item.TARGET_QA_USER == null)
                            {
                                ErrorMessage = "BA & QA EMPTY";
                                RollbackDbTrans(ctx);
                                return false;
                            }

                            StringBuilder sb = new StringBuilder();
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(PatientVisitResult.Comment);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_EA_USERID, PatientVisitResult.TargetBAUserID
                                , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                            if (HasErr(patientVisitID, ctx))
                            {
                                RollbackDbTrans(ctx);

                                return false;
                            }


                        }

                        #endregion

                        #region Sent Claim

                        if (PatientVisitResult.ClaimStatusID == 30)
                        {
                            if (item.TARGET_BA_USER == null && item.TARGET_QA_USER == null && item.TARGET_EA_USER == null)
                            {
                                ErrorMessage = "BA & QA & EA EMPTY";
                                RollbackDbTrans(ctx);
                                return false;
                            }
                        }

                        #endregion

                    }
                    else
                    {
                        #region BARange

                        if (PatientVisitResult.ClaimStatusID == 2)
                        {
                            StringBuilder sb = new StringBuilder();

                            if (item.TARGET_BA_USERID != null)
                            {
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");
                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_BA_USERID, PatientVisitResult.TargetBAUserID
                                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }


                            }
                            else
                            {
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");

                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_BA_USERID, PatientVisitResult.TargetBAUserID
                                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }
                            }
                        }

                        #endregion

                        #region QARange

                        if (PatientVisitResult.ClaimStatusID == 11)
                        {
                            if (item.TARGET_BA_USER == null)
                            {
                                ErrorMessage = "BA EMPTY";
                                RollbackDbTrans(ctx);
                                return false;
                            }
                            if (item.TARGET_QA_USERID != null)
                            {

                                StringBuilder sb = new StringBuilder();
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");

                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_QA_USERID, PatientVisitResult.TargetBAUserID
                                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }


                            }
                            else
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");

                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                   , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                   , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_QA_USERID, PatientVisitResult.TargetBAUserID
                                   , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                   , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }

                            }
                        }
                        //else
                        //{
                        //    ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                        //       , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                        //       , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, PatientVisitResult.ClaimStatusID.ToString(), item.TARGET_QA_USERID, PatientVisitResult.TargetBAUserID
                        //       , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity, PatientVisitResult.Comment
                        //       , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                        //    if (HasErr(patientVisitID, ctx))
                        //    {
                        //        RollbackDbTrans(ctx);

                        //        return false;
                        //    }

                        //}

                        #endregion

                        #region EARange

                        if (item.TARGET_BA_USER == null && item.TARGET_QA_USER == null)
                        {
                            ErrorMessage = "BA & QA EMPTY";
                            RollbackDbTrans(ctx);
                            return false;
                        }
                        if (PatientVisitResult.ClaimStatusID == 17)
                        {

                            if (item.TARGET_EA_USERID != null)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");

                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                    , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                    , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_EA_USERID, PatientVisitResult.TargetBAUserID
                                    , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                    , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }


                            }
                            else
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append("<PatVisits>");
                                //
                                sb.Append("<PatVisit>");
                                sb.Append("<ClaimStsID>");
                                sb.Append(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE));
                                sb.Append("</ClaimStsID>");
                                sb.Append("<Cmnts>");
                                sb.Append(PatientVisitResult.Comment);
                                sb.Append("</Cmnts>");
                                sb.Append("</PatVisit>");

                                sb.Append("</PatVisits>");

                                ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                                   , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                                   , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_EA_USERID, PatientVisitResult.TargetBAUserID
                                   , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                                   , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                                if (HasErr(patientVisitID, ctx))
                                {
                                    RollbackDbTrans(ctx);

                                    return false;
                                }
                            }

                        }

                        else
                        {
                            StringBuilder sb = new StringBuilder();
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(PatientVisitResult.ClaimStatusID);
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(PatientVisitResult.Comment);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            ctx.usp_Update_PatientVisit(PatientVisitResult.PatientID, PatientVisitResult.DOS, PatientVisitResult.IllnessIndicatorID
                              , PatientVisitResult.IllnessIndicatorDate, PatientVisitResult.FacilityTypeID, PatientVisitResult.FacilityDoneID, PatientVisitResult.PrimaryClaimDiagnosisID, PatientVisitResult.DoctorNoteRelPath
                              , PatientVisitResult.SuperBillRelPath, PatientVisitResult.PatientVisitDesc, sb.ToString(), item.TARGET_EA_USERID, PatientVisitResult.TargetBAUserID
                              , PatientVisitResult.TargetQAUserID, PatientVisitResult.TargetEAUserID, PatientVisitResult.PatientVisitComplexity
                              , PatientVisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                            if (HasErr(patientVisitID, ctx))
                            {
                                RollbackDbTrans(ctx);

                                return false;
                            }
                        }



                        #endregion

                        #region Sent Claim

                        if (PatientVisitResult.ClaimStatusID == 30)
                        {
                            if (item.TARGET_BA_USER == null && item.TARGET_QA_USER == null && item.TARGET_EA_USER == null)
                            {
                                ErrorMessage = "BA & QA & EA EMPTY";
                                RollbackDbTrans(ctx);
                                return false;
                            }
                        }

                        #endregion
                    }

                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion
    }

    #endregion

    #region Class AssgClaimPrevVisits

    public class PreviousVisitViewModel : BaseSaveModel
    {
        #region Properties

        public DateTime CurrDOS { get; set; }

        public List<usp_GetPrevVisit_PatientVisit_Result> AllDOSResult { get; set; }

        public long PatientVisitID { get; set; }


        #endregion

        #region Abstract

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID == 0)
            {
                AllDOSResult = new List<usp_GetPrevVisit_PatientVisit_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    AllDOSResult = new List<usp_GetPrevVisit_PatientVisit_Result>(ctx.usp_GetPrevVisit_PatientVisit(PatientVisitID, pID));
                }
            }
        }

        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Public

        #endregion
    }

    #endregion

    # region Class Created Claims

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class CreatedClaimSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearch_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string StatusIDs { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string ErrorMsg { get; set; }


        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CreatedClaimSearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimProcess_Result> lst = new List<usp_GetByAZ_ClaimProcess_Result>(ctx.usp_GetByAZ_ClaimProcess(ClinicID, StatusIDs, null, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZ_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearch_ClaimProcess_Result>(ctx.usp_GetBySearch_ClaimProcess(ClinicID, StatusIDs, null, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion

        # region Public Methods

        /// <summary>
        /// //
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {

            UnassignedClaimSaveModel objSaveModel = new UnassignedClaimSaveModel();


            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion
    }

    #endregion

    #endregion

    # region Class Assigned Claims - QA

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimQASearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetBySearch_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 ClinicID { get; set; }
        public string statusIDs { get; set; }
        public Nullable<int> AssignedTo { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimQASearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimProcess_Result> lst = new List<usp_GetByAZ_ClaimProcess_Result>(ctx.usp_GetByAZ_ClaimProcess(ClinicID, statusIDs, AssignedTo, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZ_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearch_ClaimProcess_Result>(ctx.usp_GetBySearch_ClaimProcess(ClinicID, statusIDs, AssignedTo, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion
    }

    #endregion

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimQASaveModel : BaseSaveModel
    {
        #region Properties
        /// 
        /// </summary>
        public Nullable<long> PatientVisitID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Notes { get; set; }

        public string CommentForReadyToSend { get; set; }

        public string CommentForEAGenQ { get; set; }

        public string CommentForEAPerQ { get; set; }

        public string CommentForReAsgn { get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimQASaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            usp_GetByPkId_PatientVisit_Result patientVisitResult = null;

            using (EFContext ctx = new EFContext())
            {
                patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(PatientVisitID, true))).First();
            }

            ObjectParameter objParam = null;
            //string statsIDs = string.Empty;
            StringBuilder sb = new StringBuilder();

            if (patientVisitResult.TargetEAUserID.HasValue)
            {
                patientVisitResult.AssignedTo = patientVisitResult.TargetEAUserID;


                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForReadyToSend);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForEAGenQ);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(Notes);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE)));
            }
            else
            {
                patientVisitResult.AssignedTo = null;

                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(CommentForReadyToSend);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(Notes);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE)));
            }

            objParam = ObjParam("PatientVisitID", typeof(System.Int64), patientVisitResult.PatientVisitID);

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);



                #region READY TO SEND CLAIM status Save + QA General Queue Save

                ctx.usp_Update_PatientVisit(patientVisitResult.PatientID, patientVisitResult.DOS
                    , patientVisitResult.IllnessIndicatorID, patientVisitResult.IllnessIndicatorDate, patientVisitResult.FacilityTypeID
                    , patientVisitResult.FacilityDoneID, patientVisitResult.PrimaryClaimDiagnosisID, patientVisitResult.DoctorNoteRelPath
                    , patientVisitResult.SuperBillRelPath, patientVisitResult.PatientVisitDesc, sb.ToString()
                    , patientVisitResult.AssignedTo, patientVisitResult.TargetBAUserID, patientVisitResult.TargetQAUserID
                    , patientVisitResult.TargetEAUserID, patientVisitResult.PatientVisitComplexity
                    , patientVisitResult.IsActive, patientVisitResult.LastModifiedBy, patientVisitResult.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                #endregion

                CommitDbTrans(ctx);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool ReassignSave(int pUserID)
        {
            ObjectParameter objParam = null;

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                #region REASSIGNED_BY_QA_TO_BA

                usp_GetByPkId_PatientVisit_Result patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(PatientVisitID, true))).First();

                string statsIDs = string.Empty;
                StringBuilder sb = new StringBuilder();

                if (patientVisitResult.TargetBAUserID.HasValue)
                {
                    usp_GetByPkId_User_Result userRes = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(patientVisitResult.TargetBAUserID, true))).FirstOrDefault();


                    if (userRes == null) //user inactive
                    {
                        patientVisitResult.AssignedTo = null;
                        patientVisitResult.TargetBAUserID = null;

                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForReAsgn);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(Notes);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE)));
                    }
                    else
                    {
                        if (userRes.IsBlocked) //user temp blocked
                        {
                            patientVisitResult.AssignedTo = null;
                            patientVisitResult.TargetBAUserID = null;

                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForReAsgn);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(Notes);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");
                            //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE)));
                        }
                        else
                        {
                            patientVisitResult.AssignedTo = patientVisitResult.TargetBAUserID;
                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForReAsgn);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(Notes);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");

                            // statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE)));
                        }
                    }
                }
                else
                {
                    patientVisitResult.AssignedTo = null;
                    patientVisitResult.TargetBAUserID = null;

                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(CommentForReAsgn);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(Notes);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");
                    //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE)));
                }
                objParam = ObjParam("PatientVisitID", typeof(System.Int64), patientVisitResult.PatientVisitID);

                ctx.usp_Update_PatientVisit(
                      patientVisitResult.PatientID, patientVisitResult.DOS
                    , patientVisitResult.IllnessIndicatorID, patientVisitResult.IllnessIndicatorDate, patientVisitResult.FacilityTypeID
                    , patientVisitResult.FacilityDoneID, patientVisitResult.PrimaryClaimDiagnosisID, patientVisitResult.DoctorNoteRelPath
                    , patientVisitResult.SuperBillRelPath, patientVisitResult.PatientVisitDesc, sb.ToString()
                    , patientVisitResult.AssignedTo, patientVisitResult.TargetBAUserID, patientVisitResult.TargetQAUserID
                    , patientVisitResult.TargetEAUserID, patientVisitResult.PatientVisitComplexity
                    , patientVisitResult.IsActive, patientVisitResult.LastModifiedBy, patientVisitResult.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                #endregion

                CommitDbTrans(ctx);
            }
            return true;
        }

        #endregion



    }

    #endregion

    #endregion

    # region Class Assigned Claims - EA

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimEASearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetBySearch_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 ClinicID { get; set; }

        public string statusIDs { get; set; }

        /// <summary>
        /// Written by sai as a temporary soln
        ///If needed sharon can change
        /// </summary>
        public Int32 AssignedTo { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimEASearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimProcess_Result> lst = new List<usp_GetByAZ_ClaimProcess_Result>(ctx.usp_GetByAZ_ClaimProcess(ClinicID, statusIDs, AssignedTo, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZ_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearch_ClaimProcess_Result>(ctx.usp_GetBySearch_ClaimProcess(ClinicID, statusIDs, AssignedTo, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion
    }

    #endregion

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class AssignedClaimEASaveModel : BaseSaveModel
    {
        #region Properties
        /// 
        /// </summary>
        public Nullable<long> PatientVisitID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Notes { get; set; }

        public string statsIDs { get; set; }

        public string CommentForReasgn { get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public AssignedClaimEASaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter objParam = null;

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                #region REASSIGNED_BY_EA_TO_QA

                usp_GetByPkId_PatientVisit_Result patientVisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(PatientVisitID, true))).First();
                StringBuilder sb = new StringBuilder();

                if (patientVisitResult.TargetQAUserID.HasValue)
                {
                    usp_GetByPkId_User_Result userRes = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(patientVisitResult.TargetQAUserID, true))).FirstOrDefault();

                    if (userRes == null) //user inactive
                    {
                        patientVisitResult.AssignedTo = null;
                        patientVisitResult.TargetQAUserID = null;

                        sb.Append("<PatVisits>");
                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(CommentForReasgn);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        //
                        sb.Append("<PatVisit>");
                        sb.Append("<ClaimStsID>");
                        sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                        sb.Append("</ClaimStsID>");
                        sb.Append("<Cmnts>");
                        sb.Append(Notes);
                        sb.Append("</Cmnts>");
                        sb.Append("</PatVisit>");

                        sb.Append("</PatVisits>");

                        //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE)));
                    }
                    else
                    {
                        if (userRes.IsBlocked) //user temp blocked
                        {
                            patientVisitResult.AssignedTo = null;
                            patientVisitResult.TargetQAUserID = null;

                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForReasgn);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(Notes);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");
                            //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE)));
                        }
                        else
                        {
                            patientVisitResult.AssignedTo = patientVisitResult.TargetQAUserID;

                            sb.Append("<PatVisits>");
                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(CommentForReasgn);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            //
                            sb.Append("<PatVisit>");
                            sb.Append("<ClaimStsID>");
                            sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                            sb.Append("</ClaimStsID>");
                            sb.Append("<Cmnts>");
                            sb.Append(Notes);
                            sb.Append("</Cmnts>");
                            sb.Append("</PatVisit>");

                            sb.Append("</PatVisits>");
                            //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE)));
                        }
                    }
                }
                else
                {
                    patientVisitResult.AssignedTo = null;
                    patientVisitResult.TargetQAUserID = null;

                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(CommentForReasgn);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(Notes);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");
                    //statsIDs = string.Concat(Convert.ToString(Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA)), ", ", Convert.ToString(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE)));
                }

                objParam = ObjParam("PatientVisitID", typeof(System.Int64), patientVisitResult.PatientVisitID);

                ctx.usp_Update_PatientVisit(
                      patientVisitResult.PatientID, patientVisitResult.DOS
                    , patientVisitResult.IllnessIndicatorID, patientVisitResult.IllnessIndicatorDate, patientVisitResult.FacilityTypeID
                    , patientVisitResult.FacilityDoneID, patientVisitResult.PrimaryClaimDiagnosisID, patientVisitResult.DoctorNoteRelPath
                    , patientVisitResult.SuperBillRelPath, patientVisitResult.PatientVisitDesc, sb.ToString()
                    , patientVisitResult.AssignedTo, patientVisitResult.TargetBAUserID, patientVisitResult.TargetQAUserID
                    , patientVisitResult.TargetEAUserID, patientVisitResult.PatientVisitComplexity
                    , patientVisitResult.IsActive, patientVisitResult.LastModifiedBy, patientVisitResult.LastModifiedOn, pUserID, objParam);

                if (HasErr(objParam, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                #endregion

                CommitDbTrans(ctx);
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        # endregion

        #region Public


        #endregion


    }

    #endregion

    #endregion

    # region Class Unassigned Claims - QA

    # region Search

    public class UnassignedClaimQASearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetUnAssigned_PatientVisit_Result> PatientVisit
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ClinicID { get; set; }

        public string statusIDs { get; set; }

        public string _CommentForQAPerQ { get; set; }
        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> AssignedTo { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimQASearchModel()
        { }

        # endregion

        #region Abstract Methods


        protected override void FillByAZ(bool? pIsActive)
        {

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}

            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetUnAssigned_PatientVisit_Result>(ctx.usp_GetUnAssigned_PatientVisit(ClinicID, statusIDs, SearchName, DateFrom, DateTo, AssignedTo, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }


        #endregion

        #region Private Methods

        //public void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_PatientVisit_Result spRes = (new List<usp_GetDate_PatientVisit_Result>(ctx.usp_GetDate_PatientVisit(ClinicID, statusIDs, AssignedTo))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        # endregion

        # region Public Methods

        /// <summary>
        /// //
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            UnassignedClaimQASaveModel objSaveModel = new UnassignedClaimQASaveModel();
            objSaveModel.CommentForQAPerQ = _CommentForQAPerQ;

            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion

    }
    # endregion

    # region Save

    public class UnassignedClaimQASaveModel : BaseSaveModel
    {

        #region Properties

        public Int32 ClinicID { get; set; }

        public string CommentForQAPerQ { get; set; }

        //public usp_GetByPkId_PatientVisit_Result pClaimResult
        //{
        //    get;
        //    set;
        //}

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimQASaveModel()
        { }

        # endregion

        #region Abstract Methods


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Private Methods


        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(Int64 patVisitID, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {

                usp_GetByPkId_PatientVisit_Result visitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(patVisitID, pIsActive))).FirstOrDefault();

                if (visitResult == null)
                {
                    visitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                }

                EncryptAudit(visitResult.PatientVisitID, visitResult.LastModifiedBy, visitResult.LastModifiedOn);
                if (visitResult.AssignedTo == null && (visitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE) || visitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK)))
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(CommentForQAPerQ);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");

                    BeginDbTrans(ctx);
                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    ctx.usp_Update_PatientVisit(visitResult.PatientID, visitResult.DOS, visitResult.IllnessIndicatorID, visitResult.IllnessIndicatorDate
                    , visitResult.FacilityTypeID, visitResult.FacilityDoneID, visitResult.PrimaryClaimDiagnosisID, visitResult.DoctorNoteRelPath, visitResult.SuperBillRelPath, visitResult.PatientVisitDesc
                    , sb.ToString(), pUserID, visitResult.TargetBAUserID, pUserID, visitResult.TargetEAUserID, visitResult.PatientVisitComplexity
                    , visitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                    if (HasErr(patientVisitID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }


                    CommitDbTrans(ctx);
                }
                else
                {
                    return false;
                }
            }

            return true;
        }

        #endregion



    }

    #endregion

    # endregion

    # region Class Unassigned Claims - EA

    # region Search

    public class UnassignedClaimEASearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetUnAssigned_PatientVisit_Result> PatientVisit
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ClinicID { get; set; }

        public string StatusIDs { get; set; }

        public string _CommentForEAPerQ { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<int> AssignedTo { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimEASearchModel()
        { }

        # endregion

        #region Abstract Methods


        protected override void FillByAZ(bool? pIsActive)
        {

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}

            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetUnAssigned_PatientVisit_Result>(ctx.usp_GetUnAssigned_PatientVisit(ClinicID, StatusIDs, SearchName, DateFrom, DateTo, AssignedTo, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }


        #endregion

        #region Private Methods

        //public void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_PatientVisit_Result spRes = (new List<usp_GetDate_PatientVisit_Result>(ctx.usp_GetDate_PatientVisit(ClinicID, StatusIDs, AssignedTo))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        # endregion

        # region Public Methods

        /// <summary>
        /// //
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            UnassignedClaimEASaveModel objSaveModel = new UnassignedClaimEASaveModel();
            objSaveModel.CommentForEAPerQ = _CommentForEAPerQ;
            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion

    }
    # endregion

    # region Save

    public class UnassignedClaimEASaveModel : BaseSaveModel
    {

        #region Properties

        public Int32 ClinicID { get; set; }

        public string CommentForEAPerQ { get; set; }

        //public usp_GetByPkId_PatientVisit_Result pClaimResult
        //{
        //    get;
        //    set;
        //}

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UnassignedClaimEASaveModel()
        { }

        # endregion

        #region Abstract Methods

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="pID"></param>
        ///// <param name="pIsActive"></param>
        //protected override void FillByID(long pID, bool? pIsActive)
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        pClaimResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(pID, pIsActive))).FirstOrDefault();
        //        EncryptAudit(pClaimResult.PatientVisitID, pClaimResult.LastModifiedBy, pClaimResult.LastModifiedOn);
        //    }
        //    //throw new Exception("FillByID(long pID, bool? pIsActive)");
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            //ObjectParameter claimProcessID = ObjParam("ClaimProcess");
            //using (EFContext ctx = new EFContext())
            //{
            //    BeginDbTrans(ctx);
            //    ctx.usp_Insert_ClaimProcess(Claim.PatientVisitID, pUserID, claimProcessID);

            //    if (HasErr(claimProcessID, ctx))
            //    {
            //        RollbackDbTrans(ctx);

            //        return false;
            //    }

            //    ObjectParameter patientVisitID = ObjParam("PatientVisit");

            //    ctx.usp_Update_PatientVisit(Claim.PatientID, Claim.PatientHospitalizationID, Claim.DOS, Claim.IllnessIndicatorID, Claim.IllnessIndicatorDate
            //    , Claim.FacilityTypeID, Claim.FacilityDoneID, Claim.PrimaryClaimDiagnosisID, Claim.DoctorNoteRelPath, Claim.SuperBillRelPath, Claim.PatientVisitDesc
            //    , Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE), pUserID, pUserID, Claim.TargetQAUserID, Claim.TargetEAUserID, Claim.PatientVisitComplexity, Claim.Comment
            //    , Claim.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

            //    if (HasErr(patientVisitID, ctx))
            //    {
            //        RollbackDbTrans(ctx);

            //        return false;
            //    }

            //    CommitDbTrans(ctx);
            //}

            //return true;

            throw new NotImplementedException();


        }
        #endregion

        #region Private Methods


        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(Int64 patVisitID, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {

                usp_GetByPkId_PatientVisit_Result visitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(patVisitID, pIsActive))).FirstOrDefault();

                if (visitResult == null)
                {
                    visitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                }

                EncryptAudit(visitResult.PatientVisitID, visitResult.LastModifiedBy, visitResult.LastModifiedOn);

                if (visitResult.AssignedTo == null && (visitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE) || visitResult.ClaimStatusID == Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK)))
                {

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(CommentForEAPerQ);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");

                    BeginDbTrans(ctx);
                    ObjectParameter patientVisitID = ObjParam("PatientVisit");

                    ctx.usp_Update_PatientVisit(visitResult.PatientID, visitResult.DOS, visitResult.IllnessIndicatorID, visitResult.IllnessIndicatorDate
                    , visitResult.FacilityTypeID, visitResult.FacilityDoneID, visitResult.PrimaryClaimDiagnosisID, visitResult.DoctorNoteRelPath, visitResult.SuperBillRelPath, visitResult.PatientVisitDesc
                    , sb.ToString(), pUserID, visitResult.TargetBAUserID, visitResult.TargetQAUserID, pUserID, visitResult.PatientVisitComplexity
                    , visitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                    if (HasErr(patientVisitID, ctx))
                    {
                        RollbackDbTrans(ctx);

                        return false;
                    }

                    CommitDbTrans(ctx);
                }
                else
                {
                    return false;
                }
            }

            return true;
        }

        #endregion



    }

    #endregion

    # endregion

    #region Class CaseComplexity

    # region Search

    /// <summary>
    /// By Sai : Manager Role : Case Complexity
    /// </summary>
    public class CaseComplexitySearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Nullable<int> ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ErrorMsg { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_PatientVisit_Result> PatientVisit { get; set; }


        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseComplexitySearchModel()
        {
        }

        # endregion

        #region publicmethods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_PatientVisit_Result> lst = new List<usp_GetByAZ_PatientVisit_Result>(ctx.usp_GetByAZ_PatientVisit(ClinicID, SearchName, DateFrom, DateTo, null));

                foreach (usp_GetByAZ_PatientVisit_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}

            using (EFContext ctx = new EFContext())
            {
                PatientVisit = new List<usp_GetBySearch_PatientVisit_Result>(ctx.usp_GetBySearch_PatientVisit(Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), ClinicID, null, SearchName, DateFrom, DateTo, null, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            PatientVisitSaveModel objSaveModel = new PatientVisitSaveModel();
            if (!(objSaveModel.Save(PatientVisit, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public usp_GetNameByPatientVisitID_Patient_Result GetChartByID(Nullable<bool> isActive)
        {
            usp_GetNameByPatientVisitID_Patient_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetNameByPatientVisitID_Patient_Result>(ctx.usp_GetNameByPatientVisitID_Patient(CurrNumber, isActive))).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetNameByPatientVisitID_Patient_Result();
            }

            return retAns;
        }

        #region Private Methods

        ///// <summary>
        ///// 
        ///// </summary>
        //private void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_PatientVisit_Result spRes = (new List<usp_GetDate_PatientVisit_Result>(ctx.usp_GetDate_PatientVisit(ClinicID, Convert.ToString(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE)), AssignedTo))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        # endregion

        #endregion

    }
    #endregion



    #endregion

    #region CaseReClose

    # region Search

    /// <summary>
    /// By Sai:Manager Role - Case Reclose Search - Reclosing the already reoopened case in Manager Case Reopen page
    /// </summary>
    public class CaseReCloseSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearchCaseReopen_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        ///Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Range of claim status ids to be passed into the Patient.PatientVisit table
        /// </summary>
        public string StatusIDs { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string ErrorMsg { get; set; }


        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseReCloseSearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZCaseReopen_ClaimProcess_Result> lst = new List<usp_GetByAZCaseReopen_ClaimProcess_Result>(ctx.usp_GetByAZCaseReopen_ClaimProcess(ClinicID, null, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZCaseReopen_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearchCaseReopen_ClaimProcess_Result>(ctx.usp_GetBySearchCaseReopen_ClaimProcess(ClinicID, null, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {

            CaseReCloseSaveModel objSaveModel = new CaseReCloseSaveModel();
            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion
    }

    #endregion


    # region Save

    /// <summary>
    /// By Sai:Manager Role - Case Reclose- Reclosing - Reclosing the already reoopened case in Manager Case Reopen page
    /// </summary>
    public class CaseReCloseSaveModel : BaseSaveModel
    {

        #region Properties

        /// <summary>
        ///Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_PatientVisit_Result VisitResult { get; set; }

        //public usp_GetByPkId_PatientVisit_Result pClaimResult
        //{
        //    get;
        //    set;
        //}

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseReCloseSaveModel()
        { }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Private Methods


        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(Int64 patVisitID, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                VisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(patVisitID, pIsActive))).FirstOrDefault();

                if (VisitResult == null)
                {
                    VisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                }



                EncryptAudit(VisitResult.PatientVisitID, VisitResult.LastModifiedBy, VisitResult.LastModifiedOn);

                StringBuilder sb = new StringBuilder();
                sb.Append("<PatVisits>");
                //
                sb.Append("<PatVisit>");
                sb.Append("<ClaimStsID>");
                sb.Append(Convert.ToByte(ClaimStatus.DONE));
                sb.Append("</ClaimStsID>");
                sb.Append("<Cmnts>");
                sb.Append(VisitResult.Comment);
                sb.Append("</Cmnts>");
                sb.Append("</PatVisit>");

                sb.Append("</PatVisits>");

                ObjectParameter patientVisitID = ObjParam("PatientVisit");

                ctx.usp_Update_PatientVisit(VisitResult.PatientID, VisitResult.DOS, VisitResult.IllnessIndicatorID, VisitResult.IllnessIndicatorDate
                , VisitResult.FacilityTypeID, VisitResult.FacilityDoneID, VisitResult.PrimaryClaimDiagnosisID, VisitResult.DoctorNoteRelPath, VisitResult.SuperBillRelPath, VisitResult.PatientVisitDesc
                , sb.ToString(), pUserID, VisitResult.TargetBAUserID, VisitResult.TargetQAUserID, VisitResult.TargetEAUserID, VisitResult.PatientVisitComplexity
                , VisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);

                if (HasErr(patientVisitID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;

                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion


    }

    #endregion

    #endregion

    #region CaseReopen
    #region Search

    /// <summary>
    /// By Sai:Manager Role - Case Reopen - Search - Reopening already CREATED claims
    /// </summary>
    public class CaseReopenSearchModel : BaseSearchModel
    {
        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearch_ClaimProcess_Result> Claims
        {
            get;
            set;
        }

        /// <summary>
        ///Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Range of claim status ids to be passed into the Patient.PatientVisit table
        /// </summary>
        public string StatusIDs { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string ErrorMsg { get; set; }


        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseReopenSearchModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_ClaimProcess_Result> lst = new List<usp_GetByAZ_ClaimProcess_Result>(ctx.usp_GetByAZ_ClaimProcess(ClinicID, StatusIDs, null, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZ_ClaimProcess_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                //StartBy = "";
                Claims = new List<usp_GetBySearch_ClaimProcess_Result>(ctx.usp_GetBySearch_ClaimProcess(ClinicID, StatusIDs, null, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }


        #endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            CaseReopenSaveModel objSaveModel = new CaseReopenSaveModel();
            if (!(objSaveModel.Save(CurrNumber, pUserID, pIsActive)))
            {
                ErrorMsg = objSaveModel.ErrorMsg;
                return false;
            }

            return true;
        }

        # endregion
    }
    #endregion

    #region Save

    /// <summary>
    /// By Sai:Manager Role - Case Reopen - Search - Reopening already CREATED claims
    /// </summary>
    public class CaseReopenSaveModel : BaseSaveModel
    {

        #region Properties

        /// <summary>
        ///Clinic assigned to the manager(Primary Key of Billing.Clinic table)
        /// </summary>
        public Int32 ClinicID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_PatientVisit_Result VisitResult { get; set; }

        //public usp_GetByPkId_PatientVisit_Result pClaimResult
        //{
        //    get;
        //    set;
        //}

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseReopenSaveModel()
        { }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }
        #endregion

        #region Private Methods


        # endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUnAssignedResult"></param>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(Int64 patVisitID, int pUserID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                VisitResult = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(patVisitID, pIsActive))).FirstOrDefault();

                if (VisitResult == null)
                {
                    VisitResult = new usp_GetByPkId_PatientVisit_Result() { IsActive = true };
                }

                EncryptAudit(VisitResult.PatientVisitID, VisitResult.LastModifiedBy, VisitResult.LastModifiedOn);


                BeginDbTrans(ctx);

                ObjectParameter patientVisitID = ObjParam("PatientVisit");

                usp_GetByPkId_User_Result UserResult = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(VisitResult.TargetBAUserID, true))).FirstOrDefault();

                StringBuilder sb = new StringBuilder();

                if (UserResult == null)
                {

                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(VisitResult.Comment);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");

                    ctx.usp_Update_PatientVisit(VisitResult.PatientID, VisitResult.DOS, VisitResult.IllnessIndicatorID, VisitResult.IllnessIndicatorDate
                   , VisitResult.FacilityTypeID, VisitResult.FacilityDoneID, VisitResult.PrimaryClaimDiagnosisID, VisitResult.DoctorNoteRelPath, VisitResult.SuperBillRelPath, VisitResult.PatientVisitDesc
                   , sb.ToString(), null, null, VisitResult.TargetQAUserID, VisitResult.TargetEAUserID, VisitResult.PatientVisitComplexity
                   , VisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);
                }
                else
                {
                    sb.Append("<PatVisits>");
                    //
                    sb.Append("<PatVisit>");
                    sb.Append("<ClaimStsID>");
                    sb.Append(Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE));
                    sb.Append("</ClaimStsID>");
                    sb.Append("<Cmnts>");
                    sb.Append(VisitResult.Comment);
                    sb.Append("</Cmnts>");
                    sb.Append("</PatVisit>");

                    sb.Append("</PatVisits>");

                    ctx.usp_Update_PatientVisit(VisitResult.PatientID, VisitResult.DOS, VisitResult.IllnessIndicatorID, VisitResult.IllnessIndicatorDate
                    , VisitResult.FacilityTypeID, VisitResult.FacilityDoneID, VisitResult.PrimaryClaimDiagnosisID, VisitResult.DoctorNoteRelPath, VisitResult.SuperBillRelPath, VisitResult.PatientVisitDesc
                    , sb.ToString(), VisitResult.TargetBAUserID, VisitResult.TargetBAUserID, VisitResult.TargetQAUserID, VisitResult.TargetEAUserID, VisitResult.PatientVisitComplexity
                    , VisitResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, patientVisitID);
                }

                if (HasErr(patientVisitID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);

            }

            return true;
        }

        #endregion
    }

    #endregion

    #endregion

    #region Case
    /// <summary>
    /// Manager Role-Case : For viewing all the cases irrespective of their status
    /// </summary>
    # region Search
    public class CaseSearchModel : BaseSearchModel
    {

        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public Int32 UserID { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public string ErrorMsg { get; set; }

        public List<usp_GetBySearchCase_PatientVisit_Result> CaseSearch { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public CaseSearchModel()
        {
        }

        # endregion

        #region Abstract
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZCase_PatientVisit_Result> lst = new List<usp_GetByAZCase_PatientVisit_Result>(ctx.usp_GetByAZCase_PatientVisit(0, SearchName, DateFrom, DateTo));

                foreach (usp_GetByAZCase_PatientVisit_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });

                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                CaseSearch = new List<usp_GetBySearchCase_PatientVisit_Result>(ctx.usp_GetBySearchCase_PatientVisit(0, SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }

        #endregion



    }
    #endregion

    #endregion

}
