using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClaimatePrimeModels.SecuredFolder.Reports
{
    # region ExcelSheetData

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ExcelSheetDataOLD
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 SN
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CLINIC_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PROVIDER_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.DateTime DOS
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 CASE_NO
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String INSURANCE_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PATIENT_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CHART_NO
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String POLICY_NO
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CLAIM_STATUS
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DxOLD PRIMARY_DX
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<DxOLD> Dxs
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ExcelSheetDataOLD()
        {
            PRIMARY_DX = new DxOLD();
            Dxs = new List<DxOLD>();
        }

        # endregion
    }

    # endregion

    # region DxCpt

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public abstract class DxCptOLD
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int64 SN
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CODE
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String SHORT_DESC
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String MEDIUM_DESC
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String LONG_DESC
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CUSTOM_DESC
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public DxCptOLD()
        {
        }

        # endregion
    }

    # endregion

    # region Dx

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class DxOLD : DxCptOLD
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<CptOLD> Cpts
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int16 ICD_FORMAT
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String DG_CODE
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String DG_DESC
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public DxOLD()
        {
            Cpts = new List<CptOLD>();
        }

        # endregion
    }

    # endregion

    # region Cpt

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class CptOLD : DxCptOLD
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FACILITY_TYPE_CODE
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FACILITY_TYPE_NAME
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int32 UNIT
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Decimal CHARGE_PER_UNIT
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<ModifierOLD> Modifiers
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public CptOLD()
        {
            Modifiers = new List<ModifierOLD>();
        }

        # endregion
    }

    # endregion

    # region Modifier

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ModifierOLD
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ModifierCode
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ModifierName
        {
            get;
            set;
        }

        # endregion

        # region Constructor

        /// <summary>
        /// 
        /// </summary>
        public ModifierOLD()
        {
        }

        # endregion
    }

    # endregion
}
