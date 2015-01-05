using System;
using System.Runtime.Serialization;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeEFWork;
using System.Web.Mvc;
using System.Web;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeConstants;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.AjaxCalls
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class FusionChart
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String X_AXIS_NAME
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int64 VISITS
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int64 IN_PROGRESS
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Int64 READY_TO_SEND
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public global::System.Int64 SENT
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public global::System.Int64 DONE
        {
            get;
            private set;
        }

        #endregion

        # region Constructors

        # endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumClinic_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumMnClinic_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumYrClinic_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSum_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumYr_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumMn_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumProvider_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumMnProvider_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumYrProvider_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumPatient_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumMnPatient_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumYrPatient_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.VISITS
                ,
                IN_PROGRESS = pResult.IN_PROGRESS
                ,
                READY_TO_SEND = pResult.READY_TO_SEND
                ,
                SENT = pResult.SENT
                ,
                DONE = pResult.DONE
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumAgent_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.CLAIMS
               
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumAgentComp_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = pResult.X_AXIS_NAME
                ,
                VISITS = pResult.CLAIMS

            });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator FusionChart(usp_GetReportSumAgentWise_PatientVisit_Result pResult)
        {
            return (new FusionChart()
            {
                X_AXIS_NAME = StaticClass.GetDateStr( pResult.X_AXIS_NAME)
                ,
                VISITS = pResult.VISITS

            });
        }




    }
}
