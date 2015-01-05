using System;
using System.Diagnostics;

namespace ClaimatePrimeConstants
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public static class RunMode
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public static bool IsDebug
        {
            get;
            private set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        static RunMode()
        {
            IsDebug = false;
            SetRunMode();
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        [Conditional("DEBUG")]
        private static void SetRunMode()
        {
            IsDebug = true;
        }

        # endregion        
    }
}
