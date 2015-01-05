using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010AA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PERL2010AA : PERL1000A
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PERL2010AA()
            : base("L2010AA: RECEIVER NAME")
        {
        }

        # endregion
    }
}
