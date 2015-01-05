using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace ANSI5010.SecuredFolder.StaticClasses
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public static class Static5010
    {
        # region Private Variables

        private static Dictionary<string, string> _ANSI5010Xml;

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        static Static5010()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pPath"></param>
        public static void LoadXml(string pPath)
        {
            if (_ANSI5010Xml == null)
            {
                _ANSI5010Xml = new Dictionary<string, string>();

                List<XElement> xEles = GetEles(pPath);

                foreach (XElement xEle in xEles)
                {
                    string ky = xEle.Element("name").Value;
                    if (ky.Contains(" "))
                    {
                        throw new Exception("Sorry! App_ANSI5010 : name : Should not contain blank spaces");
                    }

                    _ANSI5010Xml.Add(ky, xEle.Element("value").Value);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pName"></param>
        /// <returns></returns>
        public static string ReadXml(string pName)
        {
            try
            {
                return _ANSI5010Xml[pName];
            }
            catch
            {
                return string.Empty;
            }
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXml"></param>
        /// <returns></returns>
        private static List<XElement> GetEles(global::System.String pXml)
        {
            return (new List<XElement>(((XDocument.Load(pXml)).Element("ANSI5010")).Elements("data")));
        }

        # endregion
    }
}
