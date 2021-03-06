USE [DEV_ClaimatePrimeHMO]
GO
/****** Object:  StoredProcedure [Diagnosis].[usp_GetBySearch_DiagnosisGroup]    Script Date: 07/01/2013 22:06:40 ******/
DROP PROCEDURE [Diagnosis].[usp_GetBySearch_DiagnosisGroup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Diagnosis].[usp_GetBySearch_DiagnosisGroup]
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
		[DiagnosisGroup].[DiagnosisGroupID]
		, ROW_NUMBER() OVER (
			ORDER BY
						
				CASE WHEN @OrderByField = 'DiagnosisGroupDescription' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] END ASC,
				CASE WHEN @orderByField = 'DiagnosisGroupDescription' AND @orderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] END DESC,
						
				CASE WHEN @OrderByField = 'DiagnosisGroupCode' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] END ASC,
				CASE WHEN @orderByField = 'DiagnosisGroupCode' AND @orderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] END DESC,
				
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'A' THEN [Diagnosis].[DiagnosisGroup].[LastModifiedOn] END ASC,
				CASE WHEN @OrderByField = 'LastModifiedOn' AND @OrderByDirection = 'D' THEN [Diagnosis].[DiagnosisGroup].[LastModifiedOn] END DESC
				
			) AS ROW_NUM
	FROM
		[Diagnosis].[DiagnosisGroup]
	WHERE
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] LIKE @StartBy + '%' 
	AND
	(
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupDescription] LIKE '%' + @SearchName + '%' 
	OR
		[Diagnosis].[DiagnosisGroup].[DiagnosisGroupCode] LIKE '%' + @SearchName + '%' 
	)
	AND
		[Diagnosis].[DiagnosisGroup].[IsActive] = CASE WHEN @IsActive IS NULL THEN [Diagnosis].[DiagnosisGroup].[IsActive] ELSE @IsActive END;
		
	DECLARE @FIRST_ROW_NUM BIGINT;
	DECLARE @LAST_ROW_NUM BIGINT;
	DECLARE @REC_CNT BIGINT;
	
	SET @FIRST_ROW_NUM = ((@CurrPageNumber * @RecordsPerPage) - @RecordsPerPage) + 1;
	SET @LAST_ROW_NUM = (@FIRST_ROW_NUM + @RecordsPerPage) - 1;
	SELECT @REC_CNT = COUNT([ID]) FROM @SEARCH_TMP;
	
	SELECT
		[DiagnosisGroup].[DiagnosisGroupID], [DiagnosisGroup].[DiagnosisGroupCode], [DiagnosisGroup].[DiagnosisGroupDescription], [DiagnosisGroup].[IsActive]
	FROM
		[DiagnosisGroup] WITH (NOLOCK)
	INNER JOIN
		@SEARCH_TMP
	ON
		[PK_ID] = [DiagnosisGroup].[DiagnosisGroupID]
	WHERE
		[ROW_NUM] BETWEEN @FIRST_ROW_NUM AND @LAST_ROW_NUM
	ORDER BY
		[ID]
	ASC;
	
	-- EXEC [Diagnosis].[usp_GetBySearch_DiagnosisGroup] @SearchName  = '36'
	-- EXEC [Diagnosis].[usp_GetBySearch_DiagnosisGroup] @SearchName  = NULL, @StartBy = NULL, @IsActive = NULL, @CurrPageNumber = 1, @RecordsPerPage = 200, @OrderByField = 'LastModifiedOn', @OrderByDirection = 'D'
END
GO
