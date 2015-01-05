using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PRVL2000A : Base5010
    {
        #region Properties

        /// <summary>
        /// PRV01
        /// </summary>
        [ANSI5010Field(true, 1, 3)]
        public string P001_ProviderCode { protected get; set; }

        /// <summary>
        /// PRV02
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P002_ReferenceIdentificationQualifier { protected get; set; }

        /// <summary>
        /// PRV03
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P003_ReferenceIdentification { protected get; set; }

        /// <summary>
        /// PRV04
        /// </summary>
        [ANSI5010Field(false, 1, 50)]
        public string P004_NOT_USED { protected get; set; }

        /// <summary>
        /// PRV05
        /// </summary>
        [ANSI5010Field(false, 0, int.MaxValue)]
        public string P005_NOT_USED { protected get; set; }

        /// <summary>
        /// PRV06
        /// </summary>
        [ANSI5010Field(false, 3)]
        public string P006_NOT_USED { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PRVL2000A()
            : base("PRV", "CLINIC SPECIALITY INFO")
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopNameRef"></param>
        /// <param name="pLoopChartRef"></param>
        protected PRVL2000A(string pLoopNameRef, string pLoopChartRef)
            : base("PRV", pLoopNameRef, pLoopChartRef)
        {
        }



        # endregion
    }
}
