using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2010CA1 : REFL2010AA
    {
        #region constructor
        /// <summary>
        /// PROPERTY AND CASUALTY PATIENT IDENTIFIER
        /// </summary>
        public REFL2010CA1(string pLoopNameRef)
            : base("L2010CA: CASUALTY PAT ID", pLoopNameRef)
        {
        }
        #endregion
    }
}
