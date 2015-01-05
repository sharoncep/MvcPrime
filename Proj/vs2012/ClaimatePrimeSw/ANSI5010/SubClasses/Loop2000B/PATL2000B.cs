using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PATL2000B : Base5010
    {
        #region Properties

        /// <summary>
        /// PAT05
        /// </summary>
        [ANSI5010Field(false, 2, 3)]
        public string P001_DateTimePeriodFormatQualifier { protected get; set; }

        /// <summary>
        /// PAT06
        /// </summary>
        [ANSI5010Field(false, 1, 35)]
        public string P002_DateTimePeriod { protected get; set; }

        /// <summary>
        /// PAT07
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P003_UnitOrBasisForMeasurementCode { protected get; set; }

        /// <summary>
        /// PAT08
        /// </summary>
        [ANSI5010Field(false, 1, 10)]
        public string P004_Weight { protected get; set; }

        /// <summary>
        /// PAT09
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P005_YesNoConditionOrResponseCode { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public PATL2000B(string pLoopChartRef)
            : base("PAT", "L2000B: PATIENT INFO", pLoopChartRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected PATL2000B(string pLoopNameRef, string pLoopChartRef)
            : base("PAT", pLoopNameRef, pLoopChartRef)
        {
        }

        # endregion
    }
}
