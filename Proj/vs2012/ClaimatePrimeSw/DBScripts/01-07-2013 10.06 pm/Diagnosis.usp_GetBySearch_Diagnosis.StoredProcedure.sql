USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_Diagnosis]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_Diagnosis]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_Diagnosis]
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
		[Diagnosis].[Diagnosis].[DiagnosisID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'Description' AND @OrderByDirection = 'A' THEN ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC'))))  END ASC,
				CASE WHEN @orderByField = 'Description' AND @orderByDirection = 'D' THEN ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) END DESC,
						
				CASE WHEN @OrderByField = 'DiagnosisCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[DiagnosisCode] END ASC,
				CASE WHEN @orderByField = 'DiagnosisCode' AND @orderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[DiagnosisCode] END DESC,
				
				CASE WHEN @OrderByField = 'ICDFormat' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[ICDFormat] END ASC,
				CASE WHEN @orderByField = 'ICDFormat' AND @orderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[ICDFormat] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[Diagnosis].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[Diagnosis].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[Diagnosis]
	WHERE
	
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC'))))  LIKE @StartBy + '%' 
		
		    
	AND
	(
		ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[Diagnosis].[DiagnosisCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[Diagnosis].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[Diagnosis].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[Diagnosis].[DiagnosisID]
	  , [Diagnosis].[DiagnosisCode]
	  , ISNULL([Diagnosis].[Diagnosis].[ShortDesc],ISNULL([Diagnosis].[Diagnosis].[LongDesc],ISNULL([Diagnosis].[Diagnosis].[CustomDesc],ISNULL([Diagnosis].[Diagnosis].[MediumDesc],'NO DESC')))) as Description
	  ,[Diagnosis].[ICDFormat],[Diagnosis].[IsActive]
	FROM
		[Diagnosis] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [Diagnosis].[DiagnosisID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_Diagnosis] @SearchName  = '36'
	-- EXEC [Diagnosis].[usp_GetBySearch_Diagnosis] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
