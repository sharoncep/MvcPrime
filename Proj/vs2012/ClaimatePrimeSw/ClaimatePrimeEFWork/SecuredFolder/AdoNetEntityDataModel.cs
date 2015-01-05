using System;
using System.Reflection;
using ClaimatePrimeConstants;

namespace ClaimatePrimeEFWork.EFContexts
{
    /// <summary>
    /// 
    /// </summary>
    public partial class EFContext : IDisposable
    {
        public EFContext()
            : base("name=EFContext")
        {
            if (RunMode.IsDebug)
            {
                OnContextCreated(Assembly.GetCallingAssembly().FullName);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCalledBy"></param>
        private void OnContextCreated(global::System.String pCalledBy)
        {
            // http://stackoverflow.com/questions/5478814/c-sharp-get-calling-methods-assembly
            if (!(pCalledBy.StartsWith("ClaimatePrimeModels", StringComparison.CurrentCultureIgnoreCase)))
            {
                throw new Exception(string.Concat("Sorry! Unauthorized call to EFContext from ", pCalledBy));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="disposing"></param>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                try
                {
                    if (!(((System.Data.Entity.Infrastructure.IObjectContextAdapter)this).ObjectContext.Connection.State == System.Data.ConnectionState.Closed))
                    {
                        ((System.Data.Entity.Infrastructure.IObjectContextAdapter)this).ObjectContext.Connection.Close();
                    }
                }
                catch
                {
                }

                try
                {
                    if (!(this.Database.Connection.State == System.Data.ConnectionState.Closed))
                    {
                        this.Database.Connection.Close();
                    }
                }
                catch
                {
                }
            }

            base.Dispose(disposing);
        }
    }
}
