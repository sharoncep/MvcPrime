using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ClaimatePrimeFnSp.Classes
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class TableObject
    {
        # region Private Variables

        private List<string> _AuditTables;
        private string _TABLE_NAME;
        
        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public string TABLE_SCHEMA
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string TABLE_NAME
        {
            get
            {
                return _TABLE_NAME;
            }
            set
            {
                _TABLE_NAME = value;

                IsAudit = string.IsNullOrWhiteSpace((from oTbl in _AuditTables where string.Compare(_TABLE_NAME, oTbl, true) == 0 select oTbl).FirstOrDefault()) ? false : true;
            }
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string PkDataType
        {
            get;
            set;
        }

        /// <summary>
        /// Get
        /// </summary>
        public bool IsAudit
        {
            get;
            private set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<string> FnNames
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<string> SpNames
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<FieldObject> FieldObjects
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public TableObject()
        {
            _AuditTables = (new[] { "***** Common Functions *****", "ErrorLog", "LockUnLock", "LogInLogOut", "LogInTrial", "SyncStatus", "UserClinicSelect", "UserPassword", "UserReport", "UserRoleSelect", "WebCulture" }).ToList();

            _TABLE_NAME = string.Empty;
            PkDataType = string.Empty;
            FnNames = new List<string>();
            SpNames = new List<string>();
            FieldObjects = new List<FieldObject>();
        }

        # endregion
    }
}
