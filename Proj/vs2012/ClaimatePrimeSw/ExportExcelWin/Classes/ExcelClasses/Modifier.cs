using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Xml.Linq;

namespace ExportExcelWin.Classes.ExcelClasses
{
    /// <summary>
    /// 
    /// </summary>
    public class Modifier : CodNam
    {
        #region Properties

       

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public Modifier()
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
                    case "MODIFIER_CODE":
                        CODE = xAttr.Value;
                        break;
                    case "MODIFIER_NAME":
                        NAME = xAttr.Value;
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
