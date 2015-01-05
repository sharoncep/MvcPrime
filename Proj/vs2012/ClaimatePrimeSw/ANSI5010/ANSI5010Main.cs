using ANSI5010.SubClasses;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SubClasses.Loop1000B;
using ANSI5010.SubClasses.Loop2000A;
using ANSI5010.SubClasses.Loop2010AA;
using System;
using System.Collections.Generic;

namespace ANSI5010
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ANSI5010Main
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public ISA P001_ISA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<GSDetail> P002_GSDetails { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public IEA P003_IEA { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ANSI5010Main()
        {
            P001_ISA = new ISA();
            P002_GSDetails = new List<GSDetail>();
            P003_IEA = new IEA();
        }

        # endregion
    }
}
