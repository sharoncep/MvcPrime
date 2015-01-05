using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PRVL2310B : PRVL2000A
     {
        #region constructor
        /// <summary>
         /// RENDERING PROVIDER SPECIALTY INFORMATION
        /// </summary>
        public PRVL2310B(string pLoopNameRef)
            : base("L2310B: REND PRO SPE INF", pLoopNameRef)
        {
        }
        #endregion
    }
}
