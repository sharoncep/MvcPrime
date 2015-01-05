using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Xml.Linq;

namespace ExportExcelWin.Classes
{
    /// <summary>
    /// 
    /// </summary>
    public class UserReport : BaseClass
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public byte ReportTypeID { get;  set; }

        /// <summary>
        /// Get
        /// </summary>
        public long? ReportObjectID { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        public DateTime? DateFrom { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        public DateTime? DateTo { get;  set; }

        /// <summary>
        /// Get 
        /// </summary>
        public int UserID { get;  set; }

        /// <summary>
        /// Get 
        /// </summary>
        public bool IsSuccess { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        public string ExcelFileName { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public string ExcelFileNameTmp { get; private set; }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        public UserReport()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        protected override void Fill()
        {
            ID = (Int16)0;
            ExcelFileName = string.Empty;
            ExcelFileNameTmp = string.Empty;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName"></param>
        /// <param name="pCn"></param>
        /// <param name="pTrans"></param>
        /// <param name="pParams"></param>
        protected override XDocument Fill(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams)
        {
            XDocument xDoc = null;

            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings[pSpKy], pCn, pTrans))
            {
                cmd.CommandTimeout = pCn.ConnectionTimeout;
                cmd.CommandType = CommandType.StoredProcedure;

                if (pParams != null)
                {
                    foreach (SqlParameter parm in pParams)
                    {
                        cmd.Parameters.Add(parm);
                    }
                }

                XmlReader xmlRdr = cmd.ExecuteXmlReader();

                if ((xmlRdr.Read()) && (xmlRdr.ReadState == ReadState.Interactive))
                {
                    xDoc = XDocument.Load(xmlRdr);
                }
            }

            return xDoc;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXDoc"></param>
        protected override IEnumerable<XElement> Fill(XDocument pXDoc)
        {
            IEnumerable<XElement> xElements = null;

            XElement xElement = pXDoc.Element("DELETED_REPORTS");

            if (xElement != null)
            {
                xElements = xElement.Elements("TEMP");
                xElement = null;
            }

            return xElements;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEle"></param>
        protected override void Fill(XElement pXEle)
        {
            foreach (XAttribute xAttr in pXEle.Attributes())
            {
                switch (Convert.ToString(xAttr.Name))
                {
                    case "USER_REPORT_ID":
                        ID = Convert.ToInt32(xAttr.Value);
                        break;
                    case "EXCEL_FILE_NAME":
                        ExcelFileName = xAttr.Value;
                        break;
                    default:
                        // No Action
                        break;
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn"></param>
        /// <param name="pTrans"></param>
        /// <returns></returns>
        protected override object Insert(SqlConnection pCn, SqlTransaction pTrans)
        {
            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SP_UR_INSERT"], pCn, pTrans))
            {
                cmd.CommandTimeout = pCn.ConnectionTimeout;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "ReportTypeID", SqlDbType = SqlDbType.TinyInt, Direction = ParameterDirection.Input, Value = this.ReportTypeID });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "ReportObjectID", SqlDbType = SqlDbType.BigInt, Direction = ParameterDirection.Input, Value = this.ReportObjectID });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "DateFrom", SqlDbType = SqlDbType.Date, Direction = ParameterDirection.Input, Value = this.DateFrom });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "DateTo", SqlDbType = SqlDbType.Date, Direction = ParameterDirection.Input, Value = this.DateTo });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "CurrentModificationBy", SqlDbType = SqlDbType.Int, Direction = ParameterDirection.Input, Value = this.UserID });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "NxtIdn", SqlDbType = SqlDbType.NVarChar, Size=5, Direction = ParameterDirection.Input, Value = this.NxtID(pCn, pTrans) });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "UserReportID", SqlDbType = SqlDbType.SmallInt, Direction = ParameterDirection.InputOutput, Value = this.ID });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "ExcelFileName", SqlDbType = SqlDbType.NVarChar, Size = 50, Direction = ParameterDirection.InputOutput, Value = ExcelFileName });
                cmd.ExecuteNonQuery();
                this.ID = Convert.ToInt16(cmd.Parameters["UserReportID"].Value);
                this.ExcelFileName = Convert.ToString(cmd.Parameters["ExcelFileName"].Value);
                this.ExcelFileNameTmp = string.Concat("TMP", this.ExcelFileName);
            }

            return this.ID;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn"></param>
        /// <param name="pTrans"></param>
        /// <returns></returns>
        protected override object Update(SqlConnection pCn, SqlTransaction pTrans)
        {
            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SP_UR_UPDATE"], pCn, pTrans))
            {
                cmd.CommandTimeout = pCn.ConnectionTimeout;
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(new SqlParameter() { ParameterName = "IsSuccess", SqlDbType = SqlDbType.Bit, Direction = ParameterDirection.Input, Value = IsSuccess });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "UserReportID", SqlDbType = SqlDbType.SmallInt, Direction = ParameterDirection.InputOutput, Value = this.ID });
              
                cmd.ExecuteNonQuery();
                this.ID = Convert.ToInt16(cmd.Parameters["UserReportID"].Value);
              

            }
            return this.ID;
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn"></param>
        /// <param name="pTrans"></param>
        /// <returns></returns>
        private string NxtID(SqlConnection pCn, SqlTransaction pTrans)
        {
            string retAns = string.Empty;

            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings["SP_NXT_ID"], pCn, pTrans))
            {
                cmd.CommandTimeout = pCn.ConnectionTimeout;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "SchemaName", SqlDbType = SqlDbType.NVarChar, Size = 150, Direction = ParameterDirection.Input, Value = "Audit" });
                cmd.Parameters.Add(new SqlParameter() { ParameterName = "TableName", SqlDbType = SqlDbType.NVarChar, Size = 150, Direction = ParameterDirection.Input, Value = "UserReport" });

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        retAns = Convert.ToString(dr["NEXT_INDENTITY"]);

                    }

                    dr.Close();
                }
            }

            return retAns;
        }

        # endregion
    }
}
