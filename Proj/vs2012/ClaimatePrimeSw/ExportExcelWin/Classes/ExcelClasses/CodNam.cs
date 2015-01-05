using ExportExcelWin.SecuredFolder.BaseClasses;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class CodNam : BaseClass
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CODE
        {
            get;
            protected set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String NAME
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CodNam()
        {
        }

        # endregion
    }
}
