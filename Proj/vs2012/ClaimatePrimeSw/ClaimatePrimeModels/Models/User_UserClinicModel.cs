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

namespace ClaimatePrimeModels.Models
{
    #region Search

    /// <summary>
    /// 
    /// </summary>
    public class UserClinicSearchModel : BaseSearchModel
    {
        # region Private Variables

        private global::System.String _ErrorMsg;

        # endregion

        # region Properties

        /// <summary>
        /// 
        /// </summary>
        public global::System.String ManagerName
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public int? ManagerNameID
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
        /// Get or Set
        /// </summary>
        public List<UserClinicSearch> UserClinicSearchs
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
        public List<usp_GetBySearch_User_Result> Users { get; set; }

        /// <summary>
        /// Get or set
        /// </summary>
        public List<usp_GetByManagerID_Clinic_Result> ClinicNames { get; set; }

        public Int32 UserID { get; set; }


        # endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        public UserClinicSearchModel()
        {
        }

        #endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <param name="pIsActive"></param>
        /// <returns></returns>
        public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive)
        {
            UserClinicSaveModel objSaveModel = new UserClinicSaveModel();
            // objSaveModel.ManagerNameID = this.ManagerNameID;
            objSaveModel.Fill(pUserID, pIsActive);
            //if (objSaveModel.Save(pUserID, pIsActive, UserClinicSearchs, out _ErrorMsg))
            //{
            //    return true;
            //}

            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// 
        public List<string> GetAutoCompleteManagerName(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutocomplete_User_Result> spRes = new List<usp_GetAutocomplete_User_Result>(ctx.usp_GetAutocomplete_User(stats, null));

                foreach (usp_GetAutocomplete_User_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;
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
        /// 
        /// </summary>
        /// <returns></returns>
        public int? GetDefManagerID()
        {

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetManager_User_Result> spRes = new List<usp_GetManager_User_Result>(ctx.usp_GetManager_User(true));

                this.ManagerNameID = spRes[0].UserID;
                this.ManagerName = spRes[0].NAME_CODE;

            }


            return ManagerNameID;
        }

        # endregion

        #region Override Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_User_Result> lst = new List<usp_GetByAZ_User_Result>(ctx.usp_GetByAZ_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), ManagerNameID, SearchName, pIsActive));

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
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                Users = new List<usp_GetBySearch_User_Result>(ctx.usp_GetBySearch_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), ManagerNameID, SearchName, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
                ClinicNames = new List<usp_GetByManagerID_Clinic_Result>(ctx.usp_GetByManagerID_Clinic(this.ManagerNameID, UserID));
            }
            //by sharon

            //UserClinicSearchs = new List<UserClinicSearch>();

            //using (EFContext ctx = new EFContext())
            //{
            //List<usp_GetBySearch_User_Result> userNames = new List<usp_GetBySearch_User_Result>(ctx.usp_GetBySearch_User(SelHighRoleID, Convert.ToByte(Role.MANAGER_ROLE_ID), ManagerNameID, SearchName, StartBy, 1, 200, OrderByField, OrderByDirection, pIsActive));
            //List<usp_GetByManagerID_Clinic_Result> clinicNames = new List<usp_GetByManagerID_Clinic_Result>(ctx.usp_GetByManagerID_Clinic(this.ManagerNameID));

            //foreach (usp_GetBySearch_User_Result user in userNames)
            //{
            //    UserClinicSearch userClinicSearch = new UserClinicSearch() { USER_DISP_NAME = user.Name, USER_ID = user.UserID, UserClinicSearchSubs = new List<UserClinicSearchSub>() };

            //    foreach (usp_GetByManagerID_Clinic_Result clinic in clinicNames)
            //    {
            //        usp_GetByID_UserClinic_Result userClinic = (new List<usp_GetByID_UserClinic_Result>(ctx.usp_GetByID_UserClinic(user.UserID, clinic.ClinicID))).FirstOrDefault();

            //        if (userClinic == null)
            //        {
            //            userClinic = new usp_GetByID_UserClinic_Result();
            //        }

            //        userClinicSearch.UserClinicSearchSubs.Add(new UserClinicSearchSub() { IsActive = userClinic.IsActive, ClinicName = clinic.ClinicName, ClinicID = clinic.ClinicID, UserClinicID = userClinic.UserClinicID });
            //    }

            //    UserClinicSearchs.Add(userClinicSearch);
            //}
            //}

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
    public class UserClinicSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public global::System.Int32 ManagerNameID
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public global::System.Boolean IsActive
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public global::System.Int32 ClinicID
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public global::System.Int32 UserID
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public global::System.Int32 UserClinicID
        {
            get;
            set;
        }
        /// <summary>
        /// 
        /// </summary>
        public global::System.String Comment
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public usp_GetByPkId_UserClinic_Result UserClinicResult
        {
            get;
            set;
        }


        #endregion

        # region constructors

        /// <summary>
        /// 
        /// </summary>
        public UserClinicSaveModel()
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

        protected override void FillByID(int pID, bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                UserClinicResult = (new List<usp_GetByPkId_UserClinic_Result>(ctx.usp_GetByPkId_UserClinic(pID, pIsActive))).FirstOrDefault();
            }

            EncryptAudit(UserClinicResult.UserClinicID, UserClinicResult.LastModifiedBy, UserClinicResult.LastModifiedOn);
        }

        #endregion

        #region Public Methods

        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="pUserID"></param>
        ///// <param name="pIsActive"></param>
        ///// <param name="pUserRoles"></param>
        ///// <param name="errMsg"></param>
        ///// <returns></returns>
        //public bool Save(global::System.Int32 pUserID, Nullable<bool> pIsActive, List<UserClinicSearch> pUserClinicSearchs, out global::System.String errMsg)
        //{
        //    errMsg = string.Empty;
        //    ObjectParameter userClinicID = null;
        //    usp_GetByPkId_UserClinic_Result itemEdit = null;

        //    using (EFContext ctx = new EFContext())
        //    {
        //        BeginDbTrans(ctx);

        //        foreach (UserClinicSearch userClinicSearch in pUserClinicSearchs)
        //        {
        //            foreach (UserClinicSearchSub item in userClinicSearch.UserClinicSearchSubs)
        //            {
        //                errMsg = string.Empty;
        //                userClinicID = null;
        //                userClinicID = ObjParam("UserClinicID", typeof(global::System.Int64), item.UserClinicID);

        //                if (item.UserClinicID == 0)
        //                {
        //                    // New Rec

        //                    ctx.usp_Insert_UserClinic(userClinicSearch.USER_ID, item.ClinicID, string.Empty, pUserID, userClinicID); // Insert

        //                    if (HasErr(userClinicID, ctx))
        //                    {
        //                        RollbackDbTrans(ctx);
        //                        errMsg = this.ErrorMsg;

        //                        return false;
        //                    }
        //                }
        //                else
        //                {
        //                    // Update Exist Rec

        //                    itemEdit = (new List<usp_GetByPkId_UserClinic_Result>(ctx.usp_GetByPkId_UserClinic(item.UserClinicID, pIsActive))).FirstOrDefault();

        //                    if (itemEdit != null)
        //                    {
        //                        ctx.usp_Update_UserClinic(itemEdit.UserID, item.ClinicID, itemEdit.Comment, item.IsActive, itemEdit.LastModifiedBy, itemEdit.LastModifiedOn, pUserID, userClinicID);

        //                        if (HasErr(userClinicID, ctx))
        //                        {
        //                            RollbackDbTrans(ctx);
        //                            errMsg = this.ErrorMsg;

        //                            return false;
        //                        }
        //                    }
        //                }
        //            }
        //        }

        //        CommitDbTrans(ctx);
        //    }

        //    return true;
        //}

        public bool Insert(int userid, int userclinicid)
        {
            using (EFContext ctx = new EFContext())
            {

                ObjectParameter userClinicID = ObjParam("UserClinic");


                BeginDbTrans(ctx);

                ctx.usp_Insert_UserClinic(UserID, ClinicID, string.Empty, userid, userClinicID);

                if (HasErr(userClinicID, ctx))
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
                ObjectParameter userClinicID = ObjParam("userClinicID", typeof(Int32), UserClinicResult.UserClinicID);

                BeginDbTrans(ctx);

                ctx.usp_Update_UserClinic(UserClinicResult.UserID, UserClinicResult.ClinicID, UserClinicResult.Comment, UserClinicResult.IsActive, LastModifiedBy, LastModifiedOn, userid, userClinicID);
                if (HasErr(userClinicID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                CommitDbTrans(ctx);
                return true;

            }





        }
    }


        # endregion
    #endregion

    #region UserClinicSearch

    /// <summary>
    /// 
    /// </summary>
    public class UserClinicSearch
    {
        #region Properties

        public int USER_ID { get; set; }
        public string USER_DISP_NAME { get; set; }
        public string USER_EMAIL { get; set; }
        public bool USER_IS_ACTIVE { get; set; }

        public List<UserClinicSearchSub> UserClinicSearchSubs { get; set; }

        #endregion

        #region Constructor

        public UserClinicSearch()
        {
        }

        #endregion

        #region Public Method

        #endregion
    }

    #region UserClinicSearch

    /// <summary>
    /// 
    /// </summary>
    public class UserClinicSearchSub
    {
        #region Properties

        public string ClinicName { get; set; }
        public int ClinicID { get; set; }

        public long UserClinicID { get; set; }
        public bool IsActive { get; set; }

        #endregion

        #region Constructor

        public UserClinicSearchSub()
        {
        }

        #endregion

        #region Public Method

        #endregion
    }

    #endregion

    #endregion


}