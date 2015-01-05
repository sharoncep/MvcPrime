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
    public class Provider : ReportObject
    {
        # region Properties

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        public Provider()
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

            XElement xElement = pXDoc.Element("PROVIDER");

            if (xElement != null)
            {
                xElements = xElement.Elements("PR");
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
                    case "ProviderID":
                        ID = Convert.ToInt32(xAttr.Value);
                        break;
                    case "NAME":
                        Name = (xAttr.Value.ToString());
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
