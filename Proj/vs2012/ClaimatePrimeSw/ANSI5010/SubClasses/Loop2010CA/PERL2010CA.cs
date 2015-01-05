using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class PERL2010CA : PERL1000A
    {
        #region constructor
        /// <summary>
        /// PROPERTY AND CASUALTY PATIENT CONTACT INFORMATION
        /// </summary>
        public PERL2010CA(string pLoopNameRef)
            : base("L2010CA: CAS PAT CON INF", pLoopNameRef)
        {
        }
        #endregion
    }
}
