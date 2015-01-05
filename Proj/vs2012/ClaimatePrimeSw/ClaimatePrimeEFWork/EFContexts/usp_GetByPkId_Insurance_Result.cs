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
    
    public partial class usp_GetByPkId_Insurance_Result
    {
        public int InsuranceID { get; set; }
        public string InsuranceCode { get; set; }
        public string InsuranceName { get; set; }
        public string PayerID { get; set; }
        public byte InsuranceTypeID { get; set; }
        public int EDIReceiverID { get; set; }
        public byte PrintPinID { get; set; }
        public byte PatientPrintSignID { get; set; }
        public byte InsuredPrintSignID { get; set; }
        public byte PhysicianPrintSignID { get; set; }
        public string StreetName { get; set; }
        public string Suite { get; set; }
        public int CityID { get; set; }
        public int StateID { get; set; }
        public Nullable<int> CountyID { get; set; }
        public int CountryID { get; set; }
        public string PhoneNumber { get; set; }
        public Nullable<int> PhoneNumberExtn { get; set; }
        public string SecondaryPhoneNumber { get; set; }
        public Nullable<int> SecondaryPhoneNumberExtn { get; set; }
        public string Email { get; set; }
        public string SecondaryEmail { get; set; }
        public string Fax { get; set; }
        public string Comment { get; set; }
        public bool IsActive { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
    }
}
