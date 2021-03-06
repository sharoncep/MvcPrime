USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Provider]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_Provider]
GO
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
