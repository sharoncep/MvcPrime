using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.Extensions;
using ANSI5010.SubClasses.Loop2010AA;

namespace ANSI5010.SubClasses.Loop2400
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2400 : REFL2010AA
    {
         #region constructor
        /// <summary>
        /// LINE ITEM CONTROL NUMBER
        /// </summary>
        public REFL2400(string pLoopNameRef)
            : base("L2400: LINE ITEM CTRL NO", pLoopNameRef)
        {
        }
        #endregion
    }
}
