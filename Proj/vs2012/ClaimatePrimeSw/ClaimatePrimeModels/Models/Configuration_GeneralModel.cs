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
    public class GeneralConfigModel : BaseSaveModel
    {
        # region Properties


        //

        public byte mSearchRecordPerPage { get; set; }
        public byte mUploadMaxSizeInMB { get; set; }
        public byte mPageLockIdleTimeInMin { get; set; }
        public byte mSessionOutFromPageLockInMin { get; set; }
        public byte mBACompleteFromDOSInDay { get; set; }
        public byte mQACompleteFromDOSInDay { get; set; }
        public byte mEDIFileSentFromDOSInDay { get; set; }
        public byte mClaimDoneFromDOSInDay { get; set; }
        public string mUserAccEmailSubject { get; set; }

        public byte mSearchRecordPerPageID { get; set; }
        public byte mUploadMaxSizeInMBID { get; set; }
        public byte mPageLockIdleTimeInMinID { get; set; }
        public byte mSessionOutFromPageLockInMinID { get; set; }
        public byte mBACompleteFromDOSInDayID { get; set; }
        public byte mQACompleteFromDOSInDayID { get; set; }
        public byte mEDIFileSentFromDOSInDayID { get; set; }
        public byte mClaimDoneFromDOSInDayID { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public GeneralConfigModel()
        {
        }

        # endregion

        # region Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(global::System.Int64 pID, Nullable<bool> pIsActive)
        {
            usp_GetByPkId_General_Result getAllGen = null;

            using (EFContext ctx = new EFContext())
            {
                getAllGen = (new List<usp_GetByPkId_General_Result>(ctx.usp_GetByPkId_General(1, pIsActive))).FirstOrDefault();
            }

            if (getAllGen == null)
            {
                getAllGen = new usp_GetByPkId_General_Result() { IsActive = true };
            }

            EncryptAudit(getAllGen.GeneralID, getAllGen.LastModifiedBy, getAllGen.LastModifiedOn);

            //

            mSearchRecordPerPage = getAllGen.SearchRecordPerPage;
            mUploadMaxSizeInMB = getAllGen.UploadMaxSizeInMB;
            mPageLockIdleTimeInMin = getAllGen.PageLockIdleTimeInMin;
            mSessionOutFromPageLockInMin = getAllGen.SessionOutFromPageLockInMin;
            mBACompleteFromDOSInDay = getAllGen.BACompleteFromDOSInDay;
            mQACompleteFromDOSInDay = getAllGen.QACompleteFromDOSInDay;
            mEDIFileSentFromDOSInDay = getAllGen.EDIFileSentFromDOSInDay;
            mClaimDoneFromDOSInDay = getAllGen.ClaimDoneFromDOSInDay;
            mUserAccEmailSubject = getAllGen.UserAccEmailSubject;
            //
            mSearchRecordPerPageID = mSearchRecordPerPage;
            mUploadMaxSizeInMBID = mUploadMaxSizeInMB;
            mPageLockIdleTimeInMinID = mPageLockIdleTimeInMin;
            mSessionOutFromPageLockInMinID = mSessionOutFromPageLockInMin;
            mBACompleteFromDOSInDayID = mBACompleteFromDOSInDay;
            mQACompleteFromDOSInDayID = mQACompleteFromDOSInDay;
            mEDIFileSentFromDOSInDayID = mEDIFileSentFromDOSInDay;
            mClaimDoneFromDOSInDayID = mClaimDoneFromDOSInDay;

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
            ObjectParameter generalID = ObjParam("General");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ctx.usp_Update_General(mUserAccEmailSubject, mSearchRecordPerPageID, mUploadMaxSizeInMBID, mPageLockIdleTimeInMinID
                    , mSessionOutFromPageLockInMinID, mBACompleteFromDOSInDayID, mQACompleteFromDOSInDayID, mEDIFileSentFromDOSInDayID
                    , mClaimDoneFromDOSInDayID, null, true, LastModifiedBy, LastModifiedOn, pUserID, generalID);

                if (HasErr(generalID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }
                else
                {
                    CommitDbTrans(ctx);
                }
            }

            return true;
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static GeneralConfigModel GetGeneralConfig()
        {
            GeneralConfigModel retAns = new GeneralConfigModel();
            retAns.Fill(true);

            return retAns;
        }

        #endregion

        # region GeneralConfig

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public List<string> PageLockIdleTimeInMin(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 11; i++)
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
        public List<string> SearchRecordPerPage(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 10; i < 301; i++)
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
        public List<string> SessionOutFromPageLockInMin(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 3; i < 256; i++)
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
        public List<string> BACompleteFromDOSInDay(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 202; i++)
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
        public List<string> QACompleteFromDOSInDay(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 202; i++)
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
        public List<string> EDIFileSentFromDOSInDay(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 202; i++)
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
        public List<string> ClaimDoneFromDOSInDay(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 302; i++)
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
        public List<string> UploadMaxSizeInMB(string stats)
        {
            stats = stats.Trim();

            List<string> retRes = new List<string>();

            for (int i = 1; i < 46; i++)
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
        public List<string> PageLockIdleTimeInMinID(string selText)
        {

            for (int i = 1; i < 11; i++)
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
        public List<string> SearchRecordPerPageID(string selText)
        {

            for (int i = 10; i < 301; i++)
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
        public List<string> SessionOutFromPageLockInMinID(string selText)
        {

            for (int i = 3; i < 256; i++)
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
        public List<string> BACompleteFromDOSInDayID(string selText)
        {

            for (int i = 1; i < 202; i++)
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
        public List<string> QACompleteFromDOSInDayID(string selText)
        {

            for (int i = 1; i < 202; i++)
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
        public List<string> EDIFileSentFromDOSInDayID(string selText)
        {

            for (int i = 1; i < 202; i++)
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
        public List<string> ClaimDoneFromDOSInDayID(string selText)
        {

            for (int i = 1; i < 302; i++)
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
        public object UploadMaxSizeInMBID(string selText)
        {

            for (int i = 1; i < 46; i++)
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
