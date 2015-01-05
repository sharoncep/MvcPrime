using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2400
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class LXL2400 : Base5010
    {
        #region Properties

        /// <summary>
        /// LX01
        /// </summary>
        [ANSI5010Field(true, 1, 6)]
        public string P001_AssignedNumber { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// SERVICE LINE NUMBER
        /// </summary>
        public LXL2400(string pLoopChartRef)
            : base("LX", "L2400: SERVICE CPT NO", pLoopChartRef)
        {
        }
        # endregion
    }
}
