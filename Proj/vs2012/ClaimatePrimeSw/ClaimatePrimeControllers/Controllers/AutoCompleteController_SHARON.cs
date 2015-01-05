using System.Web.Mvc;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeModels.Models;

namespace ClaimatePrimeControllers.Controllers
{
    public partial class AutoCompleteController
    {
        # region PasswordComplexity
        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        public ActionResult MinimumLength(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MinimumLength(stats) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stats"></param>
        /// <returns></returns>
        /// 
        public ActionResult MaximumLength(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MaximumLength(stats) };
        }

        public ActionResult UpperCaseMinCount(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).UpperCaseMinCount(stats) };
        }

        public ActionResult NumbersMinCount(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).NumbersMinCount(stats) };
        }

        public ActionResult SpecialCharMinCount(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).SpecialCharMinCount(stats) };
        }

        public ActionResult MaximumPassAge(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MaximumPassAge(stats) };
        }

        public ActionResult PassTrialMaxCount(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).PassTrialMaxCount(stats) };
        }

        public ActionResult HistoryPassReuseStat(string stats)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).HistoryPassReuseStat(stats) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public ActionResult MinimumLengthID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MinimumLengthID(selText) };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="selText"></param>
        /// <returns></returns>
        public ActionResult MaximumLengthID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MaximumLengthID(selText) };
        }

        public ActionResult UpperCaseMinCountID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).UpperCaseMinCountID(selText) };
        }
        public ActionResult NumbersMinCountID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).NumbersMinCountID(selText) };
        }
        public ActionResult SpecialCharMinCountID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).SpecialCharMinCountID(selText) };
        }
        public ActionResult MaximumPassAgeID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).MaximumPassAgeID(selText) };
        }
        public ActionResult PassTrialMaxCountID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).PassTrialMaxCountID(selText) };
        }
        public ActionResult HistoryPassReuseStatID(string selText)
        {
            return new JsonResultExtension { Data = (new PasswordConfigModel()).HistoryPassReuseStatID(selText) };
        }

        #endregion

        #region GeneralConfig

        public ActionResult PageLockIdleTimeInMin(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).PageLockIdleTimeInMin(stats) };
        }

        public ActionResult SearchRecordPerPage(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).SearchRecordPerPage(stats) };
        }

        public ActionResult SessionOutFromPageLockInMin(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).SessionOutFromPageLockInMin(stats) };
        }

        public ActionResult BACompleteFromDOSInDay(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).BACompleteFromDOSInDay(stats) };
        }

        public ActionResult QACompleteFromDOSInDay(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).QACompleteFromDOSInDay(stats) };
        }

        public ActionResult EDIFileSentFromDOSInDay(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).EDIFileSentFromDOSInDay(stats) };
        }

        public ActionResult ClaimDoneFromDOSInDay(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).ClaimDoneFromDOSInDay(stats) };
        }

        public ActionResult UploadMaxSizeInMB(string stats)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).UploadMaxSizeInMB(stats) };
        }

        // // // // //



        public ActionResult PageLockIdleTimeInMinID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).PageLockIdleTimeInMinID(selText) };
        }

        public ActionResult SearchRecordPerPageID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).SearchRecordPerPageID(selText) };
        }

        public ActionResult SessionOutFromPageLockInMinID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).SessionOutFromPageLockInMinID(selText) };
        }

        public ActionResult BACompleteFromDOSInDayID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).BACompleteFromDOSInDayID(selText) };
        }

        public ActionResult QACompleteFromDOSInDayID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).QACompleteFromDOSInDayID(selText) };
        }

        public ActionResult EDIFileSentFromDOSInDayID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).EDIFileSentFromDOSInDayID(selText) };
        }

        public ActionResult ClaimDoneFromDOSInDayID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).ClaimDoneFromDOSInDayID(selText) };
        }

        public ActionResult UploadMaxSizeInMBID(string selText)
        {
            return new JsonResultExtension { Data = (new GeneralConfigModel()).UploadMaxSizeInMBID(selText) };
        }

        #endregion

        # region Patient Visit

        public ActionResult ChartNo(string stats)
        {
            return new JsonResultExtension { Data = (new VisitChartModel()).ChartNumber(ArivaSession.Sessions().SelClinicID, stats) };
        }

        public ActionResult IllnessIndicator(string stats)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).IllnessIndicator(stats) };
        }

        public ActionResult FacilityType(string stats)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityType(stats) };
        }

        public ActionResult FacilityTypeClinic(string stats, string conti)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityDone(stats, conti) };
        }


        /////


        public ActionResult ChartNoID(string selText)
        {
            return new JsonResultExtension { Data = (new VisitChartModel()).ChartNumberID(ArivaSession.Sessions().SelClinicID, selText) };
        }

        public ActionResult IllnessIndicatorID(string selText)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).IllnessIndicatorID(selText) };
        }

        public ActionResult FacilityTypeID(string selText)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityTypeID(selText) };
        }

        public ActionResult FacilityTypeClinicID(string selText)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityDoneNameID(selText) };
        }

        #endregion

        #region AssignedClaims

        public ActionResult DiagName(string stats, string conti)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).DiagnosisName(ArivaSession.Sessions().SelClinicID, conti, stats) };
        }

        public ActionResult DiagNamePri(string stats, string conti)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).PrimDxName(ArivaSession.Sessions().PageEditID<long>(), conti, stats) };
        }

        public ActionResult DiagNamePro(string stats, string conti)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).ProcedureDxName(ArivaSession.Sessions().PageEditID<long>(), conti, stats) };
        }

        public ActionResult ProcCptName(string stats, string conti)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ProcedureCPTName(stats, conti) };
        }

        public ActionResult FacilityTypeName(string stats)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityType(stats) };
        }

        public ActionResult ModifierName1(string stats)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiName(stats) };
        }

        public ActionResult ModifierName2(string stats)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiName(stats) };
        }

        public ActionResult ModifierName3(string stats)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiName(stats) };
        }

        public ActionResult ModifierName4(string stats)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiName(stats) };
        }
        // //

        public ActionResult DiagNameID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).DiagnosisNameID(selText) };
        }

        public ActionResult DiagNamePriID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).PrimDxNameID(selText, ArivaSession.Sessions().PageEditID<long>()) };
        }

        public ActionResult DiagNameProID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimDiagnosisSaveModel()).PrimDxNameID(selText, ArivaSession.Sessions().PageEditID<long>()) };
        }

        public ActionResult ProcCptNameID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ProcedureCPTNameID(selText) };
        }

        public ActionResult FacilityTypeNameID(string selText)
        {
            return new JsonResultExtension { Data = (new PatientVisitSaveModel()).FacilityTypeID(selText) };
        }

        public ActionResult ModifierName1ID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiNameID(selText) };
        }

        public ActionResult ModifierName2ID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiNameID(selText) };
        }

        public ActionResult ModifierName3ID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiNameID(selText) };
        }

        public ActionResult ModifierName4ID(string selText)
        {
            return new JsonResultExtension { Data = (new ClaimCPTSaveModel()).ModiNameID(selText) };
        }
        #endregion
    }
}
