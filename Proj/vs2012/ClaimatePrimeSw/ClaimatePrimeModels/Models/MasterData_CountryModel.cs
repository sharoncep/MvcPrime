using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{
    #region CountryAutoCompleteModel
    public  class CountryModel : BaseModel
    {
        #region PublicMethods
        public List<string> GetAutoCompleteCountry(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Country_Result> spRes = new List<usp_GetAutoComplete_Country_Result>(ctx.usp_GetAutoComplete_Country(stats));

                foreach (usp_GetAutoComplete_Country_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }





        public List<string> GetAutoCompleteCountryID(string selText)
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
                    List<usp_GetIDAutoComplete_Country_Result> spRes = new List<usp_GetIDAutoComplete_Country_Result>(ctx.usp_GetIDAutoComplete_Country(selCode));

                    foreach (usp_GetIDAutoComplete_Country_Result item in spRes)
                    {
                        retRes.Add(item.COUNTRY_ID.ToString());
                    }
                }

                return retRes;           
        }
      
        #endregion
    }

    #endregion

    # region CountrySaveModel

    /// <summary>
    /// 
    /// </summary>
    public class CountrySaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_Country_Result Country
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CountrySaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                Country = (new List<usp_GetByPkId_Country_Result>(ctx.usp_GetByPkId_Country(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (Country == null)
            {
                Country = new usp_GetByPkId_Country_Result() { IsActive = true };
            }

            EncryptAudit(Country.CountryID, Country.LastModifiedBy, Country.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter CountryID = ObjParam("Country");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_Country(Country.CountryCode, Country.CountryName, string.Empty, pUserID, CountryID);

                if (HasErr(CountryID, ctx))
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
            ObjectParameter countryID = ObjParam("Country");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_Country(Country.CountryCode, Country.CountryName, Country.Comment, Country.IsActive, LastModifiedBy, LastModifiedOn, pUserID, countryID);

                if (HasErr(countryID, ctx))
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

    # endregion

    #region CountrySearch
    /// <summary>
    /// 
    /// </summary>
    public class CountrySearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Country_Result> Countries { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CountrySearchModel()
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
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_Country_Result> lst = new List<usp_GetByAZ_Country_Result>(ctx.usp_GetByAZ_Country(SearchName, pIsActive));

                foreach (usp_GetByAZ_Country_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                Countries = new List<usp_GetBySearch_Country_Result>(ctx.usp_GetBySearch_Country(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion
}
