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
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeModels.Models
{
    #region RelationshipAutoComplete

    public class Relationship : BaseModel
    {
        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>


        public List<string> GetAutoCompleteRelationship(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_Relationship_Result> spRes = new List<usp_GetAutoComplete_Relationship_Result>(ctx.usp_GetAutoComplete_Relationship(stats));

                foreach (usp_GetAutoComplete_Relationship_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;

            
        }


        // <summary>
         
        // </summary>
        // <param name="selText"></param>
        // <returns></returns>
        //public List<string> GetAutoCompleteStateID(string selText)
        //{
        //    List<string> retRes = new List<string>();

        //    using (EFContext ctx = new EFContext())
        //    {
        //        List<usp_GetAutoComplete_State_Result> spRes = new List<usp_GetAutoComplete_State_Result>(ctx.usp_GetAutoComplete_State(selText));

        //        foreach (usp_GetAutoComplete_State_Result item in spRes)
        //        {
        //            retRes.Add(item.NAME_CODE);
        //        }
        //    }

        //    return retRes;
        //}





        public List<string> GetAutoCompleteRelationshipID(string selText)
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
                    List<usp_GetByRelationshipName_Relationship_Result> spRes = new List<usp_GetByRelationshipName_Relationship_Result>(ctx.usp_GetByRelationshipName_Relationship(selCode, true));

                    foreach (usp_GetByRelationshipName_Relationship_Result item in spRes)
                    {
                        retRes.Add(item.RelationshipID.ToString());


                    }

                }

                return retRes;
          



  
        }
    }

    #endregion

    #region RelationshipSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class RelationshipSaveModel : BaseSaveModel
    {

        #region Properties
        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_Relationship_Result Relationship
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
            ObjectParameter RelationshipID = ObjParam("Relationship");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_Relationship(Relationship.RelationshipCode, Relationship.RelationshipName, Relationship.Comment, pUserID, RelationshipID);

                if (HasErr(RelationshipID, ctx))
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
        protected override void FillByID(byte pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    Relationship = (new List<usp_GetByPkId_Relationship_Result>(ctx.usp_GetByPkId_Relationship(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (Relationship == null)
            {
                Relationship = new usp_GetByPkId_Relationship_Result() { IsActive = true };
            }

            EncryptAudit(Relationship.RelationshipID, Relationship.LastModifiedBy, Relationship.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        /// 
        public void fillByID(byte pID, bool? pIsActive)
        {
            # region Patient

            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    Relationship = (new List<usp_GetByPkId_Relationship_Result>(ctx.usp_GetByPkId_Relationship(pID, pIsActive))).FirstOrDefault();
                }
            }

            if (Relationship == null)
            {
                Relationship = new usp_GetByPkId_Relationship_Result();
            }

            EncryptAudit(Relationship.RelationshipID, Relationship.LastModifiedBy, Relationship.LastModifiedOn);

            # endregion

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter RelationshipID = ObjParam("Relationship");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_Relationship(Relationship.RelationshipCode, Relationship.RelationshipName, Relationship.Comment, Relationship.IsActive, LastModifiedBy, LastModifiedOn, pUserID, RelationshipID);

                if (HasErr(RelationshipID, ctx))
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

    #region RelationshipSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class RelationshipSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetBySearch_Relationship_Result> RelationshipResults { get; set; }



        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public RelationshipSearchModel()
        {
        }

        #endregion

        #region Public Methods

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
                RelationshipResults = new List<usp_GetBySearch_Relationship_Result>(ctx.usp_GetBySearch_Relationship(null,null,1,200,OrderByField,OrderByDirection,pIsActive));
            }
        }

        #endregion

        #region Private Methods

        #endregion
    }

    #endregion

}
