using ClaimatePrimeConstants;
using ExportExcelWin.SecuredFolder.BaseClasses;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class ExcelFile : BaseClass
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private ExcelFile()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPathTmp"></param>
        /// <param name="pExlPath"></param>
        /// <param name="pCol"></param>
        /// <param name="pData"></param>
        public static void Create(global::System.String pExlPathTmp, global::System.String pExlPath, ExcelSheetCol pCol, IBaseList pData)
        {
            if (String.Compare(pExlPathTmp, pExlPath, true) == 0)
            {
                throw new Exception("Error! pExlPathTmp and pExlPath should not be same");
            }

            if (System.IO.File.Exists(pExlPathTmp))
            {
                System.IO.File.Delete(pExlPathTmp);
            }

            # region Excel File Name

            ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPathTmp));

            #region Excel Sheet Name

            ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCol.Sheet1Name);
            ws1.View.ShowGridLines = true;

            ExcelWorksheet ws2 = pck.Workbook.Worksheets.Add(pCol.Sheet2Name);
            ws2.View.ShowGridLines = true;

            ExcelWorksheet ws3 = pck.Workbook.Worksheets.Add(pCol.Sheet3Name);
            ws3.View.ShowGridLines = true;

            # endregion

            Int64 rowIndx1 = 0;
            Int64 rowIndx2 = 0;
            Int64 rowIndx3 = 0;

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

            foreach (Claim data1 in pData.IBaseClasses)
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
                ws1.Cells[cellAddr].Value = data1.PROVIDER_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.DOS;
                ws1.Cells[cellAddr].Style.Numberformat.Format = pCol.ExcelDtFormat;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CASE_NO;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.INSURANCE_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PATIENT_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CHART_NO;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.POLICY_NO;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CLAIM_STATUS;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.CODE;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.SHORT_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.MEDIUM_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.LONG_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.CUSTOM_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.ICD_FORMAT;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.DG.CODE;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRI_CLAIM_DX.DX.DG.NAME;

                colIndx1++;
                cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCol.Sheet2Name, "!$", pCol.Sheet2Cols[1], "$", (rowIndx2 + 2), "),\"", data1.CLAIM_DXS.IBaseClasses.Count, "\")");
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws1.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                for (colIndx1 = 1; colIndx1 < pCol.Sheet1Cols.Length - 1; colIndx1++)
                {
                    cellAddr = string.Concat(pCol.Sheet1Cols[colIndx1], rowIndx1);
                    ws1.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    ws1.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode1);
                    ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                # region Sheet2

                Int64 rowIndx2Sub = rowIndx2;

                rowIndx2++;

                Int32 colIndx2 = 0;  // First column blank

                # region Main Header Row

                rowIndx2++;

                colIndx2++;
                cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = pCol.Sheet1Hdrs[5];
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2++;
                cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCol.Sheet1Name, "!$", pCol.Sheet1Cols[5], "$", rowIndx1, "),\"", data1.CASE_NO, "\")");
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                ws2.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                colIndx2++;
                cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2, ":", pCol.Sheet2Cols[pCol.Sheet2Cols.Length - 4], rowIndx2);
                ws2.Cells[cellAddr].Merge = true;
                ws2.Cells[cellAddr].Value = pCol.Sheet2Name;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2 = pCol.Sheet2Cols.Length - 4;

                colIndx2++;
                cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = string.Empty;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2++;
                cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = string.Empty;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                rowIndx2++;  // Blank Row

                # endregion

                # region Column Header Row

                rowIndx2++;  // Coloumn Header

                for (int i = 0; i < pCol.Sheet2Cols.Length; i++)
                {
                    ws2.Cells[string.Concat(pCol.Sheet2Cols[i], rowIndx2)].Value = pCol.Sheet2Hdrs[i];
                    ws2.Cells[string.Concat(pCol.Sheet2Cols[i], rowIndx2)].Style.Font.Bold = true;
                    ws2.Cells[string.Concat(pCol.Sheet2Cols[i], rowIndx2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws2.Cells[string.Concat(pCol.Sheet2Cols[i], rowIndx2)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                # endregion

                # region Column Data

                colorCode2 = System.Drawing.Color.LightCyan;

                foreach (ClaimDx data2 in data1.CLAIM_DXS.IBaseClasses)
                {
                    # region Row Changing

                    if (colorCode2 == System.Drawing.Color.LightCyan)
                    {
                        colorCode2 = System.Drawing.Color.White;
                    }
                    else
                    {
                        colorCode2 = System.Drawing.Color.LightCyan;
                    }

                    # endregion

                    rowIndx2++;

                    colIndx2 = 0;  // First column blank

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.SN;
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.CODE;
                    ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.SHORT_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.MEDIUM_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.LONG_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.CUSTOM_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.ICD_FORMAT;
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.DG.CODE;
                    ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DX.DG.NAME;

                    colIndx2++;
                    cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCol.Sheet3Name, "!$", pCol.Sheet3Cols[1], "$", (rowIndx3 + 2), "),\"", data2.CLAIM_CPTS.IBaseClasses.Count, "\")");
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws2.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    for (colIndx2 = 1; colIndx2 < pCol.Sheet2Cols.Length - 1; colIndx2++)
                    {
                        cellAddr = string.Concat(pCol.Sheet2Cols[colIndx2], rowIndx2);
                        ws2.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        ws2.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode2);
                        ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    }

                    # region Sheet3

                    Int64 rowIndx3Sub = rowIndx3;

                    rowIndx3++;

                    Int32 colIndx3 = 0;  // First column blank

                    # region Main Header Row

                    rowIndx3++;

                    colIndx3++;
                    cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Value = pCol.Sheet2Hdrs[2];
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3++;
                    cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCol.Sheet2Name, "!$", pCol.Sheet2Cols[1], "$", (rowIndx2Sub + 2), "),\"", data2.DX.CODE, "\")");
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    ws3.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    colIndx3++;
                    cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3, ":", pCol.Sheet3Cols[pCol.Sheet3Cols.Length - 4], rowIndx3);
                    ws3.Cells[cellAddr].Merge = true;
                    ws3.Cells[cellAddr].Value = pCol.Sheet3Name;
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3 = pCol.Sheet3Cols.Length - 4;

                    colIndx3++;
                    cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Value = pCol.Sheet1Hdrs[5];
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3++;
                    cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCol.Sheet1Name, "!$", pCol.Sheet1Cols[5], "$", rowIndx1, "),\"", data1.CASE_NO, "\")");
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    ws3.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    rowIndx3++;  // Blank Row

                    # endregion

                    # region Column Header Row

                    rowIndx3++;  // Coloumn Header

                    for (int i = 0; i < pCol.Sheet3Cols.Length; i++)
                    {
                        ws3.Cells[string.Concat(pCol.Sheet3Cols[i], rowIndx3)].Value = pCol.Sheet3Hdrs[i];
                        ws3.Cells[string.Concat(pCol.Sheet3Cols[i], rowIndx3)].Style.Font.Bold = true;
                        ws3.Cells[string.Concat(pCol.Sheet3Cols[i], rowIndx3)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        ws3.Cells[string.Concat(pCol.Sheet3Cols[i], rowIndx3)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    }

                    # endregion

                    # region Column Data

                    colorCode3 = System.Drawing.Color.LightCyan;

                    foreach (ClaimCpt data3 in data2.CLAIM_CPTS.IBaseClasses)
                    {
                        # region Row Changing

                        if (colorCode3 == System.Drawing.Color.LightCyan)
                        {
                            colorCode3 = System.Drawing.Color.White;
                        }
                        else
                        {
                            colorCode3 = System.Drawing.Color.LightCyan;
                        }

                        # endregion

                        rowIndx3++;

                        colIndx3 = 0;  // First column blank

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.SN;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.CODE;
                        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.SHORT_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.MEDIUM_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.LONG_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.CUSTOM_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.FACILITY.CODE;
                        ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.FACILITY.NAME;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CPT.CHARGE_PER_UNIT;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.UNIT;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        colIndx3++;
                        cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.TOTAL_CHARGE;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        for (short i = 1; i < 5; i++)
                        {
                            ClaimModifier oModi  = (from ClaimModifier o in data3.CLAIM_MODIFIERS.IBaseClasses where (o.MODIFIER_LEVEL == i) select o).FirstOrDefault();
                            if (oModi == null)
                            {
                                colIndx3++;
                                cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                                ws3.Cells[cellAddr].Value = string.Empty;

                                colIndx3++;
                                cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                                ws3.Cells[cellAddr].Value = string.Empty;
                            }
                            else
                            {
                                colIndx3++;
                                cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                                ws3.Cells[cellAddr].Value = oModi.MODIFIER.CODE;
                                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                                colIndx3++;
                                cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                                ws3.Cells[cellAddr].Value = oModi.MODIFIER.NAME;
                            }
                        }                        

                        for (colIndx3 = 1; colIndx3 < pCol.Sheet3Cols.Length - 1; colIndx3++)
                        {
                            cellAddr = string.Concat(pCol.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                            ws3.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode3);
                            ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                        }
                    }

                    # endregion

                    # region Save Sheet3

                    for (Int64 curRow3 = (rowIndx3Sub + 2); curRow3 <= rowIndx3; curRow3++)
                    {
                        for (int curCol3 = 1; curCol3 < pCol.Sheet3Cols.Length - 1; curCol3++)
                        {
                            cellAddr = string.Concat(pCol.Sheet3Cols[curCol3], curRow3);

                            if ((curCol3 == 1) && (curRow3 == (rowIndx3Sub + 2)))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if ((curCol3 == (pCol.Sheet3Cols.Length - 2)) && (curRow3 == (rowIndx3Sub + 2)))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if ((curRow3 == rowIndx3) && (curCol3 == 1))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            }
                            else if ((curRow3 == rowIndx3) && (curCol3 == (pCol.Sheet3Cols.Length - 2)))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            }
                            else if (curCol3 == 1)
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if (curCol3 == (pCol.Sheet3Cols.Length - 2))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if (curRow3 == (rowIndx3Sub + 2))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if (curRow3 == rowIndx3)
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                            }
                            else
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                        }
                    }

                    # endregion

                    # endregion
                }

                # endregion

                # region Save Sheet2

                for (Int64 curRow2 = (rowIndx2Sub + 2); curRow2 <= rowIndx2; curRow2++)
                {
                    for (int curCol2 = 1; curCol2 < pCol.Sheet2Cols.Length - 1; curCol2++)
                    {
                        cellAddr = string.Concat(pCol.Sheet2Cols[curCol2], curRow2);

                        if ((curCol2 == 1) && (curRow2 == (rowIndx2Sub + 2)))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if ((curCol2 == (pCol.Sheet2Cols.Length - 2)) && (curRow2 == (rowIndx2Sub + 2)))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if ((curRow2 == rowIndx2) && (curCol2 == 1))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        }
                        else if ((curRow2 == rowIndx2) && (curCol2 == (pCol.Sheet2Cols.Length - 2)))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        }
                        else if (curCol2 == 1)
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if (curCol2 == (pCol.Sheet2Cols.Length - 2))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if (curRow2 == (rowIndx2Sub + 2))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if (curRow2 == rowIndx2)
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        }
                        else
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                    }
                }

                # endregion

                # endregion
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
            ws2.Cells[string.Concat(pCol.Sheet2Cols[0], 1, ":", pCol.Sheet2Cols[pCol.Sheet2Cols.Length - 1], rowIndx2)].AutoFitColumns();
            ws3.Cells[string.Concat(pCol.Sheet3Cols[0], 1, ":", pCol.Sheet3Cols[pCol.Sheet3Cols.Length - 1], rowIndx3)].AutoFitColumns();

            pck.Save();
            pck.Dispose();
            pck = null;

            if (System.IO.File.Exists(pExlPath))
            {
                System.IO.File.Delete(pExlPath);
            }

            File.Move(pExlPathTmp, pExlPath);

            if (RunMode.IsDebug)
            {
                using (Process p = Process.Start(pExlPath))
                {
                    p.WaitForExit();
                }
            }

            # endregion
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {

        }

        # endregion
    }
}
