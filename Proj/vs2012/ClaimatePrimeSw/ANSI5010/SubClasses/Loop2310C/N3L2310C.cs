using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.Extensions;
using ANSI5010.SubClasses.Loop2010AA;

namespace ANSI5010.SubClasses.Loop2310C
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class N3L2310C : N3L2010AA
    {
        #region constructor
        /// <summary>
        /// SERVICE FACILITY LOCATION ADDRESS
        /// </summary>
        public N3L2310C(string pLoopNameRef)
            : base("L2310C: FACILITY ADDR1", pLoopNameRef)
        {
        }
        #endregion
    }
}
