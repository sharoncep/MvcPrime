using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Globalization;
using System.Drawing;

namespace OfficeOpenXml.Drawing.Vml
{
    /// <summary>
    /// Horizontal Alingment
    /// </summary>
    public enum eTextAlignHorizontalVml
    {
        /// <summary>
        /// 
        /// </summary>
        Left,

        /// <summary>
        /// 
        /// </summary>
        Center,

        /// <summary>
        /// 
        /// </summary>
        Right
    }
    /// <summary>
    /// Vertical Alingment
    /// </summary>
    public enum eTextAlignVerticalVml
    {
        /// <summary>
        /// 
        /// </summary>
        Top,

        /// <summary>
        /// 
        /// </summary>
        Center,

        /// <summary>
        /// 
        /// </summary>
        Bottom
    }
    /// <summary>
    /// Linestyle
    /// </summary>
    public enum eLineStyleVml
    {
        /// <summary>
        /// 
        /// </summary>
        Solid,

        /// <summary>
        /// 
        /// </summary>
        Round,

        /// <summary>
        /// 
        /// </summary>
        Square,

        /// <summary>
        /// 
        /// </summary>
        Dash,

        /// <summary>
        /// 
        /// </summary>
        DashDot,

        /// <summary>
        /// 
        /// </summary>
        LongDash,

        /// <summary>
        /// 
        /// </summary>
        LongDashDot,

        /// <summary>
        /// 
        /// </summary>
        LongDashDotDot
    }
    /// <summary>
    /// Drawing object used for comments
    /// </summary>
    public class ExcelVmlDrawingBase : XmlHelper
    {
        internal ExcelVmlDrawingBase(XmlNode topNode, XmlNamespaceManager ns) :
            base(ns, topNode)
        {
            SchemaNodeOrder = new string[] { "fill", "stroke", "shadow", "path", "textbox", "ClientData", "MoveWithCells", "SizeWithCells", "Anchor", "Locked", "AutoFill", "LockText", "TextHAlign", "TextVAlign", "Row", "Column", "Visible" };
        }  
        /// <summary>
        /// 
        /// </summary>
        public string Id 
        {
            get
            {
                return GetXmlNodeString("@id");
            }
            set
            {
                SetXmlNodeString("@id",value);
            }
        }
        #region "Style Handling methods"
        /// <summary>
        /// 
        /// </summary>
        /// <param name="style"></param>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        protected bool GetStyle(string style, string key, out string value)
        {
            string[]styles = style.Split(';');
            foreach(string s in styles)
            {
                if (s.IndexOf(':') > 0)
                {
                    string[] split = s.Split(':');
                    if (split[0] == key)
                    {
                        value=split[1];
                        return true;
                    }
                }
                else if (s == key)
                {
                    value="";
                    return true;
                }
            }
            value="";
            return false;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="style"></param>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        protected string SetStyle(string style, string key, string value)
        {
            string[] styles = style.Split(';');
            string newStyle="";
            bool changed = false;
            foreach (string s in styles)
            {
                string[] split = s.Split(':');
                if (split[0].Trim() == key)
                {
                    if (value.Trim() != "") //If blank remove the item
                    {
                        newStyle += key + ':' + value;
                    }
                    changed = true;
                }
                else
                {
                    newStyle += s;
                }
                newStyle += ';';
            }
            if (!changed)
            {
                newStyle += key + ':' + value;
            }
            else
            {
                newStyle = style.Substring(0, style.Length - 1);
            }
            return newStyle;
        }
        #endregion
    }
}
