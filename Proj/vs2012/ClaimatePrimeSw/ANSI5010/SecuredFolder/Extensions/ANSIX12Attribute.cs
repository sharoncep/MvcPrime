using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ANSI5010.SecuredFolder.Extensions
{
    # region ANSI5010Loop

    /// <summary>
    /// 
    /// </summary>
    [AttributeUsageAttribute(AttributeTargets.Class, Inherited = false, AllowMultiple = false)]
    public class ANSI5010LoopAttribute : Attribute
    {
        // http://msdn.microsoft.com/en-us/library/system.attribute.aspx
        // http://stackoverflow.com/questions/4879521/creating-custom-attribute-in-c-sharp
        // http://stackoverflow.com/questions/6637679/reflection-get-attribute-name-and-value-on-property

        # region Properties

        public readonly global::System.Boolean IsRequired;

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsRequired"></param>
        /// <param name="pMinLen"></param>
        /// <param name="pMaxLen"></param>
        public ANSI5010LoopAttribute(global::System.Boolean pIsRequired)
        {
            this.IsRequired = pIsRequired;
        }

        # endregion
    }

    # endregion

    # region ANSI5010Field

    /// <summary>
    /// 
    /// </summary>
    [AttributeUsageAttribute(AttributeTargets.Property, Inherited = false, AllowMultiple = false)]
    public class ANSI5010FieldAttribute : Attribute
    {
        // http://msdn.microsoft.com/en-us/library/system.attribute.aspx
        // http://stackoverflow.com/questions/4879521/creating-custom-attribute-in-c-sharp
        // http://stackoverflow.com/questions/6637679/reflection-get-attribute-name-and-value-on-property

        # region Properties

        public readonly global::System.Boolean IsRequired;
        public readonly global::System.Int32 MinLen;
        public readonly global::System.Int32 MaxLen;
        public readonly global::System.Boolean IsNotField;

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsRequired"></param>
        /// <param name="Len"></param>
        public ANSI5010FieldAttribute(global::System.Boolean pIsRequired, global::System.Int32 pLen)
            : this(pIsRequired, pLen, pLen, false)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsRequired"></param>
        /// <param name="pLen"></param>
        /// <param name="pIsNotField">True means component</param>
        public ANSI5010FieldAttribute(global::System.Boolean pIsRequired, global::System.Int32 pLen, global::System.Boolean pIsNotField)
            : this(pIsRequired, pLen, pLen, pIsNotField)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsRequired"></param>
        /// <param name="pMinLen"></param>
        /// <param name="pMaxLen"></param>
        public ANSI5010FieldAttribute(global::System.Boolean pIsRequired, global::System.Int32 pMinLen, global::System.Int32 pMaxLen)
            : this(pIsRequired, pMinLen, pMaxLen, false)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsRequired"></param>
        /// <param name="pMinLen"></param>
        /// <param name="pMaxLen"></param>
        /// <param name="pIsNotField">True means component</param>
        public ANSI5010FieldAttribute(global::System.Boolean pIsRequired, global::System.Int32 pMinLen, global::System.Int32 pMaxLen, global::System.Boolean pIsNotField)
        {
            this.IsRequired = pIsRequired;
            this.MinLen = pMinLen;
            this.MaxLen = pMaxLen;
            this.IsNotField = pIsNotField;
        }

        # endregion
    }

    # endregion
}
