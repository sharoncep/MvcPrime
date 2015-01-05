using System;
using System.Runtime.Serialization;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.AjaxCalls
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class CurrDtTm
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_DAY
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_MONTH
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_YEAR
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_HOUR
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_MINUTE
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_SECOND
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int32 I_MILLISECOND
        {
            get;
            private set;
        }

        #endregion

        # region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static CurrDtTm Get()
        {
            DateTime dt = DateTime.Now.AddSeconds(StaticClass.SvrTimeSecDiff);

            return (new CurrDtTm()
            {
                I_DAY = dt.Day
                ,
                I_MONTH = dt.Month - 1
                ,
                I_YEAR = dt.Year
                ,
                I_HOUR = dt.Hour
                ,
                I_MINUTE = dt.Minute
                ,
                I_SECOND = dt.Second
                ,
                I_MILLISECOND = dt.Millisecond
            });
        }

        # endregion
    }
}
