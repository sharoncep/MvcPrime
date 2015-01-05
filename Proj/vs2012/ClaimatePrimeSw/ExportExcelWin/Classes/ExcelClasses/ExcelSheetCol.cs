using ExportExcelWin.SecuredFolder.BaseClasses;
using System;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetCol : BaseClass
    {
        # region Static Variable

        private static ExcelSheetCol _ObjCols;

        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public DateTime ExcelDtTm { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelDtFormat { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelTmFormat { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelDtTmFormat { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelSubject { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string ExcelCreator { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet1Name { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet1Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet1Hdrs { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet2Name { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet2Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet2Hdrs { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string Sheet3Name { get; private set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string[] Sheet3Cols { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string[] Sheet3Hdrs { get; private set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private ExcelSheetCol()
        {
        }

        # endregion

        # region Singleton Design Pattern

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlImpoOn">Excel Imported On</param>
        /// <param name="pExcelSubject">Excel Main Header</param>
        /// <param name="pDtDef">GetDateStr()</param>
        /// <param name="pTmDef">GetTimeStr()</param>
        /// <param name="pDtTmDef">GetDateTimeStr()</param>
        /// <returns></returns>
        public static ExcelSheetCol Get(DateTime pExlImpoOn, string pExcelSubject, string pDtDef, string pTmDef, string pDtTmDef, string pUsrFulNm)
        {
            if (_ObjCols == null)
            {
                _ObjCols = new ExcelSheetCol();
            }

            _ObjCols.ExcelDtTm = pExlImpoOn;
            _ObjCols.ExcelDtFormat = pDtDef;
            _ObjCols.ExcelTmFormat = pTmDef;
            _ObjCols.ExcelDtTmFormat = pDtTmDef;
            _ObjCols.ExcelSubject = pExcelSubject;

            _ObjCols.ExcelCreator = "CREATEDBY: [X]. CREATED ON: [Y] [Z]".Replace("[X]", pUsrFulNm).Replace("[Y]", _ObjCols.ExcelDtTm.ToLongDateString()).Replace("[Z]", _ObjCols.ExcelDtTm.ToLongTimeString()).ToUpper();

            int exlColLoop;

            # region Sheet1

            exlColLoop = 0;
            _ObjCols.Sheet1Name = "CLAIM_STATUS";

            # region Define Column Heading

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "SN";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "CLINIC_NAME";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "PROVIDER_NAME";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "DOS";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "CASE_NO";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "INSURANCE_NAME";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "PATIENT_NAME";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "CHART_NO";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "POLICY_NO";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "CLAIM_STATUS";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "PRIMARY_DX";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "SHORT_DESC";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "MEDIUM_DESC";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "LONG_DESC";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "CUSTOM_DESC";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "ICD_FORMAT";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "DG_CODE";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "DG_DESCRIPTION";

            exlColLoop++;
            _ObjCols.Sheet1Hdrs[exlColLoop] = "DX_COUNT";

            # endregion

            # endregion

            # region Sheet2

            exlColLoop = 0;
            _ObjCols.Sheet2Name = "DIAGNOSIS";

            # region Define Column Heading

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "SN";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "DX_CODE";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "SHORT_DESC";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "MEDIUM_DESC";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "LONG_DESC";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "CUSTOM_DESC";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "ICD_FORMAT";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "DG_CODE";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "DG_DESCRIPTION";

            exlColLoop++;
            _ObjCols.Sheet2Hdrs[exlColLoop] = "CPT_COUNT";

            # endregion

            # endregion

            # region Sheet3

            exlColLoop = 0;
            _ObjCols.Sheet3Name = "PROCEDURES";

            # region Define Column Heading

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "SN";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "CPT_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "SHORT_DESC";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MEDIUM_DESC";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "LONG_DESC";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "CUSTOM_DESC";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "FACILITY_TYPE_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "FACILITY_TYPE_NAME";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "CHARGE_PER_UNIT";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "UNITS";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "TOTAL_CHARGE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "IS_HCPCS_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER1_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER1_DESCRIPTION";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER2_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER2_DESCRIPTION";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER3_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER3_DESCRIPTION";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER4_CODE";

            exlColLoop++;
            _ObjCols.Sheet3Hdrs[exlColLoop] = "MODIFIER4_DESCRIPTION";

            # endregion

            # endregion

            return _ObjCols;
        }
        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            Sheet1Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U" };
            Sheet1Hdrs = new string[Sheet1Cols.Length];

            Sheet2Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" };
            Sheet2Hdrs = new string[Sheet2Cols.Length];

            Sheet3Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V" };
            Sheet3Hdrs = new string[Sheet3Cols.Length];
        }

        # endregion
    }
}
