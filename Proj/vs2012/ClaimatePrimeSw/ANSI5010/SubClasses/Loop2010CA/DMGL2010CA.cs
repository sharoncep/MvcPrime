using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010BA;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2010CA
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class DMGL2010CA : DMGL2010BA
    {
        #region constructor
        /// <summary>
        /// 
        /// </summary>
        public DMGL2010CA(string pLoopNameRef)
            : base("L2010CA: PAT DEMO INFO", pLoopNameRef)
        {
        }
        #endregion
    }
}
