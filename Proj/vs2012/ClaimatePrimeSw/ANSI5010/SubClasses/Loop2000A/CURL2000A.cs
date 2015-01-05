using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2000A
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(false)]
    public class CURL2000A : Base5010
    {
        #region Properties

        /// <summary>
        /// CUR01
        /// </summary>
        [ANSI5010Field(true, 2, 3)]
        public string P001_EntityIdentifierCode { private get; set; }

        /// <summary>
        /// CUR02
        /// </summary>
        [ANSI5010Field(true, 3)]
        public string P002_CurrencyCode { private get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CURL2000A()
            : base("CUR", "L2000A: CURRENCY INFO")
        {
        }

        #endregion
    }
}
