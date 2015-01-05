using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class Dx : DxCpt
    {
        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        public Dg DG
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.Int16 ICD_FORMAT
        {
            get;
            private set;
        }      

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public Dx()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
            DG = new Dg();
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
                    case "ICD_FORMAT":
                        ICD_FORMAT = Convert.ToInt16(xAttr.Value);
                        break;
                    case "DIAGNOSIS_CODE":
                        CODE = xAttr.Value;
                        break;
                    case "SHORT_DESC":
                        SHORT_DESC = xAttr.Value;
                        break;
                    case "LONG_DESC":
                        LONG_DESC = xAttr.Value;
                        break;
                    case "MEDIUM_DESC":
                        MEDIUM_DESC = xAttr.Value;
                        break;
                    case "CUSTOM_DESC":
                        CUSTOM_DESC = xAttr.Value;
                        break;                    
                    default:
                        // No Action
                        break;
                }
            }

            # region DX

            DG.Select(pXEle.Element("DG"));

            # endregion
        }

        # endregion
    }
}
