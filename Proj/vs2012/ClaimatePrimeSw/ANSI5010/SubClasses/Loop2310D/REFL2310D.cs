using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310D
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2310D : REFL2010AA
    {
        #region constructor
        /// <summary>
        /// SUPERVISING PROVIDER SECONDARY IDENTIFICATION
        /// </summary>
        public REFL2310D(string pLoopNameRef)
            : base("L2310D: FACILITY SEC ID", pLoopNameRef)
        {
        }
        #endregion
    }
}
