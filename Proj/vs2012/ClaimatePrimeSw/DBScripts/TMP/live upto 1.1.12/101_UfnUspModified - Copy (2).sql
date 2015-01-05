----------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetAutocompleteClinicNew_User]    Script Date: 07/11/2013 11:38:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetAutocompleteClinicNew_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetAutocompleteClinicNew_User]
GO



/****** Object:  StoredProcedure [User].[usp_GetAutocompleteClinicNew_User]    Script Date: 07/11/2013 11:38:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- Select all records from the table
--Created by sai for displaying manager names in clinic set up page
CREATE PROCEDURE [User].[usp_GetAutocompleteClinicNew_User] 
	@stats	NVARCHAR (150) = NULL
	, @ManagerRoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @TBL_ANS TABLE ([ID] INT NOT NULL IDENTITY (1, 1), [NAME_CODE] NVARCHAR(165) NOT NULL);
	
	IF @stats IS NULL
	BEGIN
		SELECT @stats = '';
	END
	ELSE
	BEGIN
		SELECT @stats = LTRIM(RTRIM(@stats));
	END
	
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
	
	IF LEN(@stats) = 0
	BEGIN
		INSERT INTO
			@TBL_ANS
		SELECT
			([User].[User].[LastName] +[User].[User].[FirstName] + ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		FROM
			[User].[User]
		WHERE
			
			[User].[User].[UserID] IN
			(
				SELECT 
					[USER_ID]
				FROM 
					@USER_TMP
			)
		AND
			[User].[User].[IsActive] = 1
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
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
		FROM
			[User].[User]
		WHERE
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') LIKE @stats ESCAPE '\'		
		
		AND
			[User].[User].[UserID] IN
			(
				SELECT 
					[USER_ID]
				FROM 
					@USER_TMP
			)
		AND
			[User].[User].[IsActive] = 1
		ORDER BY 
			[NAME_CODE] 
		ASC;
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			INSERT INTO
				@TBL_ANS
			SELECT  TOP 10
			([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
			FROM
				[User].[User]
			WHERE
				[User].[User].[UserName] LIKE @stats ESCAPE '\'
			
			AND
				[User].[User].[UserID] IN
				(
					SELECT 
						[USER_ID]
					FROM 
						@USER_TMP
				)
			AND
				[User].[User].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
		
		IF NOT EXISTS (SELECT [ID] FROM @TBL_ANS)
		BEGIN
			SELECT @stats = '%' + @stats;
			
			INSERT INTO
				@TBL_ANS
			SELECT 	TOP 10
				([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') AS [NAME_CODE]
			FROM
				[User].[User]
			WHERE
				([User].[User].[LastName] +[User].[User].[FirstName]+ ' [' +[User].[User].[UserName] + ']') LIKE @stats ESCAPE '\'
			
			AND
				[User].[User].[UserID] IN
				(
					SELECT 
						[USER_ID]
					FROM 
						@USER_TMP
				)
			AND
				[User].[User].[IsActive] = 1
			ORDER BY 
				[NAME_CODE] 
			ASC;
		END
	END
		
	SELECT * FROM @TBL_ANS;	
	
	-- EXEC [User].[usp_GetAutoComplete_User] @stats = 'R', @ManagerRoleID = 2
	-- EXEC [User].[usp_GetAutoComplete_User] @stats = '', @ManagerRoleID = 2
END



GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetUnAssigned_PatientVisit]    Script Date: 07/15/2013 15:59:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetUnAssigned_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetUnAssigned_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetUnAssigned_PatientVisit]    Script Date: 07/15/2013 15:59:08 ******/
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
		[Patient].[PatientVisit].[PatientID]=[Patient].[Patient].[PatientID]	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetIDAutoComplete_Patient]    Script Date: 07/11/2013 14:49:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetIDAutoComplete_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetIDAutoComplete_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetIDAutoComplete_Patient]    Script Date: 07/11/2013 14:49:55 ******/
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_Patient]    Script Date: 07/18/2013 11:25:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_Patient]    Script Date: 07/18/2013 11:25:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetBySearch_Patient]
	@ClinicID INT
	, @SearchName NVARCHAR(150) = NULL
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
		[Patient].[Patient].[PatientID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
				
				CASE WHEN @OrderByField = 'MedicareID' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[MedicareID] END ASC,
				CASE WHEN @orderByField = 'MedicareID' AND @orderByDirection = 'D' THEN [Patient].[Patient].[MedicareID] END DESC,
				
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[Patient].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[Patient] WITH (NOLOCK)
	WHERE
	
	(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[PatientID]
		, [Patient].[ChartNumber]
		, [Patient].[MedicareID]
		, [Patient].[IsActive] 
	FROM
		[Patient] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Patient].[PatientID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Patient].[usp_GetBySearch_Patient] @ClinicID=2
	-- EXEC [Patient].[usp_GetBySearch_Patient] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientVisit]    Script Date: 07/11/2013 16:11:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZ_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientVisit]    Script Date: 07/11/2013 16:11:03 ******/
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
	, @IsActive	BIT = NULL
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
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
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



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientHospitalization]    Script Date: 07/18/2013 11:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientHospitalization]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientHospitalization]    Script Date: 07/18/2013 11:25:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetBySearch_PatientHospitalization]
     @ClinicTypeID	TINYINT
    , @ClinicID	INT  
	, @ChartNumber NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @PatientID BIGINT = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @ChartNumber IS NULL
	BEGIN
		SET @ChartNumber = '';
	END
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([Patient].[PatientHospitalization].[AdmittedOn]) FROM [Patient].[PatientHospitalization];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientHospitalization].[AdmittedOn]) FROM [Patient].[PatientHospitalization];
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
		[Patient].[PatientHospitalization].[PatientHospitalizationID]
		, ROW_NUMBER() OVER (
			ORDER BY
			
			CASE WHEN @OrderByField = 'Name ' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,						
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
								
				CASE WHEN @OrderByField = 'FacilityDoneName' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneName] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneName' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneName] END DESC,
				
				CASE WHEN @OrderByField = 'AdmittedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[AdmittedOn] END ASC,
				CASE WHEN @orderByField = 'AdmittedOn' AND @orderByDirection = 'D' THEN [Patient].[PatientHospitalization].[AdmittedOn] END DESC,				
				
				CASE WHEN @OrderByField = 'DischargedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[DischargedOn] END ASC,
				CASE WHEN @orderByField = 'DischargedOn' AND @orderByDirection = 'D' THEN [Patient].[PatientHospitalization].[DischargedOn] END DESC,

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Patient].[PatientHospitalization].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Patient].[PatientHospitalization].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Patient].[PatientHospitalization] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[FacilityDone] WITH (NOLOCK)
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
	INNER JOIN
		[Billing].[Clinic] WITH (NOLOCK)
	ON 
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @ChartNumber + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @ChartNumber + '%' 
		)
    AND
		[Patient].[PatientHospitalization].[AdmittedOn] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [Patient].[Patient].[PatientID] ELSE @PatientID END
	AND
		[Billing].[FacilityDone].[FacilityTypeID] = @ClinicTypeID
	AND
		[Billing].[Clinic].[ClinicID] = @ClinicID	
	AND
		[Patient].[PatientHospitalization].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientHospitalization].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	AND
		[Billing].[FacilityDone].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityDone].[IsActive] ELSE @IsActive END;
	
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Patient].[PatientHospitalization].[PatientHospitalizationID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [Name]
		, [Patient].[PatientHospitalization].[AdmittedOn]
		, [Patient].[PatientHospitalization].[DischargedOn]
		, [Billing].[FacilityDone].[FacilityDoneName]
		, [Patient].[Patient].[ChartNumber]
		, [Patient].[PatientHospitalization].[IsActive]
	FROM
		[Patient].[PatientHospitalization] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] =[Patient].[PatientHospitalization].[PatientHospitalizationID]
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[FacilityDone] WITH (NOLOCK)
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	-- EXEC [Patient].[usp_GetBySearch_PatientHospitalization] @ClinicTypeID = 2
	-- EXEC [Patient].[usp_GetBySearch_PatientHospitalization] @ClinicTypeID = 2, @ChartNumber  = NULL, @StartBy = NULL, @PatientID = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END



GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientDocument]    Script Date: 07/18/2013 11:25:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_PatientDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientDocument]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientDocument]    Script Date: 07/18/2013 11:25:27 ******/
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
								
				CASE WHEN @OrderByField = 'DocumentCategoryName' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryName' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END DESC,
								

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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetBySearch_ClaimProcess]    Script Date: 07/11/2013 16:19:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetBySearch_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetBySearch_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetBySearch_ClaimProcess]    Script Date: 07/11/2013 16:19:44 ******/
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientDocument]    Script Date: 07/11/2013 16:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZ_PatientDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientDocument]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientDocument]    Script Date: 07/11/2013 16:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetByAZ_PatientDocument] 
	 @SearchName NVARCHAR(350) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @IsActive	BIT = NULL	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
    
    DECLARE @TBL_ALL TABLE
    (
		[ChartNumber] [nvarchar](40) NULL
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
		[Patient].[PatientDocument] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[PatientDocument].[PatientID] = [Patient].[Patient].[PatientID]
	WHERE
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
	
	-- EXEC [Patient].[usp_GetByAZ_PatientDocument] @PatientID = 8, @ChartNumber = NULL, @IsActive = NULL
	-- EXEC [Patient].[usp_GetByAZ_Patient] @ClinicID = 2, @ChartNumber = 'iy', @IsActive = NULL
END



GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientHospitalization]    Script Date: 07/11/2013 16:36:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZ_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZ_PatientHospitalization]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZ_PatientHospitalization]    Script Date: 07/11/2013 16:36:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetByAZ_PatientHospitalization] 
	 @ClinicTypeID INT
	 ,@ClinicID INT
	 , @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @IsActive	BIT = NULL
	,@ChartNumber nvarchar(350) = NULL
	, @PatientID BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    IF @ChartNumber IS NULL
    BEGIN
		SELECT @ChartNumber = '';
	END
		IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = MIN([Patient].[PatientHospitalization].[AdmittedOn]) FROM [Patient].[PatientHospitalization];
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([Patient].[PatientHospitalization].[AdmittedOn]) FROM [Patient].[PatientHospitalization];
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
		[Patient].[PatientHospitalization] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON 
		[Patient].[Patient].[PatientID] = [Patient].[PatientHospitalization].[PatientID]
	INNER JOIN
		[Billing].[Clinic] WITH (NOLOCK)
	ON 
		[Billing].[Clinic].[ClinicID] = [Patient].[Patient].[ClinicID]	
	INNER JOIN
		[Billing].[FacilityDone] WITH (NOLOCK)
	ON 
		[Billing].[FacilityDone].[FacilityDoneID] = [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
	WHERE
		[Billing].[FacilityDone].[FacilityTypeID] = @ClinicTypeID	
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @ChartNumber + '%' 
		OR
			((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @ChartNumber + '%' 
		)
	AND
		[Patient].[PatientHospitalization].[AdmittedOn] BETWEEN @DateFrom AND @DateTo	
	AND
		[Patient].[Patient].[PatientID] = CASE WHEN @PatientID IS NULL THEN [Patient].[Patient].[PatientID] ELSE @PatientID END
	AND
		[Billing].[FacilityDone].[FacilityTypeID] = @ClinicTypeID
AND
		[Billing].[Clinic].[ClinicID] = @ClinicID	
	AND
		[Patient].[PatientHospitalization].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientHospitalization].[IsActive] ELSE @IsActive END
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END;
				
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
	
	-- EXEC [Patient].[usp_GetByAZ_PatientHospitalization]  @ClinicTypeID= 2
END



GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetByAZ_ClaimProcess]    Script Date: 07/11/2013 16:41:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByAZ_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByAZ_ClaimProcess]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetByAZ_ClaimProcess]    Script Date: 07/11/2013 16:41:58 ******/
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;

		
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 07/15/2013 10:27:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClaimAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClaimAgent_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetClaimAgent_PatientVisit]    Script Date: 07/15/2013 10:27:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







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
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON 
		[Patient].[PatientVisit].[PatientID] = [Patient].[Patient].[PatientID]
		
		
	WHERE
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
		(
			[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
		--OR
		--	((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] ))) + ' [' +[Patient].[Patient].[ChartNumber] + ']') LIKE '%' + @SearchName + '%' 
		)
	AND
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[PatientVisit].[ClaimStatusID] < 22	
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[Patient]
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
	 
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @ClinicID = '1',@SearchName = 'DIXID000',@DateFrom = '07/06/2013',@DateTo = '07/09/2013'
	-- EXEC [Patient].[usp_GetClaimAgent_PatientVisit] @SearchName  = 'DIXID000', @StartBy = 'c', @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D',@ClinicID=2
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 07/18/2013 11:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
GO

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 07/18/2013 11:19:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
	@ClinicID	INT
	, @SearchName NVARCHAR(150) = NULL
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
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
		CAST([EDI].[EDIFile].[CreatedOn] AS DATE) BETWEEN @DateFrom AND @DateTo
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
				(
					[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
				OR
					((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE '%' + @SearchName + '%' 
				OR
					[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
				)
			AND
				[Patient].[PatientVisit].[IsActive] = 1	
			AND
				[Patient].[Patient].[IsActive] = 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1	
			AND
				[Claim].[ClaimProcessEDIFile].[IsActive] = 1
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 07/18/2013 10:25:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetSentFile_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetSentFile_EDIFile]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetSentFile_EDIFile]    Script Date: 07/18/2013 10:25:43 ******/
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
		SELECT @DateFrom = MIN([EDI].[EDIFile].[CreatedOn]) FROM [EDI].[EDIFile] WITH (NOLOCK);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = MAX([EDI].[EDIFile].[CreatedOn]) FROM [EDI].[EDIFile] WITH (NOLOCK);
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
		[EDIFile].[EDIFileID]	
		, ROW_NUMBER() OVER (
			ORDER BY

				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'A' THEN [EDIFile].[CreatedOn] END ASC,
				CASE WHEN @OrderByField = 'CreatedOn' AND @OrderByDirection = 'D' THEN [EDIFile].[CreatedOn] END DESC,		

				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDIFile].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDIFile].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[EDIFile]	WITH (NOLOCK)
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
				[Patient].[PatientVisit].[ClaimStatusID] IN (SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ','))
			AND
				[Patient].[PatientVisit].[AssignedTo] = @UserID
			AND
				[Patient].[PatientVisit].[IsActive] = 1	
			AND
				[Patient].[Patient].[IsActive] = 1
			AND
				[Claim].[ClaimProcess].[IsActive] = 1	
			AND
				[Claim].[ClaimProcessEDIFile].[IsActive] = 1	
		)
	AND
		[EDI].[EDIFile].[IsActive] = 1
	ORDER BY
		[EDIFile].[LastModifiedOn]
	DESC;
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
		[EDI].[EDIFile] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EDI].[EDIFile].[EDIFileID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;		
			
	-- EXEC [EDI].[usp_GetSentFile_EDIFile] @ClinicID=20, @StatusIDs = '23,24', @UserID = 116, @SearchName = '11825' ,@DateFrom ='1900-01-01',@DateTo='2013-07-11'

END

GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]    Script Date: 07/18/2013 11:17:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetBySearchCaseReopen_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]
GO

/****** Object:  StoredProcedure [Claim].[usp_GetBySearchCaseReopen_ClaimProcess]    Script Date: 07/18/2013 11:17:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







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
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit]
	ON 
		[PK_ID] = [Patient].[PatientVisit].[PatientVisitID]
	INNER JOIN
		[Patient].[Patient]
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetByAZCaseReopen_ClaimProcess]    Script Date: 07/11/2013 16:50:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByAZCaseReopen_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByAZCaseReopen_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetByAZCaseReopen_ClaimProcess]    Script Date: 07/11/2013 16:50:31 ******/
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;

		
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



----------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetDate_Patient]    Script Date: 07/11/2013 16:52:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDate_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDate_Patient]
GO

----------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetDate_PatientVisit]    Script Date: 07/11/2013 16:52:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDate_PatientVisit]
GO
----------------------------------------------------------------------
/****** Object:  StoredProcedure [EDI].[usp_GetDate_EDIFile]    Script Date: 07/11/2013 16:57:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetDate_EDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetDate_EDIFile]
GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetDoneStatus_SyncStatus]    Script Date: 07/17/2013 20:51:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetDoneStatus_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetDoneStatus_SyncStatus]
GO


/****** Object:  StoredProcedure [Audit].[usp_GetDoneStatus_SyncStatus]    Script Date: 07/17/2013 20:51:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Audit].[usp_GetDoneStatus_SyncStatus] 

AS
BEGIN
	SET NOCOUNT ON;
		
	
	SELECT 
		TOP 1 [S].* 
		, (LTRIM(RTRIM([U].[LastName] + ' ' + [U].[FirstName] + ' ' + ISNULL ([U].[MiddleName], '')))) AS [DISP_NAME]
	FROM 
		[Audit].[SyncStatus] S WITH (NOLOCK)
	LEFT JOIN
		[User].[User] U WITH (NOLOCK)
	ON
		[S].[UserID] = [U].[UserID]
	ORDER BY 
		[S].[SyncStatusID] 
	DESC;
			
	-- EXEC [Audit].[usp_GetDoneStatus_SyncStatus] 
	-- EXEC [Audit].[usp_GetDoneStatus_SyncStatus] 
END





GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetAutoComplete_Patient]    Script Date: 07/12/2013 08:26:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAutoComplete_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAutoComplete_Patient]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetAutoComplete_Patient]    Script Date: 07/12/2013 08:26:54 ******/
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



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientVisit]    Script Date: 07/06/2013 14:13:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Insert_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Insert_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientVisit]    Script Date: 07/06/2013 14:13:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_PatientVisit]
	@ClinicID INT
	, @PatientID BIGINT
	, @DOS DATE
	, @Comment NVARCHAR(4000)
	, @CurrentModificationBy BIGINT
	, @PatientVisitID BIGINT OUTPUT
	, @FACILITY_TYPE_OFFICE_ID TINYINT
	, @FACILITY_TYPE_INPATIENT_HOSPITAL_ID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
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
			SELECT @PatientHospitalizationID = [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DOS BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[IsActive] = 1;
			
			DECLARE @IllnessIndicatorID TINYINT;
			DECLARE @IllnessIndicatorDate DATE;
			DECLARE @FacilityTypeID TINYINT;
			DECLARE @FacilityDoneID INT;
			DECLARE @PrimaryClaimDiagnosisID BIGINT;
			DECLARE @DoctorNoteRelPath NVARCHAR(350);
			DECLARE @SuperBillRelPath NVARCHAR(350);
			DECLARE @PatientVisitDesc NVARCHAR(150);
			DECLARE @ClaimStatusID TINYINT;
			DECLARE @AssignedTo INT;
			DECLARE @TargetBAUserID INT;
			DECLARE @TargetQAUserID INT;
			DECLARE @TargetEAUserID INT;
			DECLARE @PatientVisitComplexity TINYINT;
			
			IF @PatientHospitalizationID IS NOT NULL AND @PatientHospitalizationID > 0
				BEGIN 
					SELECT @FacilityTypeID = @FACILITY_TYPE_INPATIENT_HOSPITAL_ID
				END
			ELSE 
				BEGIN
					SELECT @FacilityTypeID = @FACILITY_TYPE_OFFICE_ID;
				END	
			SELECT TOP 1 @IllnessIndicatorID = [Diagnosis].[IllnessIndicator].[IllnessIndicatorID] FROM [Diagnosis].[IllnessIndicator] WHERE [Diagnosis].[IllnessIndicator].[IsActive] = 1 ORDER BY [IllnessIndicator].[IllnessIndicatorID] ASC;
			SELECT @PatientVisitComplexity = [Billing].[Clinic].[PatientVisitComplexity] FROM [Billing].[Clinic] WHERE [Billing].[Clinic].[ClinicID] = @ClinicID AND [Billing].[Clinic].[IsActive] = 1
			
			-- HARD CODED
			SELECT @IllnessIndicatorDate = @DOS;
			SELECT @FacilityDoneID = NULL;
			SELECT @PrimaryClaimDiagnosisID = NULL;
			SELECT @DoctorNoteRelPath = NULL;
			SELECT @SuperBillRelPath = NULL;
			SELECT @PatientVisitDesc = NULL;
			SELECT @ClaimStatusID = 1;
			SELECT @AssignedTo = NULL;
			SELECT @TargetBAUserID = NULL;
			SELECT @TargetQAUserID = NULL;
			SELECT @TargetEAUserID = NULL;
			
			SELECT @PatientVisitID = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @ClaimStatusID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @Comment, 0);
			
			IF @PatientVisitID = 0
			BEGIN
				INSERT INTO [Patient].[PatientVisit]
				(
					[PatientID]
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
				VALUES
				(
					@PatientID
					, @PatientHospitalizationID
					, @DOS
					, @IllnessIndicatorID
					, @IllnessIndicatorDate
					, @FacilityTypeID
					, @FacilityDoneID
					, @PrimaryClaimDiagnosisID
					, @DoctorNoteRelPath
					, @SuperBillRelPath
					, @PatientVisitDesc
					, @ClaimStatusID
					, @AssignedTo
					, @TargetBAUserID
					, @TargetQAUserID
					, @TargetEAUserID
					, @PatientVisitComplexity
					, @Comment
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @CurrentModificationBy
					, @CurrentModificationOn
					, 1
				);
				
				SELECT @PatientVisitID = MAX([Patient].[PatientVisit].[PatientVisitID]) FROM [Patient].[PatientVisit];
			END
			ELSE
			BEGIN			
				SELECT @PatientVisitID = -1;
			END
		END	
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientHospitalization]    Script Date: 07/01/2013 21:37:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Insert_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Insert_PatientHospitalization]
GO



/****** Object:  StoredProcedure [Patient].[usp_Insert_PatientHospitalization]    Script Date: 07/01/2013 21:37:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Inserts the record into the table without repeatation

CREATE PROCEDURE [Patient].[usp_Insert_PatientHospitalization]
	@PatientID BIGINT
	, @FacilityDoneHospitalID INT
	, @AdmittedOn DATE
	, @DischargedOn DATE = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @CurrentModificationBy BIGINT
	, @PatientHospitalizationID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();
		
		SELECT @PatientHospitalizationID = [Patient].[ufn_IsExists_PatientHospitalization] (@PatientID, @FacilityDoneHospitalID, @AdmittedOn, @DischargedOn, @Comment, 0);
		
		IF @PatientHospitalizationID = 0
		BEGIN
			IF @DischargedOn IS NULL -- CURRENT NO DISCHARGE
			BEGIN
				IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -3;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -4;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientID] = @PatientID AND [Patient].[PatientVisit].[DOS] >= @AdmittedOn AND [Patient].[PatientVisit].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -5;
				END
			END
			ELSE
			BEGIN
				IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -6;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DischargedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -7;
				END
				ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientVisitID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientID] = @PatientID AND [Patient].[PatientVisit].[DOS] BETWEEN @AdmittedOn AND @DischargedOn AND [Patient].[PatientVisit].[IsActive] = 1)
				BEGIN
					SELECT @PatientHospitalizationID = -8;
				END
			END
			
			IF @PatientHospitalizationID = 0
			BEGIN
				INSERT INTO [Patient].[PatientHospitalization]
				(
					[PatientID]
					, [FacilityDoneHospitalID]
					, [AdmittedOn]
					, [DischargedOn]
					, [Comment]
					, [CreatedBy]
					, [CreatedOn]
					, [LastModifiedBy]
					, [LastModifiedOn]
					, [IsActive]
				)
				VALUES
				(
					@PatientID
					, @FacilityDoneHospitalID
					, @AdmittedOn
					, @DischargedOn
					, @Comment
					, @CurrentModificationBy
					, @CurrentModificationOn
					, @CurrentModificationBy
					, @CurrentModificationOn
					, 1
				);
				
				SELECT @PatientHospitalizationID = MAX([Patient].[PatientHospitalization].[PatientHospitalizationID]) FROM [Patient].[PatientHospitalization];
			END
		END
		ELSE
		BEGIN			
			SELECT @PatientHospitalizationID = -1;
		END		
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY
			EXEC [Audit].[usp_Insert_ErrorLog];
			SELECT @PatientHospitalizationID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH	
END

GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_Update_WebCulture]    Script Date: 05/02/2013 11:14:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_Update_WebCulture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_Update_WebCulture]
GO


/****** Object:  StoredProcedure [Audit].[usp_Update_WebCulture]    Script Date: 05/02/2013 11:14:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Description:This Stored Procedure is used to INSERT the WebCulture details into the table after rollback.
 
CREATE PROCEDURE [Audit].[usp_Update_WebCulture]
	@KeyName NVARCHAR(12)
	, @IsActive BIT
	, @WebCultureID BIGINT OUTPUT	
AS
BEGIN

BEGIN TRY
	SET NOCOUNT ON;
	UPDATE 
		[Audit].[WebCulture] 
	SET 
		[Audit].[WebCulture].[IsActive] = @IsActive 
	WHERE 
		[Audit].[WebCulture].[KeyName] = @KeyName
		
	SELECT @WebCultureID = 1;
	
	END TRY
	
	BEGIN CATCH
	-- ERROR CATCHING - STARTS
	BEGIN TRY			
		EXEC [Audit].[usp_Insert_ErrorLog];			
		SELECT @WebCultureID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
	END TRY
	BEGIN CATCH
		RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
	END CATCH
	-- ERROR CATCHING - ENDS
	END CATCH
			
	END
			

GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 07/06/2013 14:13:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Update_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Update_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_Update_PatientVisit]    Script Date: 07/06/2013 14:13:16 ******/
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
	, @StatusIDs NVARCHAR(100)
	, @AssignedTo INT = NULL
	, @TargetBAUserID INT = NULL
	, @TargetQAUserID INT = NULL
	, @TargetEAUserID INT = NULL
	, @PatientVisitComplexity TINYINT
	, @Comment NVARCHAR(4000)
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
			
			DECLARE CUR_STS CURSOR LOCAL FAST_FORWARD READ_ONLY FOR SELECT [Data] FROM [dbo].[ufn_StringSplit] (@StatusIDs, ',');
			
			DECLARE @ClaimStatusID_STR NVARCHAR(100);
			
			OPEN CUR_STS;
			
			FETCH NEXT FROM CUR_STS INTO @ClaimStatusID_STR;
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @ClaimStatusID TINYINT;
				SELECT @ClaimStatusID = CAST(@ClaimStatusID_STR AS TINYINT);
				
				DECLARE @PatientVisitID_PREV BIGINT;
				SELECT @PatientVisitID_PREV = [Patient].[ufn_IsExists_PatientVisit] (@PatientID, @PatientHospitalizationID, @DOS, @IllnessIndicatorID, @IllnessIndicatorDate, @FacilityTypeID, @FacilityDoneID, @PrimaryClaimDiagnosisID, @DoctorNoteRelPath, @SuperBillRelPath, @PatientVisitDesc, @ClaimStatusID, @AssignedTo, @TargetBAUserID, @TargetQAUserID, @TargetEAUserID, @PatientVisitComplexity, @Comment, 1);

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
						
						IF @ClaimStatusID_PREV <> @ClaimStatusID
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
							, [Patient].[PatientVisit].[ClaimStatusID] = @ClaimStatusID
							, [Patient].[PatientVisit].[AssignedTo] = @AssignedTo
							, [Patient].[PatientVisit].[TargetBAUserID] = @TargetBAUserID
							, [Patient].[PatientVisit].[TargetQAUserID] = @TargetQAUserID
							, [Patient].[PatientVisit].[TargetEAUserID] = @TargetEAUserID
							, [Patient].[PatientVisit].[PatientVisitComplexity] = @PatientVisitComplexity
							, [Patient].[PatientVisit].[Comment] = @Comment
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
				
				FETCH NEXT FROM CUR_STS INTO @ClaimStatusID_STR;
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


----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_Update_PatientHospitalization]    Script Date: 07/05/2013 19:05:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_Update_PatientHospitalization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_Update_PatientHospitalization]
GO



/****** Object:  StoredProcedure [Patient].[usp_Update_PatientHospitalization]    Script Date: 07/05/2013 19:05:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--Description:This Stored Procedure is used to UPDATE the PatientHospitalization in the database.
	 
CREATE PROCEDURE [Patient].[usp_Update_PatientHospitalization]
	@PatientID BIGINT
	, @FacilityDoneHospitalID INT
	, @AdmittedOn DATE
	, @DischargedOn DATE = NULL
	, @Comment NVARCHAR(4000) = NULL
	, @IsActive BIT
	, @LastModifiedBy BIGINT
	, @LastModifiedOn DATETIME
	, @CurrentModificationBy BIGINT
	, @PatientHospitalizationID BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		DECLARE @CurrentModificationOn DATETIME;
		SELECT @CurrentModificationOn = GETDATE();

		DECLARE @PatientHospitalizationID_PREV BIGINT;
		SELECT @PatientHospitalizationID_PREV = [Patient].[ufn_IsExists_PatientHospitalization] (@PatientID, @FacilityDoneHospitalID, @AdmittedOn, @DischargedOn, @Comment, 1);

		DECLARE @IS_ACTIVE_PREV BIT;
		
		IF EXISTS(SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = @IsActive)
		BEGIN
			SELECT @IS_ACTIVE_PREV = 1;
		END
		ELSE
		BEGIN
			SELECT @IS_ACTIVE_PREV = 0;
		END		

		IF ((@PatientHospitalizationID_PREV = 0) OR (@IS_ACTIVE_PREV = 0))
		BEGIN
			DECLARE @LAST_MODIFIED_BY BIGINT;
			DECLARE @LAST_MODIFIED_ON DATETIME;
		
			SELECT 
				@LAST_MODIFIED_BY = [Patient].[PatientHospitalization].[LastModifiedBy]
				, @LAST_MODIFIED_ON =  [Patient].[PatientHospitalization].[LastModifiedOn]
			FROM 
				[Patient].[PatientHospitalization] WITH (NOLOCK)
			WHERE
				[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
			
			IF (@LAST_MODIFIED_BY = @LastModifiedBy) AND (DATEDIFF(MILLISECOND, @LAST_MODIFIED_ON, @LastModifiedOn) = 0)
			BEGIN
				IF @DischargedOn IS NULL -- CURRENT NO DISCHARGE
				BEGIN
					IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -9;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -10;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientHospitalizationID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientVisit].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -11;
					END
				END
				ELSE
				BEGIN
					IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@AdmittedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[DischargedOn] <> @AdmittedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -12;
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NOT NULL AND (@DischargedOn BETWEEN [Patient].[PatientHospitalization].[AdmittedOn] AND [Patient].[PatientHospitalization].[DischargedOn]) AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -13;		
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientHospitalization].[PatientHospitalizationID] FROM [Patient].[PatientHospitalization] WHERE [Patient].[PatientHospitalization].[PatientID] = @PatientID AND [Patient].[PatientHospitalization].[DischargedOn] IS NULL AND [Patient].[PatientHospitalization].[AdmittedOn] < @DischargedOn AND [Patient].[PatientHospitalization].[AdmittedOn] <> @DischargedOn AND [Patient].[PatientHospitalization].[PatientHospitalizationID] <> @PatientHospitalizationID AND [Patient].[PatientHospitalization].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -14;		
					END
					ELSE IF EXISTS (SELECT [Patient].[PatientVisit].[PatientHospitalizationID] FROM [Patient].[PatientVisit] WHERE [Patient].[PatientVisit].[PatientHospitalizationID] = @PatientHospitalizationID AND [Patient].[PatientVisit].[IsActive] = 1)
					BEGIN
						SELECT @PatientHospitalizationID = -15;
					END
				END
			
				IF @PatientHospitalizationID > 0
				BEGIN
					INSERT INTO 
						[Patient].[PatientHospitalizationHistory]
						(
							[PatientHospitalizationID]
							, [PatientID]
							, [FacilityDoneHospitalID]
							, [AdmittedOn]
							, [DischargedOn]
							, [Comment]
							, [CreatedBy]
							, [CreatedOn]
							, [LastModifiedBy]
							, [LastModifiedOn]
							, [IsActive]
						)
					SELECT
						[Patient].[PatientHospitalization].[PatientHospitalizationID]
						, [Patient].[PatientHospitalization].[PatientID]
						, [Patient].[PatientHospitalization].[FacilityDoneHospitalID]
						, [Patient].[PatientHospitalization].[AdmittedOn]
						, [Patient].[PatientHospitalization].[DischargedOn]
						, [Patient].[PatientHospitalization].[Comment]
						, @CurrentModificationBy
						, @CurrentModificationOn
						, @LastModifiedBy
						, @LastModifiedOn
						, [Patient].[PatientHospitalization].[IsActive]
					FROM 
						[Patient].[PatientHospitalization]
					WHERE
						[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
					
					UPDATE 
						[Patient].[PatientHospitalization]
					SET
						[Patient].[PatientHospitalization].[PatientID] = @PatientID
						, [Patient].[PatientHospitalization].[FacilityDoneHospitalID] = @FacilityDoneHospitalID
						, [Patient].[PatientHospitalization].[AdmittedOn] = @AdmittedOn
						, [Patient].[PatientHospitalization].[DischargedOn] = @DischargedOn
						, [Patient].[PatientHospitalization].[Comment] = @Comment
						, [Patient].[PatientHospitalization].[LastModifiedBy] = @CurrentModificationBy
						, [Patient].[PatientHospitalization].[LastModifiedOn] = @CurrentModificationOn
						, [Patient].[PatientHospitalization].[IsActive] = @IsActive
					WHERE
						[Patient].[PatientHospitalization].[PatientHospitalizationID] = @PatientHospitalizationID;
				END				
			END
			ELSE
			BEGIN
				SELECT @PatientHospitalizationID = -2;
			END
		END
		ELSE IF @PatientHospitalizationID_PREV <> @PatientHospitalizationID
		BEGIN			
			SELECT @PatientHospitalizationID = -1;			
		END
		-- ELSE
		-- BEGIN
		--	 SELECT @CurrentModificationOn = @LastModifiedOn;
		-- END
	END TRY
	BEGIN CATCH
		-- ERROR CATCHING - STARTS
		BEGIN TRY			
			EXEC [Audit].[usp_Insert_ErrorLog];			
			SELECT @PatientHospitalizationID = (MAX([Audit].[ErrorLog].[ErrorLogID]) * -1) FROM [Audit].[ErrorLog];
		END TRY
		BEGIN CATCH
			RAISERROR('Error in [Audit].[usp_Insert_ErrorLog]', -1, -1);
		END CATCH
		-- ERROR CATCHING - ENDS
	END CATCH
END



GO


----------------------------------------------------------------------

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReport_PatientVisit]    Script Date: 07/22/2013 18:08:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReport_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReport_PatientVisit]    Script Date: 07/22/2013 18:08:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReport_PatientVisit]	
     @UserID INT	
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Billing].[Clinic].[ClinicID]  IN
		(SELECT [USER].[UserClinic].[ClinicID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[UserID] = @UserID)
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
	
	
	--EXEC [Patient].[usp_GetReport_PatientVisit]  @UserID = 1
END

GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDx_PatientVisit]    Script Date: 07/18/2013 15:41:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDx_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDx_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportDx_PatientVisit]    Script Date: 07/18/2013 15:41:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportDx_PatientVisit]	
 @patientvisitid BIGINT
 
AS 
BEGIN

   SET NOCOUNT ON;
   
 SELECT 
         ROW_NUMBER() OVER (ORDER BY [ClaimDiagnosis].[ClaimDiagnosisID] ASC) AS [SN]
		, [ClaimDiagnosis].[ClaimDiagnosisID] AS [CLAIMDIAGNOSIS_ID]
		, [Diagnosis].[Diagnosis].[DiagnosisCode] AS [DIAGNOSIS_CODE]
		, [Diagnosis].[Diagnosis].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[Diagnosis].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[Diagnosis].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[Diagnosis].[CustomDesc] AS [CUSTOM_DESC]
		, [Diagnosis].[Diagnosis].[ICDFormat] AS [ICD_FORMAT]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] AS [DG_CODE]
		, [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] AS [DG_DESCRIPTION]
	FROM
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	INNER JOIN
		[Diagnosis].[Diagnosis] WITH (NOLOCK)
	ON
		[Diagnosis].[Diagnosis].[DiagnosisID] = [Claim].[ClaimDiagnosis].[DiagnosisID]
	LEFT JOIN
		[Diagnosis].[DiagnosisGroup] WITH (NOLOCK)
	ON
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupID] = [Diagnosis].[Diagnosis].[DiagnosisGroupID]
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = 1
	WHERE 
		[Claim].[ClaimDiagnosis].[PatientVisitID] = @patientvisitid
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	AND
		[Diagnosis].[Diagnosis].[IsActive] = 1;
		
	-- EXEC [Patient].[usp_GetReportDx_PatientVisit] @patientvisitid=1
END
GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetReportCpt_ClaimDiagnosis]    Script Date: 07/18/2013 15:41:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetReportCpt_ClaimDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetReportCpt_ClaimDiagnosis]
GO



/****** Object:  StoredProcedure [Claim].[usp_GetReportCpt_ClaimDiagnosis]    Script Date: 07/18/2013 15:41:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Claim].[usp_GetReportCpt_ClaimDiagnosis]
       @ClaimDiagnosisId BIGINT	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] ASC) AS [SN]
		, [ClaimDiagnosisCPT].[ClaimDiagnosisCPTID] AS [CLAIM_DIAGNOSIS_CPTID]
		, [Diagnosis].[CPT].[CPTCode] AS [CPT_CODE]
		, [Diagnosis].[CPT].[ShortDesc] AS [SHORT_DESC]
		, [Diagnosis].[CPT].[LongDesc] AS [LONG_DESC]
		, [Diagnosis].[CPT].[MediumDesc] AS [MEDIUM_DESC]
		, [Diagnosis].[CPT].[CustomDesc] AS [CUSTOM_DESC]
		, [Billing].[FacilityType].[FacilityTypeName]  AS [FACILITYTYPE_NAME]
		, [Claim].[ClaimDiagnosisCPT].[Unit]  AS [UNIT]
		, [Diagnosis].[CPT].[ChargePerUnit] AS [CHARGE_PER_UNIT]	
	FROM
	    [Claim].[ClaimDiagnosisCPT] WITH (NOLOCK)
	INNER JOIN
		[Claim].[ClaimDiagnosis] WITH (NOLOCK)
	ON
		[Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = [Claim].[ClaimDiagnosisCPT].[ClaimDiagnosisID]
	INNER JOIN
		[Diagnosis].[CPT] WITH (NOLOCK)
	ON
		[Diagnosis].[CPT].[CPTID] = [Claim].[ClaimDiagnosisCPT].[CPTID]
	INNER JOIN
		[Billing].[FacilityType]
	ON  
	    [Billing].[FacilityType].[FacilityTypeID] = [Claim].[ClaimDiagnosisCPT].[FacilityTypeID]
	WHERE 
	    [Claim].[ClaimDiagnosis].[ClaimDiagnosisID] = @ClaimDiagnosisId
	AND
	    [Claim].[ClaimDiagnosisCPT].[IsActive] = 1
	AND
		[Claim].[ClaimDiagnosis].[IsActive] = 1
	AND
		[Diagnosis].[CPT].[IsActive] = 1
	AND
        [Billing].[FacilityType].[IsActive]=1 	    ;
		
	--EXEC [Claim].[usp_GetReportCpt_ClaimDiagnosis]	@ClaimDiagnosisId =1
END

GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]    Script Date: 07/18/2013 15:43:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]    Script Date: 07/18/2013 15:43:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]
       @ClaimDiagnosisCPTId BIGINT
	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		ROW_NUMBER() OVER (ORDER BY [ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTModifierID] ASC) AS [SN]
		, [Diagnosis].[Modifier].[ModifierCode] AS [MODIFIER_CODE]
		, [Diagnosis].[Modifier].[ModifierName] AS [MODIFIER_NAME]
	FROM
	    [Claim].[ClaimDiagnosisCPTModifier] WITH (NOLOCK)
	INNER JOIN
		[Diagnosis].[Modifier] WITH (NOLOCK)
	ON
		[Diagnosis].[Modifier].[ModifierID] = [Claim].[ClaimDiagnosisCPTModifier].[ModifierID]
	WHERE 
	    [Claim].[ClaimDiagnosisCPTModifier].[ClaimDiagnosisCPTID] = @ClaimDiagnosisCPTId
	AND
	    [Claim].[ClaimDiagnosisCPTModifier].[IsActive] = 1  
	AND
		[Diagnosis].[Modifier].[IsActive] = 1; 
	END
	--EXEC [Claim].[usp_GetReportModifier_ClaimDiagnosisCPT]	@ClaimDiagnosisCPTId =356

GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisit_PatientVisit]    Script Date: 07/19/2013 11:46:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisit_PatientVisit]    Script Date: 07/19/2013 11:46:20 ******/
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
			AND
				[Patient].[Patient].[IsActive] = 1
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
			AND
				[Patient].[Patient].[IsActive] = 1
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
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
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
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
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicReport_PatientVisit]    Script Date: 07/16/2013 14:24:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicReport_PatientVisit]
GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 07/16/2013 17:22:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetAnsi837Visit_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetAnsi837Visit_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Visit_ClaimProcess]    Script Date: 07/16/2013 17:22:27 ******/
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
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Diagnosis].[IllnessIndicator]
	ON
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID] = [Patient].[PatientVisit].[IllnessIndicatorID]
	INNER JOIN
		[Billing].[FacilityType]
	ON
		[Billing].[FacilityType].[FacilityTypeID] = [Patient].[PatientVisit].[FacilityTypeID]
	INNER JOIN
		[Billing].[Provider]
	ON
		[Billing].[Provider].[ProviderID] = [Patient].[Patient].[ProviderID]
	INNER JOIN
		[Insurance].[Insurance]
	ON
		[Insurance].[Insurance].[InsuranceID] = [Patient].[Patient].[InsuranceID]
	INNER JOIN
		[Insurance].[Relationship]
	ON
		[Insurance].[Relationship].[RelationshipID] = [Patient].[Patient].[RelationshipID]
	INNER JOIN
		[Billing].[Credential]
	ON
		[Billing].[Credential].[CredentialID] = [Billing].[Provider].[CredentialID]
	INNER JOIN
		[Billing].[Specialty]
	ON
		[Billing].[Specialty].[SpecialtyID] = [Billing].[Provider].[SpecialtyID]
	INNER JOIN
		[Insurance].[InsuranceType]
	ON
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
	INNER JOIN
		[EDI].[PrintPin]
	ON
		[EDI].[PrintPin].[PrintPinID] = [Insurance].[Insurance].[PrintPinID]
	INNER JOIN
		[MasterData].[City] PATIENT_CITY
	ON
		[PATIENT_CITY].[CityID] = [Patient].[Patient].[CityID]
	INNER JOIN
		[MasterData].[State] PATIENT_STATE
	ON
		[PATIENT_STATE].[StateID] = [Patient].[Patient].[StateID]
	INNER JOIN
		[MasterData].[Country] PATIENT_COUNTRY
	ON
		[PATIENT_COUNTRY].[CountryID] = [Patient].[Patient].[CountryID]
	INNER JOIN
		[MasterData].[City] INSURANCE_CITY
	ON
		[INSURANCE_CITY].[CityID] = [Insurance].[Insurance].[CityID]
	INNER JOIN
		[MasterData].[State] INSURANCE_STATE
	ON
		[INSURANCE_STATE].[StateID] = [Insurance].[Insurance].[StateID]
	INNER JOIN
		[MasterData].[Country] INSURANCE_COUNTRY
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
	AND
		[Patient].[Patient].[IsActive] = 1
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = 1
	AND
		[Billing].[FacilityType].[IsActive] = 1
	AND
		[Billing].[Provider].[IsActive] = 1
	AND
		[Insurance].[Insurance].[IsActive] = 1
	AND
		[Insurance].[Relationship].[IsActive] = 1
	AND
		[Billing].[Credential].[IsActive] = 1
	AND
		[Billing].[Specialty].[IsActive] = 1
	AND
		[Insurance].[InsuranceType].[IsActive] = 1
	AND
		[EDI].[PrintPin].[IsActive] = 1
	AND
		[PATIENT_CITY].[IsActive] = 1
	AND
		[PATIENT_STATE].[IsActive] = 1
	AND
		[PATIENT_COUNTRY].[IsActive] = 1
	AND
		[INSURANCE_CITY].[IsActive] = 1
	AND
		[INSURANCE_STATE].[IsActive] = 1
	AND
		[INSURANCE_COUNTRY].[IsActive] = 1
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Clinic_ClaimProcess]    Script Date: 07/16/2013 18:34:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetAnsi837Clinic_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetAnsi837Clinic_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetAnsi837Clinic_ClaimProcess]    Script Date: 07/16/2013 18:34:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Claim].[usp_GetAnsi837Clinic_ClaimProcess]
	@ClinicID INT
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT
		[Billing].[Clinic].[ClinicID]
		, [Billing].[Clinic].[ClinicCode]
		, [Billing].[Clinic].[ClinicName]
		, [Billing].[Clinic].[ContactPersonLastName]
		, [Billing].[Clinic].[ContactPersonFirstName]
		, [Billing].[Clinic].[ContactPersonMiddleName]
		, [Billing].[Clinic].[ContactPersonEmail]
		, [Billing].[Clinic].[ContactPersonPhoneNumber]
		, [Billing].[Clinic].[ContactPersonFax]
		, [Billing].[Clinic].[NPI] AS [CLINIC_NPI]
		, [Billing].[Clinic].[TaxID] AS [CLINIC_TAX_ID]
		, [Billing].[Clinic].[StreetName] AS [ClinicStreetName]
		, [CLINIC_CITY].[CityName] AS [ClinicCityName]
		, [CLINIC_CITY].[ZipCode] AS [ClinicZipCode]
		, [CLINIC_STATE].[StateCode] AS [ClinicStateCode]
		, [CLINIC_COUNTRY].[CountryCode] AS [ClinicCountryCode]
		
		, [Billing].[IPA].[IPAName]
		, [Billing].[IPA].[NPI] AS [IPA_NPI]
		, [Billing].[IPA].[StreetName] AS [IPA_STREET_NAME]
		, [Billing].[IPA].[TaxID] AS [IPA_TAX_ID]
		, [CLINIC_ENTITY_TYPE].[EntityTypeQualifierCode] AS [ClinicEntityTypeQualifierCode]
		, [IPA_ENTITY_TYPE].[EntityTypeQualifierCode] AS [IPAEntityTypeQualifierCode]
		, [IPA_CITY].[CityName] AS [IPACityName]
		, [IPA_CITY].[ZipCode] AS [IPAZipCode]
		, [IPA_STATE].[StateCode] AS [IPAStateCode]
		, [IPA_COUNTRY].[CountryCode] AS [IPACountryCode]
		
	FROM
		[Billing].[Clinic]
	INNER JOIN
		[Billing].[IPA]
	ON
		[Billing].[IPA].[IPAID] = [Billing].[Clinic].[IPAID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] CLINIC_ENTITY_TYPE
	ON
		[CLINIC_ENTITY_TYPE].[EntityTypeQualifierID] = [Billing].[Clinic].[EntityTypeQualifierID]
	INNER JOIN
		[Transaction].[EntityTypeQualifier] IPA_ENTITY_TYPE
	ON
		[IPA_ENTITY_TYPE].[EntityTypeQualifierID] = [Billing].[IPA].[EntityTypeQualifierID]
	INNER JOIN
		[MasterData].[City] IPA_CITY
	ON
		[IPA_CITY].[CityID] = [Billing].[IPA].[CityID]
	INNER JOIN
		[MasterData].[State] IPA_STATE
	ON
		[IPA_STATE].[StateID] = [Billing].[IPA].[StateID]
	INNER JOIN
		[MasterData].[Country] IPA_COUNTRY
	ON
		[IPA_COUNTRY].[CountryID] = [Billing].[IPA].[CountryID]
	INNER JOIN
		[MasterData].[City] CLINIC_CITY
	ON
		[CLINIC_CITY].[CityID] = [Billing].[Clinic].[CityID]
	INNER JOIN
		[MasterData].[State] CLINIC_STATE
	ON
		[CLINIC_STATE].[StateID] = [Billing].[Clinic].[StateID]
	INNER JOIN
		[MasterData].[Country] CLINIC_COUNTRY
	ON
		[CLINIC_COUNTRY].[CountryID] = [Billing].[Clinic].[CountryID]
	WHERE
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
		[Billing].[Clinic].[IsActive] = 1
	AND
		[Billing].[IPA].[IsActive] = 1
	AND
		[CLINIC_ENTITY_TYPE].[IsActive] = 1
	AND
		[IPA_ENTITY_TYPE].[IsActive] = 1
	AND
		[IPA_CITY].[IsActive] = 1
	AND
		[IPA_STATE].[IsActive] = 1
	AND
		[IPA_COUNTRY].[IsActive] = 1
	AND
		[CLINIC_CITY].[IsActive] = 1
	AND
		[CLINIC_STATE].[IsActive] = 1
	AND
		[CLINIC_COUNTRY].[IsActive] = 1
		
	-- EXEC [Claim].[usp_GetAnsi837Clinic_ClaimProcess] 1
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetProviderReport_PatientVisit]    Script Date: 07/16/2013 17:36:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetProviderReport_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetProviderReport_PatientVisit]
GO

----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 07/19/2013 14:17:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisit_PatientVisit]    Script Date: 07/19/2013 14:17:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Patient].[usp_GetAgentWiseVisit_PatientVisit]
	@UserID INT
	, @Desc VARCHAR(15)
	, @DayCount VARCHAR(12)
	, @SearchName NVARCHAR(150) = NULL
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
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
	
	
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'THIRTYPLUS'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetAgentWiseVisit_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END









GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportClinic_PatientVisit]    Script Date: 07/17/2013 12:51:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportClinic_PatientVisit]    Script Date: 07/17/2013 12:51:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Patient].[usp_GetReportClinic_PatientVisit]	
     @ClinicID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Billing].[Clinic].[ClinicID] = @ClinicID
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
		[Insurance].[Insurance].[IsActive] = 1
	
	
	--EXEC [Patient].[usp_GetReportClinic_PatientVisit]  @UserID = 1
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END








GO



----------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetReportProvider_PatientVisit]    Script Date: 07/17/2013 12:53:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportProvider_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportProvider_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportProvider_PatientVisit]    Script Date: 07/17/2013 12:53:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Patient].[usp_GetReportProvider_PatientVisit]	
     @ProviderID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Billing].[Provider].[ProviderID] = @ProviderID
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
		[Insurance].[Insurance].[IsActive] = 1
	
	
	--EXEC [Patient].[usp_GetReportProvider_PatientVisit]  @UserID = 1
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END








GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetWebAdmin_User]    Script Date: 07/17/2013 13:23:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetWebAdmin_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetWebAdmin_User]
GO

/****** Object:  StoredProcedure [User].[usp_GetWebAdmin_User]    Script Date: 07/17/2013 13:23:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- created by sai for adding a new clinic to all webadmins

CREATE PROCEDURE [User].[usp_GetWebAdmin_User] 
	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
	      [User].[User].[UserID]
	     ,[User].[User].[IsActive]
	FROM
		[User].[User]  WITH (NOLOCK)
	INNER JOIN
	    [User].[UserRole]
	ON
	     [User].[User].[UserID] = [User].[UserRole].[UserID]
	INNER JOIN 
		[AccessPrivilege].[Role]  
	ON 
		[User].[UserRole].[RoleID] = [AccessPrivilege].[Role].[RoleID]
	WHERE
		[AccessPrivilege].[Role].[RoleID] = 1
	AND
	   	[User].[User].[IsActive] = 1
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[AccessPrivilege].[Role].[IsActive] = 1
	ORDER BY
		[AccessPrivilege].[Role].[RoleID]
	ASC;
		

	-- EXEC [User].[usp_GetAllWebAdmin_User] 
	
END



GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportPatient_PatientVisit]    Script Date: 07/17/2013 16:44:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportPatient_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportPatient_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportPatient_PatientVisit]    Script Date: 07/17/2013 16:44:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetReportPatient_PatientVisit]	
     @PatientID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Patient].[Patient].[PatientID] = @PatientID
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
		[Insurance].[Insurance].[IsActive] = 1
	
	
	--EXEC [Patient].[usp_GetReportPatient_PatientVisit]  @PatientID = 1
	-- EXEC [Patient].[usp_GetReportPatient_PatientVisit]
END









GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearchRpt_Patient]    Script Date: 07/17/2013 18:05:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearchRpt_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearchRpt_Patient]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetBySearchRpt_Patient]    Script Date: 07/17/2013 18:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [Patient].[usp_GetBySearchRpt_Patient]
	@ClinicID		INT
	, @StartBy NVARCHAR(1) = NULL
	, @IsActive BIT = NULL	
AS
BEGIN-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
    
    SELECT
		[Patient].[Patient].[ChartNumber]	
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) as NAME
		, [Patient].[Patient].[PatientID]
		, [Patient].[Patient].[IsActive]
	FROM
		
		[Patient].[Patient] WITH (NOLOCK) 
	
	WHERE 
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	LIKE 
		@StartBy + '%'
	AND
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	
	ORDER BY
		[Patient].[Patient].[LastName]
	ASC;
		
	
	-- EXEC [Patient].[usp_GetBySearch_Patient] @ClinicID = 103 , @RoleID = 5, @StartBy='W'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZRpt_Patient]    Script Date: 07/17/2013 18:05:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZRpt_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZRpt_Patient]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZRpt_Patient]    Script Date: 07/17/2013 18:05:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetByAZRpt_Patient] 

	@ClinicID	INT
	, @IsActive BIT = NULL	

AS
BEGIN
	
	SET NOCOUNT ON;
    
    DECLARE @TBL_ALL TABLE
    (
		[ClinicName] [nvarchar](40) NULL
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
		
		[Patient].[Patient] WITH (NOLOCK)
	WHERE
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	
	ORDER BY
		(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))
	ASC;
	    
		
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
			[ClinicName] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [Patient].[usp_GetByAZ_Clinic] 1 , 1
END



GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 07/17/2013 21:23:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetNameByID_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetNameByID_User]
GO

/****** Object:  StoredProcedure [User].[usp_GetNameByID_User]    Script Date: 07/17/2013 21:23:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- Select the particular record

CREATE PROCEDURE [User].[usp_GetNameByID_User] 
	@UserID	BIGINT
	, @IsActive	BIT = NULL
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
		@UserID = [User].[User].[UserID]
	AND
		[User].[User].[IsActive]=1;
	
	SELECT * FROM @TBL_RES;

	-- EXEC [User].[usp_GetNameByID_User] 1, NULL
	
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetBySearch_Role]    Script Date: 07/18/2013 11:11:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AccessPrivilege].[usp_GetBySearch_Role]') AND type in (N'P', N'PC'))
DROP PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
GO

/****** Object:  StoredProcedure [AccessPrivilege].[usp_GetBySearch_Role]    Script Date: 07/18/2013 11:11:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [AccessPrivilege].[usp_GetBySearch_Role]
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
		[AccessPrivilege].[Role].[RoleID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'RoleName' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[RoleName] END ASC,
				CASE WHEN @orderByField = 'RoleName' AND @orderByDirection = 'D' THEN [AccessPrivilege].[Role].[RoleName] END DESC,
				
			    CASE WHEN @OrderByField = 'RoleCode' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[RoleCode] END ASC,
				CASE WHEN @orderByField = 'RoleCode' AND @orderByDirection = 'D' THEN [AccessPrivilege].[Role].[RoleCode] END DESC,
				
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [AccessPrivilege].[Role].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [AccessPrivilege].[Role].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[AccessPrivilege].[Role]
	WHERE
		[AccessPrivilege].[Role].[RoleName] LIKE @StartBy + '%' 
	AND
		[AccessPrivilege].[Role].[RoleName] LIKE '%' + @SearchName + '%' 
	AND
		[AccessPrivilege].[Role].[IsActive] = CASE WHEN @IsActive IS NULL THEN [AccessPrivilege].[Role].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Role].[RoleID], [Role].[RoleName],[Role].[RoleCode],[Role].[IsActive]
	FROM
		[Role] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Role].[RoleID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[Role].[RoleID]
	
	
	-- EXEC [AccessPrivilege].[usp_GetBySearch_Role] @SearchName  = '45'
	-- EXEC [AccessPrivilege].[usp_GetBySearch_Role] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetBySearch_WebCulture]    Script Date: 07/18/2013 11:11:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetBySearch_WebCulture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetBySearch_WebCulture]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetBySearch_WebCulture]    Script Date: 07/18/2013 11:11:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Audit].[usp_GetBySearch_WebCulture]
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
		, [PK_ID] NVARCHAR(12) NOT NULL
		, [ROW_NUM] INT NOT NULL
	);
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT TOP (@CurrPageNumber * @RecordsPerPage)
		[Audit].[WebCulture].[KeyName]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'EnglishName' AND @OrderByDirection = 'A' THEN [Audit].[WebCulture].[EnglishName] END ASC,
				CASE WHEN @orderByField = 'EnglishName' AND @orderByDirection = 'D' THEN [Audit].[WebCulture].[EnglishName] END DESC,
						
				CASE WHEN @OrderByField = 'NativeName' AND @OrderByDirection = 'A' THEN [Audit].[WebCulture].[NativeName] END ASC,
				CASE WHEN @orderByField = 'NativeName' AND @orderByDirection = 'D' THEN [Audit].[WebCulture].[NativeName] END DESC
				
				
				
			) AS ROW_NUM
	FROM
		[Audit].[WebCulture]
	WHERE
		[Audit].[WebCulture].[EnglishName] LIKE @StartBy + '%' 
	AND
	(
		[Audit].[WebCulture].[EnglishName] LIKE '%' + @SearchName + '%' 
	
	)
	
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[WebCulture].[KeyName], [WebCulture].[EnglishName], [WebCulture].[NativeName], [WebCulture].[IsActive]
	FROM
		[WebCulture] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [WebCulture].[KeyName]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Audit].[usp_GetBySearch_WebCulture] @SearchName  = '36'
	-- EXEC [Audit].[usp_GetBySearch_WebCulture] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Credential]    Script Date: 07/18/2013 11:12:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_Credential]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_Credential]
GO

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Credential]    Script Date: 07/18/2013 11:12:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Billing].[usp_GetBySearch_Credential]
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
		[Billing].[Credential].[CredentialID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CredentialName' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[CredentialName] END ASC,
				CASE WHEN @orderByField = 'CredentialName' AND @orderByDirection = 'D' THEN [Billing].[Credential].[CredentialName] END DESC,
				
				CASE WHEN @OrderByField = 'CredentialCode' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[CredentialCode] END ASC,
				CASE WHEN @orderByField = 'CredentialCode' AND @orderByDirection = 'D' THEN [Billing].[Credential].[CredentialCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Credential].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Credential].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[Credential]
	WHERE
		[Billing].[Credential].[CredentialName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[Credential].[CredentialName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Credential].[CredentialCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[Credential].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Credential].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Credential].[CredentialID], [Credential].[CredentialCode], [Credential].[CredentialName], [Credential].[IsActive]
	FROM
		[Credential] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Credential].[CredentialID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Credential] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_Credential] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_FacilityDone]    Script Date: 07/18/2013 11:12:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_FacilityDone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_FacilityDone]
GO



/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_FacilityDone]    Script Date: 07/18/2013 11:12:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Billing].[usp_GetBySearch_FacilityDone]
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
		[Billing].[FacilityDone].[FacilityDoneID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'FacilityDoneName' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneName] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneName' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneName] END DESC,
				
				CASE WHEN @OrderByField = 'FacilityDoneCode' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[FacilityDoneCode] END ASC,
				CASE WHEN @orderByField = 'FacilityDoneCode' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[FacilityDoneCode] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[FacilityDone].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[FacilityDone].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[FacilityDone].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[FacilityDone]
	WHERE
		[Billing].[FacilityDone].[FacilityDoneName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[FacilityDone].[FacilityDoneName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[FacilityDone].[FacilityDoneCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[FacilityDone].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityDone].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[FacilityDone].[FacilityDoneID], [FacilityDone].[FacilityDoneCode], [FacilityDone].[FacilityDoneName],[FacilityDone].[NPI], [FacilityDone].[IsActive]
	FROM
		[FacilityDone] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [FacilityDone].[FacilityDoneID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_FacilityDone] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_FacilityDone] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_FacilityType]    Script Date: 07/18/2013 11:13:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_FacilityType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_FacilityType]
GO

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_FacilityType]    Script Date: 07/18/2013 11:13:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Billing].[usp_GetBySearch_FacilityType]
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
		[Billing].[FacilityType].[FacilityTypeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'FacilityTypeName' AND @OrderByDirection = 'A' THEN [Billing].[FacilityType].[FacilityTypeName] END ASC,
				CASE WHEN @orderByField = 'FacilityTypeName' AND @orderByDirection = 'D' THEN [Billing].[FacilityType].[FacilityTypeName] END DESC,
				
				CASE WHEN @OrderByField = 'FacilityTypeCode' AND @OrderByDirection = 'A' THEN [Billing].[FacilityType].[FacilityTypeCode] END ASC,
				CASE WHEN @orderByField = 'FacilityTypeCode' AND @orderByDirection = 'D' THEN [Billing].[FacilityType].[FacilityTypeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[FacilityType].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[FacilityType].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[FacilityType]
	WHERE
		[Billing].[FacilityType].[FacilityTypeName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[FacilityType].[FacilityTypeName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[FacilityType].[FacilityTypeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[FacilityType].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[FacilityType].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[FacilityType].[FacilityTypeID], [FacilityType].[FacilityTypeCode], [FacilityType].[FacilityTypeName], [FacilityType].[IsActive]
	FROM
		[FacilityType] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [FacilityType].[FacilityTypeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_FacilityType] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_FacilityType] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_IPA]    Script Date: 07/18/2013 11:14:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_IPA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_IPA]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_IPA]    Script Date: 07/18/2013 11:14:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Billing].[usp_GetBySearch_IPA]
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
		[Billing].[IPA].[IPAID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'IPAName' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[IPAName] END ASC,
				CASE WHEN @orderByField = 'IPAName' AND @orderByDirection = 'D' THEN [Billing].[IPA].[IPAName] END DESC,
				
				CASE WHEN @OrderByField = 'IPACode' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[IPACode] END ASC,
				CASE WHEN @orderByField = 'IPACode' AND @orderByDirection = 'D' THEN [Billing].[IPA].[IPACode] END DESC,
				
			    CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[IPA].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'EntityTypeQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END ASC,
				CASE WHEN @orderByField = 'EntityTypeQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[IPA].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[IPA].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[IPA]
		
		INNER JOIN
		
		[Transaction].[EntityTypeQualifier]
		
		ON
		
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = [Billing].[IPA].[EntityTypeQualifierID]
		
		
	WHERE
		[Billing].[IPA].[IPAName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[IPA].[IPAName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[IPA].[IPACode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[IPA].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[IPA].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[IPA].[IPAID], [IPA].[IPACode], [IPA].[IPAName],[IPA].[NPI],[EntityTypeQualifier].[EntityTypeQualifierName] ,[IPA].[IsActive]
	FROM
		[IPA] WITH (NOLOCK)
		INNER JOIN
		
		[Transaction].[EntityTypeQualifier]
		
		ON
		
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID] = [Billing].[IPA].[EntityTypeQualifierID]
		
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [IPA].[IPAID]
		
		
		
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_IPA] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_IPA] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Provider]    Script Date: 07/18/2013 11:14:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_Provider]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_Provider]
GO


/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Provider]    Script Date: 07/18/2013 11:14:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [Billing].[usp_GetBySearch_Provider]
     @ClinicID int = NULL
	,@SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS

IF @ClinicID IS NOT NULL

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
		[Billing].[Provider].[ProviderID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) END DESC,
				
				CASE WHEN @OrderByField = 'ProviderCode' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[ProviderCode] END ASC,
				CASE WHEN @orderByField = 'ProviderCode' AND @orderByDirection = 'D' THEN [Billing].[Provider].[ProviderCode] END DESC,
				
				CASE WHEN @OrderByField = 'SSN' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[SSN] END ASC,
				CASE WHEN @orderByField = 'SSN' AND @orderByDirection = 'D' THEN [Billing].[Provider].[SSN] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[Provider].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'SpecialtyName' AND @OrderByDirection = 'A' THEN [Billing].[Specialty].[SpecialtyName] END ASC,
				CASE WHEN @orderByField = 'SpecialtyName' AND @orderByDirection = 'D' THEN [Billing].[Specialty].[SpecialtyName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Provider].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[Provider]
		
		INNER JOIN
		
		[Billing].[Specialty]
		
		ON
		[Billing].[Provider].[SpecialtyID] = [Billing].[Specialty].[SpecialtyID]
		
	WHERE
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
	(
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Provider].[ProviderCode] LIKE '%' + @SearchName + '%' 
	)
	
	AND
	
	[Billing].[Provider].[ClinicID] = @ClinicID
	
	AND
		[Billing].[Provider].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Provider].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Provider].[ProviderID], [Provider].[ProviderCode], (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) as [Name],[Provider].[SSN],[Provider].[NPI],[Specialty].[SpecialtyName], [Provider].[IsActive]
	FROM
		[Provider] WITH (NOLOCK)
		INNER JOIN
		
		[Billing].[Specialty]
		
		ON
		[Billing].[Provider].[SpecialtyID] = [Billing].[Specialty].[SpecialtyID]
		
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Provider].[ProviderID]
		
		
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
		
	AND
	[Billing].[Provider].[ClinicID] = @ClinicID
		
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Provider] @ClinicID = 2
	-- EXEC [Billing].[usp_GetBySearch_Provider] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END

ELSE

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
	
	
	
	INSERT INTO
		@SEARCH_TMP
		(
			[PK_ID]
			, [ROW_NUM]
		)
	SELECT
		[Billing].[Provider].[ProviderID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) END DESC,
				
				CASE WHEN @OrderByField = 'ProviderCode' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[ProviderCode] END ASC,
				CASE WHEN @orderByField = 'ProviderCode' AND @orderByDirection = 'D' THEN [Billing].[Provider].[ProviderCode] END DESC,
				
				CASE WHEN @OrderByField = 'SSN' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[SSN] END ASC,
				CASE WHEN @orderByField = 'SSN' AND @orderByDirection = 'D' THEN [Billing].[Provider].[SSN] END DESC,
				
				CASE WHEN @OrderByField = 'NPI' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[NPI] END ASC,
				CASE WHEN @orderByField = 'NPI' AND @orderByDirection = 'D' THEN [Billing].[Provider].[NPI] END DESC,
				
				CASE WHEN @OrderByField = 'SpecialtyName' AND @OrderByDirection = 'A' THEN [Billing].[Specialty].[SpecialtyName] END ASC,
				CASE WHEN @orderByField = 'SpecialtyName' AND @orderByDirection = 'D' THEN [Billing].[Specialty].[SpecialtyName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Provider].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Provider].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[Provider]
		
		INNER JOIN
		
		[Billing].[Specialty]
		
		ON
		[Billing].[Provider].[SpecialtyID] = [Billing].[Specialty].[SpecialtyID]
		
	WHERE
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) LIKE @StartBy + '%' 
	AND
	(
		(LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Provider].[ProviderCode] LIKE '%' + @SearchName + '%' 
	)
	
	AND
		[Billing].[Provider].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Provider].[IsActive] ELSE @IsActive END;
		
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Provider].[ProviderID], [Provider].[ProviderCode], (LTRIM(RTRIM([Billing].[Provider].[LastName] + ' ' + [Billing].[Provider].[FirstName] + ' ' + ISNULL ([Billing].[Provider].[MiddleName], '')))) as [Name],[Provider].[SSN],[Provider].[NPI],[Specialty].[SpecialtyName], [Provider].[IsActive]
	FROM
		[Provider] WITH (NOLOCK)
		INNER JOIN
		
		[Billing].[Specialty]
		
		ON
		[Billing].[Provider].[SpecialtyID] = [Billing].[Specialty].[SpecialtyID]
		
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Provider].[ProviderID]
		
		
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
		
	
		
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Provider] @ClinicID = 2
	-- EXEC [Billing].[usp_GetBySearch_Provider] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END








GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Specialty]    Script Date: 07/18/2013 11:14:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearch_Specialty]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearch_Specialty]
GO

/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Specialty]    Script Date: 07/18/2013 11:14:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Billing].[usp_GetBySearch_Specialty]
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
		[Billing].[Specialty].[SpecialtyID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'SpecialtyName' AND @OrderByDirection = 'A' THEN [Billing].[Specialty].[SpecialtyName] END ASC,
				CASE WHEN @orderByField = 'SpecialtyName' AND @orderByDirection = 'D' THEN [Billing].[Specialty].[SpecialtyName] END DESC,
				
				CASE WHEN @OrderByField = 'SpecialtyCode' AND @OrderByDirection = 'A' THEN [Billing].[Specialty].[SpecialtyCode] END ASC,
				CASE WHEN @orderByField = 'SpecialtyCode' AND @orderByDirection = 'D' THEN [Billing].[Specialty].[SpecialtyCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Billing].[Specialty].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Billing].[Specialty].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Billing].[Specialty]
	WHERE
		[Billing].[Specialty].[SpecialtyName] LIKE @StartBy + '%' 
	AND
	(
		[Billing].[Specialty].[SpecialtyName] LIKE '%' + @SearchName + '%' 
	OR
		[Billing].[Specialty].[SpecialtyCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Billing].[Specialty].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Billing].[Specialty].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Specialty].[SpecialtyID], [Specialty].[SpecialtyCode], [Specialty].[SpecialtyName], [Specialty].[IsActive]
	FROM
		[Specialty] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Specialty].[SpecialtyID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Billing].[usp_GetBySearch_Specialty] @SearchName  = '45'
	-- EXEC [Billing].[usp_GetBySearch_Specialty] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Billing].[usp_GetBySearchAd_Clinic]    Script Date: 07/18/2013 11:15:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Billing].[usp_GetBySearchAd_Clinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Billing].[usp_GetBySearchAd_Clinic]
GO

/****** Object:  StoredProcedure [Billing].[usp_GetBySearchAd_Clinic]    Script Date: 07/18/2013 11:15:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







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
	   [Billing].[Clinic]
	 
     INNER JOIN
	     [Billing].[IPA]
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
INNER JOIN
	     [Transaction].[EntityTypeQualifier]
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
	     [Billing].[IPA]
	ON
	    [Billing].[Clinic].[IPAID]= [Billing].[IPA].[IPAID]
INNER JOIN
	     [Transaction].[EntityTypeQualifier]
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_CPT]    Script Date: 07/18/2013 11:17:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Diagnosis].[usp_GetBySearch_CPT]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_CPT]
GO


/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_CPT]    Script Date: 07/18/2013 11:17:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_CPT]
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
		[Diagnosis].[CPT].[CPTID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Description' AND @OrderByDirection = 'A' THEN ISNULL([Diagnosis].[CPT].[ShortDesc],ISNULL([Diagnosis].[CPT].[LongDesc],ISNULL([Diagnosis].[CPT].[CustomDesc],ISNULL([Diagnosis].[CPT].[MediumDesc],'NO DESC'))))  END ASC,
				CASE WHEN @orderByField = 'Description' AND @orderByDirection = 'D' THEN ISNULL([Diagnosis].[CPT].[ShortDesc],ISNULL([Diagnosis].[CPT].[LongDesc],ISNULL([Diagnosis].[CPT].[CustomDesc],ISNULL([Diagnosis].[CPT].[MediumDesc],'NO DESC')))) END DESC,
						
				CASE WHEN @OrderByField = 'CPTCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[CPT].[CPTCode] END ASC,
				CASE WHEN @orderByField = 'CPTCode' AND @orderByDirection = 'D' THEN [Diagnosis].[CPT].[CPTCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[CPT].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[CPT].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[CPT]
	WHERE
		ISNULL([Diagnosis].[CPT].[ShortDesc],ISNULL([Diagnosis].[CPT].[LongDesc],ISNULL([Diagnosis].[CPT].[CustomDesc],ISNULL([Diagnosis].[CPT].[MediumDesc],'NO DESC')))) LIKE @StartBy + '%' 
	AND
	(
		ISNULL([Diagnosis].[CPT].[ShortDesc],ISNULL([Diagnosis].[CPT].[LongDesc],ISNULL([Diagnosis].[CPT].[CustomDesc],ISNULL([Diagnosis].[CPT].[MediumDesc],'NO DESC')))) LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[CPT].[CPTCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[CPT].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[CPT].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[CPT].[CPTID], [CPT].[CPTCode], ISNULL([Diagnosis].[CPT].[ShortDesc],ISNULL([Diagnosis].[CPT].[LongDesc],ISNULL([Diagnosis].[CPT].[CustomDesc],ISNULL([Diagnosis].[CPT].[MediumDesc],'NO DESC')))) AS DESCRIPTION, [CPT].[IsActive]
	FROM
		[CPT] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [CPT].[CPTID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_CPT] @SearchName  = '36'
	-- EXEC [Diagnosis].[usp_GetBySearch_CPT] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_Diagnosis]    Script Date: 07/18/2013 11:17:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Diagnosis].[usp_GetBySearch_Diagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_Diagnosis]
GO


/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_Diagnosis]    Script Date: 07/18/2013 11:17:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_Diagnosis]
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
		[Diagnosis].[Diagnosis].[DiagnosisID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Description' AND @OrderByDirection = 'A' THEN ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC'))))  END ASC,
				CASE WHEN @orderByField = 'Description' AND @orderByDirection = 'D' THEN ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) END DESC,
						
				CASE WHEN @OrderByField = 'DiagnosisCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[DiagnosisCode] END ASC,
				CASE WHEN @orderByField = 'DiagnosisCode' AND @orderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[DiagnosisCode] END DESC,
				
				CASE WHEN @OrderByField = 'ICDFormat' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[ICDFormat] END ASC,
				CASE WHEN @orderByField = 'ICDFormat' AND @orderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[ICDFormat] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[Diagnosis]
	WHERE
	
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC'))))  LIKE @StartBy + '%' 
		
		    
	AND
	(
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[Diagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Diagnosis].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Diagnosis].[DiagnosisID]
	  , [Diagnosis].[DiagnosisCode]
	  , ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) as Description
	  ,[Diagnosis].[ICDFormat],[Diagnosis].[IsActive]
	FROM
		[Diagnosis] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Diagnosis].[DiagnosisID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_Diagnosis] @SearchName  = '36'
	-- EXEC [Diagnosis].[usp_GetBySearch_Diagnosis] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_DiagnosisGroup]    Script Date: 07/18/2013 11:18:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Diagnosis].[usp_GetBySearch_DiagnosisGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_DiagnosisGroup]
GO


/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_DiagnosisGroup]    Script Date: 07/18/2013 11:18:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_DiagnosisGroup]
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
		[DiagnosisGroup].[DiagnosisGroupID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'DiagnosisGroupDescription' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] END ASC,
				CASE WHEN @orderByField = 'DiagnosisGroupDescription' AND @orderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] END DESC,
						
				CASE WHEN @OrderByField = 'DiagnosisGroupCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] END ASC,
				CASE WHEN @orderByField = 'DiagnosisGroupCode' AND @orderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[DiagnosisGroup]
	WHERE
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] LIKE @StartBy + '%' 
	AND
	(
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[DiagnosisGroup].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[DiagnosisGroup].[DiagnosisGroupID], [DiagnosisGroup].[DiagnosisGroupCode], [DiagnosisGroup].[DiagnosisGroupDescription], [DiagnosisGroup].[IsActive]
	FROM
		[DiagnosisGroup] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [DiagnosisGroup].[DiagnosisGroupID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_DiagnosisGroup] @SearchName  = '36'
	-- EXEC [Diagnosis].[usp_GetBySearch_DiagnosisGroup] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END


GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_IllnessIndicator]    Script Date: 07/18/2013 11:18:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Diagnosis].[usp_GetBySearch_IllnessIndicator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_IllnessIndicator]
GO


/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_IllnessIndicator]    Script Date: 07/18/2013 11:18:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_IllnessIndicator]
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
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'IllnessIndicatorName' AND @OrderByDirection = 'A' THEN [Diagnosis].[IllnessIndicator].[IllnessIndicatorName] END ASC,
				CASE WHEN @orderByField = 'IllnessIndicatorName' AND @orderByDirection = 'D' THEN [Diagnosis].[IllnessIndicator].[IllnessIndicatorName] END DESC,
				
				CASE WHEN @OrderByField = 'IllnessIndicatorCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[IllnessIndicator].[IllnessIndicatorCode] END ASC,
				CASE WHEN @orderByField = 'IllnessIndicatorCode' AND @orderByDirection = 'D' THEN [Diagnosis].[IllnessIndicator].[IllnessIndicatorCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[IllnessIndicator].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[IllnessIndicator].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[IllnessIndicator]
	WHERE
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorName] LIKE @StartBy + '%' 
	AND
	(
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorName] LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[IllnessIndicator].[IllnessIndicatorCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[IllnessIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[IllnessIndicator].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[IllnessIndicator].[IllnessIndicatorID], [IllnessIndicator].[IllnessIndicatorCode], [IllnessIndicator].[IllnessIndicatorName], [IllnessIndicator].[IsActive]
	FROM
		[IllnessIndicator] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [IllnessIndicator].[IllnessIndicatorID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_IllnessIndicator] @SearchName  = '45'
	-- EXEC [Diagnosis].[usp_GetBySearch_IllnessIndicator] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_Modifier]    Script Date: 07/18/2013 11:18:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Diagnosis].[usp_GetBySearch_Modifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_Modifier]
GO


/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_Modifier]    Script Date: 07/18/2013 11:18:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_Modifier]
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
		[Diagnosis].[Modifier].[ModifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'ModifierName' AND @OrderByDirection = 'A' THEN [Diagnosis].[Modifier].[ModifierName] END ASC,
				CASE WHEN @orderByField = 'ModifierName' AND @orderByDirection = 'D' THEN [Diagnosis].[Modifier].[ModifierName] END DESC,
				
				CASE WHEN @OrderByField = 'ModifierCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[Modifier].[ModifierCode] END ASC,
				CASE WHEN @orderByField = 'ModifierCode' AND @orderByDirection = 'D' THEN [Diagnosis].[Modifier].[ModifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[Modifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[Modifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[Modifier]
	WHERE
		[Diagnosis].[Modifier].[ModifierName] LIKE @StartBy + '%' 
	AND
	(
		[Diagnosis].[Modifier].[ModifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[Modifier].[ModifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[Modifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Modifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Modifier].[ModifierID], [Modifier].[ModifierCode], [Modifier].[ModifierName], [Modifier].[IsActive]
	FROM
		[Modifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Modifier].[ModifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_Modifier] @SearchName  = '45'
	-- EXEC [Diagnosis].[usp_GetBySearch_Modifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIReceiver]    Script Date: 07/18/2013 11:20:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_EDIReceiver]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIReceiver]
GO



/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIReceiver]    Script Date: 07/18/2013 11:20:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIReceiver]	
	@OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
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
		[EDI].[EDIReceiver].[EDIReceiverID]
		, ROW_NUMBER() OVER (
			ORDER BY						
				CASE WHEN @OrderByField = 'EDIReceiverCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[EDIReceiverCode] END ASC,
				CASE WHEN @orderByField = 'EDIReceiverCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[EDIReceiverCode] END DESC,
				
				CASE WHEN @OrderByField = 'AuthQual' AND @OrderByDirection = 'A' THEN ([Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' +[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') END ASC,
				CASE WHEN @orderByField = 'AuthQual' AND @orderByDirection = 'D' THEN ([Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' +[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') END DESC,
				
				CASE WHEN @OrderByField = 'ApplicationReceiverCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ApplicationReceiverCode] END ASC,
				CASE WHEN @orderByField = 'ApplicationReceiverCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ApplicationReceiverCode] END DESC,
				
				CASE WHEN @OrderByField = 'ApplicationSenderCode' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ApplicationSenderCode] END ASC,
				CASE WHEN @orderByField = 'ApplicationSenderCode' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ApplicationSenderCode] END DESC,
				
				--CASE WHEN @OrderByField = 'ReceiverID' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[ReceiverID] END ASC,
				--CASE WHEN @orderByField = 'ReceiverID' AND @orderByDirection = 'D' THEN [EDI].[EDIReceiver].[ReceiverID] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[EDIReceiver].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[EDIReceiver].[LastModifiedOn] END DESC			
			) AS ROW_NUM
FROM
		[EDI].[EDIReceiver]
		
		INNER JOIN
		
		[Transaction].[AuthorizationInformationQualifier]
		
		ON
		
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
		
	WHERE
		[EDI].[EDIReceiver].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIReceiver].[IsActive] ELSE @IsActive END;
		
	DECLARE @TBL_RES TABLE
	(
		[EDIReceiverID] INT NOT NULL 
		, [EDIReceiverCode] NVARCHAR(15) NOT NULL
		, [AuthQual] NVARCHAR(150) NOT NULL 
		,[ApplicationReceiverCode] NVARCHAR(25) NOT NULL
		,[ApplicationSenderCode] NVARCHAR(25) NOT NULL
		--,[ReceiverID]  NVARCHAR(25) NOT NULL
		, [IsActive] BIT NOT NULL 
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		[EDIReceiver].[EDIReceiverID]
		, [EDIReceiver].[EDIReceiverCode]
		, ([AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] + ' [' + [AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] + ']') as AuthQual
		,[EDIReceiver].[ApplicationReceiverCode]
		,[EDIReceiver].[ApplicationSenderCode]
		--,[EDIReceiver].[ReceiverID]
		, [EDIReceiver].[IsActive]
	FROM
		[EDIReceiver] WITH (NOLOCK)
		
		INNER JOIN
		
		[Transaction].[AuthorizationInformationQualifier]
		
		ON
		
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID] = [EDI].[EDIReceiver].[AuthorizationInformationQualifierID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EDIReceiver].[EDIReceiverID]
	
		
	ORDER BY
		[ID]
	ASC;
	
	
	SELECT * FROM @TBL_RES;

	-- EXEC [EDI].[usp_GetBySearch_EDIReceiver]
	-- EXEC [EDI].[usp_GetBySearch_EDIReceiver] @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintPin]    Script Date: 07/18/2013 11:20:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_PrintPin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_PrintPin]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintPin]    Script Date: 07/18/2013 11:20:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [EDI].[usp_GetBySearch_PrintPin]
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
		[EDI].[PrintPin].[PrintPinID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PrintPinName' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[PrintPinName] END ASC,
				CASE WHEN @orderByField = 'PrintPinName' AND @orderByDirection = 'D' THEN [EDI].[PrintPin].[PrintPinName] END DESC,
				
				CASE WHEN @OrderByField = 'PrintPinCode' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[PrintPinCode] END ASC,
				CASE WHEN @orderByField = 'PrintPinCode' AND @orderByDirection = 'D' THEN [EDI].[PrintPin].[PrintPinCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[PrintPin].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[PrintPin]
	WHERE
		[EDI].[PrintPin].[PrintPinName] LIKE @StartBy + '%' 
	AND
	(
		[EDI].[PrintPin].[PrintPinName] LIKE '%' + @SearchName + '%' 
	OR
		[EDI].[PrintPin].[PrintPinCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[EDI].[PrintPin].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintPin].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[PrintPin].[PrintPinID], [PrintPin].[PrintPinCode], [PrintPin].[PrintPinName], [PrintPin].[IsActive]
	FROM
		[PrintPin] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PrintPin].[PrintPinID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [EDI].[usp_GetBySearch_PrintPin] @SearchName  = '45'
	-- EXEC [EDI].[usp_GetBySearch_PrintPin] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintSign]    Script Date: 07/18/2013 11:20:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EDI].[usp_GetBySearch_PrintSign]') AND type in (N'P', N'PC'))
DROP PROCEDURE [EDI].[usp_GetBySearch_PrintSign]
GO


/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintSign]    Script Date: 07/18/2013 11:20:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [EDI].[usp_GetBySearch_PrintSign]
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
		[EDI].[PrintSign].[PrintSignID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PrintSignName' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[PrintSignName] END ASC,
				CASE WHEN @orderByField = 'PrintSignName' AND @orderByDirection = 'D' THEN [EDI].[PrintSign].[PrintSignName] END DESC,
				
				CASE WHEN @OrderByField = 'PrintSignCode' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[PrintSignCode] END ASC,
				CASE WHEN @orderByField = 'PrintSignCode' AND @orderByDirection = 'D' THEN [EDI].[PrintSign].[PrintSignCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[PrintSign].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[PrintSign]
	WHERE
		[EDI].[PrintSign].[PrintSignName] LIKE @StartBy + '%' 
	AND
	(
		[EDI].[PrintSign].[PrintSignName] LIKE '%' + @SearchName + '%' 
	OR
		[EDI].[PrintSign].[PrintSignCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[EDI].[PrintSign].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintSign].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[PrintSign].[PrintSignID], [PrintSign].[PrintSignCode], [PrintSign].[PrintSignName], [PrintSign].[IsActive]
	FROM
		[PrintSign] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PrintSign].[PrintSignID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [EDI].[usp_GetBySearch_PrintSign] @SearchName  = '45'
	-- EXEC [EDI].[usp_GetBySearch_PrintSign] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Insurance]    Script Date: 07/18/2013 11:21:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Insurance].[usp_GetBySearch_Insurance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Insurance].[usp_GetBySearch_Insurance]
GO


/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Insurance]    Script Date: 07/18/2013 11:21:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Insurance].[usp_GetBySearch_Insurance]
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
		[Insurance].[Insurance].[InsuranceID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'InsuranceName' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[InsuranceName] END ASC,
				CASE WHEN @orderByField = 'InsuranceName' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[InsuranceName] END DESC,
				
				CASE WHEN @OrderByField = 'InsuranceCode' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[InsuranceCode] END ASC,
				CASE WHEN @orderByField = 'InsuranceCode' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[InsuranceCode] END DESC,
				
				CASE WHEN @OrderByField = 'EDIReceiver' AND @OrderByDirection = 'A' THEN (EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' ) END ASC,
				CASE WHEN @orderByField = 'EDIReceiver' AND @orderByDirection = 'D' THEN (EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' ) END DESC,
				
				CASE WHEN @OrderByField = 'PayerID' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[PayerID] END ASC,
				CASE WHEN @orderByField = 'PayerID' AND @orderByDirection = 'D' THEN [Insurance].[Insurance].[PayerID] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Insurance].[Insurance].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Insurance].[Insurance].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Insurance].[Insurance]
		
		INNER JOIN
		
		[Insurance].[InsuranceType]
		
		ON
		
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
		
		INNER JOIN
		
		[EDI].[EDIReceiver]
		
		ON
		
		[EDI].[EDIReceiver].[EDIReceiverID] = [Insurance].[Insurance].[EDIReceiverID]
		
		
		
	WHERE
		[Insurance].[Insurance].[InsuranceName] LIKE @StartBy + '%' 
	AND
	(
		[Insurance].[Insurance].[InsuranceName] LIKE '%' + @SearchName + '%' 
	OR
		[Insurance].[Insurance].[InsuranceCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Insurance].[Insurance].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Insurance].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Insurance].[InsuranceID], [Insurance].[InsuranceName], [Insurance].[InsuranceCode],[Insurance].[PayerID],(EDIReceiver.EDIReceiverName +' [' + EDIReceiver.EDIReceiverCode + ']' )as EDIReceiver ,[Insurance].[IsActive]
	FROM
		[Insurance] WITH (NOLOCK)
		
		INNER JOIN
		
		[Insurance].[InsuranceType]
		
		ON
		
		[Insurance].[InsuranceType].[InsuranceTypeID] = [Insurance].[Insurance].[InsuranceTypeID]
		
		INNER JOIN
		
		[EDI].[EDIReceiver]
		
		ON
		
		[EDI].[EDIReceiver].[EDIReceiverID] = [Insurance].[Insurance].[EDIReceiverID]
		
	INNER JOIN
	
		@SEARCH_TMP
	ON
		[PK_ID] = [Insurance].[InsuranceID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Insurance].[usp_GetBySearch_Insurance] @SearchName  = '45'
	-- EXEC [Insurance].[usp_GetBySearch_Insurance] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Relationship]    Script Date: 07/18/2013 11:22:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Insurance].[usp_GetBySearch_Relationship]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Insurance].[usp_GetBySearch_Relationship]
GO


/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Relationship]    Script Date: 07/18/2013 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Insurance].[usp_GetBySearch_Relationship]
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
		[Insurance].[Relationship].[RelationshipID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'RelationshipName' AND @OrderByDirection = 'A' THEN [Insurance].[Relationship].[RelationshipName] END ASC,
				CASE WHEN @orderByField = 'RelationshipName' AND @orderByDirection = 'D' THEN [Insurance].[Relationship].[RelationshipName] END DESC,
				
				CASE WHEN @OrderByField = 'RelationshipCode' AND @OrderByDirection = 'A' THEN [Insurance].[Relationship].[RelationshipCode] END ASC,
				CASE WHEN @orderByField = 'RelationshipCode' AND @orderByDirection = 'D' THEN [Insurance].[Relationship].[RelationshipCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Insurance].[Relationship].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Insurance].[Relationship].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Insurance].[Relationship]
	WHERE
		[Insurance].[Relationship].[RelationshipName] LIKE @StartBy + '%' 
	AND
	(
		[Insurance].[Relationship].[RelationshipName] LIKE '%' + @SearchName + '%' 
	OR
		[Insurance].[Relationship].[RelationshipCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Insurance].[Relationship].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Insurance].[Relationship].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Relationship].[RelationshipID], [Relationship].[RelationshipCode], [Relationship].[RelationshipName], [Relationship].[IsActive]
	FROM
		[Relationship] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Relationship].[RelationshipID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Insurance].[usp_GetBySearch_Relationship] @SearchName  = '45'
	-- EXEC [Insurance].[usp_GetBySearch_Relationship] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END





GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_City]    Script Date: 07/18/2013 11:22:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_City]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_City]
GO


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_City]    Script Date: 07/18/2013 11:22:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_ClaimStatus]    Script Date: 07/18/2013 11:23:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_ClaimStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_ClaimStatus]
GO

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_ClaimStatus]    Script Date: 07/18/2013 11:23:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





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
		[MasterData].[ClaimStatus]
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_Country]    Script Date: 07/18/2013 11:23:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_Country]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_Country]
GO


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_Country]    Script Date: 07/18/2013 11:23:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [MasterData].[usp_GetBySearch_Country]
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
		[MasterData].[Country].[CountryID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CountryName' AND @OrderByDirection = 'A' THEN [MasterData].[Country].[CountryName] END ASC,
				CASE WHEN @orderByField = 'CountryName' AND @orderByDirection = 'D' THEN [MasterData].[Country].[CountryName] END DESC,
						
				CASE WHEN @OrderByField = 'CountryCode' AND @OrderByDirection = 'A' THEN [MasterData].[Country].[CountryCode] END ASC,
				CASE WHEN @orderByField = 'CountryCode' AND @orderByDirection = 'D' THEN [MasterData].[Country].[CountryCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[Country].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[Country].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[MasterData].[Country]
	WHERE
		[MasterData].[Country].[CountryName] LIKE @StartBy + '%' 
	AND
	(
		[MasterData].[Country].[CountryName] LIKE '%' + @SearchName + '%' 
	OR
		[MasterData].[Country].[CountryCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[MasterData].[Country].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[Country].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Country].[CountryID], [Country].[CountryCode], [Country].[CountryName], [Country].[IsActive]
	FROM
		[Country] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Country].[CountryID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [MasterData].[usp_GetBySearch_Country] @SearchName  = '36'
	-- EXEC [MasterData].[usp_GetBySearch_Country] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_County]    Script Date: 07/18/2013 11:23:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_County]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_County]
GO

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_County]    Script Date: 07/18/2013 11:23:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [MasterData].[usp_GetBySearch_County]
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
		[MasterData].[County].[CountyID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CountyName' AND @OrderByDirection = 'A' THEN [MasterData].[County].[CountyName] END ASC,
				CASE WHEN @orderByField = 'CountyName' AND @orderByDirection = 'D' THEN [MasterData].[County].[CountyName] END DESC,
						
				CASE WHEN @OrderByField = 'CountyCode' AND @OrderByDirection = 'A' THEN [MasterData].[County].[CountyCode] END ASC,
				CASE WHEN @orderByField = 'CountyCode' AND @orderByDirection = 'D' THEN [MasterData].[County].[CountyCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[County].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[County].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[MasterData].[County] WITH (NOLOCK)
	WHERE
		[MasterData].[County].[CountyName] LIKE @StartBy + '%' 
	AND
	(
		[MasterData].[County].[CountyName] LIKE '%' + @SearchName + '%' 
	OR
		[MasterData].[County].[CountyCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[MasterData].[County].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[County].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[County].[CountyID], [County].[CountyCode], [County].[CountyName], [County].[IsActive]
	FROM
		[County] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [County].[CountyID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [MasterData].[usp_GetBySearch_County] @SearchName  = '36'
	-- EXEC [MasterData].[usp_GetBySearch_County] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END



GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_DocumentCategory]    Script Date: 07/18/2013 11:24:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_DocumentCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_DocumentCategory]
GO


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_DocumentCategory]    Script Date: 07/18/2013 11:24:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [MasterData].[usp_GetBySearch_DocumentCategory]	
	@OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
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
		[MasterData].[DocumentCategory].[DocumentCategoryID]
		, ROW_NUMBER() OVER (
			ORDER BY						
				CASE WHEN @OrderByField = 'DocumentCategoryCode' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryCode] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryCode' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryCode] END DESC,
				
				CASE WHEN @OrderByField = 'DocumentCategoryName' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END ASC,
				CASE WHEN @orderByField = 'DocumentCategoryName' AND @orderByDirection = 'D' THEN [MasterData].[DocumentCategory].[DocumentCategoryName] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[DocumentCategory].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[DocumentCategory].[LastModifiedOn] END DESC			
			) AS ROW_NUM
	FROM
		[MasterData].[DocumentCategory] WITH (NOLOCK)
	WHERE
		[MasterData].[DocumentCategory].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[DocumentCategory].[IsActive] ELSE @IsActive END;
		
	DECLARE @TBL_RES TABLE
	(
		[DocumentCategoryID] INT NOT NULL 
		, [DocumentCategoryCode] NVARCHAR(2) NOT NULL
		, [DocumentCategoryName] NVARCHAR(150) NOT NULL 
		, [IsActive] BIT NOT NULL 
	);

	INSERT INTO
		@TBL_RES
	SELECT		
		[DocumentCategory].[DocumentCategoryID]
		, [DocumentCategory].[DocumentCategoryCode]
		, [DocumentCategory].[DocumentCategoryName]
		, [DocumentCategory].[IsActive]
	FROM
		[DocumentCategory] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [DocumentCategory].[DocumentCategoryID]
	ORDER BY
		[ID]
	ASC;
	
	
	SELECT * FROM @TBL_RES;

	-- EXEC [MasterData].[usp_GetBySearch_DocumentCategory]
	-- EXEC [MasterData].[usp_GetBySearch_DocumentCategory] @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END


GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_State]    Script Date: 07/18/2013 11:24:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MasterData].[usp_GetBySearch_State]') AND type in (N'P', N'PC'))
DROP PROCEDURE [MasterData].[usp_GetBySearch_State]
GO


/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_State]    Script Date: 07/18/2013 11:24:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [MasterData].[usp_GetBySearch_State]
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
		[MasterData].[State].[StateID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'StateName' AND @OrderByDirection = 'A' THEN [MasterData].[State].[StateName] END ASC,
				CASE WHEN @orderByField = 'StateName' AND @orderByDirection = 'D' THEN [MasterData].[State].[StateName] END DESC,
						
				CASE WHEN @OrderByField = 'StateCode' AND @OrderByDirection = 'A' THEN [MasterData].[State].[StateCode] END ASC,
				CASE WHEN @orderByField = 'StateCode' AND @orderByDirection = 'D' THEN [MasterData].[State].[StateCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [MasterData].[State].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [MasterData].[State].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[MasterData].[State]
	WHERE
		[MasterData].[State].[StateName] LIKE @StartBy + '%' 
	AND
	(
		[MasterData].[State].[StateName] LIKE '%' + @SearchName + '%' 
	OR
		[MasterData].[State].[StateCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[MasterData].[State].[IsActive] = CASE WHEN @IsActive IS NULL THEN [MasterData].[State].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[State].[StateID], [State].[StateCode], [State].[StateName], [State].[IsActive]
	FROM
		[State] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [State].[StateID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [MasterData].[usp_GetBySearch_State] @SearchName  = '36'
	-- EXEC [MasterData].[usp_GetBySearch_State] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientVisit]    Script Date: 07/18/2013 11:44:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearch_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearch_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetBySearch_PatientVisit]    Script Date: 07/18/2013 11:44:09 ******/
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
		[Patient].[Patient].[ClinicID] = @ClinicID
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetBySearchCase_PatientVisit]    Script Date: 07/18/2013 12:17:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetBySearchCase_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetBySearchCase_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetBySearchCase_PatientVisit]    Script Date: 07/18/2013 12:17:47 ******/
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
			[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
		INNER JOIN
	    [User].[UserClinic]
	     ON
	    [Patient].[Patient].[ClinicID] = [User].[UserClinic].[ClinicID]	
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
		
		  [User].[UserClinic].[UserID] = @UserID
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		AND
		    [User].[UserClinic].[IsActive] = 1;	
		    
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
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1
	-- EXEC [Patient].[usp_GetBySearchCase_PatientVisit] @UserID = 1
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier]    Script Date: 07/18/2013 11:27:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_AuthorizationInformationQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier]
GO



/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier]    Script Date: 07/18/2013 11:27:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier]
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
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'AuthorizationInformationQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] END ASC,
				CASE WHEN @orderByField = 'AuthorizationInformationQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'AuthorizationInformationQualifierCode' AND @OrderByDirection = 'A' THEN [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] END ASC,
				CASE WHEN @orderByField = 'AuthorizationInformationQualifierCode' AND @orderByDirection = 'D' THEN [Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[AuthorizationInformationQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[AuthorizationInformationQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[AuthorizationInformationQualifier]
	WHERE
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[AuthorizationInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[AuthorizationInformationQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[AuthorizationInformationQualifier].[AuthorizationInformationQualifierID], [AuthorizationInformationQualifier].[AuthorizationInformationQualifierCode], [AuthorizationInformationQualifier].[AuthorizationInformationQualifierName], [AuthorizationInformationQualifier].[IsActive]
	FROM
		[AuthorizationInformationQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [AuthorizationInformationQualifier].[AuthorizationInformationQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_AuthorizationInformationQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_ClaimMedia]    Script Date: 07/18/2013 11:27:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_ClaimMedia]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_ClaimMedia]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_ClaimMedia]    Script Date: 07/18/2013 11:27:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





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
		[Transaction].[ClaimMedia]
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]    Script Date: 07/18/2013 11:28:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_CommunicationNumberQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]    Script Date: 07/18/2013 11:28:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]
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
		[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CommunicationNumberQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName] END ASC,
				CASE WHEN @orderByField = 'CommunicationNumberQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'CommunicationNumberQualifierCode' AND @OrderByDirection = 'A' THEN [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierCode] END ASC,
				CASE WHEN @orderByField = 'CommunicationNumberQualifierCode' AND @orderByDirection = 'D' THEN [Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[CommunicationNumberQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[CommunicationNumberQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[CommunicationNumberQualifier]
	WHERE
		[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[CommunicationNumberQualifier].[CommunicationNumberQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[CommunicationNumberQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[CommunicationNumberQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[CommunicationNumberQualifier].[CommunicationNumberQualifierID], [CommunicationNumberQualifier].[CommunicationNumberQualifierCode], [CommunicationNumberQualifier].[CommunicationNumberQualifierName], [CommunicationNumberQualifier].[IsActive]
	FROM
		[CommunicationNumberQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [CommunicationNumberQualifier].[CommunicationNumberQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_CommunicationNumberQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_CommunicationNumberQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CurrencyCode]    Script Date: 07/18/2013 11:28:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_CurrencyCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_CurrencyCode]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CurrencyCode]    Script Date: 07/18/2013 11:28:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Transaction].[usp_GetBySearch_CurrencyCode]
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
		[Transaction].[CurrencyCode].[CurrencyCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'CurrencyCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[CurrencyCodeName] END ASC,
				CASE WHEN @orderByField = 'CurrencyCodeName' AND @orderByDirection = 'D' THEN [Transaction].[CurrencyCode].[CurrencyCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'CurrencyCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[CurrencyCodeCode] END ASC,
				CASE WHEN @orderByField = 'CurrencyCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[CurrencyCode].[CurrencyCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[CurrencyCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[CurrencyCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[CurrencyCode]
	WHERE
		[Transaction].[CurrencyCode].[CurrencyCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[CurrencyCode].[CurrencyCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[CurrencyCode].[CurrencyCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[CurrencyCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[CurrencyCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[CurrencyCode].[CurrencyCodeID], [CurrencyCode].[CurrencyCodeCode], [CurrencyCode].[CurrencyCodeName], [CurrencyCode].[IsActive]
	FROM
		[CurrencyCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [CurrencyCode].[CurrencyCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_CurrencyCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_CurrencyCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_EntityIdentifierCode]    Script Date: 07/18/2013 11:28:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_EntityIdentifierCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_EntityIdentifierCode]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_EntityIdentifierCode]    Script Date: 07/18/2013 11:28:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Transaction].[usp_GetBySearch_EntityIdentifierCode]
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
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'EntityIdentifierCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] END ASC,
				CASE WHEN @orderByField = 'EntityIdentifierCodeName' AND @orderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'EntityIdentifierCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] END ASC,
				CASE WHEN @orderByField = 'EntityIdentifierCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[EntityIdentifierCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[EntityIdentifierCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[EntityIdentifierCode]
	WHERE
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[EntityIdentifierCode].[EntityIdentifierCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[EntityIdentifierCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityIdentifierCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[EntityIdentifierCode].[EntityIdentifierCodeID], [EntityIdentifierCode].[EntityIdentifierCodeCode], [EntityIdentifierCode].[EntityIdentifierCodeName], [EntityIdentifierCode].[IsActive]
	FROM
		[EntityIdentifierCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EntityIdentifierCode].[EntityIdentifierCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_EntityIdentifierCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_EntityIdentifierCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_EntityTypeQualifier]    Script Date: 07/18/2013 11:29:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_EntityTypeQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_EntityTypeQualifier]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_EntityTypeQualifier]    Script Date: 07/18/2013 11:29:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Transaction].[usp_GetBySearch_EntityTypeQualifier]
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
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'EntityTypeQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END ASC,
				CASE WHEN @orderByField = 'EntityTypeQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'ZipCode' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode] END ASC,
				CASE WHEN @orderByField = 'ZipCode' AND @orderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[EntityTypeQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[EntityTypeQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[EntityTypeQualifier]
	WHERE
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[EntityTypeQualifier].[EntityTypeQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[EntityTypeQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[EntityTypeQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[EntityTypeQualifier].[EntityTypeQualifierID], [EntityTypeQualifier].[EntityTypeQualifierCode], [EntityTypeQualifier].[EntityTypeQualifierName], [EntityTypeQualifier].[IsActive]
	FROM
		[EntityTypeQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [EntityTypeQualifier].[EntityTypeQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_EntityTypeQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_EntityTypeQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END




GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_InterchangeIDQualifier]    Script Date: 07/18/2013 11:29:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_InterchangeIDQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_InterchangeIDQualifier]
GO



/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_InterchangeIDQualifier]    Script Date: 07/18/2013 11:29:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Transaction].[usp_GetBySearch_InterchangeIDQualifier]
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
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'InterchangeIDQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] END ASC,
				CASE WHEN @orderByField = 'InterchangeIDQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'InterchangeIDQualifierCode' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] END ASC,
				CASE WHEN @orderByField = 'InterchangeIDQualifierCode' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeIDQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[InterchangeIDQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[InterchangeIDQualifier]
	WHERE
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[InterchangeIDQualifier].[InterchangeIDQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[InterchangeIDQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeIDQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[InterchangeIDQualifier].[InterchangeIDQualifierID], [InterchangeIDQualifier].[InterchangeIDQualifierCode], [InterchangeIDQualifier].[InterchangeIDQualifierName], [InterchangeIDQualifier].[IsActive]
	FROM
		[InterchangeIDQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [InterchangeIDQualifier].[InterchangeIDQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeIDQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeIDQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_InterchangeUsageIndicator]    Script Date: 07/18/2013 11:29:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_InterchangeUsageIndicator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_InterchangeUsageIndicator]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_InterchangeUsageIndicator]    Script Date: 07/18/2013 11:29:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Transaction].[usp_GetBySearch_InterchangeUsageIndicator]
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
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'InterchangeUsageIndicatorName' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] END ASC,
				CASE WHEN @orderByField = 'InterchangeUsageIndicatorName' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] END DESC,
				
				CASE WHEN @OrderByField = 'InterchangeUsageIndicatorCode' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] END ASC,
				CASE WHEN @orderByField = 'InterchangeUsageIndicatorCode' AND @orderByDirection = 'D' THEN [Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[InterchangeUsageIndicator].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[InterchangeUsageIndicator].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[InterchangeUsageIndicator]
	WHERE
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[InterchangeUsageIndicator].[InterchangeUsageIndicatorCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[InterchangeUsageIndicator].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[InterchangeUsageIndicator].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[InterchangeUsageIndicator].[InterchangeUsageIndicatorID], [InterchangeUsageIndicator].[InterchangeUsageIndicatorCode], [InterchangeUsageIndicator].[InterchangeUsageIndicatorName], [InterchangeUsageIndicator].[IsActive]
	FROM
		[InterchangeUsageIndicator] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [InterchangeUsageIndicator].[InterchangeUsageIndicatorID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeUsageIndicator] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_InterchangeUsageIndicator] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode]    Script Date: 07/18/2013 11:30:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode]    Script Date: 07/18/2013 11:30:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode]
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
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PayerResponsibilitySequenceNumberCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName] END ASC,
				CASE WHEN @orderByField = 'PayerResponsibilitySequenceNumberCodeName' AND @orderByDirection = 'D' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'PayerResponsibilitySequenceNumberCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode] END ASC,
				CASE WHEN @orderByField = 'PayerResponsibilitySequenceNumberCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[PayerResponsibilitySequenceNumberCode]
	WHERE
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[PayerResponsibilitySequenceNumberCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID], [PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeCode], [PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeName], [PayerResponsibilitySequenceNumberCode].[IsActive]
	FROM
		[PayerResponsibilitySequenceNumberCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PayerResponsibilitySequenceNumberCode].[PayerResponsibilitySequenceNumberCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_PayerResponsibilitySequenceNumberCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END







GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_SecurityInformationQualifier]    Script Date: 07/18/2013 11:30:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_SecurityInformationQualifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_SecurityInformationQualifier]
GO



/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_SecurityInformationQualifier]    Script Date: 07/18/2013 11:30:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Transaction].[usp_GetBySearch_SecurityInformationQualifier]
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
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'SecurityInformationQualifierName' AND @OrderByDirection = 'A' THEN [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName] END ASC,
				CASE WHEN @orderByField = 'SecurityInformationQualifierName' AND @orderByDirection = 'D' THEN [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName] END DESC,
				
				CASE WHEN @OrderByField = 'SecurityInformationQualifierCode' AND @OrderByDirection = 'A' THEN [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode] END ASC,
				CASE WHEN @orderByField = 'SecurityInformationQualifierCode' AND @orderByDirection = 'D' THEN [Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[SecurityInformationQualifier].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[SecurityInformationQualifier].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[SecurityInformationQualifier]
	WHERE
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[SecurityInformationQualifier].[SecurityInformationQualifierCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[SecurityInformationQualifier].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[SecurityInformationQualifier].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[SecurityInformationQualifier].[SecurityInformationQualifierID], [SecurityInformationQualifier].[SecurityInformationQualifierCode], [SecurityInformationQualifier].[SecurityInformationQualifierName], [SecurityInformationQualifier].[IsActive]
	FROM
		[SecurityInformationQualifier] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [SecurityInformationQualifier].[SecurityInformationQualifierID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_SecurityInformationQualifier] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_SecurityInformationQualifier] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]    Script Date: 07/18/2013 11:30:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_TransactionSetPurposeCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]    Script Date: 07/18/2013 11:30:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]
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
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'TransactionSetPurposeCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName] END ASC,
				CASE WHEN @orderByField = 'TransactionSetPurposeCodeName' AND @orderByDirection = 'D' THEN [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'TransactionSetPurposeCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode] END ASC,
				CASE WHEN @orderByField = 'TransactionSetPurposeCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionSetPurposeCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[TransactionSetPurposeCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[TransactionSetPurposeCode]
	WHERE
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[TransactionSetPurposeCode].[TransactionSetPurposeCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[TransactionSetPurposeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionSetPurposeCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[TransactionSetPurposeCode].[TransactionSetPurposeCodeID], [TransactionSetPurposeCode].[TransactionSetPurposeCodeCode], [TransactionSetPurposeCode].[TransactionSetPurposeCodeName], [TransactionSetPurposeCode].[IsActive]
	FROM
		[TransactionSetPurposeCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [TransactionSetPurposeCode].[TransactionSetPurposeCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_TransactionSetPurposeCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_TransactionSetPurposeCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_TransactionTypeCode]    Script Date: 07/18/2013 11:33:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Transaction].[usp_GetBySearch_TransactionTypeCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Transaction].[usp_GetBySearch_TransactionTypeCode]
GO


/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_TransactionTypeCode]    Script Date: 07/18/2013 11:33:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Transaction].[usp_GetBySearch_TransactionTypeCode]
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
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'TransactionTypeCodeName' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionTypeCode].[TransactionTypeCodeName] END ASC,
				CASE WHEN @orderByField = 'TransactionTypeCodeName' AND @orderByDirection = 'D' THEN [Transaction].[TransactionTypeCode].[TransactionTypeCodeName] END DESC,
				
				CASE WHEN @OrderByField = 'TransactionTypeCodeCode' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode] END ASC,
				CASE WHEN @orderByField = 'TransactionTypeCodeCode' AND @orderByDirection = 'D' THEN [Transaction].[TransactionTypeCode].[TransactionTypeCodeCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Transaction].[TransactionTypeCode].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Transaction].[TransactionTypeCode].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Transaction].[TransactionTypeCode]
	WHERE
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeName] LIKE @StartBy + '%' 
	AND
	(
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeName] LIKE '%' + @SearchName + '%' 
	OR
		[Transaction].[TransactionTypeCode].[TransactionTypeCodeCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Transaction].[TransactionTypeCode].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Transaction].[TransactionTypeCode].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[TransactionTypeCode].[TransactionTypeCodeID], [TransactionTypeCode].[TransactionTypeCodeCode], [TransactionTypeCode].[TransactionTypeCodeName], [TransactionTypeCode].[IsActive]
	FROM
		[TransactionTypeCode] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [TransactionTypeCode].[TransactionTypeCodeID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Transaction].[usp_GetBySearch_TransactionTypeCode] @SearchName  = '45'
	-- EXEC [Transaction].[usp_GetBySearch_TransactionTypeCode] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetBySearch_User]    Script Date: 07/18/2013 11:34:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetBySearch_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetBySearch_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetBySearch_User]    Script Date: 07/18/2013 11:34:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [User].[usp_GetBySearch_User]
	  @SelHighRoleID TINYINT
	, @ManagerRoleID TINYINT
	, @SelManagerID INT = NULL
	, @SearchName NVARCHAR(150) = NULL
	, @StartBy NVARCHAR(1) = NULL
	, @CurrPageNumber BIGINT = 1
	, @RecordsPerPage SMALLINT = 200
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @SearchName IS NULL
	BEGIN
		SET @SearchName = '';
	END
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
	
	DECLARE @USER_TMP TABLE
	(
		[USER_ID] INT NOT NULL
	);
		
	IF @SelHighRoleID <= @ManagerRoleID
	BEGIN
		SELECT @SelManagerID = NULL;
	
		INSERT INTO
			@USER_TMP
		SELECT 
			[User].[UserRole].[UserID]
		FROM 
			[User].[UserRole] WITH (NOLOCK)
		WHERE
			[User].[UserRole].[RoleID] = @SelHighRoleID
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
					[User].[UserRole] WITH (NOLOCK)
				WHERE
					[User].[UserRole].[RoleID] < @SelHighRoleID
				AND
					[User].[UserRole].[IsActive] = 1
			)
		OR
			[USER_ID] IN
			(
				SELECT 
					[User].[User].[UserID]
				FROM 
					[User].[User] WITH (NOLOCK)
				WHERE
					[User].[User].[ManagerID] IS NOT NULL
				AND
					[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
			);
	END
	ELSE
	BEGIN	
		INSERT INTO
			@USER_TMP
		SELECT 
			[User].[UserRole].[UserID]
		FROM 
			[User].[UserRole] WITH (NOLOCK)
		WHERE
			[User].[UserRole].[RoleID] >= @SelHighRoleID
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
					[User].[UserRole] WITH (NOLOCK)
				WHERE
					[User].[UserRole].[RoleID] < @SelHighRoleID
				AND
					[User].[UserRole].[IsActive] = 1
			)
		OR
			[USER_ID] IN
			(
				SELECT 
					[User].[User].[UserID]
				FROM 
					[User].[User] WITH (NOLOCK)
				WHERE
					[User].[User].[ManagerID] IS NULL
				AND
					[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
			);
			
		IF @SelManagerID IS NOT NULL
		BEGIN
			DELETE FROM
				@USER_TMP
			WHERE
				[USER_ID] IN
				(
					SELECT 
						[User].[User].[UserID]
					FROM 
						[User].[User] WITH (NOLOCK)
					WHERE
						[User].[User].[ManagerID] <> @SelManagerID
					AND
						[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
				);
		END
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
		[User].[User].[UserID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Name' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) END ASC,
				CASE WHEN @orderByField = 'Name' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) END DESC,

				CASE WHEN @OrderByField = 'Email' AND @OrderByDirection = 'A' THEN [User].[User].[Email] END ASC,
				CASE WHEN @orderByField = 'Email' AND @orderByDirection = 'D' THEN [User].[User].[Email] END DESC,				
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [User].[User].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [User].[User].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[User].[User] WITH (NOLOCK)
	WHERE
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE @StartBy + '%'
	AND
	(
			[User].[User].[Email] LIKE '%' + @SearchName + '%'	    
	    OR	    
			(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) LIKE '%' + @SearchName + '%'
	)
	AND
		[User].[User].[UserID] IN
		(
			SELECT 
				[USER_ID]
			FROM 
				@USER_TMP
		) 
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT		
		[User].[UserID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) AS [Name]
		, [User].[Email]
		, [User].[IsActive]
		, [User].[User].[ManagerID]
	FROM
		[User] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [User].[UserID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 3, @ManagerRoleID = 2
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 3, @ManagerRoleID = 2, @SelManagerID = 48
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 2, @ManagerRoleID = 2
	-- EXEC [User].[usp_GetBySearch_User] @SelHighRoleID = 2, @ManagerRoleID = 2, @SelManagerID = 48
	
END




GO



----------------------------------------------------------------------
/****** Object:  StoredProcedure [Audit].[usp_GetDoneStatus_SyncStatus]    Script Date: 07/18/2013 11:35:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetDoneStatus_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetDoneStatus_SyncStatus]
GO

----------------------------------------------------------------------


/****** Object:  StoredProcedure [Audit].[usp_GetLastStatus_SyncStatus]    Script Date: 07/18/2013 11:36:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetLastStatus_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetLastStatus_SyncStatus]
GO


/****** Object:  StoredProcedure [Audit].[usp_GetLastStatus_SyncStatus]    Script Date: 07/18/2013 11:36:19 ******/
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Audit].[usp_GetLastSuccStatus_SyncStatus]    Script Date: 07/18/2013 11:36:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Audit].[usp_GetLastSuccStatus_SyncStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Audit].[usp_GetLastSuccStatus_SyncStatus]
GO



/****** Object:  StoredProcedure [Audit].[usp_GetLastSuccStatus_SyncStatus]    Script Date: 07/18/2013 11:36:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [Audit].[usp_GetLastSuccStatus_SyncStatus] 
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT 
		TOP 1 [S].[SyncStatusID]
		, [S].[StartOn]
	FROM 
		[Audit].[SyncStatus] S WITH (NOLOCK)
	WHERE
		[S].[IsSuccess] = 1
	ORDER BY 
		[S].[SyncStatusID] 
	DESC;
			
	-- EXEC [Audit].[usp_GetLastSuccStatus_SyncStatus] 
	-- EXEC [Audit].[usp_GetLastSuccStatus_SyncStatus] 
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 07/18/2013 12:18:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZCase_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZCase_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZCase_PatientVisit]    Script Date: 07/18/2013 12:18:17 ******/
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
	INNER JOIN
	    [User].[UserClinic]
	ON
	    [Patient].[Patient].[ClinicID] = [User].[UserClinic].[ClinicID]	
	WHERE
		
			[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
		AND
		
		  [User].[UserClinic].[UserID] = @UserID
		 AND
			(
				[Patient].[Patient].[ChartNumber] LIKE '%' + @SearchName + '%' 
			OR
				(LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) LIKE '%' + @SearchName + '%' 
			OR
				[Patient].[PatientVisit].[PatientVisitID] =  @PatientVisitID
			)
		AND
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1
		AND
		    [User].[UserClinic].[IsActive] = 1;	
		
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



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetNameByPatientVisitID_Patient]    Script Date: 07/18/2013 14:47:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetNameByPatientVisitID_Patient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetNameByPatientVisitID_Patient]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetNameByPatientVisitID_Patient]    Script Date: 07/18/2013 14:47:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- Select the particular record

CREATE PROCEDURE [Patient].[usp_GetNameByPatientVisitID_Patient] 
	@PatientVisitID	BIGINT
	, @IsActive	BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_RES TABLE
	(
		[PatientID] BIGINT NOT NULL 
		, [NAME_CODE] NVARCHAR(500) NOT NULL
		, [CLINIC_ID] INT NOT NULL
		, [CLINIC_NAME_CODE] NVARCHAR(500) NOT NULL
		
	);

	INSERT INTO
		@TBL_RES
	SELECT
		[Patient].[PatientVisit].[PatientID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL([Patient].[Patient].[MiddleName], '') + ' [' + [Patient].[Patient].[ChartNumber] + ']'))) AS [NAME_CODE]
		, [Patient].[Patient].[ClinicID]
		, [Billing].[Clinic].[ClinicName] + ' [' + [Billing].[Clinic].[ClinicCode] +']'
	FROM
		[Patient].[PatientVisit] WITH (NOLOCK)
	INNER JOIN
		[Patient].[Patient] WITH (NOLOCK)
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		[Billing].[Clinic]
	ON
		[Patient].[Patient].[ClinicID] = [Billing].[Clinic].[ClinicID]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[Patient].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[Patient].[IsActive] ELSE @IsActive END
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END;

	SELECT * FROM @TBL_RES;
	
	-- EXEC [Patient].[usp_GetNameByPatientVisitID_Patient] 81, NULL

END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/18/2013 14:59:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]
GO


----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportClinicDate_PatientVisit]    Script Date: 07/23/2013 10:36:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportClinicDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportClinicDate_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportClinicDate_PatientVisit]    Script Date: 07/23/2013 10:36:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Patient].[usp_GetReportClinicDate_PatientVisit]	
     @ClinicID INT
     ,@DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Billing].[Clinic].[ClinicID] = @ClinicID
	AND
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
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC
	
	
	--EXEC [Patient].[usp_GetReportClinicDate_PatientVisit]	  @ClinicID = 1 , @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportClinicDate_PatientVisit]	
END

GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisit_PatientVisit]    Script Date: 07/18/2013 18:42:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseVisit_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseVisit_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisit_PatientVisit]    Script Date: 07/18/2013 18:42:18 ******/
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
				[Patient].[PatientVisit].[IsActive] = 1
			AND
				[Patient].[Patient].[IsActive] = 1;
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
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 07/18/2013 17:09:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetCommentByID_ClaimProcess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetCommentByID_ClaimProcess]
GO


/****** Object:  StoredProcedure [Claim].[usp_GetCommentByID_ClaimProcess]    Script Date: 07/18/2013 17:09:51 ******/
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
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] BIGINT IDENTITY (1, 1) NOT NULL
		, [USER_NAME_CODE] NVARCHAR(400) NOT NULL
		, [USER_COMMENTS] NVARCHAR(4000) NOT NULL
	);
	
	--
	
	INSERT INTO
		@TBL_ANS
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [USER_NAME_CODE] 
		, [Patient].[PatientVisit].[Comment] AS [USER_COMMENTS]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN 
		[User].[User]
	ON
		[Patient].[PatientVisit].[LastModifiedBy] = [User].[User].[UserID]
	WHERE
		@PatientVisitID = [Patient].[PatientVisit].[PatientVisitID]
	AND
		[Patient].[PatientVisit].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Patient].[PatientVisit].[IsActive] ELSE @IsActive END
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
	ORDER BY
		[Patient].[PatientVisit].[PatientVisitID]
	ASC;
	
	--
	
	INSERT INTO
		@TBL_ANS
	SELECT
		((LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL([User].[User].[MiddleName], '')))) + ' [' +[User].[User].[UserName] + ']') AS [USER_NAME_CODE] 
		, [Claim].[ClaimProcess].[Comment] AS [USER_COMMENTS]
	FROM
		[Claim].[ClaimProcess]
	INNER JOIN 
		[User].[User]
	ON
		[Claim].[ClaimProcess].[LastModifiedBy] = [User].[User].[UserID]
	WHERE
		@PatientVisitID = [Claim].[ClaimProcess].[PatientVisitID]
	AND
		[Claim].[ClaimProcess].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Claim].[ClaimProcess].[IsActive] ELSE @IsActive END
	AND
		[User].[User].[IsActive] = CASE WHEN @IsActive IS NULL THEN [User].[User].[IsActive] ELSE @IsActive END
	ORDER BY
		[Claim].[ClaimProcess].[ClaimProcessID]
	DESC;

	SELECT DISTINCT [USER_COMMENTS],[USER_NAME_CODE] FROM @TBL_ANS WHERE [USER_COMMENTS] NOT LIKE 'Status changed by automated job services%' ORDER BY 2;

	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 12500
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 1
	-- EXEC [Claim].[usp_GetCommentByID_ClaimProcess] 1, 0
END


GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByAZEDI_PatientVisit]    Script Date: 07/19/2013 11:12:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByAZEDI_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByAZEDI_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByAZEDI_PatientVisit]    Script Date: 07/19/2013 11:12:19 ******/
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
	, @IsActive BIT = NULL
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
		[ChartNumber] [nvarchar](25) NULL
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
	
	-- EXEC [Patient].[usp_GetByAZEDI_PatientVisit] @EDIFileID  = 502, @ClinicID = 17
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetByEDI_PatientVisit]    Script Date: 07/19/2013 10:57:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetByEDI_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetByEDI_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetByEDI_PatientVisit]    Script Date: 07/19/2013 10:57:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [Patient].[usp_GetByEDI_PatientVisit]
    @EDIFileID INT
    , @ClinicID INT
    , @DateFrom DATE = NULL
	, @DateTo DATE = NULL 
	, @SearchName NVARCHAR(150) = NULL
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
	SELECT
		[Patient].[PatientVisit].[PatientVisitID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PatName' AND @OrderByDirection = 'A' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))  END ASC,
				CASE WHEN @orderByField = 'PatName' AND @orderByDirection = 'D' THEN (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) END DESC,
						
				CASE WHEN @OrderByField = 'ChartNumber' AND @OrderByDirection = 'A' THEN [Patient].[Patient].[ChartNumber] END ASC,
				CASE WHEN @orderByField = 'ChartNumber' AND @orderByDirection = 'D' THEN [Patient].[Patient].[ChartNumber] END DESC,
				
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
		((LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], ''))))) LIKE @StartBy + '%' 
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
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[ID]
		, [PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[ChartNumber]
		, [PatientVisit].[DOS]
		, [PatientVisit].[PatientVisitComplexity]
		, [Patient].[ClinicID]
		, CAST('1' AS BIT) AS [AssignToMe]
	FROM
		[Patient].[PatientVisit]
	INNER JOIN
		[Patient].[Patient]
	ON
		[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PatientVisit].[PatientVisitID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Patient].[usp_GetByEDI_PatientVisit] @EDIFileID  = 3114, @ClinicID = 17
	-- EXEC [Patient].[usp_GetByEDI_PatientVisit] @SearchName  = 'ANDERSON', @StartBy = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
	-- EXEC [Patient].[usp_GetByEDI_PatientVisit] @EDIFileID  = 502 , @SearchName  = 'AUENSON CONSTANT A'
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Claim].[usp_GetByID_ClaimProcessEDIFile]    Script Date: 07/19/2013 11:24:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Claim].[usp_GetByID_ClaimProcessEDIFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Claim].[usp_GetByID_ClaimProcessEDIFile]
GO

/****** Object:  StoredProcedure [Claim].[usp_GetByID_ClaimProcessEDIFile]    Script Date: 07/19/2013 11:24:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Claim].[usp_GetByID_ClaimProcessEDIFile]
    @EDIFileID INT 
    , @ClinicID INT
    , @UserID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		 [PatientVisitID] BIGINT NOT NULL
		, [PatName] NVARCHAR(500) NOT NULL
		, [ChartNumber] NVARCHAR(20) NOT NULL
		, [DOS] DATE NOT NULL
		, [ClinicID] INT NOT NULL
		, [AssignToMe] BIT NOT NULL
	);
	
	INSERT INTO
		@TBL_ANS
	SELECT
		 [PatientVisit].[PatientVisitID]
		, (LTRIM(RTRIM([Patient].[Patient].[LastName] + ' ' + [Patient].[Patient].[FirstName] + ' ' + ISNULL ([Patient].[Patient].[MiddleName], '')))) AS [PatName]
		, [Patient].[ChartNumber]
		, [PatientVisit].[DOS]
		, [Patient].[ClinicID]
		, CAST('1' AS BIT) AS [AssignToMe]
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
	   	[Patient].[Patient].[ClinicID]	= @ClinicID
	AND
		[Patient].[PatientVisit].[AssignedTo] = @UserID;

	
	SELECT * FROM @TBL_ANS;
	
	-- EXEC [Claim].[usp_GetByID_ClaimProcessEDIFile] @EDIFileID  = 8052 , @ClinicID = 1, @UserID = 101
END

GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummary_PatientVisit]    Script Date: 07/19/2013 11:32:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardSummary_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetDashboardSummary_PatientVisit]    Script Date: 07/19/2013 11:32:22 ******/
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;	
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 07/19/2013 14:17:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseSummary_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseSummary_PatientVisit]    Script Date: 07/19/2013 14:17:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetAgentWiseSummary_PatientVisit]
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;	
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30 
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 1 AND 7
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) BETWEEN 8 AND 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
	
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
		([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
	AND
		DATEDIFF(DAY, [Patient].[PatientVisit].[DOS], GETDATE()) > 30
	AND
		[Patient].[PatientVisit].[IsActive] = 1
	AND
		[Patient].[Patient].[IsActive] = 1;
		
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
	
	-- EXEC [Patient].[usp_GetAgentWiseSummary_PatientVisit]  @UserID = 116
END









GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisitPdf_PatientVisit]    Script Date: 07/19/2013 16:35:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetDashboardVisitPdf_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetDashboardVisitPdf_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetDashboardVisitPdf_PatientVisit]    Script Date: 07/19/2013 16:35:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [Patient].[usp_GetDashboardVisitPdf_PatientVisit]
	@UserID INT
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
	
	SELECT * FROM @SEARCH_TMP;
	
	-- EXEC [Patient].[usp_GetDashboardVisitPdf_PatientVisit]  @UserID = 116,  @Desc = 'Rejected', @DayCount = 'ONE'
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDateClinicAll_PatientVisit]    Script Date: 07/19/2013 16:58:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDateClinicAll_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDateClinicAll_PatientVisit]
GO


----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/22/2013 14:25:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]
GO



/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/22/2013 14:25:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]	
    @UserID INT
    ,@DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
	[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
AND
	[Billing].[Clinic].[ClinicID]  IN
		(SELECT [USER].[UserClinic].[ClinicID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[UserID] = @UserID)

		
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
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC
	
	
	--EXEC [Patient].[usp_GetReportDateClinicAll_PatientVisit]  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END





GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportDateProviderWise_PatientVisit]    Script Date: 07/19/2013 16:58:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDateProviderWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDateProviderWise_PatientVisit]
GO

----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportProviderDate_PatientVisit]    Script Date: 07/22/2013 14:14:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportProviderDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportProviderDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportProviderDate_PatientVisit]    Script Date: 07/22/2013 14:14:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetReportProviderDate_PatientVisit]
   @ProviderID INT	
   , @DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
	[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Billing].[Provider].[ProviderID] = @ProviderID
		
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
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC
	
	
	--EXEC [Patient].[usp_GetReportDateProviderWise_PatientVisit] @ProviderID = 1,  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDatePatientWise_PatientVisit]    Script Date: 07/19/2013 16:59:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDatePatientWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDatePatientWise_PatientVisit]
GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportPatientDate_PatientVisit]    Script Date: 07/22/2013 14:12:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportPatientDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportPatientDate_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportPatientDate_PatientVisit]    Script Date: 07/22/2013 14:12:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetReportPatientDate_PatientVisit]
   @PatientID BIGINT	
   , @DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
		[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
	AND
		[Patient].[Patient].[PatientID] = @PatientID		
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
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC
	
	
	--EXEC [Patient].[usp_GetReportDatePatientWise_PatientVisit] @PatientID = 1,  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]    Script Date: 07/19/2013 17:13:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]    Script Date: 07/19/2013 17:13:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]
	@UserID INT
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
			
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
				([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
	------
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
	
	ELSE IF @Desc = 'Accepted' AND @DayCount = 'ALL'
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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
			([Patient].[PatientVisit].[TargetBAUserID] = @UserID OR [Patient].[PatientVisit].[TargetQAUserID] = @UserID or [Patient].[PatientVisit].[TargetEAUserID] = @UserID)
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

SELECT * FROM @SEARCH_TMP;
	
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'THIRTYPLUS'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID=116 , @Desc = 'Visits', @DayCount = 'ONE'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID=116 , @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetAgentWiseVisitPdf_PatientVisit]  @UserID = '116', @Desc = 'Visits', @DayCount = 'THIRTYPLUS', @SearchName  = 'a'
END

GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]    Script Date: 07/19/2013 17:23:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]    Script Date: 07/19/2013 17:23:52 ******/
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
			[Patient].[PatientVisit].[IsActive] = 1
		AND
			[Patient].[Patient].[IsActive] = 1;
	END
	
	SELECT * FROM @SEARCH_TMP;
	
	-- EXEC [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]  @ClinicID = 17,  @Desc = 'NIT', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetClinicWiseVisitpDF_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboard_PatientVisit]    Script Date: 07/22/2013 10:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboard_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboard_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboard_PatientVisit]    Script Date: 07/22/2013 10:03:42 ******/
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
		[Insurance].[Insurance].[IsActive] = 1
	
	
	-- EXEC [Patient].[usp_GetReportDashboard_PatientVisit]  @UserID = 1, @Desc = 'Rejected', @DayCount = 'TOTAL'
	-- EXEC [Patient].[usp_GetBySearch_PatientVisit] 
END

GO



----------------------------------------------------------------------
/****** Object:  StoredProcedure [Patient].[usp_GetReportAgentWise_PatientVisit]    Script Date: 07/22/2013 10:20:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportAgentWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportAgentWise_PatientVisit]
GO

----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 07/22/2013 12:34:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboardAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardAgent_PatientVisit]    Script Date: 07/22/2013 12:34:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportDashboardAgent_PatientVisit]
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
	
	-- EXEC [Patient].[usp_GetReportClinicWise_PatientVisit]  @ClinicID = 17,  @Desc = 'NIT', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetReportClinicWise_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportClinicWise_PatientVisit]    Script Date: 07/22/2013 10:25:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportClinicWise_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportClinicWise_PatientVisit]
GO

----------------------------------------------------------------------


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardClinic_PatientVisit]    Script Date: 07/22/2013 12:33:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDashboardClinic_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDashboardClinic_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportDashboardClinic_PatientVisit]    Script Date: 07/22/2013 12:33:47 ******/
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
	
	-- EXEC [Patient].[usp_GetReportClinicWise_PatientVisit]  @ClinicID = 17,  @Desc = 'NIT', @DayCount = 'ALL'
	-- EXEC [Patient].[usp_GetReportClinicWise_PatientVisit]  @ClinicID = 2,  @Desc = 'Visits', @DayCount = 'ALL'
	
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/22/2013 14:10:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportDate_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]
GO

/****** Object:  StoredProcedure [Patient].[usp_GetReportDate_PatientVisit]    Script Date: 07/22/2013 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [Patient].[usp_GetReportDate_PatientVisit]	
    @UserID INT
    ,@DateFrom DATE
     ,@DateTo DATE
     
     
AS
BEGIN
	SET NOCOUNT ON;
	
	
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
	[Patient].[PatientVisit].[DOS] BETWEEN @DateFrom AND @DateTo
AND
	[Billing].[Clinic].[ClinicID]  IN
		(SELECT [USER].[UserClinic].[ClinicID] FROM [User].[UserClinic] WITH (NOLOCK) WHERE [User].[UserClinic].[UserID] = @UserID)

		
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
		[Insurance].[Insurance].[IsActive] = 1
	
	ORDER BY DOS ASC
	
	
	--EXEC [Patient].[usp_GetReportDateClinicAll_PatientVisit]  @DateFrom='2012-JAN-12',@DateTo='2012-FEB-12'
	-- EXEC [Patient].[usp_GetReportDate_PatientVisit]	
END





GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCount_UserClinic]    Script Date: 07/22/2013 16:03:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCount_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCount_UserClinic]
GO


/****** Object:  StoredProcedure [User].[usp_GetCount_UserClinic]    Script Date: 07/22/2013 16:03:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [User].[usp_GetCount_UserClinic]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [USER_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
		SELECT 
			 COUNT(DISTINCT [User].[User].[UserID]) AS [USER_COUNT]
		FROM
			[User].[UserClinic]  WITH (NOLOCK)
		INNER JOIN
			[User].[User] WITH (NOLOCK)
		ON
			[User].[UserClinic].[UserID] = [User].[User].[UserID]
		WHERE
			[User].[UserClinic].[ClinicID] NOT IN (SELECT [Billing].[Clinic].[ClinicID] FROM [Billing].[Clinic] WHERE [Billing].[Clinic].[IsActive] = 1)
		AND
			[User].[UserClinic].[IsActive] = 1
		AND 
			[User].[User].[IsActive] = 1;
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetCount_UserClinic] 
	-- EXEC [User].[usp_GetCount_UserClinic] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [User].[usp_GetCount_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [User].[usp_GetCount_UserClinic] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCount_UserRole]    Script Date: 07/22/2013 16:21:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCount_UserRole]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCount_UserRole]
GO


/****** Object:  StoredProcedure [User].[usp_GetCount_UserRole]    Script Date: 07/22/2013 16:21:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [User].[usp_GetCount_UserRole]

AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [USER_ROLE_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
		COUNT (DISTINCT [User].[User].[UserID]) AS [USER_ROLE_COUNT]
	FROM
		[User].[User]  WITH (NOLOCK)
	INNER JOIN
		[User].[UserRole]  WITH (NOLOCK)
	ON 
		[User].[User].[UserID] = [User].[UserRole].[UserID]
	WHERE
		[User].[UserRole].[RoleID] NOT IN (SELECT [AccessPrivilege].[Role].[RoleID] FROM [AccessPrivilege].[Role] WHERE [AccessPrivilege].[Role].[IsActive] = 1)
	AND
		[User].[UserRole].[IsActive] = 1
	AND
		[User].[User].[IsActive] = 1;
		
		
	SELECT * FROM @TBL_ANS;
		
	-- EXEC [User].[usp_GetCount_UserRole] 
	-- EXEC [User].[usp_GetCount_UserRole] @ClinicID = 1, @StatusIDs = '8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25'	-- CREATED
	-- EXEC [User].[usp_GetCount_UserRole] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
	-- EXEC [User].[usp_GetCount_UserRole] @ClinicID = 1, @StatusIDs = '3', @AssignedTo = 101
END







GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCountManager_User]    Script Date: 07/22/2013 17:48:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCountManager_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCountManager_User]
GO

/****** Object:  StoredProcedure [User].[usp_GetCountManager_User]    Script Date: 07/22/2013 17:48:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User].[usp_GetCountManager_User] 
	@RoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [MANAGER_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
 		COUNT([User].[User].[UserID]) AS [MANAGER_COUNT]
 	FROM 
 		[User].[User]  WITH (NOLOCK)
 	WHERE
 		[User].[User].[UserID] IN (SELECT [UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] = @RoleID AND [User].[UserRole].[IsActive] = 1)
 	AND
 		[User].[User].[UserID] NOT IN 
 	(
		SELECT 
			DISTINCT [User].[User].[ManagerID]
		FROM
			[User].[User]
		WHERE
			[User].[User].[ManagerID] IS NOT NULL
	)
	AND
		[User].[User].[IsActive] = 1;

	SELECT * FROM @TBL_ANS;
			
	-- EXEC [User].[usp_GetCountManager_User] NULL
	-- EXEC [User].[usp_GetCountManager_User] 2
	-- EXEC [User].[usp_GetCountManager_User] 0
END




GO



----------------------------------------------------------------------


/****** Object:  StoredProcedure [User].[usp_GetCountManager_UserClinic]    Script Date: 07/22/2013 18:27:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCountManager_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCountManager_UserClinic]
GO


----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetCountClinic_UserClinic]    Script Date: 07/23/2013 10:06:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetCountClinic_UserClinic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetCountClinic_UserClinic]
GO


/****** Object:  StoredProcedure [User].[usp_GetCountClinic_UserClinic]    Script Date: 07/23/2013 10:06:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [User].[usp_GetCountClinic_UserClinic] 
	@RoleID TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TBL_ANS TABLE
	(
		[ID] INT NOT NULL IDENTITY (1, 1)
		, [CLINIC_COUNT] INT NOT NULL
	);

	INSERT INTO
		@TBL_ANS
	SELECT 
 		COUNT(DISTINCT [User].[User].[UserID]) AS [CLINIC_COUNT]
 	FROM 
 		[User].[User]  WITH (NOLOCK)
 	WHERE
 		[User].[User].[UserID] IN (SELECT [UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] = @RoleID AND [User].[UserRole].[IsActive] = 1)
 	AND
 		[User].[User].[UserID] NOT IN 
 	(
		SELECT 
			DISTINCT [User].[UserClinic].[UserID]
		FROM
			[User].[UserClinic]
		WHERE
			[User].[User].[UserID] IN (SELECT [UserID] FROM [User].[UserRole] WHERE [User].[UserRole].[RoleID] = @RoleID AND [User].[UserRole].[IsActive] = 1)
	)
	AND
		[User].[User].[IsActive] = 1;

	SELECT * FROM @TBL_ANS;
			
	-- EXEC [User].[usp_GetCountClinic_UserClinic] NULL
	-- EXEC [User].[usp_GetCountClinic_UserClinic] 2
	-- EXEC [User].[usp_GetCountClinic_UserClinic] 0
END






GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetReportAgent_User]    Script Date: 07/22/2013 19:03:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetReportAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetReportAgent_User]
GO


/****** Object:  StoredProcedure [User].[usp_GetReportAgent_User]    Script Date: 07/22/2013 19:03:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [User].[usp_GetReportAgent_User]
	@UserID		INT
, @StartBy NVARCHAR(1) = NULL
	
AS
BEGIN-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @StartBy IS NULL
	BEGIN
		SET @StartBy = '';
	END
    
    SELECT DISTINCT
		[User].[User].[UserID]
		, (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) as Name
		
	FROM
		[User].[User] 
	INNER JOIN
	
	[User].[UserRole]	
	
	ON
	[User].[UserRole].[UserID]=[User].[User].[UserID] 
		
	INNER JOIN 
		[AccessPrivilege].[Role]
	ON
		[User].[UserRole].[RoleID]=[AccessPrivilege].[Role].[RoleID]
	INNER JOIN
	
	[User].[UserClinic]	
	
	ON
	[User].[UserClinic].[UserID]=[User].[User].[UserID]
	
	WHERE
	
	 [User].[UserClinic].[ClinicID]
	 
	 IN
	 (
	 SELECT 
	   [User].[UserClinic].[ClinicID] 
	 FROM
	    [User].[UserClinic]
	 WHERE
	     [User].[UserClinic].[UserID] =@UserID   
	     
	 )
	 AND
	 
	 (LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], ''))))
	LIKE 
		@StartBy + '%'
	 
	 AND
	 
	 [AccessPrivilege].[Role].[RoleID] <> 1
	    
		
	
	-- EXEC [User].[usp_GetBySearchReports_User] @UserID = 103 
END




GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [User].[usp_GetReportAZAgent_User]    Script Date: 07/22/2013 19:07:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[User].[usp_GetReportAZAgent_User]') AND type in (N'P', N'PC'))
DROP PROCEDURE [User].[usp_GetReportAZAgent_User]
GO



/****** Object:  StoredProcedure [User].[usp_GetReportAZAgent_User]    Script Date: 07/22/2013 19:07:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [User].[usp_GetReportAZAgent_User] 

	@UserID		INT
	

AS
BEGIN
	
	SET NOCOUNT ON;
    
    DECLARE @TBL_ALL TABLE
    (
		[Name] [nvarchar](40) NULL
    );
    
    DECLARE @TBL_AZ TABLE
    (
		[AZ] [varchar](1) PRIMARY KEY NOT NULL,
		[AZ_COUNT] INT NOT NULL
    );
   
    INSERT INTO
		@TBL_ALL
	 SELECT DISTINCT
		(LTRIM(RTRIM([User].[User].[LastName] + ' ' + [User].[User].[FirstName] + ' ' + ISNULL ([User].[User].[MiddleName], '')))) 
	FROM
		[User].[User] 
	INNER JOIN
	
	[User].[UserRole]	
	
	ON
	[User].[UserRole].[UserID]=[User].[User].[UserID] 
		
	INNER JOIN 
		[AccessPrivilege].[Role]
	ON
		[User].[UserRole].[RoleID]=[AccessPrivilege].[Role].[RoleID]
	INNER JOIN
	
	[User].[UserClinic]	
	
	ON
	[User].[UserClinic].[UserID]=[User].[User].[UserID]
	
	WHERE
	
	 [User].[UserClinic].[ClinicID]
	 
	 IN
	 (
	 SELECT 
	   [User].[UserClinic].[ClinicID] 
	 FROM
	    [User].[UserClinic]
	 WHERE
	     [User].[UserClinic].[UserID] =@UserID   
	     
	 )
	 
	 AND
	 
	 [AccessPrivilege].[Role].[RoleID] <> 1
	    
		
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
			[Name] LIKE @AZ_CHR + '%';
	
		SELECT @AZ_LOOP = @AZ_LOOP + 1;
	END
	
	SELECT * FROM @TBL_AZ ORDER BY 1 ASC;
	
	-- EXEC [User].[usp_GetByAZReports_User] 48
END



GO



----------------------------------------------------------------------

/****** Object:  StoredProcedure [Patient].[usp_GetReportAgent_PatientVisit]    Script Date: 07/23/2013 10:37:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Patient].[usp_GetReportAgent_PatientVisit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Patient].[usp_GetReportAgent_PatientVisit]
GO


/****** Object:  StoredProcedure [Patient].[usp_GetReportAgent_PatientVisit]    Script Date: 07/23/2013 10:37:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Patient].[usp_GetReportAgent_PatientVisit]	
     @UserID INT	
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
		SELECT [Claim].[ClaimProcess].[PatientVisitID] FROM [Claim].[ClaimProcess]
		WHERE [Claim].[ClaimProcess].[CreatedBy] = @UserID
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
	
	
	--EXEC [Patient].[usp_GetReport_PatientVisit]  @UserID = 1
END


GO



----------------------------------------------------------------------
