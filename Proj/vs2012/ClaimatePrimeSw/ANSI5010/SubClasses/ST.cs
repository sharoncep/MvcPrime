using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class ST : Base5010
    {
        #region Properties

        /// <summary>
        /// ST01
        /// </summary>
        [ANSI5010Field(true, 3)]
        public string P001_TransactionSetIdentifierCode { private get; set; }

        /// <summary>
        /// ST02
        /// </summary>
        [ANSI5010Field(true, 4, 9)]
        public string P002_TransactionSetControlNumber { private get; set; }

        /// <summary>
        /// ST03
        /// </summary>
        [ANSI5010Field(true, 1, 35)]
        public string P003_ImplementationConventionReference { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ST()
            : base("ST", "TRANSACTION SET HEADER")
        {
        }

        # endregion
    }
}
