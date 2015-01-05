using System;

namespace ClaimatePrimeModels.SecuredFolder.Extensions
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class KeyValueModel<Tk, Tv>
    {
        #region Private Variables

        private readonly Tk _Key;
        private readonly Tv _Value;

        #endregion

        #region Properties

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public Tk Key
        {
            get { return _Key; }
        }

        /// <summary>
        /// Get
        /// </summary>
        /// <value></value>
        /// <returns></returns>
        /// <remarks></remarks>
        public Tv Value
        {
            get { return _Value; }
        }

        #endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pKey"></param>
        /// <param name="pValue"></param>
        public KeyValueModel(Tk pKey, Tv pValue)
        {
            this._Key = pKey;
            this._Value = pValue;
        }

        #endregion
    }
}
