using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class SE : Base5010
    {
        #region Properties

        /// <summary>
        /// SE01
        /// </summary>
        [ANSI5010Field(true, 1,10)]
        public string P001_NumberOfIncludedSegments { private get; set; }

        /// <summary>
        /// SE02
        /// </summary>
        [ANSI5010Field(true, 4,9)]
        public string P002_TransactionSetControlNumber { private get; set; }        

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SE()
            : base("SE", "TRANS SET TRAILER")
        {
        }

        # endregion
    }
}
