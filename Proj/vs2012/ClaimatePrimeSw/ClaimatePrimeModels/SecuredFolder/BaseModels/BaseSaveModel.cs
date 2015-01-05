using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Objects;
using System.Linq;
using System.Text;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;

namespace ClaimatePrimeModels.SecuredFolder.BaseModels
{
    /// <summary>
    /// http://stackoverflow.com/questions/824802/c-how-to-get-all-public-both-get-and-set-string-properties-of-a-type
    //  http://stackoverflow.com/questions/1288310/activator-createinstance-how-to-create-instances-of-classes-that-have-paramete
    /// </summary>
    public abstract class BaseSaveModel : BaseModel
    {
        # region Private Variables

        private global::System.Int64 _ID;
        private usp_GetByPkId_ErrorLog_Result _Error;
        private DbTransaction _DbTrans;

        # endregion

        # region Protected Properties

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int64 LastModifiedBy
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.DateTime LastModifiedOn
        {
            get;
            private set;
        }

        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public string AntiForgTokn
        {
            get
            {
                StringBuilder retAns = new StringBuilder();


                retAns.Append(((new Random()).Next(1, 9)));    // 0
                retAns.Append("_");

                retAns.Append(this._ID);    // 1
                retAns.Append("_");

                retAns.Append(this.LastModifiedBy);        // 2
                retAns.Append("_");

                retAns.Append(this.LastModifiedOn.Year);       // 3
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Month);      // 4
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Day);        // 5
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Hour);       // 6
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Minute);     // 7
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Second);     // 8
                retAns.Append("_");
                retAns.Append(this.LastModifiedOn.Millisecond);    // 9

                retAns.Append("_");
                retAns.Append(((new Random()).Next(1, 9)));     // 10

                return retAns.ToString();
            }
            set
            {
                if (!(string.IsNullOrWhiteSpace(value)))
                {
                    string[] retAns = value.Split(Convert.ToChar("_"));

                    if (retAns.Length != 11)
                    {
                        throw new Exception("Sorry! Unauthorized call to VerifyAudit");
                    }

                    this._ID = Convert.ToInt64(retAns[1]);

                    this.LastModifiedBy = Convert.ToInt64(retAns[2]);

                    this.LastModifiedOn = new DateTime(Convert.ToInt32(retAns[3]), Convert.ToInt32(retAns[4]), Convert.ToInt32(retAns[5])
                                                    , Convert.ToInt32(retAns[6]), Convert.ToInt32(retAns[7]), Convert.ToInt32(retAns[8])
                                                    , Convert.ToInt32(retAns[9]));
                }
            }
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String ErrorMsg
        {
            get
            {
                if ((_Error != null) && (_Error.ErrorLogID > 0))
                {
                    return string.Concat(" Error Message : (", _Error.ErrorLogID, ") : ", _Error.ErrorMessage);
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Boolean HasError
        {
            get
            {
                return (string.IsNullOrWhiteSpace(ErrorMsg) ? false : true);
            }
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseSaveModel()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        public void Fill(Nullable<bool> pIsActive)
        {
            Fill(this._ID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        public void Fill(global::System.Int64 pID, Nullable<bool> pIsActive)
        {
            FillByID(pID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        public void Fill(global::System.Int32 pID, Nullable<bool> pIsActive)
        {
            FillByID(pID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        public void Fill(global::System.Int16 pID, Nullable<bool> pIsActive)
        {
            FillByID(pID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        public void Fill(global::System.Byte pID, Nullable<bool> pIsActive)
        {
            FillByID(pID, pIsActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID)
        {
            if (this._ID == 0)
            {
                return SaveInsert(pUserID);
            }

            return SaveUpdate(pUserID);
        }

        # endregion

        # region Protected Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        protected void EncryptAudit(global::System.Int64 pID)
        {
            EncryptAudit(pID, 0, DateTime.MinValue);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pLastModifiedBy"></param>
        /// <param name="pLastModifiedOn"></param>
        protected void EncryptAudit(global::System.Int64 pID, global::System.Int64 pLastModifiedBy, global::System.DateTime pLastModifiedOn)
        {
            this._ID = pID;
            this.LastModifiedBy = pLastModifiedBy;
            this.LastModifiedOn = pLastModifiedOn;

            if ((this._ID == 0) || (this.LastModifiedBy == 0))
            {
                this.LastModifiedOn = DateTime.Now;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pParamName"></param>
        /// <param name="pType"></param>
        /// <param name="pValue"></param>
        /// <returns></returns>
        protected ObjectParameter ObjParam(string pParamName, Type pType, Object pValue)
        {
            return (new ObjectParameter(pParamName, pType) { Value = pValue });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pParam"></param>
        /// <param name="ctx"></param>
        /// <returns></returns>
        protected global::System.Boolean HasErr(ObjectParameter pParam, EFContext ctx)
        {
            Int64 sID = Converts.AsInt64(pParam.Value);

            if (sID == 0)
            {
                throw new Exception("Unexpected error while saving the record");
            }

            if (sID < 0)
            {
                _Error = (new List<usp_GetByPkId_ErrorLog_Result>(ctx.usp_GetByPkId_ErrorLog((sID * -1)))).FirstOrDefault();
            }

            return HasError;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCtx"></param>
        protected void BeginDbTrans(EFContext pCtx)
        {
            ((System.Data.Entity.Infrastructure.IObjectContextAdapter)pCtx).ObjectContext.Connection.Open();
            _DbTrans = ((System.Data.Entity.Infrastructure.IObjectContextAdapter)pCtx).ObjectContext.Connection.BeginTransaction();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCtx"></param>
        protected void RollbackDbTrans(EFContext pCtx)
        {
            _DbTrans.Rollback();
            ((System.Data.Entity.Infrastructure.IObjectContextAdapter)pCtx).ObjectContext.Connection.Close();
            SaveErr();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCtx"></param>
        protected void CommitDbTrans(EFContext pCtx)
        {
            _DbTrans.Commit();
            ((System.Data.Entity.Infrastructure.IObjectContextAdapter)pCtx).ObjectContext.Connection.Close();
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// This will generate table primary key in-put / out-put param
        /// </summary>
        /// <param name="pTableName"></param>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public ObjectParameter ObjParam(string pTableName)
        {
            return ObjParam(string.Concat(pTableName, "ID"), typeof(global::System.Int64), this._ID);
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        private void SaveErr()
        {
            if (_Error == null)
            {
                _Error = new usp_GetByPkId_ErrorLog_Result();
            }

            if (_Error.ErrorLogID > 0)
            {
                using (EFContext cntx = new EFContext())
                {
                    cntx.usp_Update_ErrorLog(_Error.ErrorLogID, _Error.ErrorNumber, _Error.ErrorMessage, _Error.ErrorSeverity, _Error.ErrorState, _Error.ErrorLine, _Error.ErrorProcedure);
                }
            }
        }

        # endregion

        # region Virtual Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected virtual void FillByID(global::System.Int64 pID, Nullable<bool> pIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected virtual void FillByID(global::System.Int32 pID, Nullable<bool> pIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected virtual void FillByID(global::System.Int16 pID, Nullable<bool> pIsActive)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected virtual void FillByID(global::System.Byte pID, Nullable<bool> pIsActive)
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        protected abstract bool SaveInsert(global::System.Int32 pUserID);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        protected abstract bool SaveUpdate(global::System.Int32 pUserID);

        # endregion
    }
}
