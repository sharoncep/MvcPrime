USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintSign]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetBySearch_PrintSign]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetBySearch_PrintSign]
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
		[EDI].[PrintSign].[PrintSignID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PrintSignName' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[PrintSignName] END ASC,
				CASE WHEN @orderByField = 'PrintSignName' AND @orderByDirection = 'D' THEN [EDI].[PrintSign].[PrintSignName] END DESC,
				
				CASE WHEN @OrderByField = 'PrintSignCode' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[PrintSignCode] END ASC,
				CASE WHEN @orderByField = 'PrintSignCode' AND @orderByDirection = 'D' THEN [EDI].[PrintSign].[PrintSignCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[PrintSign].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[PrintSign].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[PrintSign]
	WHERE
		[EDI].[PrintSign].[PrintSignName] LIKE @StartBy + '%' 
	AND
	(
		[EDI].[PrintSign].[PrintSignName] LIKE '%' + @SearchName + '%' 
	OR
		[EDI].[PrintSign].[PrintSignCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[EDI].[PrintSign].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintSign].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[PrintSign].[PrintSignID], [PrintSign].[PrintSignCode], [PrintSign].[PrintSignName], [PrintSign].[IsActive]
	FROM
		[PrintSign] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PrintSign].[PrintSignID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [EDI].[usp_GetBySearch_PrintSign] @SearchName  = '45'
	-- EXEC [EDI].[usp_GetBySearch_PrintSign] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
