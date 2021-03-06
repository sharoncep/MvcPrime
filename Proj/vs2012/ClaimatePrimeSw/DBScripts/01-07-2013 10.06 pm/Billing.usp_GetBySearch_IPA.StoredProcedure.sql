USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Billing].[usp_GetBySearch_IPA]    Script Date: 07/01/2013 22:06:39 ******/
DROP PROCEDURE [Billing].[usp_GetBySearch_IPA]
GO
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
	SELECT
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
