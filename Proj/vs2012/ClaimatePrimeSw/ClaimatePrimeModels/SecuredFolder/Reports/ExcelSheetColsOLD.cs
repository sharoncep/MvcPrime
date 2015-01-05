using System;

namespace ClaimatePrimeModels.SecuredFolder.Reports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetColsOLD
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public DateTime ExcelDtTm { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelDtFormat { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelTmFormat { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelDtTmFormat { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelSubject { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string XmlDateRange { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelCreator { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet1Name { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet1Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet1Hdrs { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet2Name { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet2Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet2Hdrs { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet3Name { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet3Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet3Hdrs { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ExcelSheetColsOLD()
        {
            Sheet1Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U" };
            Sheet1Hdrs = new string[Sheet1Cols.Length];

            Sheet2Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" };
            Sheet2Hdrs = new string[Sheet2Cols.Length];

            Sheet3Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T" };
            Sheet3Hdrs = new string[Sheet3Cols.Length];
        }

        # endregion
    }
}
