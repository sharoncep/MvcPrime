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
    #region EDIFileSearchModel

    /// <summary>
    /// 
    /// </summary>
    public class EDIFileSearchModel : BaseSearchModel
    {


        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetBySearch_EDIFile_Result> EDIFileResults { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<EDIFileSearchSubModel> EDIFileSearchSubModels { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>

        public System.Int32 ClinicID { get; set; }


        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DOSFrom
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Nullable<global::System.DateTime> DOSTo
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIFileSearchModel()
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
            //if (!((DateFrom.HasValue) || (DateTo.HasValue)))
            //{
            //    FillDates();
            //}
            using (EFContext ctx = new EFContext())
            {
                EDIFileResults = new List<usp_GetBySearch_EDIFile_Result>(ctx.usp_GetBySearch_EDIFile(ClinicID, SearchName, DateFrom, DateTo, DOSFrom, DOSTo, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }

            EDIFileSearchSubModels = new List<EDIFileSearchSubModel>();
        }

        #endregion

        #region Private Methods

        //private void FillDates()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        usp_GetDate_EDIFile_Result spRes = (new List<usp_GetDate_EDIFile_Result>(ctx.usp_GetDate_EDIFile(ClinicID))).FirstOrDefault();

        //        DateFrom = spRes.DOS_FROM;
        //        DateTo = spRes.DOS_TO;
        //    }
        //}

        #endregion
    }

    #endregion

    # region EDIFileSearchSubModel

    /// <summary>
    /// 
    /// </summary>
    public class EDIFileSearchSubModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public long EDIFileID { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string X12FileSvrPath { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string RefFileSvrPath { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string FileDate { get; set; }

        # endregion
    }

    # endregion

    #region EDIFileRespondSearchSubModel
    public class EDIRespondSearchSubModel : EDIFileSearchSubModel
    {
        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIRespondSearchSubModel()
        {
        }

        #endregion
    }
    #endregion

    #region EDIPatientVisitSearchModel
    /// <summary>
    /// 
    /// </summary>
    public class EDIPatientVisitSearchModel : BaseSearchModel
    {
        # region Properties

        public List<usp_GetByEDI_PatientVisit_Result> EDIPatientVisit { get; set; }

        public Int32 EDIFileID { get; set; }

        public Int32 ClinicID { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public EDIPatientVisitSearchModel()
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
                List<usp_GetByAZEDI_PatientVisit_Result> lst = new List<usp_GetByAZEDI_PatientVisit_Result>(ctx.usp_GetByAZEDI_PatientVisit(EDIFileID, ClinicID, DateFrom, DateTo, SearchName));

                foreach (usp_GetByAZEDI_PatientVisit_Result item in lst)
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
                EDIPatientVisit = new List<usp_GetByEDI_PatientVisit_Result>(ctx.usp_GetByEDI_PatientVisit(EDIFileID, ClinicID, DateFrom, DateTo, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection));
            }
        }

        #endregion

        #region Private Methods



        # endregion
    }
    #endregion
}
