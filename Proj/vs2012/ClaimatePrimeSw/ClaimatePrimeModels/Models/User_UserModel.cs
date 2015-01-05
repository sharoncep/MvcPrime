using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;
using System.IO;

namespace ClaimatePrimeModels.Models
{
    # region UserModel

    /// <summary>
    /// 
    /// </summary>
    public class User_UserModel : BaseModel
    {
        # region Public Methods

        public usp_GetByPkId_User_Result GetByPkIdUser(Nullable<global::System.Int32> userID, Nullable<global::System.Boolean> isActive)
        {

            usp_GetByPkId_User_Result retAns = null;

            if (userID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    retAns = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(userID, isActive))).FirstOrDefault();
                }
            }

            if (retAns == null)
            {
                retAns = new usp_GetByPkId_User_Result();
            }

            return retAns;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteNewUser(string stats, byte roleid)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutocompleteNew_User_Result> spRes = new List<usp_GetAutocompleteNew_User_Result>(ctx.usp_GetAutocompleteNew_User(stats, roleid));

                foreach (usp_GetAutocompleteNew_User_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;

            //  throw new Exception("GetAutoCompleteNewUser(string stats,int roleid)");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteUserID(string selText)
        {

            List<string> retRes = new List<string>();

            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutoComplete_User_Result> spRes = new List<usp_GetIDAutoComplete_User_Result>(ctx.usp_GetIDAutoComplete_User(selCode));

                foreach (usp_GetIDAutoComplete_User_Result item in spRes)
                {
                    retRes.Add(item.User_ID.ToString());
                }
            }

            return retRes;
        }

        # endregion
    }

    # endregion

    #region UserSaveModel

    /// <summary>
    /// 
    /// </summary>
    public class UserSaveModel : BaseSaveModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>

        public usp_GetByPkId_User_Result User
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public int UserID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public List<usp_GetByUserID_UserClinic_Result> UserClinic
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>

        public List<usp_GetByUserID_UserRole_Result> UserRole
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public byte PageID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set 
        /// Resultset containing users of the depromoted manager
        /// </summary>

        public List<usp_GetByManagerID_User_Result> UserManager
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public String User_Manager
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrRootPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrUserPhotoPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_General_Result GeneralResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Boolean ManagerChk
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Boolean BillingAgentChk
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public String Password
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String EmailErr
        {
            get;
            set;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserSaveModel()
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
                User = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(Convert.ToInt32(pID), pIsActive))).FirstOrDefault();

            }

            if (User == null)
            {
                User = new usp_GetByPkId_User_Result() { IsActive = true, IsBlocked = false };
            }
            else
            {
                Password = User.Password;
            }
            # region Manager


            usp_GetByPkId_User_Result stateRes = null;

            using (EFContext ctx = new EFContext())
            {
                stateRes = (new List<usp_GetByPkId_User_Result>(ctx.usp_GetByPkId_User(User.ManagerID, pIsActive))).FirstOrDefault();
            }

            if (stateRes != null)
            {
                User_Manager = string.Concat(stateRes.LastName + stateRes.FirstName, " [", stateRes.UserName, "]");
            }

            #endregion


            EncryptAudit(User.UserID, User.LastModifiedBy, User.LastModifiedOn);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter userID = ObjParam("User");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (!(string.IsNullOrWhiteSpace(User.PhotoRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Patient", "Patient"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrUserPhotoPath = string.Concat(FileSvrUserPhotoPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrUserPhotoPath))
                    {
                        Directory.Delete(FileSvrUserPhotoPath, true);
                    }
                    Directory.CreateDirectory(FileSvrUserPhotoPath);

                    FileSvrUserPhotoPath = string.Concat(FileSvrUserPhotoPath, @"\", "U_1", Path.GetExtension(User.PhotoRelPath));   // File Uploading
                    if (File.Exists(FileSvrUserPhotoPath))
                    {
                        File.Delete(FileSvrUserPhotoPath);
                    }
                    File.Move(User.PhotoRelPath, FileSvrUserPhotoPath);
                    FileSvrUserPhotoPath = FileSvrUserPhotoPath.Replace(FileSvrRootPath, string.Empty);
                    User.PhotoRelPath = FileSvrUserPhotoPath.Substring(1);
                }

                if (PageID == 1) //Adding user in Agent page - Admin
                {
                    ctx.usp_Insert_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, User.ManagerID, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
                    //adding default ba role to the agent.
                    ObjectParameter userroleID = ObjParam("UserRole");
                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 5, string.Empty, pUserID, userroleID);

                    if (HasErr(userroleID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }



                }
                else if (PageID == 2) //Adding user in Assign manager page - Admin
                {
                    #region Inserting newly added manager to user table

                    ctx.usp_Insert_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, null, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }

                    #endregion

                    #region Inserting newly added manager to the userrole table

                    ObjectParameter userroleID = ObjParam("UserRole");

                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 2, string.Empty, pUserID, userroleID);
                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 3, string.Empty, pUserID, userroleID);
                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 4, string.Empty, pUserID, userroleID);
                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 5, string.Empty, pUserID, userroleID);

                    if (HasErr(userroleID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }

                    #endregion


                }

                else if (PageID == 3) //Adding user in Agent page - Manager
                {
                    ctx.usp_Insert_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, UserID, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
                    //adding default ba role to the agent.
                    ObjectParameter userroleID = ObjParam("UserRole");
                    ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 5, string.Empty, pUserID, userroleID);

                    if (HasErr(userroleID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }


                }

                CommitDbTrans(ctx);

                return true;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveUpdate(int pUserID)
        {
            ObjectParameter userID = ObjParam("User");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (ManagerChk)
                {

                    // Promoted As Manager from Agent

                    #region Removing manager id of the promoted user in the user table

                    ctx.usp_Update_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, null, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, User.IsActive, LastModifiedBy, LastModifiedOn, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }

                    #endregion

                    #region Adding roles (2,3 & 4) to the promoted user in the user role table

                    ObjectParameter userroleID = ObjParam("UserRole");

                    UserRole = (new List<usp_GetByUserID_UserRole_Result>(ctx.usp_GetByUserID_UserRole(Convert.ToInt32(userID.Value))));

                    #region QA-Checking whether current agent has QA role

                    int QAcount = 0;
                    bool QAIsActive = true;
                    long QALastModifiedBy = UserRole[0].LastModifiedBy;
                    DateTime QALastModifiedOn = UserRole[0].LastModifiedOn;
                    ObjectParameter userroleIDQA = null;

                    for (int i = 0; i < UserRole.Count; i++)
                    {
                        if (UserRole[i].RoleID == 4 && UserRole[i].IsActive == false)
                        {
                            userroleIDQA = ObjParam("UserRoleID", typeof(System.Int32), UserRole[i].UserRoleID);
                            QAIsActive = false;
                            QALastModifiedBy = UserRole[i].LastModifiedBy;
                            QALastModifiedOn = UserRole[i].LastModifiedOn;
                            break;
                        }
                        else if (UserRole[i].RoleID == 4 && UserRole[i].IsActive == true)
                        {
                            QAcount++;
                        }

                    }
                    if (QAIsActive == false)
                    {
                        ctx.usp_Update_UserRole(Convert.ToInt32(userID.Value), 4, string.Empty, true, QALastModifiedBy, QALastModifiedOn, pUserID, userroleIDQA);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }

                    else if (QAcount == 0)
                    {
                        ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 4, string.Empty, pUserID, userroleID);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }


                    #endregion

                    #region EA-Checking whether current agent has EA role

                    int EAcount = 0;
                    bool EAIsActive = true;
                    long EALastModifiedBy = UserRole[0].LastModifiedBy;
                    DateTime EALastModifiedOn = UserRole[0].LastModifiedOn;
                    ObjectParameter userroleIDEA = null;

                    for (int i = 0; i < UserRole.Count; i++)
                    {
                        if (UserRole[i].RoleID == 3 && UserRole[i].IsActive == false)
                        {
                            userroleIDEA = ObjParam("UserRoleID", typeof(System.Int32), UserRole[i].UserRoleID);
                            EAIsActive = false;
                            EALastModifiedBy = UserRole[i].LastModifiedBy;
                            EALastModifiedOn = UserRole[i].LastModifiedOn;
                            break;
                        }
                        else if (UserRole[i].RoleID == 3 && UserRole[i].IsActive == true)
                        {
                            EAcount++;
                        }


                    }

                    if (EAIsActive == false)
                    {
                        ctx.usp_Update_UserRole(Convert.ToInt32(userID.Value), 3, string.Empty, true, EALastModifiedBy, EALastModifiedOn, pUserID, userroleIDEA);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }

                    else if (EAcount == 0)
                    {
                        ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 3, string.Empty, pUserID, userroleID);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }


                    #endregion

                    #region Manager-Entering manager role to the agent

                    #region Manager-Checking whether current agent has Manager role

                    int Managercount = 0;
                    bool ManagerIsActive = true;
                    long ManagerLastModifiedBy = UserRole[0].LastModifiedBy;
                    DateTime ManagerLastModifiedOn = UserRole[0].LastModifiedOn;
                    ObjectParameter userroleIDManager = null;

                    for (int i = 0; i < UserRole.Count; i++)
                    {
                        if (UserRole[i].RoleID == 2 && UserRole[i].IsActive == false)
                        {
                            userroleIDManager = ObjParam("UserRoleID", typeof(System.Int32), UserRole[i].UserRoleID);
                            ManagerIsActive = false;
                            ManagerLastModifiedBy = UserRole[i].LastModifiedBy;
                            ManagerLastModifiedOn = UserRole[i].LastModifiedOn;
                            break;
                        }
                        else if (UserRole[i].RoleID == 2 && UserRole[i].IsActive == true)
                        {
                            Managercount++;
                        }

                    }
                    if (ManagerIsActive == false)
                    {
                        ctx.usp_Update_UserRole(Convert.ToInt32(userID.Value), 2, string.Empty, true, ManagerLastModifiedBy, ManagerLastModifiedOn, pUserID, userroleIDManager);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }

                    else if (Managercount == 0)
                    {
                        ctx.usp_Insert_UserRole(Convert.ToInt32(userID.Value), 2, string.Empty, pUserID, userroleID);
                        if (HasErr(userroleID, ctx))
                        {
                            RollbackDbTrans(ctx);
                            return false;
                        }
                    }


                    #endregion

                    #endregion


                    #endregion
                }
                else if (BillingAgentChk) // Depromted as Agent from Manager
                {
                    #region Assign manager to the depromoted manager

                    ctx.usp_Update_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, User.ManagerID, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, User.IsActive, LastModifiedBy, LastModifiedOn, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }

                    #endregion

                    #region Reassign users of the depromoted manager to the manager assigned to the depromoted manager

                    UserManager = new List<usp_GetByManagerID_User_Result>(ctx.usp_GetByManagerID_User(Convert.ToInt32(userID.Value)));
                    for (int i = 0; i < UserManager.Count; i++)
                    {
                        ObjectParameter userIDnw = ObjParam("UserID", typeof(System.Int32), UserManager[i].UserID);
                        ctx.usp_Update_User(UserManager[i].UserName, UserManager[i].Password, UserManager[i].Email, UserManager[i].LastName, UserManager[i].MiddleName, UserManager[i].FirstName, UserManager[i].PhoneNumber, User.ManagerID, UserManager[i].PhotoRelPath, UserManager[i].AlertChangePassword, UserManager[i].Comment, UserManager[i].IsBlocked, UserManager[i].IsActive, UserManager[i].LastModifiedBy, UserManager[i].LastModifiedOn, pUserID, userIDnw);
                    }

                    #endregion

                    #region Assign clinics of the depromoted manager to the manager assigned to the depromoted manager

                    List<usp_GetByUserID_UserClinic_Result> CurrManagerClinic; //Variable used to check if the manager assigned to the depromoted manager has the same clinic of the depromoted manager.
                    UserClinic = new List<usp_GetByUserID_UserClinic_Result>(ctx.usp_GetByUserID_UserClinic(Convert.ToInt32(userID.Value)));
                    CurrManagerClinic = new List<usp_GetByUserID_UserClinic_Result>(ctx.usp_GetByUserID_UserClinic(Convert.ToInt32(User.ManagerID)));
                    for (int i = 0; i < UserClinic.Count; i++)
                    {
                        if (CurrManagerClinic == null)
                        {
                            ObjectParameter userclinicID = ObjParam("UserClinicID", typeof(System.Int32), UserClinic[i].UserClinicID);
                            ctx.usp_Update_UserClinic(Convert.ToInt32(userID.Value), UserClinic[i].ClinicID, string.Empty, UserClinic[i].IsActive, UserClinic[i].LastModifiedBy, UserClinic[i].LastModifiedOn, pUserID, userclinicID);
                            if (HasErr(userclinicID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                return false;
                            }
                        }
                        else
                        {
                            int ClinicCount = 0;
                            for (int j = 0; j < CurrManagerClinic.Count; j++)
                            {
                                if (CurrManagerClinic[j].ClinicID == UserClinic[i].ClinicID)
                                {
                                    ClinicCount++;
                                    break;
                                }
                            }
                            if (ClinicCount == 0)
                            {
                                ObjectParameter userclinicID = ObjParam("UserClinicID", typeof(System.Int32), UserClinic[i].UserClinicID);
                                ctx.usp_Update_UserClinic(Convert.ToInt32(userID.Value), UserClinic[i].ClinicID, string.Empty, UserClinic[i].IsActive, UserClinic[i].LastModifiedBy, UserClinic[i].LastModifiedOn, pUserID, userclinicID);
                                if (HasErr(userclinicID, ctx))
                                {
                                    RollbackDbTrans(ctx);
                                    return false;
                                }
                            }
                        }
                    }

                    #endregion

                    #region Remove all the roles of the depromoted manager except BA role

                    UserRole = (new List<usp_GetByUserID_UserRole_Result>(ctx.usp_GetByUserID_UserRole(Convert.ToInt32(userID.Value))));

                    for (int i = 0; i < UserRole.Count; i++)
                    {
                        ObjectParameter userroleID = ObjParam("UserRoleID", typeof(System.Int32), UserRole[i].UserRoleID);
                        if (UserRole[i].RoleID == 2 || UserRole[i].RoleID == 3 || UserRole[i].RoleID == 4)
                        {
                            ctx.usp_Update_UserRole(Convert.ToInt32(userID.Value), UserRole[i].RoleID, string.Empty, false, UserRole[i].LastModifiedBy, UserRole[i].LastModifiedOn, pUserID, userroleID);

                            if (HasErr(userroleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                return false;
                            }
                        }

                    }

                    #endregion
                }
                else
                {
                    ctx.usp_Update_User(User.UserName, Password, User.Email, User.LastName, User.MiddleName, User.FirstName, User.PhoneNumber, User.ManagerID, User.PhotoRelPath, User.AlertChangePassword, User.Comment, User.IsBlocked, User.IsActive, LastModifiedBy, LastModifiedOn, pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

        #region Public Methods

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

        public int GetFileSize()
        {
            using (EFContext ctx = new EFContext())
            {

                GeneralResult = (new List<usp_GetByPkId_General_Result>(ctx.usp_GetByPkId_General(1, true))).FirstOrDefault();

            }

            if (GeneralResult == null)
            {
                GeneralResult = new usp_GetByPkId_General_Result() { IsActive = true };
            }

            return GeneralResult.UploadMaxSizeInMB;
        }

        # endregion
    }

    #endregion

    #region UserSearchModel

    /// <summary>
    /// 
    /// </summary>
    /// 
    public class UserSearchModel : BaseSearchModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearch_User_Result> Users { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>

        public int? SelManagerID { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>

        public byte SelHighRoleID { get; set; }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserSearchModel()
        {
        }

        #endregion

        # region Public Methods

        # endregion

        #region Override Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_User_Result> lst = new List<usp_GetByAZ_User_Result>(ctx.usp_GetByAZ_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), SelManagerID, SearchName, pIsActive));

                foreach (usp_GetByAZ_User_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                Users = new List<usp_GetBySearch_User_Result>(ctx.usp_GetBySearch_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), SelManagerID, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }



    #endregion

    # region UserRoleModel

    #region Search



    /// <summary>
    /// 
    /// </summary>
    public class UserRoleSearchModel : BaseSearchModel
    {
        # region Private Variables
        /// <summary>
        /// 
        /// </summary>
        private global::System.String _ErrorMsg;


        # endregion

        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetBySearch_User_Result> Users { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetByUserID_UserRole_Result> UserRoles { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetAgent_Role_Result> Roles { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public int UserID
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public byte SelHighRoleID { get; set; }


        /// <summary>
        /// Get or set
        /// </summary>
        public int? SelManagerID { get; set; }


        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.String ManagerName
        {
            get;
            set;
        }
        /// <summary>
        /// Get or set
        /// </summary>
        public global::System.Int32 ManagerNameID
        {
            get;
            set;
        }



        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get
            {
                return _ErrorMsg;
            }
            set
            {
                _ErrorMsg = value;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteUserID(string selText)
        {

            List<string> retRes = new List<string>();

            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutoComplete_User_Result> spRes = new List<usp_GetIDAutoComplete_User_Result>(ctx.usp_GetIDAutoComplete_User(selCode));

                foreach (usp_GetIDAutoComplete_User_Result item in spRes)
                {
                    retRes.Add(item.User_ID.ToString());
                }
            }

            return retRes;
        }

        /// <summary>
        /// For setting default manager
        /// in the manager autocomplete
        /// in agent and role
        /// </summary>
        /// <returns></returns>
        public int GetManagerID()
        {
            int retres;
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetManager_User_Result> spRes = new List<usp_GetManager_User_Result>(ctx.usp_GetManager_User(true));

                retres = spRes[0].UserID;
                ManagerName = spRes[0].NAME_CODE;
                ManagerNameID = spRes[0].UserID;

            }
            return retres;
        }

        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserRoleSearchModel()
        {
        }

        #endregion

        # region Public Methods

        /// <summary>
        /// For agent and role save
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            UserRoleSaveModel objSaveModel = new UserRoleSaveModel();
            //if (objSaveModel.Save(pUserID, pIsActive, UserRoles, out _ErrorMsg))
            //{
            //    return true;
            //}

            return false;
        }

        /// <summary>
        /// For getting roleid of the current 
        /// user
        /// </summary>
        /// <param name="userid"></param>
        /// <returns></returns>
        public int GetRole(Int64 userid)
        {
            List<usp_GetRole_UserRole_Result> Role;
            using (EFContext ctx = new EFContext())
            {
                Role = (new List<usp_GetRole_UserRole_Result>(ctx.usp_GetRole_UserRole(userid)));
            }
            return Role[0].RoleID;
        }


        /// <summary>
        /// Manager name autocomplete
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteManagerName(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutocomplete_User_Result> spRes = new List<usp_GetAutocomplete_User_Result>(ctx.usp_GetAutocomplete_User(stats, 2));

                foreach (usp_GetAutocomplete_User_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }
        /// <summary>
        /// Manager name autocomplete(clinic)
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteManagerNameClinic(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutocompleteClinicNew_User_Result> spRes = new List<usp_GetAutocompleteClinicNew_User_Result>(ctx.usp_GetAutocompleteClinicNew_User(stats, 2));

                foreach (usp_GetAutocompleteClinicNew_User_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
        }



        # endregion

        #region Override Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(Nullable<global::System.Boolean> pIsActive)
        {

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_User_Result> lst = new List<usp_GetByAZ_User_Result>(ctx.usp_GetByAZ_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), SelManagerID, SearchName, pIsActive));

                foreach (usp_GetByAZ_User_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(global::System.Int64 pCurrPageNumber, Nullable<global::System.Boolean> pIsActive, global::System.Int16 pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                Users = new List<usp_GetBySearch_User_Result>(ctx.usp_GetBySearch_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), SelManagerID, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
                Roles = new List<usp_GetAgent_Role_Result>(ctx.usp_GetAgent_Role(Convert.ToByte(Role.WEB_ADMIN_ROLE_ID), Convert.ToByte(Role.MANAGER_ROLE_ID), UserID));
                UserRoles = new List<usp_GetByUserID_UserRole_Result>(ctx.usp_GetByUserID_UserRole(UserID));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    #endregion

    # region Save

    /// <summary>
    /// 
    /// </summary>
    public class UserRoleSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Get or set
        /// </summary>

        public usp_GetByPkId_UserRole_Result UserRoleResult
        {
            get;
            set;
        }

        public int UserID
        {
            get;
            set;
        }
        public string Comment
        {
            get;
            set;
        }
        public Byte RoleID
        {
            get;
            set;
        }
        public int UserRoleID
        {
            get;
            set;
        }
        public bool IsActive
        {
            get;
            set;
        }
        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UserRoleSaveModel()
        {
        }

        # endregion

        #region Abstract Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(int pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                UserRoleResult = (new List<usp_GetByPkId_UserRole_Result>(ctx.usp_GetByPkId_UserRole(pID, pIsActive))).FirstOrDefault();
            }

            EncryptAudit(UserRoleResult.UserRoleID, UserRoleResult.LastModifiedBy, UserRoleResult.LastModifiedOn);
        }
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

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pUserRoles"></param>
        /// <param name="errMsg"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive, List<usp_GetBySearch_UserRole_Result> pUserRoles, out global::System.String errMsg)
        {
            errMsg = string.Empty;

            ObjectParameter userRoleID = null;
            ObjectParameter PatientVisitID = null;
            usp_GetByPkId_UserRole_Result itemEdit = null;
            List<usp_GetByUserID_PatientVisit_Result> PatientVisit = null;

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                foreach (usp_GetBySearch_UserRole_Result item in pUserRoles)
                {
                    # region EA

                    errMsg = string.Empty;
                    userRoleID = null;
                    userRoleID = ObjParam("UserRoleID", typeof(global::System.Int64), item.USER_ROLE_ID_EA);


                    if (item.USER_ROLE_ID_EA == 0)
                    {
                        // New Rec

                        if (item.USER_ROLE_IS_ACTIVE_EA)
                        {
                            ctx.usp_Insert_UserRole(item.USER_ID, Convert.ToByte(Role.EA_ROLE_ID), string.Empty, pUserID, userRoleID); // Insert

                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }
                        }
                        else
                        {
                            // No Insert
                        }
                    }
                    else
                    {
                        // Update Exist Rec

                        itemEdit = (new List<usp_GetByPkId_UserRole_Result>(ctx.usp_GetByPkId_UserRole(item.USER_ROLE_ID_EA, pIsActive))).FirstOrDefault();
                        PatientVisit = new List<usp_GetByUserID_PatientVisit_Result>(ctx.usp_GetByUserID_PatientVisit(3, item.USER_ID, pIsActive));


                        if (itemEdit != null)
                        {


                            ctx.usp_Update_UserRole(itemEdit.UserID, itemEdit.RoleID, itemEdit.Comment, item.USER_ROLE_IS_ACTIVE_EA, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, userRoleID);

                            if (!item.USER_ROLE_IS_ACTIVE_EA)
                            {
                                foreach (usp_GetByUserID_PatientVisit_Result nwitem in PatientVisit)
                                {
                                    if (nwitem.AssignedTo != item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, nwitem.TargetBAUserID, nwitem.TargetQAUserID, null, nwitem.PatientVisitComplexity
                                            , pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);

                                    }
                                    else if (nwitem.ClaimStatusID == 19 && nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(Convert.ToByte(ClaimStatus.EA_GENERAL_QUEUE));
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, nwitem.TargetBAUserID, nwitem.TargetQAUserID, null, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                    else if (nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            null, nwitem.TargetBAUserID, nwitem.TargetQAUserID, null, nwitem.PatientVisitComplexity,
                                             pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }

                                }

                            }

                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }
                        }
                    }

                    # endregion

                    # region QA

                    errMsg = string.Empty;
                    userRoleID = null;
                    userRoleID = ObjParam("UserRoleID", typeof(global::System.Int64), item.USER_ROLE_ID_QA);

                    if (item.USER_ROLE_ID_QA == 0)
                    {
                        // New Rec

                        if (item.USER_ROLE_IS_ACTIVE_QA)
                        {
                            ctx.usp_Insert_UserRole(item.USER_ID, Convert.ToByte(Role.QA_ROLE_ID), string.Empty, pUserID, userRoleID); // Insert

                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }
                        }
                        else
                        {
                            // No Insert
                        }
                    }
                    else
                    {
                        // Update Exist Rec

                        itemEdit = (new List<usp_GetByPkId_UserRole_Result>(ctx.usp_GetByPkId_UserRole(item.USER_ROLE_ID_QA, pIsActive))).FirstOrDefault();
                        PatientVisit = new List<usp_GetByUserID_PatientVisit_Result>(ctx.usp_GetByUserID_PatientVisit(4, item.USER_ID, pIsActive));

                        if (itemEdit != null)
                        {
                            ctx.usp_Update_UserRole(itemEdit.UserID, itemEdit.RoleID, itemEdit.Comment, item.USER_ROLE_IS_ACTIVE_QA, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, userRoleID);

                            if (!item.USER_ROLE_IS_ACTIVE_QA)
                            {
                                foreach (usp_GetByUserID_PatientVisit_Result nwitem in PatientVisit)
                                {
                                    if (nwitem.AssignedTo != item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, nwitem.TargetBAUserID, null, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                    else if (nwitem.ClaimStatusID == 13 && nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(Convert.ToByte(ClaimStatus.QA_GENERAL_QUEUE));
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, nwitem.TargetBAUserID, nwitem.TargetQAUserID, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                    else if (nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            null, nwitem.TargetBAUserID, null, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                }

                            }

                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }

                        }
                    }

                    # endregion

                    # region BA

                    errMsg = string.Empty;
                    userRoleID = null;
                    userRoleID = ObjParam("UserRoleID", typeof(global::System.Int64), item.USER_ROLE_ID_BA);

                    if (item.USER_ROLE_ID_BA == 0)
                    {
                        // New Rec

                        if (item.USER_ROLE_IS_ACTIVE_BA)
                        {
                            ctx.usp_Insert_UserRole(item.USER_ID, Convert.ToByte(Role.BA_ROLE_ID), string.Empty, pUserID, userRoleID); // Insert


                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }
                        }
                        else
                        {
                            // No Insert
                        }
                    }
                    else
                    {
                        // Update Exist Rec

                        itemEdit = (new List<usp_GetByPkId_UserRole_Result>(ctx.usp_GetByPkId_UserRole(item.USER_ROLE_ID_BA, pIsActive))).FirstOrDefault();
                        PatientVisit = new List<usp_GetByUserID_PatientVisit_Result>(ctx.usp_GetByUserID_PatientVisit(5, item.USER_ID, pIsActive));

                        if (itemEdit != null)
                        {
                            ctx.usp_Update_UserRole(itemEdit.UserID, itemEdit.RoleID, itemEdit.Comment, item.USER_ROLE_IS_ACTIVE_BA, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, userRoleID);

                            if (!item.USER_ROLE_IS_ACTIVE_BA)
                            {
                                foreach (usp_GetByUserID_PatientVisit_Result nwitem in PatientVisit)
                                {
                                    if (nwitem.AssignedTo != item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, null, nwitem.TargetQAUserID, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);

                                    }
                                    else if (nwitem.ClaimStatusID == 4 && nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(Convert.ToByte(ClaimStatus.BA_GENERAL_QUEUE));
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                        , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            nwitem.AssignedTo, null, nwitem.TargetQAUserID, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                    else if (nwitem.AssignedTo == item.USER_ID)
                                    {
                                        StringBuilder sb = new StringBuilder();
                                        sb.Append("<PatVisits>");
                                        //
                                        sb.Append("<PatVisit>");
                                        sb.Append("<ClaimStsID>");
                                        sb.Append(nwitem.ClaimStatusID);
                                        sb.Append("</ClaimStsID>");
                                        sb.Append("<Cmnts>");
                                        sb.Append(nwitem.Comment);
                                        sb.Append("</Cmnts>");
                                        sb.Append("</PatVisit>");

                                        sb.Append("</PatVisits>");

                                        PatientVisitID = ObjParam("PatientVisitID", typeof(global::System.Int64), nwitem.PatientVisitID);
                                        ctx.usp_Update_PatientVisit(nwitem.PatientVisitID, nwitem.DOS, nwitem.IllnessIndicatorID, nwitem.IllnessIndicatorDate
                                            , nwitem.FacilityTypeID, nwitem.FacilityDoneID, nwitem.PrimaryClaimDiagnosisID, nwitem.DoctorNoteRelPath, nwitem.SuperBillRelPath, nwitem.PatientVisitDesc, sb.ToString(),
                                            null, null, nwitem.TargetQAUserID, nwitem.TargetEAUserID, nwitem.PatientVisitComplexity,
                                            pIsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, PatientVisitID);
                                    }
                                }

                            }

                            if (HasErr(userRoleID, ctx))
                            {
                                RollbackDbTrans(ctx);
                                errMsg = this.ErrorMsg;

                                return false;
                            }

                        }
                    }

                    # endregion
                }

                CommitDbTrans(ctx);
            }

            return true;
        }
        public bool Insert(int userid, int userclinicid)
        {
            using (EFContext ctx = new EFContext())
            {

                ObjectParameter userRoleID = ObjParam("UserRole");


                BeginDbTrans(ctx);

                ctx.usp_Insert_UserRole(UserID, RoleID, string.Empty, userid, userRoleID);

                if (HasErr(userRoleID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;

                }


                CommitDbTrans(ctx);
                return true;
            }
        }
        public bool Update(int userid, int userclinicid)
        {
            using (EFContext ctx = new EFContext())
            {
                ObjectParameter userRoleID = ObjParam("userRoleID", typeof(Int32), UserRoleResult.UserRoleID);

                BeginDbTrans(ctx);

                ctx.usp_Update_UserRole(UserRoleResult.UserID, UserRoleResult.RoleID, UserRoleResult.Comment, UserRoleResult.IsActive, LastModifiedBy, LastModifiedOn, userid, userRoleID);
                if (HasErr(userRoleID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                CommitDbTrans(ctx);
                return true;

            }

        }
        #endregion
    }


    # endregion

    # endregion

    #region TeamMembers

    #region Search



    /// <summary>
    /// 
    /// </summary>
    public class TeamMembersSearchModel : BaseSearchModel
    {
        # region Private Variables

        private global::System.String _ErrorMsg;

        # endregion

        # region Properties



        public global::System.Int32 ClinicID
        {
            get;
            set;
        }


        /// <summary>
        /// 
        /// </summary>
        /// 
        public List<usp_GetTeamMembers_User_Result> TeamMembers { get; set; }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String ErrorMsg
        {
            get
            {
                return _ErrorMsg;
            }
            set
            {
                _ErrorMsg = value;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> GetAutoCompleteUserID(string selText)
        {

            List<string> retRes = new List<string>();

            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutoComplete_User_Result> spRes = new List<usp_GetIDAutoComplete_User_Result>(ctx.usp_GetIDAutoComplete_User(selCode));

                foreach (usp_GetIDAutoComplete_User_Result item in spRes)
                {
                    retRes.Add(item.User_ID.ToString());
                }
            }

            return retRes;
        }







        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public TeamMembersSearchModel()
        {
        }

        #endregion



        #region Override Methods

        protected override void FillByAZ(bool? pIsActive)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                TeamMembers = new List<usp_GetTeamMembers_User_Result>(ctx.usp_GetTeamMembers_User(ClinicID));
            }
        }

        #endregion

        # region Private Method

        # endregion
    }

    #endregion


    #endregion

    #region AgentNameList

    public class AgentReportSearchModel : BaseSearchModel
    {
        # region Properties



        public List<usp_GetReportAgent_User_Result> UserResult
        {
            get;
            set;
        }

        public Nullable<int> UserID
        {
            get;
            set;
        }
        # endregion

        #region Abstract

        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetReportAZAgent_User_Result> lst = new List<usp_GetReportAZAgent_User_Result>(ctx.usp_GetReportAZAgent_User(UserID));

                foreach (usp_GetReportAZAgent_User_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                UserResult = new List<usp_GetReportAgent_User_Result>(ctx.usp_GetReportAgent_User(UserID, StartBy));
            }
        }

        #endregion

    }
    # endregion

    # region SummaryReportAgentModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportAgentModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumAgent_PatientVisit_Result> ReportSumAgentResults
        {
            get;
            set;
        }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumAgentComp_PatientVisit_Result> ReportSumAgentCompResults
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportAgentModel()
        {
        }

        # endregion

        # region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIS_BILLING"></param>
        /// <param name="pDATE_FROM"></param>
        /// <param name="pDATE_TO"></param>
        /// <returns></returns>
        public void FillJs(int UserID, Nullable<System.DateTime> dateFrom, Nullable<System.DateTime> dateTo)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumAgentResults = new List<usp_GetReportSumAgent_PatientVisit_Result>(ctx.usp_GetReportSumAgent_PatientVisit(UserID, dateFrom, dateTo));
            }
        }


        public void FillJsComp(int UserID, Nullable<System.DateTime> dateFrom, Nullable<System.DateTime> dateTo)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumAgentCompResults = new List<usp_GetReportSumAgentComp_PatientVisit_Result>(ctx.usp_GetReportSumAgentComp_PatientVisit(UserID, dateFrom, dateTo));
            }
        }

        # endregion
    }

    # endregion

    # region SummaryReportAgentWiseModel

    /// <summary>
    /// 
    /// </summary>
    public class SummaryReportAgentWiseModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetReportSumAgentWise_PatientVisit_Result> ReportSumAgentWiseResults
        {
            get;
            set;
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public SummaryReportAgentWiseModel()
        {
        }

        # endregion

        # region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIS_BILLING"></param>
        /// <param name="pDATE_FROM"></param>
        /// <param name="pDATE_TO"></param>
        /// <returns></returns>
        public void FillJs(int UserID, Nullable<System.DateTime> dateFrom, Nullable<System.DateTime> dateTo)
        {
            using (EFContext ctx = new EFContext())
            {
                ReportSumAgentWiseResults = new List<usp_GetReportSumAgentWise_PatientVisit_Result>(ctx.usp_GetReportSumAgentWise_PatientVisit(UserID, dateFrom, dateTo));
            }
        }
        # endregion


    }

    # endregion




}
