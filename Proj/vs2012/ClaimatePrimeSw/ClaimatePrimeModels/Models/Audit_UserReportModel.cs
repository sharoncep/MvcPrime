using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using OfficeOpenXml;
using OfficeOpenXml.Style;

namespace ClaimatePrimeModels.Models
{
    # region ExcelSheetColDash

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetColDash : BaseModel
    {
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

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ExcelSheetColDash()
        {
            Sheet1Cols = new string[] { "A", "B", "C", "D", "E", "F", "G", "H" };
            Sheet1Hdrs = new string[Sheet1Cols.Length];
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlImpoOn">Excel Imported On</param>
        /// <param name="pExcelSubject">Excel Main Header</param>
        /// <param name="pDtDef">GetDateStr()</param>
        /// <param name="pTmDef">GetTimeStr()</param>
        /// <param name="pDtTmDef">GetDateTimeStr()</param>        
        /// <param name="pUsrFulNm"></param>
        /// <param name="flag"></param>
        /// <returns></returns>
        public void FillNotification(DateTime pExlImpoOn, string pExcelSubject, string pDtDef, string pTmDef, string pDtTmDef, string pUsrFulNm, int flag)
        {
            ExcelDtTm = pExlImpoOn;
            ExcelDtFormat = pDtDef;
            ExcelTmFormat = pTmDef;
            ExcelDtTmFormat = pDtTmDef;
            ExcelSubject = pExcelSubject;

            ExcelCreator = "CREATEDBY: [X]. CREATED ON: [Y] [Z]".Replace("[X]", pUsrFulNm).Replace("[Y]", ExcelDtTm.ToLongDateString()).Replace("[Z]", ExcelDtTm.ToLongTimeString()).ToUpper();

            int exlColLoop;

            # region Sheet1

            exlColLoop = 0;
            Sheet1Name = "NOTIFICATION";

            # region Define Column Heading
            if (flag == 1)
            {
                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "EMAIL";

                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "LAST_NAME";

                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "FIRST_NAME";

                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "MIDDLE_NAME";
            }
            else
            {
                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "ClinicName";

                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "NPI";

                exlColLoop++;
                Sheet1Hdrs[exlColLoop] = "ICD_FORMAT";
            }
            # endregion

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlImpoOn">Excel Imported On</param>
        /// <param name="pExcelSubject">Excel Main Header</param>
        /// <param name="pDtDef">GetDateStr()</param>
        /// <param name="pTmDef">GetTimeStr()</param>
        /// <param name="pDtTmDef">GetDateTimeStr()</param>
        /// <param name="pUsrFulNm"></param>
        /// <returns></returns>
        public void FillDashboard(DateTime pExlImpoOn, string pExcelSubject, string pDtDef, string pTmDef, string pDtTmDef, string pUsrFulNm)
        {
            ExcelDtTm = pExlImpoOn;
            ExcelDtFormat = pDtDef;
            ExcelTmFormat = pTmDef;
            ExcelDtTmFormat = pDtTmDef;
            ExcelSubject = pExcelSubject;

            ExcelCreator = "CREATEDBY: [X]. CREATED ON: [Y] [Z]".Replace("[X]", pUsrFulNm).Replace("[Y]", ExcelDtTm.ToLongDateString()).Replace("[Z]", ExcelDtTm.ToLongTimeString()).ToUpper();

            int exlColLoop;

            # region Sheet1

            exlColLoop = 0;
            Sheet1Name = "CLAIMS";

            # region Define Column Heading

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "SN";

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "ClinicName";

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "PatientName";

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "ChartNo";

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "DOS";

            exlColLoop++;
            Sheet1Hdrs[exlColLoop] = "CaseNo";

            # endregion

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="fileSvrRptRootPath"></param>
        /// <returns></returns>
        public string GetXlsxPath(Int32 userID, string fileSvrRptRootPath)
        {
            string xlsxPath = userID.ToString();
            while (xlsxPath.Length < 5)
            {
                xlsxPath = string.Concat("0", xlsxPath);
            }
            xlsxPath = string.Concat("CP", xlsxPath);
            xlsxPath = string.Concat(xlsxPath, "DASHBOARD.xlsx");
            xlsxPath = string.Concat(fileSvrRptRootPath, @"\", xlsxPath);

            return xlsxPath;
        }

        #endregion
    }

    # endregion

    # region ExcelFileDash

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelFileDash : BaseModel
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ExcelFileDash()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPath"></param>
        /// <param name="pCol"></param>
        /// <param name="pData"></param>
        public static void Create(global::System.String pExlPath, ExcelSheetColDash pCol, List<ExcelSheetDataDash> pData)
        {
            if (System.IO.File.Exists(pExlPath))
            {
                System.IO.File.Delete(pExlPath);
            }

            # region Excel File Name

            ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPath));

            #region Excel Sheet Name

            ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCol.Sheet1Name);
            ws1.View.ShowGridLines = true;

            # endregion

            Int64 rowIndx1 = 0;

            System.Drawing.Color colorCode1;
            System.Drawing.Color colorCode2 = System.Drawing.Color.LightCyan;
            System.Drawing.Color colorCode3 = System.Drawing.Color.LightCyan;

            # endregion

            # region Excel Data

            # region Sheet1

            # region Main Header Row

            rowIndx1++;  // Row 1 Blank

            rowIndx1++; // Row number 2

            string cellAddr = string.Concat(pCol.Sheet1Cols[1], rowIndx1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCol.ExcelSubject;
            ws1.Cells[cellAddr].Style.Font.Bold = true;
            ws1.Cells[cellAddr].Style.Font.Size = 14;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 3 Blank

            # endregion

            # region Creator Details

            rowIndx1++; // Row number 4

            cellAddr = string.Concat(pCol.Sheet1Cols[1], rowIndx1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCol.ExcelCreator;
            ws1.Cells[cellAddr].Style.Font.Size = 12;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 5 Blank

            # endregion

            # region Column Header Row

            rowIndx1++;  // Row 6 Coloumn Header

            for (int i = 0; i < pCol.Sheet1Cols.Length; i++)
            {
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Value = pCol.Sheet1Hdrs[i];
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.Font.Bold = true;
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
            }

            # endregion

            # region Column Data

            colorCode1 = System.Drawing.Color.LightCyan;

            foreach (ExcelSheetDataDash data1 in pData)
            {
                # region Row Changing

                if (colorCode1 == System.Drawing.Color.LightCyan)
                {
                    colorCode1 = System.Drawing.Color.White;
                }
                else
                {
                    colorCode1 = System.Drawing.Color.LightCyan;
                }

                # endregion

                rowIndx1++;

                Int32 colIndx1 = 0;  // First column blank

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.SN;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CLINIC_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PATIENT_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CHART_NO;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.DOS;
                ws1.Cells[cellAddr].Style.Numberformat.Format = pCol.ExcelDtFormat;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CASE_NO;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                for (colIndx1 = 1; colIndx1 < pCol.Sheet1Cols.Length - 1; colIndx1++)
                {
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
                    ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }
            }

            # endregion

            # region Save Sheet1

            for (Int64 curRow1 = 2; curRow1 <= rowIndx1; curRow1++)
            {
                for (int curCol1 = 1; curCol1 < pCol.Sheet1Cols.Length - 1; curCol1++)
                {
                    cellAddr = string.Concat(pCol.Sheet1Cols[curCol1], curRow1);

                    if ((curCol1 == 1) && (curRow1 == 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if ((curCol1 == (pCol.Sheet1Cols.Length - 2)) && (curRow1 == 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if ((curRow1 == rowIndx1) && (curCol1 == 1))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else if ((curRow1 == rowIndx1) && (curCol1 == (pCol.Sheet1Cols.Length - 2)))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else if (curCol1 == 1)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curCol1 == (pCol.Sheet1Cols.Length - 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curRow1 == 2)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curRow1 == rowIndx1)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                }
            }

            # endregion

            # endregion

            # endregion

            # region Save Excel

            ws1.Cells[string.Concat(pCol.Sheet1Cols[0], 1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 1], rowIndx1)].AutoFitColumns();

            pck.Save();
            pck.Dispose();

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPath"></param>
        /// <param name="pCol"></param>
        /// <param name="pData"></param>
        /// <param name="flag"></param>
        public static void Create(global::System.String pExlPath, ExcelSheetColDash pCol, List<ExcelSheetDataNotification> pData, int flag)
        {
            if (System.IO.File.Exists(pExlPath))
            {
                System.IO.File.Delete(pExlPath);
            }

            # region Excel File Name

            ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPath));

            #region Excel Sheet Name

            ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCol.Sheet1Name);
            ws1.View.ShowGridLines = true;

            # endregion

            Int64 rowIndx1 = 0;

            System.Drawing.Color colorCode1;
            System.Drawing.Color colorCode2 = System.Drawing.Color.LightCyan;
            System.Drawing.Color colorCode3 = System.Drawing.Color.LightCyan;

            # endregion

            # region Excel Data

            # region Sheet1

            # region Main Header Row

            rowIndx1++;  // Row 1 Blank

            rowIndx1++; // Row number 2

            string cellAddr = string.Concat(pCol.Sheet1Cols[1], rowIndx1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCol.ExcelSubject;
            ws1.Cells[cellAddr].Style.Font.Bold = true;
            ws1.Cells[cellAddr].Style.Font.Size = 14;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 3 Blank

            # endregion

            # region Creator Details

            rowIndx1++; // Row number 4

            cellAddr = string.Concat(pCol.Sheet1Cols[1], rowIndx1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCol.ExcelCreator;
            ws1.Cells[cellAddr].Style.Font.Size = 12;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 5 Blank

            # endregion

            # region Column Header Row

            rowIndx1++;  // Row 6 Coloumn Header

            for (int i = 0; i < pCol.Sheet1Cols.Length; i++)
            {
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Value = pCol.Sheet1Hdrs[i];
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.Font.Bold = true;
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws1.Cells[string.Concat(pCol.Sheet1Cols[i], rowIndx1)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
            }

            # endregion

            # region Column Data

            colorCode1 = System.Drawing.Color.LightCyan;

            foreach (ExcelSheetDataNotification data1 in pData)
            {
                # region Row Changing

                if (colorCode1 == System.Drawing.Color.LightCyan)
                {
                    colorCode1 = System.Drawing.Color.White;
                }
                else
                {
                    colorCode1 = System.Drawing.Color.LightCyan;
                }

                # endregion

                rowIndx1++;

                Int32 colIndx1 = 0;  // First column blank

                if (flag == 1)
                {
                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.EMAIL;
                    ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.LAST_NAME;

                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.FIRST_NAME;

                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.MIDDLE_NAME;
                    ws1.Cells[cellAddr].Style.Numberformat.Format = pCol.ExcelDtFormat;
                    ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    for (colIndx1 = 1; colIndx1 < pCol.Sheet1Cols.Length - 1; colIndx1++)
                    {
                        cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                        ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
                        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    }
                }
                else
                {
                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.CLINIC_NAME;
                    ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.NPI;

                    colIndx1++;
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Value = data1.ICD_FORMAT;

                    for (colIndx1 = 1; colIndx1 < pCol.Sheet1Cols.Length - 1; colIndx1++)
                    {
                        cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                        ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
                        ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    }
                }
            }

            # endregion

            # region Save Sheet1

            for (Int64 curRow1 = 2; curRow1 <= rowIndx1; curRow1++)
            {
                for (int curCol1 = 1; curCol1 < pCol.Sheet1Cols.Length - 1; curCol1++)
                {
                    cellAddr = string.Concat(pCol.Sheet1Cols[curCol1], curRow1);

                    if ((curCol1 == 1) && (curRow1 == 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if ((curCol1 == (pCol.Sheet1Cols.Length - 2)) && (curRow1 == 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if ((curRow1 == rowIndx1) && (curCol1 == 1))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else if ((curRow1 == rowIndx1) && (curCol1 == (pCol.Sheet1Cols.Length - 2)))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else if (curCol1 == 1)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curCol1 == (pCol.Sheet1Cols.Length - 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curRow1 == 2)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if (curRow1 == rowIndx1)
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    }
                    else
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                }
            }

            # endregion

            # endregion

            # endregion

            # region Save Excel

            ws1.Cells[string.Concat(pCol.Sheet1Cols[0], 1, ":", pCol.Sheet1Cols[pCol.Sheet1Cols.Length - 1], rowIndx1)].AutoFitColumns();

            pck.Save();
            pck.Dispose();

            # endregion
        }

        # endregion
    }

    # endregion

    # region ExcelReportModel

    /// <summary>
    /// 
    /// </summary>
    public class ExcelReportModel : BaseModel
    {
        # region Properties

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private ExcelReportModel()
        {
        }

        # endregion

        # region Public Methods

        #region Dashboard reports

        #region Summary reports

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="desc"></param>
        /// <param name="dayCount"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataDash> GetDataAgentWise(Nullable<int> userID, string desc, string dayCount)
        {
            List<ExcelSheetDataDash> retAns = new List<ExcelSheetDataDash>();

            List<usp_GetAgentWiseVisitPdf_PatientVisit_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetAgentWiseVisitPdf_PatientVisit_Result>(ctx.usp_GetAgentWiseVisitPdf_PatientVisit(userID, desc, dayCount, Convert.ToByte(ClaimStatus.NEW_CLAIM), Convert.ToByte(ClaimStatus.BA_HOLDED), Convert.ToByte(ClaimStatus.CREATED_CLAIM), Convert.ToByte(ClaimStatus.READY_TO_SEND_CLAIM), Convert.ToByte(ClaimStatus.EDI_FILE_CREATED), Convert.ToByte(ClaimStatus.REJECTED_CLAIM), Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK), Convert.ToByte(ClaimStatus.ACCEPTED_CLAIM)
                    , string.Concat(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.BA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.HOLD_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.EA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.QA_PERSONAL_QUEUE_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.SENT_CLAIM_NOT_IN_TRACK), ", ", Convert.ToByte(ClaimStatus.REJECTED_CLAIM_NOT_IN_TRACK))));
            }

            foreach (usp_GetAgentWiseVisitPdf_PatientVisit_Result patVisit in patVisits)
            {
                ExcelSheetDataDash oData = new ExcelSheetDataDash();

                oData.SN = patVisit.SL_NO;
                oData.CLINIC_NAME = patVisit.ClinicName;
                oData.DOS = patVisit.DOS;
                oData.PATIENT_NAME = patVisit.Name;
                oData.CHART_NO = patVisit.ChartNumber;
                oData.CASE_NO = patVisit.PatientVisitID;
                oData.PATIENT_VISIT_COMPLEXITY = patVisit.PatientVisitComplexity;

                retAns.Add(oData);
            }



            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="desc"></param>
        /// <param name="dayCount"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataDash> GetDataDashboard(Nullable<int> userID, string desc, string dayCount)
        {
            List<ExcelSheetDataDash> retAns = new List<ExcelSheetDataDash>();

            List<usp_GetDashboardVisitPdf_PatientVisit_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetDashboardVisitPdf_PatientVisit_Result>(ctx.usp_GetDashboardVisitPdf_PatientVisit(userID, desc, dayCount));
            }

            foreach (usp_GetDashboardVisitPdf_PatientVisit_Result patVisit in patVisits)
            {
                ExcelSheetDataDash oData = new ExcelSheetDataDash();

                oData.SN = patVisit.SL_NO;
                oData.CLINIC_NAME = patVisit.ClinicName;
                oData.DOS = patVisit.DOS;
                oData.PATIENT_NAME = patVisit.Name;
                oData.CHART_NO = patVisit.ChartNumber;
                oData.CASE_NO = patVisit.PatientVisitID;
                oData.PATIENT_VISIT_COMPLEXITY = patVisit.PatientVisitComplexity;

                retAns.Add(oData);
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="clinicID"></param>
        /// <param name="desc"></param>
        /// <param name="dayCount"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataDash> GetDataClinicWise(Nullable<int> clinicID, string desc, string dayCount)
        {
            List<ExcelSheetDataDash> retAns = new List<ExcelSheetDataDash>();

            List<usp_GetClinicWiseVisitpDF_PatientVisit_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetClinicWiseVisitpDF_PatientVisit_Result>(ctx.usp_GetClinicWiseVisitpDF_PatientVisit(clinicID, desc, dayCount));
            }

            foreach (usp_GetClinicWiseVisitpDF_PatientVisit_Result patVisit in patVisits)
            {
                ExcelSheetDataDash oData = new ExcelSheetDataDash();

                oData.SN = patVisit.SL_NO;
                oData.CLINIC_NAME = patVisit.ClinicName;
                oData.DOS = patVisit.DOS;
                oData.PATIENT_NAME = patVisit.Name;
                oData.CHART_NO = patVisit.ChartNumber;
                oData.CASE_NO = patVisit.PatientVisitID;
                oData.PATIENT_VISIT_COMPLEXITY = patVisit.PatientVisitComplexity;

                retAns.Add(oData);
            }



            return retAns;
        }
        #endregion

        #region Notification reports

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> getUsersWithoutRole()
        {
            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationRolePdf_UserRole_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationRolePdf_UserRole_Result>(ctx.usp_GetNotificationRolePdf_UserRole());
            }

            foreach (usp_GetNotificationRolePdf_UserRole_Result patVisit in patVisits)
            {
                ExcelSheetDataNotification oData = new ExcelSheetDataNotification();

                retAns.Add(new ExcelSheetDataNotification()
                {
                    EMAIL = patVisit.Email,
                    LAST_NAME = patVisit.LastName,
                    FIRST_NAME = patVisit.FirstName,
                    MIDDLE_NAME = patVisit.MiddleName
                });
            }
            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> getUsersWithoutClinic()
        {
            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationClinicPdf_UserClinic_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationClinicPdf_UserClinic_Result>(ctx.usp_GetNotificationClinicPdf_UserClinic());
            }

            foreach (usp_GetNotificationClinicPdf_UserClinic_Result patVisit in patVisits)
            {
                retAns.Add(new ExcelSheetDataNotification()
                {
                    EMAIL = patVisit.Email,
                    LAST_NAME = patVisit.LastName,
                    FIRST_NAME = patVisit.FirstName,
                    MIDDLE_NAME = patVisit.MiddleName
                });
            }
            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="roleID"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> getManagerWithoutAgent(Nullable<byte> roleID)
        {
            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationAgentPdf_User_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationAgentPdf_User_Result>(ctx.usp_GetNotificationAgentPdf_User(roleID));
            }

            foreach (usp_GetNotificationAgentPdf_User_Result patVisit in patVisits)
            {
                ExcelSheetDataNotification oData = new ExcelSheetDataNotification();

                retAns.Add(new ExcelSheetDataNotification()
                {
                    EMAIL = patVisit.Email,
                    LAST_NAME = patVisit.LastName,
                    FIRST_NAME = patVisit.FirstName,
                    MIDDLE_NAME = patVisit.MiddleName
                });
            }
            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="managerRoleID"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> getClinicsWithoutManager(Nullable<byte> managerRoleID)
        {
            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationManagerPdf_UserClinic_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationManagerPdf_UserClinic_Result>(ctx.usp_GetNotificationManagerPdf_UserClinic(managerRoleID));
            }

            foreach (usp_GetNotificationManagerPdf_UserClinic_Result patVisit in patVisits)
            {
                ExcelSheetDataNotification oData = new ExcelSheetDataNotification();

                retAns.Add(new ExcelSheetDataNotification()
                {
                    CLINIC_NAME = patVisit.ClinicName,
                    NPI = patVisit.NPI,
                    ICD_FORMAT = patVisit.ICDFormat.ToString()
                });
            }
            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="managerRoleID"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> getClinicsWithMultiManager(Nullable<byte> managerRoleID)
        {
            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationMultiManagerPdf_UserClinic_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationMultiManagerPdf_UserClinic_Result>(ctx.usp_GetNotificationMultiManagerPdf_UserClinic(managerRoleID));
            }

            foreach (usp_GetNotificationMultiManagerPdf_UserClinic_Result patVisit in patVisits)
            {
                ExcelSheetDataNotification oData = new ExcelSheetDataNotification();

                retAns.Add(new ExcelSheetDataNotification()
                {
                    CLINIC_NAME = patVisit.ClinicName,
                    NPI = patVisit.NPI,
                    ICD_FORMAT = patVisit.ICDFormat.ToString()
                });
            }
            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public static List<ExcelSheetDataNotification> GetAgentClinic(Nullable<int> userID)
        {

            List<ExcelSheetDataNotification> retAns = new List<ExcelSheetDataNotification>();

            List<usp_GetNotificationAgentClinicPdf_UserClinic_Result> patVisits;

            using (EFContext ctx = new EFContext())
            {
                patVisits = new List<usp_GetNotificationAgentClinicPdf_UserClinic_Result>(ctx.usp_GetNotificationAgentClinicPdf_UserClinic(userID));
            }

            foreach (usp_GetNotificationAgentClinicPdf_UserClinic_Result patVisit in patVisits)
            {
                ExcelSheetDataNotification oData = new ExcelSheetDataNotification();

                retAns.Add(new ExcelSheetDataNotification()
                {
                    CLINIC_NAME = patVisit.ClinicName,
                    NPI = patVisit.NPI,
                    ICD_FORMAT = patVisit.ICDFormat.ToString()
                });
            }
            return retAns;
        }

        #endregion

        #endregion

        # endregion
    }

    # endregion

    #region User Report Search Model

    /// <summary>
    /// 
    /// </summary>
    public class UserReportSearchModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetSearch_UserReport_Result> UserReportResults { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetExcel_UserReport_Result ExcelResult { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime DateFrom { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime DateTo { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserReportSearchModel()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="reportTypeID"></param>
        /// <param name="forDtRpt"></param>
        /// <param name="reportObjectID"></param>
        /// <param name="currDtTm"></param>
        public void Fill(Nullable<int> userID, Nullable<byte> reportTypeID, Nullable<bool> forDtRpt, Nullable<long> reportObjectID, DateTime currDtTm)
        {
            using (EFContext ctx = new EFContext())
            {
                UserReportResults = (new List<usp_GetSearch_UserReport_Result>(ctx.usp_GetSearch_UserReport(userID, reportTypeID, forDtRpt, reportObjectID)));

                if (UserReportResults.Count == 0)
                {
                    UserReportResults.Add(new usp_GetSearch_UserReport_Result() { DateFrom = currDtTm.AddMonths(-1), DateTo = currDtTm, ExcelImportedOn = new DateTime(1900, 1, 1) });
                }
            }

            this.DateFrom = currDtTm.AddMonths(-1);
            this.DateTo = currDtTm;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <param name="reportTypeID"></param>
        /// <param name="reportObjectID"></param>
        public void Fill(Nullable<int> userID, Nullable<short> userReportID)
        {
            using (EFContext ctx = new EFContext())
            {
                ExcelResult = (new List<usp_GetExcel_UserReport_Result>(ctx.usp_GetExcel_UserReport(userID, userReportID))).SingleOrDefault();

                if (ExcelResult == null)
                {
                    ExcelResult = new usp_GetExcel_UserReport_Result();
                }
            }
        }

        # endregion


    }

    #endregion
}
