using ANSI5010.SecuredFolder.Extensions;
using ANSI5010.SecuredFolder.StaticClasses;
using ANSI5010.SubClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace ANSI5010.SecuredFolder.BaseClasses
{
    # region BaseClass

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public abstract class Base5010
    {
        # region Properties

        # region Readonly

        public readonly global::System.String LoopName;

        # endregion

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String P998_LoopNameRef { get; private set; }

        /// <summary>
        /// Get
        /// </summary>
        public global::System.String P999_LoopChartRef { get; private set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopName"></param>
        /// <param name="pLoopNameRef">LENGTH SHOULD NOT GREATER THAN 24</param>
        public Base5010(string pLoopName, string pLoopNameRef)
            : this(pLoopName, pLoopNameRef, string.Empty)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopName"></param>
        /// <param name="pLoopNameRef">LENGTH SHOULD NOT GREATER THAN 24</param>
        /// <param name="pLoopChartRef"></param>
        /// <param name="pIsNotFieldStChr">COMPONENT STARTING CHARACTER</param>
        public Base5010(string pLoopName, string pLoopNameRef, string pLoopChartRef)
        {
            this.LoopName = pLoopName;
            this.P998_LoopNameRef = pLoopNameRef;
            this.P999_LoopChartRef = pLoopChartRef;

            if ((this.P998_LoopNameRef.Length < 1) || (this.P998_LoopNameRef.Length > 24))
            {
                throw new Exception(string.Concat("Sorry! Invalid LoopNameRef Length: ", this.P998_LoopNameRef.Length, " [", this.P998_LoopNameRef, "]"));
            }
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ANSI5010Loop ToANSI5010Loop()
        {
            string loopNamRf = this.P998_LoopNameRef;
            string loopChrtRf = this.P999_LoopChartRef;
            string loopVal = string.Concat(Static5010.ReadXml("CharIsField"), this.LoopName);

            while (loopNamRf.Length < 24)
            {
                loopNamRf = string.Concat(loopNamRf, " ");
            }

            loopNamRf = string.Concat(loopNamRf, " ");

            while (loopChrtRf.Length < 8)
            {
                loopChrtRf = string.Concat(loopChrtRf, " ");
            }

            loopChrtRf = string.Concat(loopChrtRf, " ");

            // http://stackoverflow.com/questions/2656189/how-do-i-read-an-attribute-on-a-class-at-runtime

            object[] attrs = this.GetType().GetCustomAttributes(true);

            if ((attrs == null) || (attrs.Length != 1))
            {
                throw new Exception(string.Concat("Sorry! Class must have ANSI5010Loop attribute only [Class Name: ", this, "]"));
            }

            ANSI5010LoopAttribute loopAttr = attrs[0] as ANSI5010LoopAttribute;
            bool hasLoopVal = false;

            // http://stackoverflow.com/questions/6637679/reflection-get-attribute-name-and-value-on-property
            // http://stackoverflow.com/questions/1355090/using-propertyinfo-getvalue

            List<PropertyInfo> props = (new List<PropertyInfo>(this.GetType().GetProperties()).OrderBy(x => x.Name)).ToList();

            foreach (PropertyInfo prop in props)
            {
                if ((string.Compare(prop.Name, "P998_LoopNameRef", true) == 0) || (string.Compare(prop.Name, "P999_LoopChartRef", true) == 0))
                {
                    continue;
                }

                if (string.Compare(prop.PropertyType.Name, "String", true) != 0)
                {
                    throw new Exception(string.Concat("Sorry! Invalid PropertyType: ", prop.PropertyType.Name, " [Property Name: ", prop.Name, "]"));
                }

                attrs = prop.GetCustomAttributes(true);

                if ((attrs == null) || (attrs.Length != 1))
                {
                    throw new Exception(string.Concat("Sorry! Property must have ANSI5010Field attribure only [Property Name: ", prop.Name, "]"));
                }

                string loopValTmp = Convert.ToString(prop.GetValue(this)).Trim();

                if (!(hasLoopVal))
                {
                    if (!(string.IsNullOrWhiteSpace(loopValTmp)))
                    {
                        hasLoopVal = true;
                    }
                }

                ANSI5010FieldAttribute fieldAttr = attrs[0] as ANSI5010FieldAttribute;

                if (fieldAttr.MaxLen < fieldAttr.MinLen)
                {
                    throw new Exception(string.Concat("Sorry! Attr.MaxLen should not less than Attr.MinLen [Property Name: ", prop.Name, "]"));
                }

                if (fieldAttr.IsRequired)
                {
                    if (loopValTmp.Length > fieldAttr.MaxLen)
                    {
                        loopValTmp = loopValTmp.Substring(0, fieldAttr.MaxLen);
                    }
                    else
                    {
                        while (loopValTmp.Length < fieldAttr.MinLen)
                        {
                            loopValTmp = string.Concat(loopValTmp, " ");
                        }
                    }
                }
                else
                {
                    if (loopValTmp.Length > 0)
                    {
                        if (loopValTmp.Length > fieldAttr.MaxLen)
                        {
                            loopValTmp = loopValTmp.Substring(0, fieldAttr.MaxLen);
                        }
                        else
                        {
                            while (loopValTmp.Length < fieldAttr.MinLen)
                            {
                                loopValTmp = string.Concat(loopValTmp, " ");
                            }
                        }
                    }
                }

                if (fieldAttr.IsNotField)
                {
                    loopVal = string.Concat(loopVal, Static5010.ReadXml("CharIsNotField"), loopValTmp);
                }
                else
                {
                    loopVal = string.Concat(loopVal, Static5010.ReadXml("CharIsField"), loopValTmp);
                }
            }

            loopVal = loopVal.Substring(1);

            if (string.Compare(this.LoopName, "ISA", true) != 0)
            {
                if (!((loopAttr.IsRequired) || (hasLoopVal)))
                {
                    loopVal = string.Empty;
                }
                else
                {
                    while (((loopVal.EndsWith(Static5010.ReadXml("CharIsField"))) || (loopVal.EndsWith(Static5010.ReadXml("CharIsNotField"))) || (loopVal.EndsWith(" "))) || (loopVal.IndexOf("*:") != -1) || (loopVal.IndexOf(":*") != -1))
                    {
                        while ((loopVal.EndsWith(Static5010.ReadXml("CharIsField"))) || (loopVal.EndsWith(Static5010.ReadXml("CharIsNotField"))) || (loopVal.EndsWith(" ")))
                        {
                            loopVal = loopVal.Substring(0, loopVal.Length - 1);
                        }

                        while (loopVal.IndexOf("*:") != -1)
                        {
                            loopVal = loopVal.Replace("*:", "*");
                        }

                        while (loopVal.IndexOf(":*") != -1)
                        {
                            loopVal = loopVal.Replace(":*", "*");
                        }
                    }
                }
            }

            return (new ANSI5010Loop(loopNamRf, loopChrtRf, loopVal));
        }

        # endregion

        # region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pANSI5010Main"></param>
        /// <returns></returns>
        public static List<ANSI5010Loop> GetANSI5010Loops(ANSI5010Main pANSI5010Main)
        {
            List<ANSI5010Loop> retAns = new List<ANSI5010Loop>();

            // http://stackoverflow.com/questions/6637679/reflection-get-attribute-name-and-value-on-property
            // http://stackoverflow.com/questions/1355090/using-propertyinfo-getvalue

            List<PropertyInfo> props = (new List<PropertyInfo>(pANSI5010Main.GetType().GetProperties()).OrderBy(x => x.Name)).ToList();

            foreach (PropertyInfo prop in props)
            {
                object propVal = prop.GetValue(pANSI5010Main);

                if (propVal is Base5010)
                {
                    ANSI5010Loop tmp = ((Base5010)propVal).ToANSI5010Loop();
                    if (tmp.LoopValue.Length > 0)
                    {
                        retAns.Add(tmp);
                    }
                }
                else if (propVal is List<GSDetail>)
                {
                    List<GSDetail> gsDets = propVal as List<GSDetail>;

                    foreach (GSDetail gsDet in gsDets)
                    {
                        List<PropertyInfo> gsDetProps = (new List<PropertyInfo>(gsDet.GetType().GetProperties()).OrderBy(x => x.Name)).ToList();

                        foreach (PropertyInfo gsDetProp in gsDetProps)
                        {
                            object gsDetPropVal = gsDetProp.GetValue(gsDet);

                            if (gsDetPropVal is Base5010)
                            {
                                ANSI5010Loop tmp = ((Base5010)gsDetPropVal).ToANSI5010Loop();
                                if (tmp.LoopValue.Length > 0)
                                {
                                    retAns.Add(tmp);
                                }
                            }
                            else if (gsDetPropVal is List<SubPatDetail>)
                            {
                                List<SubPatDetail> subPatDets = gsDetPropVal as List<SubPatDetail>;

                                foreach (SubPatDetail subPatDet in subPatDets)
                                {
                                    List<PropertyInfo> subPatProps = (new List<PropertyInfo>(subPatDet.GetType().GetProperties()).OrderBy(x => x.Name)).ToList();

                                    foreach (PropertyInfo subPatProp in subPatProps)
                                    {
                                        object subPatPropVal = subPatProp.GetValue(subPatDet);

                                        if (subPatPropVal is Base5010)
                                        {
                                            ANSI5010Loop tmp = ((Base5010)subPatPropVal).ToANSI5010Loop();
                                            if (tmp.LoopValue.Length > 0)
                                            {
                                                retAns.Add(tmp);
                                            }
                                        }
                                        else if (subPatPropVal is List<CptService>)
                                        {
                                            List<CptService> cptServices = subPatPropVal as List<CptService>;

                                            foreach (CptService cptService in cptServices)
                                            {
                                                List<PropertyInfo> cptServiceProps = (new List<PropertyInfo>(cptService.GetType().GetProperties()).OrderBy(x => x.Name)).ToList();

                                                foreach (PropertyInfo cptServiceProp in cptServiceProps)
                                                {
                                                    object cptServicePropVal = cptServiceProp.GetValue(cptService);

                                                    if (cptServicePropVal is Base5010)
                                                    {
                                                        ANSI5010Loop tmp = ((Base5010)cptServicePropVal).ToANSI5010Loop();
                                                        if (tmp.LoopValue.Length > 0)
                                                        {
                                                            retAns.Add(tmp);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            throw new Exception(string.Concat("Sorry! Invalid Property Type: ", subPatProp.PropertyType.Name));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    throw new Exception(string.Concat("Sorry! Invalid Property Type: ", prop.PropertyType.Name));
                }
            }

            return retAns;
        }

        # endregion
    }

    # endregion

    # region ANSI5010Loop

    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ANSI5010Loop
    {
        # region Properties

        /// <summary>
        /// Get
        /// </summary>
        public readonly global::System.String LoopName;

        /// <summary>
        /// Get
        /// </summary>
        public readonly global::System.String LoopChart;

        /// <summary>
        /// Get
        /// </summary>
        public readonly global::System.String LoopValue;

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pLoopName"></param>
        /// <param name="pLoopChart"></param>
        /// <param name="pLoopValue"></param>
        public ANSI5010Loop(string pLoopName, string pLoopChart, string pLoopValue)
        {
            this.LoopName = pLoopName;
            this.LoopChart = pLoopChart;
            this.LoopValue = pLoopValue;
        }

        # endregion
    }

    # endregion
}
