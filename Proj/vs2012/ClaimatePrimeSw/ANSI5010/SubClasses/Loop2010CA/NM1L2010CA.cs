using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class NM1L2010CA : NM1L1000A
    {
        #region constructor
        /// <summary>
        /// 
        /// </summary>
        public NM1L2010CA(string pLoopNameRef)
            : base("L2010CA: PATIENT NAME", pLoopNameRef)
        {
        }
        #endregion
    }
}
