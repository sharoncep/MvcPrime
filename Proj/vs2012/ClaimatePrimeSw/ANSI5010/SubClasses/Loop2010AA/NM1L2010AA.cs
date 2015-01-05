using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class NM1L2010AA : NM1L1000A
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public NM1L2010AA()
            : base("L2010AA: BILL IPA NAME")
        {
        }

        #endregion
    }
}
