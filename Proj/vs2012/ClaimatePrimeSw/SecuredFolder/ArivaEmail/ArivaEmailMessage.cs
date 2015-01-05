using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;

namespace ArivaEmail
{
    # region ArivaEmailMessage

    /// <summary>
    /// 
    /// </summary>
    public class ArivaEmailMessage
    {
        # region Private Variables

        private string _ErrMsg;
        private Int32 _AddrCnt;
        private Int32 _LoopCnt;

        # endregion

        # region Properties

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        public ArivaEmailMessage()
        {
            _ErrMsg = "The email has not been sent to the following addresses : ";
            _AddrCnt = 0;
            _LoopCnt = 0;
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pAddBccToSender">Default: false</param>
        /// <param name="pTo">Default: null</param>
        /// <param name="pCC">Default: null</param>
        /// <param name="pBcc">Default: null</param>
        /// <param name="pReplyTo">Default: null</param>
        /// <param name="pSubject">Default: string.Empty</param>
        /// <param name="pBody">Default: string.Empty</param>
        /// <param name="pAckBody">Default: string.Empty</param>
        /// <param name="pImageFullPath">Default: null</param>
        /// <param name="pAttachFileFullPath">Default: null</param>
        /// <returns>Error Message</returns>
        public string Send(bool pAddBccToSender, List<EmailAddress> pTo, List<EmailAddress> pCC, List<EmailAddress> pBcc, List<EmailAddress> pReplyTo, string pSubject, string pBody, string pAckBody, List<string> pImageFullPath, List<string> pAttachFileFullPath)
        {
            return Send(GetMailMessage(pTo, pCC, pBcc, pReplyTo, pSubject, pBody, pImageFullPath, pAttachFileFullPath), pAddBccToSender, pAckBody);
        }

        # endregion

        # region Private Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pTo">Default: null</param>
        /// <param name="pCC">Default: null</param>
        /// <param name="pBcc">Default: null</param>
        /// <param name="pReplyTo">Default: null</param>
        /// <param name="pSubject">Default: string.Empty</param>
        /// <param name="pBody">Default: string.Empty</param>
        /// <param name="pImageFullPath">Default: null</param>
        /// <param name="pAttachFileFullPath">Default: null</param>
        /// <returns></returns>
        private MailMessage GetMailMessage(List<EmailAddress> pTo, List<EmailAddress> pCC, List<EmailAddress> pBcc, List<EmailAddress> pReplyTo, string pSubject, string pBody, List<string> pImageFullPath, List<string> pAttachFileFullPath)
        {
            if (pTo == null)
            {
                pTo = new List<EmailAddress>();
            }

            if (pCC == null)
            {
                pCC = new List<EmailAddress>();
            }

            if (pBcc == null)
            {
                pBcc = new List<EmailAddress>();
            }

            if (pReplyTo == null)
            {
                pReplyTo = new List<EmailAddress>();
            }

            pReplyTo = new List<EmailAddress>(from oReplyTo in pReplyTo where (string.Compare(oReplyTo.Address, "donotreply@donotreply.com", true) != 0) select oReplyTo);

            MailMessage objMailMessage = new MailMessage();

            foreach (EmailAddress addr in pTo)
            {
                objMailMessage.To.Add((MailAddress)addr);
            }

            foreach (EmailAddress addr in pCC)
            {
                objMailMessage.CC.Add((MailAddress)addr);
            }

            foreach (EmailAddress addr in pBcc)
            {
                objMailMessage.Bcc.Add((MailAddress)addr);
            }

            foreach (EmailAddress addr in pReplyTo)
            {
                objMailMessage.ReplyToList.Add((MailAddress)addr);
            }

            objMailMessage.Subject = string.IsNullOrWhiteSpace(pSubject) ? "[no subject]" : pSubject;

            AlternateView objAlternateView = AlternateView.CreateAlternateViewFromString(pBody, null, "text/html");

            if (pImageFullPath != null)
            {
                Int32 loopCount = 0;

                foreach (string imageFullPath in pImageFullPath)
                {
                    string strImgFormat = imageFullPath.Substring(imageFullPath.LastIndexOf("."));
                    loopCount++;

                    LinkedResource objLinkedResource = new LinkedResource(imageFullPath, string.Concat("image/", strImgFormat.Substring(1)));
                    objLinkedResource.ContentId = string.Concat("image", loopCount);
                    objLinkedResource.TransferEncoding = System.Net.Mime.TransferEncoding.Base64;
                    objAlternateView.LinkedResources.Add(objLinkedResource);
                }
            }

            objMailMessage.AlternateViews.Add(objAlternateView);

            if (pAttachFileFullPath != null)
            {
                foreach (string attachFileFullPath in pAttachFileFullPath)
                {
                    objMailMessage.Attachments.Add(new Attachment(attachFileFullPath));
                }
            }

            objMailMessage.IsBodyHtml = true;

            return objMailMessage;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pMailMessage"></param>
        /// <param name="pAddBccToSender"></param>
        /// <param name="pAckBody"></param>
        /// <returns></returns>
        private string Send(MailMessage pMailMessage, bool pAddBccToSender, string pAckBody)
        {
            Int32 addrCnt;
            SmtpClient objSmtpClient = new SmtpClient();

            try
            {
                objSmtpClient.Credentials = CredentialCache.DefaultNetworkCredentials;

                if (pAddBccToSender)
                {
                    List<MailAddress> lstTmp = new List<MailAddress>(from oAddr in pMailMessage.To where string.Compare(oAddr.Address, pMailMessage.From.Address, true) == 0 select oAddr);

                    if (lstTmp.Count == 0)
                    {
                        lstTmp = new List<MailAddress>(from oAddr in pMailMessage.CC where string.Compare(oAddr.Address, pMailMessage.From.Address, true) == 0 select oAddr);
                    }

                    if (lstTmp.Count == 0)
                    {
                        lstTmp = new List<MailAddress>(from oAddr in pMailMessage.Bcc where string.Compare(oAddr.Address, pMailMessage.From.Address, true) == 0 select oAddr);
                    }

                    if (lstTmp.Count == 0)
                    {
                        pMailMessage.Bcc.Add(pMailMessage.From);
                    }
                }

                addrCnt = ((pMailMessage.To == null) ? 0 : pMailMessage.To.Count) +
                                        ((pMailMessage.CC == null) ? 0 : pMailMessage.CC.Count) +
                                        ((pMailMessage.Bcc == null) ? 0 : pMailMessage.Bcc.Count);

                if (_AddrCnt == 0)
                {
                    _AddrCnt = addrCnt;
                }

                if ((addrCnt == 0) && (_AddrCnt == 0))
                {
                    return "no email addresses";
                }
                else if (addrCnt == 0)
                {
                    return _ErrMsg.Substring(0, _ErrMsg.Length - 2);
                }
                else if ((_LoopCnt > 0) && (_AddrCnt == addrCnt))
                {
                    return "unexpected error";
                }

                objSmtpClient.Send(pMailMessage);

                if (pMailMessage.ReplyToList.Count > 0)
                {
                    pMailMessage.From = new MailAddress(string.Concat("donotreply@", pMailMessage.From.Address.Split(Convert.ToChar("@"))[1]), "donotreply");
                    pMailMessage.To.Clear();

                    foreach (MailAddress oReply in pMailMessage.ReplyToList)
                    {
                        pMailMessage.To.Add(oReply);
                    }

                    pMailMessage.CC.Clear();
                    pMailMessage.Bcc.Clear();
                    pMailMessage.ReplyToList.Clear();
                    pMailMessage.Subject = string.Concat("Acknowledgment : [", pMailMessage.Subject, "]");
                    pMailMessage.AlternateViews.Clear();
                    pMailMessage.Attachments.Clear();

                    AlternateView objAlternateView = AlternateView.CreateAlternateViewFromString(pAckBody, null, "text/html");
                    pMailMessage.AlternateViews.Add(objAlternateView);

                    Send(pMailMessage, false, string.Empty);
                }
            }
            catch (Exception ex)
            {
                string errMsg = ex.ToString();
                string errAddr = string.Empty;

                Int32 lessIndx = errMsg.IndexOf("<");
                Int32 atIndx = errMsg.IndexOf("@");
                Int32 greaterIndx = errMsg.IndexOf(">");

                if ((lessIndx > -1) && (atIndx > -1) && (greaterIndx > -1) & (atIndx > lessIndx) & (atIndx < greaterIndx))
                {
                    errAddr = errMsg.Substring((lessIndx + 1), (greaterIndx - (lessIndx + 1)));
                }
                else if ((errMsg.ToLower().Contains("unable to send to a recipient")) ||
                            (errMsg.ToLower().Contains("relay access denied")) ||
                            (errMsg.ToLower().Contains("transaction failed"))
                    )
                {
                    errMsg = ex.InnerException.Message;
                    lessIndx = errMsg.IndexOf("<");
                    atIndx = errMsg.IndexOf("@");
                    greaterIndx = errMsg.IndexOf(">");

                    if ((lessIndx > -1) && (atIndx > -1) && (greaterIndx > -1) & (atIndx > lessIndx) & (atIndx < greaterIndx))
                    {
                        errAddr = errMsg.Substring((lessIndx + 1), (greaterIndx - (lessIndx + 1)));
                    }
                }
                else
                {
                    return errMsg;
                }

                if (!(string.IsNullOrWhiteSpace(errAddr)))
                {
                    _ErrMsg = string.Concat(_ErrMsg, errAddr, ", ");

                    List<MailAddress> lstErr;

                    lstErr = new List<MailAddress>(from oAddr in pMailMessage.To where string.Compare(oAddr.Address, errAddr, true) == 0 select oAddr);

                    foreach (MailAddress oItem in lstErr)
                    {
                        pMailMessage.To.Remove(oItem);
                    }

                    lstErr = new List<MailAddress>(from oAddr in pMailMessage.CC where string.Compare(oAddr.Address, errAddr, true) == 0 select oAddr);

                    foreach (MailAddress oItem in lstErr)
                    {
                        pMailMessage.CC.Remove(oItem);
                    }

                    lstErr = new List<MailAddress>(from oAddr in pMailMessage.Bcc where string.Compare(oAddr.Address, errAddr, true) == 0 select oAddr);

                    foreach (MailAddress oItem in lstErr)
                    {
                        pMailMessage.Bcc.Remove(oItem);
                    }

                    _LoopCnt++;

                    Send(pMailMessage, false, pAckBody);
                }
                else
                {
                    return errMsg;
                }
            }
            finally
            {
                pMailMessage.Dispose();
                objSmtpClient.Dispose();
            }

            if (string.Compare(_ErrMsg, "The email has not been sent to the following addresses : ", true) == 0)
            {
                return string.Empty;
            }

            return _ErrMsg.Substring(0, _ErrMsg.Length - 2);
        }

        # endregion
    }

    # endregion

    # region EmailAddress

    /// <summary>
    /// 
    /// </summary>
    public class EmailAddress
    {
        # region Private Variables

        private string _Address;
        private string _DisplayName;

        # endregion

        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public string Address
        {
            get { return _Address; }
        }

        /// <summary>
        /// Get
        /// </summary>
        public string DisplayName
        {
            get { return _DisplayName; }
        }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pAddress"></param>
        /// <param name="pDisplayName"></param>
        public EmailAddress(string pAddress, string pDisplayName)
        {
            this._Address = pAddress;
            this._DisplayName = string.IsNullOrWhiteSpace(pDisplayName) ? pAddress : pDisplayName;
        }

        # endregion

        # region Public Operators

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pEmailAddress"></param>
        /// <returns></returns>
        public static explicit operator MailAddress(EmailAddress pEmailAddress)
        {
            return new MailAddress(pEmailAddress.Address, pEmailAddress.DisplayName);
        }

        # endregion
    }

    # endregion
}
