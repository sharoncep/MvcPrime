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
    public class N4L2310C : N4L2010AA
    {
        #region constructor
        /// <summary>
        /// SERVICE FACILITY LOCATION CITY, STATE, ZIP CODE
        /// </summary>
        public N4L2310C(string pLoopNameRef)
            : base("L2310C: FACILITY ADDR2", pLoopNameRef)
        {
        }
        #endregion
    }
}
