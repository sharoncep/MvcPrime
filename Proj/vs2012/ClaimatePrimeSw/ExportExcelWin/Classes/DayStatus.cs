using ClaimatePrimeConstants;
using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace ExportExcelWin.Classes
{
    /// <summary>
    /// 
    /// </summary>
    public class DayStatus : BaseClass
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public bool DAY_STS { get; set; }

        /// <summary>
        /// Get
        /// </summary>
        public DateTime CURR_DT_TM { get; private set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public DayStatus()
            : base()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            DAY_STS = false;
            CURR_DT_TM = DateTime.Now;
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

            XElement xElement = pXDoc.Element("DSS");

            if (xElement != null)
            {
                xElements = xElement.Elements("DS");
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
                    case "DAY_STS":
                        DAY_STS = Converts.AsBoolean(xAttr.Value);
                        break;
                    case "CURR_DT_TM":
                        CURR_DT_TM = Convert.ToDateTime(xAttr.Value);
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
