
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
    # region CityAutoCompleteModel

    /// <summary>
    /// 
    /// </summary>
    public class CityAutoCompleteModel : BaseModel
    {
        # region Properties

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CityAutoCompleteModel()
        {
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteCity(string stats)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_City_Result> spRes = new List<usp_GetAutoComplete_City_Result>(ctx.usp_GetAutoComplete_City(stats));

                return (spRes.ConvertAll<string>(delegate(usp_GetAutoComplete_City_Result i) { return i.NAME_CODE; }));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> GetByZipCodeCity(string selText)
        {
            Int32 indx1 = selText.LastIndexOf("[");
          
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            # region SAI

            //string[] split = selText.Split("[".ToCharArray());
            //int count = split[0].Length;
            //string cityCode = selText.Substring(count + 1).Replace("]", "");

            # endregion

            using (EFContext ctx = new EFContext())
            {
                usp_GetIDAutoComplete_City_Result spRes = (new List<usp_GetIDAutoComplete_City_Result>(ctx.usp_GetIDAutoComplete_City(selCode))).FirstOrDefault();

                if (spRes != null)
                {
                    return ((new[] { spRes.CityID.ToString() }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());

           
        }

        #endregion
    }

    # endregion

    # region CitySaveModel

    /// <summary>
    /// By Sai : Admin Role or Manager Role - City Block/Unblock or City Edit/Save
    /// </summary>
    public class CitySaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_City_Result City
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CitySaveModel()
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
                City = (new List<usp_GetByPkId_City_Result>(ctx.usp_GetByPkId_City(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (City == null)
            {
                City = new usp_GetByPkId_City_Result() { IsActive = true };
            }

            EncryptAudit(City.CityID, City.LastModifiedBy, City.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter cityID = ObjParam("City");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

              
                ctx.usp_Insert_City(City.CityCode,City.ZipCode,City.CityName,string.Empty,pUserID,cityID);

                if (HasErr(cityID, ctx))
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
            ObjectParameter cityID = ObjParam("City");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
              
                ctx.usp_Update_City(City.CityCode, City.ZipCode, City.CityName, City.Comment, City.IsActive, LastModifiedBy, LastModifiedOn, pUserID, cityID);

                if (HasErr(cityID, ctx))
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

    # region CitySearchModel

    /// <summary>
    /// By Sai : Admin Role - City Block/Unblock
    /// </summary>
    public class CitySearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_City_Result> Cities { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CitySearchModel()
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
                List<usp_GetByAZ_City_Result> lst = new List<usp_GetByAZ_City_Result>(ctx.usp_GetByAZ_City(SearchName, pIsActive));

                foreach (usp_GetByAZ_City_Result item in lst)
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
                Cities = new List<usp_GetBySearch_City_Result>(ctx.usp_GetBySearch_City(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
