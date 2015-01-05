using System;
using System.Collections.Generic;

namespace ClaimatePrimeConstants
{
    /// <summary>
    /// http://www.c-sharpcorner.com/UploadFile/hgvyas123/3749/Default.aspx
    /// 
    /// http://www.aspcode.net/C-Datediff.aspx
    /// </summary>
    public class DateDiffs
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private DateDiffs()
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
        /// <param name="pFirstDayOfWeek"></param>
        /// <returns></returns>
        internal static global::System.Int64 DateDiff(DateIntervals pDateIntervals, DateTime pStartDate, DateTime pEndDate, DayOfWeek pFirstDayOfWeek)
        {
            if (pDateIntervals == DateIntervals.YEAR)
            {
                return pEndDate.Year - pStartDate.Year;
            }

            if (pDateIntervals == DateIntervals.MONTH)
            {
                return (pEndDate.Month - pStartDate.Month) + (12 * (pEndDate.Year - pStartDate.Year));
            }

            TimeSpan ts = pEndDate - pStartDate;

            if (pDateIntervals == DateIntervals.DAY || pDateIntervals == DateIntervals.DAYOFYEAR)
            {
                return Round(ts.TotalDays);
            }

            if (pDateIntervals == DateIntervals.HOUR)
            {
                return Round(ts.TotalHours);
            }

            if (pDateIntervals == DateIntervals.MINUTE)
            {
                return Round(ts.TotalMinutes);
            }

            if (pDateIntervals == DateIntervals.SECOND)
            {
                return Round(ts.TotalSeconds);
            }

            if (pDateIntervals == DateIntervals.WEEKDAY)
            {
                return Round(ts.TotalDays / 7.0);
            }

            if (pDateIntervals == DateIntervals.WEEKOFYEAR)
            {
                while (pEndDate.DayOfWeek != pFirstDayOfWeek)
                    pEndDate = pEndDate.AddDays(-1);
                while (pStartDate.DayOfWeek != pFirstDayOfWeek)
                    pStartDate = pStartDate.AddDays(-1);
                ts = pEndDate - pStartDate;
                return Round(ts.TotalDays / 7.0);
            }

            if (pDateIntervals == DateIntervals.QUARTER)
            {
                double d1Quarter = GetQuarter(pStartDate.Month);
                double d2Quarter = GetQuarter(pEndDate.Month);
                double d1 = d2Quarter - d1Quarter;
                double d2 = (4 * (pEndDate.Year - pStartDate.Year));
                return Round(d1 + d2);
            }

            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pStartDate"></param>
        /// <param name="pEndDate"></param>
        /// <returns>Years, Months and Days</returns>
        internal static Dictionary<DateIntervals, Int32> GetAge(DateTime pStartDate, DateTime pEndDate)
        {
            Dictionary<DateIntervals, Int32> retAns = new Dictionary<DateIntervals, Int32>();

            Int32 iYear = pEndDate.Year - pStartDate.Year;
            Int32 iMonth = pEndDate.Month - pStartDate.Month;
            Int32 iDay = pEndDate.Day - pStartDate.Day;

            if (iDay < 0)
            {
                iMonth--;

                if (pEndDate.Month == 3)
                {
                    if (((pEndDate.Year % 4) == 0) && ((pEndDate.Year % 100) != 0))
                    {
                        iDay = 29 + iDay;
                    }
                    else
                    {
                        iDay = 28 + iDay;
                    }
                }
                else if ((pEndDate.Month == 5) || (pEndDate.Month == 7) || (pEndDate.Month == 10) || (pEndDate.Month == 12))
                {
                    iDay = 30 + iDay;
                }
                else
                {
                    iDay = 31 + iDay;
                }
            }

            if (iMonth < 0)
            {
                iMonth = 12 + iMonth;
                iYear--;
            }

            retAns.Add(DateIntervals.YEAR, iYear);
            retAns.Add(DateIntervals.MONTH, iMonth);
            retAns.Add(DateIntervals.DAY, iDay);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pDateTime"></param>
        /// <returns></returns>
        internal static bool IsMinDate(DateTime pDateTime)
        {
            if (DateDiff(DateIntervals.DAY, new DateTime(1900, 1, 1), pDateTime, DayOfWeek.Sunday) <= 0)
            {
                return true;
            }

            return false;
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pMonth"></param>
        /// <returns></returns>
        private static int GetQuarter(int pMonth)
        {
            if (pMonth <= 3)
            {
                return 1;
            }

            if (pMonth <= 6)
            {
                return 2;
            }

            if (pMonth <= 9)
            {
                return 3;
            }

            return 4;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        private static global::System.Int64 Round(double pValue)
        {
            if (pValue >= 0)
            {
                return (global::System.Int64)Math.Floor(pValue);
            }

            return (global::System.Int64)Math.Ceiling(pValue);
        }

        # endregion

        # region DateIntervals

        /// <summary>
        /// 
        /// </summary>
        internal enum DateIntervals
        {
            /// <summary>
            /// 
            /// </summary>
            UNDEFINED = 0,

            /// <summary>
            /// 
            /// </summary>
            DAY = 1,

            /// <summary>
            /// 
            /// </summary>
            DAYOFYEAR = 2,

            /// <summary>
            /// 
            /// </summary>
            HOUR = 3,

            /// <summary>
            /// 
            /// </summary>
            MINUTE = 4,

            /// <summary>
            /// 
            /// </summary>
            MONTH = 5,

            /// <summary>
            /// 
            /// </summary>
            QUARTER = 6,

            /// <summary>
            /// 
            /// </summary>
            SECOND = 7,

            /// <summary>
            /// 
            /// </summary>
            WEEKDAY = 8,

            /// <summary>
            /// 
            /// </summary>
            WEEKOFYEAR = 9,

            /// <summary>
            /// 
            /// </summary>
            YEAR = 10
        }

        # endregion
    }
}
