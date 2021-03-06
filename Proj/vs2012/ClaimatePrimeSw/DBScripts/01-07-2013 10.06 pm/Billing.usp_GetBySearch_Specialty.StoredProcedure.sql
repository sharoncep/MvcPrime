USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_Specialty]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_Specialty]
GO
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
	SELECT
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
