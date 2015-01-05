using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class N3L2010CA : N3L2010AA
    {
        #region constructor
        /// <summary>
        /// 
        /// </summary>
        public N3L2010CA(string pLoopNameRef)
            : base("L2010CA: PATIENT ADDR1", pLoopNameRef)
        {
        }
        #endregion
    }
}
