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
    
    public partial class usp_GetByPkId_Password_Result
    {
        public byte PasswordID { get; set; }
        public byte MinLength { get; set; }
        public byte MaxLength { get; set; }
        public byte UpperCaseMinCount { get; set; }
        public byte NumberMinCount { get; set; }
        public byte SplCharCount { get; set; }
        public byte ExpiryDayMaxCount { get; set; }
        public byte TrialMaxCount { get; set; }
        public byte HistoryReuseStatus { get; set; }
        public bool IsActive { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
    }
}
