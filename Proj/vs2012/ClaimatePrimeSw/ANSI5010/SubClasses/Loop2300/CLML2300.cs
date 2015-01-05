using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2300
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class CLML2300 : Base5010
    {
        #region Properties

        /// <summary>
        /// CLM01
        /// </summary>
        [ANSI5010Field(true, 1, 38)]
        public string P001_ClaimSubmittersIdentifier { protected get; set; }

        /// <summary>
        /// CLM02
        /// </summary>
        [ANSI5010Field(true, 1, 18)]
        public string P002_MonetaryAmount { protected get; set; }

        /// <summary>
        /// CLM03
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P003_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM04
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P004_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM05
        /// </summary>
        [ANSI5010Field(true, 0, int.MaxValue)]
        public string P005_HealthCareServiceLocationInformation { protected get; set; }

        /// <summary>
        /// CLM05-01
        /// </summary>
        [ANSI5010Field(true, 1, 2, true)]
        public string P006_FacilityCodeValue { protected get; set; }

        /// <summary>
        /// CLM05-02 
        /// </summary>
        [ANSI5010Field(true, 1, 2, true)]
        public string P007_FacilityCodeQualifier { protected get; set; }

        /// <summary>
        /// CLM05-03
        /// </summary>
        [ANSI5010Field(true, 1, true)]
        public string P008_ClaimFrequencyTypeCode { protected get; set; }

        /// <summary>
        /// CLM06
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P009_YesNoConditionOrResponseCode { protected get; set; }

        /// <summary>
        /// CLM07
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P010_ProviderAcceptAssignmentCode { protected get; set; }

        /// <summary>
        /// CLM08
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P011_YesNoConditionOrResponseCode1 { protected get; set; }

        /// <summary>
        /// CLM09
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P012_ReleaseOfInformationCode { protected get; set; }

        /// <summary>
        /// CLM10
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P013_PatientSignatureSourceCode { protected get; set; }

        /// <summary>
        /// CLM11
        /// </summary>
        [ANSI5010Field(false, 0, int.MaxValue)]
        public string P014_RelatedCausesInformation { protected get; set; }

        /// <summary>
        /// CLM11-01
        /// </summary>
        [ANSI5010Field(true, 2, 3, true)]
        public string P015_RelatedCausesCode { protected get; set; }

        /// <summary>
        /// CLM11-02 
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P016_RelatedCausesCode1 { protected get; set; }

        /// <summary>
        /// CLM11-03 
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P017_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM11-04 
        /// </summary>
        [ANSI5010Field(false, 2, true)]
        public string P018_StateOrProvinceCode { protected get; set; }

        /// <summary>
        /// CLM11-05  
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P019_CountryCode { protected get; set; }

        /// <summary>
        /// CLM12  
        /// </summary>
        [ANSI5010Field(false, 2, 3)]
        public string P020_SpecialProgramCode { protected get; set; }

        /// <summary>
        /// CLM13
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P021_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM14
        /// </summary>
        [ANSI5010Field(false, 1, 3)]
        public string P022_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM15
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P023_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM16
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P024_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM17
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P025_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM18
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P026_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM19
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P027_NOT_USED { protected get; set; }

        /// <summary>
        /// CLM20  
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P028_DelayReasonCode { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        /// <param name="pIsNotFieldChar"></param>
        public CLML2300(string pLoopChartRef)
            : base("CLM", "L2300: CLAIM INFORMATION", pLoopChartRef)
        {
        }


        # endregion
    }
}
