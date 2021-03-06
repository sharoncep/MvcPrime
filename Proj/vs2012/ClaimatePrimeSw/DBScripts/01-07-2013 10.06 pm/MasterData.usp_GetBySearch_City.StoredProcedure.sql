USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [MasterData].[usp_GetBySearch_City]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [MasterData].[usp_GetBySearch_City]
GO
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
	SELECT
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
		[MasterData].[City]
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
