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
    public class User : ReportObject
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public string Email { get; private set; }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        public User()
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
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName"></param>
        /// <param name="pCn"></param>
        /// <param name="pParams"></param>
        /// <returns></returns>
        protected override XDocument Fill(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams)
        {
            XDocument xDoc = null;

            using (SqlCommand cmd = new SqlCommand(ConfigurationManager.AppSettings[pSpKy], pCn))
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

            XElement xElement = pXDoc.Element("USRS");

            if (xElement != null)
            {
                xElements = xElement.Elements("USR");
                xElement = null;
            }

            return xElements;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEle"></param>

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
                    case "SN":
                        SN = Convert.ToInt64(xAttr.Value);
                        break;
                    case "USER_ID":
                        ID = Convert.ToInt32(xAttr.Value);
                        break;
                    case "EMAIL":
                        Email = xAttr.Value;
                        break;
                    case "NAME_CODE":
                        Name = xAttr.Value;
                        break;  
                    default:
                        // No Action
                        break;
                }
            }
        }

        # endregion
    }
}
