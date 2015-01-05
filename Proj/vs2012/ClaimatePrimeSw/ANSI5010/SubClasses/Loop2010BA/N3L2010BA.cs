using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010BA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class N3L2010BA : N3L2010AA
    {
        #region Constructor
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public N3L2010BA(string pLoopChartRef)
            : base("L2010BA: SUBSCRIBE ADDR1", pLoopChartRef)
        {
        } 
        #endregion
    }
}
