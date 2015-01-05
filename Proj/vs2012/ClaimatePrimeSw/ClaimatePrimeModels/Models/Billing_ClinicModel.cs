using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{
    #region Billing/Clinic-Assigned Claim

    public class BillingClinicViewModel : BaseSaveModel
    {
        #region Properties

        public usp_GetByPkId_FacilityDone_Result FacilityDoneResult { get; set; }

        public usp_GetByPkId_Clinic_Result ClinicResult { get; set; }

        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string CountyName { get; set; }

        public string StateName { get; set; }

        public string IpaName { get; set; }

        public string EntityTypeQualifierName { get; set; }

        public string SpecialtyName { get; set; }

        public string ManagerName { get; set; }

        #endregion

        #region Abstract



        protected override void FillByID(int pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    ClinicResult = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(pID, true))).FirstOrDefault();
                }
            }

            if (ClinicResult == null)
            {
                ClinicResult = new usp_GetByPkId_Clinic_Result() { IsActive = true };
            }

            # region IPA

            if (ClinicResult.IPAID > 0)
            {
                usp_GetNameByID_IPA_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_IPA_Result>(ctx.usp_GetNameByID_IPA(ClinicResult.IPAID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IpaName = stateRes.NAME_CODE;
                }
            }

            # endregion

            # region EntityTypeQualifier

            if (ClinicResult.EntityTypeQualifierID > 0)
            {
                usp_GetNameByID_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_EntityTypeQualifier_Result>(ctx.usp_GetNameByID_EntityTypeQualifier(ClinicResult.EntityTypeQualifierID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    EntityTypeQualifierName = stateRes.NAME_CODE;
                }
            }

            # endregion

            # region Specialty

            if (ClinicResult.SpecialtyID > 0)
            {
                usp_GetNameByID_Specialty_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_Specialty_Result>(ctx.usp_GetNameByID_Specialty(ClinicResult.SpecialtyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    SpecialtyName = stateRes.NAME_CODE;
                }
            }

            # endregion

            # region Manager
            //commented by sharon
            //if (ClinicResult.ManagerID > 0)
            //{
            //    usp_GetNameByID_User_Result stateRes = null;

            //    using (EFContext ctx = new EFContext())
            //    {
            //        stateRes = (new List<usp_GetNameByID_User_Result>(ctx.usp_GetNameByID_User(ClinicResult.ManagerID, null))).FirstOrDefault();
            //    }

            //    if (stateRes != null)
            //    {
            //        ManagerName = stateRes.NAME_CODE;
            //    }
            //}

            # endregion

            # region City

            if (ClinicResult.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(ClinicResult.CityID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CityName = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (ClinicResult.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(ClinicResult.CountryID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountryName = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (ClinicResult.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(ClinicResult.CountyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountyName = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (ClinicResult.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(ClinicResult.StateID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    StateName = string.Concat(stateRes.StateName + " [", stateRes.StateCode, "]");
                }
            }

            # endregion
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
        public void FillByPkID(Int32 pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    FacilityDoneResult = (new List<usp_GetByPkId_FacilityDone_Result>(ctx.usp_GetByPkId_FacilityDone(pID, true))).FirstOrDefault();
                }
            }

            if (FacilityDoneResult == null)
            {
                FacilityDoneResult = new usp_GetByPkId_FacilityDone_Result() { IsActive = true };
            }
        }
        #endregion

    }


    #endregion

    #region ClinicSearchModel

    /// <summary>
    /// By Sai : Manager Role - Clinic Setup - Search
    /// </summary>
    public class ClinicSearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_Clinic_Result> Clinic
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public int UserID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetCount_Clinic_Result ClinicCount
        {
            get;
            set;
        }

        # endregion

        #region Constructors


        /// <summary>
        /// 
        /// </summary>
        public ClinicSearchModel()
        {
        }

        #endregion

        #region Public Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public usp_GetByPkId_Clinic_Result GetByPkIdClinic(Nullable<global::System.Int32> clinicID, Nullable<global::System.Boolean> isActive)
        {
            usp_GetByPkId_Clinic_Result retAns = null;

            if (clinicID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(clinicID, isActive))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Clinic_Result();
            }

            return retAns;
        }

        public void FillClinicCount()
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicCount = new List<usp_GetCount_Clinic_Result>(ctx.usp_GetCount_Clinic(UserID)).FirstOrDefault();
            }
        }


        #endregion

        # region Private Method
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Clinic_Result> lst = new List<usp_GetByAZ_Clinic_Result>(ctx.usp_GetByAZ_Clinic(UserID, true));

                foreach (usp_GetByAZ_Clinic_Result item in lst)
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
                Clinic = new List<usp_GetBySearch_Clinic_Result>(ctx.usp_GetBySearch_Clinic(UserID, StartBy, true));
            }
        }
        # endregion
    }

    #endregion

    #region ClinicSearchManagerModel

    public class ClinicSearchManagerModel : BaseSearchModel
    {
        # region Properties



        public List<usp_GetBySearch_Clinic_Result> Clinic
        {
            get;
            set;
        }
        public int UserID
        {
            get;
            set;
        }

        public usp_GetCount_Clinic_Result ClinicCount
        {
            get;
            set;
        }

        # endregion

        #region Constructors


        /// <summary>
        /// 
        /// </summary>
        public ClinicSearchManagerModel()
        {
        }

        #endregion

        #region Public Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public usp_GetByPkId_Clinic_Result GetByPkIdClinic(Nullable<global::System.Int32> clinicID, Nullable<global::System.Boolean> isActive)
        {
            usp_GetByPkId_Clinic_Result retAns = null;

            if (clinicID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(clinicID, isActive))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Clinic_Result();
            }

            return retAns;
        }

        public void FillClinicCount()
        {
            using (EFContext ctx = new EFContext())
            {
                ClinicCount = new List<usp_GetCount_Clinic_Result>(ctx.usp_GetCount_Clinic(UserID)).FirstOrDefault();
            }
        }

        /// <summary>
        /// for getting role id==>add new in manageclinic should be displayed only in manager side
        /// </summary>
        /// <param name="userid"></param>
        /// <returns></returns>
        public byte GetRoleID(int userid)
        {
            usp_GetByUserID_UserRole_Result spres;
            using (EFContext ctx = new EFContext())
            {
                spres = new List<usp_GetByUserID_UserRole_Result>(ctx.usp_GetByUserID_UserRole(UserID)).FirstOrDefault();
            }
            return spres.RoleID;
        }
        #endregion

        # region Private Method
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Clinic_Result> lst = new List<usp_GetByAZ_Clinic_Result>(ctx.usp_GetByAZ_Clinic(UserID, null));

                foreach (usp_GetByAZ_Clinic_Result item in lst)
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
                Clinic = new List<usp_GetBySearch_Clinic_Result>(ctx.usp_GetBySearch_Clinic(UserID, StartBy, null));
            }
        }
        # endregion
    }

    #endregion

    # region ClinicSaveModel

    /// <summary>
    ///   By Sai : Admin Role or Manager Role - Practice Clinic or Manage Clinic - Edit/Save/Delete
    /// </summary>
    public class ClinicSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public usp_GetByPkId_Clinic_Result ClinicResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetByClinicID_UserClinic_Result> UserClinicResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public usp_GetByPkId_User_Result UserResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public Int64 StateID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public string UserResult_User
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public Int32 ClinicID
        {
            get;
            set;
        }


        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_State
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_Country
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_County
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_City
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_IPA
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_EntityTypeQualifier
        {
            get;
            set;
        }


        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ClinicResult_Specialty
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

        public global::System.Byte ManagerCount
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Byte ErrorNo
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrClinicPhotoPath
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public ClinicSaveModel()
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
            ObjectParameter clinicid = ObjParam("Clinic");
            ObjectParameter userclinicid = ObjParam("UserClinic");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (!(string.IsNullOrWhiteSpace(ClinicResult.LogoRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Billing", "Clinic"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrClinicPhotoPath = string.Concat(FileSvrClinicPhotoPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrClinicPhotoPath))
                    {
                        Directory.Delete(FileSvrClinicPhotoPath, true);
                    }
                    Directory.CreateDirectory(FileSvrClinicPhotoPath);

                    FileSvrClinicPhotoPath = string.Concat(FileSvrClinicPhotoPath, @"\", "U_1", Path.GetExtension(ClinicResult.LogoRelPath));   // File Uploading
                    if (File.Exists(FileSvrClinicPhotoPath))
                    {
                        File.Delete(FileSvrClinicPhotoPath);
                    }
                    File.Move(ClinicResult.LogoRelPath, FileSvrClinicPhotoPath);
                    FileSvrClinicPhotoPath = FileSvrClinicPhotoPath.Replace(FileSvrRootPath, string.Empty);
                    ClinicResult.LogoRelPath = FileSvrClinicPhotoPath.Substring(1);
                }



                ctx.usp_Insert_Clinic(ClinicResult.IPAID, ClinicResult.ClinicCode, ClinicResult.ClinicName, ClinicResult.NPI, ClinicResult.TaxID, ClinicResult.EntityTypeQualifierID, ClinicResult.SpecialtyID, ClinicResult.ICDFormat, ClinicResult.LogoRelPath, ClinicResult.IsPatientDemographicsPull, ClinicResult.IsPatVisitDocManadatory, ClinicResult.StreetName, ClinicResult.Suite, ClinicResult.CityID, ClinicResult.StateID, ClinicResult.CountyID, ClinicResult.CountryID, ClinicResult.PhoneNumber, ClinicResult.PhoneNumberExtn, ClinicResult.SecondaryPhoneNumber, ClinicResult.SecondaryPhoneNumberExtn, ClinicResult.Email, ClinicResult.SecondaryEmail, ClinicResult.Fax, ClinicResult.ContactPersonLastName, ClinicResult.ContactPersonMiddleName, ClinicResult.ContactPersonFirstName, ClinicResult.ContactPersonPhoneNumber, ClinicResult.ContactPersonPhoneNumberExtn, ClinicResult.ContactPersonSecondaryPhoneNumber, ClinicResult.ContactPersonSecondaryPhoneNumberExtn, ClinicResult.ContactPersonEmail, ClinicResult.ContactPersonSecondaryEmail, ClinicResult.ContactPersonFax, ClinicResult.PatientVisitComplexity, string.Empty, pUserID, clinicid);
                List<usp_GetWebAdmin_User_Result> spres = new List<usp_GetWebAdmin_User_Result>(ctx.usp_GetWebAdmin_User());


                foreach (usp_GetWebAdmin_User_Result item in spres)
                {
                    ctx.usp_Insert_UserClinic(item.UserID, Convert.ToInt32(clinicid.Value), string.Empty, pUserID, userclinicid);
                }

                if (HasErr(clinicid, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }
                ctx.usp_Insert_UserClinic(UserResult.UserID, Convert.ToInt32(clinicid.Value), string.Empty, pUserID, userclinicid);

                if (HasErr(userclinicid, ctx))
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
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {

            using (EFContext ctx = new EFContext())
            {
                ClinicResult = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
                UserClinicResult = (new List<usp_GetByClinicID_UserClinic_Result>(ctx.usp_GetByClinicID_UserClinic(Convert.ToInt32(pID))));


            }

            if (ClinicResult == null)
            {
                ClinicResult = new usp_GetByPkId_Clinic_Result() { IsActive = true }; ;
            }
            # region Clinic

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    UserClinicResult = (new List<usp_GetByClinicID_UserClinic_Result>(ctx.usp_GetByClinicID_UserClinic(Convert.ToInt32(pID))));
                }
                # region Manager

                if (UserClinicResult.Count > 0)
                {
                    ManagerCount = 0;

                    //Checking whether the clinic has more than one manager.

                    if (UserClinicResult.Count > 1)
                    {
                        ManagerCount = 1;

                    }
                    else
                    {
                        usp_GetByClinicID_UserClinic_Result stateRes = null;

                        using (EFContext ctx = new EFContext())
                        {

                            stateRes = (new List<usp_GetByClinicID_UserClinic_Result>(ctx.usp_GetByClinicID_UserClinic(Convert.ToInt32(pID)))).FirstOrDefault();
                            UserResult = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(stateRes.UserID, pIsActive))).FirstOrDefault();
                        }

                        if (stateRes != null)
                        {
                            UserResult_User = string.Concat(stateRes.NAME_CODE);


                        }
                    }
                }



                # endregion
            }
            else
            {
                //# region Manager

                //if (UserResult != null)
                //{
                //    usp_GetByPkId_User_Result stateRes = null;

                //    using (EFContext ctx = new EFContext())
                //    {
                //        stateRes = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(UserResult.UserID, pIsActive))).FirstOrDefault();
                //    }

                //    if (stateRes != null)
                //    {
                //        UserResult_User = string.Concat(stateRes.UserName, " [", stateRes.UserID, "]");
                //    }
                //}

                //#endregion
            }

            if (ClinicResult == null)
            {
                ClinicResult = new usp_GetByPkId_Clinic_Result() { IsActive = true };
                UserResult = new usp_GetByPkId_User_Result() { };

            }
            else
            {

                # region Auto Complete Fill

                # region IPA

                if (ClinicResult.IPAID > 0)
                {
                    usp_GetByPkId_IPA_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkId_IPA_Result>(ctx.usp_GetByPkId_IPA(ClinicResult.IPAID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_IPA = string.Concat(stateRes.IPAName, " [", stateRes.IPACode, "]");
                    }
                }

                # endregion
                # region Manager

                if (UserClinicResult != null && UserClinicResult.Count == 1)
                {
                    usp_GetByPkId_User_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(UserClinicResult[0].UserID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        UserResult_User = string.Concat(stateRes.LastName + stateRes.FirstName, " [", stateRes.UserName, "]");
                        UserResult.UserID = stateRes.UserID;
                    }
                }

                #endregion

                # region State

                if (ClinicResult.StateID > 0)
                {
                    usp_GetByPkIdStateName_State_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(ClinicResult.StateID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_State = string.Concat(stateRes.StateName + " [", stateRes.StateCode, "]");
                    }
                }

                # endregion

                # region Specialty

                if (ClinicResult.SpecialtyID > 0)
                {
                    usp_GetByPkId_Specialty_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkId_Specialty_Result>(ctx.usp_GetByPkId_Specialty(ClinicResult.SpecialtyID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_Specialty = string.Concat(stateRes.SpecialtyName, " [", stateRes.SpecialtyCode, "]");
                    }
                }

                # endregion

                # region City

                if (ClinicResult.CityID > 0)
                {
                    usp_GetNameByID_City_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(ClinicResult.CityID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_City = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                    }
                }

                # endregion

                # region Country

                if (ClinicResult.CountryID > 0)
                {
                    usp_GetNameById_Country_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(ClinicResult.CountryID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                    }
                }

                # endregion

                # region County

                if (ClinicResult.CountyID > 0)
                {
                    usp_GetByPkIdCountyName_County_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(ClinicResult.CountyID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_County = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                    }
                }

                # endregion

                # region EntityTypeQualifier

                if (ClinicResult.EntityTypeQualifierID > 0)
                {
                    usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(ClinicResult.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        ClinicResult_EntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                    }
                }

                # endregion

                # endregion
            }

            EncryptAudit(ClinicResult.ClinicID, ClinicResult.LastModifiedBy, ClinicResult.LastModifiedOn);

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ObjectParameter objClinicID = ObjParam("Clinic");
                ctx.usp_Update_Clinic(ClinicResult.IPAID, ClinicResult.ClinicCode, ClinicResult.ClinicName, ClinicResult.NPI,
                    ClinicResult.TaxID, ClinicResult.EntityTypeQualifierID, ClinicResult.SpecialtyID, ClinicResult.ICDFormat, ClinicResult.LogoRelPath,
                    ClinicResult.IsPatientDemographicsPull, ClinicResult.IsPatVisitDocManadatory, ClinicResult.StreetName, ClinicResult.Suite,
                    ClinicResult.CityID, ClinicResult.StateID, ClinicResult.CountyID, ClinicResult.CountryID, ClinicResult.PhoneNumber,
                    ClinicResult.PhoneNumberExtn, ClinicResult.SecondaryPhoneNumber, ClinicResult.SecondaryPhoneNumberExtn, ClinicResult.Email,
                    ClinicResult.SecondaryEmail, ClinicResult.Fax, ClinicResult.ContactPersonLastName, ClinicResult.ContactPersonMiddleName,
                    ClinicResult.ContactPersonFirstName, ClinicResult.ContactPersonPhoneNumber, ClinicResult.ContactPersonPhoneNumberExtn,
                    ClinicResult.ContactPersonSecondaryPhoneNumber, ClinicResult.ContactPersonSecondaryPhoneNumberExtn, ClinicResult.ContactPersonEmail,
                    ClinicResult.ContactPersonSecondaryEmail, ClinicResult.ContactPersonFax, ClinicResult.PatientVisitComplexity, ClinicResult.Comment,
                    ClinicResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, objClinicID);

                if (HasErr(objClinicID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                UserClinicResult = (new List<usp_GetByClinicID_UserClinic_Result>(ctx.usp_GetByClinicID_UserClinic(Convert.ToInt32(objClinicID.Value))));

                if (UserClinicResult.Count > 1)
                {
                    //To display message when the clinic has more than one manager
                    ManagerCount = 1;
                    ErrorNo = 3;
                    RollbackDbTrans(ctx);

                    return false;
                }
                else
                {
                    if (UserClinicResult.Count != 0)
                    {
                        ObjectParameter userclinicid = ObjParam("UserClinicID", typeof(System.Int32), Convert.ToInt32(UserClinicResult[0].UserClinicID));
                        usp_GetByPkId_UserClinic_Result userclinic = (new List<usp_GetByPkId_UserClinic_Result>(ctx.usp_GetByPkId_UserClinic(Convert.ToInt32(userclinicid.Value), null))).FirstOrDefault();
                        ctx.usp_Update_UserClinic(UserResult.UserID, userclinic.ClinicID, string.Empty, ClinicResult.IsActive,
                          userclinic.LastModifiedBy, userclinic.LastModifiedOn, pUserID, userclinicid);

                        if (HasErr(userclinicid, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }
                    }
                    else
                    {
                        ObjectParameter userclinicid = ObjParam("UserClinic");
                        ctx.usp_Insert_UserClinic(UserResult.UserID, Convert.ToInt32(objClinicID.Value), string.Empty, pUserID, userclinicid);
                        if (HasErr(userclinicid, ctx))
                        {
                            RollbackDbTrans(ctx);

                            return false;
                        }
                    }
                }


                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

        #region Private Methods

        # endregion

        #region Public Methods
        /// <summary>
        /// For getting role id ==> autocomplete should come only in webadmin
        /// </summary>
        /// <param name="userid"></param>
        /// <returns></returns>
        public int GetRoleID(int userid)
        {
            usp_GetByUserID_UserRole_Result spres;
            using (EFContext ctx = new EFContext())
            {
                spres = new List<usp_GetByUserID_UserRole_Result>(ctx.usp_GetByUserID_UserRole(userid)).FirstOrDefault();
            }
            return spres.RoleID;
        }

        #endregion
    }

    # endregion

    #region ClinicSearchAdModel



    #region Search

    /// <summary>
    /// By Sai : Admin Role - Practice Clinic - Search
    /// </summary>
    public class ClinicSearchAdModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearchAd_Clinic_Result> AdClinicResult { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public Int32 UserID
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClinicSearchAdModel()
        {
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
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
            using (EFContext ctx = new EFContext())
            {
                AdClinicResult = new List<usp_GetBySearchAd_Clinic_Result>(ctx.usp_GetBySearchAd_Clinic(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

    #endregion

    # region SummaryReportClinicModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportClinicModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumClinic_PatientVisit_Result> ReportSumClinicResults
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumYrClinic_PatientVisit_Result> ReportSumYrClinicResults
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumMnClinic_PatientVisit_Result> ReportSumMnClinicResults
        {
            get;
            set;
        }


        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportClinicModel()
        {
        }

        # endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pClinicID"></param>
        public void FillJs(int pClinicID)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumClinicResults = new List<usp_GetReportSumClinic_PatientVisit_Result>(ctx.usp_GetReportSumClinic_PatientVisit(pClinicID, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pClinicID"></param>
        public void FillJs(int pClinicID, int pYear)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumYrClinicResults = new List<usp_GetReportSumYrClinic_PatientVisit_Result>(ctx.usp_GetReportSumYrClinic_PatientVisit(pClinicID, pYear, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pClinicID"></param>
        public void FillJs(int pClinicID, int pYear, byte pMonth)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumMnClinicResults = new List<usp_GetReportSumMnClinic_PatientVisit_Result>(ctx.usp_GetReportSumMnClinic_PatientVisit(pClinicID, pYear, pMonth, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        # endregion
    }

    # endregion

    # region SummaryReportAllClinicModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportAllClinicModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSum_PatientVisit_Result> ReportSumResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumYr_PatientVisit_Result> ReportSumYrResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumMn_PatientVisit_Result> ReportSumMnResults
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportAllClinicModel()
        {
        }

        # endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        public void FillJs(int pUserID)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumResults = new List<usp_GetReportSum_PatientVisit_Result>(ctx.usp_GetReportSum_PatientVisit(pUserID, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        public void FillJs(int pUserID, int pYear)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumYrResults = new List<usp_GetReportSumYr_PatientVisit_Result>(ctx.usp_GetReportSumYr_PatientVisit(pUserID, pYear, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        /// <param name="pMonth"></param>
        public void FillJs(int pUserID, int pYear, byte pMonth)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumMnResults = new List<usp_GetReportSumMn_PatientVisit_Result>(ctx.usp_GetReportSumMn_PatientVisit(pUserID, pYear, pMonth, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        # endregion
    }

    # endregion
}
