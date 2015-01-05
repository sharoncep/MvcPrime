using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class ClaimCpt : BaseClass
    {
        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        public Cpt CPT
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Facility FACILITY
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int32 UNIT
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Decimal TOTAL_CHARGE
        {
            get
            {
                return (CPT.CHARGE_PER_UNIT * UNIT);
            }
        }

        /// <summary>
        /// Get 
        /// </summary>
        public IBaseList CLAIM_MODIFIERS
        {
            get;
            private set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ClaimCpt()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            CPT = new Cpt();
            FACILITY = new Facility();
            CLAIM_MODIFIERS = new BaseList();
        }

        protected override IEnumerable<XElement> Fill(XDocument pXDoc)
        {
            IEnumerable<XElement> xElements = null;

            XElement xElement = pXDoc.Element("CLM_CPTS");

            if (xElement != null)
            {
                xElements = xElement.Elements("CLM_CPT");
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
                    case "CLAIM_DIAGNOSIS_CPTID":
                        ID = Convert.ToInt32(xAttr.Value);
                        break;
                    case "SN":
                        SN = Convert.ToInt32(xAttr.Value);
                        break;
                    case "UNIT":
                        UNIT = Convert.ToInt32(xAttr.Value);
                        break;
                    default:
                        // No Action
                        break;
                }
            }

            # region Claim Cpts

            string xDoc = Convert.ToString(pXEle.Element("CLM_MODIS"));
            if (!(string.IsNullOrWhiteSpace(xDoc)))
            {
                CLAIM_MODIFIERS = (new ClaimModifier()).SelectList(XDocument.Parse(xDoc));
            }

            # endregion

            # region Cpt

            CPT.Select(pXEle.Element("CPT"));

            # endregion
        }

        # endregion
    }
}
