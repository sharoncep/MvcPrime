using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class SBRL2000B : Base5010
    {
        #region Properties

        /// <summary>
        /// SBR01
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P001_PayerResponsibilitySequenceNumberCode { private get; set; }

        /// <summary>
        /// SBR02
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P002_IndividualRelationshipCode { private get; set; }

        /// <summary>
        /// SBR03
        /// </summary>
        [ANSI5010Field(false, 1, 50)]
        public string P003_ReferenceIdentification { private get; set; }

        /// <summary>
        /// SBR04
        /// </summary>
        [ANSI5010Field(false, 1, 60)]
        public string P004_Name { private get; set; }

        /// <summary>
        /// SBR05
        /// </summary>
        [ANSI5010Field(false, 1, 3)]
        public string P005_InsuranceTypeCode { private get; set; }

        /// <summary>
        /// SBR06
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P006_NOT_USED { private get; set; }

        /// <summary>
        /// SBR07
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P007_NOT_USED { private get; set; }

        /// <summary>
        /// SBR08
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P008_NOT_USED { private get; set; }

        /// <summary>
        /// SBR09
        /// </summary>
        [ANSI5010Field(false, 1,2)]
        public string P009_ClaimFilingIndicatorCode { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public SBRL2000B(string pLoopChartRef)
            : base("SBR", "L2000B: SUBSCRIBER INFO", pLoopChartRef)
        {
        }

        # endregion
    }
}
