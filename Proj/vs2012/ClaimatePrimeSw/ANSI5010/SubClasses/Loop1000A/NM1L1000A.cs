using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop1000A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class NM1L1000A : Base5010
    {
        #region Properties

        /// <summary>
        /// NM101
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P001_EntityIdentifierCode { protected get; set; }

        /// <summary>
        /// NM102
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P002_EntityTypeQualifier { protected get; set; }

        /// <summary>
        /// NM103
        /// </summary>
        [ANSI5010Field(true, 1, 60)]
        public string P003_NameLastOrOrganizationName { protected get; set; }

        /// <summary>
        /// NM104
        /// </summary>
        [ANSI5010Field(false, 1, 35)]
        public string P004_NameFirst { protected get; set; }

        /// <summary>
        /// NM105
        /// </summary>
        [ANSI5010Field(false, 1, 25)]
        public string P005_NameMiddle { protected get; set; }

        /// <summary>
        /// NM106
        /// </summary>
        [ANSI5010Field(false, 1, 10)]
        public string P006_NOT_USED { protected get; set; }


        /// <summary>
        /// NM107
        /// </summary>
        [ANSI5010Field(false, 1, 10)]
        public string P007_NameSuffix { protected get; set; }

        /// <summary>
        /// NM108
        /// </summary>
        [ANSI5010Field(true, 1, 2)]
        public string P008_IdentificationCodeQualifier { protected get; set; }

        /// <summary>
        /// NM109
        /// </summary>
        [ANSI5010Field(true, 2, 80)]
        public string P009_IdentificationCode { protected get; set; }


        /// <summary>
        /// NM110
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P010_NOT_USED { protected get; set; }


        /// <summary>
        /// NM111
        /// </summary>
        [ANSI5010Field(false, 2, 3)]
        public string P011_NOT_USED { protected get; set; }


        /// <summary>
        /// NM112
        /// </summary>
        [ANSI5010Field(false, 1, 60)]
        public string P012_NOT_USED { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public NM1L1000A()
            : base("NM1", "L1000A: SUBMITTER NAME")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        protected NM1L1000A(string pLoopNameRef)
            : base("NM1", pLoopNameRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected NM1L1000A(string pLoopNameRef, string pLoopChartRef)
            : base("NM1", pLoopNameRef, pLoopChartRef)
        {
        }

        # endregion
    }
}
