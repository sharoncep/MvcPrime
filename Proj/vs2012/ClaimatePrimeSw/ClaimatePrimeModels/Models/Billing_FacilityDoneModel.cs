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


    #region Facility Done - Assigned Claims

    public class FacilityDoneViewModel : BaseSaveModel
    {
        #region Properties

        public usp_GetByPkId_FacilityDone_Result FacilityDoneResult { get; set; }


        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string CountyName { get; set; }

        public string StateName { get; set; }

        public string FacilityTypeName { get; set; }


        #endregion

        #region Abstract

       

        protected override void FillByID(int pID, bool? pIsActive)
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



            # region FacilityType

            if (FacilityDoneResult.FacilityTypeID > 0)
            {
                usp_GetNameByID_FacilityType_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_FacilityType_Result>(ctx.usp_GetNameByID_FacilityType(FacilityDoneResult.FacilityTypeID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityTypeName = stateRes.NAME_CODE;
                }
            }

            # endregion

            # region City

            if (FacilityDoneResult.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(FacilityDoneResult.CityID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CityName = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (FacilityDoneResult.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(FacilityDoneResult.CountryID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountryName = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (FacilityDoneResult.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(FacilityDoneResult.CountyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountyName = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (FacilityDoneResult.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(FacilityDoneResult.StateID, null))).FirstOrDefault();
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

    # region FacilityDoneSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class FacilityDoneSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_FacilityDone_Result> FacilityDone { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public FacilityDoneSearchModel()
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
                List<usp_GetByAZ_FacilityDone_Result> lst = new List<usp_GetByAZ_FacilityDone_Result>(ctx.usp_GetByAZ_FacilityDone(SearchName, pIsActive));

                foreach (usp_GetByAZ_FacilityDone_Result item in lst)
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
                FacilityDone = new List<usp_GetBySearch_FacilityDone_Result>(ctx.usp_GetBySearch_FacilityDone(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion

    #region FacilityDoneSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class FacilityDoneSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_FacilityDone_Result FacilityDone
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public string FacilityDone_FacilityType
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public string FacilityDone_State
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public string FacilityDone_City
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public string FacilityDone_County
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public string FacilityDone_Country
        {
            get;
            set;
        }


        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter FacilityDoneID = ObjParam("FacilityDone");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_FacilityDone(FacilityDone.FacilityDoneCode, FacilityDone.FacilityDoneName, FacilityDone.NPI, FacilityDone.TaxID, FacilityDone.FacilityTypeID, FacilityDone.StreetName, FacilityDone.Suite, FacilityDone.CityID, FacilityDone.StateID, FacilityDone.CountyID, FacilityDone.CountryID, FacilityDone.PhoneNumber, FacilityDone.PhoneNumberExtn, FacilityDone.SecondaryPhoneNumber, FacilityDone.SecondaryPhoneNumberExtn, FacilityDone.Email, FacilityDone.SecondaryEmail, FacilityDone.Fax, FacilityDone.ContactPersonLastName, FacilityDone.ContactPersonMiddleName, FacilityDone.ContactPersonFirstName, FacilityDone.ContactPersonPhoneNumber, FacilityDone.ContactPersonPhoneNumberExtn, FacilityDone.ContactPersonSecondaryPhoneNumber, FacilityDone.ContactPersonSecondaryPhoneNumberExtn, FacilityDone.ContactPersonEmail, FacilityDone.ContactPersonSecondaryEmail, FacilityDone.ContactPersonFax, FacilityDone.Comment, pUserID, FacilityDoneID);

                if (HasErr(FacilityDoneID, ctx))
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
        /// <param name="ppIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    FacilityDone = (new List<usp_GetByPkId_FacilityDone_Result>(ctx.usp_GetByPkId_FacilityDone(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (FacilityDone == null)
            {
                FacilityDone = new usp_GetByPkId_FacilityDone_Result() { IsActive = true };
            }

            # region Auto Complete Fill

            # region FacilityType

            if (FacilityDone.FacilityTypeID > 0)
            {
                usp_GetByPkId_FacilityType_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_FacilityType_Result>(ctx.usp_GetByPkId_FacilityType(FacilityDone.FacilityTypeID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityDone_FacilityType = string.Concat(stateRes.FacilityTypeName, " [", stateRes.FacilityTypeCode, "]");
                }

            }


            # endregion


            # region City

            if (FacilityDone.CityID > 0)
            {
                usp_GetByPkId_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(FacilityDone.CityID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityDone_City = string.Concat(stateRes.CityName, " [", stateRes.CityCode, "]");
                }

            }
            else
            {
                FacilityDone.CityID = null;
            }

            # endregion


            # region State

            if (FacilityDone.StateID > 0)
            {
                usp_GetByPkId_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(FacilityDone.StateID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityDone_State = string.Concat(stateRes.StateName, " [", stateRes.StateCode, "]");
                }


            }
            else
            {
                FacilityDone.StateID = null;
            }

            # endregion


            # region County

            if (FacilityDone.CountyID > 0)
            {
                usp_GetByPkId_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_County_Result>(ctx.usp_GetByPkId_County(FacilityDone.CountyID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityDone_County = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }

            }
            else
            {
                FacilityDone.CountyID = null;
            }

            # endregion

            # region Country

            if (FacilityDone.CountryID > 0)
            {
                usp_GetByPkId_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(FacilityDone.CountryID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    FacilityDone_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }

            }
            else
            {
                FacilityDone.CountryID = null;
            }

            # endregion

            # endregion

            EncryptAudit(FacilityDone.FacilityDoneID, FacilityDone.LastModifiedBy, FacilityDone.LastModifiedOn);
        }

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="pUserID"></param>
        ///// <returns></returns>
        ///// 
        //public void fillByID(byte pID, bool? ppIsActive)
        //{
        //    # region Patient

        //    if (pID > 0)
        //    {
        //        using (EFContext ctx = new EFContext())
        //        {
        //            FacilityDone = (new List<usp_GetByPkId_FacilityDone_Result>(ctx.usp_GetByPkId_FacilityDone(pID, ppIsActive))).FirstOrDefault();
        //        }
        //    }

        //    if (FacilityDone == null)
        //    {
        //        FacilityDone = new usp_GetByPkId_FacilityDone_Result();
        //    }

        //    EncryptAudit(FacilityDone.FacilityDoneID, FacilityDone.LastModifiedBy, FacilityDone.LastModifiedOn);

        //    # endregion

        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter FacilityDoneID = ObjParam("FacilityDone");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_FacilityDone(FacilityDone.FacilityDoneCode, FacilityDone.FacilityDoneName, FacilityDone.NPI, FacilityDone.TaxID, FacilityDone.FacilityTypeID, FacilityDone.StreetName, FacilityDone.Suite, FacilityDone.CityID, FacilityDone.StateID, FacilityDone.CountyID, FacilityDone.CountryID, FacilityDone.PhoneNumber, FacilityDone.PhoneNumberExtn, FacilityDone.SecondaryPhoneNumber, FacilityDone.SecondaryPhoneNumberExtn, FacilityDone.Email, FacilityDone.SecondaryEmail, FacilityDone.Fax, FacilityDone.ContactPersonLastName, FacilityDone.ContactPersonMiddleName, FacilityDone.ContactPersonFirstName, FacilityDone.ContactPersonPhoneNumber, FacilityDone.ContactPersonPhoneNumberExtn, FacilityDone.ContactPersonSecondaryPhoneNumber, FacilityDone.ContactPersonSecondaryPhoneNumberExtn, FacilityDone.ContactPersonEmail, FacilityDone.ContactPersonSecondaryEmail, FacilityDone.ContactPersonFax, FacilityDone.Comment, FacilityDone.IsActive, LastModifiedBy, LastModifiedOn, pUserID, FacilityDoneID);

                if (HasErr(FacilityDoneID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

    }

    #endregion
}
