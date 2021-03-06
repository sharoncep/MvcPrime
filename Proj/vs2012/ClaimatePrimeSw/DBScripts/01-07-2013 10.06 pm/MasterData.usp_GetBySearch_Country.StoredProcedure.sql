USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_Country]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetBySearch_Country]
GO
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
	SELECT
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
