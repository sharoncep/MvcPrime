﻿    /* 
 * You may amend and distribute as you like, but don't remove this header!
 * 
 * EPPlus provides server-side generation of Excel 2007 spreadsheets.
 *
 * See http://www.codeplex.com/EPPlus for details.
 * 
 * All rights reserved.
 * 
 * EPPlus is an Open Source project provided under the 
 * GNU General Public License (GPL) as published by the 
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * The GNU General Public License can be viewed at http://www.opensource.org/licenses/gpl-license.php
 * If you unfamiliar with this license or have questions about it, here is an http://www.gnu.org/licenses/gpl-faq.html
 * 
 * The code for this project may be used and redistributed by any means PROVIDING it is 
 * not sold for profit without the author's written consent, and providing that this notice 
 * and the author's name and all copyright notices remain intact.
 * 
 * All code and executables are provided "as is" with no warranty either express or implied. 
 * The author accepts no liability for any damage or loss of business that this product may cause.
 *
 * 
 * Code change notes:
 * 
 * Author							Change						Date
 * ******************************************************************************
 * Jan Källman		                Initial Release		        2009-10-01
 *******************************************************************************/
using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.IO.Packaging;
using System.Drawing;
using System.Drawing.Imaging;
using System.Diagnostics;

namespace OfficeOpenXml.Drawing
{
    /// <summary>
    /// An image object
    /// </summary>
    public sealed class ExcelPicture : ExcelDrawing
    {
        #region "Constructors"
        internal ExcelPicture(ExcelDrawings drawings, XmlNode node) :
            base(drawings, node, "xdr:pic/xdr:nvPicPr/xdr:cNvPr/@name")
        {
            XmlNode picNode = node.SelectSingleNode("xdr:pic/xdr:blipFill/a:blip", drawings.NameSpaceManager);
            if (picNode != null)
            {
                PackageRelationship drawingRelation = drawings.Part.GetRelationship(picNode.Attributes["r:embed"].Value);
                UriPic = PackUriHelper.ResolvePartUri(drawings.UriDrawing, drawingRelation.TargetUri);

                PackagePart part = drawings.Part.Package.GetPart(UriPic);
                FileInfo f = new FileInfo(UriPic.OriginalString);
                ContentType = GetContentType(f.Extension);
                _image = Image.FromStream(part.GetStream());
            }
        }
        internal ExcelPicture(ExcelDrawings drawings, XmlNode node, Image image) :
            base(drawings, node, "xdr:pic/xdr:nvPicPr/xdr:cNvPr/@name")
        {
            XmlElement picNode = node.OwnerDocument.CreateElement("xdr", "pic", ExcelPackage.schemaSheetDrawings);
            node.InsertAfter(picNode,node.SelectSingleNode("xdr:to",NameSpaceManager));
            picNode.InnerXml = PicStartXml();

            node.InsertAfter(node.OwnerDocument.CreateElement("xdr", "clientData", ExcelPackage.schemaSheetDrawings), picNode);

            Package package = drawings.Worksheet.xlPackage.Package;
            //Get the picture if it exists or save it if not.
            _image = image;
            string relID = SavePicture(image);

            //Create relationship
            node.SelectSingleNode("xdr:pic/xdr:blipFill/a:blip/@r:embed", NameSpaceManager).Value = relID;

            SetPosDefaults(image);
            package.Flush();
        }
        internal ExcelPicture(ExcelDrawings drawings, XmlNode node, FileInfo imageFile) :
            base(drawings, node, "xdr:pic/xdr:nvPicPr/xdr:cNvPr/@name")
        {
            XmlElement picNode = node.OwnerDocument.CreateElement("xdr", "pic", ExcelPackage.schemaSheetDrawings);
            node.InsertAfter(picNode, node.SelectSingleNode("xdr:to", NameSpaceManager));
            picNode.InnerXml = PicStartXml();

            node.InsertAfter(node.OwnerDocument.CreateElement("xdr", "clientData", ExcelPackage.schemaSheetDrawings), picNode);

            Package package = drawings.Worksheet.xlPackage.Package;
            ContentType = GetContentType(imageFile.Extension);
            _image = Image.FromFile(imageFile.FullName);
            ImageConverter ic = new ImageConverter();
            byte[] img = (byte[])ic.ConvertTo(_image, typeof(byte[]));


            UriPic = GetNewUri(package, "/xl/media/{0}" + imageFile.Name);
            var ii = _drawings._package.AddImage(img, UriPic, ContentType);
            //string relID = GetPictureRelID(img);

            //if (relID == "")
            string relID;
            if(!drawings._hashes.ContainsKey(ii.Hash))
            {
                //UriPic = GetNewUri(package, "/xl/media/image{0}" + imageFile.Extension);
                //Part =  package.CreatePart(UriPic, ContentType, CompressionOption.NotCompressed);

                ////Save the picture to package.
                //byte[] file = File.ReadAllBytes(imageFile.FullName);
                //var strm = Part.GetStream(FileMode.Create, FileAccess.Write);
                //strm.Write(file, 0, file.Length);
                Part = ii.Part;
                PackageRelationship picRelation = drawings.Part.CreateRelationship(PackUriHelper.GetRelativeUri(drawings.UriDrawing, ii.Uri), TargetMode.Internal, ExcelPackage.schemaRelationships + "/image");
                relID = picRelation.Id;
                _drawings._hashes.Add(ii.Hash, relID);
                AddNewPicture(img, relID);

            }
            else
            {
                relID = drawings._hashes[ii.Hash];
                var rel = _drawings.Part.GetRelationship(relID);
                UriPic = PackUriHelper.ResolvePartUri(rel.SourceUri, rel.TargetUri);
            }
            SetPosDefaults(Image);
            //Create relationship
            node.SelectSingleNode("xdr:pic/xdr:blipFill/a:blip/@r:embed", NameSpaceManager).Value = relID;
            package.Flush();
        }

        internal static string GetContentType(string extension)
        {
            switch (extension.ToLower())
            {
                case ".bmp":
                    return  "image/bmp";
                case ".jpg":
                case ".jpeg":
                    return "image/jpeg";
                case ".gif":
                    return "image/gif";
                case ".png":
                    return "image/png";
                case ".cgm":
                    return "image/cgm";
                case ".emf":
                    return "image/x-emf";
                case ".eps":
                    return "image/x-eps";
                case ".pcx":
                    return "image/x-pcx";
                case ".tga":
                    return "image/x-tga";
                case ".tif":
                case ".tiff":
                    return "image/x-tiff";
                case ".wmf":
                    return "image/x-wmf";
                default:
                    return "image/jpeg";

            }
        }
        //Add a new image to the compare collection
        private void AddNewPicture(byte[] img, string relID)
        {
            var newPic = new ExcelDrawings.ImageCompare();
            newPic.image = img;
            newPic.relID = relID;
            //_drawings._pics.Add(newPic);
        }
        #endregion
        //private string GetPictureRelID(byte[] img)
        //{            
        //    foreach (var hash in _drawings._hashes)
        //    {
        //        if (checkImg.Comparer(img))
        //        {
        //            return checkImg.relID;
        //        }
        //    }
        //    return "";
        //}
        private string SavePicture(Image image)
        {
            ImageConverter ic = new ImageConverter();
            byte[] img = (byte[])ic.ConvertTo(image, typeof(byte[]));
            var ii = _drawings._package.AddImage(img);

            if (_drawings._hashes.ContainsKey(ii.Hash))
            {
                var relID = _drawings._hashes[ii.Hash];
                var rel = _drawings.Part.GetRelationship(relID);
                UriPic = PackUriHelper.ResolvePartUri(rel.SourceUri, rel.TargetUri);
                return relID;
            }
            else
            {
                UriPic = ii.Uri;
            }

            //Set the Image and save it to the package.
            PackageRelationship picRelation = _drawings.Part.CreateRelationship(PackUriHelper.GetRelativeUri(_drawings.UriDrawing, UriPic), TargetMode.Internal, ExcelPackage.schemaRelationships + "/image");
            
            //AddNewPicture(img, picRelation.Id);
            _drawings._hashes.Add(ii.Hash, picRelation.Id);
            
            return picRelation.Id;
        }
        private void SetPosDefaults(Image image)
        {
            SetPixelWidth(image.Width, image.HorizontalResolution);
            SetPixelHeight(image.Height, image.VerticalResolution);
        }
        private string PicStartXml()
        {
            StringBuilder xml = new StringBuilder();
            xml.AppendFormat("<xdr:nvPicPr><xdr:cNvPr id=\"{0}\" descr=\"\" />", _id);
            xml.Append("<xdr:cNvPicPr><a:picLocks noChangeAspect=\"1\" /></xdr:cNvPicPr></xdr:nvPicPr><xdr:blipFill><a:blip xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" r:embed=\"\" cstate=\"print\" /><a:stretch><a:fillRect /> </a:stretch> </xdr:blipFill> <xdr:spPr> <a:xfrm> <a:off x=\"0\" y=\"0\" />  <a:ext cx=\"0\" cy=\"0\" /> </a:xfrm> <a:prstGeom prst=\"rect\"> <a:avLst /> </a:prstGeom> </xdr:spPr>");
            return xml.ToString();
        }

        internal byte[] ImageHash { get; set; }
        Image _image = null;
        /// <summary>
        /// The Image
        /// </summary>
        public Image Image 
        {
            get
            {
                return _image;
            }
            set
            {
                if (value != null)
                {
                    _image = value;
                    try
                    {
                        _image.Save(Part.GetStream(FileMode.Create, FileAccess.Write),_imageFormat);   //Always JPEG here at this point. 
                    }
                    catch(Exception ex)
                    {
                        throw(new Exception("Can't save image - " + ex.ToString(), ex));
                    }
                }
            }
        }
        ImageFormat _imageFormat=ImageFormat.Jpeg;
        /// <summary>
        /// Image format
        /// If the picture is created from an Image this type is always Jpeg
        /// </summary>
        public ImageFormat ImageFormat
        {
            get
            {
                return _imageFormat;
            }
            internal set
            {
                _imageFormat = value;
            }
        }
        internal string ContentType
        {
            get;
            set;
        }
        /// <summary>
        /// Set the size of the image in percent from the orginal size
        /// Note that resizing columns / rows after using this function will effect the size of the picture
        /// </summary>
        /// <param name="Percent">Percent</param>
        public override void SetSize(int Percent)
        {
            if(Image == null)
            {
                base.SetSize(Percent);
            }
            else
            {
                int width = Image.Width;
                int height = Image.Height;

                width = (int)(width * ((decimal)Percent / 100));
                height = (int)(height * ((decimal)Percent / 100));

                SetPixelWidth(width, Image.HorizontalResolution);
                SetPixelHeight(height, Image.VerticalResolution);
            }
        }
        internal Uri UriPic { get; set; }
        internal PackagePart Part;

        internal new string Id
        {
            get { return Name; }
        }
        ExcelDrawingFill _fill = null;
        /// <summary>
        /// Fill
        /// </summary>
        public ExcelDrawingFill Fill
        {
            get
            {
                if (_fill == null)
                {
                    _fill = new ExcelDrawingFill(NameSpaceManager, TopNode, "xdr:pic/xdr:spPr");
                }
                return _fill;
            }
        }
        ExcelDrawingBorder _border = null;
        /// <summary>
        /// Border
        /// </summary>
        public ExcelDrawingBorder Border
        {
            get
            {
                if (_border == null)
                {
                    _border = new ExcelDrawingBorder(NameSpaceManager, TopNode, "xdr:pic/xdr:spPr/a:ln");
                }
                return _border;
            }
        }
    }
}
