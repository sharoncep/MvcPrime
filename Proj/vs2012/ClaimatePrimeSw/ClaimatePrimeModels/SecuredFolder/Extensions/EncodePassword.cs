using System;
using System.Security.Cryptography;
using System.Text;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeModels.SecuredFolder.Extensions
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public static class EncodePassword
    {
        #region Properties

        #endregion

        #region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <remarks></remarks>
        static EncodePassword()
        {
        }

        #endregion

        # region Public Methods

        /// <summary>
        /// http://www.rqna.net/qna/ysmzq-drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile.html
        /// 
        /// http://stackoverflow.com/questions/13527277/drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile
        /// 
        /// http://forums.asp.net/t/1336657.aspx
        /// </summary>
        /// <param name="pPwd"></param>
        /// <returns></returns>
        public static string PasswordSHA1(string pPwd)
        {
            // http://www.rqna.net/qna/ysmzq-drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile.html
            // 
            // http://stackoverflow.com/questions/13527277/drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile
            // 
            // http://forums.asp.net/t/1336657.aspx

            SHA1 algorithm = SHA1.Create();
            byte[] data = algorithm.ComputeHash(Encoding.UTF8.GetBytes(pPwd));
            string sh1 = "";
            for (int i = 0; i < data.Length; i++)
            {
                sh1 += data[i].ToString("x2").ToUpperInvariant();
            }

            return sh1.ToLower();
        }

        /// <summary>
        /// http://www.rqna.net/qna/ysmzq-drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile.html
        /// 
        /// http://stackoverflow.com/questions/13527277/drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile
        /// 
        /// http://forums.asp.net/t/1336657.aspx
        /// </summary>
        /// <param name="pSeed"></param>
        /// <param name="pPwd"></param>
        /// <returns></returns>
        public static string PasswordSHA1(string pSeed, string pPwd)
        {
            // http://www.rqna.net/qna/ysmzq-drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile.html
            // 
            // http://stackoverflow.com/questions/13527277/drop-in-replacement-for-formsauthentication-hashpasswordforstoringinconfigfile
            // 
            // http://forums.asp.net/t/1336657.aspx

            return PasswordSHA1(string.Concat(pSeed, pPwd));
        }

        # endregion
    }
}
