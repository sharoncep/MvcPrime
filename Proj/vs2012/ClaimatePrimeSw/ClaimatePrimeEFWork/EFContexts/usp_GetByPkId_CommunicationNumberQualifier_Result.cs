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
    
    public partial class usp_GetByPkId_CommunicationNumberQualifier_Result
    {
        public byte CommunicationNumberQualifierID { get; set; }
        public string CommunicationNumberQualifierCode { get; set; }
        public string CommunicationNumberQualifierName { get; set; }
        public string Comment { get; set; }
        public bool IsActive { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
    }
}
