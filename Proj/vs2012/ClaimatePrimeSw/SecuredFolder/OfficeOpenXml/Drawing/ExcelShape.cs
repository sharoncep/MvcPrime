/* 
 * You may amend and distribute as you like, but don't remove this header!
 * 
 * EPPlus provides server-side generation of Excel 2007 spreadsheets.
 *
 * See http://www.codeplex.com/EPPlus for details.
 * 
 * All rights reserved.
 * 
 * EPPlus is an Open Source project provided under the 
 * GNU General Public License (GPL) as published by the 
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * The GNU General Public License can be viewed at http://www.opensource.org/licenses/gpl-license.php
 * If you unfamiliar with this license or have questions about it, here is an http://www.gnu.org/licenses/gpl-faq.html
 * 
 * The code for this project may be used and redistributed by any means PROVIDING it is 
 * not sold for profit without the author's written consent, and providing that this notice 
 * and the author's name and all copyright notices remain intact.
 * 
 * All code and executables are provided "as is" with no warranty either express or implied. 
 * The author accepts no liability for any damage or loss of business that this product may cause.
 *
 * 
 * Code change notes:
 * 
 * Author							Change						Date
 * ******************************************************************************
 * Jan Källman		                Initial Release		        2009-10-01
 *******************************************************************************/
using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using OfficeOpenXml.Style.XmlAccess;
using OfficeOpenXml.Drawing;
using OfficeOpenXml.Style;

/// <summary>
/// 
/// </summary>
public enum eShapeStyle
{
    /// <summary>
    /// 
    /// </summary>
    AccentBorderCallout1,

    /// <summary>
    /// 
    /// </summary>
    AccentBorderCallout2,

    /// <summary>
    /// 
    /// </summary>
    AccentBorderCallout3,

    /// <summary>
    /// 
    /// </summary>
    AccentCallout1,

    /// <summary>
    /// 
    /// </summary>
    AccentCallout2,

    /// <summary>
    /// 
    /// </summary>
    AccentCallout3,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonBackPrevious,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonBeginning,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonBlank,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonDocument,
    /// <summary>
    /// 
    /// </summary>
    ActionButtonEnd,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonForwardNext,
    /// <summary>
    /// 
    /// </summary>
    ActionButtonHelp,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonHome,
    /// <summary>
    /// 
    /// </summary>
    ActionButtonInformation,

    /// <summary>
    /// 
    /// </summary>
    ActionButtonMovie,
    /// <summary>
    /// 
    /// </summary>
    ActionButtonReturn,
    /// <summary>
    /// 
    /// </summary>
    ActionButtonSound,
    /// <summary>
    /// 
    /// </summary>
    Arc,
    /// <summary>
    /// 
    /// </summary>
    BentArrow,
    /// <summary>
    /// 
    /// </summary>
    BentConnector2,
    /// <summary>
    /// 
    /// </summary>
    BentConnector3,
    /// <summary>
    /// 
    /// </summary>
    BentConnector4,
    /// <summary>
    /// 
    /// </summary>
    BentConnector5,
    /// <summary>
    /// 
    /// </summary>
    BentUpArrow,
    /// <summary>
    /// 
    /// </summary>
    Bevel,
    /// <summary>
    /// 
    /// </summary>
    BlockArc,
    /// <summary>
    /// 
    /// </summary>
    BorderCallout1,
    /// <summary>
    /// 
    /// </summary>
    BorderCallout2,
    /// <summary>
    /// 
    /// </summary>
    BorderCallout3,
    /// <summary>
    /// 
    /// </summary>
    BracePair,
    /// <summary>
    /// 
    /// </summary>
    BracketPair,
    /// <summary>
    /// 
    /// </summary>
    Callout1,
    /// <summary>
    /// 
    /// </summary>
    Callout2,

    /// <summary>
    /// 
    /// </summary>
    Callout3,
    /// <summary>
    /// 
    /// </summary>
    Can,
    /// <summary>
    /// 
    /// </summary>
    ChartPlus,
    /// <summary>
    /// 
    /// </summary>
    ChartStar,
    /// <summary>
    /// 
    /// </summary>
    ChartX,
    /// <summary>
    /// 
    /// </summary>
    Chevron,
    /// <summary>
    /// //////
    /// </summary>
    Chord,
    /// <summary>
    /// //
    /// </summary>
    CircularArrow,
    /// <summary>
    /// //
    /// </summary>
    Cloud,
    /// <summary>
    /// //
    /// </summary>
    CloudCallout,
    /// <summary>
    /// 
    /// </summary>
    Corner,
    /// <summary>
    /// 
    /// </summary>
    CornerTabs,
    /// <summary>
    /// 
    /// </summary>
    Cube,
    /// <summary>
    /// 
    /// </summary>
    CurvedConnector2,
    /// <summary>
    /// 
    /// </summary>
    CurvedConnector3,
    /// <summary>
    /// 
    /// </summary>
    CurvedConnector4,
    /// <summary>
    /// 
    /// </summary>
    CurvedConnector5,
    /// <summary>
    /// /////
    /// </summary>
    CurvedDownArrow,
    /// <summary>
    /// 
    /// </summary>
    CurvedLeftArrow,
    /// <summary>
    /// 
    /// </summary>
    CurvedRightArrow,
    /// <summary>
    /// 
    /// </summary>
    CurvedUpArrow,
    /// <summary>
    /// /
    /// </summary>
    Decagon,
    /// <summary>
    /// 
    /// </summary>
    DiagStripe,
    /// <summary>
    /// 
    /// </summary>
    Diamond,
    /// <summary>
    /// 
    /// </summary>
    Dodecagon,
    /// <summary>
    /// 
    /// </summary>
    Donut,
    /// <summary>
    /// 
    /// </summary>
    DoubleWave,
    /// <summary>
    /// 
    /// </summary>
    DownArrow,
    /// <summary>
    /// 
    /// </summary>
    DownArrowCallout,
    /// <summary>
    /// 
    /// </summary>
    Ellipse,
    /// <summary>
    /// 
    /// </summary>
    EllipseRibbon,
    /// <summary>
    /// 
    /// </summary>
    EllipseRibbon2,
    /// <summary>
    /// 
    /// </summary>
    FlowChartAlternateProcess,
    /// <summary>
    /// 
    /// </summary>
    FlowChartCollate,
    /// <summary>
    /// 
    /// </summary>
    FlowChartConnector,
    /// <summary>
    /// 
    /// </summary>
    FlowChartDecision,
    /// <summary>
    /// 
    /// </summary>
    FlowChartDelay,
    /// <summary>
    /// 
    /// </summary>
    FlowChartDisplay,
    /// <summary>
    /// 
    /// </summary>
    FlowChartDocument,
    /// <summary>
    /// 
    /// </summary>
    FlowChartExtract,
    /// <summary>
    /// 
    /// </summary>
    FlowChartInputOutput,
    /// <summary>
    /// 
    /// </summary>
    FlowChartInternalStorage,
    /// <summary>
    /// 
    /// </summary>
    FlowChartMagneticDisk,
    /// <summary>
    /// 
    /// </summary>
    FlowChartMagneticDrum,
    /// <summary>
    /// 
    /// </summary>
    FlowChartMagneticTape,
    /// <summary>
    /// 
    /// </summary>
    FlowChartManualInput,
    /// <summary>
    /// 
    /// </summary>
    FlowChartManualOperation,
    /// <summary>
    /// 
    /// </summary>
    FlowChartMerge,
    /// <summary>
    /// 
    /// </summary>
    FlowChartMultidocument,
    /// <summary>
    /// 
    /// </summary>
    FlowChartOfflineStorage,
    /// <summary>
    /// /
    /// </summary>
    FlowChartOffpageConnector,
    /// <summary>
    /// 
    /// </summary>
    FlowChartOnlineStorage,
/// <summary>
/// 
/// </summary>
/// 
    FlowChartOr,
    /// <summary>
    /// 
    /// </summary>
    FlowChartPredefinedProcess,
    /// <summary>
    /// 
    /// </summary>
    FlowChartPreparation,
    /// <summary>
    /// 
    /// </summary>
    FlowChartProcess,
    /// <summary>
    /// 
    /// </summary>
    FlowChartPunchedCard,
    /// <summary>
    /// 
    /// </summary>
    FlowChartPunchedTape,
    /// <summary>
    /// 
    /// </summary>
    FlowChartSort,
    /// <summary>
    /// 
    /// </summary>
    FlowChartSummingJunction,
    /// <summary>
    /// 
    /// </summary>
    FlowChartTerminator,
    /// <summary>
    /// 
    /// </summary>
    FoldedCorner,
    /// <summary>
    /// 
    /// </summary>
    Frame,
    /// <summary>
    /// 
    /// </summary>
    Funnel,
    /// <summary>
    /// 
    /// </summary>
    Gear6,
    /// <summary>
    /// 
    /// </summary>
    Gear9,
    /// <summary>
    /// 
    /// </summary>
    HalfFrame,
    /// <summary>
    /// 
    /// </summary>
    Heart,
    /// <summary>
    /// 
    /// </summary>
    Heptagon,
    /// <summary>
    /// 
    /// </summary>
    Hexagon,
    /// <summary>
    /// 
    /// </summary>
    HomePlate,
    /// <summary>
    /// 
    /// </summary>
    HorizontalScroll,
    /// <summary>
    /// 
    /// </summary>
    IrregularSeal1,
    /// <summary>
    /// 
    /// </summary>
    IrregularSeal2,
    /// <summary>
    /// 
    /// </summary>
    LeftArrow,
    /// <summary>
    /// 
    /// </summary>
    LeftArrowCallout,
    /// <summary>
    /// 
    /// </summary>
    LeftBrace,
    /// <summary>
    /// 
    /// </summary>
    LeftBracket,
    /// <summary>
    /// 
    /// </summary>
    LeftCircularArrow,
    /// <summary>
    /// 
    /// </summary>
    LeftRightArrow,
    /// <summary>
    /// 
    /// </summary>
    LeftRightArrowCallout,
    /// <summary>
    /// 
    /// </summary>
    LeftRightCircularArrow,
    /// <summary>
    /// 
    /// </summary>
    LeftRightRibbon,
    /// <summary>
    /// 
    /// </summary>
    LeftRightUpArrow,
    /// <summary>
    /// 
    /// </summary>
    LeftUpArrow,
    /// <summary>
    /// 
    /// </summary>
    LightningBolt,
    /// <summary>
    /// 
    /// </summary>
    Line,
    /// <summary>
    /// 
    /// </summary>
    LineInv,

    /// <summary>
    /// 
    /// </summary>
    MathDivide,
    /// <summary>
    /// 
    /// </summary>
    MathEqual,

    /// <summary>
    /// 
    /// </summary>
    MathMinus,

    /// <summary>
    /// /
    /// </summary>
    MathMultiply,
    /// <summary>
    /// 
    /// </summary>
    MathNotEqual,
    /// <summary>
    /// 
    /// </summary>
    MathPlus,
    /// <summary>
    /// /
    /// </summary>
    Moon,
    /// <summary>
    /// 
    /// </summary>
    NonIsoscelesTrapezoid,
    /// <summary>
    /// 
    /// </summary>
    NoSmoking,
    /// <summary>
    /// 
    /// </summary>
    NotchedRightArrow,
    /// <summary>
    /// 
    /// </summary>
    Octagon,

    /// <summary>
    /// 
    /// </summary>
    Parallelogram,
    /// <summary>
    /// 
    /// </summary>
    Pentagon,
    /// <summary>
    /// 
    /// </summary>
    Pie,
    /// <summary>
    /// 
    /// </summary>
    PieWedge,
    /// <summary>
    /// 
    /// </summary>
    Plaque,
    /// <summary>
    /// 
    /// </summary>
    PlaqueTabs,

    /// <summary>
    /// 
    /// </summary>
    Plus,
    /// <summary>
    /// 
    /// </summary>
    QuadArrow,
    /// <summary>
    /// 
    /// </summary>
    QuadArrowCallout,
    /// <summary>
    /// 
    /// </summary>
    Rect,
    /// <summary>
    /// 
    /// </summary>
    Ribbon,

    /// <summary>
    /// 
    /// </summary>
    Ribbon2,

    /// <summary>
    /// 
    /// </summary>
    RightArrow,

    /// <summary>
    /// 
    /// </summary>
    RightArrowCallout,

    /// <summary>
    /// 
    /// </summary>
    RightBrace,

    /// <summary>
    /// 
    /// </summary>
    RightBracket,

    /// <summary>
    /// 
    /// </summary>
    Round1Rect,
    /// <summary>
    /// 
    /// </summary>
    Round2DiagRect,

    /// <summary>
    /// 
    /// </summary>
    Round2SameRect,

    /// <summary>
    /// 
    /// </summary>
    RoundRect,
    /// <summary>
    /// 
    /// </summary>
    RtTriangle,
    /// <summary>
    /// 
    /// </summary>
    SmileyFace,
    /// <summary>
    /// 
    /// </summary>
    Snip1Rect,
    /// <summary>
    /// 
    /// </summary>
    Snip2DiagRect,
    /// <summary>
    /// 
    /// </summary>
    Snip2SameRect,
    /// <summary>
    /// 
    /// </summary>
    SnipRoundRect,
    /// <summary>
    /// 
    /// </summary>
    SquareTabs,
    /// <summary>
    /// 
    /// </summary>
    Star10,

    /// <summary>
    /// 
    /// </summary>
    Star12,

    /// <summary>
    /// 
    /// </summary>
    Star16,
    /// <summary>
    /// 
    /// </summary>
    Star24,
    /// <summary>
    /// 
    /// </summary>
    Star32,

    /// <summary>
    /// 
    /// </summary>
    Star4,

    /// <summary>
    /// 
    /// </summary>
    Star5,
    /// <summary>
    /// 
    /// </summary>
    Star6,
    /// <summary>
    /// 
    /// </summary>
    Star7,
    /// <summary>
    /// 
    /// </summary>
    Star8,
    /// <summary>
    /// 
    /// </summary>
    StraightConnector1,

    /// <summary>
    /// 
    /// </summary>
    StripedRightArrow,
    /// <summary>
    /// 
    /// </summary>
    Sun,
    /// <summary>
    /// 
    /// </summary>
    SwooshArrow,
    /// <summary>
    /// 
    /// </summary>
    Teardrop,

    /// <summary>
    /// 
    /// </summary>
    Trapezoid,

    /// <summary>
    /// 
    /// </summary>
    Triangle,

    /// <summary>
    /// 
    /// </summary>
    UpArrow,
    /// <summary>
    /// 
    /// </summary>
    UpArrowCallout,

    /// <summary>
    /// 
    /// </summary>
    UpDownArrow,

    /// <summary>
    /// 
    /// </summary>
    UpDownArrowCallout,

    /// <summary>
    /// 
    /// </summary>
    UturnArrow,

    /// <summary>
    /// 
    /// </summary>
    Wave,
    /// <summary>
    /// /
    /// </summary>
    WedgeEllipseCallout,

    /// <summary>
    /// 
    /// </summary>
    WedgeRectCallout,

    /// <summary>
    /// 
    /// </summary>
    WedgeRoundRectCallout,

    /// <summary>
    /// 
    /// </summary>
    VerticalScroll
}
/// <summary>
/// 
/// </summary>
public enum eTextAlignment
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
    Right,
    /// <summary>
    /// /
    /// </summary>
    Distributed,
    /// <summary>
    /// 
    /// </summary>
    Justified,
    /// <summary>
    /// 
    /// </summary>
    JustifiedLow,
    /// <summary>
    /// 
    /// </summary>
    ThaiDistributed
}
/// <summary>
/// Fillstyle.
/// </summary>
public enum eFillStyle
{
    /// <summary>
    /// 
    /// </summary>
    NoFill,
    /// <summary>
    /// 
    /// </summary>
    SolidFill,
    /// <summary>
    /// 
    /// </summary>
    GradientFill,
    /// <summary>
    /// 
    /// </summary>
    PatternFill,

    /// <summary>
    /// 
    /// </summary>
    BlipFill,
    /// <summary>
    /// 
    /// </summary>
    GroupFill
}
namespace OfficeOpenXml.Drawing
{
    /// <summary>
    /// An Excel shape.
    /// </summary>
    public sealed class ExcelShape : ExcelDrawing
    {
        internal ExcelShape(ExcelDrawings drawings, XmlNode node) :
            base(drawings, node, "xdr:sp/xdr:nvSpPr/xdr:cNvPr/@name")
        {

        }
        internal ExcelShape(ExcelDrawings drawings, XmlNode node, eShapeStyle style) :
            base(drawings, node, "xdr:sp/xdr:nvSpPr/xdr:cNvPr/@name")
        {
            SchemaNodeOrder = new string[] { "prstGeom", "ln" };
            XmlElement shapeNode = node.OwnerDocument.CreateElement("xdr", "sp", ExcelPackage.schemaSheetDrawings);
            shapeNode.SetAttribute("macro", "");
            shapeNode.SetAttribute("textlink", "");
            node.AppendChild(shapeNode);

            shapeNode.InnerXml = ShapeStartXml();
            node.AppendChild(shapeNode.OwnerDocument.CreateElement("xdr", "clientData", ExcelPackage.schemaSheetDrawings));
        }
        #region "public methods"
        const string ShapeStylePath = "xdr:sp/xdr:spPr/a:prstGeom/@prst";
        /// <summary>
        /// Shape style
        /// </summary>
        public eShapeStyle Style
        {
            get
            {
                string v = GetXmlNodeString(ShapeStylePath);
                try
                {
                    return (eShapeStyle)Enum.Parse(typeof(eShapeStyle), v, true);
                }
                catch
                {
                    throw (new Exception(string.Format("Invalid shapetype {0}", v)));
                }
            }
            set
            {
                string v = value.ToString();
                v = v.Substring(0, 1).ToLower() + v.Substring(1, v.Length - 1);
                SetXmlNodeString(ShapeStylePath, v);
            }
        }
        ExcelDrawingFill _fill = null;
        /// <summary>
        /// Fill
        /// </summary>
        public ExcelDrawingFill Fill
        {
            get
            {
                if (_fill == null)
                {
                    _fill = new ExcelDrawingFill(NameSpaceManager, TopNode, "xdr:sp/xdr:spPr");
                }
                return _fill;
            }
        }
        ExcelDrawingBorder _border = null;
        /// <summary>
        /// Border
        /// </summary>
        public ExcelDrawingBorder Border        
        {
            get
            {
                if (_border == null)
                {
                    _border = new ExcelDrawingBorder(NameSpaceManager, TopNode, "xdr:sp/xdr:spPr/a:ln");
                }
                return _border;
            }
        }
        string[] paragraphNodeOrder = new string[] { "pPr", "defRPr", "solidFill", "uFill", "latin", "cs", "r", "rPr", "t" };
        const string PARAGRAPH_PATH = "xdr:sp/xdr:txBody/a:p";
        ExcelTextFont _font=null;
        /// <summary>
        /// 
        /// </summary>
        public ExcelTextFont Font
        {
            get
            {
                if (_font == null)
                {
                    XmlNode node = TopNode.SelectSingleNode(PARAGRAPH_PATH, NameSpaceManager);
                    if(node==null)
                    {
                        Text="";    //Creates the node p element
                        node = TopNode.SelectSingleNode(PARAGRAPH_PATH, NameSpaceManager);
                    }
                    _font = new ExcelTextFont(NameSpaceManager, TopNode, "xdr:sp/xdr:txBody/a:p/a:pPr/a:defRPr", paragraphNodeOrder);
                }
                return _font;
            }
        }
        const string TextPath = "xdr:sp/xdr:txBody/a:p/a:r/a:t";
        /// <summary>
        /// Text inside the shape
        /// </summary>
        public string Text
        {
            get
            {
                return GetXmlNodeString(TextPath);
            }
            set
            {
                SetXmlNodeString(TextPath, value);
            }

        }
        string lockTextPath = "xdr:sp/@fLocksText";
        /// <summary>
        /// Lock drawing
        /// </summary>
        public bool LockText
        {
            get
            {
                return GetXmlNodeBool(lockTextPath, true);
            }
            set
            {
                SetXmlNodeBool(lockTextPath, value);
            }
        }
        ExcelParagraphCollection _richText = null;
        /// <summary>
        /// Richtext collection. Used to format specific parts of the text
        /// </summary>
        public ExcelParagraphCollection RichText
        {
            get
            {
                if (_richText == null)
                {
                    //XmlNode node=TopNode.SelectSingleNode(PARAGRAPH_PATH, NameSpaceManager);
                    //if (node == null)
                    //{
                    //    CreateNode(PARAGRAPH_PATH);
                    //}
                        _richText = new ExcelParagraphCollection(NameSpaceManager, TopNode, PARAGRAPH_PATH, paragraphNodeOrder);
                }
                return _richText;
            }
        }
        const string TextAnchoringPath = "xdr:sp/xdr:txBody/a:bodyPr/@anchor";
        /// <summary>
        /// Text Anchoring
        /// </summary>
        public eTextAnchoringType TextAnchoring
        {
            get
            {
                return GetTextAchoringEnum(GetXmlNodeString(TextAnchoringPath));
            }
            set
            {
                SetXmlNodeString(TextAnchoringPath, GetTextAchoringText(value));
            }
        }
        const string TextAnchoringCtlPath = "xdr:sp/xdr:txBody/a:bodyPr/@anchorCtr";
        /// <summary>
        /// Specifies the centering of the text box.
        /// </summary>
        public bool TextAnchoringControl
        {
            get
            {
                return GetXmlNodeBool(TextAnchoringCtlPath);
            }
            set
            {
                if (value)
                {
                    SetXmlNodeString(TextAnchoringCtlPath, "1");
                }
                else
                {
                    SetXmlNodeString(TextAnchoringCtlPath, "0");
                }
            }
        }
        const string TEXT_ALIGN_PATH = "xdr:sp/xdr:txBody/a:p/a:pPr/@algn";
        /// <summary>
        /// How the text is aligned
        /// </summary>
        public eTextAlignment TextAlignment
        {
            get
            {
               switch(GetXmlNodeString(TEXT_ALIGN_PATH))
               {
                   case "ctr":
                       return eTextAlignment.Center;
                   case "r":
                       return eTextAlignment.Right;
                   case "dist":
                       return eTextAlignment.Distributed;
                   case "just":
                       return eTextAlignment.Justified;
                   case "justLow":
                       return eTextAlignment.JustifiedLow;
                   case "thaiDist":
                       return eTextAlignment.ThaiDistributed;
                   default: 
                       return eTextAlignment.Left;
               }
            }
            set
            {
                switch (value)
                {
                    case eTextAlignment.Right:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "r");
                        break;
                    case eTextAlignment.Center:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "ctr");
                        break;
                    case eTextAlignment.Distributed:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "dist");
                        break;
                    case eTextAlignment.Justified:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "just");
                        break;
                    case eTextAlignment.JustifiedLow:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "justLow");
                        break;
                    case eTextAlignment.ThaiDistributed:
                        SetXmlNodeString(TEXT_ALIGN_PATH, "thaiDist");
                        break;
                    default:
                        DeleteNode(TEXT_ALIGN_PATH);
                        break;
                }                
            }
        }
        const string INDENT_ALIGN_PATH = "xdr:sp/xdr:txBody/a:p/a:pPr/@lvl";
        /// <summary>
        /// Indentation
        /// </summary>
        public int Indent
        {
            get
            {
                return GetXmlNodeInt(INDENT_ALIGN_PATH);
            }
            set
            {
                if (value < 0 || value > 8)
                {
                    throw(new ArgumentOutOfRangeException("Indent level must be between 0 and 8"));
                }
                SetXmlNodeString(INDENT_ALIGN_PATH, value.ToString());
            }
        }
        const string TextVerticalPath = "xdr:sp/xdr:txBody/a:bodyPr/@vert";
        /// <summary>
        /// Vertical text
        /// </summary>
        public eTextVerticalType TextVertical
        {
            get
            {
                return GetTextVerticalEnum(GetXmlNodeString(TextVerticalPath));
            }
            set
            {
                SetXmlNodeString(TextVerticalPath, GetTextVerticalText(value));
            }
        }
        #endregion
        #region "Private Methods"
        private string ShapeStartXml()
        {
            StringBuilder xml = new StringBuilder();
            xml.AppendFormat("<xdr:nvSpPr><xdr:cNvPr id=\"{0}\" name=\"{1}\" /><xdr:cNvSpPr /></xdr:nvSpPr><xdr:spPr><a:prstGeom prst=\"rect\"><a:avLst /></a:prstGeom></xdr:spPr><xdr:style><a:lnRef idx=\"2\"><a:schemeClr val=\"accent1\"><a:shade val=\"50000\" /></a:schemeClr></a:lnRef><a:fillRef idx=\"1\"><a:schemeClr val=\"accent1\" /></a:fillRef><a:effectRef idx=\"0\"><a:schemeClr val=\"accent1\" /></a:effectRef><a:fontRef idx=\"minor\"><a:schemeClr val=\"lt1\" /></a:fontRef></xdr:style><xdr:txBody><a:bodyPr vertOverflow=\"clip\" rtlCol=\"0\" anchor=\"ctr\" /><a:lstStyle /><a:p></a:p></xdr:txBody>", _id, Name);
            return xml.ToString();
        }
        private string GetTextAchoringText(eTextAnchoringType value)
        {
            switch (value)
            {
                case eTextAnchoringType.Bottom:
                    return "b";
                case eTextAnchoringType.Center:
                    return "ctr";
                case eTextAnchoringType.Distributed:
                    return "dist";
                case eTextAnchoringType.Justify:
                    return "just";
                default:
                    return "t";
            }
        }
        private string GetTextVerticalText(eTextVerticalType value)
        {
            switch (value)
            {
                case eTextVerticalType.EastAsianVertical:
                    return "eaVert";
                case eTextVerticalType.MongolianVertical:
                    return "mongolianVert";
                case eTextVerticalType.Vertical:
                    return "vert";
                case eTextVerticalType.Vertical270:
                    return "vert270";
                case eTextVerticalType.WordArtVertical:
                    return "wordArtVert";
                case eTextVerticalType.WordArtVerticalRightToLeft:
                    return "wordArtVertRtl";
                default:
                    return "horz";
            }
        }
        private eTextVerticalType GetTextVerticalEnum(string text)
        {
            switch (text)
            {
                case "eaVert":
                    return eTextVerticalType.EastAsianVertical;
                case "mongolianVert":
                    return eTextVerticalType.MongolianVertical;
                case "vert":
                    return eTextVerticalType.Vertical;
                case "vert270":
                    return eTextVerticalType.Vertical270;
                case "wordArtVert":
                    return eTextVerticalType.WordArtVertical;
                case "wordArtVertRtl":
                    return eTextVerticalType.WordArtVerticalRightToLeft;
                default:
                    return eTextVerticalType.Horizontal;
            }
        }
        private eTextAnchoringType GetTextAchoringEnum(string text)
        {
            switch (text)
            {
                case "b":
                    return eTextAnchoringType.Bottom;
                case "ctr":
                    return eTextAnchoringType.Center;
                case "dist":
                    return eTextAnchoringType.Distributed;
                case "just":
                    return eTextAnchoringType.Justify;
                default:
                    return eTextAnchoringType.Top;
            }
        }
        #endregion
        internal new string Id
        {
            get { return Name + Text; }
        }
    }
}
