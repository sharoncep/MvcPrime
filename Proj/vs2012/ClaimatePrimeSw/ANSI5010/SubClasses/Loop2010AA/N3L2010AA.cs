using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class N3L2010AA : Base5010
    {
        #region Properties

        /// <summary>
        /// N301
        /// </summary>
        [ANSI5010Field(true, 1, 55)]
        public string P001_AddressInformation { protected get; set; }

        /// <summary>
        /// N302
        /// </summary>
        [ANSI5010Field(false, 1, 55)]
        public string P002_AddressInformation1 { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public N3L2010AA()
            : base("N3", "L2010AA: BILL IPA ADDR")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        protected N3L2010AA(string pLoopNameRef)
            : base("N3", pLoopNameRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected N3L2010AA(string pLoopNameRef, string pLoopChartRef)
            : base("N3", pLoopNameRef, pLoopChartRef)
        {
        }

        #endregion
    }
}
