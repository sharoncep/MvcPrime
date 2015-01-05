

/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 08/19/2013 09:37:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClaimAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 08/19/2013 09:37:11 ******/
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



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]    Script Date: 08/12/2013 10:01:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetBySearchCaseReopen_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]    Script Date: 08/12/2013 10:01:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--By Sai:Manager Role - Case Reclose Search - Reclosing the already reoopened case in Manager Case Reopen page



CREATE PROCEDURE [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]
	  @ClinicID INT
	, @AssignedTo INT = NULL
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage) 
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
		
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	
	AND	
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] > 25
		)
		--[ClaimProcess].[ClaimStatusID] > 25 --If anything happens we need to change this to 21
	--AND
	--  	[ClaimProcess].[ClaimStatusID] < 30 
	AND
		[Patient].[PatientVisit].[ClaimStatusID] < 30
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [PatChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT 
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[Patient].[PatientVisit].[LastModifiedOn]
	DESC;
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Claim].[usp_GetBySearch_ClaimProcess] @ClinicID = 1, @StatusIDs = '3,5', @AssignedTo= 101
	-- [Claim].[usp_GetBySearchCaseReopen_ClaimProcess] @ClinicID = 2, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25', @SearchName = 'DVORAK VIRGINIA M'	-- CREATED
	-- EXEC [Claim].[usp_GetBySearch_ClaimProcess] @ClinicID = 1, @StatusIDs = '3'
END









GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Audit].[usp_GetByUserID_UserPassword]    Script Date: 08/12/2013 10:02:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetByUserID_UserPassword]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetByUserID_UserPassword]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetByUserID_UserPassword]    Script Date: 08/12/2013 10:02:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- By Sai:For Change Password

CREATE PROCEDURE [Audit].[usp_GetByUserID_UserPassword] 
	@UserID INT
	,@RecCnt INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [ALL_CAPS_PASSWORD] NVARCHAR(200) NOT NULL
	);
	
	INSERT INTO
		@TBL_RES
	SELECT TOP (@RecCnt)
		[Audit].[UserPassword].[AllCapsPassword]
	FROM 
		[Audit].[UserPassword] WITH (NOLOCK)
	WHERE 
		[Audit].[UserPassword].[UserID] = @UserID
	ORDER BY
		[Audit].[UserPassword].[UserPasswordID]
	DESC;
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Audit].[usp_GetByUserID_UserPassword] @UserID = 8, @RecCnt = 2
END



GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_City]    Script Date: 08/12/2013 10:02:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_City]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_City]
GO


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_City]    Script Date: 08/12/2013 10:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--By Sai for City Search(Manager and Web Admin)

CREATE PROCEDURE [MasterData].[usp_GetBySearch_City]
	@SearchName NVARCHAR(150) = NULL
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
		SET @SearchName = '';
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[MasterData].[City].[CityID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CityName' AND @OrderByDirection = 'A' THEN [MasterData].[City].[CityName] END ASC,
				CASE WHEN @orderByField = 'CityName' AND @orderByDirection = 'D' THEN [MasterData].[City].[CityName] END DESC,
				
				CASE WHEN @OrderByField = 'ZipCode' AND @OrderByDirection = 'A' THEN [MasterData].[City].[ZipCode] END ASC,
				CASE WHEN @orderByField = 'ZipCode' AND @orderByDirection = 'D' THEN [MasterData].[City].[ZipCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[City].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[City].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[MasterData].[City] WITH (NOLOCK)
	WHERE
		[MasterData].[City].[CityName] LIKE @StartBy + '%' 
	AND
	(
		[MasterData].[City].[CityName] LIKE '%' + @SearchName + '%' 
	OR
		[MasterData].[City].[ZipCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[MasterData].[City].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[City].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[City].[CityID], [City].[ZipCode], [City].[CityName], [City].[IsActive]
	FROM
		[City] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [City].[CityID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [MasterData].[usp_GetBySearch_City] @SearchName  = '45'
	-- EXEC [MasterData].[usp_GetBySearch_City] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_ClaimMedia]    Script Date: 08/12/2013 10:03:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_ClaimMedia]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_ClaimMedia]
GO

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_ClaimMedia]    Script Date: 08/12/2013 10:03:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--By Sai:Manager Role - Claim Media Search

CREATE PROCEDURE [Transaction].[usp_GetBySearch_ClaimMedia]
	@SearchName NVARCHAR(150) = NULL
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
		SET @SearchName = '';
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Transaction].[ClaimMedia].[ClaimMediaID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClaimMediaName' AND @OrderByDirection = 'A' THEN [Transaction].[ClaimMedia].[ClaimMediaName] END ASC,
				CASE WHEN @orderByField = 'ClaimMediaName' AND @orderByDirection = 'D' THEN [Transaction].[ClaimMedia].[ClaimMediaName] END DESC,
				
				CASE WHEN @OrderByField = 'ClaimMediaCode' AND @OrderByDirection = 'A' THEN [Transaction].[ClaimMedia].[ClaimMediaCode] END ASC,
				CASE WHEN @orderByField = 'ClaimMediaCode' AND @orderByDirection = 'D' THEN [Transaction].[ClaimMedia].[ClaimMediaCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[ClaimMedia].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[ClaimMedia].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[ClaimMedia] WITH (NOLOCK)
	WHERE
		[Transaction].[ClaimMedia].[ClaimMediaName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[ClaimMedia].[ClaimMediaName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[ClaimMedia].[ClaimMediaCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[ClaimMedia].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[ClaimMedia].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ClaimMedia].[ClaimMediaID], [ClaimMedia].[ClaimMediaCode], [ClaimMedia].[ClaimMediaName], [ClaimMedia].[IsActive]
	FROM
		[ClaimMedia] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [ClaimMedia].[ClaimMediaID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_ClaimMedia] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_ClaimMedia] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_ClaimStatus]    Script Date: 08/12/2013 10:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_ClaimStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_ClaimStatus]
GO

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_ClaimStatus]    Script Date: 08/12/2013 10:03:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--By Sai:Manager Role - Claim Status Search

CREATE PROCEDURE [MasterData].[usp_GetBySearch_ClaimStatus]
@SearchName NVARCHAR(150) = NULL
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
		SET @SearchName = '';
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[MasterData].[ClaimStatus].[ClaimStatusID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClaimStatusName' AND @OrderByDirection = 'A' THEN [MasterData].[ClaimStatus].[ClaimStatusName] END ASC,
				CASE WHEN @orderByField = 'ClaimStatusName' AND @orderByDirection = 'D' THEN [MasterData].[ClaimStatus].[ClaimStatusName] END DESC,
				
			    CASE WHEN @OrderByField = 'ClaimStatusCode' AND @OrderByDirection = 'A' THEN [MasterData].[ClaimStatus].[ClaimStatusCode] END ASC,
				CASE WHEN @orderByField = 'ClaimStatusCode' AND @orderByDirection = 'D' THEN [MasterData].[ClaimStatus].[ClaimStatusCode] END DESC,
				
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[ClaimStatus].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[ClaimStatus].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	WHERE
		[MasterData].[ClaimStatus].[ClaimStatusName] LIKE @StartBy + '%' 
	AND
	
		[MasterData].[ClaimStatus].[ClaimStatusName] LIKE '%' + @SearchName + '%' 
	
	AND
		[MasterData].[ClaimStatus].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[ClaimStatus].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ClaimStatus].[ClaimStatusID], [ClaimStatus].[ClaimStatusName],[ClaimStatus].[ClaimStatusCode],[ClaimStatus].[IsActive]
	FROM
		[ClaimStatus] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [ClaimStatus].[ClaimStatusID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [MasterData].[usp_GetBySearch_ClaimStatus] @SearchName  = '45'
	-- EXEC [MasterData].[usp_GetBySearch_ClaimStatus] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END








GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Billing].[usp_GetBySearchAd_Clinic]    Script Date: 08/12/2013 10:04:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearchAd_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearchAd_Clinic]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetBySearchAd_Clinic]    Script Date: 08/12/2013 10:04:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- By Sai : Admin Role - Practice Clinic - Search


CREATE PROCEDURE [Billing].[usp_GetBySearchAd_Clinic]
	@SearchName NVARCHAR(150) = NULL
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
		SET @SearchName = '';
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Billing].[Clinic].[ClinicID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClinicName' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicName] END ASC,
				CASE WHEN @orderByField = 'ClinicName' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicName] END DESC,
				
				CASE WHEN @OrderByField = 'ClinicCode' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicCode] END ASC,
				CASE WHEN @orderByField = 'ClinicCode' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicCode] END DESC,
				
				CASE WHEN @OrderByField = 'IPAName' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[IPAName] END ASC,
				CASE WHEN @orderByField = 'IPAName' AND @orderByDirection = 'D' THEN [Billing].[IPA].[IPAName] END DESC,
				
				CASE WHEN @OrderByField = 'EntityTypeQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END ASC,
				CASE WHEN @orderByField = 'EntityTypeQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Clinic].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
			
	FROM
		[Billing].[Clinic] WITH (NOLOCK)
    INNER JOIN
	     [Billing].[IPA] WITH (NOLOCK)
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
	INNER JOIN
	     [Transaction].[EntityTypeQualifier] WITH (NOLOCK)
	ON
	    [Billing].[Clinic].EntityTypeQualifierID = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]  
	WHERE
		[Billing].[Clinic].[ClinicName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[Clinic].[ClinicName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Clinic].[ClinicCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[Clinic].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Clinic].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT 
		[Clinic].[ClinicID], [Clinic].[ClinicCode], [Clinic].[ClinicName], [Billing].[IPA].[IPAName], [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName], [Clinic].[IsActive]
	FROM
		[Clinic] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Clinic].[ClinicID]	
	INNER JOIN
	     [Billing].[IPA] WITH (NOLOCK)
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
	INNER JOIN
	     [Transaction].[EntityTypeQualifier] WITH (NOLOCK)
	ON
	    [Billing].[Clinic].EntityTypeQualifierID = [Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
END

-- EXEC [Billing].[usp_GetBySearchAd_Clinic] @UserID  = 1 ,  @StartBy='A'
	-- EXEC [Billing].[usp_GetBySearchAd_Clinic] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'







GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetCount_Clinic]    Script Date: 08/12/2013 10:04:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetCount_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetCount_Clinic]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetCount_Clinic]    Script Date: 08/12/2013 10:04:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--By Sai 

CREATE PROCEDURE [Billing].[usp_GetCount_Clinic]
	@UserID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		COUNT ([Billing].[Clinic].[ClinicID]) AS [ClinicCount]
	FROM
		[User].[UserClinic]  WITH (NOLOCK)
	INNER JOIN 
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID]=[User].[UserClinic].[ClinicID] 
	WHERE
		[User].[UserClinic].[UserID] = @UserID
	AND
		[User].[UserClinic].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	
	SELECT * FROM @TBL_RES;
	
	-- EXEC [Billing].[usp_GetCount_Clinic] @UserID = 101
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportAgentDate_PatientVisit]    Script Date: 08/12/2013 10:04:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportAgentDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportAgentDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportAgentDate_PatientVisit]    Script Date: 08/12/2013 10:04:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportAgentDate_PatientVisit]	
     @UserID INT	
     ,@DateFrom DATE
     ,@DateTo DATE
     
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @AGENT_TMP  TABLE
	(
	     [PK_ID] INT IDENTITY (1, 1)
		,[VISIT_ID] BIGINT NOT NULL	 
	);
	
	INSERT INTO
		@AGENT_TMP
		(
			[VISIT_ID]
		)
		SELECT DISTINCT 
			[Claim].[ClaimProcess].[PatientVisitID] 
		FROM 
			[Claim].[ClaimProcess] WITH (NOLOCK)
		WHERE 
			[Claim].[ClaimProcess].[CreatedBy] = @UserID
		AND
			[Claim].[ClaimProcess].[IsActive]=1
	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
    INNER JOIN 
		@AGENT_TMP
    ON
		VISIT_ID = [Patient].[PatientVisit].[PatientVisitID]
    WHERE
       [Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
    AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	--EXEC [Patient].[usp_GetReportAgentDate_PatientVisit]	 @UserID = 8
END



GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboard_PatientVisit]    Script Date: 08/12/2013 14:49:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboard_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboard_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboard_PatientVisit]    Script Date: 08/12/2013 14:49:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportDashboard_PatientVisit]	
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- SHARON
	
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[PatientVisitID] BIGINT
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
		SELECT @StatusID = 12;
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
		SELECT @StatusID = 22;
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF (@Desc = 'Re-Submitted' OR @Desc = 'Rejected')
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				 
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
				print @StatusIDs;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	-------
	ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	------
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] > 0
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
		(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
		);
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	-- SHARON
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[PatientVisitID]  IN
		(SELECT [PatientVisitID] FROM @SEARCH_TMP)
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	
	
	-- EXEC [Patient].[usp_GetReportDashboard_PatientVisit]  @UserID = 116, @Desc = 'BLOCKED', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END


GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardClinic_PatientVisit]    Script Date: 08/12/2013 17:02:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboardClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboardClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardClinic_PatientVisit]    Script Date: 08/12/2013 17:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportDashboardClinic_PatientVisit]
	@ClinicID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[PatientVisitID] BIGINT
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF @Desc = 'Re-Submitted' 
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > 0
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID]  = @ClinicID
		AND
		(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
		);
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[PatientVisitID]  IN
		(SELECT [PatientVisitID] FROM @SEARCH_TMP)
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	-- EXEC [Patient].[usp_GetReportDashboardClinic_PatientVisit]  @ClinicID = 17,  @Desc = 'BLOCKED', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetReportDashboardClinic_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END







GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 08/12/2013 17:33:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 08/12/2013 17:33:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
	@UserID BIGINT
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
AS
BEGIN
	-- SET NOCOUNT_BIG ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE 
	(
		[ClinicID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
			[User].[UserClinic].[ClinicID] 
		FROM 
			[User].[UserClinic]  WITH (NOLOCK)
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE 
			[User].[UserClinic].[UserID] = @UserID 
		AND 
			[User].[UserClinic].[IsActive] = 1 
		AND 
			[Billing].[Clinic].[IsActive] = 1;
			
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [DESC] NVARCHAR(15) NOT NULL
		, [COUNT1] BIGINT NOT NULL
		, [COUNT7] BIGINT NOT NULL
		, [COUNT30] BIGINT NOT NULL
		, [COUNT31PLUS] BIGINT NOT NULL
		, [COUNTTOTAL] BIGINT NOT NULL
	);
	
	DECLARE @Data1 BIGINT;
	DECLARE @Data7 BIGINT;
	DECLARE @Data30 BIGINT;
	DECLARE @Data31Plus BIGINT;
	DECLARE @DataTotal BIGINT;	
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Visits'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Created COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;	

	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Created'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
--Hold COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Hold'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	
--Ready to send COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Ready To Send'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Sent COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Sent'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Accepted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Accepted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);


	--Rejected COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Rejected'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Resubmitted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		[Claim].[ClaimProcess].[LastModifiedBy] = @UserID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Claim].[ClaimProcess].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
	AND
		[Claim].[ClaimProcess].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
		)
	AND
		[Claim].[ClaimProcess].[LastModifiedBy] = @UserID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Re-Submitted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetAgentWiseSummary_PatientVisit]  116,1,6,10,16,22,26,27,29
END












GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 08/21/2013 11:08:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 08/21/2013 11:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
	, @NIT_StatusIDs NVARCHAR(150)
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE 
	(
		[ClinicID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
		[User].[UserClinic].[ClinicID] 
	FROM 
		[User].[UserClinic]  WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic]  WITH (NOLOCK)
	ON
		[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
	WHERE 
		[User].[UserClinic].[UserID] = @UserID 
	AND 
		[User].[UserClinic].[IsActive] = 1 
	AND 
		[Billing].[Clinic].[IsActive] = 1;
	
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END

	ELSE IF @Desc = 'Created'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Hold'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Ready To Send'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Sent'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Accepted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
				FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Rejected'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Re-Submitted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				@TBL_CLINIC T
			ON
				[Patient].[Patient].[ClinicID] = [T].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			@TBL_CLINIC T
		ON
			[Patient].[Patient].[ClinicID] = [T].[ClinicID]
		WHERE
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID OR [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			@TBL_CLINIC T
		ON
			[Patient].[Patient].[ClinicID] = [T].[ClinicID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@NIT_StatusIDs, ','))
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
END
	
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ID] AS [Sl_No]
		, [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
	-- EXEC [Patient].[-]  @UserID=116 , @Desc = 'Visits', @DayCount = 'THIRTYPLUS'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  13,'Visits','THIRTY',1,6,10,16,22,26,27,29, '3, 5, 18, 8, 20, 12, 14, 24, 27'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  15,'Re-Submitted','THIRTYPLUS',1,6,10,16,22,26,27,29, '3, 5, 18, 8, 20, 12, 14, 24, 27'
END












GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]    Script Date: 08/23/2013 09:03:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]    Script Date: 08/23/2013 09:03:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit]
	@UserID INT
	, @NIT_StatusIDs NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE 
	(
		[ClinicID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
		[User].[UserClinic].[ClinicID] 
	FROM 
		[User].[UserClinic]   WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic]  WITH (NOLOCK) 
	ON
		[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
	WHERE 
		[User].[UserClinic].[UserID] = @UserID 
	AND 
		[User].[UserClinic].[IsActive] = 1 
	AND 
		[Billing].[Clinic].[IsActive] = 1;
			
	DECLARE @TBL_ANS TABLE 
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [NIT] BIGINT NOT NULL
		, [BLOCKED] BIGINT NOT NULL
		, [TOTAL] BIGINT NOT NULL

	);
	
	DECLARE @NIT BIGINT;
	DECLARE @Blocked BIGINT;
	DECLARE @TOTAL BIGINT;
	
	
	SELECT 
		@NIT = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]  WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient]  WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@NIT_StatusIDs, ','))
	AND
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
-------------
	SELECT 
		@Blocked = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit]  WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient]  WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		[Patient].[PatientVisit].[IsActive] = 0;
	
	--	
	
	SELECT 
		@TOTAL = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Claim].[ClaimProcess] WITH (NOLOCK)
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON
		[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Claim].[ClaimProcess].[ClaimStatusID] = 1
	AND
		([Claim].[ClaimProcess].[CreatedBy] = @UserID)
	AND
		[Claim].[ClaimProcess].[IsActive] = 1;
	
	--
				
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		 @NIT
		, @Blocked
		, @TOTAL
	)
	
	SELECT * FROM @TBL_ANS;		
	
	-- EXEC [Patient].[usp_GetAgentWiseSummaryNIT_PatientVisit] 13, '3, 5, 18, 8, 20, 12, 14, 24, 27'
END







GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]    Script Date: 08/13/2013 11:17:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]    Script Date: 08/13/2013 11:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
	, @NIT_StatusIDs NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[SL_NO] INT IDENTITY (1, 1)
		, [PatientVisitID] BIGINT 
		, [ClinicName] NVARCHAR(40) NOT NULL
		, [Name] NVARCHAR(500) NOT NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END

	ELSE IF @Desc = 'Created'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Hold'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Ready To Send'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Sent'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Accepted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Rejected'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Re-Submitted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				, [ClinicName]
				, [Name]
				, [ChartNumber]
				, [DOS]
				, [PatientVisitComplexity]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			, [Billing].[Clinic].[ClinicName]
			, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			, [Patient].[Patient].[ChartNumber]
			, [Patient].[PatientVisit].[DOS]
			, [Patient].[PatientVisit].[PatientVisitComplexity]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID OR [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
				, [ClinicName]
				, [Name]
				, [ChartNumber]
				, [DOS]
				, [PatientVisitComplexity]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
			, [Billing].[Clinic].[ClinicName]
			, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			, [Patient].[Patient].[ChartNumber]
			, [Patient].[PatientVisit].[DOS]
			, [Patient].[PatientVisit].[PatientVisitComplexity]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
			[Billing].[Clinic]  WITH (NOLOCK)
		ON
			[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@NIT_StatusIDs, ','))
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
END

SELECT * FROM @SEARCH_TMP;
	
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  13,'Visits','THIRTY',1,6,10,16,22,26,27,29, '3, 5, 18, 8, 20, 12, 14, 24, 27'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END


GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 08/13/2013 11:32:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboardAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 08/13/2013 11:32:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @NEW_CLAIM TINYINT
	, @BA_HOLDED TINYINT
	, @CREATED_CLAIM TINYINT
	, @READY_TO_SEND_CLAIM TINYINT
	, @EDI_FILE_CREATED TINYINT
	, @REJECTED_CLAIM TINYINT
	, @REJECTED_CLAIM_NIT TINYINT
	, @ACCEPTED_CLAIM TINYINT
	, @NIT_StatusIDs NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[PatientVisitID] BIGINT
	);
		
	IF @Desc = 'Visits'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;	
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @NEW_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[CreatedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;	
		END
	END

	ELSE IF @Desc = 'Created'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @CREATED_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Hold'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @BA_HOLDED
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Ready To Send'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @READY_TO_SEND_CLAIM
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Sent'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @EDI_FILE_CREATED 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Accepted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @ACCEPTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Rejected'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] = @REJECTED_CLAIM 
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Re-Submitted'
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'SEVEN'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTY'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] WITH (NOLOCK) 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Claim].[ClaimProcess].[ClaimStatusID] > @EDI_FILE_CREATED 
			AND
				[Claim].[ClaimProcess].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (@REJECTED_CLAIM, @REJECTED_CLAIM_NIT)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				([Claim].[ClaimProcess].[LastModifiedBy] = @UserID)
			AND
				[Claim].[ClaimProcess].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
		END
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID OR [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
		(
			[Patient].[PatientVisit].[IsActive] = 0
		OR
			[Patient].[Patient].[IsActive] = 0
		);
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@SEARCH_TMP
			(
				[PatientVisitID]
			)
		SELECT 
			[Patient].[PatientVisit].[PatientVisitID]
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@NIT_StatusIDs, ','))
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
				SELECT 
					[User].[UserClinic].[ClinicID] 
				FROM 
					[User].[UserClinic]  WITH (NOLOCK)
				INNER JOIN
					[Billing].[Clinic]  WITH (NOLOCK)
				ON
					[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
				WHERE 
					[User].[UserClinic].[UserID] = @UserID 
				AND 
					[User].[UserClinic].[IsActive] = 1 
				AND 
					[Billing].[Clinic].[IsActive] = 1
			)
		AND
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
END
	
		
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PatientVisit].[PatientVisitID] ASC) AS [SN]
		, [Billing].[Clinic].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [Patient].[PatientVisit].[DOS] AS [DOS]
		, [Patient].[PatientVisit].[PatientVisitID] AS [CASE_NO]
		, [Insurance].[Insurance].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PATIENT_NAME]
		, [Patient].[Patient].[ChartNumber] AS [CHART_NO]
		, [Patient].[Patient].[PolicyNumber] AS [POLICY_NO]
		, [MasterData].[ClaimStatus].[ClaimStatusName] AS [CLAIM_STATUS]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [PRIMARY_DX]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] WITH (NOLOCK)
	ON
		[MasterData].[ClaimStatus].[ClaimStatusID] = [Patient].[PatientVisit].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] WITH (NOLOCK)
	ON 	
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	LEFT JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE
		[Patient].[PatientVisit].[PatientVisitID]  IN
		(SELECT [PatientVisitID] FROM @SEARCH_TMP)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[MasterData].[ClaimStatus].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1;
	
	
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  13,'Visits','THIRTY',1,6,10,16,22,26,27,29, '3, 5, 18, 8, 20, 12, 14, 24, 27'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetReportDashboardAgent_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END











GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 08/14/2013 12:08:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Update_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Update_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 08/14/2013 12:08:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--Description:This Stored Procedure is used to UPDATE the PatientVisit in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientVisit]
	@PatientID BIGINT
	, @DOS DATE
	, @IllnessIndicatorID TINYINT
	, @IllnessIndicatorDate DATE
	, @FacilityTypeID TINYINT
	, @FacilityDoneID INT = NULL
	, @PrimaryClaimDiagnosisID BIGINT = NULL
	, @DoctorNoteRelPath NVARCHAR(350) = NULL
	, @SuperBillRelPath NVARCHAR(350) = NULL
	, @PatientVisitDesc NVARCHAR(150) = NULL
	, @ClaimStatusXml XML
	, @AssignedTo INT = NULL
	, @TargetBAUserID INT = NULL
	, @TargetQAUserID INT = NULL
	, @TargetEAUserID INT = NULL
	, @PatientVisitComplexity TINYINT
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientVisitID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @PatientHospitalizationID BIGINT;		
		SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[IsActive] = 1;
		
		IF @PatientHospitalizationID IS NOT NULL AND @PatientHospitalizationID > 0
		BEGIN
			IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[AdmittedOn] <= @DOS)
			BEGIN
				SELECT @PatientVisitID = -16;
			END
			ELSE
			BEGIN
				SELECT @PatientHospitalizationID = NULL;
			END
		END
		
		IF @PatientVisitID > -1
		BEGIN
		
			DECLARE @CurrentModificationOn DATETIME;
			SELECT @CurrentModificationOn = GETDATE();
			
			DECLARE @TBL_STS TABLE
			(
				[CLAIM_STATUS_ID] TINYINT NOT NULL
				, [COMMENTS] NVARCHAR(4000) NOT NULL
			);
			
			INSERT INTO
				@TBL_STS
			SELECT
				t.value('(ClaimStsID/text())[1]','TINYINT') AS CLAIM_STATUS_ID ,
				t.value('(Cmnts/text())[1]','NVARCHAR(4000)') AS COMMENTS
			FROM
				@ClaimStatusXml.nodes('/PatVisits/PatVisit') AS TempTable(t);
			
			DECLARE CUR_STS CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT [CLAIM_STATUS_ID], [COMMENTS] FROM @TBL_STS;
			
			DECLARE @CLAIM_STATUS_ID TINYINT;
			DECLARE @COMMENTS  NVARCHAR(4000);
			
			OPEN CUR_STS;
			
			FETCH NEXT FROM CUR_STS INTO @CLAIM_STATUS_ID, @COMMENTS;
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @PatientVisitID_PREV BIGINT;
				SELECT @PatientVisitID_PREV = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @CLAIM_STATUS_ID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @COMMENTS, 1);

				DECLARE @IS_ACTIVE_PREV BIT;
			
				IF EXISTS(SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID AND [Patient].[PatientVisit].[IsActive] = @IsActive)
				BEGIN
					SELECT @IS_ACTIVE_PREV = 1;
				END
				ELSE
				BEGIN
					SELECT @IS_ACTIVE_PREV = 0;
				END		

				IF ((@PatientVisitID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
				BEGIN
					DECLARE @LAST_MODIFIED_BY BIGINT;
					DECLARE @LAST_MODIFIED_ON DATETIME;
				
					SELECT 
						@LAST_MODIFIED_BY = [Patient].[PatientVisit].[LastModifiedBy]
						, @LAST_MODIFIED_ON =  [Patient].[PatientVisit].[LastModifiedOn]
					FROM 
						[Patient].[PatientVisit] WITH (NOLOCK)
					WHERE
						[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
					
					IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
					BEGIN
						-- VERIFY @ClaimStatusID STARTS
						
						DECLARE @ClaimStatusID_PREV TINYINT;
						SELECT @ClaimStatusID_PREV = [Patient].[PatientVisit].[ClaimStatusID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
						
						IF @ClaimStatusID_PREV <> @CLAIM_STATUS_ID
						BEGIN
							-- @ClaimStatusID CHANGED. SO CLAIM PROCESS INSERT REQUIRED
							
							DECLARE @ClaimStatusIDClaimProcess TINYINT;
							DECLARE @AssignedToClaimProcess INT = NULL;
							DECLARE @StatusStartDate DATETIME = NULL;
							DECLARE @StatusEndDate DATETIME;
							DECLARE @StartEndMins BIGINT;
							DECLARE @LogOutLogInMins BIGINT;
							DECLARE @LockUnLockMins BIGINT;
								
							IF EXISTS (SELECT [Claim].[ClaimProcess].[ClaimProcessID] FROM [Claim].[ClaimProcess] WHERE [Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID)
							BEGIN
								SELECT
									@StatusStartDate = MAX([Claim].[ClaimProcess].[StatusEndDate])
								FROM
									[Claim].[ClaimProcess]
								WHERE
									[Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID;
							END
							
							SELECT
								@ClaimStatusIDClaimProcess = [Patient].[PatientVisit].[ClaimStatusID]
								, @AssignedToClaimProcess = [Patient].[PatientVisit].[AssignedTo]
								, @StatusStartDate = CASE WHEN @StatusStartDate IS NULL THEN [Patient].[PatientVisit].[DOS] ELSE @StatusStartDate END
							FROM
								[Patient].[PatientVisit]
							WHERE
								[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
							
							SELECT @StatusEndDate = @CurrentModificationOn;
							
							SELECT @StartEndMins = DATEDIFF(MINUTE, @StatusStartDate, @StatusEndDate);
							
							IF @AssignedToClaimProcess IS NULL
							BEGIN
								SELECT @LogOutLogInMins = 0;
								SELECT @LockUnLockMins = 0;
							END
							ELSE
							BEGIN
								DECLARE @TBL_LOG_IN TABLE
								(
									[LOG_IN_LOG_OUT_ID] [BIGINT] NOT NULL,
									[LOG_IN_ON] [DATETIME] NOT NULL,
									[LOG_OUT_ON] [DATETIME] NOT NULL,
									[USED_DURATION_MINS] [BIGINT] NOT NULL
								);
								
								INSERT INTO
									@TBL_LOG_IN
								SELECT
									[Audit].[LogInLogOut].[LogInLogOutID] AS [LOG_IN_LOG_OUT_ID]
									, [Audit].[LogInLogOut].[LogInOn] AS [LOG_IN_ON]
									, ISNULL([Audit].[LogInLogOut].[LogOutOn], @StatusEndDate) AS [LOG_OUT_ON]
									, '0' AS [USED_DURATION_MINS]
								FROM
									[Audit].[LogInLogOut]
								WHERE
									[Audit].[LogInLogOut].[UserID] = @AssignedToClaimProcess
								AND
								(
									[Audit].[LogInLogOut].[LogInOn] BETWEEN @StatusStartDate AND @StatusEndDate
								OR
									[Audit].[LogInLogOut].[LogOutOn] BETWEEN @StatusStartDate AND @StatusEndDate
								);
								
								DECLARE @DT_MIN DATETIME;
								
								SELECT @DT_MIN = MIN([LOG_IN_ON]) FROM @TBL_LOG_IN;
								IF @DT_MIN IS NULL
								BEGIN
									SELECT @DT_MIN = @StatusStartDate;
								END
								
								IF DATEDIFF(MINUTE, @StatusStartDate, @DT_MIN) > 0
								BEGIN
									INSERT INTO
										@TBL_LOG_IN
									SELECT
										'-1' AS [LOG_IN_LOG_OUT_ID]
										, @StatusStartDate AS [LOG_IN_ON]
										, @StatusStartDate AS [LOG_OUT_ON]
										, '0' AS [USED_DURATION_MINS];
								END
								ELSE
								BEGIN
									UPDATE
										@TBL_LOG_IN
									SET
										[LOG_IN_ON] = @StatusStartDate
									WHERE
										[LOG_IN_LOG_OUT_ID] = 
										(
											SELECT
												MIN([LOG_IN_LOG_OUT_ID])
											FROM
												@TBL_LOG_IN
										);
								END
								
								DECLARE @DT_MAX DATETIME;
								
								SELECT @DT_MAX = MAX([LOG_OUT_ON]) FROM @TBL_LOG_IN;
								IF @DT_MAX IS NULL
								BEGIN
									SELECT @DT_MAX = @StatusEndDate;
								END
								
								IF DATEDIFF(MINUTE, @DT_MAX, @StatusEndDate) > 0
								BEGIN
									INSERT INTO
										@TBL_LOG_IN
									SELECT
										'-1' AS [LOG_IN_LOG_OUT_ID]
										, @StatusEndDate AS [LOG_IN_ON]
										, @StatusEndDate AS [LOG_OUT_ON]
										, '0' AS [USED_DURATION_MINS];
								END
								ELSE
								BEGIN
									UPDATE
										@TBL_LOG_IN
									SET
										[LOG_OUT_ON] = @StatusEndDate
									WHERE
										[LOG_IN_LOG_OUT_ID] = 
										(
											SELECT
												MAX([LOG_IN_LOG_OUT_ID])
											FROM
												@TBL_LOG_IN
										);
								END
								
								UPDATE
									@TBL_LOG_IN
								SET
									[USED_DURATION_MINS] = DATEDIFF(MINUTE, [LOG_IN_ON], [LOG_OUT_ON]);
								
								SELECT @DT_MIN = MIN([LOG_IN_ON]) FROM @TBL_LOG_IN;
								IF @DT_MIN IS NULL
								BEGIN
									SELECT @DT_MIN = @StatusStartDate;
								END
								
								SELECT @DT_MAX = MAX([LOG_OUT_ON]) FROM @TBL_LOG_IN;
								IF @DT_MAX IS NULL
								BEGIN
									SELECT @DT_MAX = @StatusEndDate;
								END
								
								SELECT @LogOutLogInMins = DATEDIFF(MINUTE, @DT_MIN, @DT_MAX) - ISNULL((SELECT SUM([USED_DURATION_MINS]) FROM @TBL_LOG_IN), 0);
								
								-- Begin lock unlock table			
							
								DECLARE @TBL_LOCK TABLE 
								(
									[LOCK_UNLOCK_ID] [BIGINT] NOT NULL,
									[LOCK_ON] [DATETIME] NOT NULL,
									[UN_LOCK_ON] [DATETIME] NOT NULL,
									[UN_USED_DURATION_MINS] [BIGINT] NOT NULL
								);
								
								INSERT INTO
									@TBL_LOCK
								SELECT
									[Audit].[LockUnLock].[LockUnLockID] AS [LOCK_UNLOCK_ID]
									, [Audit].[LockUnLock].[LockOn] AS [LOCK_ON]
									, ISNULL([Audit].[LockUnLock].[UnLockOn], @StatusEndDate) AS [UN_LOCK_ON]
									, '0' AS [UN_USED_DURATION_MINS]
								FROM
									[Audit].[LockUnLock]
								WHERE
									[Audit].[LockUnLock].[UserID] = @AssignedToClaimProcess
								AND
								(
									[Audit].[LockUnLock].[LockOn] BETWEEN @StatusStartDate AND @StatusEndDate
								OR
									[Audit].[LockUnLock].[UnLockOn] BETWEEN @StatusStartDate AND @StatusEndDate
								);				
								
								SELECT @DT_MIN = MIN([LOCK_ON]) FROM @TBL_LOCK;
								IF @DT_MIN IS NULL
								BEGIN
									SELECT @DT_MIN = @StatusStartDate;
								END
								
								IF DATEDIFF(MINUTE, @StatusStartDate, @DT_MIN) > 0
								BEGIN
									INSERT INTO
										@TBL_LOCK
									SELECT
										'-1' AS [LOCK_UNLOCK_ID]
										, @StatusStartDate AS [LOCK_ON]
										, @StatusStartDate AS [UN_LOCK_ON]
										, '0' AS [UN_USED_DURATION_MINS];
								END
								ELSE
								BEGIN
									UPDATE
										@TBL_LOCK
									SET
										[LOCK_ON] = @StatusStartDate
									WHERE
										[LOCK_UNLOCK_ID] = 
										(
											SELECT
												MIN([LOCK_UNLOCK_ID])
											FROM
												@TBL_LOCK
										);
								END
								
								SELECT @DT_MAX = MAX([UN_LOCK_ON]) FROM @TBL_LOCK;
								IF @DT_MAX IS NULL
								BEGIN
									SELECT @DT_MAX = @StatusEndDate;
								END
								
								IF DATEDIFF(MINUTE, @DT_MAX, @StatusEndDate) > 0
								BEGIN
									INSERT INTO
										@TBL_LOCK
									SELECT
										'-1' AS [LOCK_UNLOCK_ID]
										, @StatusEndDate AS [LOCK_ON]
										, @StatusEndDate AS [UN_LOCK_ON]
										, '0' AS [UN_USED_DURATION_MINS];
								END
								ELSE
								BEGIN
									UPDATE
										@TBL_LOCK
									SET
										[LOCK_ON] = @StatusEndDate
									WHERE
										[LOCK_UNLOCK_ID] = 
										(
											SELECT
												MAX([LOCK_UNLOCK_ID])
											FROM
												@TBL_LOCK
										);
								END
								
								UPDATE
									@TBL_LOCK
								SET
									[UN_USED_DURATION_MINS] = DATEDIFF(MINUTE, [LOCK_ON], [UN_LOCK_ON]);
								
								SELECT @DT_MIN = MIN([LOCK_ON]) FROM @TBL_LOCK;
								IF @DT_MIN IS NULL
								BEGIN
									SELECT @DT_MIN = @StatusStartDate;
								END
								
								SELECT @DT_MAX = MAX([UN_LOCK_ON]) FROM @TBL_LOCK;
								IF @DT_MAX IS NULL
								BEGIN
									SELECT @DT_MAX = @StatusEndDate;
								END
								
								SELECT @LockUnlockMins = ISNULL((SELECT SUM([UN_USED_DURATION_MINS]) FROM @TBL_LOCK), 0);
								
								--End Lock Unlock
							END
						
							DECLARE @DurationMins BIGINT;
							SELECT @DurationMins = @StartEndMins - (@LogOutLogInMins + @LockUnLockMins);
							
							DECLARE @CommentClaimProcess NVARCHAR(4000);
							SELECT @CommentClaimProcess = [Patient].[PatientVisit].[Comment] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID
						
							INSERT INTO [Claim].[ClaimProcess]
							(
								[PatientVisitID]
								, [ClaimStatusID]
								, [AssignedTo]
								, [StatusStartDate]
								, [StatusEndDate]
								, [StartEndMins]
								, [LogOutLogInMins]
								, [LockUnLockMins]
								, [DurationMins]
								, [Comment]
								, [CreatedBy]
								, [CreatedOn]
								, [LastModifiedBy]
								, [LastModifiedOn]
								, [IsActive]
							)
							VALUES
							(
								@PatientVisitID
								, @ClaimStatusIDClaimProcess
								, @AssignedToClaimProcess
								, @StatusStartDate
								, @StatusEndDate
								, @StartEndMins
								, @LogOutLogInMins
								, @LockUnLockMins
								, @DurationMins
								, @CommentClaimProcess
								, @CurrentModificationBy
								, @CurrentModificationOn
								, @CurrentModificationBy
								, @CurrentModificationOn
								, 1
							);
						END
						
						-- VERIFY @ClaimStatusID ENDS
					
						INSERT INTO 
							[PatientVisitHistory]
							(
								[PatientVisitID]
								, [PatientID]
								, [PatientHospitalizationID]
								, [DOS]
								, [IllnessIndicatorID]
								, [IllnessIndicatorDate]
								, [FacilityTypeID]
								, [FacilityDoneID]
								, [PrimaryClaimDiagnosisID]
								, [DoctorNoteRelPath]
								, [SuperBillRelPath]
								, [PatientVisitDesc]
								, [ClaimStatusID]
								, [AssignedTo]
								, [TargetBAUserID]
								, [TargetQAUserID]
								, [TargetEAUserID]
								, [PatientVisitComplexity]
								, [Comment]
								, [CreatedBy]
								, [CreatedOn]
								, [LastModifiedBy]
								, [LastModifiedOn]
								, [IsActive]
							)
						SELECT
							[Patient].[PatientVisit].[PatientVisitID]
							, [Patient].[PatientVisit].[PatientID]
							, [Patient].[PatientVisit].[PatientHospitalizationID]
							, [Patient].[PatientVisit].[DOS]
							, [Patient].[PatientVisit].[IllnessIndicatorID]
							, [Patient].[PatientVisit].[IllnessIndicatorDate]
							, [Patient].[PatientVisit].[FacilityTypeID]
							, [Patient].[PatientVisit].[FacilityDoneID]
							, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
							, [Patient].[PatientVisit].[DoctorNoteRelPath]
							, [Patient].[PatientVisit].[SuperBillRelPath]
							, [Patient].[PatientVisit].[PatientVisitDesc]
							, [Patient].[PatientVisit].[ClaimStatusID]
							, [Patient].[PatientVisit].[AssignedTo]
							, [Patient].[PatientVisit].[TargetBAUserID]
							, [Patient].[PatientVisit].[TargetQAUserID]
							, [Patient].[PatientVisit].[TargetEAUserID]
							, [Patient].[PatientVisit].[PatientVisitComplexity]
							, [Patient].[PatientVisit].[Comment]
							, @CurrentModificationBy
							, @CurrentModificationOn
							, @LastModifiedBy
							, @LastModifiedOn
							, [Patient].[PatientVisit].[IsActive]
						FROM 
							[Patient].[PatientVisit]
						WHERE
							[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
						
						UPDATE 
							[Patient].[PatientVisit]
						SET
							[Patient].[PatientVisit].[PatientID] = @PatientID
							, [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID
							, [Patient].[PatientVisit].[DOS] = @DOS
							, [Patient].[PatientVisit].[IllnessIndicatorID] = @IllnessIndicatorID
							, [Patient].[PatientVisit].[IllnessIndicatorDate] = @IllnessIndicatorDate
							, [Patient].[PatientVisit].[FacilityTypeID] = @FacilityTypeID
							, [Patient].[PatientVisit].[FacilityDoneID] = @FacilityDoneID
							, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID] = @PrimaryClaimDiagnosisID
							, [Patient].[PatientVisit].[DoctorNoteRelPath] = @DoctorNoteRelPath
							, [Patient].[PatientVisit].[SuperBillRelPath] = @SuperBillRelPath
							, [Patient].[PatientVisit].[PatientVisitDesc] = @PatientVisitDesc
							, [Patient].[PatientVisit].[ClaimStatusID] = @CLAIM_STATUS_ID
							, [Patient].[PatientVisit].[AssignedTo] = @AssignedTo
							, [Patient].[PatientVisit].[TargetBAUserID] = @TargetBAUserID
							, [Patient].[PatientVisit].[TargetQAUserID] = @TargetQAUserID
							, [Patient].[PatientVisit].[TargetEAUserID] = @TargetEAUserID
							, [Patient].[PatientVisit].[PatientVisitComplexity] = @PatientVisitComplexity
							, [Patient].[PatientVisit].[Comment] = @COMMENTS
							, [Patient].[PatientVisit].[LastModifiedBy] = @CurrentModificationBy
							, [Patient].[PatientVisit].[LastModifiedOn] = @CurrentModificationOn
							, [Patient].[PatientVisit].[IsActive] = @IsActive
						WHERE
							[Patient].[PatientVisit].[PatientVisitID] = @PatientVisitID;
							
						SELECT @LastModifiedBy = @CurrentModificationBy;
						SELECT @LastModifiedOn = @CurrentModificationOn;
					END
					--ELSE
					--BEGIN
					--	SELECT @PatientVisitID = -2;		-- THIS CAN'T BE RETURED IN THIS SP ONLY
					--END
				END
				--ELSE IF @PatientVisitID_PREV <> @PatientVisitID
				--BEGIN			
				--	SELECT @PatientVisitID = -1;			-- THIS CAN'T BE RETURED IN THIS SP ONLY
				--END
				-- ELSE
				-- BEGIN
				--	 SELECT @CurrentModificationOn = @LastModifiedOn;
				-- END
				
				FETCH NEXT FROM CUR_STS INTO @CLAIM_STATUS_ID, @COMMENTS;
			END
		END
		
		CLOSE CUR_STS;
		DEALLOCATE CUR_STS;
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY			
			EXEC [Audit].[usp_Insert_ErrorLog];			
			SELECT @PatientVisitID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END





GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetXmlAll_User]    Script Date: 08/20/2013 14:20:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetXmlAll_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetXmlAll_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetXmlAll_User]    Script Date: 08/20/2013 14:20:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [User].[usp_GetXmlAll_User]
AS
BEGIN
	SELECT
		ROW_NUMBER() OVER (ORDER BY [USR].[UserID] ASC) AS [SN]
		, [USR].[UserID] AS [USER_ID], [USR].[Email] AS [EMAIL]
		, (LTRIM(RTRIM([USR].[LastName] + ' ' + [USR].[FirstName] + ' ' + ISNULL ([USR].[MiddleName], '')))) AS [FULL_NAME] 
	FROM
		[User].[User] USR WITH (NOLOCK)
	WHERE
		[USR].[IsActive] = 1
	FOR XML AUTO, ROOT('USRS');
	
	-- EXEC [User].[usp_GetXmlAll_User]
END


GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 08/14/2013 19:29:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetCommentByID_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 08/14/2013 19:29:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- Select the particular record

CREATE PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[A].[USER_COMMENTS]
		, ((LTRIM(RTRIM([D].[LastName] + ' ' + [D].[FirstName] + ' ' + ISNULL([D].[MiddleName], '')))) + ' [' +[D].[UserName] + ']') AS [USER_NAME_CODE] 
	FROM
	(
		SELECT
			[C].[LastModifiedBy] AS [USER_ID] 
			, [C].[Comment] AS [USER_COMMENTS]
		FROM
			[Claim].[ClaimProcess] C WITH (NOLOCK)
		WHERE
			[C].[PatientVisitID] = @PatientVisitID
		AND
			[C].[Comment] NOT LIKE 'Sys Gen : %'
		AND
			[C].[IsActive] = 1
		UNION ALL
		SELECT
			[B].[LastModifiedBy] AS [USER_ID] 
			, [B].[Comment] AS [USER_COMMENTS]
		FROM
			[Patient].[PatientVisit] B WITH (NOLOCK)
		WHERE
			[B].[PatientVisitID] = @PatientVisitID
		AND
			[B].[Comment] NOT LIKE 'Sys Gen : %'
		AND
			[B].[IsActive] = 1
	) AS A ([USER_ID], [USER_COMMENTS])
	INNER JOIN 
		[User].[User] D
	ON
		[D].[UserID] = [A].[USER_ID]
	AND
		[D].[IsActive] = 1;
	
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 24119
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 0
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetByPatientVisitID_ClaimProcess]    Script Date: 08/27/2013 18:46:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByPatientVisitID_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByPatientVisitID_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetByPatientVisitID_ClaimProcess]    Script Date: 08/27/2013 18:46:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Claim].[usp_GetByPatientVisitID_ClaimProcess] 
	@PatientVisitID	BIGINT
	, @SysGenKy NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[Claim].[ClaimProcess].[ClaimStatusID]
		, [Claim].[ClaimProcess].[StatusStartDate]
		, [Claim].[ClaimProcess].[StatusEndDate]
		, ABS([Claim].[ClaimProcess].[DurationMins]) AS [DurationMins]
		, CASE WHEN LEFT([Claim].[ClaimProcess].[Comment], 8) = @SysGenKy THEN '' ELSE [Claim].[ClaimProcess].[Comment] END AS Comment
		, ISNULL((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))), '') AS [USER_NAME_CODE]
		, ISNULL([Claim].[ClaimProcessEDIFile].[ClaimProcessEDIFileID], 0) AS [ClaimProcessEDIFileID]
		, ISNULL([EDI].[EDIFile].[X12FileRelPath], '') AS [X12FileRelPath]
		, ISNULL([EDI].[EDIFile].[RefFileRelPath], '') AS [RefFileRelPath]
		, ISNULL([EDI].[EDIFile].[CreatedOn], '1900-01-01') AS [CreatedOn]		
	FROM
		[Claim].[ClaimProcess]
	LEFT JOIN
		[Claim].[ClaimProcessEDIFile]
	ON
		[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
	LEFT JOIN
		[EDI].[EDIFile]
	ON
		[Claim].[ClaimProcessEDIFile].[EDIFileID] = [EDI].[EDIFile].[EDIFileID]
	LEFT JOIN
		[EDI].[EDIReceiver]
	ON
		[EDI].[EDIFile].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
	LEFT JOIN
		[User].[User]
	ON
		[User].[User].[UserID] = [Claim].[ClaimProcess].[AssignedTo]
	AND
		[User].[User].[IsActive] = 1
	WHERE
		[Claim].[ClaimProcess].[PatientVisitID] = @PatientVisitID
	AND
		[Claim].[ClaimProcess].[IsActive] = 1
	ORDER BY 
		[Claim].[ClaimProcess].[ClaimProcessID]
	ASC;
		
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 7219
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] 1, 0
	-- EXEC [Claim].[usp_GetByPatientVisitID_ClaimProcess] @PatientVisitID = 24119, @SysGenKy = 'Sys Gen :'
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 08/14/2013 22:43:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetSentFile_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetSentFile_EDIFile]
GO



/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 08/14/2013 22:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [EDI].[usp_GetSentFile_EDIFile] 
	@ClinicID	INT
	, @StatusIDs NVARCHAR(100)
	, @UserID INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @DOSFrom DATE = NULL
	, @DOSTo DATE = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
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
		SELECT @DateFrom = '1900-01-01';
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = GETDATE();
	END	
	
	IF @DOSFrom IS NULL
	BEGIN
		SELECT @DOSFrom = @DateFrom;
	END
	
	IF @DOSTo IS NULL
	BEGIN
		SELECT @DOSTo = @DateTo;
	END
		
	DECLARE @TBL_EDI  TABLE
	(
		[PK_ID] INT NOT NULL
	);
	
	WITH CTE AS 
	(
		SELECT 
			[A].[EDIFileID]	AS [PK_ID]
			, ROW_NUMBER() OVER (
				PARTITION BY
					[A].[EDIFileID]
				ORDER BY
					[A].[EDIFileID]
				ASC
				) AS [ROW_NUM]
		FROM
			[EDI].[EDIFile] A	WITH (NOLOCK)
		INNER JOIN
			[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
		ON
			[B].[EDIFileID] = [A].[EDIFileID]
		INNER JOIN
			[Claim].[ClaimProcess] C WITH (NOLOCK)
		ON
			[C].[ClaimProcessID] = [B].[ClaimProcessID]
		INNER JOIN
			[Patient].[PatientVisit] D WITH (NOLOCK)
		ON
			[D].[PatientVisitID] = [C].[PatientVisitID]
		INNER JOIN
			[Patient].[Patient] E WITH (NOLOCK)
		ON
			[E].[PatientID] = [D].[PatientID]
		INNER JOIN
			@TBL_SID F
		ON
			[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
		WHERE
			DATEDIFF(DAY, [A].[CreatedOn], @DateFrom) <= 0 AND DATEDIFF(DAY, [A].[CreatedOn], @DateTo) >= 0
		AND
			[E].[ClinicID] = @ClinicID
		AND
			[D].[AssignedTo] = @UserID
		AND
			[D].[DOS] BETWEEN @DOSFrom AND @DOSTo
		AND
			(
				[E].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				((LTRIM(RTRIM([E].[LastName] + ' ' + [E].[FirstName] + ' ' + ISNULL ([E].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
			OR
				[D].[PatientVisitID] =  @PatientVisitID
			)
		AND
			[D].[IsActive] = 1	
		AND
			[E].[IsActive] = 1
		AND
			[C].[IsActive] = 1	
		AND
			[B].[IsActive] = 1
		AND
			[A].[IsActive] = 1
	)
	INSERT INTO
		@TBL_EDI
		(
			[PK_ID]
		)
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[J].[PK_ID]
	FROM 
		CTE J
	WHERE 
		[J].[ROW_NUM] = 1;
		
	DECLARE @SEARCH_TMP  TABLE
	(
		[PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
	SELECT
		[L].[PK_ID]
		, ROW_NUMBER() OVER (
			ORDER BY

				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'A' THEN [K].[CreatedOn] END ASC,
				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'D' THEN [K].[CreatedOn] END DESC,		

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [K].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [K].[LastModifiedOn] END DESC
				
			) AS [ROW_NUM]
	FROM
		@TBL_EDI L
	INNER JOIN
		[EDI].[EDIFile] K	WITH (NOLOCK)
	ON
		[K].[EDIFileID] = [L].[PK_ID];
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ROW_NUM]) FROM @SEARCH_TMP;	
	
	SELECT
		[H].[EDIFileID]	
		,[H].[X12FileRelPath]
		,[H].[RefFileRelPath]
		,[H].[CreatedOn]	
	FROM
		[EDI].[EDIFile] H WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP I
	ON
		[I].[PK_ID] = [H].[EDIFileID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[I].[ROW_NUM]
	ASC;		
			
	-- EXEC [EDI].[usp_GetSentFile_EDIFile] @ClinicID=20, @StatusIDs = '22,23,24', @UserID = 13, @SearchName = '' ,@DateFrom ='1900-01-01',@DateTo='2013-07-11'
	-- EXEC [EDI].[usp_GetSentFile_EDIFile] @ClinicID=17, @StatusIDs = '22,23,24', @UserID = 116
	
END




GO




-----------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_User_UserID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_User_UserID]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_CurrImportEndOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_CurrImportEndOn]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_CurrImportStartOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_CurrImportStartOn]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_ExcelImportedOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_ExcelImportedOn]
GO

/****** Object:  Table [Audit].[UserReport]    Script Date: 08/20/2013 16:19:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[UserReport]') AND type in (N'U'))
DROP TABLE [Audit].[UserReport]
GO

/****** Object:  Table [Audit].[UserReport]    Script Date: 08/20/2013 16:19:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Audit].[UserReport](
	[UserReportID] [smallint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [tinyint] NOT NULL,
	[ReportObjectID] [bigint] NULL,
	[DateFrom] [date] NULL,
	[DateTo] [date] NULL,
	[UserID] [int] NOT NULL,
	[ExcelFileName] [nvarchar](50) NOT NULL,
	[ExcelImportedOn] [datetime] NOT NULL,
	[IsSuccess] [bit] NOT NULL,
	[CurrImportStartOn] [datetime] NOT NULL,
	[CurrImportEndOn] [datetime] NULL,
 CONSTRAINT [PK_UserReport] PRIMARY KEY CLUSTERED 
(
	[UserReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_UserReport_ExcelFileName] UNIQUE NONCLUSTERED 
(
	[ExcelFileName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [FK_UserReport_ReportType_ReportTypeID] FOREIGN KEY([ReportTypeID])
REFERENCES [Excel].[ReportType] ([ReportTypeID])
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [FK_UserReport_User_UserID] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [FK_UserReport_User_UserID]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_CurrImportEndOn] CHECK  (([CurrImportStartOn]<=[CurrImportEndOn] OR [CurrImportEndOn] IS NULL))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_CurrImportEndOn]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_CurrImportStartOn] CHECK  (([CurrImportStartOn]>=[ExcelImportedOn]))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_CurrImportStartOn]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_ExcelImportedOn] CHECK  (([ExcelImportedOn]<=getdate()))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_ExcelImportedOn]
GO

-----------------------------------------------------------------------------------

/****** Object:  UserDefinedFunction [Audit].[ufn_IsExists_UserReport]    Script Date: 08/16/2013 16:35:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[ufn_IsExists_UserReport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [Audit].[ufn_IsExists_UserReport]
GO

/****** Object:  UserDefinedFunction [Audit].[ufn_IsExists_UserReport]    Script Date: 08/16/2013 16:35:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Returns 0, if the record not exists, otherwise returns that primary key id value

CREATE FUNCTION [Audit].[ufn_IsExists_UserReport]
(
	@ReportTypeID TINYINT
	, @ReportObjectID BIGINT = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @UserID INT
)
RETURNS INT
AS
BEGIN
	DECLARE @UserReportID BIGINT;

	SELECT 
		@UserReportID = [Audit].[UserReport].[UserReportID]
	FROM 
		[Audit].[UserReport]
	WHERE
		[Audit].[UserReport].[ReportTypeID] = @ReportTypeID
	AND
		([Audit].[UserReport].[ReportObjectID] = @ReportObjectID OR (@ReportObjectID IS NULL AND [Audit].[UserReport].[ReportObjectID] IS NULL))
	AND
		([Audit].[UserReport].[DateFrom] = @DateFrom OR (@DateFrom IS NULL AND [Audit].[UserReport].[DateFrom] IS NULL))
	AND
		([Audit].[UserReport].[DateTo] = @DateTo OR (@DateTo IS NULL AND [Audit].[UserReport].[DateTo] IS NULL))
	AND
		[Audit].[UserReport].[UserID] = @UserID
	
	IF @UserReportID IS NULL
	BEGIN
		SELECT @UserReportID = 0
	END

	RETURN @UserReportID;
END

GO

-----------------------------------------------------------------------------------


/****** Object:  View [dbo].[uvw_PatientVisit]    Script Date: 08/29/2013 10:09:24 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_PatientVisit]'))
DROP VIEW [dbo].[uvw_PatientVisit]
GO


/****** Object:  View [dbo].[uvw_PatientVisit]    Script Date: 08/29/2013 10:09:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE VIEW [dbo].[uvw_PatientVisit]
AS
SELECT
		(
			SELECT
				(
					SELECT
						(
							SELECT
								ROW_NUMBER() OVER (ORDER BY [CLM_MODI].[ClaimDiagnosisCPTModifierID] ASC) AS [SN]
								, [CLM_MODI].[ModifierLevel] AS [MODIFIER_LEVEL]
								, [MODI].[ModifierCode] AS [MODIFIER_CODE]
								, [MODI].[ModifierName] AS [MODIFIER_NAME]
							FROM
								[Claim].[ClaimDiagnosisCPTModifier] CLM_MODI WITH (NOLOCK)
							INNER JOIN
								[Diagnosis].[Modifier] MODI WITH (NOLOCK)
							ON
								[MODI].[ModifierID] = [CLM_MODI].[ModifierID]
							WHERE 
								[CLM_MODI].[ClaimDiagnosisCPTID] = [CLM_CPT].[ClaimDiagnosisCPTID]
							AND
								[CLM_MODI].[IsActive] = 1
							FOR XML AUTO, TYPE
						) AS CLM_MODIS
						, (
							SELECT
								[FAC_TYP].[FacilityTypeName][FACILITY_TYPE_NAME]
							FROM								
								[Billing].[FacilityType] FAC_TYP WITH (NOLOCK)	
							WHERE  
								[FAC_TYP].[FacilityTypeID] = [CLM_CPT].[FacilityTypeID]
							FOR XML AUTO, TYPE	
						) AS FAC_TYPO
						, ROW_NUMBER() OVER (ORDER BY [CLM_CPT].[ClaimDiagnosisCPTID] ASC) AS [SN]
						, [CLM_CPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPTID]
						, [CLM_CPT].[Unit]  AS [UNIT]
						, [CPT].[CPTCode] AS [CPT_CODE]
						, [CPT].[ShortDesc] AS [SHORT_DESC]
						, [CPT].[LongDesc] AS [LONG_DESC]
						, [CPT].[MediumDesc] AS [MEDIUM_DESC]
						, [CPT].[CustomDesc] AS [CUSTOM_DESC]
						, [CPT].[ChargePerUnit] AS [CHARGE_PER_UNIT]
						, [CPT].[IsHCPCSCode] AS [IS_HCPCS_CODE]
					FROM
						[Claim].[ClaimDiagnosisCPT] CLM_CPT WITH (NOLOCK)
					INNER JOIN
						[Diagnosis].[CPT] CPT WITH (NOLOCK)
					ON
						[CPT].[CPTID] = [CLM_CPT].[CPTID]
					WHERE 
						[CLM_CPT].[ClaimDiagnosisID] = [CLM_DX].[ClaimDiagnosisID]
					AND
						[CLM_CPT].[IsActive] = 1
					FOR XML AUTO, TYPE
				) AS CLM_CPTS
				, ROW_NUMBER() OVER (ORDER BY [CLM_DX].[ClaimDiagnosisID] ASC) AS [SN]
				, [CLM_DX].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
				, [DX].[DiagnosisCode] AS [DIAGNOSIS_CODE]
				, [DX].[ShortDesc] AS [SHORT_DESC]
				, [DX].[LongDesc] AS [LONG_DESC]
				, [DX].[MediumDesc] AS [MEDIUM_DESC]
				, [DX].[CustomDesc] AS [CUSTOM_DESC]
				, [DX].[ICDFormat] AS [ICD_FORMAT]
				, [DG].[DiagnosisGroupCode] AS [DG_CODE]
				, [DG].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
			FROM
				[Claim].[ClaimDiagnosis] CLM_DX WITH (NOLOCK)
			INNER JOIN
				[Diagnosis].[Diagnosis] DX WITH (NOLOCK)
			ON
				[DX].[DiagnosisID] = [CLM_DX].[DiagnosisID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup] DG WITH (NOLOCK)
			ON
				[DG].[DiagnosisGroupID] = [DX].[DiagnosisGroupID]
			WHERE 
				[CLM_DX].[PatientVisitID] = [PAT_VST].[PatientVisitID]
			AND
				[CLM_DX].[IsActive] = 1
			FOR XML AUTO, TYPE
		) AS CLM_DXS
		, (
			SELECT
				ROW_NUMBER() OVER (ORDER BY [CLM_DX].[ClaimDiagnosisID] ASC) AS [SN]
				, [CLM_DX].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
				, [DX].[DiagnosisCode] AS [DIAGNOSIS_CODE]
				, [DX].[ShortDesc] AS [SHORT_DESC]
				, [DX].[LongDesc] AS [LONG_DESC]
				, [DX].[MediumDesc] AS [MEDIUM_DESC]
				, [DX].[CustomDesc] AS [CUSTOM_DESC]
				, [DX].[ICDFormat] AS [ICD_FORMAT]
				, [DG].[DiagnosisGroupCode] AS [DG_CODE]
				, [DG].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
			FROM
				[Claim].[ClaimDiagnosis] CLM_DX WITH (NOLOCK)
			INNER JOIN
				[Diagnosis].[Diagnosis] DX WITH (NOLOCK)
			ON
				[DX].[DiagnosisID] = [CLM_DX].[DiagnosisID]
			LEFT JOIN
				[Diagnosis].[DiagnosisGroup] DG WITH (NOLOCK)
			ON
				[DG].[DiagnosisGroupID] = [DX].[DiagnosisGroupID]
			WHERE 
				[CLM_DX].[ClaimDiagnosisID] = [PAT_VST].[PrimaryClaimDiagnosisID]
			AND
				[CLM_DX].[IsActive] = 1
			FOR XML AUTO, TYPE
		) AS PRI_CLM_DX
		, [CLNC].[ClinicName] AS [CLINIC_NAME]
		, (LTRIM(RTRIM([PROV].[LastName] + ' ' + [PROV].[FirstName] + ' ' + ISNULL ([PROV].[MiddleName], '')))) AS [PROVIDER_NAME]
		, [PAT_VST].[DOS] AS [DOS]
		, [PAT_VST].[PatientVisitID] AS [CASE_NO]
		, [INS].[InsuranceName] AS [INSURANCE_NAME]
		, (LTRIM(RTRIM([PAT].[LastName] + ' ' + [PAT].[FirstName] + ' ' + ISNULL ([PAT].[MiddleName], '')))) AS [PATIENT_NAME]
		, [PAT].[ChartNumber] AS [CHART_NO]
		, [PAT].[PolicyNumber] AS [POLICY_NO]
		, [CLM_STS].[ClaimStatusName] AS [CLAIM_STATUS]
		, [CLNC].[ClinicID] AS [CLINIC_ID]
		, [PROV].[ProviderID] AS [PROVIDER_ID]
		, [PAT].[PatientID] AS [PATIENT_ID]
	FROM
		[Patient].[PatientVisit] PAT_VST WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] PAT WITH (NOLOCK)
	ON 
		[PAT].[PatientID] = [PAT_VST].[PatientID]
	INNER JOIN		
		[Billing].[Clinic] CLNC WITH (NOLOCK)
	ON
		[CLNC].[ClinicID] = [PAT].[ClinicID]
	INNER JOIN
		[Billing].[Provider] PROV WITH (NOLOCK)
	ON
		[PROV].[ProviderID] = [PAT].[ProviderID]
	INNER JOIN
		[MasterData].[ClaimStatus] CLM_STS WITH (NOLOCK)
	ON
		[CLM_STS].[ClaimStatusID] = [PAT_VST].[ClaimStatusID]
	INNER JOIN 
		[Insurance].[Insurance] INS WITH (NOLOCK)
	ON 	
		[INS].[InsuranceID] = [PAT].[InsuranceID]
	WHERE
		 [PAT_VST].[IsActive] = 1
	AND
		[CLNC].[IsActive] = 1








GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 21
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'uvw_PatientVisit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'uvw_PatientVisit'
GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Audit].[usp_GetXmlDayStatus_UserReport]    Script Date: 08/29/2013 14:11:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetXmlDayStatus_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetXmlDayStatus_UserReport]
GO


/****** Object:  StoredProcedure [Audit].[usp_GetXmlDayStatus_UserReport]    Script Date: 08/29/2013 14:11:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Audit].[usp_GetXmlDayStatus_UserReport]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @DAY_STATUS TABLE
	(
		[DAY_STS] BIT NOT NULL
	);
	
	IF EXISTS(SELECT * FROM [Audit].[UserReport] UR WITH (NOLOCK)) AND DATENAME(DW, GETDATE()) <> 'Sunday'
	BEGIN
		INSERT INTO @DAY_STATUS
		SELECT 0;
	END
	ELSE
	BEGIN
		INSERT INTO @DAY_STATUS
		SELECT 1;
	END
	
	SELECT
		[DS].[DAY_STS]
		,	GETDATE() AS [CURR_DT_TM]
	FROM 
		@DAY_STATUS DS
	FOR XML AUTO, ROOT('DSS');
	
	-- EXEC [Audit].[usp_GetXmlDayStatus_UserReport]
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Update_UserReport]    Script Date: 08/27/2013 14:58:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Update_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Update_UserReport]
GO


/****** Object:  StoredProcedure [Audit].[usp_Update_UserReport]    Script Date: 08/27/2013 14:58:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Audit].[usp_Update_UserReport]
	@IsSuccess BIT
	, @UserReportID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		IF @IsSuccess = 1
		BEGIN
			UPDATE 
				[Audit].[UserReport]
			SET 
				[Audit].[UserReport].[ExcelImportedOn] = [Audit].[UserReport].[CurrImportStartOn]
				, [Audit].[UserReport].[CurrImportEndOn] = @CurrentModificationOn
				, [Audit].[UserReport].[IsSuccess] = 1
			WHERE
				[Audit].[UserReport].[UserReportID] = @UserReportID;
		END
		ELSE
		BEGIN
			UPDATE 
				[Audit].[UserReport]
			SET 
				[Audit].[UserReport].[CurrImportStartOn] = [Audit].[UserReport].[ExcelImportedOn]
				, [Audit].[UserReport].[CurrImportEndOn] = [Audit].[UserReport].[ExcelImportedOn]
			WHERE
				[Audit].[UserReport].[UserReportID] = @UserReportID;
		END
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Update_ErrorLog];
			SELECT @UserReportID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Update_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END





GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 08/26/2013 12:09:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Insert_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Insert_UserReport]
GO



/****** Object:  StoredProcedure [Audit].[usp_Insert_UserReport]    Script Date: 08/26/2013 12:09:06 ******/
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
			SELECT @XL_FL_NM = REPLICATE('0', 4) + @XL_FL_NM;
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



-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------

/****** Object:  View [dbo].[uvw_NewId]    Script Date: 08/19/2013 11:30:47 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[uvw_NewId]'))
DROP VIEW [dbo].[uvw_NewId]
GO


/****** Object:  View [dbo].[uvw_NewId]    Script Date: 08/19/2013 11:30:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[uvw_NewId]
AS
SELECT     NEWID() AS NEW_ID




GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'uvw_NewId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'uvw_NewId'
GO



-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgent_PatientVisit]    Script Date: 08/26/2013 12:28:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgent_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgent_PatientVisit]    Script Date: 08/26/2013 12:28:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI

CREATE PROCEDURE [Patient].[usp_GetXmlReportAgent_PatientVisit]
     @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	 = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportAgent_PatientVisit]
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinic_PatientVisit]    Script Date: 08/26/2013 12:30:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportClinic_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinic_PatientVisit]    Script Date: 08/26/2013 12:30:29 ******/
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
			ROW_NUMBER() OVER (PARTITION BY [PV].[CASE_NO] ORDER BY [PV].[CASE_NO] ASC) AS [SN_TMP]
			, [PV].*
		FROM
			[dbo].[uvw_PatientVisit] PV
		INNER JOIN
			[User].[UserClinic] UC WITH (NOLOCK)
		ON
			[UC].[ClinicID] = [PV].[CLINIC_ID]
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



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicDt_PatientVisit]    Script Date: 08/27/2013 19:01:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportClinicDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportClinicDt_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicDt_PatientVisit]    Script Date: 08/27/2013 19:01:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportClinicDt_PatientVisit]	
     @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	WITH CTE AS
	(
		SELECT 
			ROW_NUMBER() OVER (PARTITION BY [PV].[CASE_NO] ORDER BY [PV].[CASE_NO] ASC) AS [SN_TMP]
			, [PV].*
		FROM
			[dbo].[uvw_PatientVisit] PV
		INNER JOIN
			[User].[UserClinic] UC WITH (NOLOCK)
		ON
			[UC].[ClinicID] = [PV].[CLINIC_ID]
		WHERE
			 [UC].[UserID] = @ID
		AND
			[PV].[DOS] BETWEEN @DATE_FROM AND @DATE_TO
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
	
	-- EXEC [Patient].[usp_GetXmlReportClinicDt_PatientVisit]  @ID = 1, @DATE_FROM ='2012-JAN-12',@DATE_TO='2012-FEB-12'
END





GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicWise_PatientVisit]    Script Date: 08/27/2013 19:06:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportClinicWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportClinicWise_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicWise_PatientVisit]    Script Date: 08/27/2013 19:06:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [Patient].[usp_GetXmlReportClinicWise_PatientVisit]	
      @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[CLINIC_ID] = @ID
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportClinicWise_PatientVisit]  @CLINIC_ID = 1
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicWiseDt_PatientVisit]    Script Date: 08/27/2013 19:01:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportClinicWiseDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportClinicWiseDt_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportClinicWiseDt_PatientVisit]    Script Date: 08/27/2013 19:01:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportClinicWiseDt_PatientVisit]	
      @ID INT
    ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[CLINIC_ID] = @ID
	AND
	     [PAT_VST].[DOS] BETWEEN @DATE_FROM AND @DATE_TO 	 
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportClinicDt_PatientVisit]  @USER_ID = 1, @DATE_FROM ='2012-JAN-12',@DATE_TO='2012-FEB-12'
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatient_PatientVisit]    Script Date: 08/27/2013 19:02:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportPatient_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatient_PatientVisit]    Script Date: 08/27/2013 19:02:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI

CREATE PROCEDURE [Patient].[usp_GetXmlReportPatient_PatientVisit]
      @ID INT
    ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportPatient_PatientVisit]
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientDt_PatientVisit]    Script Date: 08/22/2013 12:02:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportPatientDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportPatientDt_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientDt_PatientVisit]    Script Date: 08/22/2013 12:02:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportPatientDt_PatientVisit]
      @ID INT
     ,@DATE_FROM DATE
     ,@DATE_TO DATE	

AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportPatientDt_PatientVisit]
END




GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientWise_PatientVisit]    Script Date: 08/27/2013 19:02:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportPatientWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportPatientWise_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientWise_PatientVisit]    Script Date: 08/27/2013 19:02:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportPatientWise_PatientVisit]	
      @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL	
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[PATIENT_ID] = @ID
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProvider_PatientVisit] @PATIENT_ID = 1
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientWiseDt_PatientVisit]    Script Date: 08/27/2013 19:03:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportPatientWiseDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportPatientWiseDt_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportPatientWiseDt_PatientVisit]    Script Date: 08/27/2013 19:03:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportPatientWiseDt_PatientVisit]	
      @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL	
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[PATIENT_ID] = @ID
	AND
	     [PAT_VST].[DOS] BETWEEN @DATE_FROM AND @DATE_TO 	 
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]  @PATIENT_ID = 1, @DATE_FROM ='2012-JAN-12',@DATE_TO='2012-FEB-12'
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProvider_PatientVisit]    Script Date: 08/27/2013 19:03:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportProvider_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProvider_PatientVisit]    Script Date: 08/27/2013 19:03:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI

CREATE PROCEDURE [Patient].[usp_GetXmlReportProvider_PatientVisit]
	    @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL	
AS
BEGIN
	SET NOCOUNT ON;	
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProvider_PatientVisit]
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderDt_PatientVisit]    Script Date: 08/27/2013 19:04:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportProviderDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportProviderDt_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderDt_PatientVisit]    Script Date: 08/27/2013 19:04:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportProviderDt_PatientVisit]
      @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL	
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProviderDt_PatientVisit]
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderWise_PatientVisit]    Script Date: 08/27/2013 19:04:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportProviderWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportProviderWise_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderWise_PatientVisit]    Script Date: 08/27/2013 19:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportProviderWise_PatientVisit]	
      @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL	
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[PROVIDER_ID] = @ID
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProvider_PatientVisit] @PROVIDER_ID = 1
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]    Script Date: 08/27/2013 19:05:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]    Script Date: 08/27/2013 19:05:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]	
     @ID INT
      ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[CASE_NO] ASC) AS [SN]
		, [PAT_VST].*
	FROM
		[dbo].[uvw_PatientVisit] PAT_VST
	WHERE
		 [PAT_VST].[PROVIDER_ID] = @ID
	AND
	     [PAT_VST].[DOS] BETWEEN @DATE_FROM AND @DATE_TO 	 
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportProviderWiseDt_PatientVisit]  @PROVIDER_ID = 1, @DATE_FROM ='2012-JAN-12',@DATE_TO='2012-FEB-12'
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWise_PatientVisit]    Script Date: 08/26/2013 12:27:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgentWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgentWise_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWise_PatientVisit]    Script Date: 08/26/2013 12:27:32 ******/
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
			ROW_NUMBER() OVER (PARTITION BY [PV].[CASE_NO] ORDER BY [PV].[CASE_NO] ASC) AS [SN_TMP]
			, [PV].*
		FROM
			[dbo].[uvw_PatientVisit] PV
		INNER JOIN 
			[Claim].[ClaimProcess] CP WITH (NOLOCK)
		ON
			[CP].[PatientVisitID] = [PV].[CASE_NO]
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
	
	-- EXEC [Patient].[usp_GetXmlReportAgentWise_PatientVisit]  @USER_ID = 1
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentDt_PatientVisit]    Script Date: 08/27/2013 19:00:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgentDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgentDt_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentDt_PatientVisit]    Script Date: 08/27/2013 19:00:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--CREATED BY SAI 

CREATE PROCEDURE [Patient].[usp_GetXmlReportAgentDt_PatientVisit]
      @ID INT
     ,@DATE_FROM DATE = NULL
     ,@DATE_TO DATE	= NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH CTE AS
	(
		SELECT CAST(1 AS BIGINT) AS [SN_TMP]
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [PAT_VST].[SN_TMP] ASC) AS [SN]
		, [PAT_VST].* 
	FROM 
		CTE PAT_VST
	WHERE
		[PAT_VST].[SN_TMP] = 1
	FOR XML AUTO, ROOT('PAT_VSTS');	
	
	-- EXEC [Patient].[usp_GetXmlReportAgentDt_PatientVisit]
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]    Script Date: 08/22/2013 11:59:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlReportAgentWiseDt_PatientVisit]    Script Date: 08/22/2013 11:59:33 ******/
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
			ROW_NUMBER() OVER (PARTITION BY [PV].[CASE_NO] ORDER BY [PV].[CASE_NO] ASC) AS [SN_TMP]
			, [PV].*
		FROM
			[dbo].[uvw_PatientVisit] PV
		INNER JOIN 
			[Claim].[ClaimProcess] CP WITH (NOLOCK)
		ON
			[CP].[PatientVisitID] = [PV].[CASE_NO]
		WHERE
			[CP].[CreatedBy] = @ID
		AND
			[PV].[DOS] BETWEEN @DATE_FROM AND @DATE_TO
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
	
	-- EXEC [Patient].[usp_GetXmlReportAgentWise_PatientVisit]  @USER_ID = 1
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetDayStatus_UserReport]    Script Date: 08/19/2013 19:08:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetDayStatus_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetDayStatus_UserReport]
GO

-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetCount_PatientVisit]    Script Date: 08/19/2013 19:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetCount_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetCount_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetCount_PatientVisit]    Script Date: 08/19/2013 19:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetCount_PatientVisit]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLAIM_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT
		COUNT ([Patient].[PatientVisit].[PatientVisitID]) AS [CLAIM_COUNT]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[EDI].[EDIReceiver] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
	(
		[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
	OR
		@AssignedTo IS NULL
	)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 20, @StatusIDs = '16,17,18,19,20', @AssignedTo = 116	-- UNASSIGNED
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [Patient].[usp_GetCount_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END







GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [EDI].[usp_GetNameCode_EDIReceiver]    Script Date: 08/26/2013 17:38:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetNameCode_EDIReceiver]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetNameCode_EDIReceiver]
GO



/****** Object:  StoredProcedure [EDI].[usp_GetNameCode_EDIReceiver]    Script Date: 08/26/2013 17:38:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [EDI].[usp_GetNameCode_EDIReceiver] 
	@ClinicID INT
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		[EDI].[EDIReceiver].[EDIReceiverID]
		, [EDI].[EDIReceiver].[EDIReceiverName] + ' [' + [EDI].[EDIReceiver].[EDIReceiverCode] +']' AS [NAME_CODE]
		, (SELECT
		COUNT ([Patient].[PatientVisit].[PatientVisitID]) AS [EDIReceiver837Count]
		FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType] WITH (NOLOCK)
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship] WITH (NOLOCK)
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential] WITH (NOLOCK)
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty] WITH (NOLOCK)
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType] WITH (NOLOCK)
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin] WITH (NOLOCK)
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY WITH (NOLOCK)
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE WITH (NOLOCK)
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY WITH (NOLOCK)
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY WITH (NOLOCK)
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE WITH (NOLOCK)
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY WITH (NOLOCK)
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Insurance].[Insurance].[CountryID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Insurance].[Insurance].[EDIReceiverID] = [EDI].[EDIReceiver].[EDIReceiverID]
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
	(
		[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
	OR
		@AssignedTo IS NULL
	)
	AND
		[Patient].[PatientVisit].[IsActive] = 1) AS [ClaimCount]
	FROM
		[EDI].[EDIReceiver]
	WHERE
		[EDI].[EDIReceiver].[IsActive] = 1;
			
	-- EXEC [EDI].[usp_GetNameCode_EDIReceiver]  @ClinicID = 18 , @StatusIDs ='16,17,18,19,20', @AssignedTo = null
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Excel].[usp_GetXmlReportTypeAll_ReportType]    Script Date: 08/20/2013 09:25:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_GetXmlReportTypeAll_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_GetXmlReportTypeAll_ReportType]
GO


/****** Object:  StoredProcedure [Excel].[usp_GetXmlReportTypeAll_ReportType]    Script Date: 08/20/2013 09:25:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---CREATED BY SAI

CREATE PROCEDURE [Excel].[usp_GetXmlReportTypeAll_ReportType]
AS
BEGIN
	SELECT
		ROW_NUMBER() OVER (ORDER BY [EXL].[ReportTypeID] ASC) AS [SN]
		, [EXL].[ReportTypeID] AS [REPORT_TYPE_ID],[EXL].[ReportTypeName] AS [REPORT_TYPE_NAME]
	FROM
		[Excel].[ReportType] EXL WITH (NOLOCK)
	WHERE
		[EXL].[IsActive] = 1
	FOR XML AUTO, ROOT('RPTTYPE');
	
	-- EXEC [Excel].[usp_GetXmlReportTypeAll_ReportType]
END


GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [dbo].[usp_GetNext_Identity]    Script Date: 08/20/2013 14:22:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetNext_Identity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetNext_Identity]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetNext_Identity]    Script Date: 08/20/2013 14:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--  Get Next Identity Value
CREATE PROCEDURE [dbo].[usp_GetNext_Identity]
	@SchemaName	NVARCHAR(150)
	, @TableName NVARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[A].[column_id] AS [ID]
		, ISNULL(CAST(CASE WHEN [A].[last_value] IS NULL THEN [A].[seed_value] ELSE (CAST([A].[last_value] AS BIGINT) + CAST([A].[increment_value] AS INT)) END AS BIGINT), '0') AS [NEXT_INDENTITY]
	FROM 
		[sys].[identity_columns] A
	WHERE
		[A].[object_id] = OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName));
    
    -- EXEC [dbo].[usp_GetNext_Identity] @SchemaName = 'Audit', @TableName = 'UserReport'
END

GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetXmlDelete_UserReport]    Script Date: 08/22/2013 09:39:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetXmlDelete_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetXmlDelete_UserReport]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetXmlDelete_UserReport]    Script Date: 08/22/2013 09:39:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Audit].[usp_GetXmlDelete_UserReport]
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_PK TABLE
	(
		[USER_REPORT_ID] SMALLINT NOT NULL
		, [EXCEL_FILE_NAME] NVARCHAR(50) NOT NULL
	); 
	
	IF EXISTS(SELECT [A].[UserReportID] FROM [Audit].[UserReport] A WHERE [A].[UserReportID] > 32700)
	BEGIN
		DELETE
			A
		OUTPUT
			[deleted].[UserReportID]
			, [deleted].[ExcelFileName]
		INTO
			@TBL_PK
		FROM
			[Audit].[UserReport] A;
		
		DBCC CHECKIDENT('[Audit].[UserReport]', RESEED, 1);
	END
	ELSE
	BEGIN
		DELETE
			A
		OUTPUT
			[deleted].[UserReportID]
			, [deleted].[ExcelFileName]
		INTO
			@TBL_PK
		FROM
			[Audit].[UserReport] A
		WHERE
			DATEDIFF(DAY, [A].[ExcelImportedOn], GETDATE()) > 7;
	END
	
	SELECT * FROM @TBL_PK AS TEMP FOR XML AUTO, ROOT('DELETED_REPORTS');;

 --EXEC [Audit].[usp_GetXmlDelete_UserReport]	
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Excel].[usp_GetXmlReportType_ReportType]    Script Date: 08/23/2013 15:48:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Excel].[usp_GetXmlReportType_ReportType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Excel].[usp_GetXmlReportType_ReportType]
GO

-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetByAZEDI_PatientVisit]    Script Date: 08/21/2013 14:25:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZEDI_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZEDI_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZEDI_PatientVisit]    Script Date: 08/21/2013 14:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Patient].[usp_GetByAZEDI_PatientVisit] 
	@EDIFileID INT 
	, @ClinicID INT
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @SearchName NVARCHAR(150) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
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
		SELECT @DateFrom = MIN([DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([DOS]) FROM [Patient].[PatientVisit];
	END
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	SELECT
		((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))))
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT
				[Claim].[ClaimProcess].[PatientVisitID]
			FROM
				[Claim].[ClaimProcess] WITH (NOLOCK)
			INNER JOIN
				[Claim].[ClaimProcessEDIFile]
			ON
				[Claim].[ClaimProcessEDIFile].[ClaimProcessID] = [Claim].[ClaimProcess].[ClaimProcessID]
			INNER JOIN
				[EDI].[EDIFile]
			ON
				[EDI].[EDIFile].[EDIFileID] = [Claim].[ClaimProcessEDIFile].[EDIFileID]
			WHERE
				[EDI].[EDIFile].[EDIFileID] = @EDIFileID
		)		
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
	   	[Patient].[Patient].[ClinicID]	= @ClinicID;
	   		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Patient].[usp_GetByAZEDI_PatientVisit] @EDIFileID  = 8088, @ClinicID = 20
END








GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationMultiManager_UserClinic]    Script Date: 08/21/2013 19:47:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationMultiManager_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationMultiManager_UserClinic]
GO

/****** Object:  StoredProcedure [User].[usp_GetNotificationMultiManager_UserClinic]    Script Date: 08/21/2013 19:47:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationMultiManager_UserClinic] 
	@ManagerRoleID TINYINT
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@USER_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@USER_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);   
		
   DECLARE @CLNC_NO_TMP TABLE
	(
		 [CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[IsActive] = 1;
	
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
		[Billing].[Clinic].[ClinicID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ClinicName' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ClinicName] END ASC,
				CASE WHEN @orderByField = 'ClinicName' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ClinicName] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'ICDFormat' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[ICDFormat] END ASC,
				CASE WHEN @orderByField = 'ICDFormat' AND @orderByDirection = 'D' THEN [Billing].[Clinic].[ICDFormat] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Clinic].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Clinic].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM 
 		[Billing].[Clinic] WITH (NOLOCK)
 	INNER JOIN
		 [User].[UserClinic] WITH (NOLOCK)
	ON
		[Billing].[Clinic].[ClinicID] = [User].[UserClinic].[ClinicID]
	INNER JOIN
		 [User].[User]  WITH (NOLOCK)
	ON
		 [User].[UserClinic].[UserID] = [User].[User].[UserID]
	INNER JOIN
		 @CLNC_NO_TMP C
	ON
		 [User].[UserClinic].[ClinicID] = [C].[CLINIC_ID]
	INNER JOIN
		@USER_TMP U
	ON
		[User].[User].[UserID] = [U].[USER_ID]
	WHERE
		[Billing].[Clinic].[IsActive] = 1
	GROUP BY 
		[Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
		, [Billing].[Clinic].[LastModifiedOn]
	HAVING     
		(COUNT([Billing].[Clinic].[ClinicID]) > 1 );
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	FROM
		[Billing].[Clinic] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Billing].[Clinic].[ClinicID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM;
	
			
	-- EXEC [User].[usp_GetNotificationMultiManager_UserClinic] NULL
	-- EXEC [User].[usp_GetNotificationMultiManager_UserClinic] @ManagerRoleID=2,@OrderByField = 'ICDFormat', @OrderByDirection = 'D'
	-- EXEC [User].[usp_GetNotificationMultiManager_UserClinic] 2
END










GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationCountMultiManager_UserClinic]    Script Date: 08/21/2013 20:08:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationCountMultiManager_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationCountMultiManager_UserClinic]
GO

/****** Object:  StoredProcedure [User].[usp_GetNotificationCountMultiManager_UserClinic]    Script Date: 08/21/2013 20:08:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationCountMultiManager_UserClinic] 
	@ManagerRoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@USER_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@USER_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);   
		
   DECLARE @CLNC_NO_TMP TABLE
	(
		 [CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[IsActive] = 1;
		
	DECLARE @CLNC_NO TABLE
	(
		[CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO
	SELECT     
		[User].[UserClinic].[ClinicID]
	FROM
		 [User].[UserClinic]
	INNER JOIN
		 [User].[User] 
	ON
		 [User].[UserClinic].[UserID] = [User].[User].[UserID]
	INNER JOIN
		 @CLNC_NO_TMP C
	ON
		 [User].[UserClinic].[ClinicID] = [C].[CLINIC_ID]
	INNER JOIN
		@USER_TMP U
	ON
		[User].[User].[UserID] = [U].[USER_ID]
	GROUP BY 
		[User].[UserClinic].[ClinicID]
	HAVING     
		(COUNT([User].[UserClinic].[ClinicID]) > 1 )
	
	SELECT
		CAST('1' AS TINYINT) AS [SN]
		, COUNT(*) AS [CLINIC_COUNT]
	FROM @CLNC_NO CN;	
		
	-- EXEC [User].[usp_GetNotificationCountMultiManager_UserClinic] 2
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNotificationMultiManagerPdf_UserClinic]    Script Date: 08/21/2013 20:12:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNotificationMultiManagerPdf_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNotificationMultiManagerPdf_UserClinic]
GO

/****** Object:  StoredProcedure [User].[usp_GetNotificationMultiManagerPdf_UserClinic]    Script Date: 08/21/2013 20:12:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetNotificationMultiManagerPdf_UserClinic] 
	@ManagerRoleID TINYINT

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
	
	INSERT INTO
		@USER_TMP
	SELECT 
		[User].[UserRole].[UserID]
	FROM 
		[User].[UserRole]
	WHERE
		[User].[UserRole].[RoleID] = @ManagerRoleID
	AND
		[User].[UserRole].[IsActive] = 1;
	
	DELETE FROM
		@USER_TMP
	WHERE
		[USER_ID] IN
		(
			SELECT 
				[User].[UserRole].[UserID]
			FROM 
				[User].[UserRole]
			WHERE
				[User].[UserRole].[RoleID] < @ManagerRoleID
			AND
				[User].[UserRole].[IsActive] = 1
		)
	OR
		[USER_ID] IN
		(
			SELECT 
				[User].[User].[UserID]
			FROM 
				[User].[User]
			WHERE
				[User].[User].[ManagerID] IS NOT NULL
			AND
				[User].[User].[IsActive] = 1
		);   
		
   DECLARE @CLNC_NO_TMP TABLE
	(
		 [CLINIC_ID] INT NOT NULL
	);
	
	INSERT INTO
		@CLNC_NO_TMP
	SELECT
		[A].[ClinicID]
	FROM
		[Billing].[Clinic] A WITH (NOLOCK)
	WHERE
		[A].[IsActive] = 1;
		
			
	SELECT
		[Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	FROM
		[Billing].[Clinic]
	INNER JOIN
		 [User].[UserClinic]
	ON
		[Billing].[Clinic].[ClinicID] = [User].[UserClinic].[ClinicID]
	INNER JOIN
		 [User].[User] 
	ON
		 [User].[UserClinic].[UserID] = [User].[User].[UserID]
	INNER JOIN
		 @CLNC_NO_TMP C
	ON
		 [User].[UserClinic].[ClinicID] = [C].[CLINIC_ID]
	INNER JOIN
		@USER_TMP U
	ON
		[User].[User].[UserID] = [U].[USER_ID]
	GROUP BY 
		[Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[NPI]
		, [Billing].[Clinic].[ICDFormat]
	HAVING     
		(COUNT([Billing].[Clinic].[ClinicID]) > 1 )
		
	-- EXEC [User].[usp_GetNotificationMultiManagerPdf_UserClinic] 2
END


GO



-----------------------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetXmlReport_PatientVisit]    Script Date: 08/22/2013 12:06:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlReport_PatientVisit]
GO

-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetXmlClinic_UserClinic]    Script Date: 08/28/2013 16:41:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetXmlClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetXmlClinic_UserClinic]
GO

/****** Object:  StoredProcedure [User].[usp_GetXmlClinic_UserClinic]    Script Date: 08/28/2013 16:41:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting Clinic of the corressponding user

CREATE PROCEDURE [User].[usp_GetXmlClinic_UserClinic]
@ID INT
AS
BEGIN
	SELECT 
	     [UC].[ClinicID] 
	    ,[BC].[ClinicName]
	     
		FROM
			[User].[UserClinic] UC WITH (NOLOCK)
	    
	    INNER JOIN		
			[Billing].[Clinic] BC WITH (NOLOCK)
		ON
		    
			UC.ClinicID = BC.ClinicID					
			
		WHERE
			 [UC].[UserID] = @ID
		AND
			[UC].[IsActive] = 1
			
		FOR XML AUTO, ROOT('USER_CLINIC');	
	
	-- EXEC [User].[usp_GetXmlClinic_UserClinic] 1
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetXmlProvider_Provider]    Script Date: 08/28/2013 16:42:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetXmlProvider_Provider]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetXmlProvider_Provider]
GO



/****** Object:  StoredProcedure [Billing].[usp_GetXmlProvider_Provider]    Script Date: 08/28/2013 16:42:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting provider from a Clinic

CREATE PROCEDURE [Billing].[usp_GetXmlProvider_Provider]
@ID INT
AS
BEGIN
	SELECT 
	     [PR].[ProviderID]
	    ,((LTRIM(RTRIM([PR].[LastName] + ' ' + [PR].[FirstName] + ' ' + ISNULL([PR].[MiddleName], ''))))) as [NAME] 
		FROM
			[Billing].[Provider] [PR] WITH (NOLOCK)
		
		WHERE
			 [PR].[ClinicID] = @ID
		AND
			[PR].[IsActive] = 1
			
		FOR XML AUTO, ROOT('PROVIDER');	
	
	-- EXEC [Billing].[usp_GetXmlProvider_Provider] 1
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]    Script Date: 08/23/2013 09:11:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardSummaryNIT_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]    Script Date: 08/23/2013 09:11:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Patient].[usp_GetDashboardSummaryNIT_PatientVisit]
	@UserID BIGINT
	, @NIT_StatusIDs NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_CLINIC TABLE 
	(
		[ClinicID] INT NOT NULL
	);
	
	INSERT INTO
		@TBL_CLINIC
	SELECT 
		[User].[UserClinic].[ClinicID] 
	FROM 
		[User].[UserClinic]   WITH (NOLOCK)
	INNER JOIN
		[Billing].[Clinic]  WITH (NOLOCK) 
	ON
		[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
	WHERE 
		[User].[UserClinic].[UserID] = @UserID 
	AND 
		[User].[UserClinic].[IsActive] = 1 
	AND 
		[Billing].[Clinic].[IsActive] = 1;
		
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [BLOCKED] BIGINT NOT NULL
		, [NIT] BIGINT NOT NULL
		, [TOTAL] BIGINT NOT NULL
	);
	
	DECLARE @BLOCKED BIGINT;
	DECLARE @NIT BIGINT;
	DECLARE @TOTAL BIGINT;
	
	--
	
	SELECT 
		@BLOCKED = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Patient].[PatientVisit].[IsActive] = 0;
	
	--
	
	SELECT 
		@NIT = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	--	
	
	SELECT 
		@TOTAL = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@TBL_CLINIC T
	ON
		[Patient].[Patient].[ClinicID] = [T].[ClinicID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	--
			
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		@BLOCKED
		, @NIT
		, @TOTAL
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetDashboardSummaryNIT_PatientVisit] 9, '3, 5, 8, 12, 14, 18, 20, 24, 27'
END








GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetSearch_UserReport]    Script Date: 08/28/2013 15:22:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetSearch_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetSearch_UserReport]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetSearch_UserReport]    Script Date: 08/28/2013 15:22:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Audit].[usp_GetSearch_UserReport]
	@UserID INT
	, @ReportTypeID TINYINT
	, @ForDtRpt BIT
	, @ReportObjectID BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		 [UR].*
	FROM
		[Audit].[UserReport] UR
	WHERE
		[UR].[UserID] = @UserID
	AND
		[UR].[ReportTypeID] = @ReportTypeID
	AND
		(
			(@ForDtRpt = 0 AND [UR].[DateFrom] IS NULL AND [UR].[DateTo] IS NULL)
		OR
			(@ForDtRpt = 1 AND [UR].[DateFrom] IS NOT NULL AND [UR].[DateTo] IS NOT NULL)
		)
	AND
		(([UR].[ReportObjectID] IS NULL AND @ReportObjectID IS NULL) OR ([UR].[ReportObjectID] = @ReportObjectID));
		
	-- EXEC [Audit].[usp_GetSearch_UserReport] @UserID = 116, @ReportTypeID = 1, @ForDtRpt = 0
	-- EXEC [Audit].[usp_GetSearch_UserReport] @UserID = 116, @ReportTypeID = 1, @ForDtRpt = 1
END



GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetExcel_UserReport]    Script Date: 08/23/2013 15:31:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetExcel_UserReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetExcel_UserReport]
GO


/****** Object:  StoredProcedure [Audit].[usp_GetExcel_UserReport]    Script Date: 08/23/2013 15:31:37 ******/
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
	FROM
		[Audit].[UserReport] UR
	WHERE
		[UR].[UserID] = @UserID
	AND
		[UR].[UserReportID] = @UserReportID;
		
	-- EXEC [Audit].[usp_GetExcel_UserReport] @UserID = 1, @UserReportID = 1
END



GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetXmlNameByID_User]    Script Date: 08/23/2013 15:47:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetXmlNameByID_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetXmlNameByID_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetXmlNameByID_User]    Script Date: 08/23/2013 15:47:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Select the particular record

CREATE PROCEDURE [User].[usp_GetXmlNameByID_User] 
	@UserID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
	FROM
		[User].[User] WITH (NOLOCK)
	WHERE
		[User].[User].[UserID] = @UserID
	AND
		[User].[User].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES AS USR FOR XML AUTO, ROOT('USRS');

	-- EXEC [User].[usp_GetNameByID_User] 1
	
END
GO



-----------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_ReportType_ReportTypeID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Audit].[FK_UserReport_User_UserID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [FK_UserReport_User_UserID]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_CurrImportEndOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_CurrImportEndOn]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_CurrImportStartOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_CurrImportStartOn]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_ExcelImportedOn]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_ExcelImportedOn]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[Audit].[CK_UserReport_ReportObjectID]') AND parent_object_id = OBJECT_ID(N'[Audit].[UserReport]'))
ALTER TABLE [Audit].[UserReport] DROP CONSTRAINT [CK_UserReport_ReportObjectID]
GO



/****** Object:  Table [Audit].[UserReport]    Script Date: 08/26/2013 11:00:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[UserReport]') AND type in (N'U'))
DROP TABLE [Audit].[UserReport]
GO



/****** Object:  Table [Audit].[UserReport]    Script Date: 08/26/2013 11:00:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Audit].[UserReport](
	[UserReportID] [smallint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [tinyint] NOT NULL,
	[ReportObjectID] [bigint] NULL,
	[DateFrom] [date] NULL,
	[DateTo] [date] NULL,
	[UserID] [int] NOT NULL,
	[ExcelFileName] [nvarchar](50) NOT NULL,
	[ExcelImportedOn] [datetime] NOT NULL,
	[IsSuccess] [bit] NOT NULL,
	[CurrImportStartOn] [datetime] NOT NULL,
	[CurrImportEndOn] [datetime] NULL,
 CONSTRAINT [PK_UserReport] PRIMARY KEY CLUSTERED 
(
	[UserReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_UserReport_ExcelFileName] UNIQUE NONCLUSTERED 
(
	[ExcelFileName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [FK_UserReport_ReportType_ReportTypeID] FOREIGN KEY([ReportTypeID])
REFERENCES [Excel].[ReportType] ([ReportTypeID])
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [FK_UserReport_ReportType_ReportTypeID]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [FK_UserReport_User_UserID] FOREIGN KEY([UserID])
REFERENCES [User].[User] ([UserID])
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [FK_UserReport_User_UserID]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_CurrImportEndOn] CHECK  (([CurrImportStartOn]<=[CurrImportEndOn] OR [CurrImportEndOn] IS NULL))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_CurrImportEndOn]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_CurrImportStartOn] CHECK  (([CurrImportStartOn]>=[ExcelImportedOn]))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_CurrImportStartOn]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_ExcelImportedOn] CHECK  (([ExcelImportedOn]<=getdate()))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_ExcelImportedOn]
GO

ALTER TABLE [Audit].[UserReport]  WITH CHECK ADD  CONSTRAINT [CK_UserReport_ReportObjectID] CHECK  (([ReportObjectID] IS NULL OR [ReportObjectID]>(0)))
GO

ALTER TABLE [Audit].[UserReport] CHECK CONSTRAINT [CK_UserReport_ReportObjectID]
GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlPatient_Patient]    Script Date: 08/28/2013 16:42:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlPatient_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlPatient_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetXmlPatient_Patient]    Script Date: 08/28/2013 16:42:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting patient from a Clinic

CREATE PROCEDURE [Patient].[usp_GetXmlPatient_Patient]
@ID INT
AS
BEGIN
	SELECT 
	     [PA].[PatientID]
	    ,((LTRIM(RTRIM([PA].[LastName] + ' ' + [PA].[FirstName] + ' ' + ISNULL([PA].[MiddleName], ''))))) as [NAME]  
		FROM
			[Patient].[Patient] [PA] WITH (NOLOCK)
		
		WHERE
			 [PA].[ClinicID] = @ID
		AND
			[PA].[IsActive] = 1
			
		FOR XML AUTO, ROOT('PATIENT');	
	
	-- EXEC [Patient].[usp_GetXmlPatient_Patient] 1
END


GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Billing].[usp_GetXmlReportObjectName_Clinic]    Script Date: 08/26/2013 17:08:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetXmlReportObjectName_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetXmlReportObjectName_Clinic]
GO

-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 08/27/2013 16:05:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNameByID_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNameByID_User]
GO

/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 08/27/2013 16:05:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- Select the particular record

CREATE PROCEDURE [User].[usp_GetNameByID_User] 
	@UserID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
	FROM
		[User].[User] WITH (NOLOCK)
	WHERE
		[User].[User].[UserID] = @UserID
	AND
		[User].[User].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetNameByID_User] 1
	
END







GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetCount837_PatientVisit]    Script Date: 08/27/2013 18:10:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetCount837_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetCount837_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetCount837_PatientVisit]    Script Date: 08/27/2013 18:10:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetCount837_PatientVisit]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLAIM_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT
		COUNT ([Patient].[PatientVisit].[PatientVisitID]) AS [CLAIM_COUNT]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType] WITH (NOLOCK)
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship] WITH (NOLOCK)
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential] WITH (NOLOCK)
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty] WITH (NOLOCK)
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType] WITH (NOLOCK)
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin] WITH (NOLOCK)
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY WITH (NOLOCK)
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE WITH (NOLOCK)
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY WITH (NOLOCK)
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY WITH (NOLOCK)
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE WITH (NOLOCK)
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY WITH (NOLOCK)
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Insurance].[Insurance].[CountryID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
	(
		[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
	OR
		@AssignedTo IS NULL
	)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [Patient].[usp_GetCount837_PatientVisit] @ClinicID = 18, @StatusIDs = '16,17,18,19,20', @AssignedTo = 116	-- UNASSIGNED
	-- EXEC [Patient].[usp_GetCount837_PatientVisit] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [Patient].[usp_GetCount837_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [Patient].[usp_GetCount837_PatientVisit] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END









GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetUnAssigned_PatientVisit]    Script Date: 08/27/2013 17:46:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetUnAssigned_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetUnAssigned_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetUnAssigned_PatientVisit]    Script Date: 08/27/2013 17:46:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetUnAssigned_PatientVisit]
	  @ClinicID INT
	, @StatusIDs NVARCHAR(100)
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @AssignedTo INT = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'	
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
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
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
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType] WITH (NOLOCK)
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship] WITH (NOLOCK)
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential] WITH (NOLOCK)
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty] WITH (NOLOCK)
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType] WITH (NOLOCK)
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin] WITH (NOLOCK)
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY WITH (NOLOCK)
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE WITH (NOLOCK)
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY WITH (NOLOCK)
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY WITH (NOLOCK)
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE WITH (NOLOCK)
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY WITH (NOLOCK)
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Insurance].[Insurance].[CountryID]	
	WHERE
		
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo
		OR
			@AssignedTo IS NULL
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT
		 [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID]=[Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientVisit].[PatientVisitID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
	-- EXEC [Patient].[usp_GetUnAssigned_PatientVisit] @ClinicID = 1, @SearchName='RITBE000', @StatusIDs = '1, 2', @DateFrom = '3/1/2000 12:00:00 AM' , @DateTo = '3/2/2014 12:00:00 AM'
END










GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetCount835_EDIFile]    Script Date: 08/27/2013 18:11:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetCount835_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetCount835_EDIFile]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetCount835_EDIFile]    Script Date: 08/27/2013 18:11:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [EDI].[usp_GetCount835_EDIFile]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
	, @UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
	DECLARE @TBL_EID TABLE
	(
		[EDI_FILE_ID] INT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_EID
	SELECT DISTINCT
		[B].[EDIFileID]
	FROM
		[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimProcess] C WITH (NOLOCK)
	ON
		[C].[ClaimProcessID] = [B].[ClaimProcessID]
	INNER JOIN
		[Patient].[PatientVisit] D WITH (NOLOCK)
	ON
		[D].[PatientVisitID] = [C].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] E WITH (NOLOCK)
	ON
		[E].[PatientID] = [D].[PatientID]
	INNER JOIN
		@TBL_SID F
	ON
		[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
	WHERE
		[E].[ClinicID] = @ClinicID
	AND
		[D].[AssignedTo] = @UserID
	AND
		[D].[IsActive] = 1;
	
	SELECT
		CAST(1 AS TINYINT) AS [ID]
		, COUNT ([A].[EDIFileID]) AS [CLAIM_COUNT]
	FROM
		[EDI].[EDIFile] A WITH (NOLOCK)
	INNER JOIN
		@TBL_EID G
	ON
		[G].[EDI_FILE_ID] = [A].EDIFileID;
		
	-- EXEC [EDI].[usp_GetCount835_EDIFile] @ClinicID=1, @StatusIDs = '23,24', @UserID=13
	-- EXEC [EDI].[usp_GetCount835_EDIFile] @ClinicID = 20, @StatusIDs = '23,24', @UserID = 13
END











GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetCountEDIHistory_EDIFile]    Script Date: 08/27/2013 18:14:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetCountEDIHistory_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetCountEDIHistory_EDIFile]
GO

/****** Object:  StoredProcedure [EDI].[usp_GetCountEDIHistory_EDIFile]    Script Date: 08/27/2013 18:14:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [EDI].[usp_GetCountEDIHistory_EDIFile]
	@ClinicID int
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_SID TABLE
	(
		[CLAIM_STATUS_ID] TINYINT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_SID
	SELECT DISTINCT
		[Data] 
	FROM 
		[dbo].[ufn_StringSplit] (@StatusIDs, ',');
	
	DECLARE @TBL_EID TABLE
	(
		[EDI_FILE_ID] INT PRIMARY KEY NOT NULL
	);
	
	INSERT INTO
		@TBL_EID
	SELECT DISTINCT
		[B].[EDIFileID]
	FROM
		[Claim].[ClaimProcessEDIFile] B WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimProcess] C WITH (NOLOCK)
	ON
		[C].[ClaimProcessID] = [B].[ClaimProcessID]
	INNER JOIN
		[Patient].[PatientVisit] D WITH (NOLOCK)
	ON
		[D].[PatientVisitID] = [C].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] E WITH (NOLOCK)
	ON
		[E].[PatientID] = [D].[PatientID]
	INNER JOIN
		@TBL_SID F
	ON
		[F].[CLAIM_STATUS_ID] = [D].[ClaimStatusID]
	WHERE
		[E].[ClinicID] = @ClinicID
	AND
		[D].[IsActive] = 1;
	
	SELECT
		CAST(1 AS TINYINT) AS [ID]
		, COUNT ([A].[EDIFileID]) AS [CLAIM_COUNT]
	FROM
		[EDI].[EDIFile] A WITH (NOLOCK)
	INNER JOIN
		@TBL_EID G
	ON
		[G].[EDI_FILE_ID] = [A].EDIFileID;
		
	-- EXEC [EDI].[usp_GetCountEDIHistory_EDIFile] @ClinicID=17, @StatusIDs = '23, 24, 25, 26, 27, 28, 29, 30'
	-- EXEC [EDI].[usp_GetCountEDIHistory_EDIFile] @ClinicID = 20, @StatusIDs = '23, 24, 25, 26, 27, 28, 29, 30'
END











GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientVisit]    Script Date: 08/27/2013 18:18:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientVisit]    Script Date: 08/27/2013 18:18:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientVisit]
	@StatusFrom TINYINT
	, @StatusTo TINYINT
	, @ClinicID INT
	, @PatientID BIGINT = NULL
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
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
		SELECT @DateFrom = MIN([DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([DOS]) FROM [Patient].[PatientVisit];
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
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitComplexity] END DESC,
				
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
		[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [PatientVisit].[PatientID] ELSE @PatientID END
	AND
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
		[Patient].[Patient].[ClinicID] = @ClinicID;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, [Patient].[PatientVisit].[TargetBAUserID]
		, [Patient].[PatientVisit].[TargetQAUserID]
		, [Patient].[PatientVisit].[TargetEAUserID]
		, [Patient].[PatientVisit].[IsActive]
		, CAST((CASE WHEN (([Patient].[PatientVisit].[ClaimStatusID] BETWEEN @StatusFrom AND @StatusTo)) THEN '1' ELSE '0' END) AS BIT) AS [CAN_UN_BLOCK]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID]=[Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientVisit].[PatientVisitID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @ClinicID = '1'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = '23197'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = 'RITBE000'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] @StatusFrom = '1', @StatusTo = '9' , @UserID = '101', @ClinicID = '1', @SearchName  = '', @StartBy = 'A', @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END


GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientVisit]    Script Date: 08/27/2013 18:24:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZ_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientVisit]    Script Date: 08/27/2013 18:24:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetByAZ_PatientVisit] 
	 @ClinicID INT
	, @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @PatientID BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		SELECT @DateFrom = MIN([DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([DOS]) FROM [Patient].[PatientVisit];
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientID]=[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [PatientVisit].[PatientID] ELSE @PatientID END
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '') ))) ) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	ORDER BY
		[Patient].[PatientVisit].[LastModifiedBy]
	DESC;
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Patient].[usp_GetByAZ_PatientVisit] @ClinicID= 2
	-- EXEC [Patient].[usp_GetByAZ_PatientVisit] @ClinicID= 2, @SearchName='RAT', @PatientID = NULL
END



GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Claim].[usp_GetByAZ_ClaimProcess]    Script Date: 08/27/2013 18:35:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByAZ_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByAZ_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetByAZ_ClaimProcess]    Script Date: 08/27/2013 18:35:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Claim].[usp_GetByAZ_ClaimProcess] 
	 @ClinicID INT
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
	, @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[Patient]
	INNER JOIN
		[Patient].[PatientVisit]
	ON 
		[Patient].[PatientID]=[PatientVisit].[PatientID]
	WHERE
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND	
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
		OR
			@AssignedTo IS NULL
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;

		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Claim].[usp_GetByAZ_ClaimProcess] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25', @SearchName = ''	-- CREATED
	
END








GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetBySearch_ClaimProcess]    Script Date: 08/27/2013 18:36:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetBySearch_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetBySearch_ClaimProcess]
GO

/****** Object:  StoredProcedure [Claim].[usp_GetBySearch_ClaimProcess]    Script Date: 08/27/2013 18:36:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Claim].[usp_GetBySearch_ClaimProcess]
	  @ClinicID INT
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
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
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]	
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND	
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
		OR
			@AssignedTo IS NULL
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [PatChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Claim].[usp_GetBySearch_ClaimProcess] @ClinicID = 1, @StatusIDs = '3,5', @AssignedTo= 101
	-- EXEC [Claim].[usp_GetBySearch_ClaimProcess] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25', @CurrPageNumber = 1, @RecordsPerPage = 10, @OrderByField = 'PatientVisitID', @OrderByDirection = 'A'	-- CREATED
	-- EXEC [Claim].[usp_GetBySearch_ClaimProcess] @ClinicID = 1, @StatusIDs = '3'
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummary_PatientVisit]    Script Date: 08/28/2013 09:34:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardSummary_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummary_PatientVisit]    Script Date: 08/28/2013 09:34:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [Patient].[usp_GetDashboardSummary_PatientVisit]
	@UserID BIGINT
AS
BEGIN
	-- SET NOCOUNT_BIG ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [DESC] NVARCHAR(15) NOT NULL
		, [COUNT1] BIGINT NOT NULL
		, [COUNT7] BIGINT NOT NULL
		, [COUNT30] BIGINT NOT NULL
		, [COUNT31PLUS] BIGINT NOT NULL
		, [COUNTTOTAL] BIGINT NOT NULL
	);
	
	DECLARE @Data1 BIGINT;
	DECLARE @Data7 BIGINT;
	DECLARE @Data30 BIGINT;
	DECLARE @Data31Plus BIGINT;
	DECLARE @DataTotal BIGINT;	
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT [User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;	
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Visits'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Created COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;	

	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Created'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
--Hold COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Hold'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	
--Ready to send COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Ready To Send'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Sent COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Sent'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Accepted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Accepted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);


	--Rejected COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 12
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 12
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic] WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 12
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 12
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic] WITH (NOLOCK) 
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Rejected'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Resubmitted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess] WITH (NOLOCK) 
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] IN 
		(
			SELECT 
				[User].[UserClinic].[ClinicID] 
			FROM 
				[User].[UserClinic]  WITH (NOLOCK)
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE 
				[User].[UserClinic].[UserID] = @UserID 
			AND 
				[User].[UserClinic].[IsActive] = 1 
			AND 
				[Billing].[Clinic].[IsActive] = 1
		)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Re-Submitted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;		
	
	-- EXEC [Patient].[usp_GetDashboardSummary_PatientVisit] 116
END










GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisit_PatientVisit]    Script Date: 08/28/2013 09:42:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardVisit_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisit_PatientVisit]    Script Date: 08/28/2013 09:42:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Patient].[usp_GetDashboardVisit_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	DECLARE @StatusID INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
		SELECT @StatusID = 12;
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
		SELECT @StatusID = 22;
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF (@Desc = 'Re-Submitted' OR @Desc = 'Rejected')
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM						
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1
		END
		
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > @StatusID
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess]  WITH (NOLOCK)
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	-------
	ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	------
		ELSE IF @DayCount <> 'ALL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] > 0
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
	BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic] WITH (NOLOCK) 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
		
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic]  WITH (NOLOCK)
					INNER JOIN
						[Billing].[Clinic]  WITH (NOLOCK)
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ID] AS [Sl_No]
		, [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Patient].[usp_GetDashboardVisit_PatientVisit]  @UserID = 116,  @Desc = 'Re-Submitted', @DayCount = 'TOTAL'
END










GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZDashVisits_PatientVisit]    Script Date: 08/28/2013 09:48:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZDashVisits_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZDashVisits_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZDashVisits_PatientVisit]    Script Date: 08/28/2013 09:48:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Patient].[usp_GetByAZDashVisits_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(100);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
	END
	
	IF @Desc = 'Resubmit'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
	
	
	
	 DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    
			
	IF @Desc = 'Resubmit' 
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND	
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@TBL_ALL
			SELECT 
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID] IN 
				(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] > 0
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT 
						[User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
					AND 
						[User].[UserClinic].[IsActive] = 1 
					AND 
						[Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
		AND 
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
			@TBL_ALL
		SELECT 
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] IN 
			(
					SELECT [User].[UserClinic].[ClinicID] 
					FROM 
						[User].[UserClinic] 
					INNER JOIN
						[Billing].[Clinic] 
					ON
						[User].[UserClinic].[ClinicID] = [Billing].[Clinic].[ClinicID]
					WHERE 
						[User].[UserClinic].[UserID] = @UserID 
						AND [User].[UserClinic].[IsActive] = 1 
						AND [Billing].[Clinic].[IsActive] = 1
				)
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	-- EXEC [Patient].[usp_GetByAZDashVisits_PatientVisit]  @UserID = 101,  @Desc = 'Visits', @DayCount = 'TOTAL'
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseSummary_PatientVisit]    Script Date: 08/28/2013 09:51:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseSummary_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseSummary_PatientVisit]    Script Date: 08/28/2013 09:51:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetClinicWiseSummary_PatientVisit]
	@ClinicID INT
AS
BEGIN
	-- SET NOCOUNT_BIG ON added to prevent extra result sets from
	-- BIGINTerfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE 
	(
		[ID] TINYINT IDENTITY (1, 1) NOT NULL
		, [DESC] NVARCHAR(15) NOT NULL
		, [COUNT1] BIGINT NOT NULL
		, [COUNT7] BIGINT NOT NULL
		, [COUNT30] BIGINT NOT NULL
		, [COUNT31PLUS] BIGINT NOT NULL
		, [COUNTTOTAL] BIGINT NOT NULL
	);
	
	DECLARE @Data1 BIGINT;
	DECLARE @Data7 BIGINT;
	DECLARE @Data30 BIGINT;
	DECLARE @Data31Plus BIGINT;
	DECLARE @DataTotal BIGINT;	
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Visits'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Created COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 9
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;	

	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Created'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
--Hold COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)	
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (6, 7)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Hold'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	
--Ready to send COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)	
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 15
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Ready To Send'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Sent COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Sent'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	--Accepted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 28
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Accepted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);


	--Rejected COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (26, 27)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Rejected'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);

--Resubmitted COUNT_BIG
	
	SELECT 
		@Data1 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data7 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
----		
	
	SELECT 
		@Data30 = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	----		
	
	SELECT 
		@Data31Plus = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 22
	AND
		[Patient].[PatientVisit].[PatientVisitID] IN
		(
			SELECT 
				[Claim].[ClaimProcess].[PatientVisitID] 
			FROM 
				[Claim].[ClaimProcess]  WITH (NOLOCK)
			WHERE 
				[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
		)
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
		
	SELECT @DataTotal = @Data1 + @Data7 + @Data30 + @Data31Plus;
	
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		'Re-Submitted'
		, @Data1
		, @Data7
		, @Data30
		, @Data31Plus
		, @DataTotal
	);
	
	SELECT * FROM @TBL_ANS ORDER BY [ID] ASC;
	
	-- EXEC [Patient].[usp_GetClinicWiseSummary_PatientVisit]  @ClinicID = 1
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit]    Script Date: 08/28/2013 09:55:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit]    Script Date: 08/28/2013 09:55:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit]
	@ClinicID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TBL_ANS TABLE 
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [NIT] BIGINT NOT NULL
		, [BLOCKED] BIGINT NOT NULL
		, [TOTAL] BIGINT NOT NULL

	);
	
	DECLARE @NIT BIGINT;
	DECLARE @Blocked BIGINT;
	DECLARE @TOTAL BIGINT;
	
	SELECT 
		@NIT = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
-------------
	SELECT 
		@Blocked = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = 0;
	
--
	
	SELECT 
		@TOTAL = COUNT_BIG([Patient].[PatientVisit].[PatientVisitID])
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	WHERE
		[Patient].[PatientVisit].[ClaimStatusID] > 0
	AND 
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[IsActive] = 1;
	
	--
				
	INSERT INTO
		@TBL_ANS
	VALUES
	(
		 @NIT
		, @Blocked
		, @TOTAL
	)
	
	SELECT * FROM @TBL_ANS;		
	
	-- EXEC [Patient].[usp_GetClinicWiseSummaryNIT_PatientVisit] 1
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisit_PatientVisit]    Script Date: 08/28/2013 09:56:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisit_PatientVisit]    Script Date: 08/28/2013 09:56:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetClinicWiseVisit_PatientVisit]
	@ClinicID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[ID] INT IDENTITY (1, 1)
		, [PK_ID] INT NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF @Desc = 'Re-Submitted' 
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount <> 'ALL'
		BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
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
					
						CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
						CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
									
						CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
						CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
										
						CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
						CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
						
						CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
						CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
						CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
						
					) AS ROW_NUM
			FROM
				[Patient].[PatientVisit]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > 0
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[Patient].[ClinicID]  = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
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
				
					CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
					CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
								
					CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
					CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
									
					CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
					CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
					
					CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
					CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
					CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
					
				) AS ROW_NUM
		FROM
			[Patient].[PatientVisit]
		INNER JOIN
			[Patient].[Patient]
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ID] AS [Sl_No]
		, [Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Patient].[usp_GetClinicWiseVisit_PatientVisit]  @ClinicID = 17,  @Desc = 'NIT', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetClinicWiseVisit_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]    Script Date: 08/28/2013 09:58:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]    Script Date: 08/28/2013 09:58:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]
	@ClinicID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @StatusIDs NVARCHAR(150);
	DECLARE @FromDiff INT;
	DECLARE @ToDiff INT;
	
	DECLARE @SEARCH_TMP  TABLE
	(
		[SL_NO] INT IDENTITY (1, 1)
		, [PatientVisitID] BIGINT 
		, [ClinicName] NVARCHAR(40) NOT NULL
		, [Name] NVARCHAR(500) NOT NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
	);
	
	IF @Desc = 'Visits'
	BEGIN
		SELECT @StatusIDS = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Created'
	BEGIN
		SELECT @StatusIDS = '10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Hold'
	BEGIN
		SELECT @StatusIDS = '6, 7';
	END
	
	IF @Desc = 'Ready To Send'
	BEGIN
		SELECT @StatusIDS = '16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Sent'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @Desc = 'Accepted'
	BEGIN
		SELECT @StatusIDS = '29, 30';
	END
	
	IF @Desc = 'Rejected'
	BEGIN
		SELECT @StatusIDS = '26, 27';
	END
	
	IF @Desc = 'Re-Submitted'
	BEGIN
		SELECT @StatusIDS = '23, 24, 25, 26, 27, 28, 29, 30';
	END
	
	IF @DayCount = 'SEVEN'
	BEGIN
		SELECT @FromDiff = 1;
		SELECT @ToDiff = 7;
	END
	
	IF @DayCount = 'THIRTY'
	BEGIN
		SELECT @FromDiff = 8;
		SELECT @ToDiff = 30;
	END
		
	IF @Desc = 'Re-Submitted' 
	BEGIN
		 IF @DayCount = 'ONE'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'THIRTYPLUS'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE 
		 BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[PatientVisitID] IN
				(
					SELECT 
						[Claim].[ClaimProcess].[PatientVisitID] 
					FROM 
						[Claim].[ClaimProcess] 
					WHERE 
						[Claim].[ClaimProcess].[ClaimStatusID] IN (26, 27)
				)
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
---------
	ELSE
	BEGIN
		IF @DayCount = 'ONE'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) < 1
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
			
		ELSE IF @DayCount = 'THIRTYPLUS'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount = 'TOTAL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
		
		ELSE IF @DayCount <> 'ALL'
		BEGIN
			INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN @FromDiff AND @ToDiff
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
		END
	END
--------------
	IF @Desc = 'Visits' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
				[Patient].[PatientVisit].[ClaimStatusID] > 0
			AND 
				[Patient].[Patient].[ClinicID]  = @ClinicID
			AND
				[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	ELSE IF @Desc = 'Blocked' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
			[Patient].[Patient].[ClinicID]  = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 0;
	END
	
	ELSE IF @Desc = 'NIT' AND @DayCount = 'ALL'
	BEGIN
		INSERT INTO
				@SEARCH_TMP
				(
					[PatientVisitID]
					, [ClinicName]
					, [Name]
					, [ChartNumber]
					, [DOS]
					, [PatientVisitComplexity]
				)
			SELECT 
				[Patient].[PatientVisit].[PatientVisitID]
				, [Billing].[Clinic].[ClinicName]
				, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
				, [Patient].[Patient].[ChartNumber]
				, [Patient].[PatientVisit].[DOS]
				, [Patient].[PatientVisit].[PatientVisitComplexity]
			FROM
				[Patient].[PatientVisit] WITH (NOLOCK)
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			INNER JOIN
				[Billing].[Clinic]  WITH (NOLOCK)
			ON
				[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
			WHERE
			[Patient].[PatientVisit].[ClaimStatusID] IN (3, 5, 8, 12, 14, 18, 20, 24, 27)
		AND
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[PatientVisit].[IsActive] = 1;
	END
	
	SELECT * FROM @SEARCH_TMP;
	
	-- EXEC [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]  @ClinicID = 17,  @Desc = 'NIT', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END






GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 08/28/2013 10:24:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 08/28/2013 10:24:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
	@ClinicID	INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @DOSFrom DATE = NULL
	, @DOSTo DATE = NULL
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
		SELECT @DateFrom = CAST(MIN([EDI].[EDIFile].[CreatedOn]) AS DATE) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = CAST(MAX([EDI].[EDIFile].[CreatedOn]) AS DATE) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END	
	IF @DOSFrom IS NULL
	BEGIN
		SELECT @DOSFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
	END
	
	IF @DOSTo IS NULL
	BEGIN
		SELECT @DOSTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit] WITH (NOLOCK);
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
		[EDI].[EDIFile].[EDIFileID]
		, ROW_NUMBER() OVER (
			ORDER BY			
				CASE WHEN @OrderByField = 'EDIFileID' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[EDIFileID] END ASC,
				CASE WHEN @orderByField = 'EDIFileID' AND @orderByDirection = 'D' THEN [EDI].[EDIFile].[EDIFileID] END DESC,

				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[CreatedOn] END ASC,
				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIFile].[CreatedOn] END DESC,		

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIFile].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIFile].[LastModifiedOn] END DESC
			) AS ROW_NUM
	FROM
		[EDI].[EDIFile]	 WITH (NOLOCK)
	WHERE
		DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateFrom) <= 0 AND DATEDIFF(DAY, [EDI].[EDIFile].[CreatedOn], @DateTo) >= 0
	AND
		[EDI].[EDIFile].[EDIFileID] IN
		(
			SELECT
				[Claim].[ClaimProcessEDIFile].[EDIFileID]
			FROM
				[Claim].[ClaimProcessEDIFile] WITH (NOLOCK)
			INNER JOIN
				[Claim].[ClaimProcess] WITH (NOLOCK)
			ON
				[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
			INNER JOIN
				[Patient].[PatientVisit] WITH (NOLOCK)
			ON
				[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimProcess].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient] WITH (NOLOCK)
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[PatientVisit].[DOS] BETWEEN @DOSFrom AND @DOSTo	
			AND
				(
					[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
				OR
					((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
				OR
					[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1	
		)
	AND
		[EDI].[EDIFile].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIFile].[IsActive] ELSE @IsActive END;
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;	
	
	SELECT		
		[EDIFile].[EDIFileID]
		,[EDIFile].[X12FileRelPath]
		,[EDIFile].[RefFileRelPath]
		,[EDIFile].[CreatedOn]		
	FROM
		[EDIFile] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EDI].[EDIFile].[EDIFileID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;	
	
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @DateFrom 
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @ClinicID = 17,@SearchName = '',@IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 10, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END










GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 08/28/2013 10:33:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetAnsi837Visit_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 08/28/2013 10:33:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
	@ClinicID INT
	, @EDIReceiverID INT
	, @StatusIDs NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, [Patient].[PatientVisit].[PatientID]
		, [Patient].[PatientVisit].[PatientHospitalizationID]
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[IllnessIndicatorID]
		, [Patient].[PatientVisit].[IllnessIndicatorDate]
		, [Patient].[PatientVisit].[FacilityTypeID]
		, [Billing].[FacilityType].[FacilityTypeCode]
		, [Patient].[PatientVisit].[FacilityDoneID]
		, [Patient].[PatientVisit].[PrimaryClaimDiagnosisID]
		, [Patient].[PatientVisit].[DoctorNoteRelPath]
		, [Patient].[PatientVisit].[SuperBillRelPath]
		, [Patient].[PatientVisit].[PatientVisitDesc]
		, [Patient].[PatientVisit].[ClaimStatusID]
		, [Patient].[PatientVisit].[AssignedTo]
		, [Patient].[PatientVisit].[TargetBAUserID]
		, [Patient].[PatientVisit].[TargetQAUserID]
		, [Patient].[PatientVisit].[TargetEAUserID]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, [Patient].[PatientVisit].[Comment]
		, [Patient].[PatientVisit].[IsActive]
		, [Patient].[PatientVisit].[LastModifiedBy]
		, [Patient].[PatientVisit].[LastModifiedOn]
		--
		, [Patient].[Patient].[GroupNumber]
		, [Patient].[Patient].[LastName] AS [PATIENT_LAST_NAME]
		, [Patient].[Patient].[MiddleName] AS [PATIENT_MIDDLE_NAME]
		, [Patient].[Patient].[FirstName] AS [PATIENT_FIRST_NAME]
		, [Patient].[Patient].[StreetName] AS [PATIENT_STREET_NAME]
		, [Patient].[Patient].[Suite] AS [PATIENT_SUITE]
		, [Patient].[Patient].[DOB]
		, [Patient].[Patient].[Sex]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[Patient].[PolicyNumber]
		, [Patient].[Patient].[CityID] AS [PATIENT_CITY_ID]
		, [PATIENT_CITY].[CityName] AS [PATIENT_CITY_NAME]
		, [PATIENT_CITY].[ZipCode] AS [PATIENT_CITY_ZIP_CODE]
		, [Patient].[Patient].[StateID] AS [PATIENT_STATE_ID]
		, [PATIENT_STATE].[StateCode] AS [PATIENT_STATE_CODE]
		, [Patient].[Patient].[CountryID] AS [PATIENT_COUNTRY_ID]
		, [PATIENT_COUNTRY].[CountryCode] AS [PATIENT_COUNTRY_CODE]
		, [Patient].[Patient].[MedicareID]
		--
		, [EDI].[PrintPin].[PrintPinCode]
		--
		, [Billing].[Provider].[LastName] AS [PROVIDER_LAST_NAME]
		, [Billing].[Provider].[MiddleName] AS [PROVIDER_MIDDLE_NAME]
		, [Billing].[Provider].[FirstName] AS [PROVIDER_FIRST_NAME]
		, ((LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], ''))))) AS [PROVIDER_NAME]
		, (CASE WHEN 
				[Billing].[Provider].[IsTaxIDPrimaryOption] = 1 THEN 
				(ISNULL([Billing].[Provider].[TaxID], (ISNULL([Billing].[Provider].[NPI], 'NO_TAX_NPI')))) ELSE 
				(ISNULL([Billing].[Provider].[NPI], (ISNULL([Billing].[Provider].[TaxID], 'NO_NPI_TAX')))) END) 
			AS [PROVIDER_TAX_NPI]
		--
		, [Billing].[Credential].[CredentialCode] AS [PROVIDER_CREDENTIAL_CODE]
		--
		, [Billing].[Specialty].[SpecialtyCode]		
		--
		, [Insurance].[Insurance].[InsuranceName]
		, [Insurance].[Insurance].[PayerID]
		, [Insurance].[Insurance].[CityID] AS [INSURANCE_CITY_ID]
		, [INSURANCE_CITY].[CityName] AS [INSURANCE_CITY_NAME]
		, [INSURANCE_CITY].[ZipCode] AS [INSURANCE_CITY_ZIP_CODE]
		, [Insurance].[Insurance].[StateID] AS [INSURANCE_STATE_ID]
		, [INSURANCE_STATE].[StateCode] AS [INSURANCE_STATE_CODE]
		, [Insurance].[Insurance].[CountryID] AS [INSURANCE_COUNTRY_ID]
		, [INSURANCE_COUNTRY].[CountryCode] AS [INSURANCE_COUNTRY_CODE]
		, [Insurance].[Insurance].[PatientPrintSignID]
		, [Insurance].[Insurance].[StreetName] AS [INSURANCE_STREET_NAME]
		, [Insurance].[Insurance].[Suite] AS [INSURANCE_SUITE]
		--
		, [Insurance].[Relationship].[RelationshipCode]
		--
		, [Insurance].[InsuranceType].[InsuranceTypeCode]
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator] WITH (NOLOCK)
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType] WITH (NOLOCK)
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider] WITH (NOLOCK)
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance] WITH (NOLOCK)
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship] WITH (NOLOCK)
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential] WITH (NOLOCK)
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty] WITH (NOLOCK)
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType] WITH (NOLOCK)
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin] WITH (NOLOCK)
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY WITH (NOLOCK)
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE WITH (NOLOCK)
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY WITH (NOLOCK)
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY WITH (NOLOCK)
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE WITH (NOLOCK)
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY WITH (NOLOCK)
	ON
		[INSURANCE_COUNTRY].[CountryID] = [Insurance].[Insurance].[CountryID]
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Insurance].[Insurance].[EDIReceiverID] = @EDIReceiverID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] IN
		(
			SELECT 
				[Data] 
			FROM 
				[dbo].[ufn_StringSplit] (@StatusIDs, ',')
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	ORDER BY
		[Insurance].[Insurance].[InsuranceName]
	ASC,
		[PROVIDER_NAME]
	ASC,
		[Patient].[PatientVisit].[PatientVisitID]
	ASC;
    
    -- EXEC [Claim].[usp_GetAnsi837Visit_ClaimProcess] @ClinicID = 1, @EDIReceiverID = 1, @StatusIDs = '16, 17, 18, 19, 20'
END










GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetAutoComplete_Patient]    Script Date: 08/28/2013 12:08:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAutoComplete_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAutoComplete_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAutoComplete_Patient]    Script Date: 08/28/2013 12:08:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Select all records from the table

CREATE PROCEDURE [Patient].[usp_GetAutoComplete_Patient] 
	@ClinicID int
	, @stats	NVARCHAR (150) = NULL
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(500) NOT NULL);
	
	IF @stats IS NULL
	BEGIN
		SELECT @stats = '';
	END
	ELSE
	BEGIN
		SELECT @stats = LTRIM(RTRIM(@stats));
	END
	
	IF LEN(@stats) = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT TOP 50 
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
		FROM
			[Patient].[Patient] WITH (NOLOCK)
		WHERE
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
	END
	ELSE
	BEGIN
		SELECT @stats = REPLACE(@stats, '[', '\[');
		SELECT @stats = @stats + '%';
		
		INSERT INTO
			@TBL_ANS
		SELECT TOP 10 	
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
		FROM
			[Patient].[Patient] WITH (NOLOCK)
		WHERE
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE @stats ESCAPE '\'
		AND
			[Patient].[Patient].[ClinicID] = @ClinicID
		AND
			[Patient].[Patient].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT TOP 10 
				((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
			FROM
				[Patient].[Patient] WITH (NOLOCK)
			WHERE
				[Patient].[Patient].[ChartNumber] LIKE @stats ESCAPE '\'
			AND
				[Patient].[Patient].[ClinicID] = @ClinicID
			AND
				[Patient].[Patient].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		
			IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
			BEGIN
				INSERT INTO
					@TBL_ANS
				SELECT TOP 10 
					((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
				FROM
					[Patient].[Patient] WITH (NOLOCK)
				WHERE
					CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) LIKE @stats ESCAPE '\'
				AND
					[Patient].[Patient].[ClinicID] = @ClinicID
				AND
					[Patient].[Patient].[IsActive] = 1
				ORDER BY 
					[NAME_CODE] 
				ASC;
				
				IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
				BEGIN
					SELECT @stats = '%' + @stats;
					
					INSERT INTO
						@TBL_ANS
					SELECT TOP 10 		
						((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') AS [NAME_CODE]
					FROM
						[Patient].[Patient] WITH (NOLOCK)
					WHERE
						((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], ' ')))) + ' - ' + CONVERT(NVARCHAR, [Patient].[Patient].[DOB], 101) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE @stats ESCAPE '\'
					AND
						[Patient].[Patient].[ClinicID] = @ClinicID
					AND
						[Patient].[Patient].[IsActive] = 1
					ORDER BY 
						[NAME_CODE] 
					ASC;
				END
			END
		END
	END
		
	SELECT * FROM @TBL_ANS;	
	-- EXEC [Patient].[usp_GetAutoComplete_Patient] @ClinicID = '2', @stats = 'XAVC'
	-- EXEC [Patient].[usp_GetAutoComplete_Patient] @ClinicID = '2', @stats = ' '
END

GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetIDAutoComplete_Patient]    Script Date: 08/28/2013 12:08:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetIDAutoComplete_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetIDAutoComplete_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetIDAutoComplete_Patient]    Script Date: 08/28/2013 12:08:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Patient].[usp_GetIDAutoComplete_Patient] 

	@ChartNumber nvarchar(20)
	, @ClinicID INT
	, @IsActive	BIT = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [PatientID] INT NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[Patient].[PatientID]
	FROM
		[Patient].[Patient] WITH (NOLOCK)
	WHERE
		@ChartNumber = [Patient].[Patient].[ChartNumber]
	AND
		@ClinicID = [Patient].[Patient].[ClinicID]
	AND
		[Patient].[Patient].[IsActive]=1
	
	SELECT * FROM @TBL_RES;
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] coo1, 1
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] 1, 1
	-- EXEC [Patient].[usp_GetIDAutoComplete_Patient] 1, 0
END

GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Claim].[usp_GetByAZCaseReopen_ClaimProcess]    Script Date: 08/28/2013 10:51:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByAZCaseReopen_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByAZCaseReopen_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetByAZCaseReopen_ClaimProcess]    Script Date: 08/28/2013 10:51:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Claim].[usp_GetByAZCaseReopen_ClaimProcess] 
	 @ClinicID INT
	, @AssignedTo INT = NULL
	, @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
		ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	INNER JOIN
	    [Claim].[ClaimProcess]
	ON
	    [Claim].[ClaimProcess].[PatientVisitID] = [Patient].[PatientVisit].[PatientVisitID]
	WHERE
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		OR
			[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND	
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[ClaimProcess].[ClaimStatusID] > 25 --If anything happens we need to change this to 21
	--AND
	--  	[ClaimProcess].[ClaimStatusID] < 30 
	AND
		CAST([Patient].[PatientVisit].[ClaimStatusID] as INT) !=30
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		(
			[Patient].[PatientVisit].[AssignedTo] = @AssignedTo 
		OR
			@AssignedTo IS NULL
		)
	AND
		[Patient].[PatientVisit].[IsActive] = 1;

		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Claim].[usp_GetByAZ_ClaimProcess] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25', @SearchName = ''	-- CREATED
	
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearchCase_PatientVisit]    Script Date: 08/29/2013 09:59:22 ******/
DROP PROCEDURE [Patient].[usp_GetBySearchCase_PatientVisit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Patient].[usp_GetBySearchCase_PatientVisit]
	  @UserID INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
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
		SELECT @DateFrom = MIN([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientVisit].[DOS]) FROM [Patient].[PatientVisit];
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
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN [Patient].[Patient].[LastName] END DESC,
							
				CASE WHEN @OrderByField = 'PatChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'PatChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'DOS' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[DOS] END ASC,
				CASE WHEN @orderByField = 'DOS' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[DOS] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitID' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitID' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,
				
				CASE WHEN @OrderByField = 'PatientVisitComplexity' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[PatientVisitID] END ASC,
				CASE WHEN @orderByField = 'PatientVisitComplexity' AND @orderByDirection = 'D' THEN [Patient].[PatientVisit].[PatientVisitID] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientVisit].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientVisit].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
			[Patient].[PatientVisit] WITH (NOLOCK)
		INNER JOIN
			[Patient].[Patient] WITH (NOLOCK)
		ON
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		WHERE
			(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
		AND
			(
				[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
			OR
				[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
			)
		AND
			[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		    
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [PatChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [PatientVisitComplexity] TINYINT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[Patient].[ChartNumber] AS [PatChartNumber] 
		, [Patient].[PatientVisit].[DOS]
		, [Patient].[PatientVisit].[PatientVisitComplexity]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		@SEARCH_TMP
	INNER JOIN
		[Patient].[PatientVisit] WITH (NOLOCK)
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 48, @StartBy = 'A', @RecordsPerPage = 3000
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1, @SearchName= '20573'
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1
END
GO

-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 08/28/2013 10:57:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZCase_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZCase_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 08/28/2013 10:57:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetByAZCase_PatientVisit] 
	 @UserID INT
	, @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		SELECT @DateFrom = MIN([DOS]) FROM [Patient].[PatientVisit];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([DOS]) FROM [Patient].[PatientVisit];
	END
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](350) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
    
    INSERT INTO
		@TBL_ALL
	
	SELECT
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientID]=[PatientVisit].[PatientID]
	WHERE
			[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		 AND
			(
				[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
			OR
				[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
			)
		
	DECLARE @AZ_TMP VARCHAR(26);
	SELECT @AZ_TMP = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE @AZ_LOOP INT;
	SELECT 	@AZ_LOOP = 1;
	DECLARE @AZ_CNT INT;
	SELECT @AZ_CNT = LEN(@AZ_TMP);
	DECLARE @AZ_CHR VARCHAR(1);
	SELECT @AZ_CHR = '';
	
	WHILE @AZ_LOOP <= @AZ_CNT
	BEGIN
		SELECT @AZ_CHR = SUBSTRING(@AZ_TMP, @AZ_LOOP, 1);
		
		INSERT INTO
			@TBL_AZ
		SELECT
			@AZ_CHR	AS [AZ]
			, COUNT(*) AS [AZ_COUNT]
		FROM
			@TBL_ALL
		WHERE
			[ChartNumber] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	--EXEC [Patient].[usp_GetByAZCase_PatientVisit]  @UserID = 48
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetXmlNameByID_User]    Script Date: 08/28/2013 14:29:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetXmlNameByID_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetXmlNameByID_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetXmlNameByID_User]    Script Date: 08/28/2013 14:29:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Select the particular record

CREATE PROCEDURE [User].[usp_GetXmlNameByID_User] 
	@UserID	BIGINT
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @TBL_RES TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [NAME_CODE] NVARCHAR(500) NOT NULL
		, [EMAIL] NVARCHAR(500) NOT NULL
	);

	INSERT INTO
		@TBL_RES
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		,[User].[User].[Email] as [EMAIL]
	FROM
		[User].[User] WITH (NOLOCK)
	WHERE
		[User].[User].[UserID] = @UserID
	AND
		[User].[User].[IsActive] = 1;
	
	SELECT * FROM @TBL_RES AS USR FOR XML AUTO, ROOT('USRS');

	-- EXEC [User].[usp_GetXmlNameByID_User] 1
	
END

GO



-----------------------------------------------------------------------------------


/****** Object:  StoredProcedure [Billing].[usp_GetXmlClinicID_Clinic]    Script Date: 08/29/2013 16:42:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetXmlClinicID_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetXmlClinicID_Clinic]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetXmlClinicID_Clinic]    Script Date: 08/29/2013 16:42:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting Clinic of the corressponding user

CREATE  PROCEDURE [Billing].[usp_GetXmlClinicID_Clinic]
@ClinicID INT
AS
BEGIN
	SELECT DISTINCT
	     [BC].[ClinicName]
	     
		FROM
				
			[Billing].[Clinic] BC WITH (NOLOCK)
						
			
		WHERE
			 [BC].[ClinicID] = @ClinicID
		AND
			[BC].[IsActive] = 1
			
		FOR XML AUTO, ROOT('BCS');	
	
	-- EXEC [Billing].[usp_GetXmlClinicID_Clinic] 1
END





GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetXmlProviderID_Provider]    Script Date: 08/28/2013 16:43:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetXmlProviderID_Provider]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetXmlProviderID_Provider]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetXmlProviderID_Provider]    Script Date: 08/28/2013 16:43:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting provider from a Clinic

CREATE PROCEDURE [Billing].[usp_GetXmlProviderID_Provider]
@ProviderID INT
AS
BEGIN
	SELECT 
	     [PR].[ProviderID]
	    ,((LTRIM(RTRIM([PR].[LastName] + ' ' + [PR].[FirstName] + ' ' + ISNULL([PR].[MiddleName], ''))))) as [NAME] 
		FROM
			[Billing].[Provider] [PR] WITH (NOLOCK)
		
		WHERE
			 [PR].[ProviderID] = @ProviderID
		AND
			[PR].[IsActive] = 1
			
		FOR XML AUTO, ROOT('PROVIDER');	
	
	-- EXEC [Billing].[usp_GetXmlProvider_Provider] 1
END




GO



-----------------------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetXmlPatientID_Patient]    Script Date: 08/28/2013 16:43:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetXmlPatientID_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetXmlPatientID_Patient]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetXmlPatientID_Patient]    Script Date: 08/28/2013 16:43:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--Created By Sai for getting patient from a Clinic

CREATE PROCEDURE [Patient].[usp_GetXmlPatientID_Patient]
@PatientID INT
AS
BEGIN
	SELECT 
	     [PA].[PatientID]
	    ,((LTRIM(RTRIM([PA].[LastName] + ' ' + [PA].[FirstName] + ' ' + ISNULL([PA].[MiddleName], ''))))) as [NAME]  
		FROM
			[Patient].[Patient] [PA] WITH (NOLOCK)
		
		WHERE
			 [PA].[PatientID] = @PatientID
		AND
			[PA].[IsActive] = 1
			
		FOR XML AUTO, ROOT('PATIENT');	
	
	-- EXEC [Patient].[usp_GetXmlPatient_Patient] 1
END


GO



-----------------------------------------------------------------------------------
