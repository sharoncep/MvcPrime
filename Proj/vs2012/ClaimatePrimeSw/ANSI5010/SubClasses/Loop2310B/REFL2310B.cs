using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2310B : REFL2010AA
    {
        #region constructor
        /// <summary>
        /// RENDERING PROVIDER SECONDARY IDENTIFICATION
        /// </summary>
        public REFL2310B(string pLoopNameRef)
            : base("L2310B: REND PROV SEC ID", pLoopNameRef)
        {
        }
        #endregion
    }
}
