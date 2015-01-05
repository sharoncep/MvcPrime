using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace OfficeOpenXml.Style
{
    /// <summary>
    /// Handels paragraph text
    /// </summary>
    public sealed class ExcelParagraph : ExcelTextFont
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ns"></param>
        /// <param name="rootNode"></param>
        /// <param name="path"></param>
        /// <param name="schemaNodeOrder"></param>
        public ExcelParagraph(XmlNamespaceManager ns, XmlNode rootNode, string path, string[] schemaNodeOrder) : 
            base(ns, rootNode, path + "a:rPr", schemaNodeOrder)
        { 

        }

        const string TextPath = "../a:t";
        /// <summary>
        /// Text
        /// </summary>
        public string Text
        {
            get
            {
                return GetXmlNodeString(TextPath);
            }
            set
            {
                CreateTopNode();
                SetXmlNodeString(TextPath, value);
            }

        }
    }
}
