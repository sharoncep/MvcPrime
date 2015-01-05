// --------------------------------------------------------------------------------------------------------------------
// <copyright file="PrintHeaderFooter.cs" company="SemanticArchitecture">
//   http://www.SemanticArchitecture.net pkalkie@gmail.com
// </copyright>
// <summary>
//   This class represents the standard header and footer for a PDF print.
//   application.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace ClaimatePrimeControllers.SecuredFolder.BinaryFiles
{
    using iTextSharp.text;
    using iTextSharp.text.pdf;

    /// <summary>
    /// This class represents the standard header and footer for a PDF print.
    /// application.
    /// </summary>
    public class PrintHeaderFooter : PdfPageEventHelper
    {
        private PdfContentByte pdfContent;
        private PdfTemplate pageNumberTemplate;
        private BaseFont baseFont;

        public string Title { get; set; }

        public override void OnOpenDocument(PdfWriter writer, Document document)
        {
            baseFont = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            pdfContent = writer.DirectContent;
            pageNumberTemplate = pdfContent.CreateTemplate(50, 50);
        }

        public override void OnStartPage(PdfWriter writer, Document document)
        {
            base.OnStartPage(writer, document);

            Rectangle pageSize = document.PageSize;

            //if (Title != string.Empty)     Moved To Footer
            //{
            //    //float len = baseFont.GetWidthPoint(Title, BinaryFilesConstants.HeaderFooterFontSize);
            //    float len = 0;
            //    pdfContent.BeginText();
            //    pdfContent.SetFontAndSize(baseFont, BinaryFilesConstants.HeaderFooterFontSize);
            //    pdfContent.SetRGBColorFill(0, 0, 0);
            //    pdfContent.ShowTextAligned(PdfContentByte.ALIGN_RIGHT, Title, pageSize.GetRight(BinaryFilesConstants.HorizontalMargin) - len, pageSize.GetTop(BinaryFilesConstants.VerticalMargin), 0);
            //    pdfContent.EndText();
            //}
        }

        public override void OnEndPage(PdfWriter writer, Document document)
        {
            base.OnEndPage(writer, document);

            int pageN = writer.PageNumber;
            string text = string.Concat("Page ", pageN, " of ");
            //float len = baseFont.GetWidthPoint(text, BinaryFilesConstants.HeaderFooterFontSize);

            Rectangle pageSize = document.PageSize;
            pdfContent = writer.DirectContent;
            pdfContent.SetRGBColorFill(100, 100, 100);

            pdfContent.BeginText();
            pdfContent.SetFontAndSize(baseFont, BinaryFilesConstants.HeaderFooterFontSize);
            pdfContent.ShowTextAligned(PdfContentByte.ALIGN_LEFT, Title, pageSize.GetLeft(BinaryFilesConstants.HorizontalMargin), pageSize.GetBottom(BinaryFilesConstants.VerticalMargin) - 10, 0);
            pdfContent.ShowTextAligned(PdfContentByte.ALIGN_RIGHT, text, pageSize.GetRight(BinaryFilesConstants.HorizontalMargin) - 3, pageSize.GetBottom(BinaryFilesConstants.VerticalMargin) - 10, 0);
            pdfContent.EndText();

            pdfContent.AddTemplate(pageNumberTemplate, pageSize.GetRight(BinaryFilesConstants.HorizontalMargin) - 3, pageSize.GetBottom(BinaryFilesConstants.VerticalMargin) - 10);
        }

        public override void OnCloseDocument(PdfWriter writer, Document document)
        {
            base.OnCloseDocument(writer, document);

            pageNumberTemplate.BeginText();
            pageNumberTemplate.SetFontAndSize(baseFont, BinaryFilesConstants.HeaderFooterFontSize);
            pageNumberTemplate.SetTextMatrix(0, 0);
            pageNumberTemplate.ShowText(string.Empty + (writer.PageNumber - 1));
            pageNumberTemplate.EndText();
        }
    }
}