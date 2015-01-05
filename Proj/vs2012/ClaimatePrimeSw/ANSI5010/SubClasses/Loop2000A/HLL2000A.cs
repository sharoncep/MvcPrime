using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class HLL2000A : Base5010
    {
        #region Properties

        /// <summary>
        /// HL01
        /// </summary>
        [ANSI5010Field(true, 1, 12)]
        public string P001_HierarchicalIDNumber { private get; set; }
        
        /// <summary>
        /// HL02
        /// </summary>
        [ANSI5010Field(false, 1, 12)]
        public string P002_NOTUSED { private get; set; }

        /// <summary>
        /// HL03
        /// </summary>
        [ANSI5010Field(true, 1, 2)]
        public string P003_HierarchicalLevelCode { private get; set; }

        /// <summary>
        /// HL04
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P004_HierarchicalChildCode { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public HLL2000A()
            : base("HL", "L2000A: IPA HIER LEVEL")
        {
        }

        # endregion
    }
}
