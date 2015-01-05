using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using System.Data.Objects;

namespace ClaimatePrimeModels.Models
{
    #region ChangePassword

    /// <summary>
    /// By Sai : Change Password
    /// </summary>
    public class ChangePasswordSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Int32 UserID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CurrPwd
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String CurrPwdEnc
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String NewPwd
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String NewPwdEnc
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String NewPwdEncUpr
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ConfPwd
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_User_Result UserResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_Password_Result PasswordResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetByUserID_UserPassword_Result> UserPasswordResults
        {
            get;
            set;
        }


        #endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ChangePasswordSaveModel()
        {

        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                UserResult = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(UserID, true))).FirstOrDefault();
                PasswordResult = (new List<usp_GetByPkId_Password_Result>(ctx.usp_GetByPkId_Password(1, true))).FirstOrDefault();
                UserPasswordResults = new List<usp_GetByUserID_UserPassword_Result>(ctx.usp_GetByUserID_UserPassword(UserID, (PasswordResult.HistoryReuseStatus + 1)));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ObjectParameter userID = ObjParam("UserID", typeof(global::System.Int32), UserResult.UserID);

                ctx.usp_Update_User(UserResult.UserName, NewPwdEnc, UserResult.Email, UserResult.LastName, UserResult.MiddleName, UserResult.FirstName, UserResult.PhoneNumber, UserResult.ManagerID, UserResult.PhotoRelPath, false, UserResult.Comment, UserResult.IsBlocked, UserResult.IsActive, UserResult.LastModifiedBy, UserResult.LastModifiedOn, pUserID, userID);

                if (HasErr(userID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                ObjectParameter userPassword = ObjParam("UserPassword");

                ctx.usp_Insert_UserPassword(UserResult.UserID, NewPwdEnc, NewPwdEncUpr, UserResult.UserID, userPassword);

                if (HasErr(userPassword, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetSplChars()
        {
            return ("!, @, #, $, %, -, _, ~");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public usp_GetByPkId_Password_Result GetConfigPassword()
        {
            using (EFContext ctx = new EFContext())
            {
                
                PasswordResult = (new List<usp_GetByPkId_Password_Result>(ctx.usp_GetByPkId_Password(1, true))).FirstOrDefault();
                
            }

            return PasswordResult;
        }

        //public bool GetByHistoryReuseStatusUserPassword(string password)
        //{
        //    //List<usp_GetByHistoryReuseStatus_UserPassword_Result> res;
        //int flag = 0;

        //using (EFContext ctx = new EFContext())
        //{
        //    res = (new List<usp_GetByHistoryReuseStatus_UserPassword_Result>(ctx.usp_GetByHistoryReuseStatus_UserPassword()));
        //}



        //foreach(usp_GetByHistoryReuseStatus_UserPassword_Result item in res)
        //{
        //    if (item.AllCapsPassword== password)
        //    {
        //        flag = 1;

        //    }


        //}

        //if (flag == 0)
        //{
        //    return true;
        //}
        //else
        //{
        //    return false;
        //}



        #endregion
    }

    #endregion
}
