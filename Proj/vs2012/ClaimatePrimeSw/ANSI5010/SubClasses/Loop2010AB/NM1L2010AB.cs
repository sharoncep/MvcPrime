using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AB
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class NM1L2010AB : NM1L1000A
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public NM1L2010AB()
            : base("L2010AB: PAY IPA NAME")
        {
        }

        # endregion
    }
}
