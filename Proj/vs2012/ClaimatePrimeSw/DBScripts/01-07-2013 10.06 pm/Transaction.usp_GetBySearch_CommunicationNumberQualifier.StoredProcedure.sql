USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetBySearch_CommunicationNumberQualifier]
GO
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
	SELECT
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
