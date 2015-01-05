using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.Linq;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class LockUnLockSaveModel : BaseSaveModel
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public LockUnLockSaveModel()
        {
        }

        # endregion

        # region  Abstract Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        protected override void FillByID(byte pID, bool? pIsActive)
        {
            EncryptAudit(pID);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pUserID"></param>
        /// <returns></returns>
        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter lockUnLockID = ObjParam("LockUnLock");
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Insert_LockUnLock(pUserID, lockUnLockID);

                if (HasErr(lockUnLockID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
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
            ObjectParameter lockUnLockID = ObjParam("LockUnLock");
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);
                ctx.usp_Update_LockUnLock(pUserID, lockUnLockID);

                if (HasErr(lockUnLockID, ctx))
                {
                    RollbackDbTrans(ctx);
                    return false;
                }

                CommitDbTrans(ctx);
                return true;
            }
        }

        # endregion

        # region Public Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sessionTimeoutMin"></param>
        /// <param name="logInLogOutID"></param>
        /// <returns></returns>
        public static long GetSessTimeOutUsed(global::System.Byte sessionTimeoutMin, global::System.Int64 logInLogOutID)
        {
            if (logInLogOutID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    usp_GetStatus_Screen_Result spRes = (new List<usp_GetStatus_Screen_Result>(ctx.usp_GetStatus_Screen(sessionTimeoutMin, logInLogOutID))).FirstOrDefault();
                    return (spRes.SessTimeOutUsedSecs);
                }
            }

            return (sessionTimeoutMin * 60);
        }

        # endregion
    }
}
