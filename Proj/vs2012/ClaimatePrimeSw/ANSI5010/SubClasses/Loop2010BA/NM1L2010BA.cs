
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;
namespace ANSI5010.SubClasses.Loop2010BA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class NM1L2010BA : NM1L1000A
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public NM1L2010BA(string pLoopChartRef)
            : base("L2010BA: SUBSCRIBER NAME", pLoopChartRef)
        {
        }

        # endregion
    }
}
