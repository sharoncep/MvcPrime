using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class Dg : CodNam
    {
        #region Properties

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public Dg()
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
                    case "DG_CODE":
                        CODE = Convert.ToString(xAttr.Value);
                        break;
                    case "DG_DESCRIPTION":
                        NAME = Convert.ToString(xAttr.Value);
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
