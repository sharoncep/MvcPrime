//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClaimatePrimeEFWork.EFContexts
{
    using System;
    
    public partial class usp_GetByPkId_PatientVisit_Result
    {
        public long PatientVisitID { get; set; }
        public long PatientID { get; set; }
        public Nullable<long> PatientHospitalizationID { get; set; }
        public System.DateTime DOS { get; set; }
        public byte IllnessIndicatorID { get; set; }
        public System.DateTime IllnessIndicatorDate { get; set; }
        public byte FacilityTypeID { get; set; }
        public Nullable<int> FacilityDoneID { get; set; }
        public Nullable<long> PrimaryClaimDiagnosisID { get; set; }
        public string DoctorNoteRelPath { get; set; }
        public string SuperBillRelPath { get; set; }
        public string PatientVisitDesc { get; set; }
        public byte ClaimStatusID { get; set; }
        public Nullable<int> AssignedTo { get; set; }
        public Nullable<int> TargetBAUserID { get; set; }
        public Nullable<int> TargetQAUserID { get; set; }
        public Nullable<int> TargetEAUserID { get; set; }
        public byte PatientVisitComplexity { get; set; }
        public string Comment { get; set; }
        public bool IsActive { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public Nullable<int> DX_COUNT { get; set; }
    }
}
