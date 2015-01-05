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
    #region PatientHospitalization

    # region Save

    /// <summary>
    /// .
    /// 
    /// </summary>
    public class PatientHospitalizationSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_PatientHospitalization_Result PatientHospitalizationResult
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String PatientHospitalizationResult_Patient
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String PatientHospitalizationResult_FacilityDoneHospital
        {
            get;
            set;
        }
        /// 
        /// </summary>
        public global::System.String CountyName
        {
            get;
            set;
        }
        /// 
        /// </summary>
        public global::System.String CityName
        {
            get;
            set;
        }


        /// 
        /// </summary>
        public global::System.String ProviderName
        {
            get;
            set;
        }

        /// 
        /// </summary>
        public global::System.String InsuranceName
        {
            get;
            set;
        }
        /// 
        /// </summary>
        public global::System.String RelationshipName
        {
            get;
            set;
        }
        /// </summary>
        public global::System.DateTime DateFrom
        {
            get;
            set;
        }
        /// </summary>
        public global::System.Nullable<DateTime> DateTo
        {
            get;
            set;
        }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientHospitalizationSaveModel()
        {
        }

        # endregion

        #region Abstract Methods



        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        public void GetChartNumber(bool pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                usp_GetNameByID_Patient_Result spRes = (new List<usp_GetNameByID_Patient_Result>(ctx.usp_GetNameByID_Patient(PatientHospitalizationResult.PatientID, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    PatientHospitalizationResult_Patient = spRes.NAME_CODE;
                }
            }
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
                ObjectParameter obj = ObjParam("PatientHospitalization");
                ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
                if (HasErr(obj, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
                return true;
            }

            //ErrorMessage = 0;

            //using (EFContext ctx = new EFContext())
            //{
            //   

            //  

            //    // usp_GetDateStatus_PatientHospitalization ==> no error
            //    // if current block --> visit exist or not check
            //    // date should not overlap the patient visit DOS

            //    List<usp_GetDateStatus_PatientHospitalization_Result> lst = new List<usp_GetDateStatus_PatientHospitalization_Result>(ctx.usp_GetDateStatus_PatientHospitalization(pUserID, PatientHospitalizationResult.PatientID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn));

            //    if (lst.Count == 1)
            //    {
            //        if (lst[0].RET_ANS == "CURRENT - PREVIOUS NOT DISCHARGED - NEW")
            //        {
            //            ErrorMessage = 1;

            //        }
            //        else if (lst[0].RET_ANS == "CURRENT NOT DISCHARGED - BUT ADMITTED DATE OVERLAPPING - NEW")
            //        {
            //            ErrorMessage = 2;
            //        }
            //        else if (lst[0].RET_ANS == "ADMITTED DATE OVERLAPPING - NEW")
            //        {
            //            ErrorMessage = 3;
            //        }
            //        else if (lst[0].RET_ANS == "DISCHARGED DATE OVERLAPPING - NEW")
            //        {
            //            ErrorMessage = 4;
            //        }
            //        else if (lst[0].RET_ANS == "CURRENT - PREVIOUS NOT DISCHARGED - EDIT")
            //        {
            //            ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //            if (HasErr(obj, ctx))
            //            {
            //                ErrorMessage = 5;
            //                RollbackDbTrans(ctx);
            //                return false;
            //            }

            //            CommitDbTrans(ctx);
            //            return true;
            //        }
            //        else if (lst[0].RET_ANS == "CURRENT NOT DISCHARGED - BUT ADMITTED DATE OVERLAPPING - EDIT")
            //        {
            //            if (PatientHospitalizationResult.DischargedOn != null)
            //            {
            //                ErrorMessage = 6;
            //            }
            //            else
            //            {
            //                ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //                if (HasErr(obj, ctx))
            //                {
            //                    RollbackDbTrans(ctx);
            //                    return false;
            //                }

            //                CommitDbTrans(ctx);
            //                return true;
            //            }

            //        }
            //        else if (lst[0].RET_ANS == "ADMITTED DATE OVERLAPPING - EDIT")
            //        {
            //            usp_GetByPkId_PatientHospitalization_Result spRes = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(Convert.ToInt64(obj.Value), true))).FirstOrDefault();

            //            if (spRes != null)
            //            {

            //                    ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //                    if (HasErr(obj, ctx))
            //                    {
            //                        RollbackDbTrans(ctx);
            //                        return false;
            //                    }

            //                    CommitDbTrans(ctx);
            //                    return true;

            //            }
            //            else
            //            {
            //                spRes = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(Convert.ToInt64(obj.Value), false))).FirstOrDefault();

            //                if (spRes != null)
            //                {
            //                    if (spRes.DischargedOn == PatientHospitalizationResult.DischargedOn && spRes.AdmittedOn == PatientHospitalizationResult.AdmittedOn)
            //                    {
            //                        ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //                        if (HasErr(obj, ctx))
            //                        {
            //                            RollbackDbTrans(ctx);
            //                            return false;
            //                        }

            //                        CommitDbTrans(ctx);
            //                        return true;
            //                    }
            //                }

            //            }


            //            ErrorMessage = 7;



            //            return false;
            //        }
            //        else if (lst[0].RET_ANS == "DISCHARGED DATE OVERLAPPING - EDIT")
            //        {
            //            ErrorMessage = 8;
            //        }
            //        else if (lst[0].RET_ANS == "VISIT EXISTS  - NEW")
            //        {
            //            ErrorMessage = 9;
            //        }
            //        else if (lst[0].RET_ANS == "NO_ERROR")
            //        {
            //            ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //            if (HasErr(obj, ctx))
            //            {
            //                RollbackDbTrans(ctx);
            //                return false;
            //            }

            //            CommitDbTrans(ctx);
            //            return true;
            //        }

            //        RollbackDbTrans(ctx);
            //        return false;
            //    }

            //    List<usp_GetByHospitalizationId_PatientVisit_Result> lst1 = new List<usp_GetByHospitalizationId_PatientVisit_Result>(ctx.usp_GetByHospitalizationId_PatientVisit(PatientHospitalizationResult.PatientHospitalizationID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn));

            //    foreach (usp_GetByHospitalizationId_PatientVisit_Result item in lst1)
            //    {
            //        if (!(item.HAS_DOS_ERROR))
            //        {
            //            if (item.PATIENT_VISIT_ID > 0)
            //            {
            //                ctx.usp_Update_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, PatientHospitalizationResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, obj);
            //                if (HasErr(obj, ctx))
            //                {
            //                    RollbackDbTrans(ctx);
            //                    return false;
            //                }

            //                CommitDbTrans(ctx);
            //                return true;

            //            }

            //            if (PatientHospitalizationResult.IsActive == false)
            //            {
            //                ErrorMessage = 10;
            //            }

            //            RollbackDbTrans(ctx);
            //            return false;
            //        }

            //        ErrorMessage = 11;

            //        RollbackDbTrans(ctx);
            //        return false;
            //    }

            //    return false;
            //}
            throw new Exception("SaveUpdate(int pUserID)");
        }

        #endregion

        #region Public Methods

        # endregion

        #region publicmethods



        /// <summary>
        /// 
        /// </summary>
        /// <param name="patientID"></param>
        /// <param name="isActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PatientHospitalizationResult = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (PatientHospitalizationResult == null)
            {
                PatientHospitalizationResult = new usp_GetByPkId_PatientHospitalization_Result() { IsActive = true };
            }

            EncryptAudit(PatientHospitalizationResult.PatientHospitalizationID, PatientHospitalizationResult.LastModifiedBy, PatientHospitalizationResult.LastModifiedOn);

            //#region PatientVisit

            //using (EFContext ctx = new EFContext())
            //{
            //    usp_GetByPatientId_PatientVisit_Result spRes = (new List<usp_GetByPatientId_PatientVisit_Result>(ctx.usp_GetByPatientId_PatientVisit(PatientHospitalizationResult.PatientID, true))).FirstOrDefault();

            //    if (spRes != null)
            //    {
            //        PatientVisitID = spRes.PatientID;
            //    }
            //}

            //#endregion

            # region ChartNumber

            if (PatientHospitalizationResult.PatientID > 0)
            {
                usp_GetByPkId_Patient_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(PatientHospitalizationResult.PatientID, pIsActive)).FirstOrDefault());
                }

                if (stateRes != null)
                {
                    PatientHospitalizationResult_Patient = string.Concat(stateRes.LastName + stateRes.FirstName, " [", stateRes.ChartNumber, "]");
                }
            }

            # endregion

            # region HospitalName

            if (PatientHospitalizationResult.FacilityDoneHospitalID > 0)
            {

                using (EFContext ctx = new EFContext())
                {
                    usp_GetNameByID_FacilityDone_Result spRes = (new List<usp_GetNameByID_FacilityDone_Result>(ctx.usp_GetNameByID_FacilityDone(PatientHospitalizationResult.FacilityDoneHospitalID, pIsActive))).FirstOrDefault();

                    if (spRes != null)
                    {
                        PatientHospitalizationResult_FacilityDoneHospital = spRes.NAME_CODE;
                    }
                }
            }

            # endregion

            # region DateFrom

            using (EFContext ctx = new EFContext())
            {
                usp_GetByPkId_PatientHospitalization_Result spRes = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(pID, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    DateTo = spRes.AdmittedOn;
                }
            }

            # endregion

            # region DateTo

            using (EFContext ctx = new EFContext())
            {
                usp_GetByPkId_PatientHospitalization_Result spRes = (new List<usp_GetByPkId_PatientHospitalization_Result>(ctx.usp_GetByPkId_PatientHospitalization(pID, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    DateTo = spRes.DischargedOn;
                }
            }

            # endregion

            // throw new Exception("ChartNumber = spRes.NAME_CODE;");


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteChartNumber(string stats, int clinicid)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Patient_Result> spRes = new List<usp_GetAutoComplete_Patient_Result>(ctx.usp_GetAutoComplete_Patient(clinicid, stats));

                foreach (usp_GetAutoComplete_Patient_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }

        public List<string> GetAutoCompleteClinicName(string stats, byte clinicid)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_FacilityDone_Result> spRes = new List<usp_GetAutoComplete_FacilityDone_Result>(ctx.usp_GetAutoComplete_FacilityDone(stats, Convert.ToByte(FacilityType.INPATIENT_HOSPITAL)));


                foreach (usp_GetAutoComplete_FacilityDone_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;

            //throw new Exception("GetAutoCompleteClinicName(string stats, int clinicid)");
        }

        public List<string> GetAutoCompleteClinicID(string selText)
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

            //retRes.Add("54321");

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutoComplete_FacilityDone_Result> spRes = new List<usp_GetIDAutoComplete_FacilityDone_Result>(ctx.usp_GetIDAutoComplete_FacilityDone(selCode));

                foreach (usp_GetIDAutoComplete_FacilityDone_Result item in spRes)
                {
                    retRes.Add(item.FACILITY_DONE_ID.ToString());


                }

            }

            return retRes;

            // throw new Exception("GetAutoCompleteClinicID(string selText)");
        }

        public List<string> GetAutoCompletePatientID(Nullable<int> clinicID, string selText)
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
                List<usp_GetIDAutoComplete_Patient_Result> spRes = new List<usp_GetIDAutoComplete_Patient_Result>(ctx.usp_GetIDAutoComplete_Patient(selCode, clinicID, true));

                foreach (usp_GetIDAutoComplete_Patient_Result item in spRes)
                {
                    retRes.Add(item.PatientID.ToString());
                }

            }

            return retRes;


            //throw new Exception("GetAutoCompletePatientID(string selText)");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ObjectParameter PatientHospitalizationID = ObjParam("PatientHospitalization");
                ctx.usp_Insert_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, pUserID, PatientHospitalizationID);

                if (HasErr(PatientHospitalizationID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }
            return true;
            //ObjectParameter PatientHospitalizationID = ObjParam("PatientHospitalization");

            //using (EFContext ctx = new EFContext())
            //{
            //    

            //    // usp_GetDateStatus_PatientHospitalization ==> no error

            //    string retans = null;
            //    List<usp_GetDateStatus_PatientHospitalization_Result> lst = new List<usp_GetDateStatus_PatientHospitalization_Result>(ctx.usp_GetDateStatus_PatientHospitalization(PatientHospitalizationResult.PatientHospitalizationID, PatientHospitalizationResult.PatientID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn));

            //    if (lst != null)
            //    {
            //        retans = lst[0].RET_ANS;
            //    }
            //    if (retans == "NO_ERROR")
            //    {

            //        ctx.usp_Insert_PatientHospitalization(PatientHospitalizationResult.PatientID, PatientHospitalizationResult.FacilityDoneHospitalID, PatientHospitalizationResult.AdmittedOn, PatientHospitalizationResult.DischargedOn, PatientHospitalizationResult.Comment, pUserID, PatientHospitalizationID);

            //        if (HasErr(PatientHospitalizationID, ctx))
            //        {
            //            RollbackDbTrans(ctx);

            //            return false;
            //        }

            //        CommitDbTrans(ctx);
            //    }
            //    else if (retans == "CURRENT - PREVIOUS NOT DISCHARGED - NEW")
            //    {

            //        ErrorMessage = 1;

            //        return false;
            //    }
            //    else if (retans == "CURRENT NOT DISCHARGED - BUT ADMITTED DATE OVERLAPPING - NEW")
            //    {

            //        ErrorMessage = 2;

            //        return false;
            //    }
            //    else if (retans == "ADMITTED DATE OVERLAPPING - NEW")
            //    {

            //        ErrorMessage = 3;

            //        return false;
            //    }
            //    else if (retans == "DISCHARGED DATE OVERLAPPING - NEW")
            //    {

            //        ErrorMessage = 4;

            //        return false;
            //    }
            //    else if (retans == "CURRENT - PREVIOUS NOT DISCHARGED - EDIT")
            //    {

            //        ErrorMessage = 5;

            //        return false;
            //    }
            //    else if (retans == "CURRENT NOT DISCHARGED - BUT ADMITTED DATE OVERLAPPING - EDIT")
            //    {

            //        ErrorMessage = 6;

            //        return false;
            //    }
            //    else if (retans == "ADMITTED DATE OVERLAPPING - EDIT")
            //    {

            //        ErrorMessage = 7;

            //        return false;
            //    }
            //    else if (retans == "DISCHARGED DATE OVERLAPPING - EDIT")
            //    {

            //        ErrorMessage = 8;

            //        return false;
            //    }
            //    else if (retans == "VISIT EXISTS  - NEW")
            //    {

            //        ErrorMessage = 9;

            //        return false;
            //    }


            //}

            //return true;

        }



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

        #endregion

        public void GetChartNumber(bool? nullable)
        {
            GetChartNumber(true);
        }
    }

    # endregion

    # region Search

    public class PatientHospitalizationSearchModel : BaseSearchModel
    {
        private Nullable<global::System.Int64> _PatientID;

        #region Properties

        public Nullable<global::System.Int64> PatientID { get { return _PatientID; } set { if (value == 0) { _PatientID = null; } else { _PatientID = value; } } }
        public List<usp_GetBySearch_PatientHospitalization_Result> PatientHospitalization { get; set; }

        /// 
        /// </summary>
        public global::System.Int32 ClinicID
        {
            get;
            set;
        }
        public usp_GetByPkId_Patient_Result PatientResult { get; set; }

        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public PatientHospitalizationSearchModel()
        {
        }

        # endregion

        #region Abstract Mthods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_PatientHospitalization_Result> lst = new List<usp_GetByAZ_PatientHospitalization_Result>(ctx.usp_GetByAZ_PatientHospitalization(Convert.ToByte(FacilityType.INPATIENT_HOSPITAL), ClinicID, DateFrom, DateTo, pIsActive, SearchName, _PatientID));

                foreach (usp_GetByAZ_PatientHospitalization_Result item in lst)
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


        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                PatientHospitalization = new List<usp_GetBySearch_PatientHospitalization_Result>(ctx.usp_GetBySearch_PatientHospitalization(Convert.ToByte(FacilityType.INPATIENT_HOSPITAL), ClinicID, SearchName, DateFrom, DateTo, StartBy, _PatientID, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
                // Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(StartBy, ClinicID));
            }

        }





        ///// <summary>
        ///// 
        ///// </summary>
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

        #region Public
        /// <summary>
        /// 
        /// </summary>
        public void FillIsActive()
        {
            using (EFContext ctx = new EFContext())
            {
                PatientResult = new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(PatientID, null)).FirstOrDefault();
            }
        }

        #endregion

    }
    #endregion

    #endregion
}
