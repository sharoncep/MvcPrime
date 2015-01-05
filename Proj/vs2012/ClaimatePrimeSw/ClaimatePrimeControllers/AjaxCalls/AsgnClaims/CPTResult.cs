using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using ClaimatePrimeEFWork.EFContexts;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
     /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class CPTResult
    {
        #region Primitive Properties
        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public decimal CHARGE_PER_UNIT  { get; private set; }

        #endregion

        # region Public Operators

        public static explicit operator CPTResult(usp_GetByPkId_CPT_Result pResult)
        {
            return (new CPTResult()
            {
                CHARGE_PER_UNIT = pResult.ChargePerUnit
            });
        }
        
        #endregion
    }
}
