using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2400
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class SV1L2400 : Base5010
    {
        #region Properties

        /// <summary>
        /// SV101
        /// </summary>
        [ANSI5010Field(true, 0, int.MaxValue)]
        public string P001_CompositeMedicalProcedureIdentifier { protected get; set; }

        /// <summary>
        /// SV101-01 
        /// </summary>
        [ANSI5010Field(true, 2, 2, true)]
        public string P002_ProductServiceIDQualifier { protected get; set; }

        /// <summary>
        ///  SV101-02 
        /// </summary>
        [ANSI5010Field(true, 1, 48, true)]
        public string P003_ProductServiceID { protected get; set; }

        /// <summary>
        /// SV101 -03  

        /// </summary>
        [ANSI5010Field(false, 2, true)]
        public string P004_ProcedureModifier { protected get; set; }

        /// <summary>
        /// SV101-04
        /// </summary>
        [ANSI5010Field(false, 2, true)]
        public string P005_ProcedureModifier1 { protected get; set; }

        /// <summary>
        /// SV101-05 
        /// </summary>
        [ANSI5010Field(false, 2, true)]
        public string P006_ProcedureModifier2 { protected get; set; }

        /// <summary>
        /// SV101-06  
        /// </summary>
        [ANSI5010Field(false, 2, true)]
        public string P007_ProcedureModifier3 { protected get; set; }

        /// <summary>
        /// SV101-07  
        /// </summary>
        [ANSI5010Field(false, 1, 80, true)]
        public string P008_Description { protected get; set; }

        /// <summary>
        /// SV101-08  
        /// </summary>
        [ANSI5010Field(false, 1, 48, true)]
        public string P009_NOT_USED { protected get; set; }

        /// <summary>
        /// SV102
        /// </summary>
        [ANSI5010Field(true, 1, 18)]
        public string P010_MonetaryAmount { protected get; set; }

        /// <summary>
        /// SV103
        /// </summary>
        [ANSI5010Field(true, 2)]
        public string P011_UnitOrBasisforMeasurementCode { protected get; set; }

        /// <summary>
        /// SV104
        /// </summary>
        [ANSI5010Field(true, 1, 15)]
        public string P012_Quantity { protected get; set; }

        /// <summary>
        /// SV105
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P013_FacilityCodeValue { protected get; set; }

        /// <summary>
        /// SV106
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P014_NOT_USED1 { protected get; set; }

        /// <summary>
        /// SV107
        /// </summary>
        [ANSI5010Field(true, 0, int.MaxValue)]
        public string P015_CompositeDiagnosisCodePointer { protected get; set; }

        /// <summary>
        /// SV107-01 
        /// </summary>
        [ANSI5010Field(true, 1, 2, true)]
        public string P016_DiagnosisCodePointer { protected get; set; }

        /// <summary>
        /// SV107-02 
        /// </summary>
        [ANSI5010Field(false, 1, 2, true)]
        public string P017_DiagnosisCodePointer1 { protected get; set; }

        /// <summary>
        /// SV107-03 
        /// </summary>
        [ANSI5010Field(true, 1, 2, true)]
        public string P018_DiagnosisCodePointer2 { protected get; set; }

        /// <summary>
        /// SV107-04 
        /// </summary>
        [ANSI5010Field(false, 1, 2, true)]
        public string P019_DiagnosisCodePointer3 { protected get; set; }

        /// <summary>
        /// SV108
        /// </summary>
        [ANSI5010Field(false, 1, 18)]
        public string P020_NOT_USED2 { protected get; set; }

        /// <summary>
        /// SV109
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P021_YesNoConditionOrResponseCode { protected get; set; }

        /// <summary>
        /// SV110
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P022_NOT_USED3 { protected get; set; }

        /// <summary>
        /// SV111
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P023_YesNoConditionOrResponseCode1 { protected get; set; }

        /// <summary>
        /// SV112
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P024_YesNoConditionOrResponseCode2 { protected get; set; }

        /// <summary>
        /// SV113
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P025_NOT_USED4 { protected get; set; }

        /// <summary>
        /// SV114
        /// </summary>
        [ANSI5010Field(false, 1, 2)]
        public string P026_NOT_USED5 { protected get; set; }

        /// <summary>
        /// SV115
        /// </summary>
        [ANSI5010Field(false, 1)]
        public string P027_CopayStatusCode { protected get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// PROFESSIONAL SERVICE
        /// </summary>
        public SV1L2400(string pLoopChartRef)
            : base("SV1", "L2400: SERVICE CPT CODE", pLoopChartRef)
        {
        }

        # endregion
    }
}
