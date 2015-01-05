using System;

namespace ClaimatePrimeConstants
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class Constants
    {
        # region AppSettingsKeys

        /// <summary>
        /// 
        /// </summary>        
        public class AppSettingsKeys
        {
            public const string SQL_CACHE_DEPENDENCY = "EFContextCacheDependency";
            public const string FILE_SERVER_ROOT = "FileServerRootDir";
            public const string SITE_LOGO = "SiteLogo";

            public const string ERROR_EMAIL_SEND = "ErrorEmailSend";
            public const string ERROR_EMAIL_SUBJECT = "ErrorEmailSubject";
            public const string ERR_EMAIL_ADDR = "ERR_EMAIL_ADDR";
        }

        # endregion

        # region XMLSchema

        /// <summary>
        /// 
        /// </summary>
        [Serializable]
        public class XMLSchema
        {
            public const string NO_FILE_ICON = "NoFile.png";
            public const string NO_PHOTO_ICON = "NoPhoto.png";
            public const string PDF_ICON = "pdf_icon.png";
            public const string WORD_ICON = "word.png";
            public const string EXCEL_ICON = "excel.png";
            public const string ATTACHMENT_ICON = "attachment.png";
            public const string POWER_POINT_ICON = "ppt.png";
            public const string ZIP_ICON = "zip_rar.png";
            public const string NOTE_PAD_ICON = "notepad.png";
            public const string TIFF_ICON = "tiff_icon.png";
            public const string RTF_ICON = "rtf_icon.png";
            public const string EDI_ICON = "edi-icon.png";

            public const string NO_DOCTOR_NOTE = "NoDoctorNote.pdf";
            public const string NO_SUPER_BILL = "NoSuperbill.pdf";

            public const string FAV_ICO = "favicon.ico";
            public const string FAV_PNG = "favicon.png";
        }

        # endregion

        # region Others

        /// <summary>
        /// 
        /// </summary>

        public class Others
        {
            public const string ARIVA_SESSION = "_AS_";
            public const string ARIVA_COOKIE = "_AC_";

            public const Int32 WEB_ADMIN_USER_ID = 1;
        }

        # endregion
    }
}
