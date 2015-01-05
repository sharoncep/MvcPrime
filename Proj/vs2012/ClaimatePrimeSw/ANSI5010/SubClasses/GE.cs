using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class GE : Base5010
    {
        #region Properties

        /// <summary>
        /// GE01
        /// </summary>
        [ANSI5010Field(true, 1, 6)]
        public string P001_NumberofTransactionSetsIncluded { private get; set; }

        /// <summary>
        /// GE02
        /// </summary>
        [ANSI5010Field(true, 1, 9)]
        public string P002_GroupControlNumber { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public GE()
            : base("GE", "FUNCTIONAL GROUP TRIL")
        {
        }

        # endregion
    }
}
