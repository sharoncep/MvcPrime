using ANSI5010.SubClasses.Loop2000B;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000C
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class HLL2000C : HLL2000B
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public HLL2000C(string pLoopNameRef)
            : base("L2000C: PAT HIER LEVEL",pLoopNameRef)
        {
        }

        # endregion
    }
}
