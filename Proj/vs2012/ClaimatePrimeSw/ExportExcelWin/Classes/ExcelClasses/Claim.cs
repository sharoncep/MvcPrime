using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Xml.Linq;
using System.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class Claim : BaseClass
    {
        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String CLINIC_NAME
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String PROVIDER_NAME
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.DateTime DOS
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int64 CASE_NO
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String INSURANCE_NAME
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String PATIENT_NAME
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String CHART_NO
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String POLICY_NO
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String CLAIM_STATUS
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public ClaimDx PRI_CLAIM_DX
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public IBaseList CLAIM_DXS
        {
            get;
            private set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public Claim()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            PRI_CLAIM_DX = new ClaimDx();
            CLAIM_DXS = new BaseList();
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

            XElement xElement = pXDoc.Element("PAT_VSTS");

            if (xElement != null)
            {
                xElements = xElement.Elements("PAT_VST");
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
                    case "SN":
                        SN = Convert.ToInt64(xAttr.Value);
                        break;
                    case "CASE_NO":
                        CASE_NO = Convert.ToInt64(xAttr.Value);
                        break;
                    case "CLINIC_NAME":
                        CLINIC_NAME = xAttr.Value;
                        break;
                    case "PROVIDER_NAME":
                        PROVIDER_NAME = xAttr.Value;
                        break;
                    case "DOS":
                        DOS = Convert.ToDateTime(xAttr.Value);
                        break;
                    case "INSURANCE_NAME":
                        INSURANCE_NAME = xAttr.Value;
                        break;
                    case "PATIENT_NAME":
                        PATIENT_NAME = xAttr.Value;
                        break;
                    case "CHART_NO":
                        CHART_NO = xAttr.Value;
                        break;
                    case "POLICY_NO":
                        POLICY_NO = xAttr.Value;
                        break;
                    case "CLAIM_STATUS":
                        CLAIM_STATUS = xAttr.Value;
                        break;
                    default:
                        // No Action
                        break;
                }
            }

            # region Primary Dx

            PRI_CLAIM_DX = ((new ClaimDx()).SelectList(pXEle.Elements("PRI_CLM_DX")).IBaseClasses.SingleOrDefault()) as ClaimDx;
            if (PRI_CLAIM_DX == null)
            {
                PRI_CLAIM_DX = new ClaimDx();
            }

            # endregion

            # region ClaimDiagnosiss

            string xDoc = Convert.ToString(pXEle.Element("CLM_DXS"));
            if (!(string.IsNullOrWhiteSpace(xDoc)))
            {
                CLAIM_DXS = (new ClaimDx()).SelectList(XDocument.Parse(xDoc));
            }

            # endregion
        }

        # endregion
    }
}