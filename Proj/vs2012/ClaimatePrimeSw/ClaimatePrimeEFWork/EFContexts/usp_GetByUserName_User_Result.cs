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
    
    public partial class usp_GetByUserName_User_Result
    {
        public int UserID { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public string FirstName { get; set; }
        public string PhoneNumber { get; set; }
        public Nullable<int> ManagerID { get; set; }
        public string PhotoRelPath { get; set; }
        public bool AlertChangePassword { get; set; }
        public string Comment { get; set; }
        public bool IsBlocked { get; set; }
        public bool IsActive { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedOn { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedOn { get; set; }
    }
}
