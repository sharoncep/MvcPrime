
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
    #region SpecialtyAutoComplete
    public class SpecialtyModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteSpecialty(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Specialty_Result> spRes = new List<usp_GetAutoComplete_Specialty_Result>(ctx.usp_GetAutoComplete_Specialty(stats));

                foreach (usp_GetAutoComplete_Specialty_Result item in spRes)
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
        public List<string> GetAutoCompleteSpecialtyID(string selText)
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

            return ((new[] { selCode }).ToList<string>());
        }

        #endregion
    }
    #endregion

    # region SpecialtySaveModel

    /// <summary>
    /// 
    /// </summary>
    public class SpecialtySaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Specialty_Result Specialty
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SpecialtySaveModel()
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
                Specialty = (new List<usp_GetByPkId_Specialty_Result>(ctx.usp_GetByPkId_Specialty(Convert.ToByte(pID), pIsActive))).FirstOrDefault();
            }

            if (Specialty == null)
            {
                Specialty = new usp_GetByPkId_Specialty_Result() { IsActive = true };
            }

            EncryptAudit(Specialty.SpecialtyID, Specialty.LastModifiedBy, Specialty.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter SpecialtyID = ObjParam("Specialty");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

               // string selCode = Specialty.SpecialtyCode.Substring(0, 5);
                ctx.usp_Insert_Specialty(Specialty.SpecialtyCode, Specialty.SpecialtyName, Specialty.Comment, pUserID, SpecialtyID);

                if (HasErr(SpecialtyID, ctx))
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
            ObjectParameter SpecialtyID = ObjParam("Specialty");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

             //   string selCode = Specialty.SpecialtyCode.Substring(0, 5);

               ctx.usp_Update_Specialty(Specialty.SpecialtyCode, Specialty.SpecialtyName, Specialty.Comment, Specialty.IsActive, LastModifiedBy, LastModifiedOn, pUserID, SpecialtyID);

                if (HasErr(SpecialtyID, ctx))
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

    # region SpecialtySearchModel

    /// <summary>
    /// 
    /// </summary>
    public class SpecialtySearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Specialty_Result> Specialty { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SpecialtySearchModel()
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
                List<usp_GetByAZ_Specialty_Result> lst = new List<usp_GetByAZ_Specialty_Result>(ctx.usp_GetByAZ_Specialty(SearchName, pIsActive));

                foreach (usp_GetByAZ_Specialty_Result item in lst)
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
                Specialty = new List<usp_GetBySearch_Specialty_Result>(ctx.usp_GetBySearch_Specialty(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    # endregion
}
