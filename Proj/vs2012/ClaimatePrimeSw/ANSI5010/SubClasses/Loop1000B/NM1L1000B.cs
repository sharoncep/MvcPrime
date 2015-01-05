using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop1000B
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class NM1L1000B : NM1L1000A
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public NM1L1000B()
            : base("L1000B: RECEIVER NAME")
        {
        }

        # endregion
    }
}
