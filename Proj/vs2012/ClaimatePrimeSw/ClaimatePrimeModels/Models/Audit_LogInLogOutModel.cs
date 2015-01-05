using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
namespace ClaimatePrimeModels.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class Audit_LogInLogOutModel : BaseModel
    {
        # region Properties

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Audit_LogInLogOutModel()
        {
        }

        # endregion

        # region Public Methods

        # endregion
    }

    /// <summary>
    /// 
    /// </summary>
    public class LoginAttemptsModel : BaseModel
    {
        # region Properties
        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetRecent_LogInLogOut_Result> RecentLogin
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetRecent_LogInTrial_Result> RecentTrials
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetRecent_LockUnLock_Result> RecentLockUnLock
        {
            get;
            set;
        }
        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public LoginAttemptsModel()
        {
        }

        # endregion

        # region Public Methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userName"></param>
        public void GetRecentLogInTrial(global::System.String userName)
        {
            using (EFContext ctx = new EFContext())
            {
                RecentTrials = new List<usp_GetRecent_LogInTrial_Result>(ctx.usp_GetRecent_LogInTrial(userName));
                return;
            }
        }

        public void GetRecentLogInLogOut(Nullable<global::System.Int32> userID)
        {
            using (EFContext ctx = new EFContext())
            {
                RecentLogin = new List<usp_GetRecent_LogInLogOut_Result>(ctx.usp_GetRecent_LogInLogOut(userID));
                return;
            }
        }

        public void GetRecentLockUnLock(Nullable<global::System.Int32> userID)
        {
            using (EFContext ctx = new EFContext())
            {
                RecentLockUnLock = new List<usp_GetRecent_LockUnLock_Result>(ctx.usp_GetRecent_LockUnLock(userID));
                return;
            }
        }
        # endregion
    }
}
