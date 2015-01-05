using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class N4L2010CA : N4L2010AA
    {
        #region constructor
        /// <summary>
        /// 
        /// </summary>
        public N4L2010CA(string pLoopNameRef)
            : base("L2010CA: PATIENT ADDR2", pLoopNameRef)
        {
        }
        #endregion
    }
}
