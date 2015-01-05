using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2000B;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000C
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PATL2000C : PATL2000B
    {
        #region constructor
        /// <summary>
        /// 
        /// </summary>
        public PATL2000C(string pLoopNameRef)
            : base("L2000C: PATIENT INFO", pLoopNameRef)
        {
        } 
        #endregion
    }
}
