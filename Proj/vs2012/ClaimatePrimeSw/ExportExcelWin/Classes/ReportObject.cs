using ExportExcelWin.SecuredFolder.BaseClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Xml.Linq;

namespace ExportExcelWin.Classes
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class ReportObject : BaseClass
    {
        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public string Name { get;  set; }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ReportObject()
        {
        }

        # endregion
    }
}
