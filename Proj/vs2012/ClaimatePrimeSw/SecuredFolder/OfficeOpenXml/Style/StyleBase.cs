/* 
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

namespace OfficeOpenXml.Style
{
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelBorderStyle
    {
        /// <summary>
        /// ///
        /// </summary>
        None,
        /// <summary>
        /// 
        /// </summary>
        Hair,
        /// <summary>
        /// 
        /// </summary>
        Dotted,
        /// <summary>
        /// 
        /// </summary>
        DashDot,
        /// <summary>
        /// 
        /// </summary>
        Thin,
        /// <summary>
        /// 
        /// </summary>
        DashDotDot,
        /// <summary>
        /// 
        /// </summary>
        Dashed,
        /// <summary>
        /// 
        /// </summary>
        MediumDashDotDot,
        /// <summary>
        /// 
        /// </summary>
        MediumDashed,
        /// <summary>
        /// 
        /// </summary>
        MediumDashDot,
        /// <summary>
        /// 
        /// </summary>
        Thick,

        /// <summary>
        /// 
        /// </summary>
        Medium,
        /// <summary>
        /// 
        /// </summary>
        Double
    };
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelHorizontalAlignment
    {
        /// <summary>
        /// 
        /// </summary>
        General,
        /// <summary>
        /// 
        /// </summary>
        Left,
        /// <summary>
        /// 
        /// </summary>
        Center,
        /// <summary>
        /// 
        /// </summary>
        CenterContinuous,
        /// <summary>
        /// 
        /// </summary>
        Right,
        /// <summary>
        /// 
        /// </summary>
        Fill,
        /// <summary>
        /// 
        /// </summary>
        Distributed,
        /// <summary>
        /// 
        /// </summary>
        Justify
    }
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelVerticalAlignment
    {
        /// <summary>
        /// /
        /// </summary>
        
        Top,
        /// <summary>
        /// 
        /// </summary>
        Center,
        /// <summary>
        /// 
        /// </summary>
        Bottom,
        /// <summary>
        /// 
        /// </summary>
        Distributed,
        /// <summary>
        /// 
        /// </summary>
        Justify
    }
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelVerticalAlignmentFont
    {
        /// <summary>
        /// 
        /// </summary>
        None,

        /// <summary>
        /// 
        /// </summary>
        Subscript,
        /// <summary>
        /// 
        /// </summary>
        Superscript
    }
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelFillStyle
    {
        /// <summary>
        /// 
        /// </summary>
        None,
        /// <summary>
        /// 
        /// </summary>
        Solid,
        /// <summary>
        /// 
        /// </summary>
        DarkGray,
        /// <summary>
        /// 
        /// </summary>
        MediumGray,
        /// <summary>
        /// 
        /// </summary>
        LightGray,
        /// <summary>
        /// 
        /// </summary>
        Gray125,
        /// <summary>
        /// 
        /// </summary>
        Gray0625,
        /// <summary>
        /// 
        /// </summary>
        DarkVertical,
        /// <summary>
        /// 
        /// </summary>
        DarkHorizontal,
        /// <summary>
        /// 
        /// </summary>
        DarkDown,
        /// <summary>
        /// 
        /// </summary>
        DarkUp,
        /// <summary>
        /// 
        /// </summary>
        DarkGrid,
        /// <summary>
        /// 
        /// </summary>
        DarkTrellis,
        /// <summary>
        /// 
        /// </summary>
        LightVertical,
        /// <summary>
        /// 
        /// </summary>
        LightHorizontal,
        /// <summary>
        /// 
        /// </summary>
        LightDown,
        /// <summary>
        /// 
        /// </summary>
        LightUp,
        /// <summary>
        /// 
        /// </summary>
        LightGrid,
        /// <summary>
        /// 
        /// </summary>
        LightTrellis
    }
    /// <summary>
    /// 
    /// </summary>
    public enum ExcelFillGradientType
    {
        /// <summary>
        /// No gradient fill. 
        /// </summary>
        None,
        /// <summary>
        /// This gradient fill is of linear gradient type. Linear gradient type means that the transition from one color to the next is along a line (e.g., horizontal, vertical,diagonal, etc.)
        /// </summary>
        Linear,
        /// <summary>
        /// This gradient fill is of path gradient type. Path gradient type means the that the boundary of transition from one color to the next is a rectangle, defined by top,bottom, left, and right attributes on the gradientFill element.
        /// </summary>
        Path
    }
    /// <summary>
    /// 
    /// </summary>
    public abstract class StyleBase
    {
        /// <summary>
        /// 
        /// </summary>
        protected ExcelStyles _styles;
        internal OfficeOpenXml.XmlHelper.ChangedEventHandler _ChangedEvent;
        /// <summary>
        /// 
        /// </summary>
        protected int _positionID;
        /// <summary>
        /// 
        /// </summary>
        protected string _address;
        internal StyleBase(ExcelStyles styles, OfficeOpenXml.XmlHelper.ChangedEventHandler ChangedEvent, int PositionID, string Address)
        {
            _styles = styles;
            _ChangedEvent = ChangedEvent;
            _address = Address;
            _positionID = PositionID;
        }
        internal int Index { get; set;}
        internal abstract string Id {get;}

        internal virtual void SetIndex(int index)
        {
            Index = index;
        }
    }
}
