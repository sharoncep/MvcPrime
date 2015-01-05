using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class GS : Base5010
    {
        #region Properties

        /// <summary>
        /// GS01
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P001_FunctionalIdentifierCode { private get; set; }

        /// <summary>
        /// GS02
        /// </summary>
        [ANSI5010Field(true, 2, 15)]
        public string P002_ApplicationSenderCode { private get; set; }

        /// <summary>
        /// GS03
        /// </summary>
        [ANSI5010Field(true, 2, 15)]
        public string P003_ApplicationReceiverCode { private get; set; }

        /// <summary>
        /// GS04
        /// </summary>
        [ANSI5010Field(true, 8)]
        public string P004_Date { private get; set; }

        /// <summary>
        /// GS05
        /// </summary>
        [ANSI5010Field(true, 4,8)]
        public string P005_Time { private get; set; }

        /// <summary>
        /// GS06
        /// </summary>
        [ANSI5010Field(true, 1,9)]
        public string P006_GroupControlNumber { private get; set; }

        /// <summary>
        /// GS07
        /// </summary>
        [ANSI5010Field(true, 1,2)]
        public string P007_ResponsibleAgencyCode { private get; set; }

        /// <summary>
        /// GS08
        /// </summary>
        [ANSI5010Field(true, 1,12)]
        public string P008_IndustryIdentifierCode { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public GS()
            : base("GS", "FUNCTIONAL GROUP HEADER")
        {
        }

        # endregion
    }
}
