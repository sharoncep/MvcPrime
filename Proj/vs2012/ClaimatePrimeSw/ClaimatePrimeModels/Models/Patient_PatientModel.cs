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
    # region PatientDemography

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class PatientDemographySaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        ///  Get or Set
        /// </summary>
        public usp_GetByPkId_Patient_Result PatientResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_General_Result GeneralResult
        {
            get;
            set;
        }

        /// <summary>
        ///  Get or Set
        /// </summary>
        public Int64 StateID
        {
            get;
            set;
        }

        /// <summary>
        ///  Get or Set
        /// </summary>
        public global::System.String PatientResult_State
        {
            get;
            set;
        }
        /// <summary>
        ///  Get or Set
        /// </summary>
        public global::System.String PatientResult_Country
        {
            get;
            set;
        }
        /// <summary>
        ///  Get or Set
        /// </summary>
        public global::System.String PatientResult_County
        {
            get;
            set;
        }
        /// <summary>
        ///  Get or Set
        /// </summary>
        public global::System.String PatientResult_City
        {
            get;
            set;
        }
        /// <summary>
        ///  Get or Set
        /// </summary>
        public global::System.String PatientResult_Provider
        {
            get;
            set;
        }

        /// 
        /// </summary>
        public global::System.String PatientResult_Insurance
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String PatientResult_Relationship
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
        public global::System.String FileSvrPatientPhotoPath
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientDemographySaveModel()
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
            ObjectParameter patientID = ObjParam("Patient");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (!(string.IsNullOrWhiteSpace(PatientResult.PhotoRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Patient", "Patient"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrPatientPhotoPath = string.Concat(FileSvrPatientPhotoPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrPatientPhotoPath))
                    {
                        Directory.Delete(FileSvrPatientPhotoPath, true);
                    }
                    Directory.CreateDirectory(FileSvrPatientPhotoPath);

                    FileSvrPatientPhotoPath = string.Concat(FileSvrPatientPhotoPath, @"\", "U_1", Path.GetExtension(PatientResult.PhotoRelPath));   // File Uploading
                    if (File.Exists(FileSvrPatientPhotoPath))
                    {
                        File.Delete(FileSvrPatientPhotoPath);
                    }
                    File.Move(PatientResult.PhotoRelPath, FileSvrPatientPhotoPath);
                    FileSvrPatientPhotoPath = FileSvrPatientPhotoPath.Replace(FileSvrRootPath, string.Empty);
                    PatientResult.PhotoRelPath = FileSvrPatientPhotoPath.Substring(1);
                }

                ctx.usp_Insert_Patient(PatientResult.ClinicID, PatientResult.ChartNumber, PatientResult.MedicareID, PatientResult.LastName
                            , PatientResult.MiddleName, PatientResult.FirstName, PatientResult.Sex, PatientResult.DOB, PatientResult.SSN, PatientResult.ProviderID
                            , PatientResult.InsuranceID, PatientResult.PolicyNumber, PatientResult.GroupNumber, PatientResult.ChartNumber
                            , PatientResult.RelationshipID, PatientResult.IsInsuranceBenefitAccepted, PatientResult.IsCapitated, PatientResult.InsuranceEffectFrom
                            , PatientResult.InsuranceEffectTo, PatientResult.PhotoRelPath, PatientResult.IsSignedFile, PatientResult.SignedDate, PatientResult.StreetName
                            , PatientResult.Suite, PatientResult.CityID, PatientResult.StateID, PatientResult.CountyID, PatientResult.CountryID
                            , PatientResult.PhoneNumber, PatientResult.SecondaryPhoneNumber, PatientResult.Email, PatientResult.SecondaryEmail, PatientResult.Fax
                            , PatientResult.Comment, pUserID, patientID);

                if (HasErr(patientID, ctx))
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
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ObjectParameter objPatientID = ObjParam("Patient");

                ctx.usp_Update_Patient(PatientResult.ClinicID, PatientResult.ChartNumber, PatientResult.MedicareID, PatientResult.LastName
                            , PatientResult.MiddleName, PatientResult.FirstName, PatientResult.Sex, PatientResult.DOB, PatientResult.SSN, PatientResult.ProviderID
                            , PatientResult.InsuranceID, PatientResult.PolicyNumber, PatientResult.GroupNumber, PatientResult.ChartNumber
                            , PatientResult.RelationshipID, PatientResult.IsInsuranceBenefitAccepted, PatientResult.IsCapitated, PatientResult.InsuranceEffectFrom
                            , PatientResult.InsuranceEffectTo, PatientResult.PhotoRelPath, PatientResult.IsSignedFile, PatientResult.SignedDate, PatientResult.StreetName
                            , PatientResult.Suite, PatientResult.CityID, PatientResult.StateID, PatientResult.CountyID, PatientResult.CountryID
                            , PatientResult.PhoneNumber, PatientResult.SecondaryPhoneNumber, PatientResult.Email, PatientResult.SecondaryEmail, PatientResult.Fax
                            , PatientResult.Comment, PatientResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, objPatientID);

                if (HasErr(objPatientID, ctx))
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
            # region Patient

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PatientResult = (new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PatientResult == null)
            {
                PatientResult = new usp_GetByPkId_Patient_Result() { IsActive = true };
            }
            else
            {
                # region Auto Complete Fill

                # region Provider

                if (PatientResult.ProviderID > 0)
                {
                    usp_GetNameByID_Provider_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetNameByID_Provider_Result>(ctx.usp_GetNameByID_Provider(PatientResult.ProviderID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_Provider = string.Concat(stateRes.ProviderName, " [", stateRes.ProviderCode, "]");
                    }
                }

                # endregion

                # region State

                if (PatientResult.StateID > 0)
                {
                    usp_GetByPkIdStateName_State_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(PatientResult.StateID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_State = string.Concat(stateRes.StateName + " [", stateRes.StateCode, "]");
                    }
                }

                # endregion

                # region Relationship

                if (PatientResult.RelationshipID > 0)
                {
                    usp_GetByPkIdRelationshipName_Relationship_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdRelationshipName_Relationship_Result>(ctx.usp_GetByPkIdRelationshipName_Relationship(PatientResult.RelationshipID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_Relationship = string.Concat(stateRes.RelationshipName, " [", stateRes.RelationshipCode, "]");
                    }
                }

                # endregion

                # region City

                if (PatientResult.CityID > 0)
                {
                    usp_GetNameByID_City_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(PatientResult.CityID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_City = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                    }
                }

                # endregion

                # region Country

                if (PatientResult.CountryID > 0)
                {
                    usp_GetNameById_Country_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(PatientResult.CountryID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                    }
                }

                # endregion

                # region County

                if (PatientResult.CountyID > 0)
                {
                    usp_GetByPkIdCountyName_County_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(PatientResult.CountyID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_County = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                    }
                }

                # endregion

                # region Insurance

                if (PatientResult.InsuranceID > 0)
                {
                    usp_GetByPkIdInsuranceName_Insurance_Result stateRes = null;

                    using (EFContext ctx = new EFContext())
                    {
                        stateRes = (new List<usp_GetByPkIdInsuranceName_Insurance_Result>(ctx.usp_GetByPkIdInsuranceName_Insurance(PatientResult.InsuranceID, pIsActive))).FirstOrDefault();
                    }

                    if (stateRes != null)
                    {
                        PatientResult_Insurance = string.Concat(stateRes.InsuranceName, " [", stateRes.InsuranceCode, "]");
                    }
                }

                # endregion

                # endregion
            }

            EncryptAudit(PatientResult.PatientID, PatientResult.LastModifiedBy, PatientResult.LastModifiedOn);

            # endregion
        }

        #endregion

        #region Private Methods

        # endregion

        #region Public Methods

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="currentModificationBy"></param>
        ///// <returns></returns>
        //public bool SavePatientDetails(Nullable<global::System.Int64> currentModificationBy)
        //{
        //    ObjectParameter patientID = ObjParam("Patient");

        //    if (patientID.Value.ToString() == "0")
        //    {
        //        using (EFContext ctx = new EFContext())
        //        {
        //            BeginDbTrans(ctx);
        //            ctx.usp_Insert_Patient(PatientResult.ClinicID, PatientResult.ChartNumber, PatientResult.MedicareID, PatientResult.LastName
        //                        , PatientResult.MiddleName, PatientResult.FirstName, PatientResult.Sex, PatientResult.DOB, PatientResult.SSN, PatientResult.ProviderID
        //                        , PatientResult.InsuranceID, PatientResult.PolicyNumber, PatientResult.GroupNumber, PatientResult.PolicyHolderChartNumber
        //                        , PatientResult.RelationshipID, PatientResult.IsInsuranceBenefitAccepted, PatientResult.IsCapitated, PatientResult.InsuranceEffectFrom
        //                        , PatientResult.InsuranceEffectTo, PatientResult.PhotoPath, PatientResult.IsSignedFile, PatientResult.SignedDate, PatientResult.StreetName
        //                        , PatientResult.Suite, PatientResult.CityID, PatientResult.StateID, PatientResult.CountyID, PatientResult.CountryID
        //                        , PatientResult.PhoneNumber, PatientResult.SecondaryPhoneNumber, PatientResult.Email, PatientResult.SecondaryEmail, PatientResult.Fax
        //                        , PatientResult.Comment, currentModificationBy, patientID);

        //            if (HasErr(patientID, ctx))
        //            {
        //                RollbackDbTrans(ctx);

        //                return false;
        //            }

        //            CommitDbTrans(ctx);
        //        }
        //    }
        //    else
        //    {
        //        //using (EFContext ctx = new EFContext())
        //        //{
        //        //    BeginDbTrans(ctx);

        //        //    ctx.usp_Update_Patient(PatientResult.ClinicID, PatientResult.ChartNumber, PatientResult.MedicareID, PatientResult.LastName
        //        //                , PatientResult.MiddleName, PatientResult.FirstName, PatientResult.Sex, PatientResult.DOB, PatientResult.SSN, PatientResult.ProviderID
        //        //                , PatientResult.InsuranceID, PatientResult.PolicyNumber, PatientResult.GroupNumber, PatientResult.PolicyHolderChartNumber
        //        //                , PatientResult.RelationshipID, PatientResult.IsInsuranceBenefitAccepted, PatientResult.IsCapitated, PatientResult.InsuranceEffectFrom
        //        //                , PatientResult.InsuranceEffectTo, PatientResult.PhotoPath, PatientResult.IsSignedFile, PatientResult.SignedDate, PatientResult.StreetName
        //        //                , PatientResult.Suite, PatientResult.CityID, PatientResult.StateID, PatientResult.CountyID, PatientResult.CountryID
        //        //                , PatientResult.PhoneNumber, PatientResult.SecondaryPhoneNumber, PatientResult.Email, PatientResult.SecondaryEmail, PatientResult.Fax
        //        //                , PatientResult.Comment, LastModifiedBy, LastModifiedOn, currentModificationBy, patientID);

        //        //    if (HasErr(patientID.Value))
        //        //    {
        //        //        RollbackDbTrans(ctx);

        //        //        return false;
        //        //    }

        //        //    CommitDbTrans(ctx);
        //        //}
        //    }

        //    return true;
        //}
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>

        public int GetFileSize()
        {
            using (EFContext ctx = new EFContext())
            {

                GeneralResult = (new List<usp_GetByPkId_General_Result>(ctx.usp_GetByPkId_General(1, true))).FirstOrDefault();

            }

            if (GeneralResult == null)
            {
                GeneralResult = new usp_GetByPkId_General_Result() { IsActive = true };
            }

            return GeneralResult.UploadMaxSizeInMB;
        }

        #endregion
    }

    # endregion

    # region Search

    /// <summary>
    /// 
    /// </summary>
    public class PatientDemographySearchModel : BaseSearchModel
    {
        # region Properties


        public Int32 ClinicID { get; set; }
        public List<usp_GetBySearch_Patient_Result> Patient { get; set; }
        public List<usp_GetByPkId_Patient_Result> PatientName { get; set; }
        public string Name { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientDemographySearchModel()
        {
        }

        #endregion

        #region  public methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetChartByID(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                usp_GetNameByID_Patient_Result spRes = (new List<usp_GetNameByID_Patient_Result>(ctx.usp_GetNameByID_Patient(CurrNumber, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    Name = spRes.NAME_CODE;
                }
            }

            return Name;
            //return null;
        }
        #region Public Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="isActive"></param>
        /// <returns></returns>
        public usp_GetByPkId_Patient_Result GetByPkIdPatient(Nullable<global::System.Int32> patientID, Nullable<global::System.Boolean> isActive)
        {
            usp_GetByPkId_Patient_Result retAns = null;

            if (patientID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(patientID, isActive))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Patient_Result();
            }

            return retAns;
        }




        #endregion

        #endregion


        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Patient_Result> lst = new List<usp_GetByAZ_Patient_Result>(ctx.usp_GetByAZ_Patient(ClinicID, SearchName, pIsActive));

                foreach (usp_GetByAZ_Patient_Result item in lst)
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
                Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(ClinicID, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
                //Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(StartBy, ClinicID));
            }
        }

        //private void VerifyStartBy()
        //{
        //    List<string> tmpAz = new List<string>(from oSB in AZModels where (oSB.AZ_COUNT > 0) select oSB.AZ);
        //    string tmpStBy = StartBy;

        //    tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) == 0 select oAz).FirstOrDefault();
        //    if (!(string.IsNullOrWhiteSpace(tmpStBy)))
        //    {
        //        return;
        //    }

        //    tmpStBy = StartBy;
        //    tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) < 0 select oAz).FirstOrDefault();
        //    if (!(string.IsNullOrWhiteSpace(tmpStBy)))
        //    {
        //        StartBy = tmpStBy;
        //        return;
        //    }

        //    tmpStBy = StartBy;
        //    tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) > 0 select oAz).FirstOrDefault();
        //    if (!(string.IsNullOrWhiteSpace(tmpStBy)))
        //    {
        //        StartBy = tmpStBy;
        //        return;
        //    }

        //    tmpStBy = "Z";
        //    StartBy = tmpStBy;
        //}

        #endregion

        # region Private Method

        # endregion
    }

    # endregion

    #endregion


    # region SummaryReportPatientModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportPatientModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumPatient_PatientVisit_Result> ReportSumPatientResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumYrPatient_PatientVisit_Result> ReportSumYrPatientResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumMnPatient_PatientVisit_Result> ReportSumMnPatientResults
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportPatientModel()
        {
        }

        # endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        public void FillJs(long pPatientID)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumPatientResults = new List<usp_GetReportSumPatient_PatientVisit_Result>(ctx.usp_GetReportSumPatient_PatientVisit(pPatientID, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        public void FillJs(long pPatientID, int pYear)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumYrPatientResults = new List<usp_GetReportSumYrPatient_PatientVisit_Result>(ctx.usp_GetReportSumYrPatient_PatientVisit(pPatientID, pYear, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pYear"></param>
        /// <param name="pMonth"></param>
        public void FillJs(long pPatientID, int pYear, byte pMonth)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumMnPatientResults = new List<usp_GetReportSumMnPatient_PatientVisit_Result>(ctx.usp_GetReportSumMnPatient_PatientVisit(pPatientID, pYear, pMonth, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_QA_TO_BA), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.REASSIGNED_BY_EA_TO_QA), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM), Convert.ToByte(ClaimStatus.DONE)));
            }
        }

        # endregion
    }

    # endregion
    #region Patientrpt

    public class PatientRptSearch : BaseSearchModel
    {
        # region Properties



        public List<usp_GetBySearchRpt_Patient_Result> PatientRpt
        {
            get;
            set;
        }
        public int ClinicID
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
        public PatientRptSearch()
        {
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
                List<usp_GetByAZRpt_Patient_Result> lst = new List<usp_GetByAZRpt_Patient_Result>(ctx.usp_GetByAZRpt_Patient(ClinicID, true));

                foreach (usp_GetByAZRpt_Patient_Result item in lst)
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
                PatientRpt = new List<usp_GetBySearchRpt_Patient_Result>(ctx.usp_GetBySearchRpt_Patient(ClinicID, StartBy, true));
            }
        }
        # endregion
    }

    #endregion
}
