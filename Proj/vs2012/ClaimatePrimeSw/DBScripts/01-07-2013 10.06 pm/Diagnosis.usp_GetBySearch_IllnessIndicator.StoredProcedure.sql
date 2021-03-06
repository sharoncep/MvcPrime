USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_IllnessIndicator]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_IllnessIndicator]
GO
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
	SELECT
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
