using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class ClaimModifier : BaseClass
    {
        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        public Modifier MODIFIER
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int16 MODIFIER_LEVEL
        {
            get;
            private set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ClaimModifier()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            MODIFIER = new Modifier();
        }

        protected override IEnumerable<XElement> Fill(XDocument pXDoc)
        {
            IEnumerable<XElement> xElements = null;

            XElement xElement = pXDoc.Element("CLM_MODIS");

            if (xElement != null)
            {
                xElements = xElement.Elements("CLM_MODI");
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
                    case "MODIFIER_LEVEL":
                        MODIFIER_LEVEL = Convert.ToInt16(xAttr.Value);
                        break;
                    case "SN":
                        SN = Convert.ToInt32(xAttr.Value);
                        break;
                    default:
                        // No Action
                        break;
                }
            }

            # region Cpt

            MODIFIER.Select(pXEle.Element("MODI"));

            # endregion
        }

        # endregion
    }
}
