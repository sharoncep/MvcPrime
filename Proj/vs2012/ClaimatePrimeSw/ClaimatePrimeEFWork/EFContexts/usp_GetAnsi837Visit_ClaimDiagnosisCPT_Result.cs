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
    
    public partial class usp_GetAnsi837Visit_ClaimDiagnosisCPT_Result
    {
        public long ID { get; set; }
        public long CLAIM_NUMBER { get; set; }
        public string DX_CODE { get; set; }
        public byte ICD_FORMAT { get; set; }
        public Nullable<long> CLAIM_DIAGNOSIS_CPT_ID { get; set; }
        public string CPT_CODE { get; set; }
        public string FACILITY_TYPE_CODE { get; set; }
        public Nullable<int> UNIT { get; set; }
        public Nullable<decimal> CHARGE_PER_UNIT { get; set; }
        public bool IS_HCPCS_CODE { get; set; }
        public Nullable<System.DateTime> CPT_DOS { get; set; }
        public string MODI1_CODE { get; set; }
        public string MODI2_CODE { get; set; }
        public string MODI3_CODE { get; set; }
        public string MODI4_CODE { get; set; }
    }
}
