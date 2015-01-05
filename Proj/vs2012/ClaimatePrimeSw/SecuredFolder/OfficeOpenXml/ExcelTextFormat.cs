﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Globalization;

namespace OfficeOpenXml
{
    /// <summary>
    /// Discribes a column
    /// </summary>
    public enum eDataTypes
    {
        /// <summary>
        /// Let the the import decide.
        /// </summary>
        Unknown,
        /// <summary>
        /// Always a string.
        /// </summary>
        String,
        /// <summary>
        /// Try to convert it to a number. If it fails then add it as a string.
        /// </summary>
        Number,
        /// <summary>
        /// Try to convert it to a date. If it fails then add it as a string.
        /// </summary>
        DateTime,
        /// <summary>
        /// Try to convert it to a number and divide with 100. Removes any tailing percent sign (%). If it fails then add it as a string.
        /// </summary>
        Percent
    }
    /// <summary>
    /// Describes how to split a CSV text. Used by the ExcelRange.LoadFromText method
    /// </summary>
    public class ExcelTextFormat
    {
        /// <summary>
        /// Describes how to split a CSV text
        /// 
        /// Default values
        /// <list>
        /// <listheader><term>Property</term><description>Value</description></listheader>
        /// <item><term>Delimiter</term><description>,</description></item>
        /// <item><term>TextQualifier</term><description>None (\0)</description></item>
        /// <item><term>EOL</term><description>CRLF</description></item>
        /// <item><term>Culture</term><description>CultureInfo.InvariantCulture</description></item>
        /// <item><term>DataTypes</term><description>End of line default CRLF</description></item>
        /// <item><term>SkipLinesBeginning</term><description>0</description></item>
        /// <item><term>SkipLinesEnd</term><description>0</description></item>
        /// <item><term>Encoding</term><description>Encoding.ASCII</description></item>
        /// </list>
        /// </summary>
        public ExcelTextFormat()
        {
            Delimiter = ',';
            TextQualifier = '\0';
            EOL = "\r\n";
            Culture = CultureInfo.InvariantCulture;
            DataTypes=null;
            SkipLinesBeginning = 0;
            SkipLinesEnd = 0;
            Encoding=Encoding.ASCII;
        }
        /// <summary>
        /// Delimiter character
        /// </summary>
        public char Delimiter { get; set; }
        /// <summary>
        /// Text quualifier character 
        /// </summary>
        public char TextQualifier {get; set; }
        /// <summary>
        /// End of line characters. Default CRLF
        /// </summary>
        public string EOL { get; set; }
        /// <summary>
        /// Datatypes list for each column (if column is not present Unknown is assumed)
        /// </summary>
        public eDataTypes[] DataTypes { get; set; }
        /// <summary>
        /// Culture used when parsing.Default CultureInfo.InvariantCulture
        /// </summary>
        public CultureInfo Culture {get; set; }
        /// <summary>
        /// Number of lines skiped in the begining of the file. Default 0.
        /// </summary>
        public int SkipLinesBeginning { get; set; }
        /// <summary>
        /// Number of lines skiped at the end of the file. Default 0.
        /// </summary>
        public int SkipLinesEnd { get; set; }
        /// <summary>
        /// Only used when reading files from disk using a FileInfo object
        /// </summary>
        public Encoding Encoding { get; set; }
    }
}
