using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class IEA : Base5010
    {
        #region Properties

        /// <summary>
        /// IEA01
        /// </summary>
        [ANSI5010Field(true, 1, 5)]
        public string P001_NumberofIncludedFunctionalGroups { private get; set; }

        /// <summary>
        /// IEA02
        /// </summary>
        [ANSI5010Field(true, 9)]
        public string P002_InterchangeControlNumber { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public IEA()
            : base("IEA", "INTERCHANGE CONTROL TRIL")
        {
        }

        # endregion
    }
}
