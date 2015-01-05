using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;


namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class StatusResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string CLAIM_STATUS_NAME { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string ASSIGNED_TO { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string STATUS_START_ON { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string STATUS_END_ON { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long START_END_MINS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long LOGOUT_LOGIN_MINS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long LOCK_UNLOCK_MINS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DURATION_MINS { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string COMMENT { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_PRINT_SRC_REF_FILE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string IMG_PRINT_X12_FILE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string EDI_CREATED_ON { get; private set; }
        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator StatusResult(usp_GetByPatientVisitID_ClaimProcess_Result pResult)
        {
            return (new StatusResult()
            {
                CLAIM_STATUS_NAME = Converts.AsEnum<ClaimStatus>(pResult.ClaimStatusID).ToString().Replace('_', ' ')
                ,
                ASSIGNED_TO = string.IsNullOrWhiteSpace(pResult.USER_NAME_CODE) ? string.Empty : (pResult.USER_NAME_CODE)
                ,
                STATUS_START_ON = StaticClass.GetDateTimeStr(pResult.StatusStartDate)
                ,
                STATUS_END_ON = StaticClass.GetDateTimeStr(pResult.StatusEndDate)
                ,
                DURATION_MINS = StaticClass.GetHourStr(pResult.DurationMins)
                ,
                COMMENT = string.IsNullOrWhiteSpace(pResult.Comment) ? string.Empty : (pResult.Comment)
                ,
                IMG_PRINT_SRC_REF_FILE = string.IsNullOrWhiteSpace(pResult.RefFileRelPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveRefFile")), "?ky=", pResult.ClaimProcessEDIFileID)
                ,
                IMG_PRINT_X12_FILE = string.IsNullOrWhiteSpace(pResult.X12FileRelPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SaveX12File")), "?ky=", pResult.ClaimProcessEDIFileID)
                ,
                EDI_CREATED_ON = StaticClass.GetDateStr(pResult.CreatedOn)
            });
        }

        # endregion



        
    }
}
