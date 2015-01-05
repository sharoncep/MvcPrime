using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;

namespace ClaimatePrimeControllers.SecuredFolder.BaseControllers
{
    /// <summary>
    /// 
    /// </summary>
    [ArivaAuthorize]
    public abstract class BaseHighRoleController : BaseController
    {
        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public BaseHighRoleController()
        {
            ArivaSession.Sessions().ReSetRole();
        }

        # endregion
    }
}
