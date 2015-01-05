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
    public class N4L2010AA : Base5010
    {
        #region Properties

        /// <summary>
        /// N401
        /// </summary>
        [ANSI5010Field(true, 2, 30)]
        public string P001_CityName { protected get; set; }

        /// <summary>
        /// N402
        /// </summary>
        [ANSI5010Field(false, 2)]
        public string P002_StateorProvinceCode { protected get; set; }

        /// <summary>
        /// N403
        /// </summary>
        [ANSI5010Field(false, 3, 15)]
        public string P003_PostalCode { protected get; set; }

        /// <summary>
        /// N404
        /// </summary>
        [ANSI5010Field(false, 2, 3)]
        public string P004_CountryCode { protected get; set; }

        /// <summary>
        /// N407
        /// </summary>
        [ANSI5010Field(false, 1, 3)]
        public string P005_CountrySubdivisionCode { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public N4L2010AA()
            : base("N4", "L2010AA: BILL IPA ADDR")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        protected N4L2010AA(string pLoopNameRef)
            : base("N4", pLoopNameRef)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected N4L2010AA(string pLoopNameRef, string pLoopChartRef)
            : base("N4", pLoopNameRef, pLoopChartRef)
        {
        }

        #endregion
    }
}
