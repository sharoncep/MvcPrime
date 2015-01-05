using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010BA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class DMGL2010BA : Base5010
    {
        #region Properties

        /// <summary>
        /// DMG01
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P001_DateTimePeriodFormatQualifier { protected get; set; }

        /// <summary>
        /// DMG02
        /// </summary>
        [ANSI5010Field(true, 1, 35)]
        public string P002_DateTimePeriod { protected get; set; }

        /// <summary>
        /// DMG03
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P003_GenderCode { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DMGL2010BA(string pLoopChartRef)
            : base("DMG", "L2010BA: SUBSBR DEM INFO", pLoopChartRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected DMGL2010BA(string pLoopNameRef, string pLoopChartRef)
            : base("DMG", pLoopNameRef)
        {
        }

        #endregion
    }
}
