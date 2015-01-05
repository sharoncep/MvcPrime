﻿using System;
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
    public class N4L2010BB : N4L2010AA
    {
        #region Constructor
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public N4L2010BB(string pLoopChartRef)
            : base("L2010BB: PAYER ADDR2", pLoopChartRef)
        {
        } 
        #endregion
    }
}
