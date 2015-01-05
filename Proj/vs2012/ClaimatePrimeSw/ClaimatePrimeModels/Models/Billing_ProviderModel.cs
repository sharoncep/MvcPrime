using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;
using System.IO;

namespace ClaimatePrimeModels.Models
{
    #region ProviderAutoComplete
    public class ProviderModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>


        public List<string> GetAutoCompleteProvider(string stats, int cliniccode)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Provider_Result> spRes = new List<usp_GetAutoComplete_Provider_Result>(ctx.usp_GetAutoComplete_Provider(stats, cliniccode));

                foreach (usp_GetAutoComplete_Provider_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }


        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="selText"></param>
        ///// <returns></returns>
        //public List<string> GetAutoCompleteStateID(string selText)
        //{
        //    List<string> retRes = new List<string>();
        //    retRes.Add("54321");

        //    //using (EFContext ctx = new EFContext())
        //    //{
        //    //    List<usp_GetAutoComplete_State_Result> spRes = new List<usp_GetAutoComplete_State_Result>(ctx.usp_GetAutoComplete_State(stats));

        //    //    foreach (usp_GetAutoComplete_State_Result item in spRes)
        //    //    {
        //    //        retRes.Add(item.NAME_CODE);
        //    //    }
        //    //}

        //    return retRes;
        //}





        public List<string> GetAutoCompleteProviderID(string selText)
        {
            List<string> retRes = new List<string>();

            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutoComplete_Provider_Result> spRes = new List<usp_GetIDAutoComplete_Provider_Result>(ctx.usp_GetIDAutoComplete_Provider(selCode, true));

                foreach (usp_GetIDAutoComplete_Provider_Result item in spRes)
                {
                    retRes.Add(item.PROVIDER_ID.ToString());
                }
            }

            return retRes;

        }



        # endregion
    }

    #endregion

    # region ProviderSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class ProviderSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Provider_Result Provider
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
        public global::System.String FileSvrProviderPhotoPath
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_Specialty
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_Credential
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_City
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_State
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_County
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String Provider_Country
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ProviderSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                Provider = (new List<usp_GetByPkId_Provider_Result>(ctx.usp_GetByPkId_Provider(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (Provider == null)
            {
                Provider = new usp_GetByPkId_Provider_Result() { IsActive = true }; ;
            }

            #region AutoComplete

            # region Specialty

            if (Provider.SpecialtyID > 0)
            {
                usp_GetByPkId_Specialty_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Specialty_Result>(ctx.usp_GetByPkId_Specialty(Provider.SpecialtyID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_Specialty = string.Concat(stateRes.SpecialtyName, " [", stateRes.SpecialtyCode, "]");
                }

            }


            # endregion

            # region City

            if (Provider.CityID > 0)
            {
                usp_GetByPkId_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(Provider.CityID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_City = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }

            }


            # endregion

            # region Credential

            if (Provider.CredentialID > 0)
            {
                usp_GetByPkId_Credential_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Credential_Result>(ctx.usp_GetByPkId_Credential(Provider.CredentialID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_Credential = string.Concat(stateRes.CredentialName, " [", stateRes.CredentialCode, "]");
                }

            }


            # endregion

            # region State

            if (Provider.StateID > 0)
            {
                usp_GetByPkId_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(Provider.StateID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_State = string.Concat(stateRes.StateName, " [", stateRes.StateCode, "]");
                }


            }


            # endregion


            # region County

            if (Provider.CountyID > 0)
            {
                usp_GetByPkId_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_County_Result>(ctx.usp_GetByPkId_County(Provider.CountyID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_County = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }

            }
            else
            {
                Provider.CountyID = null;
            }

            # endregion

            # region Country

            if (Provider.CountryID > 0)
            {
                usp_GetByPkId_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(Provider.CountryID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Provider_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }

            }


            # endregion

            #endregion

            EncryptAudit(Provider.ProviderID, Provider.LastModifiedBy, Provider.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter ProviderID = ObjParam("Provider");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (!(string.IsNullOrWhiteSpace(Provider.PhotoRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Provider", "Provider"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrProviderPhotoPath = string.Concat(FileSvrProviderPhotoPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrProviderPhotoPath))
                    {
                        Directory.Delete(FileSvrProviderPhotoPath, true);
                    }
                    Directory.CreateDirectory(FileSvrProviderPhotoPath);

                    FileSvrProviderPhotoPath = string.Concat(FileSvrProviderPhotoPath, @"\", "U_1", Path.GetExtension(Provider.PhotoRelPath));   // File Uploading
                    if (File.Exists(FileSvrProviderPhotoPath))
                    {
                        File.Delete(FileSvrProviderPhotoPath);
                    }
                    File.Move(Provider.PhotoRelPath, FileSvrProviderPhotoPath);
                    FileSvrProviderPhotoPath = FileSvrProviderPhotoPath.Replace(FileSvrRootPath, string.Empty);
                    Provider.PhotoRelPath = FileSvrProviderPhotoPath.Substring(1);
                }

                // string selCode = Provider.ProviderCode.Substring(0, 5);
                ctx.usp_Insert_Provider(Provider.ClinicID, Provider.ProviderCode, Provider.LastName, Provider.MiddleName, Provider.FirstName, Provider.CredentialID, Provider.NPI, Provider.TaxID, Provider.SSN, Provider.IsTaxIDPrimaryOption, Provider.SpecialtyID, Provider.PhotoRelPath, Provider.IsSignedFile, Provider.SignedDate, Provider.LicenseNumber, Provider.CLIANumber, Provider.StreetName, Provider.Suite, Provider.CityID, Provider.StateID, Provider.CountyID, Provider.CountryID, Provider.PhoneNumber, Provider.SecondaryPhoneNumber, Provider.Email, Provider.SecondaryEmail, Provider.Fax, string.Empty, pUserID, ProviderID);

                if (HasErr(ProviderID, ctx))
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
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter ProviderID = ObjParam("Provider");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                //   string selCode = Provider.ProviderCode.Substring(0, 5);

                ctx.usp_Update_Provider(Provider.ClinicID, Provider.ProviderCode, Provider.LastName, Provider.MiddleName, Provider.FirstName, Provider.CredentialID, Provider.NPI, Provider.TaxID, Provider.SSN, Provider.IsTaxIDPrimaryOption, Provider.SpecialtyID, Provider.PhotoRelPath, Provider.IsSignedFile, Provider.SignedDate, Provider.LicenseNumber, Provider.CLIANumber, Provider.StreetName, Provider.Suite, Provider.CityID, Provider.StateID, Provider.CountyID, Provider.CountryID, Provider.PhoneNumber, Provider.SecondaryPhoneNumber, Provider.Email, Provider.SecondaryEmail, Provider.Fax, Provider.Comment, Provider.IsActive, LastModifiedBy, LastModifiedOn, pUserID, ProviderID);

                if (HasErr(ProviderID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

        #region Public Methods

        # endregion
    }

    # endregion

    # region ProviderSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class ProviderSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Provider_Result> Provider { get; set; }

        public Nullable<Int32> ClinicID { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ProviderSearchModel()
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
        public usp_GetByPkId_Provider_Result GetByPkIdProvider(Nullable<global::System.Int32> providerID, Nullable<global::System.Boolean> isActive)
        {
            usp_GetByPkId_Provider_Result retAns = null;

            if (providerID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_Provider_Result>(ctx.usp_GetByPkId_Provider(providerID, isActive))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Provider_Result();
            }

            return retAns;
        }

       


        #endregion

        #region Override Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                
                List<usp_GetByAZ_Provider_Result> lst = new List<usp_GetByAZ_Provider_Result>(ctx.usp_GetByAZ_Provider(ClinicID,SearchName, pIsActive));

                foreach (usp_GetByAZ_Provider_Result item in lst)
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
                Provider = new List<usp_GetBySearch_Provider_Result>(ctx.usp_GetBySearch_Provider(ClinicID, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
    # region SummaryReportProviderModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportProviderModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumProvider_PatientVisit_Result> ReportSumProviderResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumYrProvider_PatientVisit_Result> ReportSumYrProviderResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumMnProvider_PatientVisit_Result> ReportSumMnProviderResults
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportProviderModel()
        {
        }

        # endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        public void FillJs(int pProviderID)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumProviderResults = new List<usp_GetReportSumProvider_PatientVisit_Result>(ctx.usp_GetReportSumProvider_PatientVisit(pProviderID, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        public void FillJs(int pProviderID, int pYear)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumYrProviderResults = new List<usp_GetReportSumYrProvider_PatientVisit_Result>(ctx.usp_GetReportSumYrProvider_PatientVisit(pProviderID, pYear, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        /// <param name="pMonth"></param>
        public void FillJs(int pProviderID, int pYear, byte pMonth)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumMnProviderResults = new List<usp_GetReportSumMnProvider_PatientVisit_Result>(ctx.usp_GetReportSumMnProvider_PatientVisit(pProviderID, pYear, pMonth, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        # endregion
    }

    # endregion

    #region ProviderAssignedClaim

    /// <summary>
    /// 
    /// </summary>
    public class ClaimProviderModel : BaseSaveModel
    {
        #region Property

        public usp_GetByPatientID_Provider_Result Provider_Result { get; set; }

        public string ClinicName { get; set; }

        public string ProviderName { get; set; }

        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string CountyName { get; set; }

        public string StateName { get; set; }

        public string CredentialName { get; set; }

        #endregion

        #region Abstract

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    Provider_Result = (new List<usp_GetByPatientID_Provider_Result>(ctx.usp_GetByPatientID_Provider(pID))).FirstOrDefault();
                }
            }

            if (Provider_Result == null)
            {
                Provider_Result = new usp_GetByPatientID_Provider_Result() { IsActive = true }; ;
            }

            #region Provider Name
            if (Provider_Result.ClinicID > 0)
            {
                usp_GetByPkId_Clinic_Result ClinicRes = null;

                using (EFContext ctx = new EFContext())
                {
                    ClinicRes = (new List<usp_GetByPkId_Clinic_Result>(ctx.usp_GetByPkId_Clinic(Provider_Result.ClinicID, null))).FirstOrDefault();
                }

                if (ClinicRes != null)
                {
                    ClinicName = string.Concat(ClinicRes.ClinicName, " [" + ClinicRes.ClinicCode + "]");
                }
            }
            #endregion

            #region credential
            if (Provider_Result.CredentialID > 0)
            {
                usp_GetByPkId_Credential_Result CredRes = null;

                using (EFContext ctx = new EFContext())
                {
                    CredRes = (new List<usp_GetByPkId_Credential_Result>(ctx.usp_GetByPkId_Credential(Provider_Result.CredentialID, null))).FirstOrDefault();
                }

                if (CredRes != null)
                {
                    CredentialName = string.Concat(CredRes.CredentialName, " [" + CredRes.CredentialCode + "]");
                }
            }
            #endregion

            #region Specality
            if (Provider_Result.SpecialtyID > 0)
            {
                usp_GetNameByID_Specialty_Result SpecRes = null;

                using (EFContext ctx = new EFContext())
                {
                    SpecRes = (new List<usp_GetNameByID_Specialty_Result>(ctx.usp_GetNameByID_Specialty(Provider_Result.SpecialtyID, null))).FirstOrDefault();
                }

                if (SpecRes != null)
                {
                    ProviderName = SpecRes.NAME_CODE;
                }
            }
            #endregion

            # region City

            if (Provider_Result.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(Provider_Result.CityID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CityName = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (Provider_Result.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(Provider_Result.CountryID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountryName = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (Provider_Result.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(Provider_Result.CountyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountyName = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (Provider_Result.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(Provider_Result.StateID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    StateName = string.Concat(stateRes.StateName + "[", stateRes.StateCode, "]");
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

        
    }

    #endregion

    #region ProviderReport


    public class ProviderReportSearchModel : BaseSearchModel
    {
        # region Properties



        public List<usp_GetBySearchClinic_Provider_Result> Clinic_Provider_Result
        {
            get;
            set;
        }
        public int ClinicID
        {
            get;
            set;
        }

        # endregion

        #region Constructors


        /// <summary>
        /// 
        /// </summary>
        public ProviderReportSearchModel()
        {
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>

        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZClinic_Provider_Result> lst = new List<usp_GetByAZClinic_Provider_Result>(ctx.usp_GetByAZClinic_Provider(ClinicID));

                foreach (usp_GetByAZClinic_Provider_Result item in lst)
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
                Clinic_Provider_Result = new List<usp_GetBySearchClinic_Provider_Result>(ctx.usp_GetBySearchClinic_Provider(StartBy, ClinicID));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    #endregion
}
