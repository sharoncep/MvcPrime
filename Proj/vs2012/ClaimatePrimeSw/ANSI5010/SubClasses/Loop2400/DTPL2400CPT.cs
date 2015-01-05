using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.Extensions;
using ANSI5010.SubClasses.Loop2300;

namespace ANSI5010.SubClasses.Loop2400
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class DTPL2400CPT : DTP1L2300
    {
         #region constructor
        /// <summary>
        /// DATE - PRESCRIPTION DATE
        /// </summary>
        public DTPL2400CPT(string pLoopNameRef)
            : base("L2400: VST ILL DIFF DOS", pLoopNameRef)
        {
        }
        #endregion
    }
}
