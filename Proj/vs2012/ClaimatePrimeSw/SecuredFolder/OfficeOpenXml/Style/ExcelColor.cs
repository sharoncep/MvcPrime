﻿/* 
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
using OfficeOpenXml.Style.XmlAccess;
using System.Drawing;

namespace OfficeOpenXml.Style
{
    /// <summary>
    /// Color for cellstyling
    /// </summary>
    public sealed class ExcelColor :  StyleBase
    {
        eStyleClass _cls;
        StyleBase _parent;
        internal ExcelColor(ExcelStyles styles, OfficeOpenXml.XmlHelper.ChangedEventHandler ChangedEvent, int worksheetID, string address, eStyleClass cls, StyleBase parent) : 
            base(styles, ChangedEvent, worksheetID, address)
            
        {
            _parent = parent;
            _cls = cls;
        }
        /// <summary>
        /// 
        /// </summary>
        public string Theme
        {
            get
            {
                return GetSource().Theme;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        public decimal Tint
        {
            get
            {
                return GetSource().Tint;
            }
            set
            {
                if (value > 1 || value < -1)
                {
                    throw (new ArgumentOutOfRangeException("Value must be between -1 and 1"));
                }
                _ChangedEvent(this, new StyleChangeEventArgs(_cls, eStyleProperty.Tint, value, _positionID, _address));
            }
        }
        /// <summary>
        /// The RGB value
        /// </summary>
        public string Rgb
        {
            get
            {
                return GetSource().Rgb;
            }
            internal set
            {
                _ChangedEvent(this, new StyleChangeEventArgs(_cls, eStyleProperty.Color, value, _positionID, _address));
            }
        }
        /// <summary>
        /// The indexed color number.
        /// </summary>
        public int Indexed
        {
            get
            {
                return GetSource().Indexed;
            }
            set
            {
                _ChangedEvent(this, new StyleChangeEventArgs(_cls, eStyleProperty.IndexedColor, value, _positionID, _address));
            }
        }
        /// <summary>
        /// Set the color of the object
        /// </summary>
        /// <param name="color">The color</param>
        public void SetColor(Color color)
        {
            Rgb = color.ToArgb().ToString("X");
        }


        internal override string Id
        {
            get 
            {
                return Theme + Tint + Rgb + Indexed;
            }
        }
        private ExcelColorXml GetSource()
        {
            Index = _parent.Index < 0 ? 0 : _parent.Index;
            switch(_cls)
            {
                case eStyleClass.FillBackgroundColor:
                    return _styles.Fills[Index].BackgroundColor;
                case eStyleClass.FillPatternColor:
                    return _styles.Fills[Index].PatternColor;
                case eStyleClass.Font:
                    return _styles.Fonts[Index].Color;
                case eStyleClass.BorderLeft:
                    return _styles.Borders[Index].Left.Color;
                case eStyleClass.BorderTop:
                    return _styles.Borders[Index].Top.Color;
                case eStyleClass.BorderRight:
                    return _styles.Borders[Index].Right.Color;
                case eStyleClass.BorderBottom:
                    return _styles.Borders[Index].Bottom.Color;
                case eStyleClass.BorderDiagonal:
                    return _styles.Borders[Index].Diagonal.Color;
                default:
                    throw(new Exception("Invalid style-class for Color"));
            }
        }
        internal override void SetIndex(int index)
        {
            _parent.Index = index;
        }
    }
}
