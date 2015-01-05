using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.Extensions;
using ANSI5010.SubClasses.Loop1000A;

namespace ANSI5010.SubClasses.Loop2310C
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class NM1L2310C : NM1L1000A
    {
        #region constructor
        /// <summary>
        ///SERVICE FACILITY LOCATION NAME
        /// </summary>
        public NM1L2310C(string pLoopNameRef)
            : base("L2310C: FACILITY NAME", pLoopNameRef)
        {
        }
        #endregion
    }
}
