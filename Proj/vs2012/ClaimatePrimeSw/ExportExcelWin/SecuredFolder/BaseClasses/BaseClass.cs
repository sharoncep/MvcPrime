using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Reflection;
using System.Xml.Linq;
using System.Linq;

namespace ExportExcelWin.SecuredFolder.BaseClasses
{
    # region BaseClass

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public abstract class BaseClass : IBaseClass
    {
        # region Properties

        /// <summary>
        /// Get or Protected Set
        /// </summary>
        public Int64 SN { get; protected set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseClass()
        {
            Fill();
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        protected abstract void Fill();

        # endregion

        # region Implement Interface Members

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public dynamic ID { get; set; }

        # endregion

        # region Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName">Stored Procedure Name</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>IBaseList</returns>
        public IBaseList SelectList(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams)
        {
            return this.SelectList(this.Fill(pSpKy, pCn, pTrans, pParams));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName">Stored Procedure Name</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>IBaseList</returns>
        public IBaseList SelectList(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams)
        {
            return this.SelectList(this.Fill(pSpKy, pCn, pParams));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXDoc"></param>
        /// <returns></returns>
        public IBaseList SelectList(XDocument pXDoc)
        {
            return ((pXDoc == null) ? (new BaseList()) : (this.SelectList(this.Fill(pXDoc))));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEles"></param>
        /// <returns></returns>
        public IBaseList SelectList(IEnumerable<XElement> pXEles)
        {
            IBaseList retAns = new BaseList();

            if (pXEles != null)
            {
                foreach (XElement xEle in pXEles)
                {
                    retAns.IBaseClasses.Add(CopyConstructor(xEle));
                }
            }

            return retAns;
        }

        //

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName">Stored Procedure Name</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>IBaseList</returns>
        public void Select(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams)
        {
            this.Select(this.Fill(pSpKy, pCn, pTrans, pParams));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpName">Stored Procedure Name</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>IBaseList</returns>
        public void Select(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams)
        {
            this.Select(this.Fill(pSpKy, pCn, pParams));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXDoc"></param>
        /// <returns></returns>
        public void Select(XDocument pXDoc)
        {
            if (pXDoc != null)
            {
                this.Select(this.Fill(pXDoc));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEles"></param>
        /// <returns></returns>
        public void Select(IEnumerable<XElement> pXEles)
        {
            if (pXEles != null)
            {
                foreach (XElement xEle in pXEles)
                {
                    this.Select(xEle);
                    break;
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEle"></param>
        public void Select(XElement pXEle)
        {
            if (pXEle != null)
            {
                this.Fill(pXEle);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>Saved ID</returns>
        public object Save(SqlConnection pCn, SqlTransaction pTrans)
        {
            return ((ID == 0) ? (this.Insert(pCn, pTrans)) : (this.Update(pCn, pTrans)));
        }

        # endregion

        # endregion

        # region Virtual Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpKy">AppSettings Key</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Paramsm (0 ... n). For multiple params, please use comma separator</param>
        /// <returns></returns>
        protected virtual XDocument Fill(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pSpKy">AppSettings Key</param>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pParams">Paramsm (0 ... n). For multiple params, please use comma separator</param>
        /// <returns></returns>
        protected virtual XDocument Fill(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXDoc"></param>
        /// <returns></returns>
        protected virtual IEnumerable<XElement> Fill(XDocument pXDoc)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pXEle"></param>
        protected virtual void Fill(XElement pXEle)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Paramsm (0 ... n). For multiple params, please use comma separator</param>
        /// <returns>Saved ID</returns>
        protected virtual object Insert(SqlConnection pCn, SqlTransaction pTrans)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCn">Opened Connection</param>
        /// <param name="pTrans">Opened Transaction</param>
        /// <param name="pParams">Params. For multiple params, please use comma separator</param>
        /// <returns>Saved ID</returns>
        protected virtual object Update(SqlConnection pCn, SqlTransaction pTrans)
        {
            throw new NotImplementedException();
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// Copy Constructor
        /// </summary>
        /// <param name="xEle"></param>
        /// <returns></returns>
        private IBaseClass CopyConstructor(XElement xEle)
        {
            IBaseClass newObj = (IBaseClass)Activator.CreateInstance(Type.GetType(this.GetType().FullName));
            newObj.Select(xEle);

            return newObj;
        }

        # endregion
    }

    # endregion

    # region IBaseClass

    /// <summary>
    /// 
    /// </summary>
    public interface IBaseClass
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        dynamic ID { get; set; }

        # endregion

        # region Methods

        IBaseList SelectList(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams);
        IBaseList SelectList(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams);
        IBaseList SelectList(XDocument pXDoc);
        IBaseList SelectList(IEnumerable<XElement> pXEles);

        void Select(string pSpKy, SqlConnection pCn, SqlTransaction pTrans, params SqlParameter[] pParams);
        void Select(string pSpKy, SqlConnection pCn, params SqlParameter[] pParams);
        void Select(XDocument pXDoc);
        void Select(IEnumerable<XElement> pXEles);
        void Select(XElement pXEle);

        object Save(SqlConnection pCn, SqlTransaction pTrans);

        # endregion
    }

    # endregion
}
