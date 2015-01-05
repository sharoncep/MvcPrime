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
    public class FieldObject
    {
        # region Private Variables

        private List<string> _AuditFields;
        private string _COLUMN_NAME;

        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 ORDINAL_POSITION
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string COLUMN_NAME
        {
            get
            {
                return _COLUMN_NAME;
            }
            set
            {
                _COLUMN_NAME = value;

                IsAudit = string.IsNullOrWhiteSpace((from oTbl in _AuditFields where string.Compare(_COLUMN_NAME, oTbl, true) == 0 select oTbl).FirstOrDefault()) ? false : true;
            }
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
        public string DATA_TYPE
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public Int32 CHARACTER_MAXIMUM_LENGTH
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public bool IS_NULLABLE
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public string COLUMN_DEFAULT
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pTableName"></param>
        public FieldObject(string pTableName)
        {
            _AuditFields = (new[] { string.Concat(pTableName, "ID"), "CreatedBy", "CreatedOn", "LastModifiedBy", "LastModifiedOn", "IsActive" }).ToList();

            ORDINAL_POSITION = 0;
            COLUMN_NAME = string.Empty;
            IsAudit = false;
            DATA_TYPE = string.Empty;
            CHARACTER_MAXIMUM_LENGTH = 0;
            IS_NULLABLE = false;
            COLUMN_DEFAULT = string.Empty;
        }

        # endregion
    }
}
