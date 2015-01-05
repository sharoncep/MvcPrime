using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class NM1L2310B : NM1L1000A
    {
        #region constructor
        /// <summary>
        /// RENDERING PROVIDER NAME
        /// </summary>
        public NM1L2310B(string pLoopNameRef)
            : base("L2310B: REND PROV NAME", pLoopNameRef)
        {
        }
        #endregion
    }
}
