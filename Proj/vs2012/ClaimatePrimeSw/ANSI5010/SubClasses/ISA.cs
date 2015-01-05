using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class ISA : Base5010
    {
        # region Properties

        /// <summary>
        /// ISA01
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P001_AuthorizationInformationQualifier { private get; set; }

        /// <summary>
        /// ISA02
        /// </summary>
        [ANSI5010Field(true, 10)]
        public string P002_AuthorizationInformation { private get; set; }

        /// <summary>
        /// ISA03
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P003_SecurityInformationQualifier { private get; set; }

        /// <summary>
        /// ISA04
        /// </summary>
        [ANSI5010Field(true, 10)]
        public string P004_SecurityInformation { private get; set; }

        /// <summary>
        /// ISA05
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P005_InterchangeIDQualifierSender { private get; set; }

        /// <summary>
        /// ISA06
        /// </summary>
        [ANSI5010Field(true, 15)]
        public string P006_InterchangeSenderID { private get; set; }

        /// <summary>
        /// ISA07
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P007_InterchangeIDQualifierReceiver { private get; set; }

        /// <summary>
        /// ISA08
        /// </summary>
        [ANSI5010Field(true, 15)]
        public string P008_InterchangeReceiverID { private get; set; }

        /// <summary>
        /// ISA09
        /// </summary>
        [ANSI5010Field(true, 6)]
        public string P009_InterchangeDate { private get; set; }

        /// <summary>
        /// ISA10
        /// </summary>
        [ANSI5010Field(true, 4)]
        public string P010_InterchangeTime { private get; set; }

        /// <summary>
        /// ISA11
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P011_RepetitionSeparator { private get; set; }

        /// <summary>
        /// ISA12
        /// </summary>
        [ANSI5010Field(true, 5)]
        public string P012_InterchangeControlVersionNumber { private get; set; }

        /// <summary>
        /// ISA13
        /// </summary>
        [ANSI5010Field(true, 9)]
        public string P013_InterchangeControlNumber { private get; set; }

        /// <summary>
        /// ISA14
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P014_AcknowledgmentRequested { private get; set; }

        /// <summary>
        /// ISA15
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P015_InterchangeUsageIndicator { private get; set; }

        /// <summary>
        /// ISA16
        /// </summary>
        [ANSI5010Field(true, 1)]
        public string P016_ComponentElementSeparator { private get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ISA()
            : base("ISA", "INTERCHANGE CONTROL HEAD")
        {
        }

        # endregion
    }
}
