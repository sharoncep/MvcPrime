using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Objects;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
namespace ClaimatePrimeModels.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class PasswordConfigModel : BaseSaveModel
    {
        # region Properties

        public byte mMinLength { get; set; }
        public byte mMaxLength { get; set; }
        public byte mUpperCaseMinCount { get; set; }
        public byte mNumberMinCount { get; set; }
        public byte mSplCharCount { get; set; }
        public byte mExpiryDayMaxCount { get; set; }
        public byte mTrialMaxCount { get; set; }
        public byte mHistoryReuseStatus { get; set; }

        public byte mMinLengthID { get; set; }
        public byte mMaxLengthID { get; set; }
        public byte mUpperCaseMinCountID { get; set; }
        public byte mNumberMinCountID { get; set; }
        public byte mSplCharCountID { get; set; }
        public byte mExpiryDayMaxCountID { get; set; }
        public byte mTrialMaxCountID { get; set; }
        public byte mHistoryReuseStatusID { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public PasswordConfigModel()
        {
        }

        # endregion

        #region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(long pID, bool? pIsActive)
        {
            usp_GetByPkId_Password_Result PwdComplexity = null;
            using (EFContext ctx = new EFContext())
            {
                PwdComplexity = (new List<usp_GetByPkId_Password_Result>(ctx.usp_GetByPkId_Password(1, pIsActive))).FirstOrDefault();
            }

            if (PwdComplexity == null)
            {
                PwdComplexity = new usp_GetByPkId_Password_Result() { IsActive = true };
            }

            EncryptAudit(PwdComplexity.PasswordID, PwdComplexity.LastModifiedBy, PwdComplexity.LastModifiedOn);

            mMinLength = PwdComplexity.MinLength;
            mMaxLength = PwdComplexity.MaxLength;
            mUpperCaseMinCount = PwdComplexity.UpperCaseMinCount;
            mNumberMinCount = PwdComplexity.NumberMinCount;
            mSplCharCount = PwdComplexity.SplCharCount;
            mExpiryDayMaxCount = PwdComplexity.ExpiryDayMaxCount;
            mTrialMaxCount = PwdComplexity.TrialMaxCount;
            mHistoryReuseStatus = PwdComplexity.HistoryReuseStatus;

            mMinLengthID = mMinLength;
            mMaxLengthID = mMaxLength;
            mUpperCaseMinCountID = mUpperCaseMinCount;
            mNumberMinCountID = mNumberMinCount;
            mSplCharCountID = mSplCharCount;
            mExpiryDayMaxCountID = mExpiryDayMaxCount;
            mTrialMaxCountID = mTrialMaxCount;
            mHistoryReuseStatusID = mHistoryReuseStatus;


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
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                List<usp_GetAll_User_Result> spRess = new List<usp_GetAll_User_Result>(ctx.usp_GetAll_User(null));

                foreach (usp_GetAll_User_Result usr in spRess)
                {
                    ObjectParameter userID = ObjParam("UserID", typeof(global::System.Int64), usr.UserID);

                    usr.AlertChangePassword = true;

                    ctx.usp_Update_User(usr.UserName, usr.Password, usr.Email, usr.LastName, usr.MiddleName, usr.FirstName, usr.PhoneNumber, usr.ManagerID
                        , usr.PhotoRelPath, usr.AlertChangePassword, usr.Comment, usr.IsBlocked, usr.IsActive, usr.LastModifiedBy, usr.LastModifiedOn
                        , pUserID, userID);

                    if (HasErr(userID, ctx))
                    {
                        RollbackDbTrans(ctx);
                        return false;
                    }
                }

                ObjectParameter passwordID = ObjParam("Password");

                ctx.usp_Update_Password(mMinLength, mMaxLength, mUpperCaseMinCount
                    , mNumberMinCount, mSplCharCount, mExpiryDayMaxCount, mTrialMaxCount
                    , mHistoryReuseStatus, true, LastModifiedBy, LastModifiedOn, pUserID, passwordID);

                if (HasErr(passwordID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        #endregion

        # region PasswordComplexity

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> MinimumLength(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 7; i < 11; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> MaximumLength(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 11; i < 31; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> UpperCaseMinCount(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> NumbersMinCount(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> SpecialCharMinCount(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> MaximumPassAge(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 0; i < 181; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> PassTrialMaxCount(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 3; i < 11; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> HistoryPassReuseStat(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 0; i < 11; i++)
            {
                string res = i.ToString();

                if (res.StartsWith(stats, StringComparison.CurrentCultureIgnoreCase))
                {
                    retRes.Add(res);
                }
            }

            return retRes;
        }

        //

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> MinimumLengthID(string selText)
        {
            for (int i = 1; i < 8; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> MaximumLengthID(string selText)
        {

            for (int i = 7; i < 31; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> UpperCaseMinCountID(string selText)
        {

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> NumbersMinCountID(string selText)
        {

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> SpecialCharMinCountID(string selText)
        {

            for (int i = 0; i < 3; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> MaximumPassAgeID(string selText)
        {

            for (int i = 0; i < 181; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> PassTrialMaxCountID(string selText)
        {

            for (int i = 3; i < 11; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public List<string> HistoryPassReuseStatID(string selText)
        {

            for (int i = 0; i < 11; i++)
            {
                string res = i.ToString();

                if (string.Compare(selText, res, true) == 0)
                {
                    return ((new[] { res }).ToList<string>());
                }
            }

            return ((new[] { "0" }).ToList<string>());
        }

        # endregion
    }
}
