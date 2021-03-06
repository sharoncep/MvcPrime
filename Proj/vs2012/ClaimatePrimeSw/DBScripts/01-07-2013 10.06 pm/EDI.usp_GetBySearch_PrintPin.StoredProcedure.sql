USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [EDI].[usp_GetBySearch_PrintPin]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [EDI].[usp_GetBySearch_PrintPin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [EDI].[usp_GetBySearch_PrintPin]
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
		[EDI].[PrintPin].[PrintPinID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'PrintPinName' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[PrintPinName] END ASC,
				CASE WHEN @orderByField = 'PrintPinName' AND @orderByDirection = 'D' THEN [EDI].[PrintPin].[PrintPinName] END DESC,
				
				CASE WHEN @OrderByField = 'PrintPinCode' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[PrintPinCode] END ASC,
				CASE WHEN @orderByField = 'PrintPinCode' AND @orderByDirection = 'D' THEN [EDI].[PrintPin].[PrintPinCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [EDI].[PrintPin].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [EDI].[PrintPin].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[EDI].[PrintPin]
	WHERE
		[EDI].[PrintPin].[PrintPinName] LIKE @StartBy + '%' 
	AND
	(
		[EDI].[PrintPin].[PrintPinName] LIKE '%' + @SearchName + '%' 
	OR
		[EDI].[PrintPin].[PrintPinCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[EDI].[PrintPin].[IsActive] = CASE WHEN @IsActive IS NULL THEN [EDI].[PrintPin].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[PrintPin].[PrintPinID], [PrintPin].[PrintPinCode], [PrintPin].[PrintPinName], [PrintPin].[IsActive]
	FROM
		[PrintPin] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [PrintPin].[PrintPinID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [EDI].[usp_GetBySearch_PrintPin] @SearchName  = '45'
	-- EXEC [EDI].[usp_GetBySearch_PrintPin] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
