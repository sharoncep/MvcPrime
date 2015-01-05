using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.Models
{
    # region LogIn

    /// <summary>
    /// 
    /// </summary>
    public class LogInModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_User_Result UserLogin
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String UserCulture
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetAll_WebCulture_Result> WebCultures
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public LogInModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
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
        public void SenthilSR()
        {
            string xMLdata = @"
<users>
          <user>
                   <FirstName>Suresh</FirstName>
                   <LastName>Dasari</LastName>
                   <UserName>SureshDasari</UserName>
                   <Job>Team Leader</Job>
          </user>
          <user>
                   <FirstName>Mahesh</FirstName>
                   <LastName>Dasari</LastName>
                   <UserName>MaheshDasari</UserName>
                   <Job>Software Developer</Job>
          </user>
          <user>
                   <FirstName>Madhav</FirstName>
                   <LastName>Yemineni</LastName>
                   <UserName>MadhavYemineni</UserName>
                   <Job>Business Analyst</Job>
          </user>
</users>";

            List<usp_GetSenthilSR_ClaimProcess_Result> srs = new List<usp_GetSenthilSR_ClaimProcess_Result>();

            using (EFContext ctx = new EFContext())
            {
                srs = new List<usp_GetSenthilSR_ClaimProcess_Result>(ctx.usp_GetSenthilSR_ClaimProcess(xMLdata));
            }

            foreach (usp_GetSenthilSR_ClaimProcess_Result item in srs)
            {

            }
        }

        ///// <summary>
        ///// 
        ///// </summary>
        //public void testing()
        //{
        //    using (EFContext ctx = new EFContext())
        //    {
        //        BeginDbTrans(ctx);
        //        usp_GetByPkId_PatientVisit_Result dddd1 = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(1, true))).First();
        //        usp_GetByPkId_PatientVisit_Result dddd2 = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(2, true))).First();
        //        usp_GetByPkId_PatientVisit_Result dddd3 = (new List<usp_GetByPkId_PatientVisit_Result>(ctx.usp_GetByPkId_PatientVisit(3, true))).First();
        //        CommitDbTrans(ctx);
        //    }
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public void FillWebCultures()
        {
            using (EFContext ctx = new EFContext())
            {
                WebCultures = new List<usp_GetAll_WebCulture_Result>(ctx.usp_GetAll_WebCulture());
            }
        }

        public usp_GetByPkId_Password_Result FillPassword()
        {
            usp_GetByPkId_Password_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetByPkId_Password_Result>(ctx.usp_GetByPkId_Password(1, true))).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_Password_Result();
            }

            return retAns;
        }

        public bool IsPasswordAged(string email, Nullable<byte> pwdAge)
        {
            usp_GetPasswordAge_User_Result retAns = null;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetPasswordAge_User_Result>(ctx.usp_GetPasswordAge_User(email, pwdAge)).FirstOrDefault());
            }

            if ((retAns != null))
            {
                return retAns.IS_AGED;
            }
            return false;
        }

        public bool IsAlert(int pUser)
        {
            usp_GetAlertByID_User_Result retAns = null;


            using (EFContext ctx = new EFContext())
            {

                retAns = (new List<usp_GetAlertByID_User_Result>(ctx.usp_GetAlertByID_User(pUser, true)).FirstOrDefault());
            }

            if (retAns != null)
            {
                return retAns.ALERT_CHANGE_PASSWORD;
            }

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool GetTrialBalanceLogInTrial(global::System.String email, Nullable<byte> trialMaxCount)
        {
            usp_GetTrialBalance_LogInTrial_Result retAns = null;


            using (EFContext ctx = new EFContext())
            {

                retAns = (new List<usp_GetTrialBalance_LogInTrial_Result>(ctx.usp_GetTrialBalance_LogInTrial(email, trialMaxCount)).FirstOrDefault());
            }

            if (retAns != null)
            {
                return retAns.HAS_BALANCE;
            }

            return false;
        }

        public bool HasClinic(Nullable<int> userID)
        {
            usp_GetCount_Clinic_Result retAns = null;


            using (EFContext ctx = new EFContext())
            {

                retAns = (new List<usp_GetCount_Clinic_Result>(ctx.usp_GetCount_Clinic(userID)).FirstOrDefault());
            }

            if ((retAns != null) && (retAns.CLINIC_COUNT > 0))
            {
                return true;
            }

            return false;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public usp_GetRole_UserRole_Result GetRoleUserRole(Nullable<global::System.Int64> userID)
        {
            usp_GetRole_UserRole_Result retAns = null;

            if (userID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetRole_UserRole_Result>(ctx.usp_GetRole_UserRole(userID))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetRole_UserRole_Result();
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userID"></param>
        /// <returns></returns>
        public List<usp_GetRoles_UserRole_Result> GetRolesUserRole(Nullable<global::System.Int64> userID)
        {
            if (userID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    return new List<usp_GetRoles_UserRole_Result>(ctx.usp_GetRoles_UserRole(userID));
                }
            }

            return new List<usp_GetRoles_UserRole_Result>();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userInput"></param>
        /// <param name="isEmail"></param>
        /// <returns></returns>
        public usp_GetByUserName_User_Result GetByUserNameUser(global::System.String userInput, global::System.Boolean isEmail)
        {
            usp_GetByUserName_User_Result retAns;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetByUserName_User_Result>(ctx.usp_GetByUserName_User(userInput, isEmail))).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetByUserName_User_Result();
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="trialUsername"></param>
        /// <param name="isSuccess"></param>
        /// <param name="clientHostIPAddress"></param>
        /// <param name="clientHostName"></param>
        /// <returns></returns>
        public bool SaveLogInTrial(global::System.String trialUsername, Nullable<global::System.Boolean> isSuccess, global::System.String clientHostIPAddress, global::System.String clientHostName)
        {
            ObjectParameter logInTrialID = ObjParam("LogInTrial");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_LogInTrial(trialUsername, isSuccess, clientHostIPAddress, clientHostName, true, logInTrialID);
                if (HasErr(logInTrialID, ctx))
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
        /// <param name="userID"></param>
        /// <param name="clientHostIPAddress"></param>
        /// <param name="clientHostName"></param>
        /// <param name="sessionID"></param>
        /// <param name="logInLogOutPk"></param>
        /// <returns></returns>
        public bool SaveLogInLogOut(Nullable<global::System.Int32> userID, global::System.String clientHostIPAddress, global::System.String clientHostName, global::System.String sessionID, out global::System.Int64 logInLogOutPk)
        {
            ObjectParameter logInLogOutID = ObjParam("LogInLogOut");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_LogInLogOut(userID, clientHostIPAddress, clientHostName, sessionID, logInLogOutID);
                if (HasErr(logInLogOutID, ctx))
                {
                    RollbackDbTrans(ctx);

                    logInLogOutPk = 0;

                    return false;
                }

                CommitDbTrans(ctx);

                logInLogOutPk = Convert.ToInt64(logInLogOutID.Value);
            }

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLogInLogOutID"></param>
        /// <returns></returns>
        public bool SaveLogInLogOut(global::System.Int64 pLogInLogOutID)
        {
            EncryptAudit(pLogInLogOutID);
            ObjectParameter logInLogOutID = ObjParam("LogInLogOut");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Update_LogInLogOut(logInLogOutID);

                if (HasErr(logInLogOutID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        protected override void FillByID(int pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                UserLogin = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(pID, true))).FirstOrDefault();
            }
            if (UserLogin == null)
            {
                UserLogin = new usp_GetByPkId_User_Result();
            }
            EncryptAudit(UserLogin.UserID, UserLogin.LastModifiedBy, UserLogin.LastModifiedOn);

        }

        public bool UpdateAlertConfig(int pUser)
        {
            ObjectParameter userID = ObjParam("User");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_User(UserLogin.UserName, UserLogin.Password, UserLogin.Email, UserLogin.LastName, UserLogin.MiddleName
                    , UserLogin.FirstName, UserLogin.PhoneNumber, UserLogin.ManagerID, UserLogin.PhotoRelPath, true, UserLogin.Comment
                    , UserLogin.IsBlocked, UserLogin.IsActive, LastModifiedBy, LastModifiedOn, pUser, userID);

                if (HasErr(userID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        public usp_GetByPkId_User_Result GetByPkIdUser1(Nullable<int> userID, Nullable<bool> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                UserLogin = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(userID, pIsActive))).FirstOrDefault();
            }

            if (UserLogin == null)
            {
                UserLogin = new usp_GetByPkId_User_Result();
            }

            return UserLogin;

        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<usp_GetAll_MvcInit_Result> GetAllMvcInit()
        {
            List<usp_GetAll_MvcInit_Result> spRes;

            using (EFContext ctx = new EFContext())
            {
                spRes = new List<usp_GetAll_MvcInit_Result>(ctx.usp_GetAll_MvcInit());
            }

            return spRes;
        }

        # endregion
    }

    # endregion

    #region ForgotPassword

    /// <summary>
    /// 
    /// </summary>
    public class ForgotPasswordModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public global::System.String Email
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String EmailSubj
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public global::System.String EmailErr
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByEmail_User_Result UserResult
        {
            get;
            set;
        }

        #endregion

        #region constructors

        /// <summary>
        /// 
        /// </summary>
        public ForgotPasswordModel()
        {

        }

        #endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
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
        public void FillByForgotUser()
        {
            using (EFContext ctx = new EFContext())
            {
                UserResult = (new List<usp_GetByEmail_User_Result>(ctx.usp_GetByEmail_User(Email))).FirstOrDefault();
            }

            if (UserResult == null)
            {
                UserResult = new usp_GetByEmail_User_Result();
            }

            EncryptAudit(UserResult.UserID, UserResult.LastModifiedBy, UserResult.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetPasswordUser()
        {
            usp_GetPassword_User_Result retAns;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetPassword_User_Result>(ctx.usp_GetPassword_User())).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetPassword_User_Result();
            }

            return retAns.NEW_PWD;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="PASSWORD"></param>
        /// <param name="clientHostIPAddress"></param>
        /// <param name="clientHostName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public bool SaveForgotPwd(global::System.String password, global::System.String PASSWORD, global::System.String clientHostIPAddress, global::System.String clientHostName, global::System.String sessionID)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                # region User

                ObjectParameter userID = ObjParam("User");

                ctx.usp_Update_User(UserResult.UserName, password, UserResult.Email, UserResult.LastName, UserResult.MiddleName, UserResult.FirstName, UserResult.PhoneNumber, UserResult.ManagerID, UserResult.PhotoRelPath, true, UserResult.Comment, UserResult.IsBlocked, UserResult.IsActive, UserResult.LastModifiedBy, UserResult.LastModifiedOn, UserResult.UserID, userID);

                if (HasErr(userID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                # endregion

                # region LogInTrial

                ObjectParameter logInTrialID = ObjParam("LogInTrial");

                ctx.usp_Insert_LogInTrial(UserResult.Email, true, clientHostIPAddress, clientHostName, false, logInTrialID);

                if (HasErr(logInTrialID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                # endregion

                # region LogInLogOut

                ObjectParameter logInLogOut = ObjParam("LogInLogOut");

                ctx.usp_Insert_LogInLogOut(UserResult.UserID, clientHostIPAddress, clientHostName, sessionID, logInLogOut);

                if (HasErr(logInLogOut, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                EncryptAudit(Convert.ToInt64(logInLogOut.Value));
                logInLogOut = ObjParam("LogInLogOut");

                ctx.usp_Update_LogInLogOut(logInLogOut);

                if (HasErr(logInLogOut, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                EncryptAudit(0);

                # endregion

                # region UserPassword

                ObjectParameter userPassword = ObjParam("UserPassword");

                ctx.usp_Insert_UserPassword(UserResult.UserID, password, PASSWORD, UserResult.UserID, userPassword);

                if (HasErr(userPassword, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                # endregion

                CommitDbTrans(ctx);

            }

            return true;
        }

        #endregion
    }

    #endregion

    #region ContactUs

    /// <summary>
    /// 
    /// </summary>
    public class ContactUsModel : BaseModel
    {
        # region properties

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_User_Result WebAdmin
        {
            get;
            set;
        }

        # endregion

        #region constructors

        /// <summary>
        /// 
        /// </summary>
        public ContactUsModel()
        {

        }

        #endregion

        #region publicmethods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public usp_GetByPkId_User_Result GetByPkIdUserWebAdmin(System.Nullable<global::System.Boolean> pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                WebAdmin = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(Constants.Others.WEB_ADMIN_USER_ID, pIsActive))).FirstOrDefault();
            }

            if (WebAdmin == null)
            {
                WebAdmin = new usp_GetByPkId_User_Result();
            }

            return WebAdmin;
        }




        #endregion
    }

    #endregion

    # region Clock

    /// <summary>
    /// 
    /// </summary>
    public class ClockModel : BaseModel
    {
        # region Properties

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ClockModel()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DateTime GetServerDtTm()
        {
            usp_GetTime_Server_Result retAns;

            using (EFContext ctx = new EFContext())
            {
                retAns = (new List<usp_GetTime_Server_Result>(ctx.usp_GetTime_Server())).FirstOrDefault();
            }

            if (retAns == null)
            {
                retAns = new usp_GetTime_Server_Result();
            }

            return retAns.CURR_DT_TM;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sessTimeOutMaxMin"></param>
        /// <param name="logInLogOutID"></param>
        /// <returns></returns>
        public usp_GetStatus_Screen_Result GetStatusScreen(byte sessTimeOutMaxMin, long logInLogOutID)
        {
            using (EFContext ctx = new EFContext())
            {
                return ((new List<usp_GetStatus_Screen_Result>(ctx.usp_GetStatus_Screen(sessTimeOutMaxMin, logInLogOutID))).FirstOrDefault());
            }
        }

        # endregion
    }

    # endregion



}
