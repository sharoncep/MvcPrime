using ArivaCryptorEngine;
using ClaimatePrimeConstants;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ClaimatePrimeModels.SecuredFolder.Reports
{
    # region ReportBaseModel

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ReportBaseModelOLD : ReportSubBaseModelOLD
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ReportBaseModelOLD()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPath"></param>
        /// <param name="pXmlPath"></param>
        /// <param name="pCols"></param>
        public void Search(global::System.String pExlPath, global::System.String pXmlPath, ExcelSheetColsOLD pCols)
        {
            Search(pExlPath, pXmlPath, pCols, new List<ExcelSheetDataOLD>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPath"></param>
        /// <param name="pXmlPath"></param>
        /// <param name="pCols"></param>
        /// <param name="pData"></param>
        public void Search(global::System.String pExlPath, global::System.String pXmlPath, ExcelSheetColsOLD pCols, List<ExcelSheetDataOLD> pData)
        {
            if (!(System.IO.File.Exists(pExlPath) && (System.IO.File.Exists(pXmlPath))))
            {
                ReImport(pExlPath, pXmlPath, pCols, pData);
            }

            # region Reading Description

            ExlDesc = new ExcelSheetDescOLD();
            CryptorEngine objCryptor = new CryptorEngine();

            XDocument xDoc = XDocument.Load(pXmlPath);
            XElement xSheet = xDoc.Element(Constants.XMLFileOLD.EXCEL_SHEET_OLD);
            XElement xDesc = xSheet.Element(Constants.XMLFileOLD.DESC_OLD);
            XElement xVal = null;

            //
            xVal = xDesc.Element(Constants.XMLFileOLD.DATE_RANGE_OLD);
            if (xVal == null)
            {
                System.IO.File.Delete(pXmlPath);
                Search(pExlPath, pXmlPath, pCols, pData);

                xVal = null;
                xDesc = null;
                xSheet = null;
                xDoc = null;
                return;
            }
            ExlDesc.DateRange = objCryptor.Decrypt(xVal.Value);
            //if (string.IsNullOrWhiteSpace(ExlDesc.DateRange))     // THIS IS NOT REQUIRED. BECAUSE MOST OF TIME THIS WILL BE EMPTY
            //{
            //    System.IO.File.Delete(pXmlPath);
            //    Search(pExlPath, pXmlPath, pCols, pData);

            //    xVal = null;
            //    xDesc = null;
            //    xSheet = null;
            //    xDoc = null;
            //    return;
            //}

            //
            xVal = xDesc.Element(Constants.XMLFileOLD.IMPORTED_ON_OLD);
            if (xVal == null)
            {
                System.IO.File.Delete(pXmlPath);
                Search(pExlPath, pXmlPath, pCols, pData);

                xVal = null;
                xDesc = null;
                xSheet = null;
                xDoc = null;
                return;
            }
            ExlDesc.ImportedOn = objCryptor.Decrypt(xVal.Value);
            if (string.IsNullOrWhiteSpace(ExlDesc.ImportedOn))
            {
                System.IO.File.Delete(pXmlPath);
                Search(pExlPath, pXmlPath, pCols, pData);

                xVal = null;
                xDesc = null;
                xSheet = null;
                xDoc = null;
                return;
            }

            xVal = null;
            xDesc = null;
            xSheet = null;
            xDoc = null;
            return;

            # endregion
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pExlPath"></param>
        /// <param name="pXmlPath"></param>
        /// <param name="pCols"></param>
        /// <param name="pData"></param>
        public void ReImport(global::System.String pExlPath, global::System.String pXmlPath, ExcelSheetColsOLD pCols, List<ExcelSheetDataOLD> pData)
        {
            # region Excel

            if (System.IO.File.Exists(pExlPath))
            {
                System.IO.File.Delete(pExlPath);
            }

            # region Excel File Name

            ExcelPackage pck = new ExcelPackage(new FileInfo(pExlPath));

            #region Excel Sheet Name

            ExcelWorksheet ws1 = pck.Workbook.Worksheets.Add(pCols.Sheet1Name);
            ws1.View.ShowGridLines = true;

            ExcelWorksheet ws2 = pck.Workbook.Worksheets.Add(pCols.Sheet2Name);
            ws2.View.ShowGridLines = true;

            ExcelWorksheet ws3 = pck.Workbook.Worksheets.Add(pCols.Sheet3Name);
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

            string cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCols.ExcelSubject;
            ws1.Cells[cellAddr].Style.Font.Bold = true;
            ws1.Cells[cellAddr].Style.Font.Size = 14;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 3 Blank

            # endregion

            # region Creator Details

            rowIndx1++; // Row number 4

            cellAddr = string.Concat(pCols.Sheet1Cols[1], rowIndx1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 2], rowIndx1);
            ws1.Cells[cellAddr].Merge = true;
            ws1.Cells[cellAddr].Value = pCols.ExcelCreator;
            ws1.Cells[cellAddr].Style.Font.Size = 12;
            ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            ws1.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

            rowIndx1++;  // Row 5 Blank

            # endregion

            # region Column Header Row

            rowIndx1++;  // Row 6 Coloumn Header

            for (int i = 0; i < pCols.Sheet1Cols.Length; i++)
            {
                ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Value = pCols.Sheet1Hdrs[i];
                ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.Font.Bold = true;
                ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws1.Cells[string.Concat(pCols.Sheet1Cols[i], rowIndx1)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
            }

            # endregion

            # region Column Data

            colorCode1 = System.Drawing.Color.LightCyan;

            foreach (ExcelSheetDataOLD data1 in pData)
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
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.SN;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CLINIC_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PROVIDER_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.DOS;
                ws1.Cells[cellAddr].Style.Numberformat.Format = pCols.ExcelDtFormat;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CASE_NO;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.INSURANCE_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PATIENT_NAME;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CHART_NO;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.POLICY_NO;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.CLAIM_STATUS;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.CODE;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.SHORT_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.MEDIUM_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.LONG_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.CUSTOM_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.ICD_FORMAT;
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.DG_CODE;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Value = data1.PRIMARY_DX.DG_DESC;

                colIndx1++;
                cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
                ws1.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCols.Sheet2Name, "!$", pCols.Sheet2Cols[1], "$", (rowIndx2 + 2), "),\"", data1.Dxs.Count, "\")");
                ws1.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws1.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                for (colIndx1 = 1; colIndx1 < pCols.Sheet1Cols.Length - 1; colIndx1++)
                {
                    cellAddr = string.Concat(pCols.Sheet1Cols[colIndx1], rowIndx1);
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
                cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = pCols.Sheet1Hdrs[5];
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2++;
                cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCols.Sheet1Name, "!$", pCols.Sheet1Cols[5], "$", rowIndx1, "),\"", data1.CASE_NO, "\")");
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                ws2.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                colIndx2++;
                cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2, ":", pCols.Sheet2Cols[pCols.Sheet2Cols.Length - 4], rowIndx2);
                ws2.Cells[cellAddr].Merge = true;
                ws2.Cells[cellAddr].Value = pCols.Sheet2Name;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2 = pCols.Sheet2Cols.Length - 4;

                colIndx2++;
                cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = string.Empty;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                colIndx2++;
                cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                ws2.Cells[cellAddr].Value = string.Empty;
                ws2.Cells[cellAddr].Style.Font.Bold = true;
                ws2.Cells[cellAddr].Style.Font.Size = 14;
                ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                ws2.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                rowIndx2++;  // Blank Row

                # endregion

                # region Column Header Row

                rowIndx2++;  // Coloumn Header

                for (int i = 0; i < pCols.Sheet2Cols.Length; i++)
                {
                    ws2.Cells[string.Concat(pCols.Sheet2Cols[i], rowIndx2)].Value = pCols.Sheet2Hdrs[i];
                    ws2.Cells[string.Concat(pCols.Sheet2Cols[i], rowIndx2)].Style.Font.Bold = true;
                    ws2.Cells[string.Concat(pCols.Sheet2Cols[i], rowIndx2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws2.Cells[string.Concat(pCols.Sheet2Cols[i], rowIndx2)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                }

                # endregion

                # region Column Data

                colorCode2 = System.Drawing.Color.LightCyan;

                foreach (DxOLD data2 in data1.Dxs)
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
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.SN;
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.CODE;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.SHORT_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.MEDIUM_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.LONG_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.CUSTOM_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.ICD_FORMAT;
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DG_CODE;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Value = data2.DG_DESC;

                    colIndx2++;
                    cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
                    ws2.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCols.Sheet3Name, "!$", pCols.Sheet3Cols[1], "$", (rowIndx3 + 2), "),\"", data2.Cpts.Count, "\")");
                    ws2.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws2.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    for (colIndx2 = 1; colIndx2 < pCols.Sheet2Cols.Length - 1; colIndx2++)
                    {
                        cellAddr = string.Concat(pCols.Sheet2Cols[colIndx2], rowIndx2);
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
                    cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Value = pCols.Sheet2Hdrs[2];
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3++;
                    cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCols.Sheet2Name, "!$", pCols.Sheet2Cols[1], "$", (rowIndx2Sub + 2), "),\"", data2.CODE, "\")");
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    ws3.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    colIndx3++;
                    cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3, ":", pCols.Sheet3Cols[pCols.Sheet3Cols.Length - 4], rowIndx3);
                    ws3.Cells[cellAddr].Merge = true;
                    ws3.Cells[cellAddr].Value = pCols.Sheet3Name;
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3 = pCols.Sheet3Cols.Length - 4;

                    colIndx3++;
                    cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Value = pCols.Sheet1Hdrs[5];
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

                    colIndx3++;
                    cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                    ws3.Cells[cellAddr].Formula = string.Concat("=HYPERLINK(\"#\"&CELL(\"address\",", pCols.Sheet1Name, "!$", pCols.Sheet1Cols[5], "$", rowIndx1, "),\"", data1.CASE_NO, "\")");
                    ws3.Cells[cellAddr].Style.Font.Bold = true;
                    ws3.Cells[cellAddr].Style.Font.Size = 14;
                    ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
                    ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    ws3.Cells[cellAddr].Style.Font.Color.SetColor(System.Drawing.Color.Blue);

                    rowIndx3++;  // Blank Row

                    # endregion

                    # region Column Header Row

                    rowIndx3++;  // Coloumn Header

                    for (int i = 0; i < pCols.Sheet3Cols.Length; i++)
                    {
                        ws3.Cells[string.Concat(pCols.Sheet3Cols[i], rowIndx3)].Value = pCols.Sheet3Hdrs[i];
                        ws3.Cells[string.Concat(pCols.Sheet3Cols[i], rowIndx3)].Style.Font.Bold = true;
                        ws3.Cells[string.Concat(pCols.Sheet3Cols[i], rowIndx3)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        ws3.Cells[string.Concat(pCols.Sheet3Cols[i], rowIndx3)].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                    }

                    # endregion

                    # region Column Data

                    colorCode3 = System.Drawing.Color.LightCyan;

                    foreach (CptOLD data3 in data2.Cpts)
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
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.SN;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CODE;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.SHORT_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.MEDIUM_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.LONG_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CUSTOM_DESC;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.FACILITY_TYPE_CODE;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.FACILITY_TYPE_NAME;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.UNIT;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        colIndx3++;
                        cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                        ws3.Cells[cellAddr].Value = data3.CHARGE_PER_UNIT;
                        ws3.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

                        if (data3.Modifiers.Count > 3)
                        {
                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[2].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[2].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[3].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[3].ModifierName;
                        }
                        else if (data3.Modifiers.Count > 2)
                        {
                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[2].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[2].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;
                        }
                        else if (data3.Modifiers.Count > 1)
                        {
                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[1].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;
                        }
                        else if (data3.Modifiers.Count > 0)
                        {
                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierCode;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = data3.Modifiers[0].ModifierName;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;
                        }
                        else
                        {
                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            //

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;

                            colIndx3++;
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Value = string.Empty;
                        }

                        for (colIndx3 = 1; colIndx3 < pCols.Sheet3Cols.Length - 1; colIndx3++)
                        {
                            cellAddr = string.Concat(pCols.Sheet3Cols[colIndx3], rowIndx3);
                            ws3.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
                            ws3.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode3);
                            ws3.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
                        }
                    }

                    # endregion

                    # region Save Sheet3

                    for (Int64 curRow3 = (rowIndx3Sub + 2); curRow3 <= rowIndx3; curRow3++)
                    {
                        for (int curCol3 = 1; curCol3 < pCols.Sheet3Cols.Length - 1; curCol3++)
                        {
                            cellAddr = string.Concat(pCols.Sheet3Cols[curCol3], curRow3);

                            if ((curCol3 == 1) && (curRow3 == (rowIndx3Sub + 2)))
                            {
                                ws3.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                                ws3.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                                ws3.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                            }
                            else if ((curCol3 == (pCols.Sheet3Cols.Length - 2)) && (curRow3 == (rowIndx3Sub + 2)))
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
                            else if ((curRow3 == rowIndx3) && (curCol3 == (pCols.Sheet3Cols.Length - 2)))
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
                            else if (curCol3 == (pCols.Sheet3Cols.Length - 2))
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
                    for (int curCol2 = 1; curCol2 < pCols.Sheet2Cols.Length - 1; curCol2++)
                    {
                        cellAddr = string.Concat(pCols.Sheet2Cols[curCol2], curRow2);

                        if ((curCol2 == 1) && (curRow2 == (rowIndx2Sub + 2)))
                        {
                            ws2.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                            ws2.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                            ws2.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                        }
                        else if ((curCol2 == (pCols.Sheet2Cols.Length - 2)) && (curRow2 == (rowIndx2Sub + 2)))
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
                        else if ((curRow2 == rowIndx2) && (curCol2 == (pCols.Sheet2Cols.Length - 2)))
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
                        else if (curCol2 == (pCols.Sheet2Cols.Length - 2))
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
                for (int curCol1 = 1; curCol1 < pCols.Sheet1Cols.Length - 1; curCol1++)
                {
                    cellAddr = string.Concat(pCols.Sheet1Cols[curCol1], curRow1);

                    if ((curCol1 == 1) && (curRow1 == 2))
                    {
                        ws1.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
                        ws1.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        ws1.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
                    }
                    else if ((curCol1 == (pCols.Sheet1Cols.Length - 2)) && (curRow1 == 2))
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
                    else if ((curRow1 == rowIndx1) && (curCol1 == (pCols.Sheet1Cols.Length - 2)))
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
                    else if (curCol1 == (pCols.Sheet1Cols.Length - 2))
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

            ws1.Cells[string.Concat(pCols.Sheet1Cols[0], 1, ":", pCols.Sheet1Cols[pCols.Sheet1Cols.Length - 1], rowIndx1)].AutoFitColumns();
            ws2.Cells[string.Concat(pCols.Sheet2Cols[0], 1, ":", pCols.Sheet2Cols[pCols.Sheet2Cols.Length - 1], rowIndx2)].AutoFitColumns();
            ws3.Cells[string.Concat(pCols.Sheet3Cols[0], 1, ":", pCols.Sheet3Cols[pCols.Sheet3Cols.Length - 1], rowIndx3)].AutoFitColumns();

            pck.Save();
            pck.Dispose();

            # endregion

            # endregion

            # region Description

            if (System.IO.File.Exists(pXmlPath))
            {
                System.IO.File.Delete(pXmlPath);
            }

            CryptorEngine objCryptor = new CryptorEngine();

            ExlDesc = new ExcelSheetDescOLD() { DateRange = objCryptor.Encrypt(pCols.XmlDateRange), ImportedOn = objCryptor.Encrypt(pCols.ExcelDtTm.ToString(pCols.ExcelDtTmFormat)) };

            XDocument xDoc = new XDocument(
                new XElement(Constants.XMLFileOLD.EXCEL_SHEET_OLD,
                    new XElement(Constants.XMLFileOLD.DESC_OLD,
                        new XElement(Constants.XMLFileOLD.DATE_RANGE_OLD, ExlDesc.DateRange),
                        new XElement(Constants.XMLFileOLD.IMPORTED_ON_OLD, ExlDesc.ImportedOn)
                    )
                )
            );

            xDoc.Save(pXmlPath, SaveOptions.None);

            xDoc = null;

            # endregion
        }

        # endregion
    }

    # endregion

    # region ReportsBaseModel

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ReportDateBaseModelOLD : BaseModel
    {
        # region Properties

        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }
        public List<ReportSubBaseModelOLD> ReportSubs { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ReportDateBaseModelOLD()
        {
        }

        # endregion
    }

    # endregion

    # region ReportSubBaseModel

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ReportSubBaseModelOLD : BaseModel
    {
        # region Properties

        public string Ky { get; set; }
        public ExcelSheetDescOLD ExlDesc { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ReportSubBaseModelOLD()
        {
        }

        # endregion
    }

    # endregion
}
