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
    
    public partial class usp_GetBySearch_PatientHospitalization_Result
    {
        public long PatientHospitalizationID { get; set; }
        public string Name { get; set; }
        public System.DateTime AdmittedOn { get; set; }
        public Nullable<System.DateTime> DischargedOn { get; set; }
        public string FacilityDoneName { get; set; }
        public string ChartNumber { get; set; }
        public bool IsActive { get; set; }
    }
}
