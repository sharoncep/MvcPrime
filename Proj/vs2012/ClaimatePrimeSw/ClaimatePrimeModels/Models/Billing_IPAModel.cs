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
    #region IPAAutoComplete
    public class IPAModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteIPA(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_IPA_Result> spRes = new List<usp_GetAutoComplete_IPA_Result>(ctx.usp_GetAutoComplete_IPA(stats));

                foreach (usp_GetAutoComplete_IPA_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteIPAID(string selText)
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
                List<usp_GetIDAutoComplete_IPA_Result> spRes = new List<usp_GetIDAutoComplete_IPA_Result>(ctx.usp_GetIDAutoComplete_IPA(selCode));

                foreach (usp_GetIDAutoComplete_IPA_Result item in spRes)
                {
                    retRes.Add(item.IPAID.ToString());
                }
            }

            return retRes;
        }

        #endregion
    }
    #endregion

    #region BillingIPAModel-Assigend Claims

    public class BillingIPAModel:BaseSaveModel
    {

        # region Properties

        public usp_GetByClinicID_IPA_Result IPA_Result
        {
            get;
            set;
        }

        public string EntityName { get; set; }

        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string CountyName { get; set; }

        public string StateName { get; set; }

        #endregion

        #region Abstract
        protected override void FillByID(int pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    IPA_Result = (new List<usp_GetByClinicID_IPA_Result>(ctx.usp_GetByClinicID_IPA(pID))).FirstOrDefault();
                }
            }

            if (IPA_Result == null)
            {
                IPA_Result = new usp_GetByClinicID_IPA_Result() { IsActive = true };
            }

            #region EntityName

            if (IPA_Result.EntityTypeQualifierID > 0)
            {
                usp_GetNameByID_EntityTypeQualifier_Result EntityRes = null;

                using (EFContext ctx = new EFContext())
                {
                    EntityRes = (new List<usp_GetNameByID_EntityTypeQualifier_Result>(ctx.usp_GetNameByID_EntityTypeQualifier(IPA_Result.EntityTypeQualifierID, null))).FirstOrDefault();
                }

                if (EntityRes != null)
                {
                    EntityName = EntityRes.NAME_CODE;
                }
            }

            #endregion

            # region City

            if (IPA_Result.CityID > 0)
            {
                usp_GetNameByID_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameByID_City_Result>(ctx.usp_GetNameByID_City(IPA_Result.CityID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CityName = string.Concat(stateRes.CityName, " [", stateRes.ZipCode, "]");
                }
            }

            # endregion

            # region Country

            if (IPA_Result.CountryID > 0)
            {
                usp_GetNameById_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetNameById_Country_Result>(ctx.usp_GetNameById_Country(IPA_Result.CountryID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountryName = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }
            }

            # endregion

            # region County

            if (IPA_Result.CountyID > 0)
            {
                usp_GetByPkIdCountyName_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdCountyName_County_Result>(ctx.usp_GetByPkIdCountyName_County(IPA_Result.CountyID, null))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    CountyName = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }
            }

            # endregion

            # region State

            if (IPA_Result.StateID > 0)
            {
                usp_GetByPkIdStateName_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkIdStateName_State_Result>(ctx.usp_GetByPkIdStateName_State(IPA_Result.StateID, null))).FirstOrDefault();
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

    #region IPASaveModel

    /// <summary>
    /// 
    /// </summary>
    public class IPASaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_IPA_Result IPA
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
        public global::System.String FileSvrIPALogoPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String IPA_EntityTypeQualifier
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String IPA_City
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String IPA_State
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String IPA_County
        {
            get;
            set;
        }
        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String IPA_Country
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
            ObjectParameter IPAID = ObjParam("IPA");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               

               ctx.usp_Insert_IPA(IPA.IPACode,IPA.IPAName,IPA.NPI,IPA.TaxID,IPA.EntityTypeQualifierID,IPA.LogoRelPath,IPA.StreetName,IPA.Suite,IPA.CityID,IPA.StateID,IPA.CountyID,IPA.CountryID,IPA.PhoneNumber,IPA.PhoneNumberExtn,IPA.SecondaryPhoneNumber,IPA.SecondaryPhoneNumberExtn,IPA.Email,IPA.SecondaryEmail,IPA.Fax,IPA.ContactPersonLastName,IPA.ContactPersonMiddleName,IPA.ContactPersonFirstName,IPA.ContactPersonPhoneNumber,IPA.ContactPersonPhoneNumberExtn,IPA.ContactPersonSecondaryPhoneNumber,IPA.ContactPersonSecondaryPhoneNumberExtn,IPA.ContactPersonEmail,IPA.ContactPersonSecondaryEmail,IPA.ContactPersonFax,IPA.Comment,pUserID,IPAID);

                if (HasErr(IPAID, ctx))
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
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    IPA = (new List<usp_GetByPkId_IPA_Result>(ctx.usp_GetByPkId_IPA(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (IPA == null)
            {
                IPA = new usp_GetByPkId_IPA_Result() { IsActive = true };
            }
            # region Auto Complete Fill

            # region EntityTypeQualifier

            if (IPA.EntityTypeQualifierID > 0)
            {
                usp_GetByPkId_EntityTypeQualifier_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_EntityTypeQualifier_Result>(ctx.usp_GetByPkId_EntityTypeQualifier(IPA.EntityTypeQualifierID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IPA_EntityTypeQualifier = string.Concat(stateRes.EntityTypeQualifierName, " [", stateRes.EntityTypeQualifierCode, "]");
                }

            }


            # endregion


            # region City

            if (IPA.CityID > 0)
            {
                usp_GetByPkId_City_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(IPA.CityID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IPA_City = string.Concat(stateRes.CityName, " [", stateRes.CityCode, "]");
                }

            }
           

            # endregion


            # region State

            if (IPA.StateID > 0)
            {
                usp_GetByPkId_State_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(IPA.StateID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IPA_State = string.Concat(stateRes.StateName, " [", stateRes.StateCode, "]");
                }


            }
           

            # endregion


            # region County

            if (IPA.CountyID > 0)
            {
                usp_GetByPkId_County_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_County_Result>(ctx.usp_GetByPkId_County(IPA.CountyID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IPA_County = string.Concat(stateRes.CountyName, " [", stateRes.CountyCode, "]");
                }

            }
            

            # endregion

            # region Country

            if (IPA.CountryID > 0)
            {
                usp_GetByPkId_Country_Result stateRes = null;

                using (EFContext ctx = new EFContext())
                {
                    stateRes = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(IPA.CountryID, pIsActive))).FirstOrDefault();
                }

                if (stateRes != null)
                {
                    IPA_Country = string.Concat(stateRes.CountryName, " [", stateRes.CountryCode, "]");
                }

            }
           

            # endregion

            # endregion

            EncryptAudit(IPA.IPAID, IPA.LastModifiedBy, IPA.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        /// 
        public void fillByID(byte pID, bool? pIsActive)
        {
            # region IPA

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    IPA = (new List<usp_GetByPkId_IPA_Result>(ctx.usp_GetByPkId_IPA(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (IPA == null)
            {
                IPA = new usp_GetByPkId_IPA_Result();
            }

            EncryptAudit(IPA.IPAID, IPA.LastModifiedBy, IPA.LastModifiedOn);

            # endregion

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter IPAID = ObjParam("IPA");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Update_IPA(IPA.IPACode, IPA.IPAName, IPA.NPI, IPA.TaxID, IPA.EntityTypeQualifierID, IPA.LogoRelPath, IPA.StreetName, IPA.Suite, IPA.CityID, IPA.StateID, IPA.CountyID, IPA.CountryID, IPA.PhoneNumber, IPA.PhoneNumberExtn, IPA.SecondaryPhoneNumber, IPA.SecondaryPhoneNumberExtn, IPA.Email, IPA.SecondaryEmail, IPA.Fax, IPA.ContactPersonLastName, IPA.ContactPersonMiddleName, IPA.ContactPersonFirstName, IPA.ContactPersonPhoneNumber, IPA.ContactPersonPhoneNumberExtn, IPA.ContactPersonSecondaryPhoneNumber, IPA.ContactPersonSecondaryPhoneNumberExtn, IPA.ContactPersonEmail, IPA.ContactPersonSecondaryEmail, IPA.ContactPersonFax, IPA.Comment, IPA.IsActive, LastModifiedBy, LastModifiedOn, pUserID, IPAID);

                if (HasErr(IPAID, ctx))
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

    #region IPASearchModel

    /// <summary>
    /// 
    /// </summary>
    public class IPASearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_IPA_Result> IPAs { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public usp_GetById_IPA_Result IPA
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public IPASearchModel()
        {
        }

        #endregion

        #region Public Methods

        public void fillByID(long pID, bool? pIsActive)
        {
            # region IPA

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    IPA = (new List<usp_GetById_IPA_Result>(ctx.usp_GetById_IPA(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
                }
            }

            if (IPA == null)
            {
                IPA = new usp_GetById_IPA_Result();
            }

          

            # endregion

        }
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
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                IPAs = new List<usp_GetBySearch_IPA_Result>(ctx.usp_GetBySearch_IPA(null, null, 1, 200, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion
}
