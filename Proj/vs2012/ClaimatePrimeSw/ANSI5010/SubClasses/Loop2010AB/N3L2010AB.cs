using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AB
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class N3L2010AB : N3L2010AA
    {
         # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public N3L2010AB()
            : base("L2010AB: PAY IPA ADDR1")
        {
        }

        # endregion
    }
}
