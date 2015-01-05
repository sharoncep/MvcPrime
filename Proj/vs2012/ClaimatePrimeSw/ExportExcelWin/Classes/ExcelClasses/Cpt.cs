using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class Cpt : DxCpt
    {
        #region Properties

        /// <summary>
        /// Get 
        /// </summary>
        public global::System.Decimal CHARGE_PER_UNIT
        {
            get;
            private set;
        }

        /// <summary>
        /// Get 
        /// </summary>
        public global::System.Boolean IS_HCPCS_CODE
        {
            get;
            private set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public Cpt()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected override void Fill()
        {
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
                    case "CPT_CODE":
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
                    case "CHARGE_PER_UNIT":
                        CHARGE_PER_UNIT = Convert.ToDecimal(xAttr.Value);
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
