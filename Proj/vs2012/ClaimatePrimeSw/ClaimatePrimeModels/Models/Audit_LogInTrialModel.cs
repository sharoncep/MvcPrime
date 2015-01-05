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
    public class Audit_LogInTrialAuditModel:BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetRecent_LogInTrial_Result> RecentTrials
        {
            get;
            set;
        }
        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public Audit_LogInTrialAuditModel()
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
        # endregion

    }


}
