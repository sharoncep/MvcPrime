using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class HLL2000B : Base5010
    {
        #region Properties
        /// <summary>
        /// HL01
        /// </summary>
        [ANSI5010Field(true, 1, 12)]
        public string P001_HierarchicalIDNumber { protected get; set; }

        /// <summary>
        /// HL02
        /// </summary>
        [ANSI5010Field(true, 1, 12)]
        public string P002_HierarchicalParentIDNumber { protected get; set; }

        /// <summary>
        /// HL03
        /// </summary>
        [ANSI5010Field(true, 1, 2)]
        public string P003_HierarchicalLevelCode { protected get; set; }

        /// <summary>
        /// HL04
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P004_HierarchicalChildCode { protected get; set; }



        #endregion

        #region Constructor

         /// <summary>
        /// 
        /// </summary>
        public HLL2000B(string pLoopNameRef)
            : base("HL", "L2000B: SUBSCR HIER LEVL",pLoopNameRef)
        {
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected HLL2000B(string pLoopNameRef, string pLoopChartRef)
            : base("HL", pLoopNameRef, pLoopChartRef)
        {
        }
        
        #endregion
    }
}
