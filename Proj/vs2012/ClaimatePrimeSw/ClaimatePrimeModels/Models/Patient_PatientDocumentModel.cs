using System;
using System.Collections.Generic;
using System.Data.Objects;
using System.IO;
using System.Linq;
using ClaimatePrimeConstants;
using ClaimatePrimeEFWork.EFContexts;
using ClaimatePrimeModels.SecuredFolder.BaseModels;
using ClaimatePrimeModels.SecuredFolder.Commons;

namespace ClaimatePrimeModels.Models
{
    #region PatientDocument

    #region Save

    /// <summary>
    /// 
    /// </summary>
    public class PatientDocumentSaveModel : BaseSaveModel
    {
        #region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_PatientDocument_Result PatientDocumentResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_DocumentCategory_Result DocumentCategoryResult
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public usp_GetByPkId_General_Result GeneralResult
        {
            get;
            set;
        }



        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientDocumentResult_Patient
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String PatientDocumentResult_DocumentCategory
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.Boolean CanImg
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrRootPath
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public global::System.String FileSvrPatientDocPath
        {
            get;
            set;
        }

        #endregion

        #region AbstractMethods

        protected override bool SaveInsert(int pUserID)
        {
            ObjectParameter PatientDocumentID = ObjParam("PatientDocument");

            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                if (!(string.IsNullOrWhiteSpace(PatientDocumentResult.DocumentRelPath)))
                {
                    Int64 ID = ((new List<usp_GetNext_Identity_Result>(ctx.usp_GetNext_Identity("Patient", "PatientDocument"))).FirstOrDefault().NEXT_INDENTITY);

                    FileSvrPatientDocPath = string.Concat(FileSvrPatientDocPath, @"\P_", ID);
                    if (Directory.Exists(FileSvrPatientDocPath))
                    {
                        Directory.Delete(FileSvrPatientDocPath, true);
                    }
                    Directory.CreateDirectory(FileSvrPatientDocPath);

                    FileSvrPatientDocPath = string.Concat(FileSvrPatientDocPath, @"\", "U_1", Path.GetExtension(PatientDocumentResult.DocumentRelPath));   // File Uploading
                    if (File.Exists(FileSvrPatientDocPath))
                    {
                        File.Delete(FileSvrPatientDocPath);
                    }
                    File.Move(PatientDocumentResult.DocumentRelPath, FileSvrPatientDocPath);
                    FileSvrPatientDocPath = FileSvrPatientDocPath.Replace(FileSvrRootPath, string.Empty);
                    PatientDocumentResult.DocumentRelPath = FileSvrPatientDocPath.Substring(1);
                }

                ctx.usp_Insert_PatientDocument(PatientDocumentResult.PatientID, PatientDocumentResult.DocumentCategoryID, PatientDocumentResult.ServiceOrFromDate, PatientDocumentResult.ToDate, PatientDocumentResult.DocumentRelPath, string.Empty, pUserID, PatientDocumentID);

                if (HasErr(PatientDocumentID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;

        }

        protected override bool SaveUpdate(int pUserID)
        {
            using (EFContext ctx = new EFContext())
            {
                BeginDbTrans(ctx);

                ObjectParameter objPatientID = ObjParam("PatientDocument");

                ctx.usp_Update_PatientDocument(PatientDocumentResult.PatientID, PatientDocumentResult.DocumentCategoryID, PatientDocumentResult.ServiceOrFromDate, PatientDocumentResult.ToDate, PatientDocumentResult.DocumentRelPath, PatientDocumentResult.Comment, PatientDocumentResult.IsActive, LastModifiedBy, LastModifiedOn, pUserID, objPatientID);

                if (HasErr(objPatientID, ctx))
                {
                    RollbackDbTrans(ctx);

                    return false;
                }

                CommitDbTrans(ctx);
            }

            return true;
        }

        public List<string> GetAutoCompleteDocumentCategory(string stats)
        {
            List<string> retRes = new List<string>();

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetAutoComplete_DocumentCategory_Result> spRes = new List<usp_GetAutoComplete_DocumentCategory_Result>(ctx.usp_GetAutoComplete_DocumentCategory(stats));

                foreach (usp_GetAutoComplete_DocumentCategory_Result item in spRes)
                {
                    retRes.Add(item.NAME_CODE);
                }
            }

            return retRes;

            // throw new Exception("GetAutoCompleteDocumentCategory(string stats)");
        }
        public List<string> GetAutoCompleteDocumentCategoryID(string selText)
        {

            List<string> retRes = new List<string>();
            Int32 indx1 = selText.LastIndexOf("[");
            Int32 indx2 = selText.LastIndexOf("]");

            if ((indx1 == -1) || (indx2 == -1))
            {
                return ((new[] { "0" }).ToList<string>());
            }

            indx1++;
            string selCode = selText.Substring(indx1, (indx2 - indx1));

            //retRes.Add("54321");

            using (EFContext ctx = new EFContext())
            {
                List<usp_GetIDAutocomplete_DocumentCategory_Result> spRes = new List<usp_GetIDAutocomplete_DocumentCategory_Result>(ctx.usp_GetIDAutocomplete_DocumentCategory(selCode, true));

                foreach (usp_GetIDAutocomplete_DocumentCategory_Result item in spRes)
                {
                    retRes.Add(item.DocumentCategoryID.ToString());
                }
            }
            return retRes;

            // throw new Exception("GetAutoCompleteDocumentCategoryID(string selText)");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pID"></param>
        /// <param name="pIsActive"></param>
        /// 




        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID > 0)
            {
                using (EFContext ctx = new EFContext())
                {
                    PatientDocumentResult = (new List<usp_GetByPkId_PatientDocument_Result>(ctx.usp_GetByPkId_PatientDocument(pID, pIsActive))).FirstOrDefault();

                }
            }

            if (PatientDocumentResult == null)
            {
                PatientDocumentResult = new usp_GetByPkId_PatientDocument_Result() { IsActive = true };
            }

            using (EFContext ctx = new EFContext())
            {

                DocumentCategoryResult = (new List<usp_GetByPkId_DocumentCategory_Result>(ctx.usp_GetByPkId_DocumentCategory(PatientDocumentResult.DocumentCategoryID, pIsActive))).FirstOrDefault();

            }

            if (DocumentCategoryResult == null)
            {
                DocumentCategoryResult = new usp_GetByPkId_DocumentCategory_Result() { IsActive = true };
            }



            # region ChartNumber

            using (EFContext ctx = new EFContext())
            {
                usp_GetNameByID_Patient_Result spRes = (new List<usp_GetNameByID_Patient_Result>(ctx.usp_GetNameByID_Patient(PatientDocumentResult.PatientID, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    PatientDocumentResult_Patient = spRes.NAME_CODE;
                }
            }

            # endregion

            # region DocumentCategory

            using (EFContext ctx = new EFContext())
            {
                usp_GetDocumentCategoryByID_DocumentCategory_Result spRes = (new List<usp_GetDocumentCategoryByID_DocumentCategory_Result>(ctx.usp_GetDocumentCategoryByID_DocumentCategory(PatientDocumentResult.DocumentCategoryID, pIsActive))).FirstOrDefault();

                if (spRes != null)
                {
                    PatientDocumentResult_DocumentCategory = spRes.DocumentCategoryName + " [" + spRes.DocumentCategoryCode + "]";
                }
            }

            # endregion





            EncryptAudit(PatientDocumentResult.PatientDocumentID, PatientDocumentResult.LastModifiedBy, PatientDocumentResult.LastModifiedOn);


        }







        public bool GetIsInPatient(byte id)
        {
            # region DocumentCategoryResult



            using (EFContext ctx = new EFContext())
            {

                DocumentCategoryResult = (new List<usp_GetByPkId_DocumentCategory_Result>(ctx.usp_GetByPkId_DocumentCategory(id, true))).FirstOrDefault();

            }

            if (DocumentCategoryResult == null)
            {
                return false;
            }

            return DocumentCategoryResult.IsInPatientRelated;

            # endregion
        }

        public void GetChartNumber()
        {
            # region ChartNumber

            using (EFContext ctx = new EFContext())
            {
                usp_GetNameByID_Patient_Result spRes = (new List<usp_GetNameByID_Patient_Result>(ctx.usp_GetNameByID_Patient(PatientDocumentResult.PatientID, true))).FirstOrDefault();

                if (spRes != null)
                {
                    PatientDocumentResult_Patient = spRes.NAME_CODE;
                }
            }

            # endregion
        }

        public int GetFileSize()
        {
            using (EFContext ctx = new EFContext())
            {

                GeneralResult = (new List<usp_GetByPkId_General_Result>(ctx.usp_GetByPkId_General(1, true))).FirstOrDefault();

            }

            if (GeneralResult == null)
            {
                GeneralResult = new usp_GetByPkId_General_Result() { IsActive = true };
            }

            return GeneralResult.UploadMaxSizeInMB;
        }

        #endregion


    }

    #endregion

    #region Search

    /// <summary>
    /// 
    /// </summary>
    public class PatientDocumentSearchModel : BaseSearchModel
    {
        #region Properties

        private Nullable<global::System.Int64> _PatientID;

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<PatientDocumentSearchSubModel> PatientDocumentSearchSubModels
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public List<usp_GetBySearch_PatientDocument_Result> PatientDocumentSearch
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        public Nullable<global::System.Int64> PatientID
        {
            get
            {
                return _PatientID;
            }
            set
            {
                if (value == 0)
                {
                    _PatientID = null;
                }
                else
                {
                    _PatientID = value;
                }
            }
        }

        public usp_GetByPkId_Patient_Result PatientResult { get; set; }

        #endregion

        #region Abstract
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pCurrPageNumber"></param>
        /// <param name="pIsActive"></param>
        /// <param name="pRecordsPerPage"></param>
        protected override void FillBySearch(long pCurrPageNumber, bool? pIsActive, short pRecordsPerPage)
        {
            using (EFContext ctx = new EFContext())
            {
                PatientDocumentSearch = new List<usp_GetBySearch_PatientDocument_Result>(ctx.usp_GetBySearch_PatientDocument(SearchName, DateFrom, DateTo, StartBy, pCurrPageNumber, pRecordsPerPage, OrderByField, OrderByDirection, pIsActive));
                //Patient = new List<usp_GetBySearch_Patient_Result>(ctx.usp_GetBySearch_Patient(StartBy, ClinicID));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="pIsActive"></param>
        protected override void FillByAZ(bool? pIsActive)
        {
            using (EFContext ctx = new EFContext())
            {
                List<usp_GetByAZ_PatientDocument_Result> lst = new List<usp_GetByAZ_PatientDocument_Result>(ctx.usp_GetByAZ_PatientDocument(SearchName, DateFrom, DateTo, pIsActive));

                foreach (usp_GetByAZ_PatientDocument_Result item in lst)
                {
                    AZModels(new AZModel()
                    {
                        AZ = item.AZ,
                        AZ_COUNT = item.AZ_COUNT

                    });
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="PatientDocumentID"></param>
        /// <param name="isactive"></param>
        public void FillCategoryPatient(long PatientDocumentID, bool? isactive)
        {
            List<usp_GetByPatientID_PatientDocument_Result> items;

            using (EFContext ctx = new EFContext())
            {
                items = new List<usp_GetByPatientID_PatientDocument_Result>(ctx.usp_GetByPatientID_PatientDocument(PatientDocumentID, isactive));
            }

            PatientDocumentSearchSubModels = new List<PatientDocumentSearchSubModel>();
            PatientDocumentSearchSubModel objSubModel = null;

            byte prevDocCatID = 0;

            foreach (usp_GetByPatientID_PatientDocument_Result item in items)
            {
                if (prevDocCatID != item.DocumentCategoryID)
                {
                    if (prevDocCatID > 0)
                    {
                        PatientDocumentSearchSubModels.Add(objSubModel);
                    }

                    objSubModel = new PatientDocumentSearchSubModel() { CategoryName = item.NAME_CODE, IsActive = item.IsActive, PatientDocumentResults = new List<usp_GetByPkId_PatientDocument_Result>() };

                    prevDocCatID = item.DocumentCategoryID;
                }

                objSubModel.PatientDocumentResults.Add(new usp_GetByPkId_PatientDocument_Result() { DocumentRelPath = item.DocumentRelPath, ServiceOrFromDate = item.ServiceOrFromDate, ToDate = item.ToDate, PatientDocumentID = item.PatientDocumentID, IsActive = item.IsActive });
            }

            if (objSubModel != null)
            {
                PatientDocumentSearchSubModels.Add(objSubModel);
            }
        }
        #endregion

        #region Public

        /// <summary>
        /// 
        /// </summary>
        public void FillIsActive(Nullable<long> patientID)
        {
            using (EFContext ctx = new EFContext())
            {
                PatientResult = new List<usp_GetByPkId_Patient_Result>(ctx.usp_GetByPkId_Patient(patientID, null)).FirstOrDefault();
            }
        }

        #endregion
    }

    # region PatientDocumentSearchSubModel

    /// <summary>
    /// 
    /// </summary>
    public class PatientDocumentSearchSubModel : BaseModel
    {
        # region Properties

        /// <summary>
        /// Get or Set
        /// </summary>
        public string CategoryName
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public bool IsActive
        {
            get;
            set;
        }

        /// <summary>
        /// Get or Set
        /// </summary>
        public List<usp_GetByPkId_PatientDocument_Result> PatientDocumentResults
        {
            get;
            set;
        }

        # endregion
    }

    # endregion

    #endregion

    #endregion

    #region PatDoc - Assigned Claims

    public class PatientDocumentViewModel : BaseSaveModel
    {
        #region Properties

        public List<usp_GetByPatientID_PatientDocument_Result> PatDocumentResult { get; set; }

        #endregion

        #region Abstract

        protected override void FillByID(long pID, bool? pIsActive)
        {
            if (pID == 0)
            {
                PatDocumentResult = new List<usp_GetByPatientID_PatientDocument_Result>();
            }
            else
            {
                using (EFContext ctx = new EFContext())
                {
                    PatDocumentResult = new List<usp_GetByPatientID_PatientDocument_Result>(ctx.usp_GetByPatientID_PatientDocument(pID, true));
                }
            }
        }
        protected override bool SaveInsert(int pUserID)
        {
            throw new NotImplementedException();
        }

        protected override bool SaveUpdate(int pUserID)
        {
            throw new NotImplementedException();
        }

        #endregion
    }

    #endregion
}
