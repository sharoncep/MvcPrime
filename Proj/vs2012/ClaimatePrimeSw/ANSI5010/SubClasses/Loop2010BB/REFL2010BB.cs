using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010BB
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2010BB : REFL2010AA
    {
        #region Constructor
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public REFL2010BB(string pLoopChartRef)
            : base("L2010BB: PAYER SEC ID", pLoopChartRef)
        {
        }
        #endregion
    }
}
