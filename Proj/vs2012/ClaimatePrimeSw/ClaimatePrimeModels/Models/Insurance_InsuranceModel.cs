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


namespace ClaimatePrimeModels.Models
{
    #region InsuranceAutoComplete
    public class InsuranceModel : BaseModel
    {
        #region PublicMethods
        public List<string> GetAutoCompleteInsurance(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Insurance_Result> spRes = new List<usp_GetAutoComplete_Insurance_Result>(ctx.usp_GetAutoComplete_Insurance(stats));

                foreach (usp_GetAutoComplete_Insurance_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompleteInsuranceID(string selText)
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
                List<usp_GetIDAutoComplete_Insurance_Result> spRes = new List<usp_GetIDAutoComplete_Insurance_Result>(ctx.usp_GetIDAutoComplete_Insurance(selCode));

                foreach (usp_GetIDAutoComplete_Insurance_Result item in spRes)
                {
                    retRes.Add(item.INSURANCE_ID.ToString());
                }
            }

            return retRes;

        }

        public List<string> GetAutoCompleteInsuranceType(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_InsuranceType_Result> spRes = new List<usp_GetAutoComplete_InsuranceType_Result>(ctx.usp_GetAutoComplete_InsuranceType(stats));

                foreach (usp_GetAutoComplete_InsuranceType_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompleteInsuranceTypeID(string selText)
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
                List<usp_GetIDAutoComplete_InsuranceType_Result> spRes = new List<usp_GetIDAutoComplete_InsuranceType_Result>(ctx.usp_GetIDAutoComplete_InsuranceType(selCode));

                foreach (usp_GetIDAutoComplete_InsuranceType_Result item in spRes)
                {
                    retRes.Add(item.InsuranceType_ID.ToString());
                }
            }

            return retRes;

        }

        public List<string> GetAutoCompleteEDIReceiver(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_EDIReceiver_Result> spRes = new List<usp_GetAutoComplete_EDIReceiver_Result>(ctx.usp_GetAutoComplete_EDIReceiver(stats));

                foreach (usp_GetAutoComplete_EDIReceiver_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompleteEDIReceiverID(string selText)
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
                List<usp_GetIDAutoComplete_EDIReceiver_Result> spRes = new List<usp_GetIDAutoComplete_EDIReceiver_Result>(ctx.usp_GetIDAutoComplete_EDIReceiver(selCode));

                foreach (usp_GetIDAutoComplete_EDIReceiver_Result item in spRes)
                {
                    retRes.Add(item.EDIReceiver_ID.ToString());
                }
            }

            return retRes;

        }

        public List<string> GetAutoCompletePrintPin(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_PrintPin_Result> spRes = new List<usp_GetAutoComplete_PrintPin_Result>(ctx.usp_GetAutoComplete_PrintPin(stats));

                foreach (usp_GetAutoComplete_PrintPin_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompletePrintPinID(string selText)
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
                List<usp_GetIDAutoComplete_PrintPin_Result> spRes = new List<usp_GetIDAutoComplete_PrintPin_Result>(ctx.usp_GetIDAutoComplete_PrintPin(selCode));

                foreach (usp_GetIDAutoComplete_PrintPin_Result item in spRes)
                {
                    retRes.Add(item.PrintPin_ID.ToString());
                }
            }

            return retRes;

        }


        public List<string> GetAutoCompletePrintSign(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_PrintSign_Result> spRes = new List<usp_GetAutoComplete_PrintSign_Result>(ctx.usp_GetAutoComplete_PrintSign(stats));

                foreach (usp_GetAutoComplete_PrintSign_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompletePrintSignID(string selText)
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
                List<usp_GetIDAutoComplete_PrintSign_Result> spRes = new List<usp_GetIDAutoComplete_PrintSign_Result>(ctx.usp_GetIDAutoComplete_PrintSign(selCode));

                foreach (usp_GetIDAutoComplete_PrintSign_Result item in spRes)
                {
                    retRes.Add(item.PrintSign_ID.ToString());
                }
            }

            return retRes;

        }
        
        
        #endregion

    }
    #endregion

    # region InsuranceSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class InsuranceSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Insurance_Result Insurance
        {
            get;
            set;
        }
        public string Insurance_InsuranceType
        {
            get;
            set;
        }

        public string Insurance_EDIReceiver
        {
            get;
            set;
        }
        public string Insurance_PrintPin
        {
            get;
            set;
        }
        public string Insurance_PatientPrintSign
        {
            get;
            set;
        }
        public string Insurance_InsuredPrintSign
        {
            get;
            set;
        }
        public string Insurance_PhysicianPrintSign
        {
            get;
            set;
        }
        public string Insurance_City
        {
            get;
            set;
        }
        public string Insurance_State
        {
            get;
            set;
        }
        public string Insurance_Country
        {
            get;
            set;
        }
        public string Insurance_County
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public InsuranceSaveModel()
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
                Insurance = (new List<usp_GetByPkId_Insurance_Result>(ctx.usp_GetByPkId_Insurance(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (Insurance == null)
            {
                Insurance = new usp_GetByPkId_Insurance_Result() { IsActive = true };
            }

            # region Auto Complete Fill

            # region InsuranceType

            if (Insurance.InsuranceTypeID > 0)
            {
                usp_GetByPkId_InsuranceType_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_InsuranceType_Result>(ctx.usp_GetByPkId_InsuranceType(Insurance.InsuranceTypeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_InsuranceType = string.Concat(stateRes.InsuranceTypeName, " [", stateRes.InsuranceTypeCode, "]");
                }
            }

            # endregion

            # region EDIReceiver

            if (Insurance.EDIReceiverID > 0)
            {
                usp_GetByPkId_EDIReceiver_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EDIReceiver_Result>(ctx.usp_GetByPkId_EDIReceiver(Insurance.EDIReceiverID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_EDIReceiver = string.Concat(stateRes.EDIReceiverName + " [", stateRes.EDIReceiverCode, "]");
                }
            }

            # endregion

            # region PrintPin

            if (Insurance.PrintPinID > 0)
            {
                usp_GetByPkId_PrintPin_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PrintPin_Result>(ctx.usp_GetByPkId_PrintPin(Insurance.PrintPinID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_PrintPin = string.Concat(stateRes.PrintPinName, " [", stateRes.PrintPinCode, "]");
                }
            }

            # endregion

            # region City

            if (Insurance.PatientPrintSignID > 0)
            {
                usp_GetByPkId_PrintSign_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(Insurance.PatientPrintSignID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_PatientPrintSign = string.Concat(stateRes.PrintSignName, " [", stateRes.PrintSignCode, "]");
                }
            }

            # endregion

            # region City

            if (Insurance.InsuredPrintSignID > 0)
            {
                usp_GetByPkId_PrintSign_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(Insurance.InsuredPrintSignID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_InsuredPrintSign = string.Concat(stateRes.PrintSignName, " [", stateRes.PrintSignCode, "]");
                }
            }

            # endregion

            # region City

            if (Insurance.PhysicianPrintSignID > 0)
            {
                usp_GetByPkId_PrintSign_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_PrintSign_Result>(ctx.usp_GetByPkId_PrintSign(Insurance.PhysicianPrintSignID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_PhysicianPrintSign = string.Concat(stateRes.PrintSignName, " [", stateRes.PrintSignCode, "]");
                }
            }

            # endregion

            # region City

            if (Insurance.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(Insurance.CityID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_City = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (Insurance.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(Insurance.CountryID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (Insurance.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(Insurance.CountyID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_Country = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (Insurance.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(Insurance.StateID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    Insurance_State = string.Concat(stateRes.StateName + " [", stateRes.StateCode, "]");
                }
            }

            # endregion


            # endregion

            EncryptAudit(Insurance.InsuranceID, Insurance.LastModifiedBy, Insurance.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter InsuranceID = ObjParam("Insurance");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                // string selCode = Insurance.InsuranceCode.Substring(0, 5);
                 ctx.usp_Insert_Insurance(Insurance.InsuranceCode,Insurance.InsuranceName,Insurance.PayerID,Insurance.InsuranceTypeID,Insurance.EDIReceiverID,Insurance.PrintPinID,Insurance.PatientPrintSignID,Insurance.InsuredPrintSignID,Insurance.PhysicianPrintSignID,Insurance.StreetName,Insurance.Suite,Insurance.CityID,Insurance.StateID,Insurance.CountyID,Insurance.CountryID,Insurance.PhoneNumber,Insurance.PhoneNumberExtn,Insurance.SecondaryPhoneNumber,Insurance.SecondaryPhoneNumberExtn,Insurance.Email,Insurance.SecondaryEmail,Insurance.Fax,Insurance.Comment,pUserID,InsuranceID);

                if (HasErr(InsuranceID, ctx))
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
            ObjectParameter InsuranceID = ObjParam("Insurance");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                //   string selCode = Insurance.InsuranceCode.Substring(0, 5);

                ctx.usp_Update_Insurance(Insurance.InsuranceCode, Insurance.InsuranceName, Insurance.PayerID, Insurance.InsuranceTypeID, Insurance.EDIReceiverID, Insurance.PrintPinID, Insurance.PatientPrintSignID, Insurance.InsuredPrintSignID, Insurance.PhysicianPrintSignID, Insurance.StreetName, Insurance.Suite, Insurance.CityID, Insurance.StateID, Insurance.CountyID, Insurance.CountryID, Insurance.PhoneNumber, Insurance.PhoneNumberExtn, Insurance.SecondaryPhoneNumber, Insurance.SecondaryPhoneNumberExtn, Insurance.Email, Insurance.SecondaryEmail, Insurance.Fax, Insurance.Comment, Insurance.IsActive, LastModifiedBy, LastModifiedOn, pUserID, InsuranceID);

                if (HasErr(InsuranceID, ctx))
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

    # region InsuranceSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class InsuranceSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Insurance_Result> Insurance { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public InsuranceSearchModel()
        {
        }

        #endregion

        # region Public Methods

        # endregion

        #region Override Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Insurance_Result> lst = new List<usp_GetByAZ_Insurance_Result>(ctx.usp_GetByAZ_Insurance(SearchName, pIsActive));

                foreach (usp_GetByAZ_Insurance_Result item in lst)
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
                Insurance = new List<usp_GetBySearch_Insurance_Result>(ctx.usp_GetBySearch_Insurance(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion

    #region ClaimInsurance

    public class ClaimInsuranceModel : BaseSaveModel
    {
        #region Property

        public usp_GetByPatientID_Insurance_Result InsuranceResult { get; set; }

        public string InsuranceResult_InsType { get; set; }

        public string InsuranceResult_EDIRecvr { get; set; }

        public string InsuranceResult_PrintPin { get; set; }

        public string InsuranceResult_PatPrintSign { get; set; }

        public string InsuranceResult_InsuPrintSign { get; set; }

        public string InsuranceResult_PhysPrintSign { get; set; }

        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string CountyName { get; set; }

        public string StateName { get; set; }
        #endregion

        #region Abstract
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    InsuranceResult = (new List<usp_GetByPatientID_Insurance_Result>(ctx.usp_GetByPatientID_Insurance(pID))).FirstOrDefault();
                }
            }

            if (InsuranceResult == null)
            {
                InsuranceResult = new usp_GetByPatientID_Insurance_Result() { IsActive = true };
            }

            #region InsuranceTypeName

            if (InsuranceResult.InsuranceTypeID > 0)
            {
                usp_GetByInsuranceTypeID_InsuranceType_Result InsTypeRes = null;

                using (EFContext ctx = new EFContext())
                {
                    InsTypeRes = (new List<usp_GetByInsuranceTypeID_InsuranceType_Result>(ctx.usp_GetByInsuranceTypeID_InsuranceType(InsuranceResult.InsuranceID))).FirstOrDefault();
                }

                if (InsTypeRes != null)
                {
                    InsuranceResult_InsType = InsTypeRes.NAME_CODE;
                }
            }

            #endregion

            #region EDI Receiver Name

            if (InsuranceResult.EDIReceiverID > 0)
            {
                usp_GetByEDIReceiverID_EDIReceiver_Result EDIRecvrRes = null;

                using (EFContext ctx = new EFContext())
                {
                    EDIRecvrRes = (new List<usp_GetByEDIReceiverID_EDIReceiver_Result>(ctx.usp_GetByEDIReceiverID_EDIReceiver(InsuranceResult.InsuranceID))).FirstOrDefault();
                }

                if (EDIRecvrRes != null)
                {
                    InsuranceResult_EDIRecvr = EDIRecvrRes.NAME_CODE;
                }
            }

            #endregion

            #region Print Pin

            if (InsuranceResult.PrintPinID > 0)
            {
                usp_GetByPrintPinID_PrintPin_Result PrintPinRes = null;

                using (EFContext ctx = new EFContext())
                {
                    PrintPinRes = (new List<usp_GetByPrintPinID_PrintPin_Result>(ctx.usp_GetByPrintPinID_PrintPin(InsuranceResult.InsuranceID))).FirstOrDefault();
                }

                if (PrintPinRes != null)
                {
                    InsuranceResult_PrintPin = PrintPinRes.NAME_CODE;
                }
            }

            #endregion

            #region PrintSign

            if (InsuranceResult.InsuranceID > 0)
            {
                usp_GetByPrintSignID_PrintSign_Result PrintSignRes = null;

                using (EFContext ctx = new EFContext())
                {
                    PrintSignRes = (new List<usp_GetByPrintSignID_PrintSign_Result>(ctx.usp_GetByPrintSignID_PrintSign(InsuranceResult.InsuranceID))).FirstOrDefault();
                }

                if (PrintSignRes != null)
                {
                    InsuranceResult_PatPrintSign = PrintSignRes.NAME_CODE_PAT;
                    InsuranceResult_InsuPrintSign = PrintSignRes.NAME_CODE_INSURED;
                    InsuranceResult_PhysPrintSign = PrintSignRes.NAME_CODE_PROVIDER;
                }
            }

            #endregion

            # region City

            if (InsuranceResult.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(InsuranceResult.CityID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CityName = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (InsuranceResult.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(InsuranceResult.CountryID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountryName = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (InsuranceResult.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(InsuranceResult.CountyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountyName = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (InsuranceResult.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(InsuranceResult.StateID, null))).FirstOrDefault();
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


    }

    #endregion
}
