using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2300
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class DTP1L2300 : Base5010
    {
        #region Properties

        /// <summary>
        /// DTP01
        /// </summary>
        [ANSI5010Field(true, 3)]
        public string P001_DateTimeQualifier { protected get; set; }

        /// <summary>
        /// DTP02
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P002_DateTimePeriodFormatQualifier { protected get; set; }

        /// <summary>
        /// DTP03
        /// </summary>
        [ANSI5010Field(true, 1, 35)]
        public string P003_DateTimePeriod { protected get; set; }


        #endregion

        # region Constructors

        /// <summary>
        ///  DATE - ONSET OF CURRENT ILLNESS OR SYMPTOM
        /// </summary>
        public DTP1L2300(string pLoopChartRef)
            : base("DTP", "L2300: VISIT ILL DATE", pLoopChartRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected DTP1L2300(string pLoopNameRef, string pLoopChartRef)
            : base("DTP", pLoopNameRef, pLoopChartRef)
        {
        }

        # endregion
    }
}
