using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010BB
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class NM1L2010BB : NM1L1000A
    {
         #region Constructor
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public NM1L2010BB(string pLoopChartRef)
            : base("L2010BB: PAYER NAME", pLoopChartRef)
        {
        } 
        #endregion
    }
}
