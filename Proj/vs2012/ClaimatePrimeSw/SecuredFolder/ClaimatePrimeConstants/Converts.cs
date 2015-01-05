using System;
using System.Globalization;

namespace ClaimatePrimeConstants
{
    /// <summary>
    /// 
    /// </summary>
    public class Converts
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private Converts()
        {

        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static Byte AsByte(object pValue)
        {
            if (AsBoolean(pValue))
            {
                return 1;
            }

            return Convert.ToByte(Math.Round(AsDecimal(pValue)));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static Int16 AsInt16(object pValue)
        {
            if (AsBoolean(pValue))
            {
                return 1;
            }

            return Convert.ToInt16(Math.Round(AsDecimal(pValue)));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<Int16> AsInt16Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<Int16> retAns = AsInt16(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static UInt16 AsUInt16(object pValue)
        {
            Int16 tmp = AsInt16(pValue);

            if (tmp < 1)
            {
                return 0;
            }
            else
            {
                return Convert.ToUInt16(tmp);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<UInt16> AsUInt16Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<UInt16> retAns = AsUInt16(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static int AsInt(object pValue)
        {
            if (AsBoolean(pValue))
            {
                return 1;
            }

            pValue = Math.Round(AsDecimal(pValue));

            int retAns;

            if (int.TryParse(Convert.ToString(pValue), out retAns))
            {
                return retAns;
            }

            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<int> AsIntNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<int> retAns = AsInt(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static uint AsUInt(object pValue)
        {
            int tmp = AsInt(pValue);

            if (tmp < 1)
            {
                return 0;
            }
            else
            {
                return Convert.ToUInt32(tmp);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<uint> AsUIntNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<uint> retAns = AsUInt(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static Int32 AsInt32(object pValue)
        {
            if (AsBoolean(pValue))
            {
                return 1;
            }

            return Convert.ToInt32(Math.Round(AsDecimal(pValue)));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<Int32> AsInt32Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<Int32> retAns = AsInt32(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static uint AsUInt32(object pValue)
        {
            Int32 tmp = AsInt32(pValue);

            if (tmp < 1)
            {
                return 0;
            }
            else
            {
                return Convert.ToUInt32(tmp);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<UInt32> AsUInt32Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<UInt32> retAns = AsUInt32(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static Int64 AsInt64(object pValue)
        {
            if (AsBoolean(pValue))
            {
                return 1;
            }

            return Convert.ToInt64(Math.Round(AsDecimal(pValue)));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<Int64> AsInt64Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<Int64> retAns = AsInt64(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static UInt64 AsUInt64(object pValue)
        {
            Int64 tmp = AsInt64(pValue);

            if (tmp < 1)
            {
                return 0;
            }
            else
            {
                return Convert.ToUInt64(tmp);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<UInt64> AsUInt64Nullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<UInt64> retAns = AsUInt64(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static double AsDouble(object pValue)
        {
            double retAns;

            if (double.TryParse(Convert.ToString(pValue), out retAns))
            {
                return retAns;
            }

            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<double> AsDoubleNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<double> retAns = AsDouble(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static decimal AsDecimal(object pValue)
        {
            decimal retAns;

            if (decimal.TryParse(Convert.ToString(pValue), out retAns))
            {
                return retAns;
            }

            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<decimal> AsDecimalNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<decimal> retAns = AsDecimal(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static float AsFloat(object pValue)
        {
            float retAns;

            if (float.TryParse(Convert.ToString(pValue), out retAns))
            {
                return retAns;
            }

            return 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<float> AsFloatNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<float> retAns = AsFloat(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static DateTime AsDateTime(object pValue)
        {
            DateTime retAns;

            if (DateTime.TryParse(Convert.ToString(pValue), out retAns))
            {
                if (DateTime.Compare(new DateTime(retAns.Year, retAns.Month, retAns.Day), new DateTime(1900, 1, 1)) < 0)
                {
                    return DateTime.MinValue;
                }

                return retAns;
            }

            return DateTime.MinValue;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<DateTime> AsDateTimeNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            DateTime dt = AsDateTime(pValue);

            System.Nullable<DateTime> retAns = null;

            if (dt != DateTime.MinValue)
            {
                retAns = dt;
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static bool AsBoolean(object pValue)
        {
            bool retAns;

            if (bool.TryParse(Convert.ToString(pValue).ToLower(), out retAns))
            {
                return retAns;
            }

            string strTmp = Convert.ToString(pValue);

            if ((string.Compare(strTmp, "Yes", true) == 0) ||
                (string.Compare(strTmp, "Y", true) == 0) ||
                (string.Compare(strTmp, "True", true) == 0) ||
                (string.Compare(strTmp, "T", true) == 0) ||
                (string.Compare(strTmp, "Checked", true) == 0) ||
                (string.Compare(strTmp, "1", true) == 0))
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static System.Nullable<bool> AsBooleanNullable(object pValue)
        {
            if ((pValue == null) || (string.IsNullOrWhiteSpace(Convert.ToString(pValue))))
            {
                return null;
            }

            System.Nullable<bool> retAns = AsBoolean(pValue);

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static T AsEnum<T>(string pValue)
        {
            return (T)Enum.Parse(typeof(T), pValue, true);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static T AsEnum<T>(int pValue)
        {
            return AsEnum<T>(Convert.ToString(pValue));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static T AsEnum<T>(byte pValue)
        {
            return AsEnum<T>(Convert.ToString(pValue));
        }

        ///// <summary>
        ///// http://byatool.com/utilities/another-silly-method-just-for-you/
        ///// </summary>
        ///// <typeparam name="K">Enum</typeparam>
        ///// <returns></returns>
        //public static IDictionary<String, Int32> AsDictionary<K>()
        //{
        //    return Enum.GetValues(typeof(K)).Cast<Int32>().ToDictionary(currentItem => Enum.GetName(typeof(K), currentItem));
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pValue"></param>
        /// <returns></returns>
        public static string AsTitleCase(string pValue)
        {
            string retAns = string.Empty;

            string[] strArr = pValue.Split(Convert.ToChar(" "));

            foreach (string s in strArr)
            {
                if (string.IsNullOrWhiteSpace(s))
                {
                    continue;
                }

                string currWord = string.Concat(s.Substring(0, 1).ToUpper(), s.Substring(1).ToLower());

                if (string.Compare(currWord, "id", true) == 0)
                {
                    currWord = currWord.ToUpper();
                }
                else if (string.Compare(currWord, "db", true) == 0)
                {
                    currWord = currWord.ToUpper();
                }
                else if (string.Compare(currWord, "caqh", true) == 0)
                {
                    currWord = currWord.ToUpper();
                }
                else if (string.Compare(currWord, "bmi", true) == 0)
                {
                    currWord = currWord.ToUpper();
                }
                else if (string.Compare(currWord, "sao2", true) == 0)
                {
                    currWord = "SaO2";
                }
                else if (string.Compare(currWord, "heent", true) == 0)
                {
                    currWord = currWord.ToUpper();
                }
                else if (currWord.Length == 1)
                {
                    currWord = currWord.ToUpper();
                }

                retAns = string.Concat(retAns, currWord, " ");
            }

            return retAns.Trim();
        }

        # endregion
    }
}