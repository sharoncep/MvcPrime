USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]    Script Date: 07/01/2013 22:06:41 ******/
DROP PROCEDURE [Transaction].[usp_GetBySearch_TransactionSetPurposeCode]
GO
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
	SELECT
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
