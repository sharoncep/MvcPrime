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
    
    public partial class usp_GetReportSumYr_PatientVisit_Result
    {
        public byte ID { get; set; }
        public string X_AXIS_NAME { get; set; }
        public long VISITS { get; set; }
        public long IN_PROGRESS { get; set; }
        public long READY_TO_SEND { get; set; }
        public long SENT { get; set; }
        public long DONE { get; set; }
    }
}