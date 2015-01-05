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
 * Parts of the interface of this file comes from the Excelpackage project. http://www.codeplex.com/ExcelPackage
 *
 *  Code change notes:
 * 
 * Author							Change						Date
 * ******************************************************************************
 * Jan K�llman		                Initial Release		        2009-10-01
 *******************************************************************************/
using System;
using System.Xml;
using System.IO;
using System.IO.Packaging;
using System.Collections.Generic;
using System.Text;
using System.Security;
using System.Globalization;
using System.Text.RegularExpressions;

namespace OfficeOpenXml
{
	#region Public Enum ExcelCalcMode
	/// <summary>
	/// When the application should calculate formulas in the workbook
	/// </summary>
	public enum ExcelCalcMode
	{
		/// <summary>
		/// Indicates that calculations in the workbook are performed automatically when cell values change. 
		/// The application recalculates those cells that are dependent on other cells that contain changed values. 
		/// This mode of calculation helps to avoid unnecessary calculations.
		/// </summary>
		Automatic,
		/// <summary>
		/// Indicates tables be excluded during automatic calculation
		/// </summary>
		AutomaticNoTable,
		/// <summary>
		/// Indicates that calculations in the workbook be triggered manually by the user. 
		/// </summary>
		Manual
	}
	#endregion

	/// <summary>
	/// Represents the Excel workbook    and provides access to all the 
	/// document properties and worksheets within the workbook.
	/// </summary>
	public sealed class ExcelWorkbook : XmlHelper
	{
		internal class SharedStringItem
		{
			internal int pos;
			internal string Text;
			internal bool isRichText = false;
		}
		#region Private Properties
		internal ExcelPackage _package;
		private ExcelWorksheets _worksheets;
		private OfficeProperties _properties;

		private ExcelStyles _styles;
		#endregion

		#region ExcelWorkbook Constructor
		/// <summary>
		/// Creates a new instance of the ExcelWorkbook class.  For internal use only!
		/// </summary>
		/// <param name="xlPackage">The parent package</param>
		/// <param name="namespaceManager">NamespaceManager</param>
		internal ExcelWorkbook(ExcelPackage xlPackage, XmlNamespaceManager namespaceManager) :
			base(namespaceManager)
		{
			_package = xlPackage;
			WorkbookUri = new Uri("/xl/workbook.xml", UriKind.Relative);
			SharedStringsUri = new Uri("/xl/sharedStrings.xml", UriKind.Relative);
			StylesUri = new Uri("/xl/styles.xml", UriKind.Relative);

			_names = new ExcelNamedRangeCollection(this);
			_namespaceManager = namespaceManager;
			TopNode = WorkbookXml.DocumentElement;
			SchemaNodeOrder = new string[] { "fileVersion", "fileSharing", "workbookPr", "workbookProtection", "bookViews", "sheets", "functionGroups", "functionPrototypes", "externalReferences", "definedNames", "calcPr", "oleSize", "customWorkbookViews", "pivotCaches", "smartTagPr", "smartTagTypes", "webPublishing", "fileRecoveryPr", };
			GetSharedStrings();
		}
		#endregion

		internal Dictionary<string, SharedStringItem> _sharedStrings = new Dictionary<string, SharedStringItem>(); //Used when reading cells.
		internal List<SharedStringItem> _sharedStringsList = new List<SharedStringItem>(); //Used when reading cells.
		internal ExcelNamedRangeCollection _names;
		internal int _nextDrawingID = 0;
		internal int _nextTableID = 1;
		internal int _nextPivotTableID = 1;
		internal XmlNamespaceManager _namespaceManager;
		/// <summary>
		/// Read shared strings to list
		/// </summary>
		private void GetSharedStrings()
		{
			if (_package.Package.PartExists(SharedStringsUri))
			{
				var xml = _package.GetXmlFromUri(SharedStringsUri);
				XmlNodeList nl = xml.SelectNodes("//d:sst/d:si", NameSpaceManager);
				_sharedStringsList = new List<SharedStringItem>();
				if (nl != null)
				{
					foreach (XmlNode node in nl)
					{
						XmlNode n = node.SelectSingleNode("d:t", NameSpaceManager);
						if (n != null)
						{
							_sharedStringsList.Add(new SharedStringItem() { Text = ExcelDecodeString(n.InnerText) });
						}
						else
						{
							_sharedStringsList.Add(new SharedStringItem() { Text = node.InnerXml, isRichText = true });
						}
					}
				}
			}
		}
		internal void GetDefinedNames()
		{
			XmlNodeList nl = WorkbookXml.SelectNodes("//d:definedNames/d:definedName", NameSpaceManager);
			if (nl != null)
			{
				foreach (XmlElement elem in nl)
				{ 
					string fullAddress = elem.InnerText;

					int localSheetID;
					ExcelWorksheet nameWorksheet;
					if(!int.TryParse(elem.GetAttribute("localSheetId"), out localSheetID))
					{
						localSheetID = -1;
						nameWorksheet=null;
					}
					else
					{
						nameWorksheet=Worksheets[localSheetID + 1];
					}
					var addressType = ExcelAddressBase.IsValid(fullAddress);
					ExcelRangeBase range;
					ExcelNamedRange namedRange;

					if (fullAddress.IndexOf("[") > -1)
					{
						int start = fullAddress.IndexOf("[");
						int end = fullAddress.IndexOf("]", start);
						if (start >= 0 && end >= 0)
						{

							string externalIndex = fullAddress.Substring(start + 1, end - start - 1);
							int index;
							if (int.TryParse(externalIndex, out index))
							{
								if (index > 0 && index <= _externalReferences.Count)
								{
									fullAddress = fullAddress.Substring(0, start) + "[" + _externalReferences[index - 1] + "]" + fullAddress.Substring(end + 1);
								}
							}
						}
					}

					if (addressType == ExcelAddressBase.AddressType.Invalid || addressType == ExcelAddressBase.AddressType.InternalName || addressType == ExcelAddressBase.AddressType.ExternalName)    //A value or a formula
					{
						double value;
						range = new ExcelRangeBase(this, nameWorksheet, elem.GetAttribute("name"), true);
						if (nameWorksheet == null)
						{
							namedRange = _names.Add(elem.GetAttribute("name"), range);
						}
						else
						{
							namedRange = nameWorksheet.Names.Add(elem.GetAttribute("name"), range);
						}
						
						if (fullAddress.StartsWith("\"")) //String value
						{
							namedRange.NameValue = fullAddress.Substring(1,fullAddress.Length-2);
						}
						else if (double.TryParse(fullAddress, NumberStyles.Any, CultureInfo.InvariantCulture, out value))
						{
							namedRange.NameValue = value;
						}
						else
						{
							namedRange.NameFormula = fullAddress;
						}
					}
					else
					{
						ExcelAddress addr = new ExcelAddress(fullAddress);
						if (localSheetID > -1)
						{
							if (string.IsNullOrEmpty(addr._ws))
							{
								namedRange = Worksheets[localSheetID + 1].Names.Add(elem.GetAttribute("name"), new ExcelRangeBase(this, Worksheets[localSheetID + 1], fullAddress, false));
							}
							else
							{
								namedRange = Worksheets[localSheetID + 1].Names.Add(elem.GetAttribute("name"), new ExcelRangeBase(this, Worksheets[addr._ws], fullAddress, false));
							}
						}
						else
						{
							var ws = Worksheets[addr._ws];
							namedRange = _names.Add(elem.GetAttribute("name"), new ExcelRangeBase(this, ws, fullAddress, false));
						}
					}
					if (elem.GetAttribute("hidden") == "1" && namedRange != null) namedRange.IsNameHidden = true;
					if(!string.IsNullOrEmpty(elem.GetAttribute("comment"))) namedRange.NameComment=elem.GetAttribute("comment");
				}
			}
		}
		#region Worksheets
		/// <summary>
		/// Provides access to all the worksheets in the workbook.
		/// </summary>
		public ExcelWorksheets Worksheets
		{
			get
			{
				if (_worksheets == null)
				{
					var sheetsNode = _xmlWorkbook.DocumentElement.SelectSingleNode("d:sheets", _namespaceManager);
					if (sheetsNode == null)
					{
						sheetsNode = CreateNode("d:sheets");
					}
					
					_worksheets = new ExcelWorksheets(_package, _namespaceManager, sheetsNode);
				}
				return (_worksheets);
			}
		}
		#endregion

		/// <summary>
		/// Provides access to named ranges
		/// </summary>
		public ExcelNamedRangeCollection Names
		{
			get
			{
				return _names;
			}
		}
		#region Workbook Properties
		decimal _standardFontWidth = decimal.MinValue;
		/// <summary>
		/// Max font width for the workbook
		/// </summary>
		public decimal MaxFontWidth 
		{
			get
			{
				if (_standardFontWidth == decimal.MinValue)
				{
					var font = Styles.Fonts[0];
					System.Drawing.Font f = new System.Drawing.Font(font.Name, font.Size);
					_standardFontWidth=(decimal)(System.Windows.Forms.TextRenderer.MeasureText("00", f).Width - System.Windows.Forms.TextRenderer.MeasureText("0", f).Width);
				}
				return _standardFontWidth;
			}
		}
		ExcelProtection _protection = null;
		/// <summary>
		/// Access properties to protect or unprotect a workbook
		/// </summary>
		public ExcelProtection Protection
		{
			get
			{
				if (_protection == null)
				{
					_protection = new ExcelProtection(NameSpaceManager, TopNode, this);
					_protection.SchemaNodeOrder = SchemaNodeOrder;
				}
				return _protection;
			}
		}
		ExcelWorkbookView _view = null;
		/// <summary>
		/// Access to workbook view properties
		/// </summary>
		public ExcelWorkbookView View
		{
			get
			{
				if (_view == null)
				{
					_view = new ExcelWorkbookView(NameSpaceManager, TopNode, this);
				}
				return _view;
			}
		}
		/// <summary>
		/// The Uri to the workbook in the package
		/// </summary>
		internal Uri WorkbookUri { get; private set; }
		/// <summary>
		/// The Uri to the styles.xml in the package
		/// </summary>
		internal Uri StylesUri { get; private set; }
		/// <summary>
		/// The Uri to the shared strings file
		/// </summary>
		internal Uri SharedStringsUri { get; private set; }
		/// <summary>
		/// Returns a reference to the workbook's part within the package
		/// </summary>
		internal PackagePart Part { get { return (_package.Package.GetPart(WorkbookUri)); } }
		
		#region WorkbookXml
		private XmlDocument _xmlWorkbook;
		/// <summary>
		/// Provides access to the XML data representing the workbook in the package.
		/// </summary>
		public XmlDocument WorkbookXml
		{
			get
			{
				if (_xmlWorkbook == null)
				{
					CreateWorkbookXml(_namespaceManager);
				}
				return (_xmlWorkbook);
			}
		}
		/// <summary>
		/// Create or read the XML for the workbook.
		/// </summary>
		private void CreateWorkbookXml(XmlNamespaceManager namespaceManager)
		{
			if (_package.Package.PartExists(WorkbookUri))
				_xmlWorkbook = _package.GetXmlFromUri(WorkbookUri);
			else
			{
				// create a new workbook part and add to the package
				PackagePart partWorkbook = _package.Package.CreatePart(WorkbookUri, @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml", _package.Compression);

				// create the workbook
				_xmlWorkbook = new XmlDocument(namespaceManager.NameTable);                
				
				_xmlWorkbook.PreserveWhitespace = ExcelPackage.preserveWhitespace;
				// create the workbook element
				XmlElement wbElem = _xmlWorkbook.CreateElement("workbook", ExcelPackage.schemaMain);

				// Add the relationships namespace
				wbElem.SetAttribute("xmlns:r", ExcelPackage.schemaRelationships);

				_xmlWorkbook.AppendChild(wbElem);

				// create the bookViews and workbooks element
				XmlElement bookViews = _xmlWorkbook.CreateElement("bookViews", ExcelPackage.schemaMain);
				wbElem.AppendChild(bookViews);
				XmlElement workbookView = _xmlWorkbook.CreateElement("workbookView", ExcelPackage.schemaMain);
				bookViews.AppendChild(workbookView);

				// save it to the package
				StreamWriter stream = new StreamWriter(partWorkbook.GetStream(FileMode.Create, FileAccess.Write));
				_xmlWorkbook.Save(stream);
				stream.Close();
				_package.Package.Flush();
			}
		}
		#endregion
		#region StylesXml
		private XmlDocument _xmlStyles;
		/// <summary>
		/// Provides access to the XML data representing the styles in the package. 
		/// </summary>
		public XmlDocument StylesXml
		{
			get
			{
				if (_xmlStyles == null)
				{
					if (_package.Package.PartExists(StylesUri))
						_xmlStyles = _package.GetXmlFromUri(StylesUri);
					else
					{
						// create a new styles part and add to the package
						PackagePart part = _package.Package.CreatePart(StylesUri, @"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml", _package.Compression);
						// create the style sheet

						StringBuilder xml = new StringBuilder("<styleSheet xmlns:d=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">");
						xml.Append("<d:numFmts />");
						xml.Append("<d:fonts count=\"1\"><d:font><d:sz val=\"11\" /><d:name val=\"Calibri\" /></d:font></d:fonts>");
						xml.Append("<d:fills><d:fill><d:patternFill patternType=\"none\" /></d:fill><d:fill><d:patternFill d4p1:d=\"gray125\" xmlns:d4p1=\"patternType\" /></d:fill></d:fills>");
						xml.Append("<d:borders><d:border><d:left /><d:right /><d:top /><d:bottom /><d:diagonal /></d:border></d:borders>");
						xml.Append("<d:cellStyleXfs count=\"1\"><d:xf numFmtId=\"0\" fontId=\"0\" /></d:cellStyleXfs>");
						xml.Append("<d:cellXfs count=\"1\"><d:xf numFmtId=\"0\" fontId=\"0\" xfId=\"0\" /></d:cellXfs>");
						xml.Append("<d:cellStyles><d:cellStyle name=\"Normal\" xfId=\"0\" builtinId=\"0\" /></d:cellStyles>");
						xml.Append("</styleSheet>");
						
						_xmlStyles = new XmlDocument();
						_xmlStyles.LoadXml(xml.ToString());
						
						//Save it to the package
						StreamWriter stream = new StreamWriter(part.GetStream(FileMode.Create, FileAccess.Write));

						_xmlStyles.Save(stream);
						stream.Close();
						_package.Package.Flush();

						// create the relationship between the workbook and the new shared strings part
						_package.Workbook.Part.CreateRelationship(PackUriHelper.GetRelativeUri(WorkbookUri, StylesUri), TargetMode.Internal, ExcelPackage.schemaRelationships + "/styles");
						_package.Package.Flush();
					}
				}
				return (_xmlStyles);
			}
			set
			{
				_xmlStyles = value;
			}
		}
		/// <summary>
		/// Package styles collection. Used internally to access style data.
		/// </summary>
		public ExcelStyles Styles
		{
			get
			{
				if (_styles == null)
				{
					_styles = new ExcelStyles(NameSpaceManager, StylesXml, this);
				}
				return _styles;
			}
		}
		#endregion

		#region Office Document Properties
		/// <summary>
		/// The office document properties
		/// </summary>
		public OfficeProperties Properties
		{
			get 
			{
				if (_properties == null)
				{
					//  Create a NamespaceManager to handle the default namespace, 
					//  and create a prefix for the default namespace:                   
					_properties = new OfficeProperties(_package, NameSpaceManager);
				}
				return _properties;
			}
		}
		#endregion

		#region CalcMode
		private string CALC_MODE_PATH = "d:calcPr/@calcMode";
		/// <summary>
		/// Calculation mode for the workbook.
		/// </summary>
		public ExcelCalcMode CalcMode
		{
			get
			{
				string calcMode = GetXmlNodeString(CALC_MODE_PATH);
				switch (calcMode)
				{
					case "autoNoTable":
						return ExcelCalcMode.AutomaticNoTable;
					case "manual":
						return ExcelCalcMode.Manual;
					default:
						return ExcelCalcMode.Automatic;

				}
			}
			set
			{
				switch (value)
				{
					case ExcelCalcMode.AutomaticNoTable:
						SetXmlNodeString(CALC_MODE_PATH, "autoNoTable") ;
						break;
					case ExcelCalcMode.Manual:
						SetXmlNodeString(CALC_MODE_PATH, "manual");
						break;
					default:
						SetXmlNodeString(CALC_MODE_PATH, "auto");
						break;

				}
			}
			#endregion
		}
		#endregion

		#region Workbook Private Methods
			
		#region Save // Workbook Save
		/// <summary>
		/// Saves the workbook and all its components to the package.
		/// For internal use only!
		/// </summary>
		internal void Save()  // Workbook Save
		{
			if (Worksheets.Count == 0)
				throw new InvalidOperationException("The workbook must contain at least one worksheet");

			DeleteCalcChain();
			
			UpdateDefinedNamesXml();

			// save the workbook
			if (_xmlWorkbook != null)
			{
				_package.SavePart(WorkbookUri, _xmlWorkbook);
			}

			// save the properties of the workbook
			if (_properties != null)
			{
				_properties.Save();
			}

			// save the style sheet
			Styles.UpdateXml();
			_package.SavePart(StylesUri, _xmlStyles);

			// save all the open worksheets
			var isProtected = Protection.LockWindows || Protection.LockStructure;
			foreach (ExcelWorksheet worksheet in Worksheets)
			{
				if (isProtected && Protection.LockWindows)
				{
					worksheet.View.WindowProtection = true;
				}
				worksheet.Save();
			}
			
			UpdateSharedStringsXml();
			
			// Data validation
			ValidateDataValidations();
		}

		private void DeleteCalcChain()
		{
			//Remove the calc chain if it exists.
			Uri uriCalcChain = new Uri("/xl/calcChain.xml", UriKind.Relative);
			if (_package.Package.PartExists(uriCalcChain))
			{
				Uri calcChain = new Uri("calcChain.xml", UriKind.Relative);
				foreach (PackageRelationship relationship in _package.Workbook.Part.GetRelationships())
				{
					if (relationship.TargetUri == calcChain)
					{
						_package.Workbook.Part.DeleteRelationship(relationship.Id);
						break;
					}
				}
				// delete the calcChain part
				_package.Package.DeletePart(uriCalcChain);
			}
		}

		private void ValidateDataValidations()
		{
			foreach (var sheet in _package.Workbook.Worksheets)
			{
				sheet.DataValidations.ValidateAll();
			}
		}

		private void UpdateSharedStringsXml()
		{
			PackagePart stringPart;
			if (_package.Package.PartExists(SharedStringsUri))
			{
				stringPart=_package.Package.GetPart(SharedStringsUri);
			}
			else
			{
				stringPart = _package.Package.CreatePart(SharedStringsUri, @"application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml", _package.Compression);
				Part.CreateRelationship(PackUriHelper.GetRelativeUri(WorkbookUri, SharedStringsUri), TargetMode.Internal, ExcelPackage.schemaRelationships + "/sharedStrings");
			}

			StreamWriter sw = new StreamWriter(stringPart.GetStream(FileMode.Create, FileAccess.Write));
			sw.Write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?><sst xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" count=\"{0}\" uniqueCount=\"{0}\">", _sharedStrings.Count);
			foreach (string t in _sharedStrings.Keys)
			{

				SharedStringItem ssi = _sharedStrings[t];
				if (ssi.isRichText)
				{
					sw.Write("<si>");
					ExcelEncodeString(sw, t);
					sw.Write("</si>");
				}
				else
				{
					if (t.Length>0 && (t[0] == ' ' || t[t.Length-1] == ' ' || t.Contains("  ") || t.Contains("\t")))
					{
						sw.Write("<si><t xml:space=\"preserve\">");
					}
					else
					{
						sw.Write("<si><t>");
					}
					ExcelEncodeString(sw, SecurityElement.Escape(t));
					sw.Write("</t></si>");
				}
			}
			sw.Write("</sst>");
			sw.Flush();
		}

		/// <summary>
		/// Return true if preserve space attribute is set.
		/// </summary>
		/// <param name="sw"></param>
		/// <param name="t"></param>
		/// <returns></returns>
		private void ExcelEncodeString(StreamWriter sw, string t)
		{
			if(Regex.IsMatch(t, "(_x[0-9A-F]{4,4}_)"))
			{
				var match = Regex.Match(t, "(_x[0-9A-F]{4,4}_)");
				int indexAdd = 0;
				while (match.Success)
				{
					t=t.Insert(match.Index + indexAdd, "_x005F");
					indexAdd += 6;
					match = match.NextMatch();
				}
			}
			for (int i=0;i<t.Length;i++)
			{
				if (t[i] < 0x1f && t[i] != '\t' && t[i] != '\n' && t[i] != '\r') //Not Tab, CR or LF
				{
					sw.Write("_x00{0}_", (t[i] < 0xa ? "0" : "") + ((int)t[i]).ToString("X"));                    
				}
				else
				{
					sw.Write(t[i]);
				}
			}

		}
		private string ExcelDecodeString(string t)
		{
			var match = Regex.Match(t, "(_x005F|_x[0-9A-F]{4,4}_)");
			if(!match.Success) return t;

			bool useNextValue = false;
			StringBuilder ret=new StringBuilder();
			int prevIndex=0;
			while(match.Success)
			{
				if (prevIndex < match.Index) ret.Append(t.Substring(prevIndex, match.Index - prevIndex));
				if (!useNextValue && match.Value == "_x005F")
				{
					useNextValue = true;
				}
				else
				{
					if (useNextValue)
					{
						ret.Append(match.Value);
						useNextValue=false;
					}
					else
					{
						ret.Append((char)int.Parse(match.Value.Substring(2,4),NumberStyles.AllowHexSpecifier));
					}
				}
				prevIndex=match.Index+match.Length;
				match = match.NextMatch();
			}
			ret.Append(t.Substring(prevIndex, t.Length - prevIndex));
			return ret.ToString();
		}
		private void UpdateDefinedNamesXml()
		{
			try
			{
				XmlNode top = WorkbookXml.SelectSingleNode("//d:definedNames", NameSpaceManager);
				if (!ExistsNames())
				{
					if (top != null) TopNode.RemoveChild(top);
					return;
				}
				else
				{
					if (top == null)
					{
						CreateNode("d:definedNames");
						top = WorkbookXml.SelectSingleNode("//d:definedNames", NameSpaceManager);
					}
					else
					{
						top.RemoveAll();
					}
					foreach (ExcelNamedRange name in _names)
					{

						XmlElement elem = WorkbookXml.CreateElement("definedName", ExcelPackage.schemaMain);
						top.AppendChild(elem);
						elem.SetAttribute("name", name.Name);
						if (name.IsNameHidden) elem.SetAttribute("hidden", "1");
						if (!string.IsNullOrEmpty(name.NameComment)) elem.SetAttribute("comment", name.NameComment);
						SetNameElement(name, elem);
					}
				}
				foreach (ExcelWorksheet ws in _worksheets)
				{
					foreach (ExcelNamedRange name in ws.Names)
					{

						XmlElement elem = WorkbookXml.CreateElement("definedName", ExcelPackage.schemaMain);
						top.AppendChild(elem);
						elem.SetAttribute("name", name.Name);
						elem.SetAttribute("localSheetId", name.LocalSheetId.ToString());
						if (name.IsNameHidden) elem.SetAttribute("hidden", "1");
						if (!string.IsNullOrEmpty(name.NameComment)) elem.SetAttribute("comment", name.NameComment);
						SetNameElement(name, elem);
					}
				}
			}
			catch (Exception ex)
			{
				throw new Exception("Internal error updating named ranges ",ex);
			}
		}

		private void SetNameElement(ExcelNamedRange name, XmlElement elem)
		{
			if (name.IsName)
			{
				if (string.IsNullOrEmpty(name.NameFormula))
				{
					if ((name.NameValue.GetType().IsPrimitive || name.NameValue is double || name.NameValue is decimal))
					{
						elem.InnerText = Convert.ToDouble(name.NameValue, CultureInfo.InvariantCulture).ToString("g15", CultureInfo.InvariantCulture); 
					}
					else if (name.NameValue is DateTime)
					{
						elem.InnerText = ((DateTime)name.NameValue).ToOADate().ToString(CultureInfo.InvariantCulture);
					}
					else
					{
						elem.InnerText = "\"" + name.NameValue.ToString() + "\"";
					}                                
				}
				else
				{
					elem.InnerText = name.NameFormula;
				}
			}
			else
			{
				elem.InnerText = name.FullAddressAbsolute;
			}
		}
		/// <summary>
		/// Is their any names in the workbook or in the sheets.
		/// </summary>
		/// <returns>?</returns>
		private bool ExistsNames()
		{
			if (_names.Count == 0)
			{
				foreach (ExcelWorksheet ws in Worksheets)
				{
					if(ws.Names.Count>0)
					{
						return true;
					}
				}
			}
			else
			{
				return true;
			}
			return false;
		}        
		#endregion

		#endregion

		internal bool ExistsTableName(string Name)
		{
			foreach (var ws in Worksheets)
			{
				if(ws.Tables._tableNames.ContainsKey(Name))
				{
					return true;
				}
			}
			return false;
		}
		internal bool ExistsPivotTableName(string Name)
		{
			foreach (var ws in Worksheets)
			{
				if (ws.PivotTables._pivotTableNames.ContainsKey(Name))
				{
					return true;
				}
			}
			return false;
		}

		internal void AddPivotTable(string cacheID, Uri defUri)
		{
			CreateNode("d:pivotCaches");

			XmlElement item = WorkbookXml.CreateElement("pivotCache", ExcelPackage.schemaMain);
			item.SetAttribute("cacheId", cacheID);
			var rel = Part.CreateRelationship(PackUriHelper.ResolvePartUri(WorkbookUri, defUri), TargetMode.Internal, ExcelPackage.schemaRelationships + "/pivotCacheDefinition");
			item.SetAttribute("id", ExcelPackage.schemaRelationships, rel.Id);

			var pivotCaches = WorkbookXml.SelectSingleNode("//d:pivotCaches", NameSpaceManager);
			pivotCaches.AppendChild(item);
		}

		internal List<string> _externalReferences = new List<string>();
		internal void GetExternalReferences()
		{
			XmlNodeList nl = WorkbookXml.SelectNodes("//d:externalReferences/d:externalReference", NameSpaceManager);
			if (nl != null)
			{
				foreach (XmlElement elem in nl)
				{
					string rID = elem.GetAttribute("r:id");
					PackageRelationship rel = Part.GetRelationship(rID);
					var part = _package.Package.GetPart(PackUriHelper.ResolvePartUri(rel.SourceUri, rel.TargetUri));
					XmlDocument xmlExtRef = new XmlDocument();
					xmlExtRef.Load(part.GetStream());

					XmlElement book=xmlExtRef.SelectSingleNode("//d:externalBook", NameSpaceManager) as XmlElement;
					if(book!=null)
					{
						string rId_ExtRef = book.GetAttribute("r:id");
						var rel_extRef = part.GetRelationship(rId_ExtRef);
						if (rel_extRef != null)
						{
							_externalReferences.Add(rel_extRef.TargetUri.OriginalString);
						}

					}
				}
			}
		}
	} // end Workbook
}
