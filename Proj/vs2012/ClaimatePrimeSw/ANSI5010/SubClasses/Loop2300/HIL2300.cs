using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses.Loop2010AA;
using ANSI5010.SecuredFolder.BaseClasses;
using ANSI5010.SecuredFolder.Extensions;

namespace ANSI5010.SubClasses.Loop2300
{
    /// <summary>
    /// 
    /// </summary>
    [ANSI5010Loop(true)]
    public class HIL2300 : Base5010
    {
        #region Properties

        #region one

        /// <summary>
        /// HI01
        /// </summary>
        [ANSI5010Field(true, 0, 0)]
        public string P001_HealthCareCodeInformation { protected get; set; }

        /// <summary>
        ///  HI01 -01  
        /// </summary>
        [ANSI5010Field(true, 1, 3, true)]
        public string P002_CodeListQualifierCode { protected get; set; }

        /// <summary>
        /// HI01-02
        /// </summary>
        [ANSI5010Field(true, 1, 30, true)]
        public string P003_IndustryCode { protected get; set; }

        /// <summary>
        /// HI01-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P004_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P005_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P006_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P007_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P008_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P009_NOT_USED { protected get; set; }

        /// <summary>
        /// HI01-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P010_NOT_USED { protected get; set; } 

        #endregion

        #region TWO

        /// <summary>
        /// HI02
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P011_HealthCareCodeInformation1 { protected get; set; }

        /// <summary>
        /// HI02-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P012_CodeListQualifierCode1 { protected get; set; }

        /// <summary>
        /// HI02-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P013_IndustryCode1 { protected get; set; }

        /// <summary>
        /// HI02-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P014_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P015_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P016_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P017_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P018_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P019_NOT_USED { protected get; set; }

        /// <summary>
        /// HI02-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P020_NOT_USED { protected get; set; } 

        #endregion

        #region THREE
        /// <summary>
        /// HI03
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P021_HealthCareCodeInformation2 { protected get; set; }

        /// <summary>
        /// HI03-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P022_CodeListQualifierCode2 { protected get; set; }

        /// <summary>
        /// HI03-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P023_IndustryCode2 { protected get; set; }

        /// <summary>
        /// HI03-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P024_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P025_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P026_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P027_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P028_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P029_NOT_USED { protected get; set; }

        /// <summary>
        /// HI03-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P030_NOT_USED { protected get; set; } 
        #endregion

        #region FOUR
        /// <summary>
        /// HI04
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P031_HealthCareCodeInformation3 { protected get; set; }

        /// <summary>
        /// HI04-01
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P032_CodeListQualifierCode3 { protected get; set; }

        /// <summary>
        /// HI04-02
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P033_IndustryCode3 { protected get; set; }

        /// <summary>
        /// HI04-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P034_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P035_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P036_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P037_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P038_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P039_NOT_USED { protected get; set; }

        /// <summary>
        /// HI04-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P040_NOT_USED { protected get; set; } 
        #endregion

        #region FIVE
        /// <summary>
        /// HI05
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P041_HealthCareCodeInformation4 { protected get; set; }

        /// <summary>
        /// HI05-01
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P042_CodeListQualifierCode4 { protected get; set; }

        /// <summary>
        ///   HI05-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P043_IndustryCode4 { protected get; set; }

        /// <summary>
        /// HI05-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P044_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P045_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P046_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P047_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P048_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P049_NOT_USED { protected get; set; }

        /// <summary>
        /// HI05-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P050_NOT_USED46 { protected get; set; } 
        #endregion

        #region SIX
        /// <summary>
        /// HI06
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P051_HealthCareCodeInformation5 { protected get; set; }

        /// <summary>
        /// HI06-01
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P052_CodeListQualifierCode5 { protected get; set; }

        /// <summary>
        /// HI06-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P053_IndustryCode5 { protected get; set; }

        /// <summary>
        /// HI06-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P054_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P055_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P056_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P057_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P058_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P059_NOT_USED { protected get; set; }

        /// <summary>
        /// HI06-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P060_NOT_USED { protected get; set; } 
        #endregion

        #region SEVEN
        /// <summary>
        /// HI07
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P061_HealthCareCodeInformation6 { protected get; set; }

        /// <summary>
        /// HI07-01
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P062_CodeListQualifierCode6 { protected get; set; }

        /// <summary>
        /// HI07-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P063_IndustryCode6 { protected get; set; }

        /// <summary>
        /// HI07-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P064_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P065_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P066_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P067_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P068_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P069_NOT_USED { protected get; set; }

        /// <summary>
        /// HI07-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P070_NOT_USED { protected get; set; } 
        #endregion

        #region EIGHT
        /// <summary>
        /// HI08
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P071_HealthCareCodeInformation7 { protected get; set; }

        /// <summary>
        /// HI08-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P072_CodeListQualifierCode7 { protected get; set; }

        /// <summary>
        /// HI08-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P073_IndustryCode7 { protected get; set; }

        /// <summary>
        /// HI08-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P074_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P075_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P076_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P077_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P078_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P079_NOT_USED { protected get; set; }

        /// <summary>
        /// HI08-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P080_NOT_USED { protected get; set; }
        #endregion

        #region NINE
        /// <summary>
        /// HI09
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P081_HealthCareCodeInformation8 { protected get; set; }

        /// <summary>
        /// HI09-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P082_CodeListQualifierCode8 { protected get; set; }

        /// <summary>
        /// HI09-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P083_IndustryCode8 { protected get; set; }

        /// <summary>
        /// HI09-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P084_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P085_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P086_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P087_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P088_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P089_NOT_USED { protected get; set; }

        /// <summary>
        /// HI09-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P090_NOT_USED { protected get; set; }
        #endregion

        #region TEN
        /// <summary>
        /// HI10
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P091_HealthCareCodeInformation9 { protected get; set; }

        /// <summary>
        /// HI10-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P092_CodeListQualifierCode9 { protected get; set; }

        /// <summary>
        /// HI10-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P093_IndustryCode9 { protected get; set; }

        /// <summary>
        /// HI10-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P094_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P095_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P096_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P097_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P098_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P099_NOT_USED { protected get; set; }

        /// <summary>
        /// HI10-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P100_NOT_USED { protected get; set; }
        #endregion

        #region ELEVEN
        /// <summary>
        /// HI11
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P101_HealthCareCodeInformation10 { protected get; set; }

        /// <summary>
        /// HI11-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P102_CodeListQualifierCode10 { protected get; set; }

        /// <summary>
        /// HI11-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P103_IndustryCode10 { protected get; set; }

        /// <summary>
        /// HI11-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P104_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P105_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P106_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P107_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P108_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P109_NOT_USED { protected get; set; }

        /// <summary>
        /// HI11-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P110_NOT_USED { protected get; set; }
        #endregion

        #region TWELVE
        /// <summary>
        /// HI12
        /// </summary>
        [ANSI5010Field(false, 0, 0)]
        public string P111_HealthCareCodeInformation11 { protected get; set; }

        /// <summary>
        /// HI12-01 
        /// </summary>
        [ANSI5010Field(false, 1, 3, true)]
        public string P112_CodeListQualifierCode11 { protected get; set; }

        /// <summary>
        /// HI12-02 
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P113_IndustryCode11 { protected get; set; }

        /// <summary>
        /// HI12-03
        /// </summary>
        [ANSI5010Field(false, 2, 3, true)]
        public string P114_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-04
        /// </summary>
        [ANSI5010Field(false, 1, 35, true)]
        public string P115_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-05
        /// </summary>
        [ANSI5010Field(false, 1, 18, true)]
        public string P116_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-06
        /// </summary>
        [ANSI5010Field(false, 1, 15, true)]
        public string P117_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-07
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P118_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-08
        /// </summary>
        [ANSI5010Field(false, 1, 30, true)]
        public string P119_NOT_USED { protected get; set; }

        /// <summary>
        /// HI12-09
        /// </summary>
        [ANSI5010Field(false, 1, true)]
        public string P120_NOT_USED { protected get; set; }
        #endregion

        #endregion

        # region Constructors

        /// <summary>
        /// HEALTH CARE DIAGNOSIS CODE
        /// </summary>
        public HIL2300(string pLoopChartRef)
            : base("HI", "L2300: HEALTH CARE DX", pLoopChartRef)
        {
        }


        # endregion
    }
}
