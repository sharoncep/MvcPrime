using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010BA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class REFL2010BA : REFL2010AA
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public REFL2010BA(string pLoopChartRef)
            : base("L2010BA: SUBSCRIB SEC ID", pLoopChartRef)
        {
        }


        #endregion
    }
}
