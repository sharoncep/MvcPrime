using System;
using System.Collections.Generic;

namespace ClaimatePrimeConstants
{
    /// <summary>
    /// http://stackoverflow.com/questions/1617049/calculate-the-number-of-business-days-between-two-dates
    /// </summary>
    public static class Extensions
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDateTime"></param>
        /// <returns></returns>
        public static bool IsMinDate(this DateTime pDateTime)
        {
            return DateDiffs.IsMinDate(pDateTime);
        }

        /// <summary>
        /// Difference between pDateOfBirth and CurrentDate
        /// </summary>
        /// <param name="pDateOfBirth"></param>
        /// <returns>Years, Months and Days</returns>
        public static Dictionary<DateIntervals, Int32> GetAge(this DateTime pDateOfBirth)
        {
            return DateAndTime.GetAge(pDateOfBirth, DateTime.Now);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDate"></param>
        /// <returns></returns>
        public static bool IsBusinessDay(this DateTime pDate)
        {
            return ((pDate.DayOfWeek != DayOfWeek.Saturday) && (pDate.DayOfWeek != DayOfWeek.Sunday));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pVal"></param>
        /// <returns></returns>
        public static bool IsNumeric(this string pVal)
        {
            float output;
            return float.TryParse(pVal, out output);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pVal"></param>
        /// <returns></returns>
        public static bool IsNumeric(this char pVal)
        {
            float output;
            return float.TryParse(Convert.ToString(pVal), out output);
        }

    }
}
