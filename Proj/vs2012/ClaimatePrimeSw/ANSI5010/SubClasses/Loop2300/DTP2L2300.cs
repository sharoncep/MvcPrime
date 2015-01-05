using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2300
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class DTP2L2300 : DTP1L2300
    {
        #region Constructor
        /// <summary>
        /// DTP - DATE - INITIAL TREATMENT DATE
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public DTP2L2300(string pLoopChartRef)
            : base("L2300: HOSP ADMIT DATE", pLoopChartRef)
        {
        } 
        #endregion
    }
}
