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
    #region StateAutoComplete
    public  class StateModel : BaseModel
    {
        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteState(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_State_Result> spRes = new List<usp_GetAutoComplete_State_Result>(ctx.usp_GetAutoComplete_State(stats));

                foreach (usp_GetAutoComplete_State_Result item in spRes)
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
        public List<string> GetAutoCompleteStateID(string selText)
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
                    List<usp_GetIDAutoComplete_State_Result> spRes = new List<usp_GetIDAutoComplete_State_Result>(ctx.usp_GetIDAutoComplete_State(selCode));

                    foreach (usp_GetIDAutoComplete_State_Result item in spRes)
                    {
                        retRes.Add(item.STATE_ID.ToString());
                    }
                }

                return retRes;           
        }

        #endregion
    }
    #endregion

    # region StateSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class StateSaveModel : BaseSaveModel
    {
        # region Properties
        public usp_GetByPkId_State_Result State
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public StateSaveModel()
        {
        }

        #endregion

        #region Abstract Methods

        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                State = (new List<usp_GetByPkId_State_Result>(ctx.usp_GetByPkId_State(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();
            }

            if (State == null)
            {
                State = new usp_GetByPkId_State_Result() { IsActive = true };
            }

            EncryptAudit(State.StateID, State.LastModifiedBy, State.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter StateID = ObjParam("State");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);


                ctx.usp_Insert_State(State.StateCode, State.StateName, string.Empty, pUserID, StateID);

                if (HasErr(StateID, ctx))
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
            ObjectParameter StateID = ObjParam("State");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_State(State.StateCode, State.StateName, State.Comment, State.IsActive, LastModifiedBy, LastModifiedOn, pUserID, StateID);
                if (HasErr(StateID, ctx))
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

    #region StateSearch
    /// <summary>
    /// 
    /// </summary>
    public class StateSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_State_Result> Counties { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public StateSearchModel()
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
                List<usp_GetByAZ_State_Result> lst = new List<usp_GetByAZ_State_Result>(ctx.usp_GetByAZ_State(SearchName, pIsActive));

                foreach (usp_GetByAZ_State_Result item in lst)
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
                Counties = new List<usp_GetBySearch_State_Result>(ctx.usp_GetBySearch_State(SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }
    #endregion
}
