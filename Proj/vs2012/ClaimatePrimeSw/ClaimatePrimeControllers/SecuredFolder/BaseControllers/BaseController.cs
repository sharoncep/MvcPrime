using System;
using System.Globalization;
using System.IO;
using System.Threading;
using System.Web.Mvc;
using System.Web.Routing;
using ClaimatePrimeConstants;
using ClaimatePrimeControllers.SecuredFolder.BinaryFiles;
using ClaimatePrimeControllers.SecuredFolder.Extensions;
using ClaimatePrimeControllers.SecuredFolder.SessionClasses;
using ClaimatePrimeControllers.SecuredFolder.StaticClasses;
using ClaimatePrimeModels.SecuredFolder.BaseModels;

namespace ClaimatePrimeControllers.SecuredFolder.BaseControllers
{
    /// <summary>
    /// http://stackoverflow.com/questions/12948156/asp-net-mvc-how-to-disable-automatic-caching-option
    /// </summary>
    [ArivaAuthorize]
    [OutputCacheAttribute(VaryByParam = "*", Duration = 0, NoStore = true)]
    public abstract class BaseController : Controller
    {
        // http://stackoverflow.com/questions/12948156/asp-net-mvc-how-to-disable-automatic-caching-option

        # region Private Variables

        # endregion

        # region Protected Variables

        # endregion

        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        protected UInt32 ViewBagDotPgKey
        {
            get
            {
                return ViewBag.PgKey;
            }
            set
            {
                ViewBag.PgKey = value;
            }
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        protected UInt32 ViewBagDotSuccMsg
        {
            get
            {
                return ViewBag.SuccMsg;
            }
            set
            {
                ViewBag.SuccMsg = value;
                ViewBag.ErrMsg = 0;
            }
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        protected UInt32 ViewBagDotErrMsg
        {
            get
            {
                return ViewBag.ErrMsg;
            }
            set
            {
                ViewBag.SuccMsg = 0;
                ViewBag.ErrMsg = value;
            }
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        protected global::System.Boolean IsPatSessReq { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// http://forums.asp.net/t/1765544.aspx/1
        /// </summary>
        public BaseController()
        {
        }

        # endregion

        # region Protected Methods

        /// <summary>
        /// 
        /// </summary>
        protected void ViewBagDotReset()
        {
            ViewBagDotErrMsg = 0;
            ViewBagDotSuccMsg = 0;
        }

        /// <summary>
        /// 
        /// </summary>
        protected System.Nullable<global::System.Boolean> IsActive()
        {
            System.Nullable<global::System.Boolean> retAns = null;

            if (!((ArivaSession.Sessions().HighRoleID == Convert.ToByte(Role.WEB_ADMIN_ROLE_ID)) ||
                (ArivaSession.Sessions().HighRoleID == Convert.ToByte(Role.MANAGER_ROLE_ID))))
            {
                retAns = true;
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        protected System.Nullable<global::System.Boolean> IsActive(global::System.Boolean pIsActive)
        {
            System.Nullable<global::System.Boolean> retAns = pIsActive;

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pBaseModel"></param>
        /// <returns></returns>
        protected PartialViewResult ResponseDotRedirect()
        {
            return PartialView();
        }

        /// <summary>
        /// http://blogs.msdn.com/b/simonince/archive/2010/05/05/asp-net-mvc-s-html-helpers-render-the-wrong-value.aspx?utm_medium=Twitter&utm_source=Shared
        /// </summary>
        /// <param name="pBaseModel"></param>
        /// <returns></returns>
        protected PartialViewResult ResponseDotRedirect(BaseModel pBaseModel)
        {
            ModelState.Clear();
            return PartialView(pBaseModel);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <returns></returns>
        protected RedirectToRouteResult ResponseDotRedirect(string pController)
        {
            return ResponseDotRedirect(pController, "Search", 0, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <returns></returns>
        protected RedirectToRouteResult ResponseDotRedirect(string pController, string pAction)
        {
            return ResponseDotRedirect(pController, pAction, 0, 0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="pStartBy">pVal1 ==> A To Z</param>
        /// <param name="pVal2"></param>
        /// <returns></returns>
        protected RedirectToRouteResult ResponseDotRedirect(string pController, string pAction, string pStartBy, UInt32 pVal2)
        {
            uint val1 = 0;

            for (int i = 0; i < StaticClass.AtoZ.Length; i++)
            {
                if (string.Compare(StaticClass.AtoZ[i], pStartBy, true) == 0)
                {
                    val1 = Convert.ToUInt32(i);
                    break;
                }
            }

            return ResponseDotRedirect(pController, pAction, val1, pVal2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pController"></param>
        /// <param name="pAction"></param>
        /// <param name="val1">For DB or Page Operations</param>
        /// <param name="val2">For Success or Error Message</param>
        /// <returns></returns>
        protected RedirectToRouteResult ResponseDotRedirect(string pController, string pAction, UInt32 pVal1, UInt32 pVal2)
        {
            return RedirectToActionPermanent(pAction, StaticClass.RouteValues(pController, pAction, pVal1, pVal2));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="val1">For DB or Page Operations</param>
        /// <param name="val2">For Success or Error Message</param>
        protected void ResponseDotMessage(out UInt32 val1, out UInt32 val2)
        {
            StaticClass.RouteDatas(base.RouteData, out val1, out val2);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pFilePath"></param>
        /// <returns></returns>
        protected FilePathResult ResponseDotFile(string pFilePath)
        {
            string[] fileDisplayName = pFilePath.Split(Convert.ToChar(@"\"));
            int arrLen = fileDisplayName.Length;

            return ResponseDotFile(pFilePath, fileDisplayName[arrLen - 1]);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pFilePath"></param>
        /// <param name="pFileDisplayName"></param>
        /// <returns></returns>
        protected FilePathResult ResponseDotFile(string pFilePath, string pFileDisplayName)
        {
            return (new FilePathResult(pFilePath, StaticClass.GetFileContentType(Path.GetExtension(pFilePath))) { FileDownloadName = pFileDisplayName });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pFilePath"></param>
        /// <returns></returns>
        protected FilePathResult ResponseDotFilePreview(string pFilePath)
        {
            string extn = Path.GetExtension(pFilePath);

            if (StaticClass.CanImg(extn))
            {
                return ResponseDotFile(pFilePath);
            }

            if ((string.Compare(extn, ".xls", true) == 0)
                || (string.Compare(extn, ".xlsx", true) == 0))
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.EXCEL_ICON);
            }
            else if (string.Compare(extn, ".txt", true) == 0)
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.NOTE_PAD_ICON);
            }
            else if (string.Compare(extn, ".pdf", true) == 0)
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.PDF_ICON);
            }
            else if ((string.Compare(extn, ".ppt", true) == 0)
                || (string.Compare(extn, ".pptx", true) == 0))
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.POWER_POINT_ICON);
            }
            else if ((string.Compare(extn, ".tif", true) == 0)
                || (string.Compare(extn, ".tiff", true) == 0))
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.TIFF_ICON);
            }
            else if (string.Compare(extn, ".rtf", true) == 0)
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.RTF_ICON);
            }
            else if ((string.Compare(extn, ".doc", true) == 0)
                || (string.Compare(extn, ".docx", true) == 0))
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.WORD_ICON);
            }
            else if ((string.Compare(extn, ".zip", true) == 0)
                || (string.Compare(extn, ".rar", true) == 0))
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.ZIP_ICON);
            }
            else
            {
                pFilePath = string.Concat(StaticClass.FileSvrRootPath, @"\", Constants.XMLSchema.ATTACHMENT_ICON);
            }

            return ResponseDotFile(pFilePath);
        }

        /// <summary>
        /// http://www.codeproject.com/Articles/260470/PDF-reporting-using-ASP-NET-MVC3
        /// </summary>
        /// <param name="pBinaryType"></param>
        /// <param name="pTitle"></param>
        /// <param name="pCsHtmlName"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        protected BinaryContentResult ResponseDotBinary(string pBinaryType, string pTitle, string pCsHtmlName, object model)
        {
            HtmlViewRenderer htmlViewRenderer = new HtmlViewRenderer();
            StandardPdfRenderer standardPdfRenderer = new StandardPdfRenderer();

            // Render the view html to a string.
            string htmlText = htmlViewRenderer.RenderViewToString(this, pCsHtmlName, model);

            // Let the html be rendered into a PDF document through iTextSharp.
            byte[] buffer = standardPdfRenderer.Render(htmlText, pTitle);

            // Return the PDF as a binary stream to the client.
            return (new BinaryContentResult(buffer, string.Concat("application/", pBinaryType)));
        }

        # endregion

        # region Override Methods

        /// <summary>
        /// http://forums.asp.net/t/1765544.aspx/1
        /// </summary>
        /// <param name="filterContext"></param>
        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            # region Culture

            // http://msdn.microsoft.com/en-us/library/bz9tc508(v=VS.90).aspx

            if (ArivaSession.Sessions().IsNoCulture)
            {
                Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(ArivaSession.Sessions().UserCulture);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(ArivaSession.Sessions().UserCulture);

                Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern = StaticClass.GetDateStr();
                Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortTimePattern = StaticClass.GetTimeStr();
                Thread.CurrentThread.CurrentUICulture.DateTimeFormat.ShortDatePattern = StaticClass.GetDateStr();
            }

            # endregion

            base.OnActionExecuted(filterContext);
        }

        # endregion

        # region Private Methods

        # endregion
    }
}
