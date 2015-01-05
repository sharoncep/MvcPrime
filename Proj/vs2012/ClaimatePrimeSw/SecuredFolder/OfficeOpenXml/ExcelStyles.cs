/* 
 * You may amend and distribute as you like, but don't remove this header!
 * 
 * EPPlus provides server-side generation of Excel 2007 spreadsheets.
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
 * Jan K�llman		                Initial Release		        2009-10-01
 *******************************************************************************/
using System;
using System.Xml;
using System.Collections.Generic;
using draw=System.Drawing;
using OfficeOpenXml.Style;
using OfficeOpenXml.Style.XmlAccess;
namespace OfficeOpenXml
{
	/// <summary>
	/// Containts all shared cell styles for a workbook
	/// </summary>
    public sealed class ExcelStyles : XmlHelper
    {
        const string NumberFormatsPath = "d:styleSheet/d:numFmts";
        const string FontsPath = "d:styleSheet/d:fonts";
        const string FillsPath = "d:styleSheet/d:fills";
        const string BordersPath = "d:styleSheet/d:borders";
        const string CellStyleXfsPath = "d:styleSheet/d:cellStyleXfs";
        const string CellXfsPath = "d:styleSheet/d:cellXfs";
        const string CellStylesPath = "d:styleSheet/d:cellStyles";

        //internal Dictionary<int, ExcelXfs> Styles = new Dictionary<int, ExcelXfs>();
        XmlDocument _styleXml;
        ExcelWorkbook _wb;
        XmlNamespaceManager _nameSpaceManager;
        internal ExcelStyles(XmlNamespaceManager NameSpaceManager, XmlDocument xml, ExcelWorkbook wb) :
            base(NameSpaceManager, xml)
        {       
            _styleXml=xml;
            _wb = wb;
            _nameSpaceManager = NameSpaceManager;
            LoadFromDocument();
        }
        /// <summary>
        /// Loads the style XML to memory
        /// </summary>
        private void LoadFromDocument()
        {
            //NumberFormats
            ExcelNumberFormatXml.AddBuildIn(NameSpaceManager, NumberFormats);
            XmlNode numNode = _styleXml.SelectSingleNode(NumberFormatsPath, _nameSpaceManager);
            if (numNode != null)
            {
                foreach (XmlNode n in numNode)
                {
                    ExcelNumberFormatXml nf = new ExcelNumberFormatXml(_nameSpaceManager, n);
                    NumberFormats.Add(nf.Id, nf);
                    if (nf.NumFmtId >= NumberFormats.NextId) NumberFormats.NextId=nf.NumFmtId+1;
                }
            }

            //Fonts
            XmlNode fontNode = _styleXml.SelectSingleNode(FontsPath, _nameSpaceManager);
            foreach (XmlNode n in fontNode)
            {
                ExcelFontXml f = new ExcelFontXml(_nameSpaceManager, n);
                Fonts.Add(f.Id, f);
            }

            //Fills
            XmlNode fillNode = _styleXml.SelectSingleNode(FillsPath, _nameSpaceManager);
            foreach (XmlNode n in fillNode)
            {
                ExcelFillXml f;
                if (n.FirstChild != null && n.FirstChild.LocalName == "gradientFill")
                {
                    f = new ExcelGradientFillXml(_nameSpaceManager, n);
                }
                else
                {
                    f = new ExcelFillXml(_nameSpaceManager, n);
                }
                Fills.Add(f.Id, f);
            }

            //Borders
            XmlNode borderNode = _styleXml.SelectSingleNode(BordersPath, _nameSpaceManager);
            foreach (XmlNode n in borderNode)
            {
                ExcelBorderXml b = new ExcelBorderXml(_nameSpaceManager, n);
                Borders.Add(b.Id, b);
            }

            //cellStyleXfs
            XmlNode styleXfsNode = _styleXml.SelectSingleNode(CellStyleXfsPath, _nameSpaceManager);
            foreach (XmlNode n in styleXfsNode)
            {
                ExcelXfs item = new ExcelXfs(_nameSpaceManager, n, this);
                CellStyleXfs.Add(item.Id, item);
            }

            XmlNode styleNode = _styleXml.SelectSingleNode(CellXfsPath, _nameSpaceManager);
            for (int i = 0; i < styleNode.ChildNodes.Count; i++)
            {
                XmlNode n = styleNode.ChildNodes[i];
                ExcelXfs item = new ExcelXfs(_nameSpaceManager, n, this);
                CellXfs.Add(item.Id, item);
            }

            //cellStyle
            XmlNode namedStyleNode = _styleXml.SelectSingleNode(CellStylesPath, _nameSpaceManager);
            foreach (XmlNode n in namedStyleNode)
            {
                ExcelNamedStyleXml item = new ExcelNamedStyleXml(_nameSpaceManager, n, this);
                NamedStyles.Add(item.Name, item);
            }
        }
        internal ExcelStyle GetStyleObject(int Id,int PositionID, string Address)
        {
            if (Id < 0) Id = 0;
            return new ExcelStyle(this, PropertyChange, PositionID, Address, Id);
        }
        /// <summary>
        /// Handels changes of properties on the style objects
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <returns></returns>
        internal int PropertyChange(StyleBase sender, Style.StyleChangeEventArgs e)
        {
            var address = new ExcelAddressBase(e.Address);
            var ws = _wb.Worksheets[e.PositionID];
            Dictionary<int, int> styleCashe = new Dictionary<int, int>();
            //Set single address
            SetStyleAddress(sender, e, address, ws, ref styleCashe);
            if (address.Addresses != null)
            {
                //Handle multiaddresses
                foreach (var innerAddress in address.Addresses)
                {
                    SetStyleAddress(sender, e, innerAddress, ws, ref styleCashe);
                }
            }
            return 0;
        }

        private void SetStyleAddress(StyleBase sender, Style.StyleChangeEventArgs e, ExcelAddressBase address, ExcelWorksheet ws, ref Dictionary<int, int> styleCashe)
        {
            if (address.Start.Column == 0 || address.Start.Row == 0)
            {
                throw (new Exception("error address"));
            }
            //Columns
            else if (address.Start.Row == 1 && address.End.Row == ExcelPackage.MaxRows)
            {
                ExcelColumn column;
                //Get the startcolumn
                ulong colID = ExcelColumn.GetColumnID(ws.SheetID, address.Start.Column);
                if (!ws._columns.ContainsKey(colID))
                {
                    column=ws.Column(address.Start.Column);
                }
                else
                {
                    column = ws._columns[colID] as ExcelColumn;
                }

                var index = ws._columns.IndexOf(colID);
                while(column.ColumnMin <= address.End.Column)
                {
                    if (column.ColumnMax > address.End.Column)
                    {
                        var newCol=ws.CopyColumn(column, address.End.Column+1);
                        newCol.ColumnMax = column.ColumnMax;
                        column.ColumnMax = address.End.Column;
                    }

                    if (styleCashe.ContainsKey(column.StyleID))
                    {
                        column.StyleID = styleCashe[column.StyleID];
                    }
                    else
                    {
                        ExcelXfs st = CellXfs[column.StyleID];
                        int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                        styleCashe.Add(column.StyleID, newId);
                        column.StyleID = newId;
                    }

                    index++;
                    if (index >= ws._columns.Count)
                    {
                        break;
                    }
                    else
                    {
                        column = (ws._columns[index] as ExcelColumn);
                    }
                }

                if (column._columnMax < address.End.Column)
                {
                    var newCol = ws.Column(column._columnMax + 1) as ExcelColumn;
                    newCol._columnMax = address.End.Column;

                    if (styleCashe.ContainsKey(newCol.StyleID))
                    {
                        newCol.StyleID = styleCashe[newCol.StyleID];
                    }
                    else
                    {
                        ExcelXfs st = CellXfs[column.StyleID];
                        int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                        styleCashe.Add(newCol.StyleID, newId);
                        newCol.StyleID = newId;
                    }
                    
                    //column._columnMax = address.End.Column;
                }

                //Set for individual cells in the spann. We loop all cells here since the cells are sorted with columns first.
                foreach (ExcelCell cell in ws._cells)
                {
                    if (cell.Column >= address.Start.Column &&
                       cell.Column <= address.End.Column)
                    {
                        if (styleCashe.ContainsKey(cell.StyleID))
                        {
                            cell.StyleID = styleCashe[cell.StyleID];
                        }
                        else
                        {
                            ExcelXfs st = CellXfs[cell.StyleID];
                            int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                            styleCashe.Add(cell.StyleID, newId);
                            cell.StyleID = newId;
                        }
                    }

                }
            }
            //Rows
            else if(address.Start.Column==1 && address.End.Column==ExcelPackage.MaxColumns)
            {
                for (int rowNum = address.Start.Row; rowNum <= address.End.Row; rowNum++)
                {
                    ExcelRow row = ws.Row(rowNum);
                    if (row.StyleID == 0 && ws._columns.Count > 0)
                    {
                        //TODO: We should loop all columns here and change each cell. But for now we take style of column A.
                        foreach (ExcelColumn column in ws._columns)
                        {
                            row.StyleID = column.StyleID;
                            break;  //Get the first one and break. 
                        }

                    }
                    if (styleCashe.ContainsKey(row.StyleID))
                    {
                        row.StyleID = styleCashe[row.StyleID];
                    }
                    else
                    {
                        ExcelXfs st = CellXfs[row.StyleID];
                        int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                        styleCashe.Add(row.StyleID, newId);
                        row.StyleID = newId;
                    }
                }

                //Get Start Cell
                ulong rowID = ExcelRow.GetRowID(ws.SheetID, address.Start.Row);
                int index = ws._cells.IndexOf(rowID);

                index = ~index;
                while (index < ws._cells.Count)
                {                        
                    var cell = ws._cells[index] as ExcelCell;
                    if(cell.Row > address.End.Row)
                    {
                        break;
                    }
                    if (styleCashe.ContainsKey(cell.StyleID))
                    {
                        cell.StyleID = styleCashe[cell.StyleID];
                    }
                    else
                    {
                        ExcelXfs st = CellXfs[cell.StyleID];
                        int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                        styleCashe.Add(cell.StyleID, newId);
                        cell.StyleID = newId;
                    }
                    index++;
                }
            }
            else             //Cellrange
            {
                for (int col = address.Start.Column; col <= address.End.Column; col++)
                {
                    for (int row = address.Start.Row; row <= address.End.Row; row++)
                    {
                        ExcelCell cell = ws.Cell(row, col);
                        if (styleCashe.ContainsKey(cell.StyleID))
                        {
                            cell.StyleID = styleCashe[cell.StyleID];
                        }
                        else
                        {
                            ExcelXfs st = CellXfs[cell.StyleID];
                            int newId = st.GetNewID(CellXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                            styleCashe.Add(cell.StyleID, newId);
                            cell.StyleID = newId;
                        }
                    }
                }            
            }
        }
        /// <summary>
        /// Handles property changes on Named styles.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// <returns></returns>
        internal int NamedStylePropertyChange(StyleBase sender, Style.StyleChangeEventArgs e)
        {

            int index = NamedStyles.FindIndexByID(e.Address);
            if (index >= 0)
            {
                int newId = CellStyleXfs[NamedStyles[index].StyleXfId].GetNewID(CellStyleXfs, sender, e.StyleClass, e.StyleProperty, e.Value);
                NamedStyles[index].StyleXfId = newId;
                NamedStyles[index].Style.Index = newId;

                NamedStyles[index].XfId = int.MinValue;
            }
            return 0;
        }
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelNumberFormatXml> NumberFormats = new ExcelStyleCollection<ExcelNumberFormatXml>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelFontXml> Fonts = new ExcelStyleCollection<ExcelFontXml>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelFillXml> Fills = new ExcelStyleCollection<ExcelFillXml>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelBorderXml> Borders = new ExcelStyleCollection<ExcelBorderXml>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelXfs> CellStyleXfs = new ExcelStyleCollection<ExcelXfs>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelXfs> CellXfs = new ExcelStyleCollection<ExcelXfs>();
        /// <summary>
        /// 
        /// </summary>
        public ExcelStyleCollection<ExcelNamedStyleXml> NamedStyles = new ExcelStyleCollection<ExcelNamedStyleXml>();
        
        internal string Id
        {
            get { return ""; }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public ExcelNamedStyleXml CreateNamedStyle(string name)
        {
            return CreateNamedStyle(name, null);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="Template"></param>
        /// <returns></returns>
        public ExcelNamedStyleXml CreateNamedStyle(string name, ExcelStyle Template)
        {
            if (_wb.Styles.NamedStyles.ExistsKey(name))
            {
                throw new Exception(string.Format("Key {0} already exist in collection", name));
            }

            ExcelNamedStyleXml style;
            style = new ExcelNamedStyleXml(NameSpaceManager, this);
            if (Template == null)
            {
                style.Style = new ExcelStyle(this, NamedStylePropertyChange, -1, name, 0);
            }
            else
            {
                if (Template.PositionID < 0 && Template.Styles==this)
                {
                    style.Style = new ExcelStyle(this, NamedStylePropertyChange, Template.PositionID, name, Template.Index);
                    style.StyleXfId = Template.Index;
                }
                else
                {
                    int xfid=CloneStyle(Template.Styles, Template.XfId, true);
                    style.Style = new ExcelStyle(this, NamedStylePropertyChange, -1, name, xfid);
                    style.StyleXfId = xfid;
                    
                }
            }
            
            style.Name = name;
            int ix =_wb.Styles.NamedStyles.Add(style.Name, style);
            style.Style.SetIndex(ix);
            //style.Style.XfId = ix;
            return style;
        }
        /// <summary>
        /// 
        /// </summary>
        public void UpdateXml()
        {
            RemoveUnusedStyles();

            //NumberFormat
            XmlNode nfNode=_styleXml.SelectSingleNode(NumberFormatsPath, _nameSpaceManager);
            if (nfNode == null)
            {
                CreateNode(NumberFormatsPath, true);
                nfNode = _styleXml.SelectSingleNode(NumberFormatsPath, _nameSpaceManager);
            }
            else
            {
                nfNode.RemoveAll();                
            }

            int count = 0;
            foreach (ExcelNumberFormatXml nf in NumberFormats)
            {
                if(!nf.BuildIn) //Buildin formats are not updated.
                {
                    nfNode.AppendChild(nf.CreateXmlNode(_styleXml.CreateElement("numFmt", ExcelPackage.schemaMain)));
                    nf.newID = count;
                    count++;
                }
            }
            (nfNode as XmlElement).SetAttribute("count", count.ToString());

            //Font
            count=0;
            XmlNode fntNode = _styleXml.SelectSingleNode(FontsPath, _nameSpaceManager);
            fntNode.RemoveAll();
            foreach (ExcelFontXml fnt in Fonts)
            {
                if (fnt.useCnt > 0)
                {
                    fntNode.AppendChild(fnt.CreateXmlNode(_styleXml.CreateElement("font", ExcelPackage.schemaMain)));
                    fnt.newID = count;
                    count++;
                }
            }
            (fntNode as XmlElement).SetAttribute("count", count.ToString());


            //Fills
            count = 0;
            XmlNode fillsNode = _styleXml.SelectSingleNode(FillsPath, _nameSpaceManager);
            fillsNode.RemoveAll();
            Fills[0].useCnt = 1;    //Must exist (none);  
            Fills[1].useCnt = 1;    //Must exist (gray125);
            foreach (ExcelFillXml fill in Fills)
            {
                if (fill.useCnt > 0)
                {
                    fillsNode.AppendChild(fill.CreateXmlNode(_styleXml.CreateElement("fill", ExcelPackage.schemaMain)));
                    fill.newID = count;
                    count++;
                }
            }
            (fillsNode as XmlElement).SetAttribute("count", count.ToString());

            //Borders
            count = 0;
            XmlNode bordersNode = _styleXml.SelectSingleNode(BordersPath, _nameSpaceManager);
            bordersNode.RemoveAll();
            Borders[0].useCnt = 1;    //Must exist blank;
            foreach (ExcelBorderXml border in Borders)
            {
                if (border.useCnt > 0)
                {
                    bordersNode.AppendChild(border.CreateXmlNode(_styleXml.CreateElement("border", ExcelPackage.schemaMain)));
                    border.newID = count;
                    count++;
                }
            }
            (bordersNode as XmlElement).SetAttribute("count", count.ToString());

            count = 0;
            XmlNode styleXfsNode = _styleXml.SelectSingleNode(CellStyleXfsPath, _nameSpaceManager);
            styleXfsNode.RemoveAll();
            foreach (ExcelXfs styleXfs in CellStyleXfs)
            {
                if (styleXfs.useCnt > 0)
                {
                    styleXfsNode.AppendChild(styleXfs.CreateXmlNode(_styleXml.CreateElement("xf", ExcelPackage.schemaMain)));
                    styleXfs.newID = count;                 
                    count++;
                }
            }
            (styleXfsNode as XmlElement).SetAttribute("count", count.ToString());

            //NamedStyles
            count = 0;
            XmlNode cellStyleNode = _styleXml.SelectSingleNode(CellStylesPath, _nameSpaceManager);
            cellStyleNode.RemoveAll();
            foreach (ExcelNamedStyleXml style in NamedStyles)
            {
                cellStyleNode.AppendChild(style.CreateXmlNode(_styleXml.CreateElement("cellStyle", ExcelPackage.schemaMain)));
                style.newID = count;
                if (style.XfId >= 0) style.XfId = CellXfs[style.XfId].newID;
                count++;
            }
            (cellStyleNode as XmlElement).SetAttribute("count", count.ToString());


            //CellStyle
            count = 0;
            XmlNode cellXfsNode = _styleXml.SelectSingleNode(CellXfsPath, _nameSpaceManager);
            cellXfsNode.RemoveAll();
            foreach (ExcelXfs xf in CellXfs)
            {
                if (xf.useCnt > 0)
                {
                    cellXfsNode.AppendChild(xf.CreateXmlNode(_styleXml.CreateElement("xf", ExcelPackage.schemaMain)));
                    xf.newID = count;
                    count++;
                }
            }
            (cellXfsNode as XmlElement).SetAttribute("count", count.ToString());
        }

        private void RemoveUnusedStyles()
        {
            CellXfs[0].useCnt = 1; //First item is allways used.
            foreach (ExcelWorksheet sheet in _wb.Worksheets)
            {
                foreach (ExcelCell cell in sheet._cells) //sheet._cells.Values
                {
                    CellXfs[cell.GetCellStyleID()].useCnt++;
                }
                foreach(ExcelRow row in sheet._rows)
                {
                    CellXfs[row.StyleID].useCnt++;
                }
                foreach (ExcelColumn col in sheet._columns)
                {
                    if(col.StyleID>=0) CellXfs[col.StyleID].useCnt++;
                }
            }
            foreach (ExcelNamedStyleXml ns in NamedStyles)
            {
                CellStyleXfs[ns.StyleXfId].useCnt++;
            }

            foreach (ExcelXfs xf in CellXfs)
            {
                if (xf.useCnt > 0)
                {
                    if (xf.FontId >= 0) Fonts[xf.FontId].useCnt++;
                    if (xf.FillId >= 0) Fills[xf.FillId].useCnt++;
                    if (xf.BorderId >= 0) Borders[xf.BorderId].useCnt++;
                }
            }
            foreach (ExcelXfs xf in CellStyleXfs)
            {
                if (xf.useCnt > 0)
                {
                    if (xf.FontId >= 0) Fonts[xf.FontId].useCnt++;
                    if (xf.FillId >= 0) Fills[xf.FillId].useCnt++;
                    if (xf.BorderId >= 0) Borders[xf.BorderId].useCnt++;                    
                }
            }
        }
        internal int GetStyleIdFromName(string Name)
        {
            int i = NamedStyles.FindIndexByID(Name);
            if (i >= 0)
            {
                int id = NamedStyles[i].XfId;
                if (id < 0)
                {
                    int styleXfId=NamedStyles[i].StyleXfId;
                    ExcelXfs newStyle = CellStyleXfs[styleXfId].Copy();
                    newStyle.XfId = styleXfId;
                    id = CellXfs.FindIndexByID(newStyle.Id);
                    if (id < 0)
                    {
                        id = CellXfs.Add(newStyle);
                    }
                    NamedStyles[i].XfId=id;
                }
                return id;
            }
            else
            {
                return 0;
                //throw(new Exception("Named style does not exist"));        	         
            }
        }
   #region XmlHelpFunctions
        private int GetXmlNodeInt(XmlNode node)
        {
            int i;
            if (int.TryParse(GetXmlNode(node), out i))
            {
                return i;
            }
            else
            {
                return 0;
            }
        }
        private string GetXmlNode(XmlNode node)
        {
            if (node == null)
            {
                return "";
            }
            if (node.Value != null)
            {
                return node.Value;
            }
            else
            {
                return "";
            }
        }

#endregion
        internal int CloneStyle(ExcelStyles style, int styleID)
        {
            return CloneStyle(style, styleID, false);
        }
        internal int CloneStyle(ExcelStyles style, int styleID, bool isNamedStyle)
        {
            ExcelXfs xfs;
            if (isNamedStyle)
            {
                xfs = style.CellStyleXfs[styleID];
            }
            else
            {
                xfs = style.CellXfs[styleID];
            }
            ExcelXfs newXfs=xfs.Copy(this);
            //Numberformat
            if (xfs.NumberFormatId > -1)
            {
                string format = xfs.Numberformat.Format;
                int ix=NumberFormats.FindIndexByID(format);
                if (ix<0)
                {
                    ExcelNumberFormatXml item = new ExcelNumberFormatXml(NameSpaceManager) { Format = format, NumFmtId = style.NumberFormats.NextId++ };
                    NumberFormats.Add(format, item);
                    ix=item.NumFmtId;
                }
                newXfs.NumberFormatId= ix;
            }

            //Font
            if (xfs.FontId > -1)
            {
                int ix=Fonts.FindIndexByID(xfs.Font.Id);
                if (ix<0)
                {
                    ExcelFontXml item = style.Fonts[xfs.FontId].Copy();
                    ix=Fonts.Add(xfs.Font.Id, item);
                }
                newXfs.FontId=ix;
            }

            //Border
            if (xfs.BorderId > -1)
            {
                int ix = Borders.FindIndexByID(xfs.Border.Id);
                if (ix < 0)
                {
                    ExcelBorderXml item = style.Borders[xfs.BorderId].Copy();
                    ix = Borders.Add(xfs.Border.Id, item);
                }
                newXfs.BorderId = ix;
            }

            //Fill
            if (xfs.FillId > -1)
            {
                int ix = Fills.FindIndexByID(xfs.Fill.Id);
                if (ix < 0)
                {
                    var item = style.Fills[xfs.FillId].Copy();
                    ix = Fills.Add(xfs.Fill.Id, item);
                }
                newXfs.FillId = ix;
            }

            int id;
            if (isNamedStyle)
            {
                id = CellStyleXfs.FindIndexByID(newXfs.Id);
                if (id < 0)
                {
                    id = CellStyleXfs.Add(newXfs.Id, newXfs);
                }
            }
            else
            {
                id = CellXfs.FindIndexByID(newXfs.Id);
                if (id < 0)
                {
                    id = CellXfs.Add(newXfs.Id, newXfs);
                }
            }
            return id;
        }
    }
}
