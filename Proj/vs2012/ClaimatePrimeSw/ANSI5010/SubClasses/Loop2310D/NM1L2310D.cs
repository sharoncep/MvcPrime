using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310D
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class NM1L2310D : NM1L1000A
    {
        #region constructor
        /// <summary>
        ///SUPERVISING PROVIDER NAME
        /// </summary>
        public NM1L2310D(string pLoopNameRef)
            : base("L2310D: SUP PROV NAME", pLoopNameRef)
        {
        }
        #endregion
    }
}
