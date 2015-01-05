using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;

namespace ClaimatePrimeModels.Models
{
    #region UserClinicSelectSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class UserClinicSelectSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int32 ClinicID
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserClinicSelectSaveModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter userClinicSelectID = ObjParam("UserClinicSelect");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                Int32 prevClinc = (new List<usp_GetRecent_UserClinicSelect_Result>(ctx.usp_GetRecent_UserClinicSelect(pUserID))).FirstOrDefault().CLINIC_ID;

                if (prevClinc != ClinicID)
                {
                    ctx.usp_Insert_UserClinicSelect(pUserID, ClinicID, userClinicSelectID);
                    if (HasErr(userClinicSelectID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Public Methods

        #endregion
    }
    #endregion

    # region Old

    //# region ExcelSheetDescModel

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public class ExcelSheetDescModel : BaseModel
    //{
    //    # region Properties

    //    public global::System.String Subject { get; set; }
    //    public global::System.String CreatedBy { get; set; }
    //    public global::System.String CreatedOn { get; set; }

    //    # endregion

    //    # region Constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public ExcelSheetDescModel()
    //    {
    //    }

    //    # endregion
    //}

    //# endregion

    //# region ExcelReportSearchModel

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public class ExcelReportSearchModel : BaseModel
    //{
    //    # region Properties

    //    public global::System.String Ky { get; set; }
    //    public ExcelSheetDescModel Description { get; set; }

    //    # endregion

    //    # region Constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public ExcelReportSearchModel()
    //    {
    //    }

    //    # endregion
    //}

    //# endregion

    //#region FileOperations

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public partial class FileOperations
    //{
    //    # region Properties



    //    # endregion

    //    # region Constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    private FileOperations()
    //    {
    //    }

    //    # endregion

    //    # region Public Methods

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="desMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr"></param>
    //    /// <param name="pDtFormat"></param>
    //    public static void Load(global::System.String pDesFilPath, ref ExcelSheetDescModel desMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, string pDtFormat)
    //    {
    //        try
    //        {
    //            if (!(System.IO.File.Exists(pDesFilPath) && (System.IO.File.Exists(pExlFilPath))))
    //            {
    //                CreateExcel(pDesFilPath, desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, new List<BaseExcel>(), pDtFormat);
    //            }

    //            # region Reading Description

    //            desMsg = new ExcelSheetDescModel();

    //            XDocument xDoc = XDocument.Load(pDesFilPath);
    //            XElement xSheet = xDoc.Element(XMLFile.EXCEL_SHEET);
    //            XElement xDesc = xSheet.Element(XMLFile.DESC);
    //            XElement xVal = null;

    //            //
    //            xVal = xDesc.Element(XMLFile.SUBJECT);
    //            if (xVal == null)
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }
    //            desMsg.Subject = xVal.Value;
    //            if (string.IsNullOrWhiteSpace(desMsg.Subject))
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }

    //            //
    //            xVal = xDesc.Element(XMLFile.CREATED_BY);
    //            if (xVal == null)
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }
    //            desMsg.CreatedBy = xVal.Value;
    //            if (string.IsNullOrWhiteSpace(desMsg.CreatedBy))
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }

    //            //
    //            xVal = xDesc.Element(XMLFile.CREATED_ON);
    //            if (xVal == null)
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }
    //            desMsg.CreatedOn = xVal.Value;
    //            if (string.IsNullOrWhiteSpace(desMsg.CreatedOn))
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //                Load(pDesFilPath, ref desMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, pDtFormat);
    //                return;
    //            }

    //            xVal = null;
    //            xDesc = null;
    //            xSheet = null;
    //            xDoc = null;

    //            # endregion
    //        }
    //        catch (Exception ex)
    //        {
    //            if (!(ex.ToString().Contains("because it is being used by another process")))
    //            {
    //                throw ex;
    //            }
    //        }
    //    }



    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="pDesMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr"></param>
    //    /// <param name="pClinic"></param>
    //    /// <param name="pDtFormat"></param>
    //    public static void CreateExcelForBillingAgent(global::System.String pDesFilPath, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, string pDtFormat)
    //    {
    //        CreateExcel(pDesFilPath, pDesMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, EFOperation.uspBillingOnlineBillingAgentAll(), pDtFormat);
    //    }

    //    public static void CreateExcelForEA(global::System.String pDesFilPath, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, string pDtFormat)
    //    {
    //        CreateExcel(pDesFilPath, pDesMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, EFOperation.uspBillingOnlineEAAll(), pDtFormat);
    //    }
    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="pDesMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr"></param>
    //    /// <param name="pClinic"></param>
    //    /// <param name="pDtFormat"></param>
    //    public static void CreateExcelForQA(global::System.String pDesFilPath, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, string pDtFormat)
    //    {
    //        CreateExcel(pDesFilPath, pDesMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, EFOperation.uspBillingOnlineQAAll(), pDtFormat);
    //    }
    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="pDesMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr"></param>
    //    /// <param name="pClinic"></param>
    //    /// <param name="pDtFormat"></param>
    //    public static void CreateExcelForClinic(global::System.String pDesFilPath, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, int pClinicID, string pDtFormat)
    //    {
    //        CreateExcel(pDesFilPath, pDesMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, EFOperation.uspBillingOnlineCapitatedClinic(pClinicID), pDtFormat);
    //    }
    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="pDesMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr"></param>
    //    /// <param name="pDtFormat"></param>
    //    public static void CreateExcelForAllClinic(global::System.String pDesFilPath, global::System.Int32 userid, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, string pDtFormat)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            CreateExcel(pDesFilPath, pDesMsg, pExlFilPath, pExlShtName, pExlHdrMain, pExlCols, pExlColHdr, EFOperation.uspBillingOnlineCapitatedAll(userid), pDtFormat);
    //        }
    //    }



    //    # endregion

    //    # region Private Methods

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pDesFilPath"></param>
    //    /// <param name="pDesMsg"></param>
    //    /// <param name="pExlFilPath"></param>
    //    /// <param name="pExlShtName"></param>
    //    /// <param name="pExlHdrMain"></param>
    //    /// <param name="pExlCols"></param>
    //    /// <param name="pExlColHdr">Cell Addr, Cell Data</param>
    //    /// <param name="pExlData"></param>
    //    /// <param name="pDtFormat"></param>
    //    private static void CreateExcel(global::System.String pDesFilPath, ExcelSheetDescModel pDesMsg, global::System.String pExlFilPath, global::System.String pExlShtName, global::System.String pExlHdrMain, global::System.String[] pExlCols, global::System.Collections.Generic.Dictionary<string, string> pExlColHdr, List<BaseExcel> pExlData, string pDtFormat)
    //    {
    //        try
    //        {
    //            Int64 totRows = 0;
    //            Int32 totCols = pExlCols.Length;

    //            # region Excel

    //            if (System.IO.File.Exists(pExlFilPath))
    //            {
    //                System.IO.File.Delete(pExlFilPath);
    //            }

    //            # region Excel File Name


    //            ExcelPackage pck = new ExcelPackage(new FileInfo(pExlFilPath));
    //            ExcelWorksheet ws = pck.Workbook.Worksheets.Add(pExlShtName);
    //            ws.View.ShowGridLines = true;

    //            # endregion

    //            # region Main Header Row

    //            totRows++;  // Row 1 Blank

    //            // Row number 2

    //            totRows++;

    //            string cellAddr = string.Concat(pExlCols[1], 2, ":", pExlCols[pExlCols.Length - 2], 2);
    //            ws.Cells[cellAddr].Merge = true;
    //            ws.Cells[cellAddr].Value = pExlHdrMain;
    //            ws.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //            ws.Cells[cellAddr].Style.Font.Bold = true;
    //            ws.Cells[cellAddr].Style.Font.Size = 14;
    //            ws.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //            ws.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;

    //            totRows++;  // Row 3 Blank

    //            # endregion

    //            # region Column Header Row

    //            totRows++;  // Row 4 Coloumn Header

    //            foreach (KeyValuePair<string, string> item in pExlColHdr)
    //            {
    //                ws.Cells[item.Key].Value = item.Value;
    //                ws.Cells[item.Key].Style.Font.Bold = true;
    //                ws.Cells[item.Key].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
    //                ws.Cells[item.Key].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //            }

    //            # endregion

    //            # region Column Data

    //            VerifyData(ref pExlData);

    //            System.Drawing.Color colorCode = System.Drawing.Color.LightCyan;

    //            foreach (BaseExcel item in pExlData)
    //            {
    //                # region Row Changing

    //                if (colorCode == System.Drawing.Color.LightCyan)
    //                {
    //                    colorCode = System.Drawing.Color.White;
    //                }
    //                else
    //                {
    //                    colorCode = System.Drawing.Color.LightCyan;
    //                }

    //                # endregion

    //                totRows++;

    //                Int32 colIndx = 0;  // First column blank

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.SN;
    //                ws.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.CLINIC_NAME;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.PROVIDER_NAME;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.DOS;
    //                ws.Cells[cellAddr].Style.Numberformat.Format = pDtFormat;
    //                ws.Cells[cellAddr].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.CASE_NO;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.PATIENT_NAME;

    //                colIndx++;
    //                cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                ws.Cells[cellAddr].Value = item.CLAIM_STATUS;



    //                for (colIndx = 1; colIndx < totCols - 1; colIndx++)
    //                {
    //                    cellAddr = string.Concat(pExlCols[colIndx], totRows);
    //                    ws.Cells[cellAddr].Style.Fill.PatternType = ExcelFillStyle.Solid;
    //                    ws.Cells[cellAddr].Style.Fill.BackgroundColor.SetColor(colorCode);
    //                    ws.Cells[cellAddr].Style.VerticalAlignment = ExcelVerticalAlignment.Top;
    //                }
    //            }

    //            # endregion

    //            # region Save Sheet

    //            for (int curRow = 2; curRow <= totRows; curRow++)
    //            {
    //                for (int curCol = 1; curCol < totCols - 1; curCol++)
    //                {
    //                    cellAddr = string.Concat(pExlCols[curCol], curRow);

    //                    if ((curCol == 1) && (curRow == 2))
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                    else if ((curCol == (totCols - 2)) && (curRow == 2))
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                    else if ((curRow == totRows) && (curCol == 1))
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                    }
    //                    else if ((curRow == totRows) && (curCol == (totCols - 2)))
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                    }
    //                    else if (curCol == 1)
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                    else if (curCol == (totCols - 2))
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                    else if (curRow == 2)
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Thin;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                    else if (curRow == totRows)
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
    //                    }
    //                    else
    //                    {
    //                        ws.Cells[cellAddr].Style.Border.Left.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Right.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Top.Style = ExcelBorderStyle.Hair;
    //                        ws.Cells[cellAddr].Style.Border.Bottom.Style = ExcelBorderStyle.Hair;
    //                    }
    //                }
    //            }

    //            ws.Cells[string.Concat(pExlCols[0], 1, ":", pExlCols[totCols - 1], totRows)].AutoFitColumns();

    //            # endregion

    //            # region Save Excel

    //            pck.Save();
    //            pck.Dispose();

    //            # endregion

    //            # endregion

    //            # region Description

    //            if (System.IO.File.Exists(pDesFilPath))
    //            {
    //                System.IO.File.Delete(pDesFilPath);
    //            }

    //            XDocument xDoc = new XDocument(
    //                new XElement(XMLFile.EXCEL_SHEET,
    //                    new XElement(XMLFile.DESC,
    //                        new XElement(XMLFile.SUBJECT, pDesMsg.Subject),
    //                        new XElement(XMLFile.CREATED_BY, pDesMsg.CreatedBy),
    //                        new XElement(XMLFile.CREATED_ON, pDesMsg.CreatedOn)
    //                    )
    //                )
    //            );

    //            xDoc.Save(pDesFilPath, System.Xml.Linq.SaveOptions.None);

    //            xDoc = null;

    //            # endregion
    //        }
    //        catch (Exception ex)
    //        {
    //            if (!(ex.ToString().Contains("because it is being used by another process")))
    //            {
    //                throw ex;
    //            }
    //        }
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pExlData"></param>
    //    private static void VerifyData(ref List<BaseExcel> pExlData)
    //    {
    //        if (pExlData.Count == 0)
    //        {
    //            pExlData.Add(new BaseExcel
    //            {


    //                CLAIM_STATUS = "-"
    //                ,
    //                CLINIC_NAME = "-"
    //                ,

    //                DOS = new DateTime(1900, 1, 1, 0, 0, 0, 0)
    //                ,

    //                PROVIDER_NAME = "-"
    //                ,

    //                CASE_NO = "-"
    //                 ,
    //                DX_COUNT = "-"
    //                  ,

    //                SN = 0

    //            });





    //        }
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pStr"></param>
    //    /// <param name="tmpCPT"></param>
    //    /// <returns></returns>
    //    private static object CPT(string pStr)
    //    {
    //        double tmp = Converts.AsDouble(pStr);

    //        if (tmp == 0)
    //        {
    //            return pStr;
    //        }

    //        return tmp;
    //    }

    //    # endregion
    //}


    //#endregion

    //#region BaseExcel

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public class BaseExcel
    //{
    //    #region Primitive Properties

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.Int64 SN
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String CLINIC_NAME
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String PROVIDER_NAME
    //    {
    //        get;
    //        set;
    //    }
    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String PATIENT_NAME
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.DateTime DOS
    //    {
    //        get;
    //        set;
    //    }


    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String CLAIM_STATUS
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String CASE_NO
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String PRIMARY_DX
    //    {
    //        get;
    //        set;
    //    }

    //    /// <summary>
    //    /// Get or Set
    //    /// </summary>
    //    public global::System.String DX_COUNT
    //    {
    //        get;
    //        set;
    //    }



    //    #endregion

    //    public BaseExcel()
    //    {
    //        // TODO: Complete member initialization
    //    }
    //}
    //#endregion

    //# region XMLFile

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public class XMLFile
    //{
    //    public const string EXCEL_SHEET = "ExcelSheet";
    //    public const string DESC = "Desc";
    //    public const string SUBJECT = "Subject";
    //    public const string CREATED_BY = "CreatedBy";
    //    public const string CREATED_ON = "CreatedOn";
    //}

    //# endregion

    //#region EFOperations

    ///// <summary>
    ///// 
    ///// </summary>
    //[Serializable]
    //public class EFOperation
    //{
    //    # region Constructors

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    private EFOperation()
    //    {
    //    }

    //    # endregion


    //    #region Properties

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    public Int32 UserID
    //    {
    //        get;
    //        set;
    //    }

    //    #endregion

    //    # region Public Methods


    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pCHART_NO"></param>
    //    /// <param name="pPROVIDER_ID"></param>
    //    /// <param name="pBILLING_USER_NAME"></param>
    //    /// <param name="pQA_USER_NAME"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <param name="pBILLING_ON_FROM"></param>
    //    /// <param name="pBILLING_ON_TO"></param>
    //    /// <param name="pQA_ON_FROM"></param>
    //    /// <param name="pQA_ON_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedClinic(global::System.String pCLINIC_ID, global::System.String pUserID, global::System.String pCHART_NO, global::System.String pPROVIDER_ID, global::System.String pBILLING_USER_NAME, global::System.String pQA_USER_NAME, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO, Nullable<global::System.DateTime> pBILLING_ON_FROM, Nullable<global::System.DateTime> pBILLING_ON_TO, Nullable<global::System.DateTime> pQA_ON_FROM, Nullable<global::System.DateTime> pQA_ON_TO)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            List<BaseExcel> retAns = new List<BaseExcel>();
    //            List<usp_GetReportClinic_PatientVisit_Result> lst = new List<usp_GetReportClinic_PatientVisit_Result>(ctx.usp_GetReportClinic_PatientVisit(Convert.ToInt32(pCLINIC_ID)));

    //            foreach (usp_GetReportClinic_PatientVisit_Result item in lst)
    //            {
    //                retAns.Add(new BaseExcel()
    //                {
    //                    CASE_NO = item.CASE_NO.ToString()
    //                    ,
    //                    CLAIM_STATUS = item.CLAIM_STATUS
    //                    ,
    //                    CLINIC_NAME = item.CLINIC_NAME
    //                    ,
    //                    DOS = item.DOS
    //                    ,
    //                    DX_COUNT = item.DX_COUNT
    //                     ,
    //                    PATIENT_NAME = item.PATIENT_NAME
    //                     ,
    //                    PROVIDER_NAME = item.PROVIDER_NAME


    //                }

    //                    );
    //            }

    //            return retAns;
    //        }
    //    }



    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pCHART_NO"></param>
    //    /// <param name="pPROVIDER_ID"></param>
    //    /// <param name="pBILLING_USER_NAME"></param>
    //    /// <param name="pQA_USER_NAME"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <param name="pBILLING_ON_FROM"></param>
    //    /// <param name="pBILLING_ON_TO"></param>
    //    /// <param name="pQA_ON_FROM"></param>
    //    /// <param name="pQA_ON_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(global::System.String pCLINIC_ID, global::System.String pUserID, global::System.String pCHART_NO, global::System.String pPROVIDER_ID, global::System.String pBILLING_USER_NAME, global::System.String pQA_USER_NAME, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO, Nullable<global::System.DateTime> pBILLING_ON_FROM, Nullable<global::System.DateTime> pBILLING_ON_TO, Nullable<global::System.DateTime> pQA_ON_FROM, Nullable<global::System.DateTime> pQA_ON_TO)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            List<BaseExcel> retAns = new List<BaseExcel>();
    //            List<usp_GetReport_PatientVisit_Result> lst = new List<usp_GetReport_PatientVisit_Result>(ctx.usp_GetReport_PatientVisit(Convert.ToInt32(pUserID)));

    //            foreach (usp_GetReport_PatientVisit_Result item in lst)
    //            {
    //                retAns.Add(new BaseExcel()
    //                    {
    //                        CASE_NO = item.CASE_NO.ToString()
    //                        ,
    //                        CLAIM_STATUS = item.CLAIM_STATUS
    //                        ,
    //                        CLINIC_NAME = item.CLINIC_NAME
    //                        ,
    //                        DOS = item.DOS
    //                        ,
    //                        DX_COUNT = item.DX_COUNT
    //                         ,
    //                        PATIENT_NAME = item.PATIENT_NAME
    //                         ,
    //                        PROVIDER_NAME = item.PROVIDER_NAME


    //                    }

    //                    );
    //            }

    //            return retAns;
    //        }
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pCHART_NO"></param>
    //    /// <param name="pPROVIDER_ID"></param>
    //    /// <param name="pBILLING_USER_NAME"></param>
    //    /// <param name="pQA_USER_NAME"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <param name="pBILLING_ON_FROM"></param>
    //    /// <param name="pBILLING_ON_TO"></param>
    //    /// <param name="pQA_ON_FROM"></param>
    //    /// <param name="pQA_ON_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineBillingAgentAll(global::System.String pCLINIC_ID, global::System.String pUserID, global::System.String pCHART_NO, global::System.String pPROVIDER_ID, global::System.String pBILLING_USER_NAME, global::System.String pQA_USER_NAME, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO, Nullable<global::System.DateTime> pBILLING_ON_FROM, Nullable<global::System.DateTime> pBILLING_ON_TO, Nullable<global::System.DateTime> pQA_ON_FROM, Nullable<global::System.DateTime> pQA_ON_TO)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            List<BaseExcel> retAns = new List<BaseExcel>();
    //            List<usp_GetAgentBAReport_PatientVisit_Result> lst = new List<usp_GetAgentBAReport_PatientVisit_Result>(ctx.usp_GetAgentBAReport_PatientVisit());

    //            foreach (usp_GetAgentBAReport_PatientVisit_Result item in lst)
    //            {
    //                retAns.Add(new BaseExcel()
    //                {
    //                    CASE_NO = item.CASE_NO.ToString()
    //                    ,
    //                    CLAIM_STATUS = item.CLAIM_STATUS
    //                    ,
    //                    CLINIC_NAME = item.CLINIC_NAME
    //                    ,
    //                    DOS = item.DOS
    //                    ,
    //                    DX_COUNT = item.DX_COUNT
    //                     ,
    //                    PATIENT_NAME = item.PATIENT_NAME
    //                     ,
    //                    PROVIDER_NAME = item.PROVIDER_NAME


    //                }

    //                    );
    //            }

    //            return retAns;
    //        }
    //    }

    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pCHART_NO"></param>
    //    /// <param name="pPROVIDER_ID"></param>
    //    /// <param name="pBILLING_USER_NAME"></param>
    //    /// <param name="pQA_USER_NAME"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <param name="pBILLING_ON_FROM"></param>
    //    /// <param name="pBILLING_ON_TO"></param>
    //    /// <param name="pQA_ON_FROM"></param>
    //    /// <param name="pQA_ON_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineEAAll(global::System.String pCLINIC_ID, global::System.String pUserID, global::System.String pCHART_NO, global::System.String pPROVIDER_ID, global::System.String pBILLING_USER_NAME, global::System.String pQA_USER_NAME, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO, Nullable<global::System.DateTime> pBILLING_ON_FROM, Nullable<global::System.DateTime> pBILLING_ON_TO, Nullable<global::System.DateTime> pQA_ON_FROM, Nullable<global::System.DateTime> pQA_ON_TO)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            List<BaseExcel> retAns = new List<BaseExcel>();
    //            List<usp_GetAgentEAReport_PatientVisit_Result> lst = new List<usp_GetAgentEAReport_PatientVisit_Result>(ctx.usp_GetAgentEAReport_PatientVisit());

    //            foreach (usp_GetAgentEAReport_PatientVisit_Result item in lst)
    //            {
    //                retAns.Add(new BaseExcel()
    //                {
    //                    CASE_NO = item.CASE_NO.ToString()
    //                    ,
    //                    CLAIM_STATUS = item.CLAIM_STATUS
    //                    ,
    //                    CLINIC_NAME = item.CLINIC_NAME
    //                    ,
    //                    DOS = item.DOS
    //                    ,
    //                    DX_COUNT = item.DX_COUNT
    //                     ,
    //                    PATIENT_NAME = item.PATIENT_NAME
    //                     ,
    //                    PROVIDER_NAME = item.PROVIDER_NAME


    //                }

    //                    );
    //            }

    //            return retAns;
    //        }
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pCHART_NO"></param>
    //    /// <param name="pPROVIDER_ID"></param>
    //    /// <param name="pBILLING_USER_NAME"></param>
    //    /// <param name="pQA_USER_NAME"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <param name="pBILLING_ON_FROM"></param>
    //    /// <param name="pBILLING_ON_TO"></param>
    //    /// <param name="pQA_ON_FROM"></param>
    //    /// <param name="pQA_ON_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineQAAll(global::System.String pCLINIC_ID, global::System.String pUserID, global::System.String pCHART_NO, global::System.String pPROVIDER_ID, global::System.String pBILLING_USER_NAME, global::System.String pQA_USER_NAME, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO, Nullable<global::System.DateTime> pBILLING_ON_FROM, Nullable<global::System.DateTime> pBILLING_ON_TO, Nullable<global::System.DateTime> pQA_ON_FROM, Nullable<global::System.DateTime> pQA_ON_TO)
    //    {
    //        using (EFContext ctx = new EFContext())
    //        {
    //            List<BaseExcel> retAns = new List<BaseExcel>();
    //            List<usp_GetAgentQAReport_PatientVisit_Result> lst = new List<usp_GetAgentQAReport_PatientVisit_Result>(ctx.usp_GetAgentQAReport_PatientVisit());

    //            foreach (usp_GetAgentQAReport_PatientVisit_Result item in lst)
    //            {
    //                retAns.Add(new BaseExcel()
    //                {
    //                    CASE_NO = item.CASE_NO.ToString()
    //                    ,
    //                    CLAIM_STATUS = item.CLAIM_STATUS
    //                    ,
    //                    CLINIC_NAME = item.CLINIC_NAME
    //                    ,
    //                    DOS = item.DOS
    //                    ,
    //                    DX_COUNT = item.DX_COUNT
    //                     ,
    //                    PATIENT_NAME = item.PATIENT_NAME
    //                     ,
    //                    PROVIDER_NAME = item.PROVIDER_NAME


    //                }

    //                    );
    //            }

    //            return retAns;
    //        }
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedClinic(int clinicID)
    //    {
    //        global::System.String pCLINIC_ID = clinicID.ToString();
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;


    //        return uspBillingOnlineCapitatedClinic(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(int userID)
    //    {
    //        global::System.String pCLINIC_ID = null;
    //        global::System.String pUserID = userID.ToString();
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;


    //        return uspBillingOnlineCapitatedAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }
    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineBillingAgentAll()
    //    {
    //        global::System.String pCLINIC_ID = null;
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;


    //        return uspBillingOnlineBillingAgentAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineEAAll()
    //    {
    //        global::System.String pCLINIC_ID = null;
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;


    //        return uspBillingOnlineEAAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineQAAll()
    //    {
    //        global::System.String pCLINIC_ID = null;
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;


    //        return uspBillingOnlineQAAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(global::System.String pCLINIC_ID)
    //    {
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;

    //        return uspBillingOnlineCapitatedAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pChartNoOrProvID"></param>
    //    /// <param name="pIsPat"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(global::System.String pCLINIC_ID, global::System.String pChartNoOrProvID, bool pIsPat)
    //    {
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pDOS_FROM = null;
    //        Nullable<global::System.DateTime> pDOS_TO = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;

    //        if (pIsPat)
    //        {
    //            pCHART_NO = pChartNoOrProvID;
    //        }
    //        else
    //        {
    //            pPROVIDER_ID = pChartNoOrProvID;
    //        }

    //        return uspBillingOnlineCapitatedAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(global::System.String pCLINIC_ID, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO)
    //    {
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;

    //        return uspBillingOnlineCapitatedAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }

    //    /// <summary>
    //    /// 
    //    /// </summary>
    //    /// <param name="pCLINIC_ID"></param>
    //    /// <param name="pChartNoOrProvID"></param>
    //    /// <param name="pIsPat"></param>
    //    /// <param name="pDOS_FROM"></param>
    //    /// <param name="pDOS_TO"></param>
    //    /// <returns></returns>
    //    public static List<BaseExcel> uspBillingOnlineCapitatedAll(global::System.String pCLINIC_ID, global::System.String pChartNoOrProvID, bool pIsPat, Nullable<global::System.DateTime> pDOS_FROM, Nullable<global::System.DateTime> pDOS_TO)
    //    {
    //        global::System.String pUserID = null;
    //        global::System.String pCHART_NO = null;
    //        global::System.String pPROVIDER_ID = null;
    //        global::System.String pBILLING_USER_NAME = null;
    //        global::System.String pQA_USER_NAME = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_FROM = null;
    //        Nullable<global::System.DateTime> pBILLING_ON_TO = null;
    //        Nullable<global::System.DateTime> pQA_ON_FROM = null;
    //        Nullable<global::System.DateTime> pQA_ON_TO = null;

    //        if (pIsPat)
    //        {
    //            pCHART_NO = pChartNoOrProvID;
    //        }
    //        else
    //        {
    //            pPROVIDER_ID = pChartNoOrProvID;
    //        }

    //        return uspBillingOnlineCapitatedAll(pCLINIC_ID, pUserID, pCHART_NO, pPROVIDER_ID, pBILLING_USER_NAME, pQA_USER_NAME, pDOS_FROM, pDOS_TO, pBILLING_ON_FROM, pBILLING_ON_TO, pQA_ON_FROM, pQA_ON_TO);
    //    }



    //    # endregion
    //}


    //#endregion

# endregion
}
