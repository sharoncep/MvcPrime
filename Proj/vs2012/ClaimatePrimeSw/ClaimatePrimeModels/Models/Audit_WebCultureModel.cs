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
    # region WebCultureSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class WebCultureSaveModel : BaseSaveModel
    {
        # region Properties       

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public WebCultureSaveModel()
        {
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
            throw new NotImplementedException();
        }      

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();

            //ObjectParameter WebCultureID = ObjParam("WebCulture");

            //using (EFContext ctx = new EFContext())
            //{
            //    BeginDbTrans(ctx);

            //    ctx.usp_Update_WebCulture(
            //    if (HasErr(WebCultureID, ctx))
            //    {
            //        RollbackDbTrans(ctx);
            //        return false;
            //    }
            //    else
            //    {
            //        CommitDbTrans(ctx);
            //    }
            //}

            //return true;
        }

        #endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPk"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(string pPk, bool pIsActive)
        {
            ObjectParameter WebCultureID = ObjParam("WebCulture");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_WebCulture(pPk, pIsActive, WebCultureID);
                if (HasErr(WebCultureID, ctx))
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

        # endregion
    }

    # endregion

    #region WebCultureSearch
    /// <summary>
    /// 
    /// </summary>
    public class WebCultureSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_WebCulture_Result> Counties { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public WebCultureSearchModel()
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
                List<usp_GetByAZ_WebCulture_Result> lst = new List<usp_GetByAZ_WebCulture_Result>(ctx.usp_GetByAZ_WebCulture(SearchName, pIsActive));

                foreach (usp_GetByAZ_WebCulture_Result item in lst)
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
                Counties = new List<usp_GetBySearch_WebCulture_Result>(ctx.usp_GetBySearch_WebCulture(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion
}
