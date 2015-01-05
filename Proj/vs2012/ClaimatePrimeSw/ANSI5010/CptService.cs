using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2400;

namespace ANSI5010
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class CptService
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public LXL2400 P001_LXL2400 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public SV1L2400 P002_SV1L2400 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DTPL2400 P003_DTPL2400 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DTPL2400CPT P004_DTPL2400CPT { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2400 P005_REFL2400 { get; set; }


        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public CptService(string pLoopChartRef)
        {
            P001_LXL2400 = new LXL2400(pLoopChartRef);
            P002_SV1L2400 = new SV1L2400(pLoopChartRef);
            P003_DTPL2400 = new DTPL2400(pLoopChartRef);
            P004_DTPL2400CPT = new DTPL2400CPT(pLoopChartRef);
            P005_REFL2400 = new REFL2400(pLoopChartRef);
        }

        # endregion
    }
}
