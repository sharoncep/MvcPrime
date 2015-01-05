using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2310A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2310A : REFL2010AA
    {
        #region constructor
        /// <summary>
        /// REFERRING PROVIDER SECONDARY IDENTIFICATION
        /// </summary>
        public REFL2310A(string pLoopNameRef)
            : base("L2310A: REF PROV SEC ID", pLoopNameRef)
        {
        }
        #endregion
    }
}
