USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_EDIFile]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetBySearch_EDIFile]
	@ClinicID	INT
	, @DateFrom DATE = NULL
	, @DateTo DATE = NULL
	, @OrderByField NVARCHAR(250) = 'LastModifiedOn'
	, @OrderByDirection	NVARCHAR(1) = 'D'
	, @IsActive BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF @DateFrom IS NULL
	BEGIN
		SELECT @DateFrom = CAST('1900-01-01' AS DATE);
	END
	
	IF @DateTo IS NULL
	BEGIN
		SELECT @DateTo = DATEADD(MONTH, 1, GETDATE());
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
		[EDI].[EDIFile]	
	WHERE	
		[EDI].[EDIFile].[CreatedOn] BETWEEN @DateFrom AND @DateTo
	AND
		[EDI].[EDIFile].[EDIFileID] IN
		(
			SELECT
				[Claim].[ClaimProcessEDIFile].[EDIFileID]
			FROM
				[Claim].[ClaimProcessEDIFile]
			INNER JOIN
				[Claim].[ClaimProcess]
			ON
				[Claim].[ClaimProcess].[ClaimProcessID] = [Claim].[ClaimProcessEDIFile].[ClaimProcessID]
			INNER JOIN
				[Patient].[PatientVisit]
			ON
				[Patient].[PatientVisit].[PatientVisitID] = [Claim].[ClaimProcess].[PatientVisitID]
			INNER JOIN
				[Patient].[Patient]
			ON
				[Patient].[Patient].[PatientID] = [Patient].[PatientVisit].[PatientID]
			WHERE
				[Patient].[Patient].[ClinicID] = @ClinicID
		)
	AND
		[EDI].[EDIFile].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[EDIFile].[IsActive] ELSE @IsActive END
	ORDER BY
		[EDIFile].[LastModifiedOn]
	DESC;	
		
	DECLARE @TBL_RES TABLE
	(
	    [EDIFileID] INT NOT NULL
		, [X12FileRelPath] NVARCHAR(255) NOT NULL
		, [RefFileRelPath] NVARCHAR(255) NOT NULL
		, [CreatedOn] DATETIME  NOT NULL		
	);

	INSERT INTO
		@TBL_RES
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
		[PK_ID] = [EDIFile].[EDIFileID]		
	ORDER BY
		[ID]
	ASC;
		
	SELECT * FROM @TBL_RES;
	
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @DateFrom 
	-- EXEC [EDI].[usp_GetBySearch_EDIFile] @ClinicTypeID = 2, @ChartNumber  = NULL, @StartBy = NULL, @EDIID = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
