using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ANSI5010.SubClasses;
using ANSI5010.SubClasses.Loop1000A;
using ANSI5010.SubClasses.Loop1000B;
using ANSI5010.SubClasses.Loop2000A;
using ANSI5010.SubClasses.Loop2010AA;

namespace ANSI5010
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class GSDetail
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public GS P001_GS { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public ST P002_ST { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public BHT P003_BHT { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L1000A P004_NM1L1000A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PERL1000A P005_PERL1000A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L1000B P006_NM1L1000B { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public HLL2000A P007_HLL2000A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PRVL2000A P008_PRVL2000A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public CURL2000A P009_CURL2000A { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public NM1L2010AA P010_NM1L2010AA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N3L2010AA P011_N3L2010AA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public N4L2010AA P012_N4L2010AA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010AA P013_REFL2010AA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public REFL2010AA1 P014_REFL2010AA1 { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public PERL2010AA P015_PERL2010AA { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<SubPatDetail> P016_SubPatDetails { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public SE P017_SE { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public GE P018_GE { get; set; }

        #endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public GSDetail()
        {
            P001_GS = new GS();
            P002_ST = new ST();
            P003_BHT = new BHT();
            P004_NM1L1000A = new NM1L1000A();
            P005_PERL1000A = new PERL1000A();
            P006_NM1L1000B = new NM1L1000B();
            P007_HLL2000A = new HLL2000A();
            P008_PRVL2000A = new PRVL2000A();
            P009_CURL2000A = new CURL2000A();
            P010_NM1L2010AA = new NM1L2010AA();
            P011_N3L2010AA = new N3L2010AA();
            P012_N4L2010AA = new N4L2010AA();

            P013_REFL2010AA = new REFL2010AA();
            P014_REFL2010AA1 = new REFL2010AA1();


            P015_PERL2010AA = new PERL2010AA();
            P016_SubPatDetails = new List<SubPatDetail>();
            P017_SE = new SE();
            P018_GE = new GE();
        }

        # endregion
    }
}
