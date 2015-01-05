using System;
using System.Collections.Generic;
using System.Linq;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.SecuredFolder.BaseModels
{
    /// <summary>
    /// http://stackoverflow.com/questions/824802/c-how-to-get-all-public-both-get-and-set-string-properties-of-a-type
    //  http://stackoverflow.com/questions/1288310/activator-createinstance-how-to-create-instances-of-classes-that-have-paramete
    /// </summary>
    public abstract class BaseSearchModel : BaseModel
    {
        # region Private Variables

        private List<AZModel> _AZModels;

        # endregion

        # region Protected Properties

        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 CurrNumber
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String SearchName
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DateFrom
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DateTo
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String StartBy
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String OrderByField
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String OrderByDirection
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.Boolean HasRec
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseSearchModel()
        {
            this._AZModels = new List<AZModel>();
            this.StartBy = "A";
            this.OrderByField = "LastModifiedOn";
            this.OrderByDirection = "D";
            this.HasRec = false;
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        public void Fill(Nullable<global::System.Boolean> pIsActive)
        {
            Fill(0, pIsActive, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        public void Fill(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            FillCs(pIsActive);
            FillJs(pCurrPageNumber, pIsActive, pRecordsPerPage);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        public void FillCs(Nullable<global::System.Boolean> pIsActive)
        {
            FillByAZ(pIsActive);
            VerifyStartBy();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        public void FillJs(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            FillBySearch(pCurrPageNumber, pIsActive, pRecordsPerPage);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<AZModel> AZModels()
        {
            return this._AZModels;
        }

        # endregion

        # region Protected Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pAZModel"></param>
        protected void AZModels(AZModel pAZModel)
        {
            this._AZModels.Add(pAZModel);

            if (!((this.HasRec) || (pAZModel.AZ_COUNT == 0)))
            {
                this.HasRec = true;
            }
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        private void VerifyStartBy()
        {
            List<string> tmpAz = new List<string>(from oSB in _AZModels where (oSB.AZ_COUNT > 0) select oSB.AZ);

            if (tmpAz.Count == 0)
            {
                StartBy = "Z";
                return;
            }

            string tmpStBy = StartBy;

            tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) == 0 select oAz).FirstOrDefault();
            if (!(string.IsNullOrWhiteSpace(tmpStBy)))
            {
                return;
            }

            tmpStBy = StartBy;
            tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) < 0 select oAz).FirstOrDefault();
            if (!(string.IsNullOrWhiteSpace(tmpStBy)))
            {
                StartBy = tmpStBy;
                return;
            }

            tmpStBy = StartBy;
            tmpStBy = (from oAz in tmpAz where string.Compare(tmpStBy, oAz, true) > 0 select oAz).FirstOrDefault();
            if (!(string.IsNullOrWhiteSpace(tmpStBy)))
            {
                StartBy = tmpStBy;
                return;
            }

            StartBy = "Z";
        }

        # endregion

        # region Virtual Methods

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected abstract void FillByAZ(Nullable<global::System.Boolean> pIsActive);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected abstract void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage);

        # endregion
    }
}
