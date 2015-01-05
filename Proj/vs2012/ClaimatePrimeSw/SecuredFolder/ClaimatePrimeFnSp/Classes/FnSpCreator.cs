using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;

namespace ClaimatePrimeFnSp.Classes
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class FnSpCreator
    {
        # region Properties

        public static global::System.String DbServer { get; set; }
        public static global::System.String DbName { get; set; }
        public static global::System.String DbUid { get; set; }
        public static global::System.String DbPwd { get; set; }
        public static global::System.String Templates { get; set; }
        public static global::System.String CreatedScripts { get; set; }

        # endregion

        # region Constructors

        /// <summary>
        /// 
        /// </summary>
        private FnSpCreator()
        {
        }

        # endregion

        # region Public Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="_DbSvr"></param>
        /// <param name="_DbUid"></param>
        /// <param name="_DbPwd"></param>
        /// <returns></returns>
        public static List<string> GetDbNames()
        {
            List<string> retAns = new List<string>();

            using (SqlConnection conn = new SqlConnection(string.Concat("server=", DbServer, ";uid=", DbUid, ";pwd=", DbPwd, ";database=master;")))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "sp_databases";
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    while (dr.Read())
                    {
                        retAns.Add(dr[0].ToString());
                    }

                    dr.Close();
                    dr.Dispose();
                    cmd.Dispose();
                }
                catch (Exception ex)
                {
                    retAns = new List<string>();
                    retAns.Add(ex.ToString());
                }
                finally
                {
                    while (conn.State != System.Data.ConnectionState.Closed)
                    {
                        conn.Close();
                    }
                }
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="_DbSvr"></param>
        /// <param name="_DbUid"></param>
        /// <param name="_DbPwd"></param>
        /// <param name="_DbNam"></param>
        /// <param name="TmplRoot"></param>
        /// <param name="pTmplFile"></param>
        /// <param name="pTmplFileHistory"></param>
        /// <returns></returns>
        public static List<TableObject> GetTableNames(string pTmplFile)
        {
            List<TableObject> retAns = new List<TableObject>();

            using (SqlConnection conn = new SqlConnection(string.Concat("server=", DbServer, ";uid=", DbUid, ";pwd=", DbPwd, ";database=", DbName, ";")))
            {
                try
                {
                    string cmdText = string.Empty;

                    var x = string.Concat(Templates, @"\", pTmplFile);
                    using (StreamReader sr = new StreamReader(string.Concat(Templates, @"\", pTmplFile)))
                    {
                        cmdText = sr.ReadToEnd();
                        sr.Close();
                    }

                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = cmdText;
                    cmd.CommandType = System.Data.CommandType.Text;
                    SqlDataReader dr = cmd.ExecuteReader();

                    string prevTblName = string.Empty;
                    string prevTblSchema = string.Empty;
                    TableObject tblObj = new TableObject();

                    while (dr.Read())
                    {
                        string currTblName = Convert.ToString(dr["TABLE_NAME"]);
                        string currTblSchema = Convert.ToString(dr["TABLE_SCHEMA"]);

                        if (string.Compare(prevTblName, currTblName, true) != 0)
                        {
                            try
                            {
                                tblObj.PkDataType = (from oPk in tblObj.FieldObjects where (string.Compare(oPk.COLUMN_NAME, string.Concat(tblObj.TABLE_NAME, "ID"), true) == 0) select oPk.DATA_TYPE).First();
                            }
                            catch (Exception ex)
                            {
                                tblObj.PkDataType = ex.ToString();
                            }

                            retAns.Add(tblObj);

                            prevTblName = currTblName;
                            prevTblSchema = currTblSchema;
                            tblObj = new TableObject() { TABLE_SCHEMA = prevTblSchema, TABLE_NAME = prevTblName };
                        }

                        string colName = Convert.ToString(dr["COLUMN_NAME"]);

                        if (string.Compare(tblObj.TABLE_NAME, colName, true) == 0)
                        {
                            throw new Exception(string.Concat("Sorry! The table name '", tblObj.TABLE_NAME, "' and the field name '", colName
                                , "' both have same spelling. This should not allowed."));
                        }

                        tblObj.FieldObjects.Add(
                            new FieldObject(tblObj.TABLE_NAME)
                            {
                                CHARACTER_MAXIMUM_LENGTH = Convert.ToInt32(dr["CHARACTER_MAXIMUM_LENGTH"])
                                ,
                                COLUMN_DEFAULT = Convert.ToString(dr["COLUMN_DEFAULT"])
                                ,
                                COLUMN_NAME = colName
                                ,
                                DATA_TYPE = Convert.ToString(dr["DATA_TYPE"]).ToUpper()
                                ,
                                IS_NULLABLE = (Convert.ToString(dr["IS_NULLABLE"]) == "YES") ? true : false
                                ,
                                ORDINAL_POSITION = Convert.ToInt32(dr["ORDINAL_POSITION"])
                            }
                            );
                    }

                    dr.Close();
                    dr.Dispose();
                    cmd.Dispose();

                    try
                    {
                        tblObj.PkDataType = (from oPk in tblObj.FieldObjects where (string.Compare(oPk.COLUMN_NAME, string.Concat(tblObj.TABLE_NAME, "ID"), true) == 0) select oPk.DATA_TYPE).First();
                    }
                    catch (Exception ex)
                    {
                        tblObj.PkDataType = ex.ToString();
                    }

                    retAns.Add(tblObj);
                    tblObj = new TableObject() { TABLE_SCHEMA = prevTblSchema, TABLE_NAME = prevTblName };

                    retAns.RemoveAt(0);
                }
                catch (Exception ex)
                {
                    retAns = new List<TableObject>();
                    retAns.Add(new TableObject() { TABLE_NAME = ex.ToString() });
                }
                finally
                {
                    while (conn.State != System.Data.ConnectionState.Closed)
                    {
                        conn.Close();
                    }
                }
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="pTmplFile"></param>
        /// <returns></returns>
        public static List<string> GetSpUsageKeys(string pTmplFile)
        {
            List<string> retAns = new List<string>();

            try
            {
                using (StreamReader sr = new StreamReader(string.Concat(Templates, @"\", pTmplFile)))
                {
                    while (!(sr.EndOfStream))
                    {
                        retAns.Add(sr.ReadLine());
                    }

                    sr.Close();
                }
            }
            catch (Exception ex)
            {
                retAns = new List<string>();
                retAns.Add(ex.ToString());
            }
            finally
            {
            }

            retAns = new List<string>(retAns.OrderByDescending(x => x));
            retAns.Reverse();

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="pTmplFile"></param>
        /// <returns></returns>
        public static List<string> GetScalarFnUsageKeys(string pTmplFile)
        {
            List<string> retAns = new List<string>();

            try
            {
                using (StreamReader sr = new StreamReader(string.Concat(Templates, @"\", pTmplFile)))
                {
                    while (!(sr.EndOfStream))
                    {
                        retAns.Add(sr.ReadLine());
                    }

                    sr.Close();
                }
            }
            catch (Exception ex)
            {
                retAns = new List<string>();
                retAns.Add(ex.ToString());
            }
            finally
            {
            }

            retAns = new List<string>(retAns.OrderByDescending(x => x));
            retAns.Reverse();

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="CreatedScripts"></param>
        /// <returns></returns>
        public string CreateBlankScript()
        {
            string retAns = string.Empty;

            try
            {
                # region DropUfn

                string filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "01_DropUfn.sql");

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                FileStream fs = File.Create(filePath);
                fs.Close();
                fs.Dispose();

                using (StreamWriter sw = new StreamWriter(filePath))
                {
                    sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString()
                        , " ", DateTime.Now.ToLongTimeString(), " using ahtllc basic (common) stored procedure and scalar function creator tool"));

                    sw.WriteLine(string.Empty);
                    sw.WriteLine("-- Note:- Before executing this script, please take backup for all existing User Defined function and Stored procedures");
                    sw.WriteLine(string.Empty);
                    sw.Close();
                }

                # endregion

                # region DropUsp

                filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "02_DropUsp.sql");

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                fs = File.Create(filePath);
                fs.Close();
                fs.Dispose();

                using (StreamWriter sw = new StreamWriter(filePath, true))
                {
                    sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString()
                        , " ", DateTime.Now.ToLongTimeString(), " using ahtllc basic (common) stored procedure and scalar function creator tool"));

                    sw.WriteLine(string.Empty);
                    sw.WriteLine("-- Note:- Before executing this script, please take backup for all existing User Defined function and Stored procedures");
                    sw.WriteLine(string.Empty);
                    sw.Close();
                }

                # endregion

                # region Create Ufn

                filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "03_CreateUfn.sql");

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                fs = File.Create(filePath);
                fs.Close();
                fs.Dispose();

                using (StreamWriter sw = new StreamWriter(filePath))
                {
                    sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString()
                        , " ", DateTime.Now.ToLongTimeString(), " using ahtllc basic (common) stored procedure and scalar function creator tool"));

                    sw.WriteLine(string.Empty);
                    sw.WriteLine("-- Note:- Before executing this script, please take backup for all existing User Defined function and Stored procedures");
                    sw.WriteLine(string.Empty);

                    sw.Close();
                }

                # endregion

                # region Create Usp

                filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "04_CreateUsp.sql");

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                fs = File.Create(filePath);
                fs.Close();
                fs.Dispose();

                using (StreamWriter sw = new StreamWriter(filePath))
                {
                    sw.WriteLine(string.Concat("-- DB Script Created By Senthil S R on ", DateTime.Now.ToLongDateString()
                        , " ", DateTime.Now.ToLongTimeString(), " using ahtllc basic (common) stored procedure and scalar function creator tool"));

                    sw.WriteLine(string.Empty);
                    sw.WriteLine("-- Note:- Before executing this script, please take backup for all existing User Defined function and Stored procedures");
                    sw.WriteLine(string.Empty);

                    sw.Close();
                }

                # endregion
            }
            catch (Exception ex)
            {
                retAns = ex.ToString();
            }

            return retAns;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="CreatedScripts"></param>
        /// <param name="pUfnTmplName"></param>
        /// <param name="pUspTmplName"></param>
        /// <param name="pUfnUspTmplFile">User defined function name or user defined stored procedure name, usp or ufn</param>
        /// <returns></returns>
        public string CreateDropDbScript(string pUfnTmplName, string pUspTmplName, Dictionary<string, string> pUfnUspTmplFile)
        {
            string retAns = string.Empty;

            try
            {
                foreach (KeyValuePair<string, string> item in pUfnUspTmplFile)
                {
                    string filePath = string.Empty;
                    string tmplPath = string.Empty;

                    if (string.Compare(item.Value, "ufn", StringComparison.CurrentCultureIgnoreCase) == 0)
                    {
                        filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "01_DropUfn.sql");
                        tmplPath = string.Concat(Templates, @"\", pUfnTmplName);
                    }
                    else if (string.Compare(item.Value, "usp", StringComparison.CurrentCultureIgnoreCase) == 0)
                    {
                        filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "02_DropUsp.sql");
                        tmplPath = string.Concat(Templates, @"\", pUspTmplName);
                    }
                    else
                    {
                        filePath = string.Empty;
                        tmplPath = string.Empty;
                    }

                    string strDropScr = string.Empty;

                    using (StreamReader sr = new StreamReader(tmplPath))
                    {
                        strDropScr = sr.ReadToEnd();
                        sr.Close();
                    }

                    using (StreamWriter sw = new StreamWriter(filePath, true))
                    {
                        strDropScr = strDropScr.Replace("[xFN_SP_NAMEx]", item.Key);

                        sw.WriteLine(strDropScr);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", item.Key, " ************************* Completed."));
                        sw.WriteLine(string.Empty);

                        sw.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                retAns = ex.ToString();
            }
            finally
            {
                //
            }

            return retAns;
        }

        /// <summary>
        /// Common user definded functions
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="CreatedScripts"></param>
        /// <param name="pUfnTmplFile">User definded function name, Template file name</param>
        /// <returns></returns>
        public string CreateCufnDbScript(Dictionary<string, string> pUfnTmplFile)
        {
            string retAns = string.Empty;

            try
            {
                string filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "03_CreateUfn.sql");

                using (StreamWriter sw = new StreamWriter(filePath, true))
                {
                    foreach (KeyValuePair<string, string> item in pUfnTmplFile)
                    {
                        string strCreateScr = string.Empty;

                        using (StreamReader sr = new StreamReader(string.Concat(Templates, @"\", item.Value)))
                        {
                            strCreateScr = sr.ReadToEnd();
                            sr.Close();
                        }

                        sw.WriteLine(strCreateScr);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", item.Key, " ************************* Completed."));
                        sw.WriteLine(string.Empty);
                    }

                    sw.Close();
                }
            }
            catch (Exception ex)
            {
                retAns = ex.ToString();
            }

            return retAns;
        }

        /// <summary>
        /// User defined functions and User defined stored procedures
        /// </summary>
        /// <param name="TmplRoot"></param>
        /// <param name="CreatedScripts"></param>
        /// <param name="pTableObject"></param>
        /// <param name="pUfnUspTmplFile">User definded function name or User definded stored procedure name, Template file name</param>
        /// <returns></returns>
        public string CreateUfnUspDbScript(TableObject pTableObject, Dictionary<string, string> pUfnUspTmplFile)
        {
            string retAns = string.Empty;

            try
            {
                foreach (KeyValuePair<string, string> item in pUfnUspTmplFile)
                {
                    string strCreateScr = string.Empty;

                    using (StreamReader sr = new StreamReader(string.Concat(Templates, @"\", item.Value)))
                    {
                        strCreateScr = sr.ReadToEnd();
                        sr.Close();
                    }

                    string filePath = string.Empty;

                    List<string> ufnUspNmArr = item.Key.Split(Convert.ToChar("_")).ToList();

                    if (string.Compare(ufnUspNmArr[0], "ufn", StringComparison.CurrentCultureIgnoreCase) == 0)
                    {
                        filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "03_CreateUfn.sql");

                        if (string.Compare(ufnUspNmArr[1], "IsExists", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region IsExists

                            string strParams = string.Empty;
                            string strConti = string.Empty;
                            string strContiCase = string.Empty;

                            foreach (FieldObject fldObj in pTableObject.FieldObjects)
                            {
                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                if (fldObj.IS_NULLABLE)
                                {
                                    if ((string.Compare(fldObj.DATA_TYPE, "NCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NTEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NVARCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "TEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "VARCHAR", true) == 0))
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t("
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] COLLATE LATIN1_GENERAL_CS_AS = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t("
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");
                                    }
                                    else
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t("
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t("
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME
                                            , " OR (@", fldObj.COLUMN_NAME, " IS NULL AND "
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]"
                                            , " IS NULL))");
                                    }
                                }
                                else
                                {
                                    if ((string.Compare(fldObj.DATA_TYPE, "NCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NTEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "NVARCHAR", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "TEXT", true) == 0)
                                        || (string.Compare(fldObj.DATA_TYPE, "VARCHAR", true) == 0))
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t"
                                             , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] COLLATE LATIN1_GENERAL_CS_AS = @", fldObj.COLUMN_NAME);

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t"
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                                    }
                                    else
                                    {
                                        strContiCase = string.Concat(strContiCase, "\n\t\tAND\n\t\t\t"
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);

                                        strConti = string.Concat(strConti, "\n\t\tAND\n\t\t\t"
                                            , "[", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                                    }
                                }
                            }

                            strParams = strParams.Substring(4);
                            strConti = strConti.Substring(10);
                            strContiCase = strContiCase.Substring(10);

                            strCreateScr = strCreateScr.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xWHERE_CONDITIONSx]", strConti)
                                            .Replace("[xWHERE_CONDITIONS_CASEx]", strContiCase);

                            # endregion
                        }
                    }
                    else if (string.Compare(ufnUspNmArr[0], "usp", StringComparison.CurrentCultureIgnoreCase) == 0)
                    {
                        filePath = string.Concat(Templates, @"\", CreatedScripts, @"\", "04_CreateUsp.sql");

                        if (string.Compare(ufnUspNmArr[1], "IsExists", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region IsExists

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;

                            foreach (FieldObject fldObj in pTableObject.FieldObjects)
                            {
                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);
                            }

                            strParams = strParams.Substring(4);
                            strFnArgs = strFnArgs.Substring(2);

                            strCreateScr = strCreateScr.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs);

                            # endregion
                        }
                        else if (string.Compare(ufnUspNmArr[1], "Insert", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region Insert

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;
                            string strInsFlds = string.Empty;
                            string strInsVars = string.Empty;

                            foreach (FieldObject fldObj in pTableObject.FieldObjects)
                            {
                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);

                                strInsFlds = string.Concat(strInsFlds, "\n\t\t\t\t, [", fldObj.COLUMN_NAME, "]");
                                strInsVars = string.Concat(strInsVars, "\n\t\t\t\t, @", fldObj.COLUMN_NAME);
                            }

                            strParams = strParams.Substring(4);
                            strFnArgs = strFnArgs.Substring(2);
                            strInsFlds = strInsFlds.Substring(7);
                            strInsVars = strInsVars.Substring(7);

                            strCreateScr = strCreateScr.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs)
                                            .Replace("[xINSERT_FIELDSx]", strInsFlds)
                                            .Replace("[xINSERT_VARSx]", strInsVars);

                            # endregion
                        }
                        else if (string.Compare(ufnUspNmArr[1], "Update", StringComparison.CurrentCultureIgnoreCase) == 0)
                        {
                            # region Update

                            string strParams = string.Empty;
                            string strFnArgs = string.Empty;
                            string strInsFlds = string.Empty;
                            string strSelFlds = string.Empty;
                            string strUpdFlds = string.Empty;

                            foreach (FieldObject fldObj in pTableObject.FieldObjects)
                            {
                                strParams = string.Concat(strParams, "\n\t, @", fldObj.COLUMN_NAME
                                    , " ", fldObj.DATA_TYPE, ""
                                    , (fldObj.CHARACTER_MAXIMUM_LENGTH == 0) ? string.Empty : string.Concat("(", fldObj.CHARACTER_MAXIMUM_LENGTH, ")")
                                    , (fldObj.IS_NULLABLE) ? " = NULL" : string.Empty);

                                strFnArgs = string.Concat(strFnArgs, ", @", fldObj.COLUMN_NAME);

                                strInsFlds = string.Concat(strInsFlds, "\n\t\t\t\t\t\t, [", fldObj.COLUMN_NAME, "]");
                                strSelFlds = string.Concat(strSelFlds, "\n\t\t\t\t\t, [", pTableObject.TABLE_NAME, "].[", fldObj.COLUMN_NAME, "]");
                                strUpdFlds = string.Concat(strUpdFlds, "\n\t\t\t\t\t, [", pTableObject.TABLE_NAME, "].["
                                    , fldObj.COLUMN_NAME, "] = @", fldObj.COLUMN_NAME);
                            }

                            strParams = strParams.Substring(4);
                            strFnArgs = strFnArgs.Substring(2);
                            strInsFlds = strInsFlds.Substring(7);
                            strSelFlds = strSelFlds.Substring(6);
                            strUpdFlds = strUpdFlds.Substring(8);

                            strCreateScr = strCreateScr.Replace("[xINPUT_PARAMSx]", strParams)
                                            .Replace("[xFN_ARGSx]", strFnArgs)
                                            .Replace("[xINSERT_FIELDSx]", strInsFlds)
                                            .Replace("[xSELECT_FIELDSx]", strSelFlds)
                                            .Replace("[xUPDATE_FIELDSx]", strUpdFlds);

                            # endregion
                        }
                    }
                    else
                    {
                        filePath = string.Empty;
                    }

                    using (StreamWriter sw = new StreamWriter(filePath, true))
                    {
                        strCreateScr = strCreateScr.Replace("[xTABLE_NAMEx]", ufnUspNmArr[2])
                                    .Replace("[xPK_DATA_TYPEx]", pTableObject.PkDataType);

                        sw.WriteLine(strCreateScr);
                        sw.WriteLine(string.Empty);
                        sw.WriteLine(string.Concat("-- ************************* ", item.Key, " ************************* Completed."));
                        sw.WriteLine(string.Empty);

                        sw.Close();
                    }

                }
            }
            catch (Exception ex)
            {
                retAns = ex.ToString();
            }
            finally
            {
                //
            }

            return retAns;
        }

        # endregion
    }
}
