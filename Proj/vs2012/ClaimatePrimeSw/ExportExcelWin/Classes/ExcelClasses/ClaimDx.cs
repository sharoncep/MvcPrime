using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class ClaimDx : BaseClass
    {
        #region Properties
        
        /// <summary>
        /// Get or Set
        /// </summary>
        public Dx DX
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public IBaseList CLAIM_CPTS
        {
            get;
            private set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ClaimDx()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            CLAIM_CPTS = new BaseList();
            DX = new Dx();
        }

        protected override IEnumerable<XElement> Fill(XDocument pXDoc)
        {
            IEnumerable<XElement> xElements = null;

            XElement xElement = pXDoc.Element("CLM_DXS");

            if (xElement != null)
            {
                xElements = xElement.Elements("CLM_DX");
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
                    case "CLAIMDIAGNOSIS_ID":
                        ID = Convert.ToInt32(xAttr.Value);
                        break;
                    case "SN":
                        SN = Convert.ToInt32(xAttr.Value);
                        break;                    
                    default:
                        // No Action
                        break;
                }
            }

            # region Claim Cpts

            string xDoc = Convert.ToString(pXEle.Element("CLM_CPTS"));
            if (!(string.IsNullOrWhiteSpace(xDoc)))
            {
                CLAIM_CPTS = (new ClaimCpt()).SelectList(XDocument.Parse(xDoc));
            }

            # endregion

            # region Primary DX

            string xelePdx = Convert.ToString(pXEle.Element("CLM_DX"));
            if (!(string.IsNullOrWhiteSpace(xelePdx)))
            {
                DX.Select(pXEle.Element("CLM_DX").Element("DX"));
            }

            # endregion

            # region DX

            DX.Select(pXEle.Element("DX"));

            # endregion
        }

        # endregion
    }
}
