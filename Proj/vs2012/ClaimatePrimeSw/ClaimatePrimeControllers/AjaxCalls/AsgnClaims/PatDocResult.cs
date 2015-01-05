using System;
using System.Runtime.Serialization;
using System.Web;
using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.Models;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeConstants;

namespace ClaimatePrimeControllers.AjaxCalls.AsgnClaims
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    [DataContractAttribute]
    public class PatDocResult
    {
        #region Primitive Properties


        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_DOCUMENT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public long PATIENT_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public byte DOCUMENT_CATEGORY_ID { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string SERVICE_DATE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string TO_DATE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string NAME_CODE { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DOC_SRC_PREVIEW { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public string DOC_SRC { get; private set; }

        #endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator PatDocResult(usp_GetByPatientID_PatientDocument_Result pResult)
        {
            return (new PatDocResult()
            {

                NAME_CODE = pResult.NAME_CODE
                ,
                SERVICE_DATE = StaticClass.GetDateStr(pResult.ServiceOrFromDate)
                ,
                TO_DATE = pResult.ToDate.HasValue ? StaticClass.GetDateStr(pResult.ToDate) : string.Empty
                ,
                DOC_SRC_PREVIEW = StaticClass.CanImg(System.IO.Path.GetExtension(pResult.DocumentRelPath))
                ? string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SavePatDoc")), "?ky=", pResult.PatientDocumentID)
                : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SavePatDocPreview")), "?ky=", pResult.PatientDocumentID)
                ,
                DOC_SRC = string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues((ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.BA_ROLE_ID) ? "AssgnClaims" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.QA_ROLE_ID) ? "AssgnClaimsQ" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.EA_ROLE_ID) ? "AssgnClaimsE" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID) ? "Dashboard" : (ArivaSession.Sessions().SelRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID) ? "Dashboard" : string.Empty))))), "SavePatDoc")), "?ky=", pResult.PatientDocumentID)
            });
        }

        # endregion
    }
}
