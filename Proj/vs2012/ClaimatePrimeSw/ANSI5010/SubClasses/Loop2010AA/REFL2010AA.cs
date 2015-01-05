using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class REFL2010AA : Base5010
    {
        #region Properties

        /// <summary>
        /// REF01
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P001_ReferenceIdentificationQualifier { protected get; set; }

        /// <summary>
        /// REF02
        /// </summary>
        [ANSI5010Field(true, 1, 50)]
        public string P002_ReferenceIdentification { protected get; set; }

        /// <summary>
        /// REF03
        /// </summary>
        [ANSI5010Field(false, 1, 80)]
        public string P003_NOT_USED { protected get; set; }

        /// <summary>
        /// REF04
        /// </summary>
        [ANSI5010Field(false, 0, int.MaxValue)]
        public string P004_NOT_USED { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public REFL2010AA()
            : base("REF", "L2010AA: BILL IPA TAX ID")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        protected REFL2010AA(string pLoopNameRef)
            : base("REF", pLoopNameRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected REFL2010AA(string pLoopNameRef, string pLoopChartRef)
            : base("REF", pLoopNameRef, pLoopChartRef)
        {
        }

        #endregion
    }
}
