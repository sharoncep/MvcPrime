using System;
using System.Runtime.Serialization;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeEFWork;
using ClaimatePrimeModels.Models;
using System.Web.Mvc;
using System.Web;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeConstants;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class VisitResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ANTI_FORG_TOKN { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_VISIT_ID { get; private set; }


        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<long> PATIENT_HOSPITALIZATION_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String HOSPITAL_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public int HOSPITAL_NAME_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public System.String DOS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<byte> ILLNESS_INDICATOR_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String ILLNESS_INDICATOR_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public System.String ILLNESS_INDICATOR_DATE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte FACILITY_TYPE_OWN_CLINIC_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte FACILITY_TYPE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String FACILITY_TYPE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> FACILITY_DONE_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String FACILITY_DONE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<long> PRIMARY_CASE_DIAGNOSIS_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TMP_URL_DR_NOTE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_SRC_DR_NOTE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_PRINT_SRC_DR_NOTE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TMP_URL_SUP_BILL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_SRC_SUP_BILL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_PRINT_SRC_SUP_BILL { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String FACILITY_DONE_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string PATIENT_VISIT_DESC { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte CLAIM_STATUS_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> ASSIGNED_TO { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COMMENT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Boolean IS_ACTIVE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte PATIENT_VISIT_COMPLEXITY { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> TARGET_BA_USER_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> TARGET_QA_USER_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<int> TARGET_EA_USER_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLAIM_STATUS_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String PRIMARY_DX_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String TARGET_BA_USER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String TARGET_QA_USER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String TARGET_EA_USER { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String ASSIGNED_TO_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 DX_COUNT
        {
            get;
            set;
        }

        #endregion

        # region Constructors

        # endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <param name="pCtrlName"></param>
        /// <returns></returns>
        public static explicit operator VisitResult(PatientVisitSaveModel pResult)
        {
            return (new VisitResult()
            {
                ANTI_FORG_TOKN = pResult.AntiForgTokn
                ,
                PATIENT_VISIT_ID = pResult.PatientVisitResult.PatientVisitID
                ,
                PATIENT_ID = pResult.PatientVisitResult.PatientID
                ,
                PATIENT_HOSPITALIZATION_ID = pResult.PatientVisitResult.PatientHospitalizationID
                ,
                HOSPITAL_NAME = pResult.PatientVisitResult_PatientHospitalization
                ,
                HOSPITAL_NAME_ID = pResult.HospitalID
                ,
                DOS = StaticClass.GetDateStr(pResult.PatientVisitResult.DOS)
                ,
                ILLNESS_INDICATOR_ID = pResult.PatientVisitResult.IllnessIndicatorID
                ,
                ILLNESS_INDICATOR_NAME = pResult.PatientVisitResult_IllnessIndicator
                ,
                ILLNESS_INDICATOR_DATE = StaticClass.GetDateStr(pResult.PatientVisitResult.IllnessIndicatorDate)
                ,
                FACILITY_TYPE_OWN_CLINIC_ID = Convert.ToByte(FacilityType.OFFICE)
                ,
                FACILITY_TYPE_ID = pResult.PatientVisitResult.FacilityTypeID
                ,
                FACILITY_TYPE = pResult.PatientVisitResult_FacilityType
                ,
                FACILITY_DONE_ID = pResult.PatientVisitResult.FacilityDoneID
                ,
                FACILITY_DONE = (pResult.PatientVisitResult.FacilityTypeID == Convert.ToByte(FacilityType.OFFICE)) ? string.IsNullOrWhiteSpace(ArivaSession.Sessions().SelClinicDispName) ? pResult.SelClinicDispName : (ArivaSession.Sessions().SelClinicDispName) : pResult.PatientVisitResult_FacilityDone
                ,
                PRIMARY_CASE_DIAGNOSIS_ID = pResult.PatientVisitResult.PrimaryClaimDiagnosisID
                ,
                PRIMARY_DX_NAME = pResult.PrimaryDxName
                ,
                TMP_URL_DR_NOTE = string.Concat(StaticClass.SiteURL, "ReportTmp/DN", ArivaSession.Sessions().UserID, ".pdf?ky=", StaticClass.GetUniqueStr())
                ,
                IMG_SRC_DR_NOTE = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveDrNotePreview"))
                ,
                IMG_PRINT_SRC_DR_NOTE = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveDrNote"))
                ,
                TMP_URL_SUP_BILL = string.Concat(StaticClass.SiteURL, "ReportTmp/SB", ArivaSession.Sessions().UserID, ".pdf?ky=", StaticClass.GetUniqueStr())
                ,
                IMG_SRC_SUP_BILL = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveSupBillPreview"))
                ,
                IMG_PRINT_SRC_SUP_BILL = (new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveSupBill"))
                ,
                FACILITY_DONE_NAME = string.IsNullOrWhiteSpace(pResult.PatientVisitResult_FacilityDone) ? string.Empty : (pResult.PatientVisitResult_FacilityDone)
                ,
                PATIENT_VISIT_DESC = string.IsNullOrWhiteSpace(pResult.PatientVisitResult.PatientVisitDesc) ? string.Empty : (pResult.PatientVisitResult.PatientVisitDesc)
                ,
                CLAIM_STATUS_ID = pResult.PatientVisitResult.ClaimStatusID
                ,
                ASSIGNED_TO = pResult.PatientVisitResult.AssignedTo
                ,
                COMMENT = pResult.PatientVisitResult.Comment
                ,
                IS_ACTIVE = pResult.PatientVisitResult.IsActive
                ,
                PATIENT_VISIT_COMPLEXITY = pResult.PatientVisitResult.PatientVisitComplexity
                ,
                TARGET_BA_USER_ID = pResult.PatientVisitResult.TargetBAUserID
                ,
                TARGET_BA_USER = string.IsNullOrWhiteSpace(pResult.Target_BA_User) ? string.Empty : (pResult.Target_BA_User)
                ,
                TARGET_EA_USER_ID = pResult.PatientVisitResult.TargetEAUserID
                ,
                TARGET_EA_USER = string.IsNullOrWhiteSpace(pResult.Target_EA_User) ? string.Empty : (pResult.Target_EA_User)
                ,
                TARGET_QA_USER_ID = pResult.PatientVisitResult.TargetQAUserID
                ,
                TARGET_QA_USER = string.IsNullOrWhiteSpace(pResult.Target_QA_User) ? string.Empty : (pResult.Target_QA_User)
                ,
                CLAIM_STATUS_NAME = Converts.AsEnum<ClaimStatus>(pResult.PatientVisitResult.ClaimStatusID).ToString().Replace('_', ' ')
                ,
                ASSIGNED_TO_NAME = string.IsNullOrWhiteSpace(pResult.AssignedToName) ? string.Empty : (pResult.AssignedToName)
                ,
                DX_COUNT = pResult.PatientVisitResult.DX_COUNT.HasValue ? pResult.PatientVisitResult.DX_COUNT.Value : 0
            });
        }

        # endregion
    }
}
