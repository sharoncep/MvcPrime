using System;
using System.Collections.Generic;
using ANSI5010.SubClasses.Loop2000B;
using ANSI5010.SubClasses.Loop2000C;
using ANSI5010.SubClasses.Loop2010BA;
using ANSI5010.SubClasses.Loop2010BB;
using ANSI5010.SubClasses.Loop2010CA;
using ANSI5010.SubClasses.Loop2300;
using ANSI5010.SubClasses.Loop2310A;
using ANSI5010.SubClasses.Loop2310B;
using ANSI5010.SubClasses.Loop2310C;
using ANSI5010.SubClasses.Loop2310D;
using ANSI5010.SubClasses.Loop2400;

namespace ANSI5010
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class SubPatDetail
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public HLL2000B P001_HLL2000B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public SBRL2000B P002_SBRL2000B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PATL2000B P003_PATL2000B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2010BA P004_NM1L2010BA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N3L2010BA P005_N3L2010BA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N4L2010BA P006_N4L2010BA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DMGL2010BA P007_DMGL2010BA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010BA P008_REFL2010BA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010BA1 P009_REFL2010BA1 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2010BB P010_NM1L2010BB { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N3L2010BB P011_N3L2010BB { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N4L2010BB P012_N4L2010BB { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010BB P013_REFL2010BB { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public HLL2000C P014_HLL2000C { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PATL2000C P015_PATL2000C { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2010CA P016_NM1L2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N3L2010CA P017_N3L2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N4L2010CA P018_N4L2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DMGL2010CA P019_DMGL2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010CA P020_REFL2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010CA1 P021_REFL2010CA1 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PERL2010CA P022_PERL2010CA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public CLML2300 P023_CLML2300 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DTP1L2300 P024_DTP1L2300 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DTP2L2300 P025_DTP2L2300 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public DTP3L2300 P026_DTP3L2300 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public HIL2300 P027_HIL2300 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2310A P028_NM1L2310A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2310A P029_REFL2310A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2310B P030_NM1L2310B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PRVL2310B P031_PRVL2310B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2310B P032_REFL2310B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2310C P033_NM1L2310C { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N3L2310C P034_N3L2310C { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N4L2310C P035_N4L2310C { get; set; }


        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2310D P036_NM1L2310D { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2310D P037_REFL2310D { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<CptService> P038_CptServices { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopChartRef"></param>
        public SubPatDetail(string pLoopChartRef)
        {
            P001_HLL2000B = new HLL2000B(pLoopChartRef);
            P002_SBRL2000B = new SBRL2000B(pLoopChartRef);
            P003_PATL2000B = new PATL2000B(pLoopChartRef);
            P004_NM1L2010BA = new NM1L2010BA(pLoopChartRef);
            P005_N3L2010BA = new N3L2010BA(pLoopChartRef);
            P006_N4L2010BA = new N4L2010BA(pLoopChartRef);
            P007_DMGL2010BA = new DMGL2010BA(pLoopChartRef);
            P008_REFL2010BA = new REFL2010BA(pLoopChartRef);
            P009_REFL2010BA1 = new REFL2010BA1(pLoopChartRef);
            P010_NM1L2010BB = new NM1L2010BB(pLoopChartRef);
            P011_N3L2010BB = new N3L2010BB(pLoopChartRef);
            P012_N4L2010BB = new N4L2010BB(pLoopChartRef);
            P013_REFL2010BB = new REFL2010BB(pLoopChartRef);
            P014_HLL2000C = new HLL2000C(pLoopChartRef);
            P015_PATL2000C = new PATL2000C(pLoopChartRef);
            P016_NM1L2010CA = new NM1L2010CA(pLoopChartRef);
            P017_N3L2010CA = new N3L2010CA(pLoopChartRef);
            P018_N4L2010CA = new N4L2010CA(pLoopChartRef);
            P019_DMGL2010CA = new DMGL2010CA(pLoopChartRef);
            P020_REFL2010CA = new REFL2010CA(pLoopChartRef);
            P021_REFL2010CA1 = new REFL2010CA1(pLoopChartRef);
            P022_PERL2010CA = new PERL2010CA(pLoopChartRef);
            P023_CLML2300 = new CLML2300(pLoopChartRef);
            P024_DTP1L2300 = new DTP1L2300(pLoopChartRef);
            P025_DTP2L2300 = new DTP2L2300(pLoopChartRef);
            P026_DTP3L2300 = new DTP3L2300(pLoopChartRef);
            P027_HIL2300 = new HIL2300(pLoopChartRef);
            P028_NM1L2310A = new NM1L2310A(pLoopChartRef);
            P029_REFL2310A = new REFL2310A(pLoopChartRef);
            P030_NM1L2310B = new NM1L2310B(pLoopChartRef);
            P031_PRVL2310B = new PRVL2310B(pLoopChartRef);
            P032_REFL2310B = new REFL2310B(pLoopChartRef);
            P033_NM1L2310C = new NM1L2310C(pLoopChartRef);
            P034_N3L2310C = new N3L2310C(pLoopChartRef);
            P035_N4L2310C = new N4L2310C(pLoopChartRef);
            P036_NM1L2310D = new NM1L2310D(pLoopChartRef);
            P037_REFL2310D = new REFL2310D(pLoopChartRef);
            P038_CptServices = new List<CptService>();
        }

        # endregion
    }
}
