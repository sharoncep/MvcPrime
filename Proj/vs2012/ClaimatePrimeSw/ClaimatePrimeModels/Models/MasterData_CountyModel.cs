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
    # region CityAutoCompleteModel
    public class CountyModel : BaseModel
    {
        #region PublicMethods


        public List<string> GetAutoCompleteCounty(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_County_Result> spRes = new List<usp_GetAutoComplete_County_Result>(ctx.usp_GetAutoComplete_County(stats));

                foreach (usp_GetAutoComplete_County_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }
        public List<string> GetAutoCompleteCountyID(string selText)
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
                List<usp_GetIDAutoComplete_County_Result> spRes = new List<usp_GetIDAutoComplete_County_Result>(ctx.usp_GetIDAutoComplete_County(selCode));

                foreach (usp_GetIDAutoComplete_County_Result item in spRes)
                {
                    retRes.Add(item.COUNTY_ID.ToString());


                }

            }

            return retRes;
        }



        #endregion
    }
    #endregion

    # region CountySaveModel

    /// <summary>
    /// 
    /// </summary>
    public class CountySaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_County_Result County
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CountySaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                County = (new List<usp_GetByPkId_County_Result>(ctx.usp_GetByPkId_County(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (County == null)
            {
                County = new usp_GetByPkId_County_Result() { IsActive = true };
            }

            EncryptAudit(County.CountyID, County.LastModifiedBy, County.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter countyID = ObjParam("County");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_County(County.CountyCode, County.CountyName, string.Empty, pUserID, countyID);

                if (HasErr(countyID, ctx))
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
            ObjectParameter CountyID = ObjParam("County");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_County(County.CountyCode, County.CountyName, County.Comment, County.IsActive, LastModifiedBy, LastModifiedOn, pUserID, CountyID);
                if (HasErr(CountyID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                else
                {
                    CommitDbTrans(ctx);
                }
            }

            return true;
        }

        #endregion
    }

    # endregion

    #region CountySearch
    /// <summary>
    /// 
    /// </summary>
    public class CountySearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_County_Result> Counties { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CountySearchModel()
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
                List<usp_GetByAZ_County_Result> lst = new List<usp_GetByAZ_County_Result>(ctx.usp_GetByAZ_County(SearchName, pIsActive));

                foreach (usp_GetByAZ_County_Result item in lst)
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
                Counties = new List<usp_GetBySearch_County_Result>(ctx.usp_GetBySearch_County(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion
}
