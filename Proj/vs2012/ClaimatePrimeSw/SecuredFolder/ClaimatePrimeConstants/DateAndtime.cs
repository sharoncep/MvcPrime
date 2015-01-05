using System;
using System.Collections.Generic;
using System.Linq;

namespace ClaimatePrimeConstants
{
    public class DateAndTime
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private DateAndTime()
        {

        }

        # endregion

        # region Public Methods

        // http://www.aspcode.net/C-Datediff.aspx

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDateIntervals"></param>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <returns></returns>
        public static global::System.Int64 GetDateDiff(DateIntervals pDateIntervals, DateTime pStartDate, DateTime pEndDate)
        {
            return GetDateDiff(pDateIntervals, pStartDate, pEndDate,
                            System.Globalization.DateTimeFormatInfo.CurrentInfo == null
                                ? DayOfWeek.Sunday
                                : System.Globalization.DateTimeFormatInfo.CurrentInfo.FirstDayOfWeek);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDateIntervals"></param>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <param name="pFirstDayOfWeek"></param>
        /// <returns></returns>
        public static global::System.Int64 GetDateDiff(DateIntervals pDateIntervals, DateTime pStartDate, DateTime pEndDate, DayOfWeek pFirstDayOfWeek)
        {
            return DateDiffs.DateDiff((DateDiffs.DateIntervals)pDateIntervals, pStartDate, pEndDate, pFirstDayOfWeek);
        }

        /// <summary>
        /// Difference between pDateOfBirth and pEndDate
        /// </summary>
        /// <param name="pDateOfBirth"></param>
        /// <param name="pEndDate"></param>
        /// <returns>Years, Months and Days</returns>
        public static Dictionary<DateIntervals, Int32> GetAge(DateTime pDateOfBirth, DateTime pEndDate)
        {
            Dictionary<DateIntervals, Int32> retAns = new Dictionary<DateIntervals, int>();

            Dictionary<DateDiffs.DateIntervals, Int32> dictAns = DateDiffs.GetAge(pDateOfBirth, pEndDate);

            retAns.Add(DateIntervals.YEAR, dictAns[DateDiffs.DateIntervals.YEAR]);
            retAns.Add(DateIntervals.MONTH, dictAns[DateDiffs.DateIntervals.MONTH]);
            retAns.Add(DateIntervals.DAY, dictAns[DateDiffs.DateIntervals.DAY]);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <returns></returns>
        public static List<DateTime> GetAllDates(DateTime pStartDate, DateTime pEndDate)
        {
            List<DateTime> retAns = new List<DateTime>();

            while (DateTime.Compare(pStartDate, pEndDate) < 1)
            {
                retAns.Add(pStartDate);
                pStartDate = pStartDate.AddDays(1);
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <returns></returns>
        public static List<DateTime> GetAllBusinessDates(DateTime pStartDate, DateTime pEndDate)
        {
            List<DateTime> retAns = new List<DateTime>();

            List<DateTime> allDate = GetAllDates(pStartDate, pEndDate);
            retAns = new List<DateTime>(from oAllDate in allDate where oAllDate.IsBusinessDay() select oAllDate);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <returns></returns>
        public static List<DateTime> GetAllNonBusinessDates(DateTime pStartDate, DateTime pEndDate)
        {
            List<DateTime> retAns = new List<DateTime>();

            List<DateTime> allDate = GetAllDates(pStartDate, pEndDate);
            retAns = new List<DateTime>(from oAllDate in allDate where (!(oAllDate.IsBusinessDay())) select oAllDate);

            return retAns;
        }

        # endregion
    }
}
