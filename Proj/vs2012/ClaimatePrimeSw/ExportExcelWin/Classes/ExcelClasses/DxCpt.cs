using ExportExcelWin.SecuredFolder.BaseClasses;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class DxCpt : BaseClass
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
        public global::System.String SHORT_DESC
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String MEDIUM_DESC
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String LONG_DESC
        {
            get;
             set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CUSTOM_DESC
        {
            get;
             set;
        }

        # endregion

        # region Constructors

        public DxCpt()
        {
        }

        # endregion
    }
}
