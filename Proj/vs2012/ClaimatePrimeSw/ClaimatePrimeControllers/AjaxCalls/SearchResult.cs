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
    public class SearchResult
    {
        #region Primitive Properties

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<long> ID
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String DISP1
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String DISP2
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.String DISP3
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public global::System.String DISP4
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public global::System.String DISP5
        {
            get;
            private set;
        }

        /// <summary>
        /// 
        /// </summary>
        [DataMember]
        public global::System.String DISP6
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public global::System.Boolean IsActive
        {
            get;
            private set;
        }

        /// <summary>
        /// Get
        /// </summary>
        [DataMember]
        public Nullable<bool> FLAG
        {
            get;
            private set;
        }

        #endregion

        # region Constructors

        # endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_City_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.CityID
                ,
                DISP1 = pResult.CityName
                ,
                DISP2 = pResult.ZipCode
                ,
                IsActive = pResult.IsActive
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_EDIFile_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.EDIFileID
                ,
                DISP1 = StaticClass.GetDateTimeStr(pResult.CreatedOn)
                ,
                DISP2 = pResult.X12FileRelPath
                ,
                DISP3 = pResult.RefFileRelPath

            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetByEDI_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {

                ID = pResult.PatientVisitID
                ,
                DISP1 = Convert.ToString(pResult.PatName)
                ,
                DISP2 = pResult.ChartNumber
                ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
                ,
                DISP4 = pResult.PatientVisitID.ToString()
                ,
                DISP5 = pResult.PatientVisitComplexity.ToString()


            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_EntityTypeQualifier_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.EntityTypeQualifierID
                ,
                DISP1 = pResult.EntityTypeQualifierName
                ,
                DISP2 = pResult.EntityTypeQualifierCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetAgent_Role_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.RoleID
                ,
                DISP1 = pResult.RoleName
                ,
                DISP2 = pResult.AgentUserRoleID.ToString()
                ,
                FLAG = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Insurance_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.InsuranceID
                ,
                DISP1 = pResult.InsuranceName
                ,
                DISP2 = pResult.InsuranceCode
                ,
                DISP3 = pResult.EDIReceiver
                ,
                DISP4 = pResult.PayerID
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Diagnosis_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.DiagnosisID
                ,
                DISP1 = pResult.DiagnosisCode
                ,
                DISP2 = pResult.Description
                ,
                DISP3 = pResult.ICDFormat.ToString()
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_DiagnosisGroup_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.DiagnosisGroupID
                ,
                DISP1 = pResult.DiagnosisGroupCode
                ,
                DISP2 = pResult.DiagnosisGroupDescription
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_CPT_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.CPTID
                ,
                DISP1 = pResult.CPTCode
                ,
                DISP2 = pResult.DESCRIPTION
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Provider_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ProviderID
                ,
                DISP1 = pResult.Name
                ,
                DISP2 = pResult.ProviderCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Specialty_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.SpecialtyID
                ,
                DISP1 = pResult.SpecialtyName
                ,
                DISP2 = pResult.SpecialtyCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_FacilityDone_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.FacilityDoneID
                ,
                DISP1 = pResult.FacilityDoneName
                ,
                DISP2 = pResult.FacilityDoneCode
                ,
                DISP3 = pResult.NPI
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Modifier_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ModifierID
                ,
                DISP1 = pResult.ModifierName
                ,
                DISP2 = pResult.ModifierCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_ClaimMedia_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ClaimMediaID
                ,
                DISP1 = pResult.ClaimMediaName
                ,
                DISP2 = pResult.ClaimMediaCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_IllnessIndicator_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.IllnessIndicatorID
                ,
                DISP1 = pResult.IllnessIndicatorName
                ,
                DISP2 = pResult.IllnessIndicatorCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        //public static explicit operator SearchResult(usp_GetBySearch_UsageIndicator_Result pResult)
        //{
        //    return (new SearchResult()
        //    {
        //        ID = pResult.UsageIndicatorID
        //        ,
        //        DISP1 = pResult.UsageIndicatorName
        //        ,
        //        DISP2 = pResult.UsageIndicatorCode
        //        ,
        //        IsActive = pResult.IsActive
        //    });
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_County_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.CountyID
                ,
                DISP1 = pResult.CountyName
                ,
                DISP2 = pResult.CountyCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Country_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.CountryID
                ,
                DISP1 = pResult.CountryName
                ,
                DISP2 = pResult.CountryCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_State_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.StateID
                ,
                DISP1 = pResult.StateName
                ,
                DISP2 = pResult.StateCode
                ,
                IsActive = pResult.IsActive
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_WebCulture_Result pResult)
        {
            return (new SearchResult()
            {
                ID = 0
                ,
                DISP1 = pResult.EnglishName
                ,
                DISP2 = pResult.NativeName

                ,
                DISP3 = pResult.KeyName
                ,
                IsActive = pResult.IsActive
            });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Clinic_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ClinicID
                ,
                DISP1 = pResult.ClinicName
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_Patient_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientID
                ,
                DISP1 = pResult.Name
                ,
                DISP2 = pResult.ChartNumber
                ,
                DISP3 = pResult.MedicareID
                ,
                IsActive = pResult.IsActive
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientVisitID
                ,
                DISP1 = pResult.Name
                ,
                DISP2 = pResult.ChartNumber
                ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
                ,
                DISP4 = pResult.PatientVisitComplexity.ToString()
                ,
                IsActive = pResult.IsActive
                ,
                FLAG = pResult.CAN_UN_BLOCK
            });
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearchCase_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientVisitID
                ,
                DISP1 = pResult.PatName
                ,
                DISP2 = pResult.PatChartNumber
                ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
                ,
                DISP4 = pResult.PatientVisitComplexity.ToString()


            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetUnAssigned_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientVisitID
                ,
                DISP1 = pResult.PatName
                ,
                DISP2 = pResult.PatChartNumber
                ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
                ,
                DISP4 = pResult.PatientVisitComplexity.ToString()
            });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_PatientHospitalization_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientHospitalizationID
               ,
                DISP1 = pResult.Name
               ,
                DISP2 = pResult.ChartNumber
                ,
                DISP3 = pResult.FacilityDoneName
                ,
                DISP4 = StaticClass.GetDateStr(pResult.AdmittedOn)
                ,
                DISP5 = pResult.DischargedOn.HasValue ? StaticClass.GetDateStr(pResult.DischargedOn.Value) : string.Empty
                ,
                IsActive = pResult.IsActive
            });
        }
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetBySearch_PatientDocument_Result pResult)
        {
            string filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", pResult.DocumentRelPath);
            if (!(System.IO.File.Exists(filePath)))
            {
                filePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NO_FILE_ICON);
            }
            ArivaSession.Sessions().FilePathsDotAdd(string.Concat("PatientDocumentID_", pResult.PatientDocumentID), filePath);

            return (new SearchResult()
            {
                ID = pResult.PatientDocumentID
                ,
                DISP1 = pResult.Name
                ,
                DISP2 = pResult.ChartNumber
                ,
                DISP3 = pResult.DocumentCategoryName
                ,
                DISP4 = string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("Document", "SearchFile")), "?ky=", pResult.PatientDocumentID)
                ,
                DISP5 = StaticClass.CanImg(System.IO.Path.GetExtension(pResult.DocumentRelPath)) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("Document", "SearchFilePreview")), "?ky=", pResult.PatientDocumentID)
                ,
                IsActive = pResult.IsActive
            });
        }
        /// 
        /// </summary>
        /// <param name="pResult"></param>
        /// <returns></returns>
        public static explicit operator SearchResult(usp_GetByPkId_DocumentCategory_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.DocumentCategoryID
               ,
                IsActive = pResult.IsInPatientRelated
            });
        }

        public static explicit operator SearchResult(usp_GetBySearch_ClaimProcess_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientVisitID
               ,
                DISP1 = pResult.PatName
               ,
                DISP2 = pResult.PatChartNumber
               ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
               ,
                DISP4 = pResult.PatientVisitComplexity.ToString()

            });
        }
        public static explicit operator SearchResult(usp_GetBySearchCaseReopen_ClaimProcess_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PatientVisitID
               ,
                DISP1 = pResult.PatName
               ,
                DISP2 = pResult.PatChartNumber
               ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
               ,
                DISP4 = pResult.PatientVisitComplexity.ToString()

            });
        }
        public static explicit operator SearchResult(usp_GetBySearch_User_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.UserID
               ,
                DISP1 = pResult.Name
               ,
                DISP2 = pResult.Email
                ,
                DISP3 = pResult.ManagerID.ToString()
                ,
                IsActive = pResult.IsActive
            });
        }
        public static explicit operator SearchResult(usp_GetByManagerID_Clinic_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ClinicID
               ,
                DISP1 = pResult.ClinicName
                ,
                DISP2 = pResult.AgentUserClinicID.ToString()
                ,
                FLAG = pResult.IsActive
            });
        }

        public static explicit operator SearchResult(usp_GetPrimeDxByID_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.PrimaryClaimDiagnosisID
               ,
                DISP1 = pResult.NAME_CODE
            });
        }


        public static explicit operator SearchResult(usp_GetNameByID_ClaimDiagnosis_Result pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.ClaimDiagnosisID
               ,
                DISP1 = pResult.NAME_CODE
            });
        }
        public static explicit operator SearchResult(usp_GetDashboardSummaryNIT_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.BLOCKED.ToString()
               ,
                DISP2 = pResult.NIT.ToString()
               ,
                DISP3 = pResult.TOTAL.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetClinicWiseSummaryNIT_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.BLOCKED.ToString()
               ,
                DISP2 = pResult.NIT.ToString()
               ,
                DISP3 = pResult.TOTAL.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetAgentWiseSummaryNIT_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.BLOCKED.ToString()
               ,
                DISP2 = pResult.NIT.ToString()
               ,
                DISP3 = pResult.TOTAL.ToString()
            });
        }

        public static explicit operator SearchResult(EDIFileSearchSubModel pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.EDIFileID
                ,
                DISP1 = pResult.FileDate
               ,
                DISP2 = string.IsNullOrWhiteSpace(pResult.RefFileSvrPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("EDIHistory", "ShowRefEDIFile")), "?ky=", pResult.EDIFileID)
               ,
                DISP3 = string.IsNullOrWhiteSpace(pResult.X12FileSvrPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("EDIHistory", "ShowX12EDIFile")), "?ky=", pResult.EDIFileID)
            });
        }

        public static explicit operator SearchResult(EDIRespondSearchSubModel pResult)
        {
            return (new SearchResult()
            {
                ID = pResult.EDIFileID
                ,
                DISP1 = pResult.FileDate
               ,
                DISP2 = string.IsNullOrWhiteSpace(pResult.RefFileSvrPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("EDIRespond", "ShowRefEDIFile")), "?ky=", pResult.EDIFileID)
               ,
                DISP3 = string.IsNullOrWhiteSpace(pResult.X12FileSvrPath) ? string.Empty : string.Concat((new UrlHelper(new HttpRequestWrapper(HttpContext.Current.Request).RequestContext)).RouteUrl(StaticClass.RouteValues("EDIRespond", "ShowX12EDIFile")), "?ky=", pResult.EDIFileID)
            });
        }

        public static explicit operator SearchResult(usp_GetDashboardVisit_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP5 = pResult.Sl_No.ToString()
                 ,
                ID = pResult.PatientVisitID
               ,
                DISP1 = pResult.Name
               ,
                DISP2 = pResult.ChartNumber
               ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
               ,
                DISP4 = pResult.PatientVisitComplexity.ToString()

            });
        }

        public static explicit operator SearchResult(usp_GetAgentWiseVisit_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP5 = pResult.Sl_No.ToString()
                 ,
                ID = pResult.PatientVisitID
               ,
                DISP1 = pResult.Name
               ,
                DISP2 = pResult.ChartNumber
               ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
               ,
                DISP4 = pResult.PatientVisitComplexity.ToString()

            });
        }

        public static explicit operator SearchResult(usp_GetClinicWiseVisit_PatientVisit_Result pResult)
        {
            return (new SearchResult()
            {
                DISP5 = pResult.Sl_No.ToString()
                 ,
                ID = pResult.PatientVisitID
               ,
                DISP1 = pResult.Name
               ,
                DISP2 = pResult.ChartNumber
               ,
                DISP3 = StaticClass.GetDateStr(pResult.DOS)
               ,
                DISP4 = pResult.PatientVisitComplexity.ToString()

            });
        }

        public static explicit operator SearchResult(DashBoardModel pResult)
        {
            return (new SearchResult()
            {
                DISP1 = string.IsNullOrWhiteSpace(pResult.UsersWithoutRoleCount.USER_ROLE_COUNT.ToString()) ? string.Empty : (pResult.UsersWithoutRoleCount.USER_ROLE_COUNT.ToString())
               ,
                DISP2 = string.IsNullOrWhiteSpace(pResult.UsersWithOutClinicCount.USER_COUNT.ToString()) ? string.Empty : (pResult.UsersWithOutClinicCount.USER_COUNT.ToString())
               ,
                DISP3 = string.IsNullOrWhiteSpace(pResult.ManagerWithoutAgentCount.MANAGER_COUNT.ToString()) ? string.Empty : (pResult.ManagerWithoutAgentCount.MANAGER_COUNT.ToString())
               ,
                DISP4 = string.IsNullOrWhiteSpace(pResult.ClinicsWithoutManagerCount.CLINIC_COUNT.ToString()) ? string.Empty : (pResult.ClinicsWithoutManagerCount.CLINIC_COUNT.ToString())
                ,
                DISP5 = string.IsNullOrWhiteSpace(pResult.AgentClinicCount.CLINIC_COUNT.ToString()) ? string.Empty : (pResult.AgentClinicCount.CLINIC_COUNT.ToString())
                ,
                DISP6 = string.IsNullOrWhiteSpace(pResult.ClinicsWithMultiManagerCount.CLINIC_COUNT.ToString()) ? string.Empty : (pResult.ClinicsWithMultiManagerCount.CLINIC_COUNT.ToString())
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationRole_UserRole_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.Email
               ,
                DISP2 = pResult.LastName
               ,
                DISP3 = pResult.FirstName
               ,
                DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                //,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationClinic_UserClinic_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.Email
               ,
                DISP2 = pResult.LastName
               ,
                DISP3 = pResult.FirstName
               ,
                DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                //,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationAgent_User_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.Email
               ,
                DISP2 = pResult.LastName
               ,
                DISP3 = pResult.FirstName
               ,
                DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                //,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationManager_UserClinic_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.ClinicName
               ,
                DISP2 = pResult.NPI
               ,
                DISP3 = pResult.ICDFormat.ToString()
                //,
                //DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                ////,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationMultiManager_UserClinic_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.ClinicName
               ,
                DISP2 = pResult.NPI
               ,
                DISP3 = pResult.ICDFormat.ToString()
                //,
                //DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                ////,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        public static explicit operator SearchResult(usp_GetNotificationAgentClinic_UserClinic_Result pResult)
        {
            return (new SearchResult()
            {
                DISP1 = pResult.ClinicName
               ,
                DISP2 = pResult.NPI
               ,
                DISP3 = pResult.ICDFormat.ToString()
                //,
                //DISP4 = string.IsNullOrWhiteSpace(pResult.MiddleName) ? string.Empty : (pResult.MiddleName)
                ////,
                //DISP5 = pResult.Sl_No.ToString()
            });
        }

        # endregion
    }
}
