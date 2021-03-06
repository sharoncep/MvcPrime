USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Insurance].[usp_GetBySearch_Relationship]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Insurance].[usp_GetBySearch_Relationship]
GO
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
	SELECT
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
