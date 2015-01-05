using System;

namespace ClaimatePrimeConstants
{
    # region DateIntervals

    /// <summary>
    /// We can change the number value at any time. Becauase there is no relation between database.
    /// </summary>
    public enum DateIntervals
    {
        /// <summary>
        /// 
        /// </summary>
        UNDEFINED = 0,

        /// <summary>
        /// 
        /// </summary>
        DAY = 1,

        /// <summary>
        /// 
        /// </summary>
        DAYOFYEAR = 2,

        /// <summary>
        /// 
        /// </summary>
        HOUR = 3,

        /// <summary>
        /// 
        /// </summary>
        MINUTE = 4,

        /// <summary>
        /// 
        /// </summary>
        MONTH = 5,

        /// <summary>
        /// 
        /// </summary>
        QUARTER = 6,

        /// <summary>
        /// 
        /// </summary>
        SECOND = 7,

        /// <summary>
        /// 
        /// </summary>
        WEEKDAY = 8,

        /// <summary>
        /// 
        /// </summary>
        WEEKOFYEAR = 9,

        /// <summary>
        /// 
        /// </summary>
        YEAR = 10
    }

    # endregion

    # region Role

    /// <summary>
    /// 
    /// </summary>
    public enum Role
    {
        /// <summary>
        /// 
        /// </summary>
        WEB_ADMIN_ROLE_ID = 1,

        /// <summary>
        /// 
        /// </summary>
        MANAGER_ROLE_ID = 2,

        /// <summary>
        /// 
        /// </summary>
        EA_ROLE_ID = 3,

        /// <summary>
        /// 
        /// </summary>
        QA_ROLE_ID = 4,

        /// <summary>
        /// 
        /// </summary>
        BA_ROLE_ID = 5
    }

    # endregion

    # region Sex

    /// <summary>
    /// 
    /// </summary>
    public enum Sex
    {
        /// <summary>
        /// MALE
        /// </summary>
        M,

        /// <summary>
        /// FEMALE
        /// </summary>
        F,

        /// <summary>
        /// OTHER
        /// </summary>
        O
    }

    # endregion

    # region FacilityType

    /// <summary>
    /// 
    /// </summary>
    public enum FacilityType
    {
        /// <summary>
        /// OWN_CLINIC
        /// </summary>
        OFFICE = 10,

        /// <summary>
        /// 
        /// </summary>
        INPATIENT_HOSPITAL = 17
    }

    # endregion

    # region ClaimStatus

    /// <summary>
    /// 
    /// </summary>
    public enum ClaimStatus
    {
        /// <summary>
        /// 
        /// </summary>
        NEW_CLAIM = 1,

        /// <summary>
        /// 
        /// </summary>
        BA_GENERAL_QUEUE = 2,

        /// <summary>
        /// 
        /// </summary>
        BA_GENERAL_QUEUE_NOT_IN_TRACK = 3,

        /// <summary>
        /// 
        /// </summary>
        BA_PERSONAL_QUEUE = 4,

        /// <summary>
        /// 
        /// </summary>
        BA_PERSONAL_QUEUE_NOT_IN_TRACK = 5,

        /// <summary>
        /// 
        /// </summary>
        BA_HOLDED = 6,

        /// <summary>
        /// 
        /// </summary>
        HOLD_CLAIM = 7,

        /// <summary>
        /// 
        /// </summary>
        HOLD_CLAIM_NOT_IN_TRACK = 8,

        /// <summary>
        /// 
        /// </summary>
        UNHOLD_CLAIM = 9,

        /// <summary>
        /// 
        /// </summary>
        CREATED_CLAIM = 10,

        /// <summary>
        /// 
        /// </summary>
        QA_GENERAL_QUEUE = 11,

        /// <summary>
        /// 
        /// </summary>
        QA_GENERAL_QUEUE_NOT_IN_TRACK = 12,

        /// <summary>
        /// 
        /// </summary>
        QA_PERSONAL_QUEUE = 13,

        /// <summary>
        /// 
        /// </summary>
        QA_PERSONAL_QUEUE_NOT_IN_TRACK = 14,

        /// <summary>
        /// 
        /// </summary>
        REASSIGNED_BY_QA_TO_BA = 15,

        /// <summary>
        /// 
        /// </summary>
        READY_TO_SEND_CLAIM = 16,

        /// <summary>
        /// 
        /// </summary>
        EA_GENERAL_QUEUE = 17,

        /// <summary>
        /// 
        /// </summary>
        EA_GENERAL_QUEUE_NOT_IN_TRACK = 18,

        /// <summary>
        /// 
        /// </summary>
        EA_PERSONAL_QUEUE = 19,

        /// <summary>
        /// 
        /// </summary>
        EA_PERSONAL_QUEUE_NOT_IN_TRACK = 20,

        /// <summary>
        /// 
        /// </summary>
        REASSIGNED_BY_EA_TO_QA = 21,

        /// <summary>
        /// 
        /// </summary>
        EDI_FILE_CREATED = 22,

        /// <summary>
        /// 
        /// </summary>
        SENT_CLAIM = 23,

        /// <summary>
        /// 
        /// </summary>
        SENT_CLAIM_NOT_IN_TRACK = 24,

        /// <summary>
        /// 
        /// </summary>
        EDI_FILE_RESPONSED = 25,

        /// <summary>
        /// 
        /// </summary>
        REJECTED_CLAIM = 26,

        /// <summary>
        /// 
        /// </summary>
        REJECTED_CLAIM_NOT_IN_TRACK = 27,

        /// <summary>
        /// 
        /// </summary>
        REJECTED_CLAIM_REASSIGNED_BY_EA_TO_QA = 28,

        /// <summary>
        /// 
        /// </summary>
        ACCEPTED_CLAIM = 29,

        /// <summary>
        /// 
        /// </summary>
        DONE = 30
    }

    # endregion

    # region UserReport

    /// <summary>
    /// These values are hard coded in the stored procedure '[Audit].[usp_Insert_UserReport]' also
    /// </summary>
    public enum ExcelReportType
    {
        /// <summary>
        /// 
        /// </summary>
        CLINIC_REPORT = 1,

        /// <summary>
        /// 
        /// </summary>
        PROVIDER_REPORT = 2,

        /// <summary>
        /// 
        /// </summary>
        PATIENT_REPORT = 3,

        /// <summary>
        /// 
        /// </summary>
        AGENT_REPORT = 4
    }

    # endregion
}
