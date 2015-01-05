using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class BHT : Base5010
    {
        #region Properties

        /// <summary>
        /// BHT01
        /// </summary>
        [ANSI5010Field(true, 4)]
        public string P001_HierarchicalStructureCode { private get; set; }

        /// <summary>
        /// BHT02
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P002_TransactionSetPurposeCode { private get; set; }

        /// <summary>
        /// BHT03
        /// </summary>
        [ANSI5010Field(true, 1, 50)]
        public string P003_ReferenceIdentification { private get; set; }

        /// <summary>
        /// BHT04
        /// </summary>
        [ANSI5010Field(true, 8)]
        public string P004_Date { private get; set; }

        /// <summary>
        /// BHT05
        /// </summary>
        [ANSI5010Field(true, 4, 8)]
        public string P005_Time { private get; set; }

        /// <summary>
        /// BHT06
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P006_TransactionTypeCode { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BHT()
            : base("BHT", "BEGIN HIERARCHICAL TRAN")
        {
        }

        # endregion
    }
}
