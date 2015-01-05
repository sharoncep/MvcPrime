-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinic_PatientVisit]    Script Date: 08/30/2013 11:56:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinic_PatientVisit]    Script Date: 08/30/2013 11:56:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [Patient].[usp_GetXmlReportClinic_PatientVisit]	
     @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	WITH CTE AS
	(
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY [PAT_VST].[CASE_NO] ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN_TMP]
			, [PAT_VST].*
		FROM
			[dbo].[uvw_PatientVisit] [PAT_VST]
		INNER JOIN
			[User].[UserClinic] UC WITH (NOLOCK)
		ON
			[UC].[ClinicID] = [PAT_VST].[CLINIC_ID]
		WHERE
			 [UC].[UserID] = @ID
		AND
			[UC].[IsActive] = 1
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportClinic_PatientVisit]  @ID = 1
END






GO



-----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientDocument]    Script Date: 09/03/2013 15:38:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_PatientDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientDocument]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientDocument]    Script Date: 09/03/2013 15:38:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientDocument] 
	 @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([Patient].[PatientDocument].[ServiceOrFromDate]) FROM [Patient].[PatientDocument];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientDocument].[ServiceOrFromDate]) FROM [Patient].[PatientDocument];
	END
	
	IF @StartBy IS NULL
	BEGIN
		SELECT @StartBy = '';
	END
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Patient].[PatientDocument].[PatientDocumentID]
		, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'Document' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END ASC,
				CASE WHEN @orderByField = 'Document' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END DESC,
								

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientDocument].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientDocument].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientDocument] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientDocument].[PatientID] = [Patient].[Patient].[PatientID]		
	INNER JOIN
		[MasterData].[DocumentCategory] WITH (NOLOCK)
	ON 
		[Patient].[PatientDocument].[DocumentCategoryID] = [MasterData].[DocumentCategory].[DocumentCategoryID]	
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[PatientDocument].[ServiceOrFromDate] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[PatientDocument].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientDocument].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	

	DECLARE @TBL_RES TABLE
	(
		[PatientDocumentID] INT NOT NULL
		, [Name] NVARCHAR(500) NOT NULL
		, [DocumentCategoryName] NVARCHAR(155) NOT NULL
		, [DocumentRelPath]NVARCHAR(350)  NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [IsActive] BIT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[PatientDocument].[PatientDocumentID]
		,(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		,[DocumentCategory].[DocumentCategoryName] + ' ['+ [DocumentCategory].[DocumentCategoryCode] + ']'
		,[Patient].[PatientDocument].[DocumentRelPath]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientDocument].[IsActive]
	FROM
		[Patient].[PatientDocument] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientDocument].[PatientDocumentID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientDocument].[PatientID] = [Patient].[Patient].[PatientID]
	INNER JOIN
		[MasterData].[DocumentCategory] WITH (NOLOCK)
	ON 
		[Patient].[PatientDocument].[DocumentCategoryID] = [MasterData].[DocumentCategory].[DocumentCategoryID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Patient].[usp_GetBySearch_PatientDocument] @StartBy=' '
	-- EXEC [Patient].[usp_GetBySearch_PatientDocument] @ClinicTypeID = 2, @SearchName  = NULL, @StartBy = NULL, @PatientID = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



-----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetPrevVisit_PatientVisit]    Script Date: 09/03/2013 17:04:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetPrevVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetPrevVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetPrevVisit_PatientVisit]    Script Date: 09/03/2013 17:04:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetPrevVisit_PatientVisit]
	@PatientVisitID BIGINT
	, @PatientID BIGINT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		,[Patient].[PatientVisit].[DOS] 
		,[Patient].[PatientVisit].[ClaimStatusID]
		,[Patient].[PatientVisit].[PatientVisitComplexity]
		,CASE WHEN [Patient].[PatientVisit].[AssignedTo] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[AssignedTo])END AS [AssignedTo]
		,CASE WHEN [Patient].[PatientVisit].[TargetBAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetBAUserID])END AS [TargetBAUserID]
		,CASE WHEN [Patient].[PatientVisit].[TargetQAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetQAUserID])END AS [TargetQAUserID]
		,CASE WHEN [Patient].[PatientVisit].[TargetEAUserID] IS NULL THEN NULL ELSE (SELECT LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))) FROM [User].[User] WHERE [User].[User].[UserID] = [Patient].[PatientVisit].[TargetEAUserID])END AS [TargetEAUserID]
	FROM
		[Patient].[PatientVisit]
	WHERE
		[Patient].[PatientVisit].[PatientID] = @PatientID
	AND
		[Patient].[PatientVisit].[PatientVisitID] <> @PatientVisitID
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	ORDER BY 
		[Patient].[PatientVisit].[DOS]
	DESC
		
	-- EXEC [Patient].[usp_GetPrevVisit_PatientVisit] 11522 , 11522
END





GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 09/04/2013 14:23:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Insert_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Insert_UserReport]
GO

/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 09/04/2013 14:23:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Audit].[usp_Insert_UserReport]
	@ReportTypeID TINYINT
	, @ReportObjectID BIGINT = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @CurrentModificationBy INT
	, @NxtIdn NVARCHAR(5)
	, @UserReportID SMALLINT OUTPUT
	, @ExcelFileName NVARCHAR(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		IF @ReportObjectID IS NOT NULL AND @ReportObjectID = 0
		BEGIN
			SELECT @ReportObjectID = NULL;		
		END
		
		UPDATE
			UR
		SET
			[UR].[CurrImportStartOn] = [UR].[ExcelImportedOn]
			, [UR].[CurrImportEndOn] = [UR].[ExcelImportedOn]
		FROM
			[Audit].[UserReport] UR
		WHERE
			[UR].[CurrImportEndOn] IS NULL
		AND
			DATEDIFF(MINUTE, [UR].[CurrImportStartOn], GETDATE()) > 300;
			
		SELECT @UserReportID = [Audit].[ufn_IsExists_UserReport] (@ReportTypeID, @ReportObjectID, @DateFrom, @DateTo, @CurrentModificationBy);
		IF (@UserReportID = 0)
		BEGIN
			DECLARE @XL_FL_NM NVARCHAR(50);
			SELECT @XL_FL_NM = @NxtIdn;
			SELECT @XL_FL_NM = REPLICATE('0', 5 - LEN(@XL_FL_NM)) + @XL_FL_NM;
			SELECT @XL_FL_NM = 'CP' + @XL_FL_NM + 'CLAIMSTATUS.xlsx';
			
			INSERT INTO [Audit].[UserReport] ([ReportTypeID], [ReportObjectID], [DateFrom], [DateTo], [UserID], [ExcelFileName], [ExcelImportedOn], [IsSuccess], [CurrImportStartOn])
				VALUES(@ReportTypeID, @ReportObjectID, @DateFrom, @DateTo, @CurrentModificationBy, @XL_FL_NM, '1900-Jan-01', 0, @CurrentModificationOn);
				
			SELECT @UserReportID = [Audit].[ufn_IsExists_UserReport] (@ReportTypeID, @ReportObjectID, @DateFrom, @DateTo, @CurrentModificationBy);
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT [UR].* FROM [Audit].[UserReport] UR WITH (NOLOCK) WHERE [UR].[UserReportID] = @UserReportID AND [UR].[CurrImportEndOn] IS NULL)
			BEGIN
				SELECT @UserReportID = 0;
			END
			ELSE
			BEGIN
				UPDATE
					[UR]
				SET
					[UR].[CurrImportStartOn] = @CurrentModificationOn
					, [UR].[IsSuccess] = 0
					, [UR].[CurrImportEndOn] = NULL
				FROM
					[Audit].[UserReport] UR
				WHERE
					[UR].[UserReportID] = @UserReportID;
			END
		END
		
		SELECT @ExcelFileName = [UR].[ExcelFileName] FROM [Audit].[UserReport] UR WHERE [UR].[UserReportID] = @UserReportID;
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @UserReportID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
	
	-- EXEC [Audit].[usp_Insert_UserReport] @ReportTypeID = 1, @CurrentModificationBy = 1, @UserReportID = 0, @ExcelFileName = '', @NxtIdn = 
	-- EXEC [Audit].[usp_Insert_UserReport] @ReportTypeID = 1, @CurrentModificationBy = 116, @UserReportID = 0, @ExcelFileName = '', @NxtIdn = 
END






GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWise_PatientVisit]    Script Date: 09/04/2013 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgentWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgentWise_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWise_PatientVisit]    Script Date: 09/04/2013 16:25:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetXmlReportAgentWise_PatientVisit]	
    @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	 = NULL	
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE AS
	(
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY [PAT_VST].[CASE_NO] ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN_TMP]
			, [PAT_VST].*
		FROM
			[dbo].[uvw_PatientVisit] PAT_VST
		INNER JOIN 
			[Claim].[ClaimProcess] CP WITH (NOLOCK)
		ON
			[CP].[PatientVisitID] = [PAT_VST].[CASE_NO]
		WHERE
			[CP].[CreatedBy] = @ID
		AND
			[CP].[IsActive] = 1
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportAgentWise_PatientVisit]  @ID = 1
END






GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]    Script Date: 09/05/2013 09:59:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]    Script Date: 09/05/2013 09:59:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]	
     @ID INT
     ,@DATE_FROM DATE
     ,@DATE_TO DATE		
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE AS
	(
		SELECT
			ROW_NUMBER() OVER (PARTITION BY [PAT_VST].[CASE_NO] ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN_TMP]
			, [PAT_VST].*
		FROM
			[dbo].[uvw_PatientVisit] [PAT_VST]
		INNER JOIN 
			[Claim].[ClaimProcess] CP WITH (NOLOCK)
		ON
			[CP].[PatientVisitID] = [PAT_VST].[CASE_NO]
		WHERE
			[CP].[CreatedBy] = @ID
		AND
			[PAT_VST].[DOS] BETWEEN @DATE_FROM AND @DATE_TO
		AND
			[CP].[IsActive] = 1
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportAgentWise_PatientVisit]  @ID = 1
END






GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetLastStatus_SyncStatus]    Script Date: 09/05/2013 11:29:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetLastStatus_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetLastStatus_SyncStatus]
GO


/****** Object:  StoredProcedure [Audit].[usp_GetLastStatus_SyncStatus]    Script Date: 09/05/2013 11:29:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Audit].[usp_GetLastStatus_SyncStatus] 
AS
BEGIN
	SET NOCOUNT ON;
		
	IF EXISTS(SELECT [Audit].[SyncStatus].[SyncStatusID] FROM [Audit].[SyncStatus] WITH (NOLOCK) WHERE [Audit].[SyncStatus].[EndOn] IS NULL)
	BEGIN	
		SELECT 
			TOP 1 [S].* 
			, (LTRIM(RTRIM([U].[LastName] + ' ' + [U].[FirstName] + ' ' + ISNULL ([U].[MiddleName], '')))) AS [DISP_NAME]
		FROM 
			[Audit].[SyncStatus] S WITH (NOLOCK)
		LEFT JOIN
			[User].[User] U WITH (NOLOCK)
		ON
			[S].[UserID] = [U].[UserID]
		WHERE
			[S].[EndOn] IS NULL
		ORDER BY 
			[S].[SyncStatusID] 
		DESC;	
	END
	ELSE
	BEGIN	
		SELECT 
			TOP 1 [S].* 
			, (LTRIM(RTRIM([U].[LastName] + ' ' + [U].[FirstName] + ' ' + ISNULL ([U].[MiddleName], '')))) AS [DISP_NAME]
		FROM 
			[Audit].[SyncStatus] S WITH (NOLOCK)
		LEFT JOIN
			[User].[User] U WITH (NOLOCK)
		ON
			[S].[UserID] = [U].[UserID]
		WHERE
			[S].[IsSuccess] = 1
		ORDER BY 
			[S].[SyncStatusID] 
		DESC;	
	END
			
	-- EXEC [Audit].[usp_GetLastStatus_SyncStatus] 
	-- EXEC [Audit].[usp_GetLastStatus_SyncStatus] 
END







GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetExcel_UserReport]    Script Date: 09/05/2013 14:01:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetExcel_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetExcel_UserReport]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetExcel_UserReport]    Script Date: 09/05/2013 14:01:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Audit].[usp_GetExcel_UserReport]
	@UserID INT
	, @UserReportID SMALLINT
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		[UR].[UserReportID]
		 ,[UR].[ExcelFileName]
		 ,[UR].[DateFrom]
		 ,[UR].[DateTo]
		 ,[UR].[CurrImportEndOn]
	FROM
		[Audit].[UserReport] UR
	WHERE
		[UR].[UserID] = @UserID
	AND
		[UR].[UserReportID] = @UserReportID;
		
	-- EXEC [Audit].[usp_GetExcel_UserReport] @UserID = 1, @UserReportID = 1
END




GO



-----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 09/05/2013 14:27:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClaimAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 09/05/2013 14:27:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--By Sai:Manager Role - Case Agent


CREATE PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
    @ClinicID INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SELECT @SearchName = '';
	END
	
		DECLARE @PatientVisitID BIGINT;
	BEGIN TRY
		SELECT @PatientVisitID = CAST (@SearchName AS BIGINT);
	END TRY
	BEGIN CATCH
		SELECT @PatientVisitID = 0;
	END CATCH
	
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'TargetBAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetBAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetBAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetBAUserID] END DESC,
				
				CASE WHEN @OrderByField = 'TargetQAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetQAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetQAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetQAUserID] END DESC,
			    
			    CASE WHEN @OrderByField = 'TargetEAUserID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[TargetEAUserID] END ASC,
				CASE WHEN @orderByField = 'TargetEAUserID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[TargetEAUserID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] < 22	
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	DECLARE @TBL_RES TABLE
	(
		[PAT_NAME] NVARCHAR(500) NOT NULL
		, [CHART_NUMBER] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PATIENT_VISIT_ID] BIGINT NOT NULL
		, [PATIENT_VISIT_COMPLEXITY] TINYINT NOT NULL
		, [TARGET_BA_USER] NVARCHAR(400) NULL
		, [TARGET_BA_USERID] INT NULL
		, [TARGET_QA_USER] NVARCHAR(400) NULL
		, [TARGET_QA_USERID] INT NULL
		, [TARGET_EA_USER] NVARCHAR(400) NULL
		, [TARGET_EA_USERID] INT NULL
		, [CLAIM_STATUS] TINYINT NULL 
		, [IS_ACTIVE] BIT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
		,ChartNumber
		,DOS
		,PatientVisitID
		,PatientVisitComplexity
		,NULL
		,TargetBAUserID
		,NULL
		,TargetQAUserID
		,NULL
		,TargetEAUserID
		,ClaimStatusID
		,PatientVisit.IsActive
	FROM
		[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	UPDATE
		T
	SET
		[T].[TARGET_BA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U 
	ON
		[U].[UserID] = [T].[TARGET_BA_USERID]
	WHERE
		[T].[TARGET_BA_USERID] IS NOT NULL;
		
	UPDATE
		T
	SET
		[T].[TARGET_QA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U
	ON
		[U].[UserID] = [T].[TARGET_QA_USERID]
	WHERE
		[T].[TARGET_QA_USERID] IS NOT NULL;
		
	UPDATE
		T
	SET
		[T].[TARGET_EA_USER] = [U].[LastName] + ' ' + [U].[FirstName] + ISNULL((' ' + [U].[MiddleName]), '') + ' [' + [U].[UserName] + ']'
	FROM
		@TBL_RES T
	INNER JOIN
		[User].[User] U
	ON
		[U].[UserID] = [T].[TARGET_EA_USERID]
	WHERE
		[T].[TARGET_EA_USERID] IS NOT NULL;
	
	SELECT * FROM @TBL_RES;	
	 
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @ClinicID = '5',@SearchName = '3893'
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @SearchName  = 'DIXID000', @StartBy = 'c', @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D',@ClinicID=2
END










GO



-----------------------------------------------------------------------
