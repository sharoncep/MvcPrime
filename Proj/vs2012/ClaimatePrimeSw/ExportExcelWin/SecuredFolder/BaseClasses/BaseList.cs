using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExportExcelWin.SecuredFolder.BaseClasses
{
    # region BaseList

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public sealed class BaseList : IBaseList
    {
        # region Implement Interface Members

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<IBaseClass> IBaseClasses { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseList()
        {
            IBaseClasses = new List<IBaseClass>();
        }

        # endregion
    }

    # endregion

    # region IBaseList

    /// <summary>
    /// Get or Set
    /// </summary>
    public interface IBaseList
    {
        List<IBaseClass> IBaseClasses { get; set; }
    }

    # endregion
}
