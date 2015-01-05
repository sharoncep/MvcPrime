using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

// http://www.satalketo.co.uk/vbnet-articles/how-to-encrypt-string-or-file-using-tripledes

namespace ArivaCryptorEngine
{
    /// <summary>
    /// http://www.satalketo.co.uk/vbnet-articles/how-to-encrypt-string-or-file-using-tripledes
    /// </summary>
    [Serializable]
    public class CryptorEngine
    {
        # region Private Variables

        private byte[] TheKey = new byte[24];
        private byte[] Vector = {
			0x12,
			0x44,
			0x16,
			0xee,
			0x88,
			0x15,
			0xdd,
			0x41

		};

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public CryptorEngine()
        {
            string password = "Syed Moshiur Murshed";

            if (password.Length <= 16)
            {
                password = password + "<~{},.#'/',(%(|\\'";
            }
            else if (password.Length <= 24)
            {
                password = password + "|`¬{:~\\^(£[";
                password = password.Substring(0, 24);
            }
            else
            {
                password = password.Substring(0, 24);
            }
            createKey(password);
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pInFile"></param>
        /// <param name="pOutFile"></param>
        public void Encrypt(string pInFile, string pOutFile)
        {
            if ((string.IsNullOrEmpty(pInFile)) || (string.IsNullOrEmpty(pOutFile)))
            {
                return;
            }

            FileStream fin = new FileStream(pInFile, FileMode.Open, FileAccess.Read);
            FileStream fout = new FileStream(pOutFile, FileMode.Create, FileAccess.Write);
            TripleDESCryptoServiceProvider tes = new TripleDESCryptoServiceProvider();

            performOnFile(fin, fout, tes.CreateEncryptor(TheKey, Vector));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pInFile"></param>
        /// <param name="pOutFile"></param>
        public void Decrypt(string pInFile, string pOutFile)
        {
            if ((string.IsNullOrEmpty(pInFile)) || (string.IsNullOrEmpty(pOutFile)))
            {
                return;
            }

            FileStream fin = new FileStream(pInFile, FileMode.Open, FileAccess.Read);
            FileStream fout = new FileStream(pOutFile, FileMode.Create, FileAccess.Write);
            TripleDESCryptoServiceProvider tes = new TripleDESCryptoServiceProvider();

            performOnFile(fin, fout, tes.CreateDecryptor(TheKey, Vector));
        }

        /// <summary>
        /// Encrypt a string using dual encryption method. Return a encrypted cipher Text
        /// </summary>
        /// <param name="toEncrypt"></param>
        /// <returns></returns>
        public string Encrypt(object toEncrypt)
        {
            return encryptString(Convert.ToString(toEncrypt));
        }

        /// <summary>
        /// DeCrypt a string using dual encryption method. Return a DeCrypted clear string
        /// </summary>
        /// <param name="cipherString"></param>
        /// <returns></returns>
        public string Decrypt(string cipherString)
        {
            return decryptString(cipherString);
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strKey"></param>
        private void createKey(string strKey)
        {
            // Byte array to hold key 
            byte[] arrByte = new byte[24];

            ASCIIEncoding AscEncod = new ASCIIEncoding();
            int i = 0;
            AscEncod.GetBytes(strKey, i, strKey.Length, arrByte, i);

            //Get the hash value of the password 
            SHA256Managed hashSha = new SHA256Managed();
            byte[] arrHash = hashSha.ComputeHash(arrByte);

            //put the hash value into the key 
            for (i = 0; i <= 23; i++)
            {
                TheKey[i] = arrHash[i];
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fin"></param>
        /// <param name="fout"></param>
        /// <param name="transformer"></param>
        private void performOnFile(FileStream fin, FileStream fout, ICryptoTransform transformer)
        {
            byte[] storage = new byte[4097];
            int readLen = 0;
            long totalBytesWritten = 8;
            TripleDESCryptoServiceProvider tes = new TripleDESCryptoServiceProvider();

            fout.SetLength(0);
            CryptoStream crstream = new CryptoStream(fout, transformer, CryptoStreamMode.Write);

            while (totalBytesWritten < fin.Length)
            {
                readLen = fin.Read(storage, 0, 4096);
                crstream.Write(storage, 0, readLen);
                totalBytesWritten = Convert.ToInt32(Convert.ToDouble(totalBytesWritten + readLen) / Convert.ToDouble(tes.BlockSize) * Convert.ToDouble(tes.BlockSize));
            }

            crstream.Close();
            fin.Close();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        private string encryptString(string Input)
        {
            if (string.IsNullOrEmpty(Input))
            {
                return string.Empty;
            }

            byte[] buffer = Encoding.UTF8.GetBytes(Input);
            TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
            des.Key = TheKey;
            des.IV = Vector;
            return Convert.ToBase64String(des.CreateEncryptor().TransformFinalBlock(buffer, 0, buffer.Length));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        private string decryptString(string Input)
        {
            if (string.IsNullOrEmpty(Input))
            {
                return string.Empty;
            }

            byte[] buffer = Convert.FromBase64String(Input);
            TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
            des.Key = TheKey;
            des.IV = Vector;
            return Encoding.UTF8.GetString(des.CreateDecryptor().TransformFinalBlock(buffer, 0, buffer.Length));
        }

        # endregion
    }
}
