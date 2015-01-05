using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop1000A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class PERL1000A : Base5010
    {
        #region Properties

        /// <summary>
        /// PER01
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P001_ContactFunctionCode { protected get; set; }

        /// <summary>
        /// PER02
        /// </summary>
        [ANSI5010Field(false, 1, 60)]
        public string P002_Name { protected get; set; }

        /// <summary>
        /// PER03
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P003_CommunicationNumberQualifier { protected get; set; }


        /// <summary>
        /// PER04
        /// </summary>
        [ANSI5010Field(false, 1, 256)]
        public string P004_CommunicationNumber { protected get; set; }


        /// <summary>
        /// PER05
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P005_CommunicationNumberQualifier1 { protected get; set; }


        /// <summary>
        /// PER06
        /// </summary>
        [ANSI5010Field(false, 1, 256)]
        public string P006_CommunicationNumber1 { protected get; set; }


        /// <summary>
        /// PER07
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P007_CommunicationNumberQualifier2 { protected get; set; }


        /// <summary>
        /// PER08
        /// </summary>
        [ANSI5010Field(false, 1, 256)]
        public string P008_CommunicationNumber2 { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PERL1000A()
            : base("PER", "L1000A: SUBMITTER CONTAT")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        protected PERL1000A(string pLoopNameRef)
            : base("PER", pLoopNameRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected PERL1000A(string pLoopNameRef, string pLoopChartRef)
            : base("PER", pLoopNameRef, pLoopChartRef)
        {
        }

        # endregion
    }
}
